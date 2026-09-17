#!/usr/bin/env python3
"""Convert a square underside photo into a compact OpenSCAD demo projection."""

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path


def grayscale_pixels(image: Path, size: int, trim: bool = False) -> list[list[int]]:
    command = [
        "magick",
        str(image),
        "-auto-orient",
    ]
    if trim:
        command.extend(["-trim", "+repage"])
    command.extend([
        "-resize",
        f"{size}x{size}!",
        "-colorspace",
        "Gray",
        "-dither",
        "None",
        "-posterize",
        "16",
        "-depth",
        "8",
        "gray:-",
    ])
    pixels = subprocess.run(command, check=True, capture_output=True).stdout
    expected = size * size
    if len(pixels) != expected:
        raise RuntimeError(f"Expected {expected} pixels, received {len(pixels)}")

    return [list(pixels[row * size : (row + 1) * size]) for row in range(size)]


def merged_rectangles(rows: list[list[int]]) -> list[tuple[int, int, int, int, int]]:
    """Merge identical horizontal runs vertically when their spans also match."""
    finished: list[tuple[int, int, int, int, int]] = []
    active: dict[tuple[int, int, int], list[int]] = {}

    for row_index, row in enumerate(rows):
        runs: list[tuple[int, int, int]] = []
        start = 0
        for column in range(1, len(row) + 1):
            if column == len(row) or row[column] != row[start]:
                runs.append((start, column - start, row[start]))
                start = column

        next_active: dict[tuple[int, int, int], list[int]] = {}
        for column, width, shade in runs:
            key = (column, width, shade)
            if key in active:
                rectangle = active.pop(key)
                rectangle[3] += 1
            else:
                rectangle = [row_index, column, width, 1, shade]
            next_active[key] = rectangle

        finished.extend(tuple(rectangle) for rectangle in active.values())
        active = next_active

    finished.extend(tuple(rectangle) for rectangle in active.values())
    return sorted(finished)


def write_projection(
    output: Path,
    source_name: str,
    prefix: str,
    size: int,
    rectangles: list[tuple[int, int, int, int, int]],
) -> None:
    array_name = f"{prefix}_projection_rectangles"
    size_name = f"{prefix}_projection_size"
    module_name = f"{prefix}_bottom_projection"

    lines = [
        "/*",
        f" * Demo-only pixel projection generated from {source_name}.",
        " * Rows are stored top-to-bottom; the module flips them so the photograph's",
        " * bottom edge maps to Y=0, the physical front of the device.",
        " * Adjacent equal-shade pixels are merged into rectangles for faster previews.",
        " */",
        "",
        f"{size_name} = {size};",
        f"{array_name} = [",
    ]
    lines.extend(
        f"    [{row}, {column}, {width}, {height}, {shade}],"
        for row, column, width, height, shade in rectangles[:-1]
    )
    if rectangles:
        row, column, width, height, shade = rectangles[-1]
        lines.append(f"    [{row}, {column}, {width}, {height}, {shade}]")
    lines.extend(
        [
            "];",
            "",
            f"module {module_name}(width = 150, depth = 150, thickness = 0.05) {{",
            f"    pixel_x = width / {size_name};",
            f"    pixel_y = depth / {size_name};",
            "",
            f"    for (rect = {array_name}) {{",
            "        shade = rect[4] / 255;",
            "        color([shade, shade, shade])",
            "            translate([rect[1] * pixel_x,",
            f"                       ({size_name} - rect[0] - rect[3]) * pixel_y,",
            "                       -thickness])",
            "                cube([rect[2] * pixel_x + 0.01,",
            "                      rect[3] * pixel_y + 0.01,",
            "                      thickness]);",
            "    }",
            "}",
            "",
        ]
    )
    output.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("image", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("prefix")
    parser.add_argument("--size", type=int, default=160)
    parser.add_argument("--trim", action="store_true")
    args = parser.parse_args()

    rows = grayscale_pixels(args.image, args.size, args.trim)
    rectangles = merged_rectangles(rows)
    write_projection(
        args.output, args.image.name, args.prefix, args.size, rectangles
    )


if __name__ == "__main__":
    main()
