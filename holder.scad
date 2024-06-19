include <hex-grid.scad>

// BOSL2 library is required for aux base grid generation (above include)
// For instalation details see: https://github.com/BelfrySCAD/BOSL2 

// If you see invalid preview, turn on Preferences -> Advanced -> Force Goldfeather

// main frame parameters
diameter=200;
height=300;
ring_diameter=14;
support_diameter=9;

support_pin_len=5;
support_pin_diam=5;

// aux base parameters
base_margin = -8; //was 25;
base_thickness = 6;
base_wall_thickness = 6;
base_rim_height = 15;

aux_support_height = 170;
aux_support_pole_diam = 8;
aux_support_pin_diam = 4;
aux_support_pin_len = 4;

joint_interlock_tolerance=0.25; // Asuming millimeter as unit. Adjust for your printer.

// switches for stl exporting:
show_top_ring = true;
show_middle_ring = true;
show_bottom_ring = true;
show_poles = true; //do not use this to export stl, use 'show_single_pole'

show_aux_base = true;
show_aux_base_poles = true; //do not use this to export stl, use 'show_single_aux_base_poles'

// use below part for support pole print
show_single_pole = false;
show_single_aux_base_poles = false;


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


base_diameter = (diameter - 2 * ring_diameter) - base_margin;

pole_position=base_diameter/2-aux_support_pole_diam/2;

base_poles=[ [pole_position, 0, 0], [-pole_position, 0, 0], [0, pole_position, 0], [0, -pole_position, 0] ];

if (show_aux_base) {
    
    translate([0, 0, aux_support_height]) {
        difference() {
            union() {
                round_hex_base(height=base_thickness, diameter=base_diameter, wall_thickness=base_wall_thickness, rimm_height=base_rim_height);
                for(pole=base_poles) {
                    translate(pole){
                        color("orange") cylinder(h=base_thickness, d=aux_support_pole_diam); 
                    }
                }
            }
            for(pole=base_poles) {
                translate(pole+[0,0,-1]) {
                    cylinder(
                        h=aux_support_pin_len+joint_interlock_tolerance+1,
                        d=aux_support_pin_diam+joint_interlock_tolerance
                    );
                }
            }
        }
    }   
}

if (show_aux_base_poles) {
    for(a_pole=base_poles) {
        translate(a_pole) {
            pole(
                pole_d=aux_support_pole_diam,
                pole_h=aux_support_height,
                pin_diam=aux_support_pin_diam,
                pin_len=aux_support_pin_len,
                lower_pin=false,
                upper_pin=true
            );
        }
    }
}

if (show_single_pole) {
    translate([-support_height/2,support_diameter,0]) rotate([0, 90, 0]) {
        pole(pole_d=support_diameter, pole_h=support_height, pin_diam=support_pin_diam, pin_len=support_pin_len);
    }
}

if (show_single_aux_base_poles) {
    translate([-aux_support_height/2,-aux_support_pole_diam,0]) rotate([0, 90, 0]) {
        pole(
            pole_d=aux_support_pole_diam,
            pole_h=aux_support_height,
            pin_diam=aux_support_pin_diam,
            pin_len=aux_support_pin_len,
            lower_pin=false,
            upper_pin=true
        );
    }
}

module round_hex_base(height, diameter, wall_thickness, rimm_height) {
    intersection() {
        translate([0, 0, height/2]) {
            create_grid(size=[diameter, diameter, height],SW=27, wall=3);
        }
        translate([0, 0, -1]) {
            cylinder(d = diameter, h = height+2);  
        }
    }
    difference() {
        cylinder(d = diameter, h = height+rimm_height);
        translate([0,0,-1]) {
            cylinder(d = diameter-wall_thickness, h = height+rimm_height+2);
        }
    }
}

module pole(pole_d, pole_h, pin_diam, pin_len, lower_pin=true, upper_pin=true) {
    translate([0,0,0]) {
        color("green") cylinder(h=pole_h, d=pole_d);
    }
    if (upper_pin) {
        translate([0, 0 , 0]) {
            color("green") cylinder(h=pin_len+pole_h, d=pin_diam);
        }
    }
    if (lower_pin) {
        translate([0, 0 , -pin_len]) {
            color("green") cylinder(h=pin_len+pole_h, d=pin_diam);
        }
    }
}


module toroid(diameter, ring_diameter) { rotate_extrude(angle=360) {
    translate([diameter / 2, ring_diameter/2])
        circle(d=ring_diameter);
    }
}
