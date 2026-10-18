accuracy = 100;
is_cover = false;

pcb_thickness = is_cover ? 14 : 1.6;
component_thickness = is_cover ? 0 : 2;
case_thickness = 2;

total_thickness = case_thickness + component_thickness + pcb_thickness;

module pcb() {
    difference() {
        translate([-6.5, -6.4, 0])
        import("clog.svg", $fn=accuracy);
        translate([105, 70.08, 0])
        square([20, 10]);
    };
};

module pcb_ghost() {
    %
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness)
    pcb();
};

module pcb_cutout() {
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness + 0.1)
    offset(1, $fn=accuracy)
    pcb();
};

module component_cutout() {
    translate([0, 0, case_thickness])
    linear_extrude(component_thickness + pcb_thickness + 0.1)
    offset(-1, $fn=accuracy)
    pcb();
}

module case_body() {
    linear_extrude(total_thickness)
    offset(5, $fn=accuracy)
    pcb();
};

module daughterboard_cutout() {
    translate([107.99, 60, case_thickness])
    cube([20, 16, 20]);
};

module power_switch_cutout() {
    translate([112.5, 60, case_thickness])
    union() {
        translate([0, 10, 0.3])
        rotate([-20, 0, 0])
        cube([12, 16, 5 ]);
        cube([12, 16, 20]);
    };
};

module primary_bridge() {
    intersection() {
        translate([131, -4.75, 0])
        cube([21, 100, total_thickness]);
        translate([126, -4.75, 0])
        rotate([0, 0, 12.5])
        cube([21, 95, total_thickness]);
    };
};

module bottom_bridge() {
    translate([126.1, -4.725, 0])
    rotate([0, 0, 12.5])
    cube([8, 3, total_thickness]);
};

module top_bridge() {
    translate([125.14, 72.15, 0])
    rotate([0, 0, 12.5])
    cube([5, 3, total_thickness]);
};

module center_magnet_cutout() {
    translate([135, 0, total_thickness - 2])
    rotate([0, 0, 12.5])
    cube([5.2, 20.2, 5]);
};

module case_half() {
    union() {
        difference() {
            union() {
                case_body();
                primary_bridge();
                top_bridge();
                bottom_bridge();
            };
            pcb_cutout();
            component_cutout();
            center_magnet_cutout();
            if (is_cover) {
                daughterboard_cutout();
            } else {
                power_switch_cutout();
            };
        };
        pcb_ghost();
    };
};

union() {
    translate([0, 0, 0])
    rotate([0, 0, -12.5])
    case_half();
    translate([285, 0, 0])
    mirror([1, 0, 0])
    rotate([0, 0, -12.5])
    case_half();
};
