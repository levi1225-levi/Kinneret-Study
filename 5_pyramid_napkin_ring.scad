// Passover Pyramid Napkin Ring
// A napkin ring with Egyptian pyramids representing the Exodus from Egypt

$fn = 80;

// Napkin ring parameters
ring_inner_d = 40;
ring_height = 25;
ring_wall = 3;

// Pyramid parameters
pyramid_base = 14;
pyramid_h = 12;
small_pyramid_base = 9;
small_pyramid_h = 7;

module napkin_ring() {
    difference() {
        cylinder(d = ring_inner_d + 2 * ring_wall, h = ring_height);
        translate([0, 0, -1])
            cylinder(d = ring_inner_d, h = ring_height + 2);
    }
}

module pyramid(base, h) {
    // A four-sided pyramid
    polyhedron(
        points = [
            [-base/2, -base/2, 0],  // 0: front-left
            [ base/2, -base/2, 0],  // 1: front-right
            [ base/2,  base/2, 0],  // 2: back-right
            [-base/2,  base/2, 0],  // 3: back-left
            [0, 0, h]               // 4: apex
        ],
        faces = [
            [0, 1, 2, 3],  // base
            [0, 4, 1],     // front
            [1, 4, 2],     // right
            [2, 4, 3],     // back
            [3, 4, 0]      // left
        ]
    );
}

// Sand/desert texture - small bumps on the ring surface
module desert_texture() {
    outer_r = (ring_inner_d + 2 * ring_wall) / 2;

    for (i = [0:60]) {
        angle = i * 360 / 61;
        z = 2 + (i * 7) % (ring_height - 4);
        rotate([0, 0, angle])
            translate([outer_r, 0, z])
                sphere(r = 0.4);
    }
}

// Assemble
union() {
    napkin_ring();
    desert_texture();

    // Main large pyramid
    translate([0, (ring_inner_d / 2 + ring_wall), ring_height])
        pyramid(pyramid_base, pyramid_h);

    // Smaller companion pyramid
    translate([10, (ring_inner_d / 2 + ring_wall - 2), ring_height])
        pyramid(small_pyramid_base, small_pyramid_h);

    // Third small pyramid
    translate([-8, (ring_inner_d / 2 + ring_wall - 1), ring_height])
        pyramid(small_pyramid_base * 0.8, small_pyramid_h * 0.8);
}
