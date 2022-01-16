hole_locations = [
    [90.5, 52.33],
    [90.5, 18.33],
    [18.7, 18.33],
    [54.7, 59.33],
];

pcb_thickness = 1.6;
component_thickness = 2;
case_thickness = 1.5;
total_thickness = pcb_thickness +
    component_thickness + case_thickness;

heat_insert_radius = 1.5;
strut_radius = 3;

accuracy = 100;

right_side = false;

module pcb() {
    difference() {
        translate([-6.5, -6.4, 0])
        import("../clog.svg", $fn=accuracy);
        translate([105, 70.08, 0])
        square([20, 10]);
    };
}

module drill_holes() {
    translate([-6.5, -6.4, 0])
    import("../../pcb/gerber/clog-Edge_Cuts.svg", $fn=accuracy);
}

drill_holes();

module pcb_ghost() {
    %
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness)
    pcb();
}

module pcb_cutout() {
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness + 0.1)
    offset(1, $fn=accuracy)
    pcb();
}

module component_cutout() {
    translate([0, 0, case_thickness])
    linear_extrude(component_thickness + pcb_thickness + 0.1)
    offset(-1, $fn=accuracy)
    pcb();
}

module case_body() {
    linear_extrude(total_thickness)
    offset(4, $fn=accuracy)
    pcb();
}

module heat_insert_holes() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness + component_thickness - 3])
        linear_extrude(10)
        circle(heat_insert_radius, $fn=accuracy);
    }
}

module heat_insert_struts() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness - 0.1])
        linear_extrude(component_thickness)
        circle(strut_radius, $fn=accuracy);
    }
}

module power_switch_cutout() {
    union() {
        difference() {
            translate([118, 72.22, case_thickness + 2.5])
            rotate([-25, 0, 0])
            cube([14, 10, 5], center=true);

            translate([118 - 8.48, 70, case_thickness + 2.5])
            rotate([0, 0, 45])
            cube([8, 10, 10], center=true);

            translate([118 + 8.48, 70, case_thickness + 2.5])
            rotate([0, 0, -45])
            cube([8, 10, 10], center=true);
        };
        
        translate([118, 75, case_thickness + 2.5])
        cube([9, 10, 5], center=true);
    };
}

module wire_cutout() {
    translate([111, 60.1, case_thickness])
    cube([14, 10, 5]);
}

module full_case() {
    difference() {
        union() {
            difference() {
                case_body();
                pcb_cutout();
                component_cutout();
                power_switch_cutout();
                wire_cutout();
            };
            heat_insert_struts();
        };
        heat_insert_holes();
        pcb_ghost();
    };
}

if (right_side) {
    translate([130, 0, 0])
    mirror([1, 0, 0])
    full_case();
} else {
    full_case();
};