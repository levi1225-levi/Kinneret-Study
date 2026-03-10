// ============================================================
// Passover Star of David Napkin Ring - Flat Silhouette Style
// A large Star of David (hexagram) outline as the flat shape,
// with the napkin ring hole in the center hexagonal area.
// Features intricate filigree patterns within the triangle
// sections, decorative borders, and fine geometric details.
// Print flat on bed, no supports needed. ~5mm thick.
// ============================================================

$fn = 200;

// --- Core Parameters ---
ring_hole_r = 19;          // napkin hole radius (38mm diameter)
thickness = 5;             // main body thickness
relief_h = 1.0;            // raised detail height

// Star dimensions
star_outer_r = 42;         // outer radius of star points
star_inner_r = 24;         // inner hexagon radius (where triangles meet)
frame_width = 4;           // width of the star frame/outline
point_rounding = 1.5;      // rounding on star points

// --- Star of David outline (2D) ---
// Two overlapping equilateral triangles forming a hexagram

module triangle_2d(r) {
    polygon(points = [
        for (i = [0:2])
            [r * cos(90 + i * 120), r * sin(90 + i * 120)]
    ]);
}

module hexagram_solid_2d(r) {
    triangle_2d(r);
    rotate(60) triangle_2d(r);
}

module hexagram_outline_2d(outer_r, width) {
    difference() {
        offset(r = point_rounding)
        offset(r = -point_rounding)
            hexagram_solid_2d(outer_r);

        offset(r = point_rounding)
        offset(r = -point_rounding)
            hexagram_solid_2d(outer_r - width * 1.6);
    }
}

// --- Inner hexagonal border around ring hole ---
module inner_hex_border_2d() {
    difference() {
        circle(r = ring_hole_r + 3, $fn = 6);
        circle(r = ring_hole_r);
    }
}

// --- Filigree patterns inside the triangle arms ---
// Each of the 6 triangle "arms" gets a decorative pattern

module arm_filigree_2d(arm_length, arm_width) {
    // Diamond chain pattern
    num_diamonds = 3;
    spacing = arm_length / (num_diamonds + 1);

    for (i = [1:num_diamonds]) {
        d_size = arm_width * 0.35 * (1 - i * 0.15);
        translate([0, i * spacing])
            rotate(45)
                square([d_size, d_size], center = true);
    }

    // Connecting line
    square([0.6, arm_length * 0.8], center = true);
    translate([0, arm_length * 0.4])
        square([0.6, arm_length * 0.8], center = true);
}

module all_arm_filigrees_2d() {
    arm_length = star_outer_r - star_inner_r - frame_width;
    arm_width = frame_width;

    for (i = [0:5]) {
        angle = i * 60 + 30;
        arm_r = (star_inner_r + star_outer_r) / 2;
        rotate(angle)
            translate([0, arm_r - 2])
                arm_filigree_2d(arm_length * 0.6, arm_width);
    }
}

// --- Decorative dots at star points ---
module point_dots_2d() {
    dot_r = 1.0;
    for (i = [0:5]) {
        angle = i * 60 + 90;
        r = star_outer_r - frame_width - 1;
        translate([r * cos(angle), r * sin(angle)])
            circle(r = dot_r);
    }
}

// --- Decorative dots at inner hex vertices ---
module hex_vertex_dots_2d() {
    dot_r = 0.8;
    for (i = [0:5]) {
        angle = i * 60;
        r = ring_hole_r + 4.5;
        translate([r * cos(angle), r * sin(angle)])
            circle(r = dot_r);
    }
}

// --- Small Stars of David at each point ---
module mini_star_2d(size) {
    hexagram_solid_2d(size);
}

module point_mini_stars_2d() {
    for (i = [0:5]) {
        angle = i * 60 + 90;
        r = star_outer_r - frame_width * 1.5 - 2;
        translate([r * cos(angle), r * sin(angle)])
            mini_star_2d(2.2);
    }
}

// --- Ornamental curves in the concave sections between points ---
module concave_ornaments_2d() {
    for (i = [0:5]) {
        angle = i * 60 + 60;
        r = star_inner_r + 1;
        translate([r * cos(angle), r * sin(angle)])
            rotate(angle)
                ornament_scroll_2d(5);
    }
}

module ornament_scroll_2d(size) {
    // Small scroll/flourish
    difference() {
        circle(r = size * 0.4);
        circle(r = size * 0.25);
        translate([-size, 0])
            square([size * 2, size], center = false);
    }
    mirror([0, 1, 0])
    difference() {
        circle(r = size * 0.4);
        circle(r = size * 0.25);
        translate([-size, 0])
            square([size * 2, size], center = false);
    }
}

// --- Outer border ring of tiny dots ---
module outer_dot_ring_2d() {
    num_dots = 48;
    for (i = [0:num_dots - 1]) {
        angle = i * 360 / num_dots;
        // Place dots just outside the inner hexagon
        r = star_inner_r - 1;
        translate([r * cos(angle), r * sin(angle)])
            circle(r = 0.4);
    }
}

// --- Inner dot ring around napkin hole ---
module inner_dot_ring_2d() {
    num_dots = 30;
    for (i = [0:num_dots - 1]) {
        angle = i * 360 / num_dots;
        r = ring_hole_r + 1.5;
        translate([r * cos(angle), r * sin(angle)])
            circle(r = 0.35);
    }
}

// --- Connecting bridges between star frame and inner hex ---
module bridges_2d() {
    for (i = [0:5]) {
        angle = i * 60;
        // Radial bridge
        rotate(angle)
            translate([0, ring_hole_r + 3])
                square([1.5, star_inner_r - ring_hole_r - frame_width + 1], center = false);
    }
}

// ========================================
// ASSEMBLY
// ========================================

// Main star body
difference() {
    union() {
        // Base star slab
        linear_extrude(height = thickness)
        difference() {
            union() {
                hexagram_outline_2d(star_outer_r, frame_width);
                inner_hex_border_2d();
                bridges_2d();
            }
            // Napkin ring hole
            circle(r = ring_hole_r);
        }

        // Raised details on top face

        // Mini stars at points
        translate([0, 0, thickness])
            linear_extrude(height = relief_h)
                intersection() {
                    point_mini_stars_2d();
                    hexagram_solid_2d(star_outer_r - 1);
                }

        // Filigree in arms
        translate([0, 0, thickness])
            linear_extrude(height = relief_h * 0.8)
                intersection() {
                    all_arm_filigrees_2d();
                    difference() {
                        hexagram_solid_2d(star_outer_r - 2);
                        hexagram_solid_2d(star_outer_r - frame_width * 1.6 - 1);
                    }
                }

        // Dot decorations
        translate([0, 0, thickness])
            linear_extrude(height = relief_h * 0.7) {
                point_dots_2d();
                hex_vertex_dots_2d();
                outer_dot_ring_2d();
                inner_dot_ring_2d();
            }

        // Concave ornaments
        translate([0, 0, thickness])
            linear_extrude(height = relief_h * 0.6)
                concave_ornaments_2d();

        // Raised ring hole rim
        translate([0, 0, thickness])
            linear_extrude(height = relief_h) {
                difference() {
                    circle(r = ring_hole_r + 1.5);
                    circle(r = ring_hole_r);
                }
            }
    }

    // Clean napkin hole
    translate([0, 0, -1])
        cylinder(r = ring_hole_r, h = thickness + relief_h + 2);
}
