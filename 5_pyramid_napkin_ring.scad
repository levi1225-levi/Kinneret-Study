// ============================================================
// Passover Parting of the Red Sea Napkin Ring
// A dramatic napkin ring where the band represents the sea
// with rising wave walls on two sides and a clear passage
// between them. The bottom has a "sea floor" texture and
// the waves curl inward at the top. Fish silhouettes are
// embedded in the wave walls.
// Designed for FDM 3D printing (print upright, no supports).
// ============================================================

$fn = 120;

// --- Parameters ---
ring_inner_r = 21;
wall = 2.5;
ring_outer_r = ring_inner_r + wall;
base_height = 15;        // height of the regular band
wave_height = 22;         // how high the waves rise above the band
passage_angle = 35;       // half-angle of the passage opening (degrees)

// --- Base ring band ---
module base_ring() {
    // Elegant base with subtle flared edges
    rotate_extrude(convexity = 2)
    polygon(points = [
        [ring_inner_r, 0],
        [ring_outer_r + 0.5, 0],         // slight base flare
        [ring_outer_r, 1.5],
        [ring_outer_r, base_height - 1.5],
        [ring_outer_r + 0.5, base_height], // slight top flare
        [ring_inner_r, base_height]
    ]);
}

// --- Wave walls rising from the band ---
// Two arcs of waves on opposite sides, with passages at 0° and 180°
module wave_wall(start_angle, end_angle) {
    steps = 80;
    angular_span = end_angle - start_angle;
    step_angle = angular_span / steps;

    for (i = [0:steps - 1]) {
        a1 = start_angle + i * step_angle;
        a2 = start_angle + (i + 1) * step_angle;

        // Wave height varies - highest in the middle, lower at edges
        mid_angle = (start_angle + end_angle) / 2;
        t1 = 1 - abs(a1 - mid_angle) / (angular_span / 2);
        t2 = 1 - abs(a2 - mid_angle) / (angular_span / 2);

        // Smooth falloff using sine
        h1 = base_height + wave_height * sin(t1 * 90);
        h2 = base_height + wave_height * sin(t2 * 90);

        // Slight curl inward at top (wall gets thicker and leans in)
        curl1 = 1.5 * pow(t1, 2);
        curl2 = 1.5 * pow(t2, 2);

        hull() {
            rotate([0, 0, a1]) translate([ring_inner_r + wall/2 - curl1 * 0.3, 0, 0])
                cylinder(r = wall/2 + curl1 * 0.3, h = h1);
            rotate([0, 0, a2]) translate([ring_inner_r + wall/2 - curl2 * 0.3, 0, 0])
                cylinder(r = wall/2 + curl2 * 0.3, h = h2);
        }
    }
}

// --- Foam/splash at wave tops ---
module wave_foam(start_angle, end_angle) {
    mid_angle = (start_angle + end_angle) / 2;
    angular_span = end_angle - start_angle;

    for (i = [0:8]) {
        // Place foam blobs near the top of the highest wave sections
        angle = mid_angle + (i - 4) * angular_span * 0.08;
        t = 1 - abs(angle - mid_angle) / (angular_span / 2);
        h = base_height + wave_height * sin(t * 90);
        foam_r = 0.8 + 0.5 * sin(i * 40);

        rotate([0, 0, angle])
            translate([ring_inner_r + wall * 0.5, 0, h])
                sphere(r = foam_r);

        // Curling foam
        rotate([0, 0, angle])
            translate([ring_inner_r - 0.5, 0, h - 1])
                sphere(r = foam_r * 0.7);
    }
}

// --- Fish silhouettes embedded in wave walls ---
module fish_2d() {
    // Simple fish body
    scale([1, 0.6])
        circle(r = 2.5);
    // Tail
    translate([-2.5, 0])
        polygon(points = [[0, 0], [-2, 1.5], [-2, -1.5]]);
    // Eye (will be a bump)
    translate([1.2, 0.3])
        circle(r = 0.4);
}

module fish_relief(angle, z_pos, flip) {
    f = flip ? -1 : 1;
    rotate([0, 0, angle])
        translate([ring_outer_r + 0.3, 0, z_pos])
            rotate([0, 90, 0])
                rotate([0, 0, f * 15])
                    linear_extrude(height = 0.6)
                        scale([f, 1])
                            fish_2d();
}

// --- Sea floor texture (on the base ring) ---
module seafloor_texture() {
    // Wavy horizontal lines around the base
    for (row = [0:2]) {
        z = 2 + row * 4;
        for (a = [0:3:357]) {
            wave_r = ring_outer_r + 0.3 * sin(a * 6 + row * 60);
            rotate([0, 0, a])
                translate([wave_r, 0, z])
                    sphere(r = 0.35);
        }
    }
}

// --- Passage floor detail (footprints / dry path) ---
module passage_detail() {
    // Small stones/pebbles on the "dry" passage floor
    for (side = [0, 180]) {
        for (i = [0:4]) {
            angle = side - passage_angle + 5 + i * passage_angle * 0.4;
            rotate([0, 0, angle])
                translate([ring_inner_r + wall / 2, 0, 0.5])
                    scale([1, 1, 0.4])
                        sphere(r = 0.6 + (i % 2) * 0.3);
        }
    }
}

// --- Assembly ---
union() {
    base_ring();

    // Two wave walls on opposite sides
    // Left wave wall (90° to 270° going through 180°)
    wave_wall(passage_angle, 180 - passage_angle);
    wave_foam(passage_angle, 180 - passage_angle);

    // Right wave wall
    wave_wall(180 + passage_angle, 360 - passage_angle);
    wave_foam(180 + passage_angle, 360 - passage_angle);

    // Sea floor texture
    seafloor_texture();

    // Fish in the wave walls
    fish_relief(90, base_height + 8, false);
    fish_relief(120, base_height + 4, true);
    fish_relief(250, base_height + 6, false);
    fish_relief(280, base_height + 10, true);

    // Passage floor details
    passage_detail();
}
