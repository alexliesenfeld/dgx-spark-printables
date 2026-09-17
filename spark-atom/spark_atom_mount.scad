/*
 * Under-table mount for the GIGABYTE AI TOP ATOM.
 *
 * Coordinate system in the assembled preview:
 *   X = device width, Y = device depth (front to rear), Z = height.
 *
 * Select a printable part with `part`. The assembled view contains three
 * disconnected printable components: two side mounts and one loose plate.
 */

include <images/asus-gx10-bottom-projection.scad>
include <images/nvidia-dgx-spark-bottom-projection.scad>
include <images/gigabyte-top-ai-nano-projection.scad>
include <images/msi-bottom-projection.scad>
include <images/acer-bottom-projection.scad>
include <images/lenovo-bottom-projection.scad>

part = "assembly"; // [assembly,print_layout,bottom_plate,bottom_plate_print,left_side,right_side,demo-gx10,demo-nvidia,demo-gigabyte,demo-msi,demo-acer,demo-lenovo,demo,tray,left_rail,right_rail]
selected_part = is_undef(part_override) ? part : part_override;

device_width = 150;
device_depth = 150;
device_height = 50.5;
device_vent_width = 135;
device_vent_depth = 5;
device_vent_front_offset = 15;
device_vent_marker_thickness = 0.25;
device_demo_stop_overlap = 0.2;
device_bottom_projection_thickness = 0.05;

width_clearance = 0.5;  // Per side on plate: 151 mm total plate width
depth_clearance = 0.5;  // Front/rear: 151 mm total internal depth
height_clearance = 2;  // Vertical clearance below inward top mounts
wall = 5;
shelf_width = 11;
shelf_thickness = 5;
bottom_support_width = shelf_width + 20;
bottom_support_inner_corner_radius = 5;
top_mount_width = 35;
top_mount_thickness = 5;
rail_flange = top_mount_width - wall;  // Inward extension beyond side wall
top_mount_corner_radius = 5;
rear_side_stop_width = 3;
rear_side_stop_depth = 2;
rear_side_stop_height = 10;
rear_side_stop_corner_radius = 2;
rear_side_stop_embed = 0.2;
rear_plate_stop_corner_radius = 3;
rear_wall_spring_slot_length = 30;
rear_wall_spring_slot_height = 1;
rear_wall_spring_thickness = 2;
rear_wall_spring_relief_depth = wall - rear_wall_spring_thickness;
side_wall_vent_count = 4;
side_wall_vent_length = 39;
side_wall_vent_width = 16;
side_wall_vent_angle = 68;
side_wall_vent_end_margin = 11.625;

floor_thickness = 3;  // Loose plate only; structural holders remain 5 mm
vent_back_offset = 25;  // Front opening depth from the physical front edge
rear_vent_depth = 17.5; // Rear opening extends 17.5 mm into the interior
vent_rear_corner_radius = 7;
vent_open_corner_radius = 2;
front_cutout_side_extension = 2;
// CENTER BOTTOM-PLATE CUTOUTS
// These are the two large openings beneath the device. Length is measured
// front-to-back (Y in this SCAD).
center_plate_bridge_width = 10;
center_plate_cutout_radius = 7;
middle_bottom_support_width =
    shelf_width + center_plate_cutout_radius;
center_plate_front_bridge_depth = 24;
center_plate_rear_bridge_depth = 34;
front_stop_thickness = 6;
front_stop_width = shelf_width / 2;
bottom_support_rail_width =
    front_stop_width - front_cutout_side_extension;
front_stop_corner_radius = 3;
front_bottom_radius = 5;
front_stop_effective_height = 17;
front_stop_height = front_stop_effective_height + front_bottom_radius;

screw_diameter = 4.5;  // Clearance for a 4 mm / #8 wood screw
screw_head_diameter = 9;
screw_head_depth = 2.6;
mount_hole_center_inset = 13;
print_layout_gap = 10;
print_bed_width = 250;
print_bed_depth = 250;
$fn = 48;

rear_side_stop_contact_y = device_depth + 2 * depth_clearance;
rail_length = rear_side_stop_contact_y + rear_side_stop_depth;
rear_side_stop_anchor_y = rail_length;
// Prevent OpenSCAD from fusing touching parts in the assembled STL. This tiny
// display/export gap disappears when the loose plate rests on the real ledges.
assembly_part_gap = 0.01;
bottom_plate_width = device_width + 2 * width_clearance;
device_pocket_width = bottom_plate_width + 2 * assembly_part_gap;
rail_origin_spacing = device_pocket_width + 2 * wall;
bottom_plate_x = wall + assembly_part_gap;
bottom_plate_y = assembly_part_gap;
bottom_plate_z = shelf_thickness + assembly_part_gap;
bottom_plate_depth = device_depth;
device_support_z = bottom_plate_z + floor_thickness;
rear_plate_stop_x = wall;
rear_plate_stop_width = shelf_width;
rear_plate_stop_front_y =
    bottom_plate_y + bottom_plate_depth + assembly_part_gap;
rear_plate_stop_depth = rail_length - rear_plate_stop_front_y;
rear_plate_stop_bottom_z = 0;
rear_plate_stop_height = device_support_z - rear_plate_stop_bottom_z;
center_plate_cutout_front_y = -front_stop_thickness + vent_back_offset +
                               center_plate_front_bridge_depth;
center_plate_cutout_rear_y = rail_length - rear_vent_depth -
                              center_plate_rear_bridge_depth;
center_plate_cutout_length = center_plate_cutout_rear_y -
                             center_plate_cutout_front_y;
front_transverse_cutout_inner_y =
    -front_stop_thickness + vent_back_offset;
rear_transverse_cutout_inner_y =
    rail_length - rear_vent_depth;
front_cutout_inner_left_x =
    wall + front_stop_width - front_cutout_side_extension;
front_cutout_inner_right_x =
    rail_origin_spacing - wall - front_stop_width +
    front_cutout_side_extension;
front_cutout_width =
    front_cutout_inner_right_x - front_cutout_inner_left_x;
front_cutout_depth =
    front_transverse_cutout_inner_y - bottom_plate_y;
front_bottom_support_core_length =
    center_plate_cutout_front_y - front_transverse_cutout_inner_y;
rear_bottom_support_core_length =
    rear_transverse_cutout_inner_y - center_plate_cutout_rear_y;
front_bottom_support_y =
    front_transverse_cutout_inner_y - vent_rear_corner_radius;
front_bottom_support_depth =
    center_plate_cutout_front_y + center_plate_cutout_radius -
    front_bottom_support_y;
rear_bottom_support_y =
    center_plate_cutout_rear_y - center_plate_cutout_radius;
rear_bottom_support_depth =
    rear_transverse_cutout_inner_y + vent_rear_corner_radius -
    rear_bottom_support_y;
rear_bottom_support_tail_y = rear_transverse_cutout_inner_y;
rear_bottom_support_tail_depth =
    bottom_plate_y + bottom_plate_depth -
    rear_bottom_support_tail_y;
center_plate_cutout_width =
    (device_pocket_width - 2 * shelf_width -
     center_plate_bridge_width) / 2;
side_mount_inward_extent =
    max(top_mount_width, wall + bottom_support_width);
// Inward flanges sit above the device and therefore include the loose plate.
inside_height = device_height + height_clearance;
flange_z = device_support_z + inside_height;
device_pocket_depth = device_depth + 2 * depth_clearance;
// Center wall openings and the Sprungfeder in the complete visible side wall,
// including the wall section beside the top mount thickness. This remains
// independent of the installed plate and device position.
side_wall_feature_bottom_z = 0;
side_wall_feature_top_z = flange_z + top_mount_thickness;
side_wall_feature_center_z =
    (side_wall_feature_bottom_z + side_wall_feature_top_z) / 2;
side_wall_vent_projected_height =
    (side_wall_vent_length - side_wall_vent_width) *
    abs(sin(side_wall_vent_angle)) + side_wall_vent_width;
rear_wall_spring_tongue_center_z = side_wall_feature_center_z;
rear_wall_spring_tongue_height = side_wall_vent_projected_height -
                                 2 * rear_wall_spring_slot_height;
rear_wall_spring_tongue_bottom_z = rear_wall_spring_tongue_center_z -
                                    rear_wall_spring_tongue_height / 2;
rear_wall_spring_root_y = rail_length - rear_wall_spring_slot_length;
rear_side_stop_bottom_z = rear_wall_spring_tongue_center_z -
                          rear_side_stop_height / 2;

assert(device_width > 2 * shelf_width,
       "Shelves must leave an opening beneath the device");
assert(device_width > 2 * bottom_support_width,
       "Bottom support pads leave no opening beneath the device");
assert(middle_bottom_support_width <= bottom_support_width,
       "Middle bottom support exceeds the larger support fields");
assert(bottom_support_inner_corner_radius <= bottom_support_width &&
       2 * bottom_support_inner_corner_radius <=
       min(center_plate_front_bridge_depth,
           center_plate_rear_bridge_depth),
       "Bottom support inner-corner radius is too large");
assert(bottom_support_rail_width >= 3 &&
       bottom_support_rail_width <= bottom_support_width,
       "Continuous bottom support width is invalid");
assert(bottom_plate_width <= device_pocket_width &&
       bottom_plate_depth <= device_pocket_depth,
       "Loose bottom plate does not fit inside the device pocket");
assert(shelf_width > width_clearance,
       "Bottom ledges do not reach beneath the loose plate");
assert(rear_plate_stop_depth > 0,
       "No room remains behind the plate for the rear alignment stops");
assert(rear_plate_stop_width == shelf_width,
       "Rear plate stops must align with the bottom holders");
assert(rear_plate_stop_front_y >
       bottom_plate_y + bottom_plate_depth,
       "Rear plate stops must remain behind the loose plate");
assert(front_bottom_support_core_length == center_plate_front_bridge_depth,
       "Front bottom support no longer matches its plate band");
assert(rear_bottom_support_core_length == center_plate_rear_bridge_depth,
       "Rear bottom support no longer matches its plate band");
assert(front_bottom_support_y >= bottom_plate_y &&
       rear_bottom_support_y + rear_bottom_support_depth <=
       bottom_plate_y + bottom_plate_depth,
       "Bottom support envelopes extend beyond the plate");
assert(screw_head_diameter < top_mount_width - 2,
       "Mounting flange is too narrow for the screw heads");
assert(screw_head_depth < top_mount_thickness,
       "Top mounting flange is too thin for the screw-head recess");
assert(rear_wall_spring_thickness > 0 &&
       rear_wall_spring_thickness < wall,
       "Spring tongue thickness must be between zero and wall thickness");
assert(floor_thickness > 0,
       "Loose bottom plate thickness must be positive");
module screw_hole(height) {
    // Through hole plus a recess on the exposed underside of the flange.
    cylinder(h = height + 0.2, d = screw_diameter);
    cylinder(h = screw_head_depth + 0.1, d1 = screw_head_diameter,
             d2 = screw_diameter);
}

module rail() {
    full_rail_length = rail_length + front_stop_thickness;
    // Center the holes across the exposed inward flange. Their front/rear
    // positions still align with plate openings for screwdriver access below.
    flange_center_x = wall + rail_flange / 2;
    flange_front_y = -front_stop_thickness;

    union() {
        difference() {
            union() {
                // Side wall and inward-facing flange span the full depth.
                translate([0, -front_stop_thickness, 0])
                    cube([wall, full_rail_length,
                          flange_z + top_mount_thickness]);
                translate([0, -front_stop_thickness, flange_z])
                    linear_extrude(height = top_mount_thickness)
                        rounded_free_edge_flange_2d(
                            top_mount_width, full_rail_length,
                            top_mount_corner_radius);
            }

            for (y = [flange_front_y + mount_hole_center_inset,
                      rail_length - mount_hole_center_inset])
                translate([flange_center_x, y, flange_z - 0.1])
                    screw_hole(top_mount_thickness + 0.2);

            rear_wall_spring_slots();
            rear_wall_spring_side_reliefs();
            side_wall_vent_holes();
        }

        // Add after thinning so the stopper embeds into the 2 mm tongue.
        rear_side_stop();
    }
}

module rounded_free_edge_flange_2d(width, depth, radius) {
    steps = 30;
    front_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(-90 + i * 90 / steps),
         radius + radius * sin(-90 + i * 90 / steps)]];
    rear_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(i * 90 / steps),
         depth - radius + radius * sin(i * 90 / steps)]];

    assert(radius <= min(width, depth) / 2,
           "Top mounting flange radius is too large");

    // Local left edge stays square at the outer wall; the rounded free edge
    // points inward. Mirroring the complete right side reverses it correctly.
    polygon(concat([[0, 0], [width - radius, 0]], front_arc,
                   rear_arc, [[0, depth]]));
}

module bottom_support_pads() {
    // Intersect broad support envelopes with a Z-shifted copy of the plate.
    // This inherits the exact cutout arcs in bottom view instead of applying
    // unrelated generic corner radii.
    bottom_support_pad(
        front_bottom_support_y, front_bottom_support_depth,
        front_transverse_cutout_inner_y, center_plate_cutout_front_y);
    bottom_support_pad(
        rear_bottom_support_y, rear_bottom_support_depth,
        center_plate_cutout_rear_y, rear_transverse_cutout_inner_y);
    middle_bottom_support();
    rear_bottom_support_tail();
}

module continuous_bottom_support() {
    // Follow the nominal front opening width but keep the holder's inward
    // docking corner square instead of inheriting the plate's 2 mm radius.
    difference() {
        translate([wall, bottom_plate_y, 0])
            cube([bottom_support_rail_width,
                  bottom_plate_depth, shelf_thickness]);
        translate([front_cutout_inner_left_x, bottom_plate_y, -0.2])
            linear_extrude(height = shelf_thickness + 0.4)
                open_front_notch_2d(
                    front_cutout_width, front_cutout_depth,
                    vent_rear_corner_radius, 0);
    }
}

module bottom_plate_support_profile() {
    // Reuse the exact plate outline while expanding only its temporary Z copy
    // to the independent 5 mm structural-holder thickness.
    scale([1, 1, shelf_thickness / floor_thickness])
        translate([0, 0, -bottom_plate_z])
            bottom_plate();
}

module bottom_support_pad(y, depth, core_front_y, core_rear_y) {
    difference() {
        intersection() {
            translate([wall, y, 0])
                cube([bottom_support_width, depth, shelf_thickness]);
            bottom_plate_support_profile();
        }
        bottom_support_inner_corner_cutouts(core_front_y, core_rear_y);
    }
}

module bottom_support_inner_corner_cutouts(core_front_y, core_rear_y) {
    radius = bottom_support_inner_corner_radius;
    inner_x = wall + bottom_support_width;
    corner_x = inner_x - radius;

    // Remove only the two convex corners at the free inward end. The nearby
    // plate-derived arcs and narrow docking holders remain untouched.
    translate([0, 0, -0.2])
        linear_extrude(height = shelf_thickness + 0.4) {
            difference() {
                translate([corner_x, core_front_y])
                    square([radius, radius]);
                translate([corner_x, core_front_y + radius])
                    circle(r = radius, $fn = 120);
            }
            difference() {
                translate([corner_x, core_rear_y - radius])
                    square([radius, radius]);
                translate([corner_x, core_rear_y - radius])
                    circle(r = radius, $fn = 120);
            }
        }
}

module middle_bottom_support() {
    // Connect the front and rear fields beneath the plate's side rim. The
    // shifted plate intersection reproduces both center-cutout arcs exactly.
    intersection() {
        translate([wall, center_plate_cutout_front_y, 0])
            cube([middle_bottom_support_width,
                  center_plate_cutout_length, shelf_thickness]);
        bottom_plate_support_profile();
    }
}

module rear_bottom_support_tail() {
    // Continue to the plate edge as a square docking tongue. It deliberately
    // does not inherit the rear plate opening's 2 mm inner-corner radius.
    translate([wall, rear_bottom_support_tail_y, 0])
        cube([shelf_width, rear_bottom_support_tail_depth,
              shelf_thickness]);
}

module side_wall_vent_holes() {
    // Arrange four angled capsules between the physical front edge and the
    // Sprungfeder root. Preserve the former first/last opening positions while
    // distributing the three smaller internal gaps equally.
    // Mirroring the rail produces eight openings in total.
    region_front_y = -front_stop_thickness;
    region_rear_y = rear_wall_spring_root_y;
    region_length = region_rear_y - region_front_y;
    region_bottom_z = side_wall_feature_bottom_z;
    region_top_z = side_wall_feature_top_z;
    region_height = region_top_z - region_bottom_z;
    center_z = side_wall_feature_center_z;
    // A capsule's circular ends stay circular when rotated; only the distance
    // between their centers contributes an angled projection.
    projected_width = (side_wall_vent_length - side_wall_vent_width) *
                      abs(cos(side_wall_vent_angle)) +
                      side_wall_vent_width;
    projected_height = side_wall_vent_projected_height;
    horizontal_gap = side_wall_vent_count > 1
        ? (region_length - 2 * side_wall_vent_end_margin -
           side_wall_vent_count * projected_width) /
          (side_wall_vent_count - 1)
        : 0;

    assert(side_wall_vent_length >= side_wall_vent_width,
           "Side-wall oval length must be at least its width");
    assert(side_wall_vent_end_margin >= 0 && horizontal_gap > 0,
           "Side-wall ovals do not fit between front and Sprungfeder");
    assert(projected_height <= region_height,
           "Side-wall ovals do not fit between floor and top mount");

    for (i = [0 : side_wall_vent_count - 1]) {
        center_y = region_front_y + side_wall_vent_end_margin +
                   projected_width / 2 +
                   i * (projected_width + horizontal_gap);
        side_wall_oval_hole(center_y, center_z, side_wall_vent_angle);
    }
}

module side_wall_oval_hole(center_y, center_z, angle = 0) {
    radius = side_wall_vent_width / 2;
    center_offset = (side_wall_vent_length - side_wall_vent_width) / 2;

    // Rotate a true capsule in the side-wall Y/Z plane around its center.
    translate([0, center_y, center_z])
        rotate([angle, 0, 0])
            hull()
                for (y = [-center_offset, center_offset])
                    translate([-0.2, y, 0])
                        rotate([0, 90, 0])
                            cylinder(h = wall + 0.4, r = radius, $fn = 72);
}

module rear_wall_spring_slots() {
    slot_offset_z = rear_wall_spring_tongue_height / 2 +
                    rear_wall_spring_slot_height / 2;

    // Their outer edges align with the ventilation holes' bottom and top.
    // Square, open rear slots let the stopper tongue flex during insertion.
    for (z = [rear_wall_spring_tongue_center_z - slot_offset_z,
              rear_wall_spring_tongue_center_z + slot_offset_z])
        translate([-0.2,
                   rail_length - rear_wall_spring_slot_length,
                   z - rear_wall_spring_slot_height / 2])
            cube([wall + 0.4,
                  rear_wall_spring_slot_length + 0.4,
                  rear_wall_spring_slot_height]);
}

module rear_wall_spring_side_reliefs() {
    relief = rear_wall_spring_relief_depth;
    steps = 24;
    z_overlap = 0.05;
    front_arc = [for (i = [0 : steps])
        [relief * cos(-90 + i * 90 / steps),
         rear_wall_spring_root_y + relief +
         relief * sin(-90 + i * 90 / steps)]];
    relief_profile = concat(
        [[-0.2, rear_wall_spring_root_y]],
        front_arc,
        [[relief, rail_length + 0.2],
         [-0.2, rail_length + 0.2]]);

    // Remove material only from the inner face. This leaves the 2 mm tongue
    // flush with the outer wall surface instead of centered.
    translate([wall, 0,
               rear_wall_spring_tongue_bottom_z - z_overlap])
        mirror([1, 0, 0])
            linear_extrude(height = rear_wall_spring_tongue_height +
                                    2 * z_overlap)
                polygon(relief_profile);
}

module rear_side_stop() {
    // Attach to the flexible rear wall tongue. The free inward edge is rounded
    // at top and bottom; the wall-side edge remains square.
    stop_x = rear_wall_spring_thickness - rear_side_stop_embed;
    stop_width = rear_wall_spring_relief_depth + rear_side_stop_width +
                 rear_side_stop_embed;

    translate([stop_x, rear_side_stop_anchor_y, rear_side_stop_bottom_z])
        rounded_side_tab(
            stop_width, rear_side_stop_depth,
            rear_side_stop_height, rear_side_stop_corner_radius,
            rounded_side = "right");
}

module left_rail() {
    // Inner face is x=0; device extends toward +X.
    rail();
}

module right_rail() {
    // Mirrored so the device extends toward -X.
    mirror([1, 0, 0]) rail();
}

module open_front_notch_2d(width, depth, radius,
                           open_corner_radius = 0) {
    steps = 30;
    right_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(i * 90 / steps),
         depth - radius + radius * sin(i * 90 / steps)]];
    left_arc = [for (i = [0 : steps])
        [radius + radius * cos(90 + i * 90 / steps),
         depth - radius + radius * sin(90 + i * 90 / steps)]];
    front_right_arc = [for (i = [0 : steps])
        [width + open_corner_radius +
         open_corner_radius * cos(-90 - i * 90 / steps),
         open_corner_radius +
         open_corner_radius * sin(-90 - i * 90 / steps)]];
    front_left_arc = [for (i = [0 : steps])
        [-open_corner_radius +
         open_corner_radius * cos(-i * 90 / steps),
         open_corner_radius +
         open_corner_radius * sin(-i * 90 / steps)]];

    assert(radius + open_corner_radius <= depth,
           "Open notch corner radii overlap");

    polygon(open_corner_radius > 0
        ? concat([[-open_corner_radius, 0],
                  [width + open_corner_radius, 0]],
                 front_right_arc, right_arc,
                 [[radius, depth]], left_arc,
                 [[0, open_corner_radius]], front_left_arc)
        : concat([[0, 0], [width, 0]], right_arc,
                 [[radius, depth]], left_arc));
}

module bottom_plate_blank() {
    // Device width plus 0.5 mm per side, centered inside the wall pocket.
    translate([bottom_plate_x, bottom_plate_y, bottom_plate_z])
        cube([bottom_plate_width, bottom_plate_depth, floor_thickness]);
}

module transverse_vent_cutout() {
    // Extend 2 mm beyond each shortened front stopper tip.
    floor_front = bottom_plate_y;
    vent_inner_y = front_transverse_cutout_inner_y;
    plate_vent_depth = vent_inner_y - floor_front;

    assert(front_cutout_inner_left_x - vent_open_corner_radius >=
           bottom_plate_x &&
           front_cutout_inner_right_x + vent_open_corner_radius <=
           bottom_plate_x + bottom_plate_width,
           "Front cutout leaves no material at the plate side edges");

    // Preserve narrow side rims while opening beyond the stopper tips.
    translate([front_cutout_inner_left_x, floor_front,
               bottom_plate_z - 0.2])
        linear_extrude(height = floor_thickness + 0.4)
            open_front_notch_2d(front_cutout_width, plate_vent_depth,
                                vent_rear_corner_radius,
                                vent_open_corner_radius);
}

module rear_transverse_vent_cutout() {
    // Leave side rims that align with the inward ends of the bottom ledges.
    inner_left_x = wall + shelf_width;
    inner_right_x = rail_origin_spacing - wall - shelf_width;
    vent_width = inner_right_x - inner_left_x;
    plate_rear_y = bottom_plate_y + bottom_plate_depth;
    vent_inner_y = rear_transverse_cutout_inner_y;
    plate_vent_depth = plate_rear_y - vent_inner_y;

    // Use the same profile at the physical rear edge, but with the shallower
    // rear-specific depth. Its two inward-facing corners retain the radius.
    translate([inner_left_x, plate_rear_y, bottom_plate_z - 0.2])
        linear_extrude(height = floor_thickness + 0.4)
            mirror([0, 1, 0])
                open_front_notch_2d(vent_width, plate_vent_depth,
                                    vent_rear_corner_radius,
                                    vent_open_corner_radius);
}

module rounded_rectangle_2d(width, depth, radius) {
    assert(radius <= min(width, depth) / 2,
           "Plate cutout radius is too large");

    hull()
        for (x = [radius, width - radius])
            for (y = [radius, depth - radius])
                translate([x, y]) circle(r = radius, $fn = 120);
}

module center_plate_cutout() {
    // Align the openings' outer edges with the inward ends of the ledges.
    inner_left_x = wall + shelf_width;
    inner_right_x = rail_origin_spacing - wall - shelf_width;
    available_width = inner_right_x - inner_left_x;
    cutout_x_positions = [inner_left_x,
                          inner_right_x - center_plate_cutout_width];
    assert(2 * center_plate_cutout_width +
           center_plate_bridge_width <= available_width,
           "Longitudinal center cutouts do not fit across the floor plate");
    assert(center_plate_cutout_length >= 2 * center_plate_cutout_radius,
           "Longitudinal center cutouts are too short for their radius");

    // Front and rear strip depths can be adjusted independently without
    // changing either transverse opening.
    for (x = cutout_x_positions)
        translate([x, center_plate_cutout_front_y,
                   bottom_plate_z - 0.2])
            linear_extrude(height = floor_thickness + 0.4)
                rounded_rectangle_2d(center_plate_cutout_width,
                                     center_plate_cutout_length,
                                     center_plate_cutout_radius);
}

module front_bottom_rounding_cutout() {
    front_y = -front_stop_thickness;
    cutter_x = -rail_flange - 0.2;
    cutter_width = rail_origin_spacing + 2 * rail_flange + 0.4;

    // Remove the area outside a quarter circle in the front/bottom Y/Z corner.
    difference() {
        translate([cutter_x, front_y - 0.1, -0.1])
            cube([cutter_width, front_bottom_radius + 0.1,
                  front_bottom_radius + 0.1]);
        translate([cutter_x - 0.1, front_y + front_bottom_radius,
                   front_bottom_radius])
            rotate([0, 90, 0])
                cylinder(h = cutter_width + 0.2, r = front_bottom_radius,
                         $fn = 120);
    }
}

module rear_bottom_rounding_cutout() {
    rear_y = rail_length;
    cutter_x = -rail_flange - 0.2;
    cutter_width = rail_origin_spacing + 2 * rail_flange + 0.4;

    // Mirror the front underside curve at the physical rear edge.
    difference() {
        translate([cutter_x, rear_y - front_bottom_radius, -0.1])
            cube([cutter_width, front_bottom_radius + 0.1,
                  front_bottom_radius + 0.1]);
        translate([cutter_x - 0.1, rear_y - front_bottom_radius,
                   front_bottom_radius])
            rotate([0, 90, 0])
                cylinder(h = cutter_width + 0.2, r = front_bottom_radius,
                         $fn = 120);
    }
}

module front_stop_wall() {
    // The right-side counterpart is produced by mirroring the complete wall.
    translate([wall, 0, 0])
        rounded_side_tab(front_stop_width, front_stop_thickness,
                         front_stop_height, front_stop_corner_radius,
                         rounded_side = "right");
}

module rear_plate_stop() {
    // Full-height rear lip runs from the mount bottom to the plate surface.
    // Its top inward corner is rounded here; side_mount() applies the shared
    // rear-bottom curve so the lip sweeps smoothly upward from front to back.
    translate([rear_plate_stop_x, rail_length,
               rear_plate_stop_bottom_z])
        rounded_top_wall(
            rear_plate_stop_width, rear_plate_stop_depth,
            rear_plate_stop_height, rear_plate_stop_corner_radius,
            round_right = true);
}

module rounded_side_tab(width, depth, height, radius,
                        rounded_side = "right") {
    steps = 30;
    bottom_right_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(-90 + i * 90 / steps),
         radius + radius * sin(-90 + i * 90 / steps)]];
    top_right_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(i * 90 / steps),
         height - radius + radius * sin(i * 90 / steps)]];
    top_left_arc = [for (i = [0 : steps])
        [radius + radius * cos(90 + i * 90 / steps),
         height - radius + radius * sin(90 + i * 90 / steps)]];
    bottom_left_arc = [for (i = [0 : steps])
        [radius + radius * cos(180 + i * 90 / steps),
         radius + radius * sin(180 + i * 90 / steps)]];
    profile = rounded_side == "right"
        ? concat([[0, 0], [width - radius, 0]],
                 bottom_right_arc, top_right_arc, [[0, height]])
        : concat([[radius, 0], [width, 0], [width, height],
                  [radius, height]], top_left_arc, bottom_left_arc);

    assert(radius <= width && 2 * radius <= height,
           "Rounded tab radius is too large");

    // Extrude toward -Y with both corners rounded on only the selected side.
    rotate([90, 0, 0])
        linear_extrude(height = depth)
            polygon(profile);
}

module rounded_top_wall(width, depth, height, radius,
                        round_left = false, round_right = false) {
    steps = 30;
    right_arc = [for (i = [0 : steps])
        [width - radius + radius * cos(i * 90 / steps),
         height - radius + radius * sin(i * 90 / steps)]];
    left_arc = [for (i = [0 : steps])
        [radius + radius * cos(90 + i * 90 / steps),
         height - radius + radius * sin(90 + i * 90 / steps)]];
    profile = round_left && round_right
        ? concat([[0, 0], [width, 0]], right_arc,
                 [[radius, height]], left_arc)
        : round_right
        ? concat([[0, 0], [width, 0]], right_arc, [[0, height]])
        : round_left
            ? concat([[0, 0], [width, 0], [width, height],
                      [radius, height]], left_arc)
            : [[0, 0], [width, 0], [width, height], [0, height]];

    assert(radius <= height &&
           (round_left && round_right ? radius <= width / 2
                                      : radius <= width),
           "Rounded wall corner radius is too large");

    // Extrude toward -Y using a one-sided rounded X/Z profile.
    rotate([90, 0, 0])
        linear_extrude(height = depth)
            polygon(profile);
}

module side_mount() {
    difference() {
        union() {
            difference() {
                union() {
                    rail();
                    front_stop_wall();
                    rear_plate_stop();
                }
                // Continue the rounded lower edge through the front stopper.
                front_bottom_rounding_cutout();
            }
            // Join the square-cornered holders before applying the shared
            // rear Y/Z curve through holder, wall, and stopper.
            continuous_bottom_support();
            bottom_support_pads();
        }
        rear_bottom_rounding_cutout();
    }
}

module left_side() {
    side_mount();
}

module right_side() {
    translate([rail_origin_spacing, 0, 0])
        mirror([1, 0, 0]) side_mount();
}

module bottom_plate() {
    difference() {
        bottom_plate_blank();
        // Retain the tuned global opening positions and clip them naturally
        // to the 151 × 150 mm loose plate.
        transverse_vent_cutout();
        rear_transverse_vent_cutout();
        center_plate_cutout();
    }
}

module bottom_plate_print() {
    // Isolate the loose plate and place its lower-left-bottom corner at zero.
    translate([-bottom_plate_x, -bottom_plate_y, -bottom_plate_z])
        bottom_plate();
}

module left_side_wall_print() {
    // Put the broad outside face of the side wall on the build plate.
    translate([side_wall_feature_top_z, front_stop_thickness, 0])
        rotate([0, -90, 0])
            left_side();
}

module right_side_wall_print() {
    // Normalize the mirrored side locally, then put its outside wall face down.
    translate([0, front_stop_thickness, 0])
        rotate([0, 90, 0])
            mirror([1, 0, 0])
                side_mount();
}

module print_layout() {
    side_wall_print_length = rail_length + front_stop_thickness;
    side_wall_print_width = side_wall_feature_top_z;
    right_column_x = bottom_plate_width + print_layout_gap;
    top_row_y = side_wall_print_length + print_layout_gap;
    layout_width = max(
        bottom_plate_width,
        right_column_x + side_wall_print_width,
        side_wall_print_length);
    layout_depth = max(
        bottom_plate_depth,
        side_wall_print_length,
        top_row_y + side_wall_print_width);

    assert(layout_width <= print_bed_width &&
           layout_depth <= print_bed_depth,
           str("Print layout is ", layout_width, " × ", layout_depth,
               " mm and exceeds the ", print_bed_width, " × ",
               print_bed_depth, " mm build plate"));
    echo(str("Print layout footprint: ", layout_width, " × ",
             layout_depth, " mm"));

    // Plate in the lower-left corner. Both side walls lie on their broad
    // outside faces; the upper wall is turned 90 degrees for compact packing.
    bottom_plate_print();
    translate([right_column_x, 0, 0])
        left_side_wall_print();
    translate([side_wall_print_length, top_row_y, 0])
        rotate([0, 0, 90])
            right_side_wall_print();
}

module assembly() {
    // Three disconnected components shown in their installed positions.
    left_side();
    right_side();
    bottom_plate();
}

// Backward-compatible name for older demo/export files.
module tray() {
    assembly();
}

module device_mockup(bottom_model = "gx10") {
    device_x = bottom_plate_x + width_clearance;
    // Tiny demo-only overlap avoids a false visual gap between coplanar faces.
    device_y = -device_demo_stop_overlap;

    echo(str("Demo device (", bottom_model, "): ", device_width, " × ",
             device_depth, " × ", device_height, " mm"));
    echo(str("Bottom plate: ", bottom_plate_width, " mm wide (",
             width_clearance, " mm device margin per side); mount pocket: ",
             device_pocket_width, " × ", device_pocket_depth,
             " mm; demo leaves ",
             device_pocket_depth - device_depth + device_demo_stop_overlap,
             " mm behind device"));
    color([0.10, 0.11, 0.12])
        translate([device_x, device_y, device_support_z])
            cube([device_width, device_depth, device_height]);

    // Demo-only pixel projection generated from the selected underside photo.
    translate([device_x, device_y, device_support_z - 0.01])
        if (bottom_model == "nvidia")
            nvidia_dgx_spark_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);
        else if (bottom_model == "gigabyte")
            gigabyte_top_ai_nano_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);
        else if (bottom_model == "msi")
            msi_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);
        else if (bottom_model == "acer")
            acer_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);
        else if (bottom_model == "lenovo")
            lenovo_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);
        else
            asus_gx10_bottom_projection(
                device_width, device_depth,
                device_bottom_projection_thickness);

    // Keep the red outlet-alignment cue visible below the photo projection.
    color([0.9, 0.03, 0.03])
        translate([device_x + (device_width - device_vent_width) / 2,
                   device_y + device_vent_front_offset,
                   device_support_z - device_bottom_projection_thickness -
                   device_vent_marker_thickness - 0.01])
            cube([device_vent_width, device_vent_depth,
                  device_vent_marker_thickness]);
}

module demo(bottom_model = "gx10") {
    assembly();
    device_mockup(bottom_model);
}

if (selected_part == "print_layout") {
    print_layout();
} else if (selected_part == "bottom_plate_print") {
    bottom_plate_print();
} else if (selected_part == "bottom_plate") {
    bottom_plate();
} else if (selected_part == "left_side" ||
           selected_part == "left_rail") {
    left_side();
} else if (selected_part == "right_side" ||
           selected_part == "right_rail") {
    right_side();
} else if (selected_part == "assembly" || selected_part == "tray") {
    assembly();
} else if (selected_part == "demo-nvidia") {
    demo("nvidia");
} else if (selected_part == "demo-gigabyte") {
    demo("gigabyte");
} else if (selected_part == "demo-msi") {
    demo("msi");
} else if (selected_part == "demo-acer") {
    demo("acer");
} else if (selected_part == "demo-lenovo") {
    demo("lenovo");
} else if (selected_part == "demo-gx10" || selected_part == "demo") {
    demo("gx10");
} else {
    echo(str("Unknown part_override: ", selected_part));
    assembly();
}
