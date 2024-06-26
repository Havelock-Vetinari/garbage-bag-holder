include <hex-grid.scad> // From https://www.printables.com/model/86604-hexagonal-grid-generator-in-openscad

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

aux_support_height = 125;
aux_support_pole_diam = 8;
aux_support_pin_diam = 4;
aux_support_pin_len = 4;

bag_holder_height= 10;//ring_diameter*(1/3);

joint_interlock_tolerance=0.25; // Asuming millimeter as unit. Adjust for your printer.

// switches for stl exporting:
show_top_ring = true;
show_middle_ring = false;
show_bottom_ring = false;
show_poles = false; //do not use this to export stl, use 'show_single_pole'

show_aux_base = false;
show_aux_base_poles = false; //do not use this to export stl, use 'show_single_aux_base_poles'

show_lid = false;

// use below part for support pole print
show_single_pole = false;
show_single_aux_base_poles = false;


support_offset=ring_diameter/1.25;
support_height=(height/2)-support_offset/1.25;

support_poles=[ [diameter/2, 0, 0], [-diameter/2, 0, 0], [0, diameter/2, 0], [0, -diameter/2, 0] ];



translate([0, 0, height+2*ring_diameter]) {
    //color("red") 
        bag_holder_ring(
            height=bag_holder_height,
            diameter=diameter,
            base_diameter=diameter,
            ring_diameter=ring_diameter,
            lower_outer_rimm = 1.5,
            upper_outer_rimm = 4,
            upper_inner_rimm_height = 2
        );
}


if (show_lid) {
    lid_height=7;

    translate([0, 0, height+4*ring_diameter]) {
        union(){
            color("orange") difference() {
                cylinder(h=lid_height, d=diameter+ring_diameter/2);
                translate([0,0,-bag_holder_height/1.35]){
                    bag_holder_ring(
                        height=bag_holder_height,
                        diameter=diameter-joint_interlock_tolerance,
                        base_diameter=diameter-joint_interlock_tolerance,
                        ring_diameter=ring_diameter-joint_interlock_tolerance
                    );
                }
                translate([0,0,lid_height/2]){
                    cylinder(h=10, d=diameter-ring_diameter);
                }
            }
            color("olive") translate([0,0,0]){
                cylinder(h=lid_height, r1=10, r2=14);
            }
        }
    }
}
 
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

module bag_holder_ring(
    height,
    diameter,
    base_diameter,
    ring_diameter,
    lower_outer_rimm,
    upper_outer_rimm,
    upper_inner_rimm_height
) {
    assert(lower_outer_rimm <= (ring_diameter / 2), "lower_outer_rimm must be at most half size of ring_diameter");
    
    rooted = (ring_diameter*lower_outer_rimm) - (lower_outer_rimm^2);
    
    assert (rooted >= 0, "Can't squere root negative value, lower_outer_rimm value is to big or ring_diameter is to small");
       
    shift = sqrt(rooted);
    assert (shift <= ring_diameter/2, "Shift is to big, lower_outer_rimm value is to big or ring_diameter is to small");
    
    difference() {
        color("blue", 0.5)
            cylinder(h=height, d=diameter);
        translate([0,0,-1]){
            cylinder(h=height+2, d=base_diameter);
        }
        translate([0,0, -ring_diameter/2 - shift]){
            color("green", 0.5)
                toroid(diameter=base_diameter, ring_diameter=ring_diameter);
        }
        translate([0,0,(ring_diameter/2-shift)+upper_inner_rimm_height]) {
            color("red") 
                cylinder(
                    h=height-(ring_diameter/2-shift)-upper_inner_rimm_height+0.01,
                    d1=diameter,
                    d2=diameter+ring_diameter-upper_outer_rimm
                );
        }
    }
}
