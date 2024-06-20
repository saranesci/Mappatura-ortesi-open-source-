/********************************************************
 * Project: T-Rex Mouse
 * by:      T. Wirtl
 * year:    2015
 * license: CC BY-SA 4.0 for details visit:
            http://creativecommons.org/licenses/by-sa/4.0/
 * change log:
 *  22-10-2015 initial version 
 ********************************************************/
 
include<oshw_logo.scad> // OSHW logo by pierre-alain dorange

/********************************************************
 * The mouthpiece
 ********************************************************/
module mouthpiece()
{
    
    module sub_mouthpiece_body()
    {
        hull()
        {
        translate([0,-1,35]) cylinder(h=0.1, r=2, $fn=40);
        translate([0,1,35]) cylinder(h=0.1, r=2, $fn=40);
            
        translate([0,-1,20]) cylinder(h=0.1, r=3, $fn=40);
        translate([0,1,20]) cylinder(h=0.1, r=3, $fn=40);
        }

        hull()
        {

        translate([0,-1,20]) cylinder(h=0.1, r=3, $fn=40);
        translate([0,1,20]) cylinder(h=0.1, r=3, $fn=40);

        // base
        cylinder(h=0.1, r=15, $fn=40);
        }
        
        
        hull()
        {
            translate([12,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=2, $fn=40);
            translate([20,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=2, $fn=40);
            
        }
    }
    
    module sub_mouthpiece_channel()
    {
        hull()
        {
            translate([0,-1,35]) cylinder(h=0.1, r=1, $fn=40);
            translate([0,1,35]) cylinder(h=0.1, r=1, $fn=40);

            translate([0,-1,20]) cylinder(h=0.1, r=1.5, $fn=40);
            translate([0,1,20]) cylinder(h=0.1, r=1.5, $fn=40);
        }
        hull()
        {
            translate([0,-1,20]) cylinder(h=0.1, r=1.5, $fn=40);
            translate([0,1,20]) cylinder(h=0.1, r=1.5, $fn=40);

            translate([11,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=1.5, $fn=40);
            
        }
        
        hull()
        {
            translate([11,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=1.5, $fn=40);
            translate([14,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=1, $fn=40);
        }
        
        hull()
        {
            translate([14,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=1, $fn=40);
            translate([20,0,2]) rotate([0,90,0])  cylinder(h=0.1, r=1, $fn=40);
            
        }    
    }
    
    difference()
    {
        sub_mouthpiece_body();
        sub_mouthpiece_channel();
        translate([0,0,0]) cylinder(h=9, r=5.5, $fn=40);
    }
}

/********************************************************
 * Basic shape of a case part. This will be used by most
 * of the other modules to create the basic shape of a 
 * part.
 *
 * iExtrudeHeight:  Extrusion height (Z-Axis)
 * bScrewHoles:     Add screw holes for M3 screws
 ********************************************************/
module basic_case(iExtrudeHeight, bScrewholes)
{
    width=60;
    height=40;
    
    difference()
    {
        // basic case shape
        hull()
        {
            translate([(width/2-3),(height/2-3)]) cylinder(r=6,h=iExtrudeHeight, $fn=40);
            translate([-(width/2-3),(height/2-3)]) cylinder(r=6,h=iExtrudeHeight, $fn=40);
            translate([(width/2-3),-(height/2-3)]) cylinder(r=6,h=iExtrudeHeight, $fn=40);
            translate([-(width/2-3),-(height/2-3)]) cylinder(r=6,h=iExtrudeHeight, $fn=40);
        }
        if (bScrewholes == true)
        {
             // screw holes
            translate([(width/2-3),(height/2-3),0]) cylinder(r=1.7,h=iExtrudeHeight, $fn=40);
            translate([-(width/2-3),(height/2-3),0]) cylinder(r=1.7,h=iExtrudeHeight, $fn=40);
            translate([(width/2-3),-(height/2-3),0]) cylinder(r=1.7,h=iExtrudeHeight, $fn=40);
            translate([-(width/2-3),-(height/2-3),0]) cylinder(r=1.7,h=iExtrudeHeight, $fn=40);
        }
    }
}

/********************************************************
 * Joystick PCB dummy
 ********************************************************/
module joystick_pcb()
{
    // joystick
    translate([0,0,6]) cube([17,17,12], center=true);
    translate([8.5,-6,0]) cube([4.7,12,12], center=false);
    translate([-11.4,-6,0]) cube([2.9,12,7], center=false);
    translate([-6,8.5,0]) cube([12,4.1,12], center=false);
    translate([-6,-15.8,0]) cube([12,7.3,10], center=false);

    // pcb
    translate([-18.5,-15.8,0]) cube([36,28.4,1.6], center=false);

    // holes
    translate([13.6,-11,0]) cylinder(h=6.6,r=1.4,$fn=40);
    translate([-12.5,-11,0]) cylinder(h=6.6,r=1.4,$fn=40);
    translate([13.6,8.9,0]) cylinder(h=6.6,r=1.4,$fn=40);
    translate([-12.5,8.9,0]) cylinder(h=6.6,r=1.4,$fn=40);
    
    translate([-15.2,0,2.6]) cube([3.5,14.5,3], center=true);
}

/********************************************************
 * Arduino pro micro PCB dummy with pinheaders on 
 * the bottom
 ********************************************************/
module arduino_micro()
{
    module pcb()
    {
        translate([-2,5,1.4]) cube([7,8.2,3]);
        translate([0,0,0]) cube([33.4,18.2,3.2]);
        translate([2.4,0,-8.5]) cube([31,3,8.5]);
        translate([2.4,15.2,-8.5]) cube([31,3,8.5]);
    }
    difference()
    {
      

        pcb();
        
        translate([31.4,4.1,1.6]) cube([2,10,01.6]);
    }
}

/********************************************************
 * Front part to hide the joystick mechanics
 ********************************************************/
module joystick_case()
{
    depth=10;
    width=60;
    height=40;
    difference()
    {
        // basic case shape
        hull()
        {
            basic_case(depth-5, false);
            cylinder(h=depth, r=15, $fn=40);
        }
        // joystick hole
        hull()
        {
            translate([0,0,depth]) cylinder(h=0.01, r=14, $fn=40);
            cylinder(h=0.01, r=18, $fn=40);
        }
        // screw holes
        translate([(width/2-3),(height/2-3),0]) cylinder(r=1.7,h=depth, $fn=40);
        translate([(width/2-3),(height/2-3),depth-5]) cylinder(r=3.1,h=depth, $fn=40);
        translate([-(width/2-3),(height/2-3),0]) cylinder(r=1.7,h=depth, $fn=40);
        translate([-(width/2-3),(height/2-3),depth-5]) cylinder(r=3.1,h=depth, $fn=40);
        translate([(width/2-3),-(height/2-3),0]) cylinder(r=1.7,h=depth, $fn=40);
        translate([(width/2-3),-(height/2-3),depth-5]) cylinder(r=3.1,h=depth, $fn=40);
        translate([-(width/2-3),-(height/2-3),0]) cylinder(r=1.7,h=depth, $fn=40);
        translate([-(width/2-3),-(height/2-3),depth-5]) cylinder(r=3.1,h=depth, $fn=40);
        
        
    }
    
}

/********************************************************
 * Plate to mount the joystick PCB
 ********************************************************/
module joystick_mount()
{
    depth=5;
    width=60;
    height=40;
    difference()
    {
        basic_case(depth, true);
        joystick_pcb();
    }
}

/********************************************************
 * Middle Part with hose connector. Should give enough
 * for all wiring. If you solder the connections directly
 * the height of this part can be mouch lower.
 ********************************************************/
module middle()
{
    width=60;
    height=40;
    depth=20;
    
    module sub_middle_hose_connector()
    {
        translate([-33,0,5]) rotate([0,90,0]) cylinder(h=10,r=3, $fn=40);
        translate([-38,0,5]) rotate([0,90,0]) cylinder(h=10,r=1.7, $fn=40);

        
    }
    
    module sub_middle_basic_shape()
    {
        difference()
        {
            basic_case(depth,true);
            translate([0,0,depth/2]) cube([width,height-12,depth], center=true);
            translate([0,3,depth/2]) cube([width-12,height-6,depth], center=true);
        }
        
        sub_middle_hose_connector();
        
        // Arduino mount
        translate([10,0,1]) cube([width-30,height,2], center=true);
        translate([28,0,1]) cube([7,height-10,2], center=true);
    }
    
    difference()
    {
        sub_middle_basic_shape();

        // Arduino cutouts
        translate([32,-9,0]) rotate([180,0,180]) arduino_micro();
        
        
        // mounting nut
        translate([-6.5,-22,16]) cube( [13,6,5]);
        translate([0,-16,14.5]) rotate([90,0,0]) cylinder( h=6, r=6.5, $fn=6);
        translate([0,-20,14.5]) rotate([90,0,0]) cylinder( h=3, r=3.5, $fn=40);
        
        // Air hole
        translate([-38,0,5]) rotate([0,90,0]) cylinder(h=15,r=1, $fn=40);

        // OHW logo
        translate([0,23,10]) rotate([90,0,0]) linear_extrude(height=0.3) oshw_logo_2d(15);


    }
}

/********************************************************
 * Back plate of the case
 ********************************************************/
module back()
{
    width=60;
    height=40;
    difference()
    {
        hull()
        {
            translate([0,0,2])
            {
                basic_case(3, true);
            }  
            // Eye candy
            translate([(width/2-3),(height/2-3),0]) cylinder(r=5,h=2, $fn=40);
            translate([-(width/2-3),(height/2-3),0]) cylinder(r=5,h=2, $fn=40);
            translate([(width/2-3),-(height/2-3),0]) cylinder(r=5,h=2, $fn=40);
            translate([-(width/2-3),-(height/2-3),0]) cylinder(r=5,h=2, $fn=40);
        }
        translate([32,-9,5]) rotate([180,0,180]) arduino_micro();

        // Nut holes
        translate([(width/2-3),(height/2-3),0]) cylinder(r=3.3,h=3, $fn=6);
        translate([-(width/2-3),(height/2-3),0]) cylinder(r=3.3,h=3, $fn=6);
        translate([(width/2-3),-(height/2-3),0]) cylinder(r=3.3,h=3, $fn=6);
        translate([-(width/2-3),-(height/2-3),0]) cylinder(r=3.3,h=3, $fn=6);

        translate([(width/2-3),(height/2-3),3.2]) cylinder(r=1.7,h=2, $fn=40);
        translate([-(width/2-3),(height/2-3),3.2]) cylinder(r=1.7,h=2, $fn=40);
        translate([(width/2-3),-(height/2-3),3.2]) cylinder(r=1.7,h=2, $fn=40);
        translate([-(width/2-3),-(height/2-3),3.2]) cylinder(r=1.7,h=2, $fn=40);

    }


}

module overview()
{
    translate([0,0,60]) rotate([0,0,-90]) mouthpiece();
    translate([0,0,45]) joystick_case();
    translate([0,0,35]) joystick_mount();
    translate([0,0,10]) middle();
    translate([0,0,0]) back();
}

module mouthpiece_print()
{
    mouthpiece();
}

module joystick_case_print()
{
    joystick_case();
}

module joystick_mount_print()
{
    translate([0,0,5]) rotate([0,180,0]) joystick_mount();
}

module middle_print()
{
    middle();
    // add some support for printing
    translate([-38,-0.5,0]) cube([5,1,3.5]);
    translate([-26,-0.5,0]) cube([3,1,3]);
    translate([-38,-3,0]) cube([15,6,0.2]); // makes printing easier
}

module back_print()
{
    back();
}

overview();
//mouthpiece_print();
//joystick_case_print();
//joystick_mount_print();
//middle_print();
//back_print();












