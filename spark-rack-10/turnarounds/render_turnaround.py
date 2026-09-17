#!/usr/bin/env python3
"""Build and render a centered 360-degree STL turnaround in Blender.

Run through Blender, for example:
    blender --background --python render_turnaround.py -- \
        --input model.stl --output model_horizontal.mp4 --axis horizontal
"""

from __future__ import annotations

import argparse
import math
import subprocess
import sys
import tempfile
from pathlib import Path

import bpy
from mathutils import Vector


def parse_args() -> argparse.Namespace:
    argv = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else []
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--axis", choices=("horizontal", "vertical"), required=True
    )
    parser.add_argument("--frames", type=int, default=180)
    parser.add_argument("--fps", type=int, default=30)
    parser.add_argument("--resolution-x", type=int, default=1280)
    parser.add_argument("--resolution-y", type=int, default=720)
    parser.add_argument(
        "--preview-only",
        action="store_true",
        help="Render only a representative PNG while still saving the .blend file.",
    )
    parser.add_argument(
        "--preview-frame",
        type=int,
        help="Frame used for the preview PNG (defaults to one eighth-turn).",
    )
    return parser.parse_args(argv)


def clear_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for datablocks in (bpy.data.meshes, bpy.data.curves, bpy.data.materials,
                       bpy.data.cameras, bpy.data.lights):
        for block in list(datablocks):
            if block.users == 0:
                datablocks.remove(block)


def import_stl(path: Path) -> bpy.types.Object:
    before = set(bpy.context.scene.objects)
    if hasattr(bpy.ops.wm, "stl_import"):
        bpy.ops.wm.stl_import(filepath=str(path))
    else:
        bpy.ops.import_mesh.stl(filepath=str(path))

    imported = [
        obj for obj in bpy.context.scene.objects
        if obj not in before and obj.type == "MESH"
    ]
    if not imported:
        raise RuntimeError(f"No mesh was imported from {path}")

    bpy.ops.object.select_all(action="DESELECT")
    for obj in imported:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = imported[0]
    if len(imported) > 1:
        bpy.ops.object.join()
    obj = bpy.context.view_layer.objects.active
    obj.name = path.stem
    return obj


def center_and_normalize(obj: bpy.types.Object) -> tuple[Vector, float]:
    bpy.context.view_layer.update()
    corners = [obj.matrix_world @ Vector(corner) for corner in obj.bound_box]
    lower = Vector(tuple(min(p[i] for p in corners) for i in range(3)))
    upper = Vector(tuple(max(p[i] for p in corners) for i in range(3)))
    original_dimensions = upper - lower
    center = (lower + upper) / 2.0
    scale = 4.0 / max(original_dimensions)

    obj.scale = (scale, scale, scale)
    obj.location = -center * scale
    bpy.context.view_layer.update()

    # Apply the normalized transform so the rotation driver's origin is exact.
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)

    radius = max(vertex.co.length for vertex in obj.data.vertices)
    obj["source_dimensions_mm"] = tuple(round(v, 4) for v in original_dimensions)
    obj["normalization_scale"] = scale
    return original_dimensions, radius


def assign_material(obj: bpy.types.Object) -> None:
    material = bpy.data.materials.new("Matte translucent printed plastic")
    material.use_nodes = True
    principled = material.node_tree.nodes.get("Principled BSDF")
    principled.inputs["Base Color"].default_value = (0.055, 0.19, 0.34, 0.9)
    principled.inputs["Metallic"].default_value = 0.0
    principled.inputs["Roughness"].default_value = 0.62
    principled.inputs["Specular IOR Level"].default_value = 0.28
    principled.inputs["Coat Weight"].default_value = 0.0
    principled.inputs["Alpha"].default_value = 0.9
    material.diffuse_color = (0.055, 0.19, 0.34, 0.9)
    if hasattr(material, "surface_render_method"):
        # Dithered transparency avoids the per-triangle sorting artifacts that
        # alpha blending creates on triangulated STL surfaces.
        material.surface_render_method = "DITHERED"
    else:
        material.blend_method = "HASHED"
    material.use_transparent_shadow = True
    material["opacity"] = 0.9
    obj.data.materials.clear()
    obj.data.materials.append(material)


def look_at(obj: bpy.types.Object, target: Vector = Vector((0, 0, 0))) -> None:
    obj.rotation_euler = (target - obj.location).to_track_quat("-Z", "Y").to_euler()


def add_area_light(
    name: str,
    location: tuple[float, float, float],
    energy: float,
    size: float,
    color: tuple[float, float, float],
) -> None:
    data = bpy.data.lights.new(name, type="AREA")
    data.energy = energy
    data.shape = "DISK"
    data.size = size
    data.color = color
    light = bpy.data.objects.new(name, data)
    bpy.context.collection.objects.link(light)
    light.location = location
    look_at(light)


def build_studio(scene: bpy.types.Scene, radius: float) -> None:
    world = bpy.data.worlds.new("Turnaround World") if not scene.world else scene.world
    scene.world = world
    world.use_nodes = True
    background = world.node_tree.nodes.get("Background")
    background.inputs["Color"].default_value = (0.006, 0.009, 0.016, 1.0)
    background.inputs["Strength"].default_value = 0.24

    add_area_light(
        "Key",
        (-radius * 2.7, -radius * 3.1, radius * 2.9),
        1150,
        radius * 2.4,
        (1.0, 0.88, 0.76),
    )
    add_area_light(
        "Fill",
        (radius * 3.0, -radius * 2.0, radius * 0.7),
        780,
        radius * 2.7,
        (0.70, 0.83, 1.0),
    )
    add_area_light(
        "Rim",
        (radius * 1.2, radius * 2.8, radius * 2.1),
        1250,
        radius * 2.0,
        (0.55, 0.74, 1.0),
    )


def add_camera(
    scene: bpy.types.Scene,
    radius: float,
    dimensions: Vector,
    axis: str,
) -> bpy.types.Object:
    data = bpy.data.cameras.new("Turnaround Camera")
    data.lens = 58
    camera = bpy.data.objects.new("Turnaround Camera", data)
    bpy.context.collection.objects.link(camera)
    scene.camera = camera

    # Fit the swept volume for this particular rotation. Unlike a generic
    # bounding sphere, this keeps wide, shallow rack parts large in frame.
    bpy.context.view_layer.update()
    if axis == "horizontal":
        half_width = math.hypot(dimensions.x, dimensions.y) / 2.0
        half_height = dimensions.z / 2.0
    else:
        half_width = dimensions.x / 2.0
        half_height = math.hypot(dimensions.y, dimensions.z) / 2.0
    fit_margin = 1.12 if axis == "horizontal" else 1.36
    distance = max(
        half_width / math.sin(data.angle_x / 2.0),
        half_height / math.sin(data.angle_y / 2.0),
    ) * fit_margin
    camera.location = (0.0, -distance, 0.0)
    data.clip_start = max(0.01, distance - radius * 2.5)
    data.clip_end = distance + radius * 4.0
    look_at(camera)
    return camera


def add_rotation_driver(obj: bpy.types.Object, axis: str, frames: int) -> None:
    pivot = bpy.data.objects.new("Turntable Pivot", None)
    bpy.context.collection.objects.link(pivot)
    obj.parent = pivot
    obj.matrix_parent_inverse = pivot.matrix_world.inverted()
    pivot.rotation_mode = "XYZ"
    axis_index = 2 if axis == "horizontal" else 0
    fcurve = pivot.driver_add("rotation_euler", axis_index)
    fcurve.driver.type = "SCRIPTED"
    fcurve.driver.expression = f"6.283185307179586*(frame-1)/{frames}"
    pivot["rotation_axis"] = "Z" if axis == "horizontal" else "X"
    pivot["description"] = (
        "Horizontal orbit (rotation about Z)" if axis == "horizontal"
        else "Vertical orbit (rotation about X)"
    )


def configure_render(scene: bpy.types.Scene, args: argparse.Namespace) -> None:
    try:
        scene.render.engine = "BLENDER_EEVEE_NEXT"
    except TypeError:
        scene.render.engine = "BLENDER_EEVEE"

    if hasattr(scene, "eevee"):
        # Extra temporal samples smooth the dithered 90% opacity and prevent
        # visible transparency noise from changing between animation frames.
        scene.eevee.taa_render_samples = 128

    scene.render.resolution_x = args.resolution_x
    scene.render.resolution_y = args.resolution_y
    scene.render.resolution_percentage = 100
    scene.render.fps = args.fps
    scene.frame_start = 1
    scene.frame_end = args.frames
    scene.render.film_transparent = False

    # This Blender build omits its internal FFmpeg writer, so animation frames
    # are rendered losslessly and assembled with the system FFmpeg below.
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGB"

    scene.view_settings.look = "AgX - Medium High Contrast"


def render_preview(scene: bpy.types.Scene, path: Path, frame: int) -> None:
    original_path = scene.render.filepath
    scene.frame_set(frame)
    scene.render.filepath = str(path)
    bpy.ops.render.render(write_still=True)
    scene.render.filepath = original_path


def render_animation(
    scene: bpy.types.Scene, output: Path, frames: int, fps: int
) -> None:
    with tempfile.TemporaryDirectory(
        prefix=f".{output.stem}_frames_", dir=output.parent
    ) as frame_dir:
        scene.render.filepath = str(Path(frame_dir) / "frame_")
        scene.frame_set(1)
        bpy.ops.render.render(animation=True)
        subprocess.run(
            [
                "/opt/homebrew/bin/ffmpeg",
                "-y",
                "-hide_banner",
                "-loglevel",
                "warning",
                "-framerate",
                str(fps),
                "-start_number",
                "1",
                "-i",
                str(Path(frame_dir) / "frame_%04d.png"),
                "-frames:v",
                str(frames),
                "-c:v",
                "libx264",
                "-preset",
                "medium",
                "-crf",
                "18",
                "-pix_fmt",
                "yuv420p",
                "-movflags",
                "+faststart",
                str(output),
            ],
            check=True,
        )


def main() -> None:
    args = parse_args()
    args.input = args.input.resolve()
    args.output = args.output.resolve()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    clear_scene()
    scene = bpy.context.scene
    obj = import_stl(args.input)
    dimensions, radius = center_and_normalize(obj)
    assign_material(obj)
    add_rotation_driver(obj, args.axis, args.frames)
    build_studio(scene, radius)
    add_camera(scene, radius, obj.dimensions.copy(), args.axis)
    configure_render(scene, args)

    scene["source_stl"] = str(args.input)
    scene["source_dimensions_mm"] = tuple(round(v, 4) for v in dimensions)
    scene["turnaround_axis"] = args.axis
    scene["duration_seconds"] = args.frames / args.fps

    blend_path = args.output.with_suffix(".blend")
    bpy.ops.wm.save_as_mainfile(filepath=str(blend_path))

    preview_path = args.output.with_name(args.output.stem + "_preview.png")
    preview_frame = (
        args.preview_frame
        if args.preview_frame is not None
        else max(1, args.frames // 8)
    )
    render_preview(scene, preview_path, preview_frame)
    if not args.preview_only:
        render_animation(scene, args.output, args.frames, args.fps)

    print(f"SOURCE_DIMENSIONS_MM={tuple(round(v, 3) for v in dimensions)}")
    print(f"BLEND={blend_path}")
    print(f"PREVIEW={preview_path}")
    if not args.preview_only:
        print(f"VIDEO={args.output}")


if __name__ == "__main__":
    main()
