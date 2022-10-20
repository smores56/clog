hole_locations = [
    [90.5, 52.33],
    [90.5, 18.33],
    [18.7, 18.33],
    [54.7, 59.33],
];

positive_tilt = 10;
tenting_angle = 20;

battery_thickness = 15;
battery_width = 35;
battery_length = 50;

pcb_thickness = 1.6;
component_thickness = 2;
case_thickness = 2;

bolt_radius = 1.3;
strut_radius = 3;
exit_hole_radius = 5;

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
    translate([0, 0, -100 + case_thickness +
        component_thickness + pcb_thickness])
    linear_extrude(100)
    offset(5, $fn=accuracy)
    pcb();
}

module mounting_holes() {
    for (location = hole_locations) {
        translate([location[0], location[1], 0])
        linear_extrude(100, center=true)
        circle(bolt_radius, $fn=accuracy);
    }
}

module mounting_hole_struts() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness - 0.1])
        linear_extrude(component_thickness)
        circle(strut_radius, $fn=accuracy);
    }
}

module mounting_exit_holes() {
    for (location = hole_locations) {
        translate([location[0], location[1], -100])
        linear_extrude(100)
        circle(exit_hole_radius, $fn=accuracy);
    }
};

module battery_cutout() {
    translate([105, 8, -35])
    cube([battery_thickness + 4,
        battery_length + 4,
        battery_width + 4 ]);
}

module wire_cutout() {
    translate([112.5, 60, case_thickness])
    cube([12, 10, 5]);
}

module heel_cutout() {
    translate([50, 100, -60])
    rotate([90, 0, 0])
    linear_extrude(200)
    offset(5, $fn=accuracy)
    square(90, center=true);
}

module full_case() {
    difference() {
        translate([0, 0, -case_thickness - component_thickness + 1])
        rotate([positive_tilt, -tenting_angle, 0])
        difference() {
            union() {
                difference() {
                    case_body();
                    pcb_cutout();
                    component_cutout();
                    mounting_exit_holes();
                    battery_cutout();
                    wire_cutout();
                    heel_cutout();
                };
                mounting_hole_struts();
            };
            mounting_holes();
            pcb_ghost();
        }
        translate([100, 100, -200])
        cube(400, center=true);
    };
}

if (right_side) {
    translate([130, 0, 0])
    mirror([1, 0, 0])
    full_case();
} else {
    full_case();
};