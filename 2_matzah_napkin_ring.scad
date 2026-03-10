// Passover Matzah Napkin Ring
// A napkin ring with a matzah (unleavened bread) texture pattern

$fn = 80;

// Napkin ring parameters
ring_inner_d = 40;
ring_height = 25;
ring_wall = 3;

module napkin_ring_base() {
    difference() {
        cylinder(d = ring_inner_d + 2 * ring_wall, h = ring_height);
        translate([0, 0, -1])
            cylinder(d = ring_inner_d, h = ring_height + 2);
    }
}

// Matzah perforation pattern on the outer surface
module matzah_holes() {
    outer_r = (ring_inner_d + 2 * ring_wall) / 2;
    hole_r = 0.8;
    rows = 5;
    cols = 20;

    for (row = [0:rows-1]) {
        z_offset = 4 + row * (ring_height - 8) / (rows - 1);
        for (col = [0:cols-1]) {
            angle = col * 360 / cols + (row % 2) * (180 / cols);
            rotate([0, 0, angle])
                translate([outer_r - ring_wall / 2, 0, z_offset])
                    rotate([0, 90, 0])
                        cylinder(r = hole_r, h = ring_wall + 2, center = true);
        }
    }
}

// Wavy score lines like matzah
module matzah_score_lines() {
    outer_r = (ring_inner_d + 2 * ring_wall) / 2 + 0.1;
    num_lines = 4;

    for (i = [0:num_lines-1]) {
        z_pos = 3.5 + (i + 0.5) * (ring_height - 7) / num_lines;
        for (angle = [0:5:355]) {
            wave = 0.8 * sin(angle * 3);
            rotate([0, 0, angle])
                translate([outer_r, 0, z_pos + wave])
                    cube([0.8, 0.5, 0.5], center = true);
        }
    }
}

// Assemble
difference() {
    union() {
        napkin_ring_base();
        matzah_score_lines();
    }
    matzah_holes();
}
