// ============================================================
// Passover Pomegranate Napkin Ring - Flat Silhouette Style
// A beautiful pomegranate fruit silhouette with the napkin
// ring hole in the center of the fruit body. Features a
// detailed crown (calyx), stem with leaves, visible seeds
// as surface texture, and organic fruit contours.
// Pomegranates symbolize righteousness and abundance in
// Jewish tradition (613 seeds = 613 mitzvot).
// Print flat on bed, no supports needed. ~5mm thick.
// ============================================================

$fn = 200;

// --- Core Parameters ---
ring_hole_r = 19;          // napkin hole radius (38mm diameter)
thickness = 5;             // main body thickness
relief_h = 1.0;            // raised detail height

// Pomegranate dimensions
fruit_r = 32;              // main fruit body radius
fruit_stretch_y = 1.15;    // slight vertical elongation
crown_base_w = 16;         // width of crown base
crown_h = 12;              // height of crown
crown_points = 6;          // number of crown petals
stem_length = 10;          // length of stem
leaf_length = 18;          // length of leaves
leaf_width = 7;            // width of leaves

// Seed parameters
seed_r = 1.3;              // individual seed radius
seed_ring_count = 3;       // concentric rings of seeds

// --- Pomegranate body outline (2D) ---
module pomegranate_body_2d() {
    // Slightly irregular oval with a slight point at bottom
    // and flattened top where crown sits

    // Build from hull of offset circles for organic shape
    hull() {
        // Main body - two overlapping circles for slight pear shape
        translate([0, -2])
            scale([1, fruit_stretch_y])
                circle(r = fruit_r);
    }

    // Slight bottom point
    translate([0, -fruit_r * fruit_stretch_y + 2])
        scale([0.4, 1])
            circle(r = 5);
}

// --- Crown / Calyx (the spiky top of pomegranate) ---
module crown_2d() {
    crown_base_y = fruit_r * fruit_stretch_y - 8;

    translate([0, crown_base_y]) {
        // Crown base - wider connecting piece
        hull() {
            translate([-crown_base_w / 2, 0]) circle(r = 2);
            translate([crown_base_w / 2, 0]) circle(r = 2);
            translate([-crown_base_w / 2 + 3, -3]) circle(r = 1.5);
            translate([crown_base_w / 2 - 3, -3]) circle(r = 1.5);
        }

        // Crown petals - pointed shapes radiating upward
        for (i = [0:crown_points - 1]) {
            // Spread petals across the crown width
            x_offset = -crown_base_w / 2 + 3 +
                       i * (crown_base_w - 6) / (crown_points - 1);

            // Alternate heights for visual interest
            petal_h = crown_h * (0.7 + 0.3 * ((i % 2 == 0) ? 1 : 0.6));
            petal_w = 2.5;

            // Each petal is a pointed teardrop shape
            translate([x_offset, 0])
                hull() {
                    circle(r = petal_w / 2);
                    translate([0, petal_h])
                        circle(r = 0.4);
                    // Slight curve
                    translate([((i % 2 == 0) ? 0.5 : -0.5), petal_h * 0.6])
                        circle(r = petal_w / 2 * 0.6);
                }
        }

        // Small inner crown details
        for (i = [0:crown_points - 2]) {
            x1 = -crown_base_w / 2 + 3 + i * (crown_base_w - 6) / (crown_points - 1);
            x2 = -crown_base_w / 2 + 3 + (i + 1) * (crown_base_w - 6) / (crown_points - 1);
            // Small connecting arcs between petals
            translate([(x1 + x2) / 2, 2])
                circle(r = 1);
        }
    }
}

// --- Stem and Leaves ---
module stem_2d() {
    crown_top_y = fruit_r * fruit_stretch_y - 8 + crown_h;

    translate([0, crown_top_y]) {
        // Main stem - slightly curved
        hull() {
            translate([0, 0]) circle(r = 1.5);
            translate([1, stem_length * 0.5]) circle(r = 1.2);
            translate([0.5, stem_length]) circle(r = 0.8);
        }
    }
}

module leaves_2d() {
    crown_top_y = fruit_r * fruit_stretch_y - 8 + crown_h;
    stem_top_y = crown_top_y + stem_length * 0.6;

    // Left leaf - curves to the left
    translate([-2, stem_top_y])
        rotate(35)
            pomegranate_leaf_2d(leaf_length, leaf_width);

    // Right leaf - curves to the right
    translate([2, stem_top_y])
        rotate(-25)
            pomegranate_leaf_2d(leaf_length * 0.85, leaf_width * 0.9);

    // Small bud leaf
    translate([0, stem_top_y + 3])
        rotate(5)
            pomegranate_leaf_2d(leaf_length * 0.5, leaf_width * 0.6);
}

module pomegranate_leaf_2d(l, w) {
    // Pointed leaf with central vein
    hull() {
        circle(r = w / 4);
        translate([0, l * 0.4])
            scale([1, 1.5])
                circle(r = w / 2);
        translate([0, l])
            circle(r = 0.3);
    }
}

// --- Leaf veins (for relief detail) ---
module leaf_veins_2d(l, w) {
    // Central vein
    square([0.5, l * 0.85], center = true);
    translate([0, l * 0.425])
        square([0.5, l * 0.85], center = true);

    // Side veins
    for (i = [1:4]) {
        y = l * 0.15 + i * l * 0.17;
        for (side = [-1, 1]) {
            translate([0, y])
                rotate(side * 40)
                    square([0.4, w * 0.4], center = false);
        }
    }
}

// --- Seed pattern (visible seeds around the ring hole) ---
module seed_pattern_2d() {
    // Concentric rings of seed-shaped ovals around the ring hole
    for (ring = [1:seed_ring_count]) {
        r = ring_hole_r + 3 + ring * (seed_r * 2.5 + 0.5);
        num_seeds = floor(2 * 3.14159 * r / (seed_r * 2.8));

        for (i = [0:num_seeds - 1]) {
            angle = i * 360 / num_seeds + ring * 15; // offset each ring
            x = r * cos(angle);
            y = r * sin(angle) - 2; // shift down since fruit is centered low

            // Only place seeds inside the fruit body
            dist_from_center = sqrt(x * x + (y + 2) * (y + 2));
            if (dist_from_center < fruit_r - 4 && dist_from_center > ring_hole_r + 2) {
                translate([x, y])
                    rotate(angle + 90)
                        scale([0.6, 1])
                            circle(r = seed_r);
            }
        }
    }

    // Additional scattered seeds to fill gaps
    for (i = [0:40]) {
        angle = i * 137.508; // golden angle
        r = ring_hole_r + 4 + sqrt(i) * 3;
        x = r * cos(angle);
        y = r * sin(angle) - 2;

        dist_from_center = sqrt(x * x + (y + 2) * (y + 2));
        if (dist_from_center < fruit_r - 5 && dist_from_center > ring_hole_r + 3) {
            translate([x, y])
                rotate(angle)
                    scale([0.6, 1])
                        circle(r = seed_r * 0.9);
        }
    }
}

// --- Fruit surface texture (subtle dimples) ---
module surface_dimples_2d() {
    for (i = [0:25]) {
        angle = i * 137.508 + 50;
        r = fruit_r * 0.7 + (i % 5) * 2;
        x = r * cos(angle);
        y = r * sin(angle) * fruit_stretch_y - 2;

        dist = sqrt(x * x + (y + 2) * (y + 2));
        if (dist < fruit_r - 2 && dist > ring_hole_r + 5) {
            translate([x, y])
                circle(r = 0.5 + (i % 3) * 0.2);
        }
    }
}

// --- Decorative ring around napkin hole ---
module ring_border_2d() {
    difference() {
        circle(r = ring_hole_r + 2.5);
        circle(r = ring_hole_r);
    }
}

module ring_dot_border_2d() {
    num_dots = 32;
    for (i = [0:num_dots - 1]) {
        angle = i * 360 / num_dots;
        translate([(ring_hole_r + 1.2) * cos(angle),
                   (ring_hole_r + 1.2) * sin(angle)])
            circle(r = 0.4);
    }
}

// --- Fruit section lines (radiating from center) ---
module section_lines_2d() {
    num_sections = 6;
    for (i = [0:num_sections - 1]) {
        angle = i * 360 / num_sections + 15;
        rotate(angle)
            translate([ring_hole_r + 3, -0.2])
                square([fruit_r - ring_hole_r - 7, 0.4]);
    }
}

// ========================================
// ASSEMBLY
// ========================================

// Center the fruit body (ring hole will be at center)
translate([0, 2, 0]) { // shift up slightly so hole is centered in body

    difference() {
        union() {
            // Main fruit body
            linear_extrude(height = thickness)
            difference() {
                union() {
                    pomegranate_body_2d();
                    crown_2d();
                    stem_2d();
                    leaves_2d();
                }
                // Napkin ring hole
                circle(r = ring_hole_r);
            }

            // Raised ring border
            translate([0, 0, thickness])
                linear_extrude(height = relief_h)
                    ring_border_2d();

            // Raised seed pattern
            translate([0, 0, thickness])
                linear_extrude(height = relief_h * 0.7)
                    intersection() {
                        seed_pattern_2d();
                        difference() {
                            pomegranate_body_2d();
                            circle(r = ring_hole_r + 2);
                        }
                    }

            // Raised section lines
            translate([0, 0, thickness])
                linear_extrude(height = relief_h * 0.4)
                    intersection() {
                        section_lines_2d();
                        difference() {
                            pomegranate_body_2d();
                            circle(r = ring_hole_r + 2.5);
                        }
                    }

            // Raised dot border around hole
            translate([0, 0, thickness])
                linear_extrude(height = relief_h * 0.6)
                    ring_dot_border_2d();

            // Raised crown detail
            translate([0, 0, thickness])
                linear_extrude(height = relief_h * 0.5)
                    intersection() {
                        crown_2d();
                        // Only the crown area
                        translate([0, fruit_r * fruit_stretch_y - 10])
                            square([crown_base_w + 10, crown_h + 20], center = true);
                    }

            // Leaf vein details
            crown_top_y = fruit_r * fruit_stretch_y - 8 + crown_h;
            stem_top_y = crown_top_y + stem_length * 0.6;

            translate([-2, stem_top_y, thickness])
                rotate(35)
                    linear_extrude(height = relief_h * 0.5)
                        leaf_veins_2d(leaf_length, leaf_width);

            translate([2, stem_top_y, thickness])
                rotate(-25)
                    linear_extrude(height = relief_h * 0.5)
                        leaf_veins_2d(leaf_length * 0.85, leaf_width * 0.9);
        }

        // Ensure clean napkin hole
        translate([0, 0, -1])
            cylinder(r = ring_hole_r, h = thickness + relief_h + 2);

        // Surface dimples cut into top
        translate([0, 0, thickness - 0.3])
            linear_extrude(height = relief_h + 1)
                surface_dimples_2d();
    }
}
