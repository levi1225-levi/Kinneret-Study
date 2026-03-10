// ============================================================
// Passover Seder Plate Napkin Ring
// An elegant band with molded profile edges and 6 raised
// medallion panels, each containing a symbol for a seder item.
// Designed for FDM 3D printing (print upright, no supports).
// ============================================================

$fn = 120;

// --- Parameters ---
ring_inner_r = 21;      // inner radius (~42mm ID for rolled napkin)
wall = 2.5;             // wall thickness
ring_outer_r = ring_inner_r + wall;
band_height = 28;       // main band height

// Molding profile parameters
bevel = 1.2;            // edge bevel size
lip = 0.8;              // decorative lip protrusion

// Medallion parameters
num_medallions = 6;
medallion_w = 10;       // angular width in degrees mapped to size
medallion_h = 14;
medallion_depth = 1.0;  // raised from surface
frame_w = 1.0;

// --- Molded ring body ---
// Cross-section profile for rotate_extrude: a band with
// classical molding at top and bottom edges
module ring_profile() {
    // Main body with beveled edges and a decorative lip
    polygon(points = [
        [ring_inner_r, 0],
        [ring_outer_r - bevel, 0],
        [ring_outer_r, bevel],
        [ring_outer_r + lip, bevel + 0.5],      // lower lip
        [ring_outer_r + lip, bevel + 1.5],
        [ring_outer_r, bevel + 2.0],
        [ring_outer_r, band_height - bevel - 2.0],
        [ring_outer_r + lip, band_height - bevel - 1.5],  // upper lip
        [ring_outer_r + lip, band_height - bevel - 0.5],
        [ring_outer_r, band_height - bevel],
        [ring_outer_r - bevel, band_height],
        [ring_inner_r, band_height]
    ]);
}

module ring_body() {
    rotate_extrude(convexity = 4)
        ring_profile();
}

// --- Decorative bead border ---
module bead_border(z_pos, num_beads = 36) {
    bead_r = 0.7;
    for (i = [0:num_beads - 1]) {
        angle = i * 360 / num_beads;
        rotate([0, 0, angle])
            translate([ring_outer_r + lip + bead_r * 0.3, 0, z_pos])
                sphere(r = bead_r);
    }
}

// --- Raised medallion panel ---
module medallion_panel(angle_pos) {
    rotate([0, 0, angle_pos])
    translate([ring_outer_r + 0.5, 0, band_height / 2]) {
        // Outer frame - rounded rectangle
        rotate([0, 90, 0])
            linear_extrude(height = medallion_depth + 0.3)
                offset(r = 1.2)
                    square([medallion_h - 2.4, medallion_w - 2.4], center = true);
        // Inner recessed area
        rotate([0, 90, 0])
            translate([0, 0, 0.6])
                linear_extrude(height = medallion_depth)
                    offset(r = 0.8)
                        square([medallion_h - 4, medallion_w - 4], center = true);
    }
}

// --- Seder item symbols (simplified 2D for embossing) ---

// Egg (beitzah) - oval
module symbol_egg() {
    scale([1, 1.3]) circle(r = 2.2);
}

// Bone (zeroa) - elongated shape
module symbol_bone() {
    hull() {
        translate([-3, 0]) circle(r = 1.2);
        translate([3, 0]) circle(r = 1.2);
    }
    // Bone knobs
    translate([-3.5, 0]) circle(r = 1.6);
    translate([3.5, 0]) circle(r = 1.6);
}

// Herbs (maror) - leaf shape
module symbol_leaf() {
    intersection() {
        translate([-1.5, 0]) circle(r = 3.5);
        translate([1.5, 0]) circle(r = 3.5);
    }
    // Stem
    translate([0, -3.5]) square([0.6, 2], center = true);
}

// Charoset - apple/circle with line
module symbol_apple() {
    circle(r = 2.5);
    // Stem
    translate([0, 2.5]) square([0.6, 1.5], center = true);
    // Leaf
    translate([0.8, 3.5])
        scale([0.5, 1])
            circle(r = 1);
}

// Karpas (vegetable) - simple sprig
module symbol_sprig() {
    // Stem
    square([0.6, 6], center = true);
    // Leaves
    for (side = [-1, 1]) {
        for (h = [-1.5, 0, 1.5]) {
            translate([side * 0.3, h])
                rotate([0, 0, side * 35])
                    scale([0.5, 1])
                        circle(r = 1.5);
        }
    }
}

// Matzah - square with dots
module symbol_matzah() {
    square([5, 4.5], center = true);
    // Perforations
    for (x = [-1.2, 0, 1.2])
        for (y = [-0.8, 0.8])
            translate([x, y]) circle(r = 0.4);
}

// --- Emboss symbols onto medallions ---
module embossed_symbol(angle_pos, symbol_index) {
    rotate([0, 0, angle_pos])
    translate([ring_outer_r + medallion_depth + 0.8, 0, band_height / 2])
    rotate([0, 90, 0])
    linear_extrude(height = 0.6) {
        if (symbol_index == 0) symbol_egg();
        if (symbol_index == 1) symbol_bone();
        if (symbol_index == 2) symbol_leaf();
        if (symbol_index == 3) symbol_apple();
        if (symbol_index == 4) symbol_sprig();
        if (symbol_index == 5) symbol_matzah();
    }
}

// --- Assembly ---
union() {
    ring_body();

    // Bead borders
    bead_border(bevel + 2.5);
    bead_border(band_height - bevel - 2.5);

    // Medallions with symbols
    for (i = [0:num_medallions - 1]) {
        angle = i * 360 / num_medallions;
        medallion_panel(angle);
        embossed_symbol(angle, i);
    }
}
