// ============================================================
// Passover Matzah Napkin Ring
// A textured band that mimics the look of matzah (unleavened
// bread) with realistic dimple perforations, score line channels,
// and slightly organic wavy edges like torn flatbread.
// Designed for FDM 3D printing (print upright, no supports).
// ============================================================

$fn = 120;

// --- Parameters ---
ring_inner_r = 21;
wall = 3.0;             // slightly thicker to accommodate texture
ring_outer_r = ring_inner_r + wall;
band_height = 26;

// Texture parameters
dimple_r = 0.9;         // perforation dimple radius
dimple_depth = 1.2;     // how deep dimples go (not through-holes)
dimple_rows = 5;
dimple_cols = 28;

score_depth = 0.6;      // score line channel depth
score_width = 0.5;
num_score_lines = 3;

wave_amplitude = 1.5;   // edge waviness
wave_freq = 8;          // number of waves around circumference

// --- Wavy-edged ring body ---
// Creates a ring with organic wavy top and bottom edges
module wavy_ring() {
    num_slices = 180;
    step = 360 / num_slices;

    difference() {
        union() {
            for (i = [0:num_slices - 1]) {
                a1 = i * step;
                a2 = (i + 1) * step;

                // Wavy top edge
                top1 = band_height + wave_amplitude * sin(a1 * wave_freq);
                top2 = band_height + wave_amplitude * sin(a2 * wave_freq);
                // Wavy bottom edge
                bot1 = -wave_amplitude * sin(a1 * wave_freq + 45);
                bot2 = -wave_amplitude * sin(a2 * wave_freq + 45);

                hull() {
                    rotate([0, 0, a1])
                        translate([ring_inner_r + wall / 2, 0, 0])
                            cylinder(r = wall / 2, h = max(0.01, top1 - bot1));

                    rotate([0, 0, a2])
                        translate([ring_inner_r + wall / 2, 0, 0])
                            cylinder(r = wall / 2, h = max(0.01, top2 - bot2));
                }
            }
        }
        // Hollow out the inside
        translate([0, 0, -wave_amplitude - 1])
            cylinder(r = ring_inner_r, h = band_height + 4 * wave_amplitude + 2);
    }
}

// --- Simpler approach: cylinder with wavy trim ---
module matzah_body() {
    difference() {
        // Base cylinder
        cylinder(r = ring_outer_r, h = band_height);

        // Hollow interior
        translate([0, 0, -1])
            cylinder(r = ring_inner_r, h = band_height + 2);

        // Wavy top trim
        for (i = [0:359]) {
            wave_z = band_height - wave_amplitude + wave_amplitude * sin(i * wave_freq);
            rotate([0, 0, i])
                translate([ring_inner_r - 1, -0.5, wave_z])
                    cube([wall + 2, 1, wave_amplitude * 2 + 1]);
        }

        // Wavy bottom trim
        for (i = [0:359]) {
            wave_z = wave_amplitude * sin(i * wave_freq + 180);
            rotate([0, 0, i])
                translate([ring_inner_r - 1, -0.5, -wave_amplitude - 0.5])
                    cube([wall + 2, 1, wave_amplitude + 0.5 + max(0, wave_z)]);
        }
    }
}

// --- Dimple perforations (indentations, not through-holes) ---
module dimple_grid() {
    for (row = [0:dimple_rows - 1]) {
        z_pos = 4 + row * (band_height - 8) / max(1, dimple_rows - 1);
        for (col = [0:dimple_cols - 1]) {
            angle = col * 360 / dimple_cols + (row % 2) * (180 / dimple_cols);
            rotate([0, 0, angle])
                translate([ring_outer_r - dimple_depth + 0.3, 0, z_pos])
                    rotate([0, 90, 0])
                        cylinder(r1 = dimple_r, r2 = dimple_r * 0.3,
                                 h = dimple_depth);
        }
    }
}

// --- Score line channels ---
module score_lines() {
    for (i = [0:num_score_lines - 1]) {
        z_pos = 3 + (i + 0.5) * (band_height - 6) / num_score_lines;
        difference() {
            // Slightly larger cylinder to cut into outer surface
            cylinder(r = ring_outer_r + 0.1, h = score_width, $fn = 120);
            // Remove inner portion (keep only outer shell cut)
            cylinder(r = ring_outer_r - score_depth, h = score_width + 1, $fn = 120);
            // Also keep interior clear
            translate([0, 0, -0.5])
                cylinder(r = ring_inner_r + 0.5, h = score_width + 1);
        }
    }
}

// --- Light surface grain texture ---
module grain_bumps() {
    // Small random-looking bumps for bread texture
    for (i = [0:80]) {
        // Pseudo-random placement using modular arithmetic
        angle = (i * 137.5) % 360;  // golden angle distribution
        z = 2 + ((i * 7 + 3) % (band_height - 4));
        bump_r = 0.3 + (i % 3) * 0.15;

        rotate([0, 0, angle])
            translate([ring_outer_r - 0.1, 0, z])
                sphere(r = bump_r);
    }
}

// --- Assembly ---
union() {
    difference() {
        union() {
            matzah_body();
            grain_bumps();
        }
        // Cut dimples
        dimple_grid();
    }
    // Score lines are additive (raised ridges between sections)
    // Actually, make them cuts into the surface
}

// Final: subtract score lines as channels
difference() {
    union() {
        difference() {
            union() {
                matzah_body();
                grain_bumps();
            }
            dimple_grid();
        }
    }
    // Score line channels
    for (i = [0:num_score_lines - 1]) {
        z_pos = 3 + (i + 0.5) * (band_height - 6) / num_score_lines;
        translate([0, 0, z_pos - score_width / 2])
        difference() {
            cylinder(r = ring_outer_r + 0.1, h = score_width);
            cylinder(r = ring_outer_r - score_depth, h = score_width + 0.1);
        }
    }
}
