// Passover Star of David Napkin Ring
// A napkin ring with Star of David cutouts around the band

$fn = 80;

// Napkin ring parameters
ring_inner_d = 40;
ring_height = 30;
ring_wall = 3.5;

module napkin_ring_base() {
    difference() {
        cylinder(d = ring_inner_d + 2 * ring_wall, h = ring_height);
        translate([0, 0, -1])
            cylinder(d = ring_inner_d, h = ring_height + 2);
    }
}

// 2D Star of David (two overlapping triangles)
module star_of_david_2d(size) {
    // Upward triangle
    polygon(points = [
        [size * cos(90), size * sin(90)],
        [size * cos(210), size * sin(210)],
        [size * cos(330), size * sin(330)]
    ]);
    // Downward triangle
    polygon(points = [
        [size * cos(270), size * sin(270)],
        [size * cos(30), size * sin(30)],
        [size * cos(150), size * sin(150)]
    ]);
}

// Cut stars around the ring
module star_cutouts() {
    outer_r = (ring_inner_d + 2 * ring_wall) / 2;
    num_stars = 6;
    star_size = 7;

    for (i = [0:num_stars-1]) {
        angle = i * 360 / num_stars;
        rotate([0, 0, angle])
            translate([outer_r, 0, ring_height / 2])
                rotate([0, 90, 0])
                    linear_extrude(height = ring_wall + 2, center = true)
                        star_of_david_2d(star_size);
    }
}

// Decorative border lines at top and bottom
module border_rings() {
    outer_r = (ring_inner_d + 2 * ring_wall) / 2;

    for (z = [2, ring_height - 2]) {
        difference() {
            cylinder(d = ring_inner_d + 2 * ring_wall + 1, h = 1.5, center = true);
            cylinder(d = ring_inner_d + 2 * ring_wall - 1, h = 2, center = true);
            translate([0, 0, 0])
                cylinder(d = ring_inner_d, h = 4, center = true);
        }
    }
}

// Assemble
difference() {
    union() {
        napkin_ring_base();
        // Top border
        translate([0, 0, ring_height - 1.5])
            difference() {
                cylinder(d = ring_inner_d + 2 * ring_wall + 1.2, h = 1.5);
                translate([0, 0, -0.5])
                    cylinder(d = ring_inner_d, h = 2.5);
            }
        // Bottom border
        difference() {
            cylinder(d = ring_inner_d + 2 * ring_wall + 1.2, h = 1.5);
            translate([0, 0, -0.5])
                cylinder(d = ring_inner_d, h = 2.5);
        }
    }
    star_cutouts();
}
