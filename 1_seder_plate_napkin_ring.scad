// Passover Seder Plate Napkin Ring
// A napkin ring decorated with a miniature seder plate on top

$fn = 80;

// Napkin ring parameters
ring_inner_d = 40;    // inner diameter (fits rolled napkin)
ring_height = 25;
ring_wall = 3;

// Seder plate parameters
plate_d = 30;
plate_h = 2;
well_d = 7;
well_depth = 1.2;

module napkin_ring() {
    difference() {
        cylinder(d = ring_inner_d + 2 * ring_wall, h = ring_height);
        translate([0, 0, -1])
            cylinder(d = ring_inner_d, h = ring_height + 2);
    }
}

module seder_plate() {
    // Main plate
    difference() {
        union() {
            cylinder(d = plate_d, h = plate_h);
            // Rim
            difference() {
                cylinder(d = plate_d, h = plate_h + 1);
                translate([0, 0, -0.5])
                    cylinder(d = plate_d - 3, h = plate_h + 2);
            }
        }
        // 6 wells arranged in a circle for the seder items
        for (i = [0:5]) {
            angle = i * 60;
            r = (i < 5) ? plate_d / 2 - well_d / 2 - 2 : 0;
            translate([r * cos(angle), r * sin(angle), plate_h - well_depth + 0.5])
                cylinder(d = well_d, h = well_depth + 1);
        }
    }
}

// Assemble
napkin_ring();
translate([0, 0, ring_height])
    seder_plate();
