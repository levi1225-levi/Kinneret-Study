// Passover Elijah's Cup / Wine Cup Napkin Ring
// A napkin ring with a decorative kiddush cup (wine goblet) on top

$fn = 80;

// Napkin ring parameters
ring_inner_d = 40;
ring_height = 25;
ring_wall = 3;

// Cup parameters
cup_base_d = 10;
cup_base_h = 2;
stem_d = 4;
stem_h = 10;
bowl_bottom_d = 8;
bowl_top_d = 16;
bowl_h = 14;
bowl_wall = 1.5;

module napkin_ring() {
    difference() {
        cylinder(d = ring_inner_d + 2 * ring_wall, h = ring_height);
        translate([0, 0, -1])
            cylinder(d = ring_inner_d, h = ring_height + 2);
    }
}

module kiddush_cup() {
    // Base
    cylinder(d = cup_base_d, h = cup_base_h);

    // Stem
    translate([0, 0, cup_base_h])
        cylinder(d = stem_d, h = stem_h);

    // Stem knob decoration
    translate([0, 0, cup_base_h + stem_h / 2])
        sphere(d = stem_d + 2);

    // Bowl
    translate([0, 0, cup_base_h + stem_h]) {
        difference() {
            cylinder(d1 = bowl_bottom_d, d2 = bowl_top_d, h = bowl_h);
            translate([0, 0, bowl_wall])
                cylinder(d1 = bowl_bottom_d - 2 * bowl_wall,
                         d2 = bowl_top_d - 2 * bowl_wall,
                         h = bowl_h);
        }
    }

    // Decorative band around bowl
    translate([0, 0, cup_base_h + stem_h + bowl_h * 0.4]) {
        mid_d = bowl_bottom_d + (bowl_top_d - bowl_bottom_d) * 0.4;
        difference() {
            cylinder(d = mid_d + 1.5, h = 2);
            translate([0, 0, -0.5])
                cylinder(d = mid_d - 1, h = 3);
        }
    }
}

// Assemble
napkin_ring();
translate([0, (ring_inner_d + ring_wall) / 2, ring_height])
    kiddush_cup();
