diameter=200;
height=300;
ring_diameter=14;
support_diameter=9;

support_pin_len=5;
support_pin_diam=5;

joint_interlock_tolerance=0.25; // Asuming millimeter as unit. Adjust for your printer.

// switches for stl exporting:
show_top_ring = true;
show_middle_ring = false;
show_bottom_ring = false;
show_poles = false;
// use below part for support pole print
show_single_pole = false;


support_offset=ring_diameter/1.25;
support_height=(height/2)-support_offset/1.25;

support_poles=[ [diameter/2, 0, 0], [-diameter/2, 0, 0], [0, diameter/2, 0], [0, -diameter/2, 0] ];

if (show_bottom_ring) {
    difference() {
        translate([0,0,0]) {
            toroid(diameter, ring_diameter);
        }
        for (pole = support_poles) {
            translate(pole + [0, 0, support_offset]) {
                pole(
                    pole_d=support_diameter+joint_interlock_tolerance,
                    pole_h=support_height,
                    pin_diam=support_pin_diam+joint_interlock_tolerance,
                    pin_len=support_pin_len+joint_interlock_tolerance
                );
            }
        }
    }
}

if (show_middle_ring) {
    difference() {
        translate([0,0, height/2]){
            toroid(diameter, ring_diameter);
        }
        for (pole = support_poles) {
            translate(pole + [0, 0, support_offset]) {
                pole(
                    pole_d=support_diameter+joint_interlock_tolerance,
                    pole_h=support_height,
                    pin_diam=support_pin_diam+joint_interlock_tolerance,
                    pin_len=support_pin_len+joint_interlock_tolerance
                );
            }
            translate(pole + [0, 0, height/2+support_offset]) {
                pole(
                    pole_d=support_diameter+joint_interlock_tolerance,
                    pole_h=support_height,
                    pin_diam=support_pin_diam+joint_interlock_tolerance,
                    pin_len=support_pin_len+joint_interlock_tolerance
                );
            }       
        }
    }
}

if (show_top_ring) {
    difference() {
        translate([0,0, height]){
            toroid(diameter, ring_diameter);
        }
        for (pole = support_poles) {
            translate(pole + [0, 0, height/2+support_offset]) {
                pole(
                    pole_d=support_diameter+joint_interlock_tolerance,
                    pole_h=support_height,
                    pin_diam=support_pin_diam+joint_interlock_tolerance,
                    pin_len=support_pin_len+joint_interlock_tolerance
                );
            }
        }
    }
}

if (show_poles) {
    for (pole=support_poles) {
        translate(pole + [0, 0, support_offset]) {
            pole(pole_d=support_diameter, pole_h=support_height, pin_diam=support_pin_diam, pin_len=support_pin_len);
        }
        
        translate(pole + [0, 0, height/2+support_offset]) {
            pole(pole_d=support_diameter, pole_h=support_height, pin_diam=support_pin_diam, pin_len=support_pin_len);
        }    
    }
}

if (show_single_pole) {
    translate([-support_height/2,0,0]) rotate([0, 90, 0]) {
        pole(pole_d=support_diameter, pole_h=support_height, pin_diam=support_pin_diam, pin_len=support_pin_len);
    }
}

module pole(pole_d, pole_h, pin_diam, pin_len) {
    translate([0,0,0]) {
        color("green") cylinder(h=pole_h, d=pole_d);
    }
    translate([0, 0 , 0]) {
        color("green") cylinder(h=pin_len+pole_h, d=pin_diam);
    }
    translate([0, 0 , -pin_len]) {
        color("green") cylinder(h=pin_len+pole_h, d=pin_diam);
    }
}


module toroid(diameter, ring_diameter) { rotate_extrude(angle=360) {
    translate([diameter / 2, ring_diameter/2])
        circle(d=ring_diameter);
    }
}
