// ============================================================
// Passover Star of David Napkin Ring
// An elegant wide band with Star of David filigree cutouts,
// decorative bead borders, and proper structural framing.
// The stars are cleanly cut through the wall with thin
// bridging frames between them.
// Designed for FDM 3D printing (print upright, no supports).
// ============================================================

$fn = 120;

// --- Parameters ---
ring_inner_r = 21;
wall = 3.0;              // thicker wall for structural cutouts
ring_outer_r = ring_inner_r + wall;
band_height = 32;

// Star parameters
num_stars = 6;
star_size = 7.5;         // outer radius of star
star_line_w = 1.2;       // width of star outline (hollow star)

// Border parameters
border_h = 3.5;          // height of top/bottom decorative border
bead_r = 0.8;
num_beads = 40;

// --- Molded ring body with decorative profile ---
module ring_body() {
    rotate_extrude(convexity = 4)
    polygon(points = [
        // Inner wall
        [ring_inner_r, 0],
        // Bottom border - stepped profile
        [ring_outer_r + 0.8, 0],           // base lip
        [ring_outer_r + 0.8, 0.8],
        [ring_outer_r + 0.3, 1.2],
        [ring_outer_r + 0.3, border_h - 0.5],
        [ring_outer_r + 0.6, border_h],     // border top ridge
        [ring_outer_r, border_h + 0.3],
        // Main band
        [ring_outer_r, band_height - border_h - 0.3],
        // Top border
        [ring_outer_r + 0.6, band_height - border_h],
        [ring_outer_r + 0.3, band_height - border_h + 0.5],
        [ring_outer_r + 0.3, band_height - 1.2],
        [ring_outer_r + 0.8, band_height - 0.8],
        [ring_outer_r + 0.8, band_height],  // top lip
        [ring_inner_r, band_height]
    ]);
}

// --- Star of David 2D outline (hollow for filigree look) ---
module star_of_david_2d(size, line_w) {
    difference() {
        // Solid star
        star_of_david_solid(size);
        // Inner cutout (smaller star offset)
        star_of_david_solid(size - line_w * 1.8);
    }
}

module star_of_david_solid(size) {
    // Two overlapping equilateral triangles
    // Upward pointing
    polygon(points = [
        for (i = [0:2])
            [size * cos(90 + i * 120), size * sin(90 + i * 120)]
    ]);
    // Downward pointing
    polygon(points = [
        for (i = [0:2])
            [size * cos(-90 + i * 120), size * sin(-90 + i * 120)]
    ]);
}

// --- Full solid star for through-cutouts ---
module star_of_david_cutout_solid(size) {
    // Slightly oversized solid star for clean cuts
    polygon(points = [
        for (i = [0:2])
            [size * cos(90 + i * 120), size * sin(90 + i * 120)]
    ]);
    polygon(points = [
        for (i = [0:2])
            [size * cos(-90 + i * 120), size * sin(-90 + i * 120)]
    ]);
}

// --- Star cutout through the wall ---
module star_cutouts() {
    mid_z = band_height / 2;

    for (i = [0:num_stars - 1]) {
        angle = i * 360 / num_stars;
        rotate([0, 0, angle])
            translate([ring_outer_r + 1, 0, mid_z])
                rotate([0, 90, 0])
                    linear_extrude(height = wall + 3, center = true)
                        star_of_david_cutout_solid(star_size);
    }
}

// --- Star outline frames (raised on surface) ---
module star_frames() {
    mid_z = band_height / 2;

    for (i = [0:num_stars - 1]) {
        angle = i * 360 / num_stars;
        rotate([0, 0, angle])
            translate([ring_outer_r - 0.2, 0, mid_z])
                rotate([0, 90, 0])
                    linear_extrude(height = 0.8)
                        star_of_david_2d(star_size + 0.5, star_line_w);
    }
}

// --- Bead borders ---
module bead_border(z_pos) {
    for (i = [0:num_beads - 1]) {
        angle = i * 360 / num_beads;
        rotate([0, 0, angle])
            translate([ring_outer_r + 0.3, 0, z_pos])
                sphere(r = bead_r);
    }
}

// --- Decorative diamonds between stars ---
module inter_star_diamonds() {
    mid_z = band_height / 2;

    for (i = [0:num_stars - 1]) {
        angle = (i + 0.5) * 360 / num_stars;
        rotate([0, 0, angle])
            translate([ring_outer_r + 0.3, 0, mid_z])
                rotate([0, 90, 0])
                    linear_extrude(height = 0.6)
                        rotate([0, 0, 45])
                            square([3, 3], center = true);
    }
}

// --- Assembly ---
union() {
    difference() {
        ring_body();
        star_cutouts();
    }

    // Raised star outlines around the cutouts
    star_frames();

    // Bead borders
    bead_border(border_h / 2);
    bead_border(band_height - border_h / 2);

    // Small diamonds between stars
    inter_star_diamonds();
}
