// ============================================================
// Passover Kiddush Cup / Elijah's Cup Napkin Ring
// Flat Silhouette Style
// The outer shape IS a wine goblet/chalice silhouette.
// The napkin ring hole is positioned in the bowl of the cup.
// Features elegant curves, grape vine decorations, and
// Hebrew-inspired decorative borders.
// Print flat on bed, no supports needed. ~5mm thick.
// ============================================================

$fn = 200;

// --- Core Parameters ---
ring_hole_r = 19;          // napkin hole radius (38mm diameter)
thickness = 5;             // main body thickness
relief_h = 1.0;            // raised detail height

// Goblet dimensions - the silhouette shape
// Total height from bottom of base to top of rim
goblet_total_h = 80;
base_w = 36;               // foot/base width
base_h = 6;                // foot height
stem_w = 8;                // stem narrowest width
stem_h = 18;               // stem section height
bowl_w = 52;               // bowl widest width
bowl_h = 42;               // bowl height
lip_flare = 3;             // extra flare at lip
rim_h = 3;                 // rim band height

// Knob on stem
knob_w = 14;
knob_h = 8;

// --- Goblet silhouette profile (right half, 2D) ---
// We define the right side outline and mirror it
module goblet_half_outline() {
    // Build smooth profile using polygon with many points
    // Going from bottom-left up the right side

    // Base foot
    base_top_y = base_h;
    stem_start_y = base_h + 2;
    stem_end_y = base_h + stem_h;
    knob_center_y = base_h + stem_h * 0.55;
    bowl_start_y = stem_end_y;
    bowl_end_y = stem_end_y + bowl_h;

    points = concat(
        // Bottom edge of base (center to right)
        [[0, 0], [base_w / 2, 0]],

        // Right side of base foot going up - slight curve
        [[base_w / 2, 1]],
        [[base_w / 2 - 0.5, 2]],
        [[base_w / 2 - 1.5, base_h - 1]],
        [[base_w / 2 - 2, base_h]],

        // Taper into stem
        [for (i = [0:5])
            let(t = i / 5,
                y = base_h + t * 4,
                x = (base_w / 2 - 2) * (1 - t) + stem_w / 2 * t)
            [x, y]
        ],

        // Lower stem
        [[stem_w / 2, base_h + 5]],

        // Knob bulge - smooth curve outward and back
        [for (i = [0:20])
            let(t = i / 20,
                angle = t * 180,
                y = knob_center_y - knob_h / 2 + t * knob_h,
                knob_offset = knob_w / 2 * sin(angle),
                x = stem_w / 2 + knob_offset * 0.4)
            [max(stem_w / 2, x), y]
        ],

        // Upper stem
        [[stem_w / 2, stem_end_y - 3]],

        // Transition to bowl - elegant S-curve
        [for (i = [0:15])
            let(t = i / 15,
                y = stem_end_y - 3 + t * 8,
                // S-curve from stem_w/2 to partway to bowl_w/2
                x = stem_w / 2 + (bowl_w / 2 - stem_w / 2) * 0.3 *
                    (3 * t * t - 2 * t * t * t))
            [x, y]
        ],

        // Bowl curve - expanding upward
        [for (i = [0:30])
            let(t = i / 30,
                y = stem_end_y + 5 + t * (bowl_h - 10),
                // Slightly concave bowl curve
                curve = pow(t, 0.6),
                x = stem_w / 2 + (bowl_w / 2 - stem_w / 2) * (0.3 + 0.7 * curve))
            [x, y]
        ],

        // Lip flare at top
        [[bowl_w / 2 + lip_flare * 0.5, bowl_end_y - 2]],
        [[bowl_w / 2 + lip_flare, bowl_end_y - 1]],
        [[bowl_w / 2 + lip_flare, bowl_end_y]],
        [[bowl_w / 2 + lip_flare - 0.5, bowl_end_y + rim_h]],

        // Top edge back to center
        [[0, bowl_end_y + rim_h]]
    );

    polygon(points = points);
}

// --- Full goblet outline (2D) ---
module goblet_outline_2d() {
    union() {
        goblet_half_outline();
        mirror([1, 0, 0]) goblet_half_outline();
    }
}

// --- Grape cluster relief (2D) ---
module grape_cluster_2d(size) {
    // Triangular arrangement of circles
    grape_r = size * 0.28;
    positions = [
        [0, 0],
        [-0.5, 0.85], [0.5, 0.85],
        [-1, 1.7], [0, 1.7], [1, 1.7],
        [-0.5, 2.55], [0.5, 2.55],
        [0, 3.4]
    ];
    for (p = positions)
        translate([p[0] * size * 0.32, p[1] * size * 0.32])
            circle(r = grape_r);
}

// --- Grape vine with leaves (2D) ---
module vine_decoration_2d(span) {
    // Curving vine stem
    for (i = [0:60]) {
        t = i / 60;
        x = t * span - span / 2;
        y = 1.5 * sin(t * 360);
        translate([x, y])
            circle(r = 0.4);
    }

    // Grape clusters hanging down
    translate([-span * 0.25, -3])
        grape_cluster_2d(3.5);
    translate([span * 0.25, -3])
        grape_cluster_2d(3.5);

    // Vine leaves
    translate([-span * 0.4, 2])
        rotate(15)
            vine_leaf_2d(4);
    translate([span * 0.1, 2.5])
        rotate(-20)
            vine_leaf_2d(3.5);
    translate([span * 0.4, 1.5])
        rotate(10)
            vine_leaf_2d(3);
}

// --- Vine leaf (2D) - multi-lobed ---
module vine_leaf_2d(size) {
    // Five-lobed leaf shape
    s = size / 4;
    hull() {
        circle(r = s * 0.8);
        translate([s * 1.5, s * 0.5]) circle(r = s * 0.6);
        translate([s * 0.5, s * 1.5]) circle(r = s * 0.6);
    }
    hull() {
        circle(r = s * 0.8);
        translate([-s * 1.5, s * 0.5]) circle(r = s * 0.6);
        translate([-s * 0.5, s * 1.5]) circle(r = s * 0.6);
    }
    hull() {
        circle(r = s * 0.8);
        translate([0, s * 2]) circle(r = s * 0.5);
    }
    // Stem
    translate([0, -s * 0.8])
        square([0.5, s * 1.2], center = true);
}

// --- Decorative band pattern (2D) ---
module decorative_band_2d(width, height) {
    // Repeating arch/wave pattern
    num_arches = floor(width / 4);
    for (i = [0:num_arches - 1]) {
        x = -width / 2 + (i + 0.5) * width / num_arches;
        translate([x, 0])
            intersection() {
                translate([0, -height * 0.3])
                    circle(r = width / num_arches * 0.45);
                square([width / num_arches, height], center = true);
            }
    }
}

// --- Ring hole position (in the bowl area) ---
// Center the ring hole in the upper-middle of the bowl
ring_hole_y = base_h + stem_h + bowl_h * 0.5;

// ========================================
// ASSEMBLY
// ========================================

// Main goblet body
difference() {
    union() {
        // Base goblet slab
        linear_extrude(height = thickness)
        difference() {
            goblet_outline_2d();
            // Napkin ring hole
            translate([0, ring_hole_y])
                circle(r = ring_hole_r);
        }

        // Raised rim reinforcement around hole
        translate([0, 0, thickness])
            linear_extrude(height = relief_h)
            difference() {
                translate([0, ring_hole_y])
                    circle(r = ring_hole_r + 2.5);
                translate([0, ring_hole_y])
                    circle(r = ring_hole_r);
            }

        // Raised decorative elements on front face

        // Grape vine decoration on the bowl (above hole)
        translate([0, ring_hole_y + ring_hole_r + 7, thickness])
            linear_extrude(height = relief_h)
                vine_decoration_2d(30);

        // Grape vine below hole
        translate([0, ring_hole_y - ring_hole_r - 7, thickness])
            linear_extrude(height = relief_h)
                rotate(180)
                    scale([0.7, 0.7])
                        vine_decoration_2d(22);

        // Decorative band on the rim
        bowl_top_y = base_h + stem_h + bowl_h;
        translate([0, bowl_top_y + 0.5, thickness])
            linear_extrude(height = relief_h * 0.8)
                decorative_band_2d(bowl_w + lip_flare * 2 - 4, rim_h - 1);

        // Decorative band on the base
        translate([0, 1, thickness])
            linear_extrude(height = relief_h * 0.8)
                decorative_band_2d(base_w - 4, base_h - 2);

        // Knob highlight ring
        knob_y = base_h + stem_h * 0.55;
        translate([0, knob_y, thickness])
            linear_extrude(height = relief_h * 0.6)
            difference() {
                scale([1.05, 0.6]) circle(r = knob_w / 2);
                scale([0.85, 0.45]) circle(r = knob_w / 2);
            }

        // Stem highlight lines
        for (y_off = [base_h + 6, base_h + stem_h - 4]) {
            translate([0, y_off, thickness])
                linear_extrude(height = relief_h * 0.5)
                    square([stem_w + 2, 0.8], center = true);
        }
    }

    // Ensure clean napkin hole
    translate([0, ring_hole_y, -1])
        cylinder(r = ring_hole_r, h = thickness + relief_h + 2);
}
