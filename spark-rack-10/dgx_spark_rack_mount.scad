/*
 * 10-inch rack mount with an attached holder for an NVIDIA DGX Spark.
 *
 * Axes in the assembled model:
 *   X = rack width, Y = front-to-rear depth, Z = rack height.
 *
 * Holder dimensions are based on ../spark-atom/spark_atom_mount.scad:
 *   - 150 x 150 x 50.5 mm device
 *   - 10.5 mm device side clearance and 0.5 mm rear clearance
 *   - 173 mm-wide square-channel bottom support beneath the fans/device
 *   - 5 mm structural walls
 *   - open top for unobstructed access and airflow
 *
 * All dimensions are millimetres.
 */

part = "assembly"; // [assembly,front_panel,holder,demo]
selected_part = is_undef(part_override) ? part : part_override;

// De-facto 10-inch rack face width. The horizontal rack slots are centered on
// the common 236.525 mm hole spacing for equal inward/outward tolerance.
front_panel_width = 254;
front_panel_height = 88;
front_panel_thickness = 5;
front_panel_corner_radius = 5;

// M6/FDM-friendly rack slots using the standard 2U outer-hole spacing.
rack_holes_enabled = true;
rack_hole_diameter = 7;
rack_hole_width = 10;
rack_hole_horizontal_spacing_nominal = 236.525;
rack_hole_vertical_spacing = 76.2;
rack_hole_standard_pitch = 15.875;
rack_hole_center_x =
    (front_panel_width - rack_hole_horizontal_spacing_nominal) / 2;
rack_hole_bottom_z =
    (front_panel_height - rack_hole_vertical_spacing) / 2;
rack_hole_top_z = rack_hole_bottom_z + rack_hole_vertical_spacing;
rack_hole_inner_bottom_z =
    rack_hole_bottom_z + 2 * rack_hole_standard_pitch;
rack_hole_inner_top_z =
    rack_hole_top_z - 2 * rack_hole_standard_pitch;
rack_hole_zs = [
    rack_hole_bottom_z,
    rack_hole_inner_bottom_z,
    rack_hole_inner_top_z,
    rack_hole_top_z
];

// DGX Spark envelope and holder clearances copied from the source mount.
device_width = 150;
device_depth = 150;
device_height = 50.5;
width_clearance = 10.5;
depth_clearance = 5.5;
height_clearance = 2;

wall = 5;
floor_thickness = 5;
floor_channel_width = 20;
floor_support_width = 20;
floor_support_front_setback = 20;
floor_support_rear_setback = 20;
back_stopper_thickness = 3;
back_stopper_width = 10;
back_stopper_extra_height = 10;
back_stopper_corner_radius = 2;
wall_top_flat_depth = 20;
wall_profile_corner_radius = 5;
wall_profile_corner_segments = 12;

// Small ventilation slots across the front panel.
vent_slot_angle = 45;
vent_slot_length = 10;
vent_slot_width = 5;
vent_slot_minimum_web = 3;
front_slot_edge_margin_x = 5;
front_slot_edge_margin_z = 5;
front_rack_hole_keepout_web = 2;
front_side_wall_clearance = 0;
front_wall_outward_extension = 1;
front_slot_columns_per_side = 3;
front_slot_outer_columns_removed = 1;

// Two standard 80 mm fans with a 2 mm gap between their frames.
fan_size = 80;
fan_center_spacing = 82;
fan_opening_diameter = 66.4;
fan_mount_hole_spacing = 71.5;
fan_mount_hole_diameter = 4.5;
fan_depth = 25;
fan_device_clearance = 2;

// Fan-demo geometry; these dimensions do not alter the printable mount.
fan_frame_hole_diameter = 4.3;
fan_demo_airflow_diameter = 77;
fan_demo_corner_radius = 3;
fan_demo_hub_diameter = 26;
fan_demo_blade_count = 7;
fan_demo_rotor_thickness = 3;

// The tray overlaps the thin panel slightly so the exported mesh is one solid.
join_overlap = min(0.1, front_panel_thickness / 2);
floor_panel_overlap = 2;

// Preview only; does not affect printable assembly/holder exports.
demo_device_enabled = true;
demo_fans_enabled = true;

$fn = 64;

floor_width = device_width +
              2 * (width_clearance + front_wall_outward_extension);
device_front_offset = fan_depth + fan_device_clearance;
holder_depth = device_front_offset + device_depth + depth_clearance;
floor_depth = device_depth + depth_clearance;
device_support_z = floor_thickness;
// Keep rear-mounted fan frames above the bottom plate and align the installed
// device's vertical center with the fan centers.
fan_center_z = max(front_panel_height / 2,
                   floor_thickness + fan_size / 2);
holder_z = fan_center_z - device_support_z - device_height / 2;
device_support_top_z = holder_z + device_support_z;
floor_support_top_z = device_support_top_z;
back_stopper_top_z =
    floor_support_top_z + back_stopper_extra_height;
floor_support_count = floor(
    (floor_width + floor_channel_width) /
    (floor_support_width + floor_channel_width));
floor_pattern_width =
    floor_support_count * floor_support_width +
    (floor_support_count - 1) * floor_channel_width;
floor_side_channel_width =
    (floor_width - floor_pattern_width) / 2;
vent_slot_projected_x =
    (vent_slot_length - vent_slot_width) *
    abs(cos(vent_slot_angle)) + vent_slot_width;
vent_slot_projected_z =
    (vent_slot_length - vent_slot_width) *
    abs(sin(vent_slot_angle)) + vent_slot_width;
front_slot_count_z = floor(
    (front_panel_height - 2 * front_slot_edge_margin_z +
     vent_slot_minimum_web) /
    (vent_slot_projected_z + vent_slot_minimum_web));
front_slot_pitch_z =
    (front_panel_height - 2 * front_slot_edge_margin_z -
     vent_slot_projected_z) /
    (front_slot_count_z - 1);

// The walls begin at the panel bottom to meet the square-channel base.
wall_base_z = 0;
holder_height = front_panel_height - wall_base_z;
wall_rear_height =
    device_support_top_z + device_height / 4 - wall_base_z;
wall_plateau_start_y =
    wall_top_flat_depth + 2 * wall_profile_corner_radius;

holder_outer_width = floor_width + 2 * wall;
holder_x = (front_panel_width - holder_outer_width) / 2;
floor_x = holder_x + wall;
actual_width_clearance = (floor_width - device_width) / 2;
holder_y = front_panel_thickness - join_overlap;
device_y = holder_y + device_front_offset;
floor_y = device_y;
floor_support_y = floor_y + floor_support_front_setback;
floor_support_depth =
    device_depth - floor_support_front_setback -
    floor_support_rear_setback;
base_floor_y = front_panel_thickness - floor_panel_overlap;
base_floor_depth = floor_y + floor_depth - base_floor_y;
back_stopper_y =
    base_floor_y + base_floor_depth - back_stopper_thickness;
back_stopper_support_indices = [
    floor(floor_support_count / 2) - 1,
    floor(floor_support_count / 2)
];
back_stopper_xs = [for (i = back_stopper_support_indices)
    floor_x + floor_side_channel_width +
    i * (floor_support_width + floor_channel_width) +
    (floor_support_width - back_stopper_width) / 2
];
fan_center_xs = [
    front_panel_width / 2 - fan_center_spacing / 2,
    front_panel_width / 2 + fan_center_spacing / 2
];

assert(front_panel_width > 0 && front_panel_height > 0 &&
       front_panel_thickness > 0,
       "Front-panel dimensions must be positive");
assert(front_panel_corner_radius <=
       min(front_panel_width, front_panel_height) / 2,
       "Front-panel corner radius is too large");
assert(holder_outer_width <= front_panel_width,
       "Holder is wider than the rack panel");
assert(actual_width_clearance >= width_clearance,
       "Holder does not retain the minimum device side clearance");
assert(holder_height <= front_panel_height,
       "Holder is taller than the rack panel");
assert(floor_support_count > 0 &&
       floor_side_channel_width >= 0 &&
       floor_support_top_z > floor_thickness,
       "Square-channel floor does not fit the holder width or height");
assert(floor_channel_width > 0 && floor_support_width > 0,
       "Square-channel dimensions must be positive");
assert(floor_support_front_setback >= 0 &&
       floor_support_rear_setback >= 0 && floor_support_depth > 0,
       "Floor-support setbacks leave no support beneath the device");
assert(back_stopper_thickness > 0 &&
       back_stopper_width > 0 &&
       back_stopper_width <= floor_support_width &&
       back_stopper_corner_radius > 0 &&
       2 * back_stopper_corner_radius <= back_stopper_width &&
       2 * back_stopper_corner_radius <=
           back_stopper_top_z - wall_base_z &&
       back_stopper_y >= device_y + device_depth &&
       back_stopper_top_z <= wall_base_z + wall_rear_height,
       "Back stopper conflicts with the device or side-wall height");
assert(wall_rear_height > floor_thickness &&
       wall_rear_height < holder_height,
       "Wall plateau must be between the floor and panel top");
assert(wall_top_flat_depth > 0 &&
       wall_plateau_start_y < holder_depth,
       "Wall top and rounded step do not fit within the holder depth");
assert(2 * wall_profile_corner_radius <
       holder_height - wall_rear_height &&
       wall_profile_corner_radius < wall_rear_height,
       "Wall corner radius does not fit the stepped profile");
assert(rack_hole_center_x -
           (rack_hole_width - rack_hole_diameter) / 2 >=
           rack_hole_diameter / 2 &&
       rack_hole_bottom_z >= rack_hole_diameter / 2 &&
       rack_hole_top_z <=
           front_panel_height - rack_hole_diameter / 2 &&
       rack_hole_inner_bottom_z < rack_hole_inner_top_z &&
       rack_hole_width >= rack_hole_diameter,
       "Rack slots cross a panel edge or have invalid dimensions");
assert(fan_opening_diameter < fan_size &&
       fan_mount_hole_spacing < fan_size,
       "Fan opening or mounting pattern exceeds the 80 mm fan frame");
assert(fan_center_xs[0] - fan_size / 2 >= 0 &&
       fan_center_xs[1] + fan_size / 2 <= front_panel_width &&
       fan_center_z - fan_size / 2 >= 0 &&
       fan_center_z + fan_size / 2 <= front_panel_height,
       "The two fan footprints do not fit on the front panel");
assert(floor_x <= fan_center_xs[0] - fan_size / 2 &&
       floor_x + floor_width >= fan_center_xs[1] + fan_size / 2,
       "Side walls conflict with the two 80 mm fan footprints");
assert(floor_panel_overlap > 0 &&
       floor_panel_overlap <= front_panel_thickness,
       "Invalid bottom-plate/front-panel overlap");
assert(device_y >= front_panel_thickness + fan_depth +
                   fan_device_clearance - join_overlap,
       "The device conflicts with fans mounted behind the front panel");
assert(abs(holder_z + device_support_z + device_height / 2 -
           fan_center_z) < 0.001,
       "Device and fan vertical centers are not aligned");

module front_through_hole(x, z, diameter) {
    translate([x, -0.1, z])
        rotate([-90, 0, 0])
            cylinder(h = front_panel_thickness + 0.2,
                     d = diameter);
}

module rack_hole(slot_center_x, z) {
    inward_x_direction = slot_center_x < front_panel_width / 2 ? 1 : -1;
    centerline_half_travel =
        (rack_hole_width - rack_hole_diameter) / 2;
    outer_cap_x = slot_center_x -
        inward_x_direction * centerline_half_travel;
    inner_cap_x = slot_center_x +
        inward_x_direction * centerline_half_travel;

    hull()
        for (cap_x = [outer_cap_x, inner_cap_x])
            front_through_hole(cap_x, z, rack_hole_diameter);
}

module fan_cutouts() {
    mount_offset = fan_mount_hole_spacing / 2;

    for (fan_x = fan_center_xs) {
        front_through_hole(
            fan_x, fan_center_z, fan_opening_diameter);

        for (dx = [-mount_offset, mount_offset])
            for (dz = [-mount_offset, mount_offset])
                front_through_hole(
                    fan_x + dx,
                    fan_center_z + dz,
                    fan_mount_hole_diameter);
    }
}

module front_slot_grid_2d() {
    projected_x = vent_slot_projected_x;
    projected_z = vent_slot_projected_z;
    count_z = front_slot_count_z;
    left_first_x = front_slot_edge_margin_x + projected_x / 2;
    left_last_x = holder_x - front_side_wall_clearance - projected_x / 2;
    side_pitch_x = front_slot_columns_per_side > 1
        ? (left_last_x - left_first_x) /
          (front_slot_columns_per_side - 1)
        : 0;
    left_slot_xs =
        [for (ix = [front_slot_outer_columns_removed :
                    front_slot_columns_per_side - 1])
            left_first_x + ix * side_pitch_x];
    pitch_z = front_slot_pitch_z;
    rack_keepout_x = projected_x / 2 + rack_hole_diameter / 2 +
                     front_rack_hole_keepout_web;
    rack_keepout_z = projected_z / 2 + rack_hole_diameter / 2 +
                     front_rack_hole_keepout_web;
    rack_centerline_travel = rack_hole_width - rack_hole_diameter;
    left_rack_outer_x = rack_hole_center_x - rack_centerline_travel / 2;
    left_rack_inner_x = rack_hole_center_x + rack_centerline_travel / 2;
    right_rack_outer_x = front_panel_width - left_rack_outer_x;
    right_rack_inner_x = right_rack_outer_x - rack_centerline_travel;

    assert(front_slot_columns_per_side > 0 &&
           front_slot_outer_columns_removed >= 0 &&
           front_slot_outer_columns_removed < front_slot_columns_per_side &&
           count_z > 2,
           "No front slots fit in the selected region");
    assert(left_last_x >= left_first_x &&
           (front_slot_columns_per_side == 1 ||
            side_pitch_x >= projected_x),
           "Front slots do not fit between panel edge and side wall");
    echo(str("Front wing slots: ",
             2 * len(left_slot_xs) * (count_z - 2),
             " total at ", vent_slot_angle, " degrees"));

    for (side = [0, 1])
        for (left_slot_x = left_slot_xs)
            for (iz = [1 : count_z - 2]) {
            slot_x = side == 0
                ? left_slot_x
                : front_panel_width - left_slot_x;
            slot_z = front_slot_edge_margin_z + projected_z / 2 +
                     iz * pitch_z;
            near_rack_x =
                (slot_x >= left_rack_outer_x - rack_keepout_x &&
                 slot_x <= left_rack_inner_x + rack_keepout_x) ||
                (slot_x >= right_rack_inner_x - rack_keepout_x &&
                 slot_x <= right_rack_outer_x + rack_keepout_x);
            near_rack_z =
                min([for (rack_z = rack_hole_zs)
                    abs(slot_z - rack_z)]) < rack_keepout_z;
            slot_angle = side == 0
                ? -vent_slot_angle
                : vent_slot_angle;

            if (!(rack_holes_enabled && near_rack_x && near_rack_z))
                translate([slot_x, slot_z])
                    rotate(slot_angle)
                        vent_slot_2d();
        }
}

module front_slot_cutouts() {
    // Rotate the 2D grid into the X/Z front-panel plane and cut through Y.
    translate([0, front_panel_thickness + 0.1, 0])
        rotate([90, 0, 0])
            linear_extrude(height = front_panel_thickness + 0.2)
                front_slot_grid_2d();
}

module rounded_rectangle_2d(width, height, radius) {
    hull()
        for (x = [radius, width - radius])
            for (y = [radius, height - radius])
                translate([x, y])
                    circle(r = radius, $fn = 64);
}

module front_panel_blank() {
    // Extrude the rounded X/Z outline through the panel's Y thickness.
    translate([0, front_panel_thickness, 0])
        rotate([90, 0, 0])
            linear_extrude(height = front_panel_thickness)
                rounded_rectangle_2d(
                    front_panel_width,
                    front_panel_height,
                    front_panel_corner_radius);
}

module front_panel() {
    difference() {
        front_panel_blank();

        front_slot_cutouts();
        fan_cutouts();

        if (rack_holes_enabled)
            for (x = [rack_hole_center_x,
                      front_panel_width - rack_hole_center_x])
                for (z = rack_hole_zs)
                    rack_hole(x, z);
    }
}

module vent_slot_2d(length = vent_slot_length,
                    width = vent_slot_width) {
    center_offset = (length - width) / 2;

    hull()
        for (x = [-center_offset, center_offset])
            translate([x, 0])
                circle(d = width, $fn = 32);
}

module square_channel_floor() {
    union() {
        // The low 5 mm plate attaches directly to the front panel and runs
        // beneath the fans before continuing through the device bay.
        translate([floor_x, base_floor_y, wall_base_z])
            cube([floor_width, base_floor_depth, floor_thickness]);

        // Four rectangular rails hold the device at its original height.
        // They begin behind the fan frames; the spaces between them become
        // front-to-back cooling channels beneath the installed device.
        for (i = [0 : floor_support_count - 1])
            translate([
                floor_x + floor_side_channel_width +
                    i * (floor_support_width + floor_channel_width),
                floor_support_y,
                wall_base_z
            ])
                cube([
                    floor_support_width,
                    floor_support_depth,
                    floor_support_top_z - wall_base_z
                ]);
    }
}

module holder_floor() {
    square_channel_floor();
}

module rounded_step_side_wall(width, depth, height, plateau_height,
                              top_flat_depth, corner_radius,
                              corner_segments) {
    step_x = top_flat_depth + corner_radius;
    lower_corner_center_x = top_flat_depth + 2 * corner_radius;
    rear_corner_center_x = depth - corner_radius;
    points = concat(
        [
            [0, 0],
            [depth, 0],
            [depth, plateau_height - corner_radius]
        ],
        // Round the rear-top corner without rounding the vertical rear edge.
        [for (i = [1 : corner_segments])
            let(a = i * 90 / corner_segments)
                [rear_corner_center_x + corner_radius * cos(a),
                 plateau_height - corner_radius +
                     corner_radius * sin(a)]],
        [[lower_corner_center_x, plateau_height]],
        // Round from the rear plateau into the vertical height change.
        [for (i = [1 : corner_segments])
            let(a = -90 - i * 90 / corner_segments)
                [lower_corner_center_x + corner_radius * cos(a),
                 plateau_height + corner_radius +
                     corner_radius * sin(a)]],
        [[step_x, height - corner_radius]],
        // Round from the vertical height change into the full-height top.
        [for (i = [1 : corner_segments])
            let(a = i * 90 / corner_segments)
                [top_flat_depth + corner_radius * cos(a),
                 height - corner_radius + corner_radius * sin(a)]],
        [[0, height]]
    );

    // The polygon is Y/Z in the finished model and is extruded across X.
    rotate([90, 0, 90])
        linear_extrude(height = width)
            polygon(points);
}

module side_walls() {
    union() {
        translate([holder_x, holder_y, wall_base_z])
            rounded_step_side_wall(
                wall, holder_depth, holder_height,
                wall_rear_height, wall_top_flat_depth,
                wall_profile_corner_radius,
                wall_profile_corner_segments);
        translate([holder_x + wall + floor_width,
                   holder_y, wall_base_z])
            rounded_step_side_wall(
                wall, holder_depth, holder_height,
                wall_rear_height, wall_top_flat_depth,
                wall_profile_corner_radius,
                wall_profile_corner_segments);
    }
}

module back_stopper() {
    // Two slim tabs align with the inner support rails, keeping the central
    // cooling channel completely unobstructed. Their X/Z profile is rounded;
    // the floor beneath them fills the lower fillets for a strong attachment.
    for (stopper_x = back_stopper_xs)
        translate([
            stopper_x,
            back_stopper_y + back_stopper_thickness,
            wall_base_z
        ])
            rotate([90, 0, 0])
                linear_extrude(height = back_stopper_thickness)
                    rounded_rectangle_2d(
                        back_stopper_width,
                        back_stopper_top_z - wall_base_z,
                        back_stopper_corner_radius);
}

module holder() {
    union() {
        holder_floor();
        side_walls();
        back_stopper();
    }
}

module assembly() {
    union() {
        front_panel();
        holder();
    }
}

module device_mockup() {
    color([0.12, 0.13, 0.14, 0.75])
        translate([floor_x + actual_width_clearance,
                   device_y,
                   holder_z + device_support_z])
            cube([device_width, device_depth, device_height]);
}

module fan_frame_mockup_2d() {
    mount_offset = fan_mount_hole_spacing / 2;

    difference() {
        rounded_rectangle_2d(
            fan_size, fan_size, fan_demo_corner_radius);
        translate([fan_size / 2, fan_size / 2])
            circle(d = fan_demo_airflow_diameter, $fn = 96);
        for (dx = [-mount_offset, mount_offset])
            for (dz = [-mount_offset, mount_offset])
                translate([fan_size / 2 + dx,
                           fan_size / 2 + dz])
                    circle(d = fan_frame_hole_diameter, $fn = 32);
    }
}

module fan_blade_mockup_2d() {
    hull() {
        translate([fan_demo_hub_diameter / 2 - 2, -3])
            circle(r = 3, $fn = 32);
        translate([fan_demo_airflow_diameter / 2 - 8, 8])
            circle(r = 5, $fn = 32);
    }
}

module fan_rotor_mockup_2d() {
    union() {
        circle(d = fan_demo_hub_diameter, $fn = 64);
        for (i = [0 : fan_demo_blade_count - 1])
            rotate(i * 360 / fan_demo_blade_count)
                fan_blade_mockup_2d();
    }
}

module fan_mockup(fan_x) {
    // Frame occupies the rear side of the front panel from Y=4 to Y=29 mm.
    color([0.07, 0.08, 0.09, 0.92])
        translate([fan_x - fan_size / 2,
                   front_panel_thickness + fan_depth,
                   fan_center_z - fan_size / 2])
            rotate([90, 0, 0])
                linear_extrude(height = fan_depth)
                    fan_frame_mockup_2d();

    // Simple hub-and-blade visualization centered within the fan frame.
    color([0.24, 0.26, 0.29, 0.96])
        translate([fan_x,
                   front_panel_thickness + fan_depth / 2 +
                   fan_demo_rotor_thickness / 2,
                   fan_center_z])
            rotate([90, 0, 0])
                linear_extrude(height = fan_demo_rotor_thickness)
                    fan_rotor_mockup_2d();
}

module fan_mockups() {
    for (fan_x = fan_center_xs)
        fan_mockup(fan_x);
}

module demo() {
    color([0.74, 0.76, 0.80]) assembly();
    if (demo_device_enabled)
        device_mockup();
    if (demo_fans_enabled)
        fan_mockups();
}

echo(str("Front panel: ", front_panel_width, " x ",
         front_panel_height, " x ", front_panel_thickness, " mm"));
echo(str("Device bay: ", floor_width, " mm wide; device starts ",
         device_front_offset, " mm behind panel rear; ",
         depth_clearance, " mm rear clearance; ",
         actual_width_clearance, " mm side clearance"));
echo(str("Square-channel bottom support: ", floor_width, " x ",
         base_floor_depth, " x ", floor_thickness,
         " mm base; ", floor_support_count, " rear supports x ",
         floor_support_width, " mm with ", floor_channel_width,
         " mm internal channels; ", floor_support_front_setback,
         " mm front and ", floor_support_rear_setback,
         " mm rear setbacks"));
echo(str("Holder envelope: ", holder_outer_width, " x ", holder_depth,
         " x ", holder_height, " mm"));
echo(str("Rear side-wall top: Z=", wall_base_z + wall_rear_height,
         " mm (one quarter of device height above the plate)"));
echo(str("Back stoppers: 2 x ", back_stopper_width, " mm wide x ",
         back_stopper_thickness, " mm thick; top Z=",
         back_stopper_top_z, " mm"));

if (selected_part == "front_panel") {
    front_panel();
} else if (selected_part == "holder") {
    holder();
} else if (selected_part == "demo") {
    demo();
} else {
    assembly();
}
