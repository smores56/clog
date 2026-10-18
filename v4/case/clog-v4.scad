hole_locations = [
    [45.9, -53],
    [26.4, -43.3],
    [64.2, -14.8],
    [101.4, -17.5],
    [111.9, -68.5],
];

pcb_thickness = 1.6;
component_thickness = 2;
case_thickness = 1.5;

plate_thickness = 1.2;
pcb_plate_gap = 1;

total_plate_thickness = plate_thickness + pcb_plate_gap;

total_thickness = pcb_thickness +
    component_thickness + case_thickness +
    total_plate_thickness;

pcb_case_margin = 0.5;
pcb_ridge_margin = 1;

case_wall_thickness = 4;

heat_insert_radius = 1.5;
strut_radius = 3;

// rendering level
$fn = 15;

right_side = true;

module pcb() {
    translate([-75, 50, 0])
    scale([25.4, 25.4, 1])
    import("empty-pcb.dxf");
}

module pcb_ghost() {
    %
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness)
    pcb();
}

module pcb_cutout() {
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness + total_plate_thickness + 1)
    offset(pcb_case_margin)
    pcb();
}

module component_cutout() {
    translate([0, 0, case_thickness])
    linear_extrude(component_thickness + pcb_thickness + 0.1)
    offset(-pcb_ridge_margin)
    pcb();
}

module case_body() {
    minkowski() {
        linear_extrude(total_thickness)
        offset(case_wall_thickness)
        pcb();
        sphere(0.5);
    }
}

module heat_insert_holes() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness + component_thickness - 3])
        linear_extrude(10)
        circle(heat_insert_radius);
    }
}

module heat_insert_struts() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness - 0.1])
        linear_extrude(component_thickness)
        circle(strut_radius);
    }
}

module wire_port_cutout() {
    translate([24.135, -28, case_thickness + component_thickness + total_thickness / 2+ pcb_thickness])
    rotate([0, 0, 8])
    cube([38.75, 35, total_thickness], center=true);
}

module power_switch_cutout() {
    z_rotation_base = 8;
    z_rotation_delta = 15;

    intersection() {
        translate([27.7, -18.5, 1])
        rotate([0, 0, z_rotation_base + z_rotation_delta])
        cube([12, 10, 6]);

        translate([23.7, -16, 1])
        rotate([0, 0, z_rotation_base - z_rotation_delta])
        cube([12, 10, 6]);

        translate([24.7, -17, 2])
        rotate([-10, 0, z_rotation_base])
        cube([15, 10, 6]);
    }
}

module reset_switch_cutout() {
    intersection() {
        translate([6.4, -42.3, 3])
        rotate([-15, 0, 8])
        cube([10, 15, 6]);
        
        translate([6.4, -41.03, 0])
        rotate([0, 0, 8])
        cube([10, 15, 9]);

        translate([6.4, -46, 1])
        rotate([0, 0, 28])
        cube([10, 21, 6]);
    }
}

module full_case() {
    difference() {
        union() {
            difference() {
                case_body();
                pcb_cutout();
                component_cutout();
                wire_port_cutout();
                power_switch_cutout();
                reset_switch_cutout();
            };
            heat_insert_struts();
        };
        heat_insert_holes();
        pcb_ghost();
    };
}

if (right_side) {
    translate([110, 0, 0])
    mirror([1, 0, 0])
    full_case();
} else {
    full_case();
};