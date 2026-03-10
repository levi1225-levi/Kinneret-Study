// ============================================================
// Passover Matzah Napkin Ring - Flat Silhouette Style
// A flat matzah (unleavened bread) shape with the napkin ring
// hole in the center. Features realistic perforations, score
// lines dividing it into sections, and slightly irregular
// organic edges like real handmade matzah.
// Print flat on bed, no supports needed. ~5mm thick.
// ============================================================

$fn = 200;

// --- Core Parameters ---
ring_hole_r = 19;          // napkin hole radius (38mm diameter)
thickness = 5;             // main body thickness
relief_h = 0.8;            // raised score line height
score_depth = 1.0;         // score line depth from top

// Matzah dimensions
matzah_w = 58;             // width
matzah_h = 52;             // height
corner_r = 5;              // corner rounding

// Perforation parameters
perf_r = 1.1;              // perforation hole radius
perf_rows = 7;
perf_cols = 8;
perf_spacing_x = 6.2;
perf_spacing_y = 6.0;

// Score line parameters
num_h_scores = 3;          // horizontal score lines
num_v_scores = 3;          // vertical score lines
score_line_w = 0.8;        // width of score lines

// Edge irregularity
edge_bumps = 30;           // number of bumps on edge
bump_amplitude = 1.2;      // how bumpy the edge is

// --- Organic irregular matzah outline (2D) ---
module matzah_outline_2d() {
    // Start with a rounded rectangle, then add irregularity
    // We build it from a hull of circles placed with slight offsets

    // Base rounded rectangle with organic bumps
    offset(r = 2)
    offset(r = -2)  // smooth any sharp corners
    difference() {
        union() {
            // Core rounded rectangle
            offset(r = corner_r)
                square([matzah_w - 2 * corner_r, matzah_h - 2 * corner_r], center = true);

            // Organic edge bumps for "handmade" feel
            for (i = [0:edge_bumps - 1]) {
                angle = i * 360 / edge_bumps;
                // Distribute bumps along the rectangular perimeter
                px = (matzah_w / 2 + bump_amplitude * 0.5) * cos(angle);
                py = (matzah_h / 2 + bump_amplitude * 0.5) * sin(angle);
                // Clamp to edge
                cx = max(-matzah_w / 2 - bump_amplitude, min(matzah_w / 2 + bump_amplitude, px));
                cy = max(-matzah_h / 2 - bump_amplitude, min(matzah_h / 2 + bump_amplitude, py));
                amplitude = bump_amplitude * (0.5 + 0.5 * sin(i * 137.5));
                translate([cx, cy])
                    circle(r = amplitude + 1.5);
            }
        }
        // Nothing to subtract from outline
    }
}

// --- Perforation holes grid (2D) ---
module perforations_2d() {
    // Offset grid of holes, avoiding the center ring hole
    for (row = [0:perf_rows - 1]) {
        for (col = [0:perf_cols - 1]) {
            x = (col - (perf_cols - 1) / 2) * perf_spacing_x;
            y = (row - (perf_rows - 1) / 2) * perf_spacing_y;

            // Offset every other row
            x_off = x + (row % 2) * perf_spacing_x * 0.5;

            // Only place if outside the ring hole (with margin)
            dist = sqrt(x_off * x_off + y * y);
            if (dist > ring_hole_r + 3 && dist < matzah_w / 2 - 4) {
                translate([x_off, y])
                    circle(r = perf_r);
            }
        }
    }
}

// --- Score lines (2D) - dividing lines across the matzah ---
module score_lines_h_2d() {
    // Horizontal score lines with slight waviness
    for (i = [1:num_h_scores]) {
        y_pos = -matzah_h / 2 + i * matzah_h / (num_h_scores + 1);

        // Build wavy line from small segments
        for (x = [-matzah_w / 2 + 3 : 1 : matzah_w / 2 - 3]) {
            wave = 0.3 * sin(x * 8 + i * 45);
            dist = sqrt(x * x + (y_pos + wave) * (y_pos + wave));

            // Skip where line would cross the ring hole
            if (dist > ring_hole_r + 2) {
                translate([x, y_pos + wave])
                    square([1.2, score_line_w], center = true);
            }
        }
    }
}

module score_lines_v_2d() {
    // Vertical score lines with slight waviness
    for (i = [1:num_v_scores]) {
        x_pos = -matzah_w / 2 + i * matzah_w / (num_v_scores + 1);

        for (y = [-matzah_h / 2 + 3 : 1 : matzah_h / 2 - 3]) {
            wave = 0.3 * sin(y * 8 + i * 60);
            dist = sqrt((x_pos + wave) * (x_pos + wave) + y * y);

            if (dist > ring_hole_r + 2) {
                translate([x_pos + wave, y])
                    square([score_line_w, 1.2], center = true);
            }
        }
    }
}

// --- Blistered/bubbly surface texture ---
module blister_texture_2d() {
    // Scattered small circles representing the bubbly surface
    // Using golden angle distribution for natural-looking scatter
    num_blisters = 60;
    for (i = [0:num_blisters - 1]) {
        angle = i * 137.508;
        r = 5 + sqrt(i) * 4.5;
        x = r * cos(angle);
        y = r * sin(angle) * 0.85; // slightly compressed vertically

        dist = sqrt(x * x + y * y);
        if (dist > ring_hole_r + 3.5 &&
            abs(x) < matzah_w / 2 - 4 &&
            abs(y) < matzah_h / 2 - 4) {
            blister_r = 0.8 + 0.6 * sin(i * 73);
            translate([x, y])
                circle(r = blister_r);
        }
    }
}

// --- Brown spots / bake marks (larger flat circles as relief) ---
module bake_marks_2d() {
    marks = [
        [-18, 14, 2.5], [15, -16, 3.0], [-20, -12, 2.2],
        [22, 10, 2.8], [-8, 20, 2.0], [10, 18, 1.8],
        [-15, -20, 2.4], [25, -5, 2.0], [-25, 5, 1.9]
    ];
    for (m = marks) {
        dist = sqrt(m[0] * m[0] + m[1] * m[1]);
        if (dist > ring_hole_r + 4) {
            translate([m[0], m[1]])
                circle(r = m[2]);
        }
    }
}

// --- Ring hole reinforcement rim (2D) ---
module ring_rim_2d() {
    difference() {
        circle(r = ring_hole_r + 2);
        circle(r = ring_hole_r);
    }
}

// ========================================
// ASSEMBLY
// ========================================

// Main matzah body
difference() {
    union() {
        // Base matzah slab
        linear_extrude(height = thickness)
        difference() {
            matzah_outline_2d();
            circle(r = ring_hole_r);
        }

        // Raised ring reinforcement rim
        translate([0, 0, thickness])
            linear_extrude(height = relief_h)
                ring_rim_2d();

        // Raised bake mark spots (subtle surface texture)
        translate([0, 0, thickness])
            linear_extrude(height = 0.4)
                intersection() {
                    bake_marks_2d();
                    difference() {
                        matzah_outline_2d();
                        circle(r = ring_hole_r + 2.5);
                    }
                }
    }

    // Cut perforations all the way through
    translate([0, 0, -1])
        linear_extrude(height = thickness + relief_h + 2)
            perforations_2d();

    // Cut score lines as channels from the top
    translate([0, 0, thickness - score_depth])
        linear_extrude(height = score_depth + relief_h + 1) {
            score_lines_h_2d();
            score_lines_v_2d();
        }
}

// Blister texture on bottom (very subtle raised dots)
translate([0, 0, 0])
    linear_extrude(height = 0.3)
        intersection() {
            blister_texture_2d();
            difference() {
                offset(r = -1) matzah_outline_2d();
                circle(r = ring_hole_r + 1);
            }
        }
