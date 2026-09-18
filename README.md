# 3D-printable mounts for NVIDIA DGX Spark and other GB10 systems

3D-printable mounts for the **original NVIDIA DGX Spark** and other
**NVIDIA GB10 systems**: **ASUS Ascent GX10**, **GIGABYTE AI TOP ATOM**,
**MSI EdgeXpert AI**, **Lenovo ThinkStation PGX**, and **Acer Veriton GN100**.

The repository includes editable `.scad` sources, `.stl` exports, `.3mf` print
projects, and rendered previews and 360° turnaround videos of both designs.

## 10-inch rack mount

[`spark-rack-10/`](spark-rack-10/) holds the computer behind a **254 × 88 mm
front panel**, sized for a **10-inch, 2U rack position**. The front panel has
mounting holes for **two 80 mm fans**. An open top and a base with ventilation
channels leave the device accessible, while rear stops locate it in the holder.

The design prioritizes airflow and a stable fit when connecting or removing
cables. The large fan openings are free of printed grilles to minimize airflow
restriction and avoid adding grille-related noise or vibration.

**Printed rack mount**

| Installed in the rack | Front view | Fans and support detail |
| --- | --- | --- |
| [![Printed DGX Spark mount installed in a 10-inch rack](spark-rack-10/img/1.JPG)](spark-rack-10/img/1.JPG) | [![Front view of the printed rack mount with two fans](spark-rack-10/img/2.JPG)](spark-rack-10/img/2.JPG) | [![Top view showing the fans and open device supports](spark-rack-10/img/3.jpeg)](spark-rack-10/img/3.jpeg) |

| Device installed | Running in the rack | Rear connector access |
| --- | --- | --- |
| [![GB10 system seated in the printed rack mount](spark-rack-10/img/4.JPG)](spark-rack-10/img/4.JPG) | [![Front view of the rack-mounted system with fans running](spark-rack-10/img/5.JPG)](spark-rack-10/img/5.JPG) | [![Rear view showing accessible connectors and device support](spark-rack-10/img/6.JPG)](spark-rack-10/img/6.JPG) |

**Turnaround previews**

| Horizontal turnaround preview | Vertical turnaround preview |
| --- | --- |
| [![10-inch DGX Spark rack mount, horizontal turnaround preview](spark-rack-10/turnarounds/dgx_spark_rack_mount_horizontal_preview.png)](spark-rack-10/turnarounds/dgx_spark_rack_mount_horizontal.mp4) | [![10-inch DGX Spark rack mount, vertical turnaround preview](spark-rack-10/turnarounds/dgx_spark_rack_mount_vertical_preview.png)](spark-rack-10/turnarounds/dgx_spark_rack_mount_vertical.mp4) |

**Horizontal turnaround**

https://github.com/user-attachments/assets/c2208833-c9f4-418d-8570-8aad48857cc8

**Vertical turnaround**

https://github.com/user-attachments/assets/7938ebce-b39c-4762-b75c-36b6145284a8

[OpenSCAD source](spark-rack-10/dgx_spark_rack_mount.scad) ·
[STL model](spark-rack-10/dgx_spark_rack_mount.stl) ·
[3MF project](spark-rack-10/dgx_spark_rack_mount.3mf) ·
[Demo assembly](spark-rack-10/dgx_spark_rack_mount_demo.scad) ·
[Load-test notes](spark-rack-10/load_test/README.md)

### Cooling observations

In my own rack-mount comparison tests, CPU and GPU temperatures were on average
about **5 °C lower** with the open design, with differences of up to **8 °C** at
individual temperature peaks. These results describe my test setup; actual
temperatures depend on the device, workload, room temperature, and rack airflow.
See the [load-test notes and plots](spark-rack-10/load_test/) for context.

| CPU / ACPI temperatures | GPU temperatures |
| --- | --- |
| [![Annotated CPU and ACPI temperature plot before and after installation in the rack mount](spark-rack-10/load_test/loadtest_acpitemps_with_markers.png)](spark-rack-10/load_test/loadtest_acpitemps_with_markers.png) | [![Annotated GPU temperature plot before and after installation in the rack mount](spark-rack-10/load_test/loadtest_gputemps_with_markers.png)](spark-rack-10/load_test/loadtest_gputemps_with_markers.png) |

Click either plot to view the annotations at full resolution.

## Under-desk mount

[`spark-atom/`](spark-atom/) frees up desk space by securing the computer beneath
a desk or table, with support for the device during everyday use and cable
changes. It consists of **three printable parts**: two side mounts and a separate
ventilated bottom plate. Four screws secure the upper flanges to the tabletop;
the side mounts support the plate and retain the device with front stops and
flexible rear tabs.

The bottom plate supports the device from below and helps set the spacing
between the side mounts during assembly. Together, the plate and side supports
spread the load and limit unwanted movement. The plate cutouts and side openings
leave room for airflow; check their alignment with your device's vents when
adapting the model.

Use screws suitable for the tabletop material and thickness. Print strength
depends on the filament, orientation, wall count, infill, and layer adhesion;
the [model guide](spark-atom/README.md) includes dimensions, print settings, and
installation details.

**Under-desk mount examples**

| Rear connector access | Bottom plate | Rear support detail | Side ventilation |
| --- | --- | --- | --- |
| [![Rear connectors accessible with the GB10 system in the under-desk mount](spark-atom/demo-img/1.jpg)](spark-atom/demo-img/1.jpg) | [![Underside of the mount showing the ventilated bottom plate](spark-atom/demo-img/2.jpg)](spark-atom/demo-img/2.jpg) | [![Rear view of the device seated between the side mounts](spark-atom/demo-img/3.jpg)](spark-atom/demo-img/3.jpg) | [![Side view of the mounted device and ventilation openings](spark-atom/demo-img/4.jpg)](spark-atom/demo-img/4.jpg) |

**Turnaround previews**

| Horizontal turnaround preview | Vertical turnaround preview |
| --- | --- |
| [![DGX Spark and AI TOP ATOM under-table mount, horizontal turnaround preview](spark-atom/turnarounds/spark_atom_mount_horizontal_preview.png)](spark-atom/turnarounds/spark_atom_mount_horizontal.mp4) | [![DGX Spark and AI TOP ATOM under-table mount, vertical turnaround preview](spark-atom/turnarounds/spark_atom_mount_vertical_preview.png)](spark-atom/turnarounds/spark_atom_mount_vertical.mp4) |

**Horizontal turnaround**

https://github.com/user-attachments/assets/820ae4a6-639c-43a1-a501-b3cc796e51cc

**Vertical turnaround**

https://github.com/user-attachments/assets/ac608dab-5ee2-4ecf-ad42-badc45d0a388

[Detailed dimensions and installation](spark-atom/README.md) ·
[OpenSCAD source](spark-atom/spark_atom_mount.scad) ·
[STL assembly](spark-atom/spark_atom_mount.stl) ·
[Print layout](spark-atom/spark_atom_print.scad) ·
[Print-layout STL](spark-atom/spark_atom_print.stl) ·
[Bottom-plate 3MF](spark-atom/spark_atom_print_plate.3mf) ·
[Side-mount 3MF](spark-atom/spark_atom_print_sides.3mf)

## Support

If you find these models useful, consider supporting the project.

Your support helps improve the current models and develop more 3D-printable
mounts, gadgets, and utilities for NVIDIA DGX Spark and other GB10 systems
in the future.

<a href="https://buymeacoffee.com/alexliesenfeld"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me a Coffee" height="40"></a>
<a href="https://github.com/sponsors/alexliesenfeld"><img src=".github/assets/github-sponsors.svg" alt="GitHub Sponsors" height="40"></a>

## Device fit and vendor variants

Both models currently use a **150 × 150 × 50.5 mm** device envelope. They are
intended for DGX Spark and similarly sized vendor variants; fit depends on the
actual enclosure, feet, vents, and connector positions. Measure your device and
adjust `device_width`, `device_depth`, `device_height`, and the clearance
parameters in the OpenSCAD source before printing if needed.

The under-table demo also includes underside references for NVIDIA, GIGABYTE,
ASUS GX10, MSI, Acer, and Lenovo systems. These help inspect vent placement;
they do not establish that every variant fits the default dimensions.

## Printing

**PETG is recommended** for its heat resistance and strength. PLA can also be
used, but it has lower heat resistance than PETG and may soften or deform if
the mount gets too warm, especially during sustained heavy use of the system.
Inspect the finished print for cracks, poor layer adhesion, and other defects
before mounting the device.

1. Open the relevant `.scad` file in OpenSCAD and check the dimensions for your
   device and installation.
2. Select the printable parts, render them, and export STL files. For the
   under-table mount, use `spark_atom_print.scad` for the arranged print layout
   or export the left side, right side, and bottom plate separately.
3. Slice the STL files or start from the supplied 3MF projects. Regenerate the
   STL exports after changing the source dimensions. Demo assemblies include
   visualization geometry and are for previewing the installation.

The original MP4 videos, PNG previews, Blender scenes, and rendering scripts are
in each model's `turnarounds/` directory. Click a preview image to open its MP4.

## License

The models and design source files are licensed under
[Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](LICENSE).
You may download, print, modify, and share them for noncommercial purposes.
When sharing files or adaptations, credit Alexander Liesenfeld, retain the
license notice, and indicate any changes.

Commercial sales of the digital files or printed models, including modified
versions, require prior written permission from
[Alexander Liesenfeld](https://github.com/alexliesenfeld).
