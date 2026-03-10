// ============================================================
// Passover Kiddush Cup / Elijah's Cup Napkin Ring
// The ring itself IS shaped like a classical goblet/chalice -
// using rotate_extrude with a turned vessel profile featuring
// a flared base, narrow waist, and elegant bowl top.
// Decorative horizontal banding and grape vine relief.
// Designed for FDM 3D printing (print upright, no supports).
// ============================================================

$fn = 150;

// --- Parameters ---
ring_inner_r = 21;
wall = 2.5;
total_height = 35;

// Profile control points (r_offset from inner_r, z position)
// Creates a classical goblet silhouette
base_flare = 4.0;       // extra radius at base
waist_pinch = -0.3;     // narrowing at waist (negative = thinner)
bowl_flare = 3.5;       // flare at top bowl
lip_extra = 1.0;        // extra flare at very top lip

// --- Goblet profile ---
// Returns the outer wall radius at a given height fraction (0-1)
function goblet_r(t) =
    let(
        // Base section (0 - 0.15): flared foot
        base = (t < 0.15) ?
            ring_inner_r + wall + base_flare * (1 - t / 0.15) : 0,
        // Lower stem (0.15 - 0.25): taper in
        lower = (t >= 0.15 && t < 0.25) ?
            ring_inner_r + wall + base_flare * 0.0 +
            waist_pinch * ((t - 0.15) / 0.1) : 0,
        // Waist/knob (0.25 - 0.45): decorative knob bulge
        knob_t = (t - 0.35) / 0.1,
        waist = (t >= 0.25 && t < 0.45) ?
            ring_inner_r + wall + waist_pinch +
            1.5 * (1 - knob_t * knob_t) : 0,
        // Upper stem (0.45 - 0.55): taper to bowl
        upper = (t >= 0.45 && t < 0.55) ?
            ring_inner_r + wall + waist_pinch +
            (bowl_flare - waist_pinch) * ((t - 0.45) / 0.1) * 0.3 : 0,
        // Bowl (0.55 - 0.9): expanding bowl
        bowl = (t >= 0.55 && t < 0.9) ?
            ring_inner_r + wall +
            bowl_flare * pow((t - 0.55) / 0.35, 0.7) : 0,
        // Lip (0.9 - 1.0): slight flare out then in
        lip = (t >= 0.9) ?
            ring_inner_r + wall + bowl_flare +
            lip_extra * sin((t - 0.9) / 0.1 * 180) : 0
    )
    base + lower + waist + upper + bowl + lip;

// --- Build ring using stacked slices ---
module goblet_ring() {
    slices = 100;
    slice_h = total_height / slices;

    for (i = [0:slices - 1]) {
        t1 = i / slices;
        t2 = (i + 1) / slices;
        r1 = goblet_r(t1);
        r2 = goblet_r(t2);
        z1 = t1 * total_height;

        translate([0, 0, z1])
            difference() {
                cylinder(r1 = r1, r2 = r2, h = slice_h + 0.01);
                translate([0, 0, -0.1])
                    cylinder(r = ring_inner_r, h = slice_h + 0.2);
            }
    }
}

// --- Simpler approach using rotate_extrude with polygon ---
module goblet_ring_v2() {
    // Define the outer profile as a series of points
    steps = 60;
    outer_pts = [for (i = [0:steps])
        let(t = i / steps)
        [goblet_r(t), t * total_height]
    ];

    // Inner wall is straight
    inner_pts = [
        [ring_inner_r, total_height],
        [ring_inner_r, 0]
    ];

    all_pts = concat(outer_pts, inner_pts);

    rotate_extrude(convexity = 4)
        polygon(points = all_pts);
}

// --- Decorative horizontal bands ---
module decorative_bands() {
    // Band at base
    translate([0, 0, total_height * 0.08])
        ring_band(goblet_r(0.08) + 0.4, 1.5);

    // Band at waist knob top/bottom
    translate([0, 0, total_height * 0.28])
        ring_band(goblet_r(0.28) + 0.3, 0.8);
    translate([0, 0, total_height * 0.42])
        ring_band(goblet_r(0.42) + 0.3, 0.8);

    // Band at bowl start
    translate([0, 0, total_height * 0.58])
        ring_band(goblet_r(0.58) + 0.3, 0.8);

    // Band near lip
    translate([0, 0, total_height * 0.88])
        ring_band(goblet_r(0.88) + 0.3, 1.0);
}

module ring_band(outer_r, height) {
    difference() {
        cylinder(r = outer_r, h = height);
        translate([0, 0, -0.1])
            cylinder(r = outer_r - 0.8, h = height + 0.2);
    }
}

// --- Grape cluster relief (embossed on bowl section) ---
module grape_cluster(angle) {
    rotate([0, 0, angle])
    translate([0, 0, total_height * 0.68]) {
        // Grapes - cluster of spheres on the outer surface
        grape_r = 1.2;
        bowl_r = goblet_r(0.68);
        translate([bowl_r + grape_r * 0.3, 0, 0]) {
            // Cluster arrangement
            for (pos = [
                [0, 0, 0],
                [1.8, 0.8, 0],
                [1.8, -0.8, 0],
                [0, 1.6, 0],
                [0, -1.6, 0],
                [1.0, 0, 2.0],
                [1.0, 1.0, 2.0],
                [1.0, -1.0, 2.0],
                [0.5, 0, 3.5]
            ]) {
                // Flatten spheres against the surface
                translate([pos[0] * 0.4, pos[1], pos[2]])
                    scale([0.5, 1, 1])
                        sphere(r = grape_r);
            }
            // Vine stem
            translate([0.2, 0, 4.5])
                rotate([0, 20, 0])
                    cylinder(r = 0.3, h = 3);
            // Small leaf
            translate([0.3, 0, 7])
                scale([0.3, 1, 0.8])
                    sphere(r = 2);
        }
    }
}

// --- Assembly ---
union() {
    goblet_ring_v2();
    decorative_bands();

    // 4 grape clusters evenly spaced
    for (i = [0:3]) {
        grape_cluster(i * 90);
    }
}
