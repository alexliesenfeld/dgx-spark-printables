# GIGABYTE AI TOP ATOM under-table mount

This is a parametric OpenSCAD project for mounting a GIGABYTE AI TOP ATOM
(DGX Spark-class system) beneath a table.

Device envelope: **150 mm wide × 150 mm deep × 50.5 mm high**.

The mount now consists of **three independent printable components**: a left
side mount, a right side mount, and a loose ventilated bottom plate. Nothing in
the plate bridges or joins the two side mounts.

The loose plate is exactly **151 × 150 × 3 mm**: the 150 mm device width plus
1 mm total wiggle room, centered as 0.5 mm per side. In the assembled view it
occupies approximately X=5.01–156.01 mm and Y=0–150 mm inside the **151.02 ×
151 mm** device pocket. Each side mount has a continuous **3.5 mm inward × 5 mm
thick** support lip running from front to rear beneath the plate. Its inward
edge follows the nominal widened front-cutout boundary but deliberately keeps a
square inner docking corner rather than inheriting the plate's 2 mm open-edge
radius. Two
**31 mm inward × 5 mm thick** lower support fields remain over this continuous
layout, extending approximately 30.99 mm beneath each plate edge. Rather than
using generic rounded rectangles, each field is intersected with the exact
bottom-plate outline. The front field follows the plate from Y=12–50 mm around
its 24 mm solid core at Y=19–43 mm. The rear field follows Y=94.5–142.5 mm
around its 34 mm solid core at Y=101.5–135.5 mm. Their curved transitions
therefore coincide exactly with the adjacent plate cutouts when viewed from
below. The two free inward-pointing corners of every wide support field have a
**5 mm radius**; the narrow front/rear docking tabs remain unchanged. A middle
support rib connects the front and rear fields beneath each
plate side rim. It is 11 mm inward along the center cutouts' straight edges and
flares through their exact 7 mm end arcs, keeping the entire underside profile
aligned. Behind the rear field, an 11 mm support tail continues to the physical
back edge with the same square inner docking corner. It does not inherit the
rear plate cutout's 2 mm open-edge radius. All plate-support
geometry joins the side walls before one shared rear-bottom subtraction. The
rear holder, wall, and stopper therefore retain the continuous 5 mm Y/Z curve
approved for that region. This is independent of the square inner docking
corners in the bottom view; those remain unrounded. The front holder end also
remains square in the Y/Z side profile. The continuous support lip keeps
everything connected to the walls.
The device sits on top of the plate at Z=8 mm.
The SCAD assembly retains an imperceptible 0.01 mm display gap so F6 does not
fuse the three touching components into one mesh.

At the rear, each side wall has an **11 mm-wide alignment stop** behind the
plate. Each stop joins its side wall across the tiny CAD separation and extends
from the mount bottom exactly to the plate's top surface, so it retains the
loose plate without projecting into the device space. Its lower profile follows
the same **5 mm front-to-back rear curve** as the wall, filling the rear corner
without leaving a floating tab. Each stop also has a **3 mm radius** on its top
inward corner.

The existing ventilation layout remains on the loose plate. The front opening
extends 2 mm beyond each shortened 5.5 mm front stopper tip, making it 4 mm
wider overall. The rear opening and the two
**59.51 mm-wide** rounded longitudinal openings align with the inward ends of
the lower support pads, leaving approximately 10.99 mm-wide solid side rims
away from the front.
The longitudinal openings retain their 10 mm center bridge. The plate underside
remains flat where it seats on the support pads. The front stoppers project
**5.5 mm inward**, half the support-pad reach.

The front and rear plate openings have **2 mm radii** at their open-edge
corners and retain **7 mm radii** at their inward corners.

The exposed front- and rear-bottom edges of both side mounts use a **5 mm
radius**. The front curve continues through the lower leading edge of each
front stopper tab.

The top screw-mounting flanges are **35 mm wide**, including the 5 mm side wall,
so they extend **30 mm inward over the device**. Each flange has two holes
placed symmetrically **13 mm from the physical front and rear ends**. Their
centers sit exactly on the exposed flange centerline and align with the front
and rear bottom-plate openings. This provides a straight approximately **6
mm-diameter screwdriver-shaft path from below** while retaining 10.5 mm of
material on both sides of each 9 mm screw-head recess. The two free inward
corners of each flange have a **5 mm radius**; the outer wall-attachment edge
remains square.

At the rear of each side wall, two square-ended **30 × 1 mm** horizontal slots
leave a centered approximately **35.33 mm-high flexible tongue** between them. The tongue is reduced
from the 5 mm wall thickness to **2 mm** and is flush with the outer wall
surface. The 3 mm reduction is taken entirely from the device-facing inner face,
with a rounded transition into the full wall at the fixed end.
Each tongue carries one rear stopper, giving two mirrored stoppers in total.
Each stopper projects **3 mm inward from the normal wall face × 2 mm
front-to-back × 10 mm high** and has 2 mm radii on both corners of its free
inward edge. Both front contact faces remain at Y=151 mm. The stoppers and the
entire rear of the side mounts end together at Y=153 mm, leaving no frame behind
them.

Each side wall has four **39 × 16 mm** capsule-shaped ventilation holes,
giving eight openings in total. They lean **68°** toward the rear and form one
evenly spaced row between the physical front edge and the rear Sprungfeder
root. Their approximately **24.62 mm** horizontal projections preserve the
previous first and
last openings' **11.625 mm** distances from the front and rear boundaries. The
three internal gaps are evenly reduced to approximately **2.43 mm**. Every
opening is centered vertically at Z=32.76 mm, midway across the complete
visible side-wall height, including the wall beside the 5 mm top mount. This
remains independent of the device and loose plate positions. Its approximately
37.33 mm vertical projection leaves approximately **14.09 mm** of wall above
and below.

## Files

- `spark_atom_mount.scad` — adjustable source, part exports, and assembly view
- `spark_atom_mount.stl` — generated export; regenerate it after SCAD changes
- `spark_atom_demo.scad` — separate OpenSCAD demo with the device installed
- `spark_atom_print.scad` — both side mounts laid wall-face-down beside the
  loose plate in a separated print layout
- `images/asus-gx10-bottom.jpg` — supplied underside reference photograph
- `images/asus-gx10-bottom-projection.scad` — compressed 160 × 160, 16-shade
  demo projection derived from the photograph
- `images/NVIDIA-DGX-SPARK-Bottom.jpg` — supplied DGX Spark underside reference
- `images/nvidia-dgx-spark-bottom-projection.scad` — compressed 160 × 160,
  16-shade demo projection derived from the DGX Spark photograph
- `images/gigabyte-top-ai-nano.jpg` — supplied Gigabyte underside reference
- `images/gigabyte-top-ai-nano-projection.scad` — compressed 160 × 160,
  16-shade demo projection derived from the Gigabyte photograph
- `images/msi.png` — supplied MSI underside reference
- `images/msi-bottom-projection.scad` — compressed 160 × 160, 16-shade MSI
  demo projection
- `images/acer.jpg` — supplied Acer underside reference
- `images/acer-bottom-projection.scad` — compressed 160 × 160, 16-shade Acer
  demo projection
- `images/lenovo.png` — supplied Lenovo underside reference
- `images/lenovo-bottom-projection.scad` — compressed 160 × 160, 16-shade
  Lenovo demo projection
- `images/generate_bottom_projection.py` — reusable projection generator

## Generate the parts

Open `spark_atom_mount.scad` in OpenSCAD and change `part` near the top to export:

Use `assembly` (the default) to inspect all three components in their installed
positions. Export `left_side`, `right_side`, and `bottom_plate` separately for
printing. The legacy `tray`, `left_rail`, and `right_rail` selector names remain
as aliases for compatibility; `tray` now shows the three-piece assembly.

Open `spark_atom_print.scad` to render both complete side mounts and the loose
bottom plate. Both mounts are placed on their broad outside wall faces and
packed around the flat plate for a **226.51 × 234.51 mm** footprint, fitting a
250 × 250 mm build plate. Use `bottom_plate_print` directly when only the
isolated plate is needed.

Open `spark_atom_demo.scad` and set `part_override` to `"demo-gx10"`,
`"demo-nvidia"`, `"demo-gigabyte"`, `"demo-msi"`, `"demo-acer"`, or
`"demo-lenovo"` to select the displayed device
underside. The demo renders an
opaque dark 150 × 150 × 50.5 mm device mockup inside the mount with a shallow
grayscale projection derived from the selected photograph. The projections are
visible pixel tiles rather than height maps, and each photograph's bottom edge
is aligned with the device front. The printable `tray` selection contains
neither projection nor the device mockup. A red, centered 135 × 5 mm ventilation
marker remains visible beneath the projection, beginning 15 mm behind the
device's front edge. The mockup's front face visually overlaps the front stopper
plane by 0.2 mm, leaving 1.2 mm behind the device. Do not export a demo for
printing.

Render each printable selection with F6, then export it as STL.

If using the command-line version of OpenSCAD:

```sh
openscad -D 'part="bottom_plate"' -o spark_atom_bottom_plate.stl spark_atom_mount.scad
openscad -D 'part="left_side"' -o spark_atom_left_side.stl spark_atom_mount.scad
openscad -D 'part="right_side"' -o spark_atom_right_side.stl spark_atom_mount.scad
```

## Hardware and installation

- 4 × 4 mm or #8 countersunk/pan-head wood screws, with a length suitable for
  the tabletop
- Optional 0.5–1 mm felt or rubber tape on the rail contact surfaces

Print in PETG, ASA, or another heat-tolerant material with at least four walls
and 30% infill. Print the bottom plate flat. Orient each side mount appropriately
in the slicer and use support only where your printer requires it. The assembled
envelope is approximately **161.02 × 159 × 65.5 mm**. Fasten the side mounts
through their four
flange holes, lay the loose plate on the lower support pads, and slide the device into
the retained pocket.

The distance between the front and rear stops is **151 mm**, providing 0.5 mm
clearance at both ends of the 150 mm-deep enclosure. Internal width is
**151.02 mm**, providing approximately 0.51 mm clearance on each side. The
151 mm plate itself provides exactly 0.5 mm per side around the device.

The loose bottom plate is **3 mm thick**. The side walls, top mounting flanges,
and support ledges are **5 mm thick**. Each front retaining wall
has a **5.5 mm inward width × 6 mm depth** footprint and is **22 mm high** before
the shared bottom curve. Its effective height at the rounded leading edge is
**17 mm**. It is attached to the side wall and begins at the mount's absolute
bottom. Its upper
and lower inward corners retain a **3 mm radius**, giving the tab a gradual,
printable transition from the side wall. Both outer corners remain square.

The inward flange undersides are **60.5 mm** above the side mounts' bottom. With
the plate top at Z=8 mm and the 50.5 mm device above it, this leaves **2 mm of
vertical clearance**. The complete assembled model is **65.5 mm high**.

Do not overtighten the rails against the computer. Check the real enclosure with
calipers before drilling; adjust `device_*` or `clearance` at the top of the SCAD
file if necessary. Confirm that no screw can penetrate the top surface of the
table and periodically inspect the printed parts for heat deformation or cracks.
