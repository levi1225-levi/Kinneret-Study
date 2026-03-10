// ============================================================
// Passover Seder Plate Napkin Ring - Flat Silhouette Style
// A flat circular seder plate shape with the napkin ring hole
// in the center. Six symbolic food items are arranged around
// the rim as raised relief details. Scalloped decorative edge.
// Print flat on bed, no supports needed. ~5mm thick.
// ============================================================

$fn = 200;

// --- Core Parameters ---
ring_hole_r = 19;          // napkin hole radius (38mm diameter)
plate_r = 38;              // outer plate radius
thickness = 5;             // main body thickness
relief_h = 1.2;            // raised detail height above surface
rim_width = 4;             // decorative rim width
scallop_count = 24;        // number of scallops on rim
scallop_depth = 1.5;       // how deep each scallop indentation is

// Inner ring wall minimum
ring_wall = 8;             // minimum material around the hole

// --- Helper: Smooth 2D egg shape ---
module egg_2d(w, h) {
    // Egg shape using hull of offset circles
    hull() {
        translate([0, h * 0.15])
            scale([1, 1.2]) circle(r = w / 2);
        translate([0, -h * 0.2])
            scale([1, 0.8]) circle(r = w / 2 * 0.85);
    }
}

// --- Helper: Leaf shape ---
module leaf_2d(length, width) {
    // Pointed at both ends, widest in middle
    hull() {
        translate([0, length / 2 - 0.3]) circle(r = 0.3);
        translate([0, 0]) scale([1, 1.5]) circle(r = width / 2);
        translate([0, -length / 2 + 0.3]) circle(r = 0.3);
    }
}

// --- Helper: Bone shape (zeroa) ---
module bone_2d(length, knob_r) {
    // Shaft
    translate([0, 0])
        square([knob_r * 0.6, length], center = true);
    // Top knob - two bumps
    translate([0, length / 2]) {
        hull() {
            translate([-knob_r * 0.5, 0]) circle(r = knob_r * 0.7);
            translate([knob_r * 0.5, 0]) circle(r = knob_r * 0.7);
        }
    }
    // Bottom knob - two bumps
    translate([0, -length / 2]) {
        hull() {
            translate([-knob_r * 0.4, 0]) circle(r = knob_r * 0.6);
            translate([knob_r * 0.4, 0]) circle(r = knob_r * 0.6);
        }
    }
}

// --- Helper: Apple/Charoset shape ---
module apple_2d(r) {
    // Apple body - two overlapping circles for the dimpled top
    hull() {
        translate([-r * 0.3, r * 0.1]) circle(r = r * 0.85);
        translate([r * 0.3, r * 0.1]) circle(r = r * 0.85);
        translate([0, -r * 0.3]) circle(r = r * 0.75);
    }
    // Stem
    translate([0, r * 0.85])
        square([0.5, r * 0.5], center = true);
    // Small leaf
    translate([r * 0.3, r * 1.0])
        rotate(30)
            leaf_2d(r * 0.7, r * 0.35);
}

// --- Helper: Herb/Maror leaf cluster ---
module maror_2d(size) {
    // Central leaf
    leaf_2d(size * 1.4, size * 0.5);
    // Left leaf
    translate([-size * 0.3, -size * 0.1])
        rotate(25)
            leaf_2d(size * 1.1, size * 0.4);
    // Right leaf
    translate([size * 0.3, -size * 0.1])
        rotate(-25)
            leaf_2d(size * 1.1, size * 0.4);
    // Small stem
    translate([0, -size * 0.7])
        square([0.5, size * 0.3], center = true);
}

// --- Helper: Celery/Karpas sprig ---
module karpas_2d(size) {
    // Main stem
    square([0.6, size * 1.8], center = true);
    // Leaves along stem
    for (i = [0:3]) {
        y_pos = size * 0.6 - i * size * 0.35;
        side = (i % 2 == 0) ? 1 : -1;
        translate([side * 0.3, y_pos])
            rotate(side * -30)
                leaf_2d(size * 0.7, size * 0.3);
    }
    // Top leaves
    translate([0, size * 0.9])
        leaf_2d(size * 0.5, size * 0.25);
}

// --- Helper: Matzah square ---
module matzah_2d(size) {
    // Slightly rounded square
    offset(r = 0.8)
        square([size - 1.6, size * 0.85 - 1.6], center = true);
    // Perforations - grid of small circles
    // (these will be cut out)
}

module matzah_perforations(size) {
    spacing = size / 5;
    for (x = [-2:2])
        for (y = [-1:1])
            translate([x * spacing, y * spacing * 0.85])
                circle(r = 0.5);
}

// --- Scalloped plate edge (2D) ---
module scalloped_circle_2d(r, n, depth) {
    difference() {
        circle(r = r);
        for (i = [0:n - 1]) {
            angle = i * 360 / n;
            translate([r * cos(angle), r * sin(angle)])
                circle(r = depth);
        }
    }
}

// --- Main plate outline (2D) ---
module plate_outline_2d() {
    difference() {
        // Outer scalloped edge
        scalloped_circle_2d(plate_r, scallop_count, scallop_depth);
        // Inner napkin hole
        circle(r = ring_hole_r);
    }
}

// --- Decorative rim ring (2D) ---
module rim_ring_2d() {
    difference() {
        circle(r = plate_r - 2);
        circle(r = plate_r - rim_width);
    }
}

// --- Inner decorative ring around hole ---
module inner_rim_2d() {
    difference() {
        circle(r = ring_hole_r + 3);
        circle(r = ring_hole_r);
    }
}

// --- Dot border pattern (2D) ---
module dot_border_2d(r, num_dots, dot_r) {
    for (i = [0:num_dots - 1]) {
        angle = i * 360 / num_dots;
        translate([r * cos(angle), r * sin(angle)])
            circle(r = dot_r);
    }
}

// --- Place seder items around the plate ---
// Items are placed at radius between hole and rim
item_r = (ring_hole_r + plate_r) / 2 + 1;  // radius for item placement
item_scale = 0.85;  // scale factor for items

module seder_items_2d() {
    // 0° - Egg (Beitzah) - top
    translate([item_r * cos(90), item_r * sin(90)])
        scale([item_scale, item_scale])
            egg_2d(5, 6.5);

    // 60° - Bone (Zeroa) - upper right
    translate([item_r * cos(30), item_r * sin(30)])
        rotate(-30)
            scale([item_scale, item_scale])
                bone_2d(8, 1.8);

    // 120° - Maror (Bitter Herbs) - lower right
    translate([item_r * cos(-30), item_r * sin(-30)])
        scale([item_scale, item_scale])
            maror_2d(3.5);

    // 180° - Charoset (Apple) - bottom
    translate([item_r * cos(-90), item_r * sin(-90)])
        scale([item_scale, item_scale])
            apple_2d(3.2);

    // 240° - Karpas (Celery/Parsley) - lower left
    translate([item_r * cos(210), item_r * sin(210)])
        scale([item_scale, item_scale])
            karpas_2d(3.5);

    // 300° - Matzah - upper left
    translate([item_r * cos(150), item_r * sin(150)])
        scale([item_scale, item_scale])
            matzah_2d(7);
}

module seder_item_cutouts_2d() {
    // Only matzah has perforations to cut
    translate([item_r * cos(150), item_r * sin(150)])
        scale([item_scale, item_scale])
            matzah_perforations(7);
}

// --- Divider lines between items ---
module divider_lines_2d() {
    for (i = [0:5]) {
        angle = i * 60 + 0;
        rotate(angle)
            translate([ring_hole_r + 4, -0.3])
                square([plate_r - ring_hole_r - rim_width - 5, 0.6]);
    }
}

// ========================================
// ASSEMBLY
// ========================================

// Main plate body
linear_extrude(height = thickness)
    plate_outline_2d();

// Raised decorative rim
translate([0, 0, thickness])
    linear_extrude(height = relief_h)
        rim_ring_2d();

// Raised inner rim around napkin hole
translate([0, 0, thickness])
    linear_extrude(height = relief_h)
        inner_rim_2d();

// Raised dot border
translate([0, 0, thickness])
    linear_extrude(height = relief_h * 0.8) {
        dot_border_2d(plate_r - rim_width - 1.5, 36, 0.6);
        dot_border_2d(ring_hole_r + 4, 24, 0.5);
    }

// Raised seder item symbols
difference() {
    translate([0, 0, thickness])
        linear_extrude(height = relief_h)
            seder_items_2d();
    // Cut matzah perforations through the relief
    translate([0, 0, thickness - 0.1])
        linear_extrude(height = relief_h + 0.2)
            seder_item_cutouts_2d();
}

// Raised divider lines
translate([0, 0, thickness])
    linear_extrude(height = relief_h * 0.5)
        divider_lines_2d();

// Bottom side mirror: subtle rim detail
translate([0, 0, 0])
    linear_extrude(height = relief_h * 0.6)
        rim_ring_2d();

translate([0, 0, 0])
    linear_extrude(height = relief_h * 0.6)
        inner_rim_2d();
