// Written by Volksswitch <www.volksswitch.org>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.


//------------------------------------------------------------------
// User Inputs
//------------------------------------------------------------------

/*[Part to Print]*/
part = "arm connector"; // [arm connector,front arm,side arm,back arm,pointer mount,pointer retention bolt]

/*[Arm Measurements]*/
brow_distance = 160; // [50:250]
top_of_ear_distance = 140; // [50:250]
//set to zero for shorter side arms
bottom_of_ear_distance = 0; // [0:300]
curve_of_skull_distance = 160; // [50:250]
//set to zero for shorter back arm
neck_distance = 0; // [0:300]
temple_angle = 75; // [60:90]
arm_thickness = 2; // [1:5]

/*[Elastic Measurements]*/
hat_band_width = 10; // [5:20]
hat_band_thickness = 1; // [1:2]
neck_band_width = 10; // [5:20]
neck_band_thickness = 1; // [1:2]
chin_band_width = 10; // [5:20]
chin_band_thickness = 1; // [1:4]
hat_band_attachment_type = "post"; // ["double slot", "post", "none"]
neck_band_attachment_type = "post"; // ["double slot", "post", "none"]
chin_band_attachment_type = "post"; // ["double slot", "post", "none"]

/*[Pointer Mount Measurements]*/
pointer_diameter = 9; // [5:15]
pointer_tightness = 0; // [-9:9]
pointer_angle = 0; // [0:20]
//affects only the pointer mount
pointer_retention_bolt_tightness = 0; // [-9:9]
//affects only the pointer mount
pointer_mount_tightness = 0; // [-9:9]
add_laser_pointer_slot = "no"; // ["yes","no"]
slot_width = 4; //[2:8]
slot_height = 3; // [2:5]

/*[Accessory Hole Info]*/
//separate numbers with commas and include brackets
front_accessory_holes = []; 
//separate numbers with commas and include brackets
side_accessory_holes = []; 
//separate numbers with commas and include brackets
back_accessory_holes = []; 
//separate numbers with commas and include brackets
connector_accessory_holes = []; 
accessory_hole_diameter = 8; // [1:10]

/*[Hidden]*/
//General variables
arm_width = 24;
dovetail_thickness = max(4,arm_thickness);
fudge = 0.005;
$fn = 40;

//arm_connector variables
front_base = 65;
side_base = 55;
back_base = 45;

//elastic variables
h_band_width = hat_band_width + 2;
h_band_thickness = hat_band_thickness + 1;
n_band_width = neck_band_width + 2;
n_band_thickness = neck_band_thickness + 1;
c_band_width = chin_band_width + 2;
c_band_thickness = chin_band_thickness + 1;

//arm variables
chin_strap_tab_dist = c_band_thickness*2 + 8;

front_arm = brow_distance - front_base - 4;
side_arm = (bottom_of_ear_distance==0) ? top_of_ear_distance - side_base + chin_strap_tab_dist + 2 - 4
										 : bottom_of_ear_distance - side_base + 2 + n_band_width + chin_strap_tab_dist - 4;
back_arm = (neck_distance==0) ? curve_of_skull_distance - back_base + 2 - 4 : neck_distance - back_base - 4;


//bolt and mount variables
mount_height = 20;
mount_len = 20;

grip_dia = 15;
grip_len = 10;
thread_len = 15;
thread_dia = 10;
bolt_scale = 1;
threaded_hole_scale = 1.05-pointer_retention_bolt_tightness/100;
threaded_hole_len = 15;
p_diam = pointer_diameter + pointer_tightness/10;


// ************* Main Program *****************
if (part == "arm connector"){
	difference(){
		arm_connector();
		count=len(connector_accessory_holes);
		echo(count);
		if(count>0){
			for(i=[0:count-1]){
				translate([-connector_accessory_holes[i],0,0])
				cylinder(d=accessory_hole_diameter,h=20,center=true);
			}
		}
	}
}
else if (part=="front arm"){
	difference(){
		front_arm();
		if(len(front_accessory_holes)>0){
			for(i=[0:len(front_accessory_holes)-1]){
				// if(front_accessory_holes[i] > 0){
					translate([front_accessory_holes[i]-front_base-front_arm/2-4,0,0])
					cylinder(d=accessory_hole_diameter,h=arm_thickness+fudge*2,center=true);
				// }
			}
		}
	}
}
else if (part=="side arm"){
	difference(){
		side_arm();
		if(len(side_accessory_holes)>0){
			for(i=[0:len(side_accessory_holes)-1]){
				// if(side_accessory_holes[i] > 0){
					translate([side_accessory_holes[i]-side_base-side_arm/2-4,0,0])
					cylinder(d=accessory_hole_diameter,h=arm_thickness+fudge*2,center=true);
				// }
			}
		}
	}
}
else if (part=="back arm"){
	difference(){
		back_arm();
		if(len(back_accessory_holes)>0){
			for(i=[0:len(back_accessory_holes)-1]){
				// if(back_accessory_holes[i] > 0){
					translate([back_accessory_holes[i]-back_base-back_arm/2-4,0,0])
					cylinder(d=accessory_hole_diameter,h=arm_thickness+fudge*2,center=true);
				// }
			}
		}
	}
}
else if (part=="pointer mount"){
	pointer_mount();
}
else if (part=="pointer retention bolt"){
	bolt();
	}

//************ Modules ***********

module arm_connector(){
	difference(){
		union(){
			translate([-front_base/2,0,0])
			union(){
				translate([-front_base/2,0,-arm_thickness/2])
				rotate([0,0,180])
				arm_connector_dove_tail();
				cube([front_base,arm_width,arm_thickness],center=true);
			}

			rotate([0,0,180])
			translate([-back_base/2,0,0])
			union(){
				translate([-back_base/2,0,-arm_thickness/2])
				rotate([0,0,180])
				arm_connector_dove_tail();
				cube([back_base,arm_width,arm_thickness],center=true);
			}

			rotate([0,0,-temple_angle])
			translate([-side_base/2,0,0])
			union(){
				translate([-side_base/2,0,-arm_thickness/2])
				rotate([0,0,180])
				arm_connector_dove_tail();
				cube([side_base,arm_width,arm_thickness],center=true);
			}

			rotate([0,0,temple_angle])
			translate([-side_base/2,0,0])
			union(){
				translate([-side_base/2,0,-arm_thickness/2])
				rotate([0,0,180])
				arm_connector_dove_tail();
				cube([side_base,arm_width,arm_thickness],center=true);
			}
			
			translate([-15.5,0,arm_thickness/2-2-fudge])
			arm_connector_pointer_dove_tail();
		}
		//center marker
		cylinder(d=2,h=arm_thickness+fudge*2,center=true);
		
		//chamfers on pointer mounting rails
		chamfer_len = 4 * 1.414 + fudge;
		
		translate([-15.5+fudge,0,arm_thickness/2+chamfer_len/2*1.414])
		difference(){
			rotate([0,45,0])
			cube([chamfer_len,24+fudge*2,chamfer_len],center=true);
			translate([4,0,0])
			cube([8,24+fudge*4,8],center=true);
		}
		
		translate([-front_base+2-fudge,0,arm_thickness/2+chamfer_len/2*1.414])
		rotate([0,180,0])
		difference(){
			rotate([0,45,0])
			cube([chamfer_len,24+fudge*2,chamfer_len],center=true);
			translate([4,0,0])
			cube([8,24+fudge*4,8],center=true);
		}
	}
}

module arm_connector_dove_tail(){
	translate([-2,-12,0])
	difference(){
		linear_extrude(height=dovetail_thickness)
		polygon([[0,0],[0,24],[6,24],[6,20],[2,22],[2,14],[6,16],[6,8],[2,10],[2,2],[6,4],[6,0]]);
	
		// translate([6.5,16.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[-2,0],[0,-2]]);
		
		// translate([6.5,4.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[-2,0],[0,-2]]);
		
		// translate([6.5,19.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[-2,0],[0,2]]);
		
		// translate([6.5,7.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[-2,0],[0,2]]);
	}
}

module arm_connector_pointer_dove_tail(){
	rotate([0,-90,0])
	difference(){
		translate([0,-arm_width/2,0])
		linear_extrude(height=front_base-17.5)
		polygon([[0,0],[0,24],[6,24],[6,20],[2,22],[2,14],[6,16],[6,8],[2,10],[2,2],[6,4],[6,0]]);
		
		if(arm_thickness==1){
			translate([.5+fudge,0,23.5])
			rotate([0,90,0])
			cube([front_base-16.5+fudge*2,24+fudge*2,1+fudge*2],center=true);
		}
	
		translate([6.5,4.5,0])
		linear_extrude(height=front_base-17)
		polygon([[0,0],[-2,0],[0,-2]]);
		
		translate([6.5,-7.5,0])
		linear_extrude(height=front_base-17)
		polygon([[0,0],[-2,0],[0,-2]]);
		
		translate([6.5,-4.5,0])
		linear_extrude(height=front_base-17)
		polygon([[0,0],[-2,0],[0,2]]);
		
		translate([6.5,7.5,0])
		linear_extrude(height=front_base-17)
		polygon([[0,0],[-2,0],[0,2]]);
	}
}

module arm_dove_tail(){
	translate([-6,-12,0])
	difference(){
		linear_extrude(height=dovetail_thickness)
		polygon([[6,24],[6,20],[2,22],[2,14],[6,16],[6,8],[2,10],[2,2],[6,4],[6,0],[8,0],[8,24],[6,24]]);
		
		// translate([1.5,22.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[2,0],[0,-2]]);
		
		// translate([1.5,10.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[2,0],[0,-2]]);
		
		// translate([1.5,13.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[2,0],[0,2]]);
		
		// translate([1.5,1.5,-fudge])
		// linear_extrude(height=dovetail_thickness+fudge*2)
		// polygon([[0,0],[2,0],[0,2]]);
	}
	
}

module front_arm(){
	difference(){
		union(){
			translate([-front_arm/2,0,-arm_thickness/2])
			arm_dove_tail();
			translate([0,0,-arm_thickness/2])
			linear_extrude(height=arm_thickness)
			offset(r=2)
			square([front_arm-4,arm_width-4],center=true);
		}
		
		if (hat_band_attachment_type=="double slot"){
			translate([front_arm/2-h_band_width/2-2,0,0])
			four_slots(h_band_width,h_band_thickness);
		}
	}
	
	if (hat_band_attachment_type=="post"){
		translate([front_arm/2-h_band_width/2-2,0,0])
		post(h_band_width,h_band_thickness);
	}
}

module back_arm(){
	difference(){
		union(){
			translate([-back_arm/2,0,-arm_thickness/2])
			arm_dove_tail();
			translate([0,0,-arm_thickness/2])
			linear_extrude(height=arm_thickness)
			offset(r=2)
			square([back_arm-4,arm_width-4],center=true);
		}
		
		if (neck_distance==0){
			if (hat_band_attachment_type=="double slot"){
				translate([back_arm/2-h_band_width/2-2,0,0])
				four_slots(h_band_width,h_band_thickness);
			}
		}
		else{
			if (hat_band_attachment_type=="double slot"){
				translate([-back_arm/2+curve_of_skull_distance-back_base-h_band_width/2,0,0])
				four_slots(h_band_width,h_band_thickness);
			}		
			if (neck_band_attachment_type=="double slot"){
				translate([back_arm/2-n_band_width/2-2,0,0])
				four_slots(n_band_width,n_band_thickness);
			}
		}
	}
	if (neck_distance==0){
		if (hat_band_attachment_type=="post"){
			translate([back_arm/2-h_band_width/2-2,0,0])
			post(h_band_width,h_band_thickness);
		}
	}
	else{
		if (hat_band_attachment_type=="post"){
				translate([-back_arm/2+curve_of_skull_distance-back_base-h_band_width/2,0,0])
				post(h_band_width,h_band_thickness);
		}
		if (neck_band_attachment_type=="post"){
				translate([back_arm/2-n_band_width/2-2,0,0])
				post(n_band_width,n_band_thickness);
		}
	}
}

module side_arm(){
	difference(){
		union(){
			translate([-side_arm/2,0,-arm_thickness/2])
			arm_dove_tail();
			translate([0,0,-arm_thickness/2])
			linear_extrude(height=arm_thickness)
			offset(r=2)
			square([side_arm-4,arm_width-4],center=true);
		}
		
		if(bottom_of_ear_distance == 0){
			if(hat_band_attachment_type=="double slot"){
				translate([-side_arm/2+top_of_ear_distance-side_base-h_band_width/2,0,0])
				four_slots(h_band_width,h_band_thickness);
			}
		}
		else{
			if(hat_band_attachment_type=="double slot"){
				translate([-side_arm/2+top_of_ear_distance-side_base-h_band_width/2,0,0])
				four_slots(h_band_width,h_band_thickness);
			}
			if(neck_band_attachment_type=="double slot"){
				translate([-side_arm/2+bottom_of_ear_distance-side_base+n_band_width/2+2,0,0])
				four_slots(n_band_width,n_band_thickness);
			}
		}
		if(chin_band_attachment_type=="double slot"){
			translate([side_arm/2-c_band_thickness/2-2,0,0])
			rotate([0,0,90])
			slot(c_band_width,c_band_thickness);

			translate([side_arm/2-c_band_thickness/2*3-4,0,0])
			rotate([0,0,90])
			slot(c_band_width,c_band_thickness);
		}
	}
	if(bottom_of_ear_distance == 0){
		if(hat_band_attachment_type=="post"){
			translate([-side_arm/2+top_of_ear_distance-side_base-h_band_width/2,0,0])
			post(h_band_width,h_band_thickness);
		}
	}
	else{
		if(hat_band_attachment_type=="post"){
			translate([-side_arm/2+top_of_ear_distance-side_base-h_band_width/2,0,0])
			post(h_band_width,h_band_thickness);
		}
		if(neck_band_attachment_type=="post"){
			translate([-side_arm/2+bottom_of_ear_distance-side_base+n_band_width/2+2,0,0])
			post(n_band_width,n_band_thickness);
		}
	}
	if(chin_band_attachment_type=="post"){
		translate([side_arm/2-c_band_thickness/2-2,0,0])
		rotate([0,0,90])
		post(c_band_width,c_band_thickness);
	}
}

module four_slots(elastic_band_width,elastic_band_thickness){
	translate([0,-arm_width/2+elastic_band_thickness/2+2,0])
	slot(elastic_band_width,elastic_band_thickness);
	translate([0,-arm_width/2+elastic_band_thickness/2*3+4,0])
	slot(elastic_band_width,elastic_band_thickness);
	translate([0,arm_width/2-elastic_band_thickness/2-2,0])
	slot(elastic_band_width,elastic_band_thickness);
	translate([0,arm_width/2-elastic_band_thickness/2*3-4,0])
	slot(elastic_band_width,elastic_band_thickness);
}

module slot(width,thickness){
	cube([width-thickness,thickness,arm_thickness+fudge*2],center=true);
	translate([-width/2+thickness/2,0,0])
	cylinder(d=thickness,h=arm_thickness+fudge*2,center=true);
	translate([width/2-thickness/2,0,0])
	cylinder(d=thickness,h=arm_thickness+fudge*2,center=true);
}

module post(width,thickness){
	translate([0,0,arm_thickness/2-fudge*2])
	cylinder(d1=3,d2=6,h=5);
}

module pointer_mount(){
	rotate([0,-90,0])
	union(){
		difference(){
			intersection(){
				translate([0,0,-10])
				linear_extrude(height=20)
				offset(delta=2,chamfer=true)
				square([p_diam+12-4,24-4],center=true);
				
				
				rotate([0,90,0])
				translate([0,0,-(p_diam+12)/2])
				linear_extrude(height=p_diam+12)
				offset(delta=2,chamfer=true)
				square([20-4,24-4],center=true);
			}
			
			//pointer hole
			cylinder(d=p_diam,h=20+fudge*2,center=true);
			
			//threaded hole for pointer retention bolt
			translate([-mount_height/2+threaded_hole_len-5-fudge,0,0])
			rotate([0,-90,0])
			threads(thread_dia,1.5,threaded_hole_len,threaded_hole_scale,60);
			
			if(add_laser_pointer_slot=="yes"){
				translate([-(p_diam+slot_height)/2+.5,0,0])
				rotate([0,90,0])
				cube([20+fudge*2,slot_width,slot_height],center=true);
			}
		}

		rotate([0,180,0])
		translate([-(p_diam+12)/2,0,0])
		pointer_dove_tails();
	}
}

module pointer_dove_tails_base(){
	a = cos(pointer_angle) * 20;
	b = sin(pointer_angle) * 20;
	
	translate([0,0,-a/2])
	rotate([0,-90,0])
	rotate([90,0,0])
	linear_extrude(height=15)
	polygon([[0,0],[a,0],[0,b]]);

}

module pointer_dove_tails(){
	a = cos(pointer_angle) * 20;
	b = sin(pointer_angle) * 20;
	
	//dove tails base
	base_width = 16;
	
	translate([0,base_width/2,-a/2])
	rotate([0,-90,0])
	rotate([90,0,0])
	linear_extrude(height=base_width)
	polygon([[0,0],[a,0],[0,b]]);


	//dove tails
	gap = pointer_mount_tightness/10;
	
	translate([0,0,a/2])
	rotate([0,pointer_angle,0])
	translate([0,0,-10])
	difference(){
		translate([-6,-12,-10])
		linear_extrude(height=20)
		polygon([[6,24],[6,20+gap],[2-gap,22+gap],[2-gap,14-gap],[6,16-gap],[6,8+gap],[2-gap,10+gap],[2-gap,2-gap],[6,4-gap],[6,0],[8,0],[8,24]]);
		
		//remove platform
		translate([1,0,0])
		rotate([0,90,0])
		cube([20+fudge*2,24+fudge*2,2+fudge*2],center=true);
	
		translate([-4.5-gap,2-gap,-10-fudge])
		linear_extrude(height=20+fudge*2)
		polygon([[0,0],[2,0],[0,2]]);
		
		translate([-4.5-gap,-10-gap,-10-fudge])
		linear_extrude(height=20+fudge*2)
		polygon([[0,0],[2,0],[0,2]]);
		
		translate([-4.5-gap,-2+gap,-10-fudge])
		linear_extrude(height=20+fudge*2)
		polygon([[0,0],[2,0],[0,-2]]);
		
		translate([-4.5-gap,10+gap,-10-fudge])
		linear_extrude(height=20+fudge*2)
		polygon([[0,0],[2,0],[0,-2]]);
		
		translate([-4-gap-fudge,0,-10])
		rotate([0,180,0])
		end_trim();
		
		translate([-4-gap-fudge,0,10])
		rotate([0,180,0])
		end_trim();
	}
}

module end_trim(){
	chamfer_len = 4 * 1.414 + fudge;
	difference(){
		rotate([0,45,0])
		cube([chamfer_len,24+fudge*2,chamfer_len],center=true);
		translate([4,0,0])
		cube([8,24+fudge*4,8],center=true);
	}
}

module bolt(){
	difference(){
		union(){
			translate([0,0,grip_len-fudge])
			threads(thread_dia,1.5,thread_len,bolt_scale,60);
			cylinder(d=grip_dia,h=grip_len,$fn=8);
		}

		translate([0,0,grip_len+thread_len+fudge])
		rotate_extrude($fn=200)
		polygon([[4,0],[thread_dia/2,0],[thread_dia/2,-2]]);
	}
}



//sine_thread.scad by Ron Butcher (aka. Ming of Mongo), 
//with bits borrowed from ISOThread by Trevor Moseley
//
//Thread libs for OpenSCAD are hideously slow.  I love OpenSCAD, but that's the fact.
//But I found that, if you are cool with approximating iso threads with a sine wave,
//you can make very smooth threads really fast just by spinning a circle around.
//
//Actually, you could make near perfect threads by specifying a polygon other than a circle
//with the exact screw cross-section you need, but I leave that as an excersize for those
//who care more than I do.  Circle works for me.
//
//threads module gives a threaded rod
//hex_nut(diameter) does just what you think
//hex_screw(diameter, length) gives an M(diameter) hex head screw with length mm of thread.
//
//defaults get you an M4 x 10mm bolt and an M4 nut.  If you want something non standard,
//you can supply the pitch, head height and diameter, rez(olution) and a scaling factor
//to help make up for the oddities of everyone's individual printers and settings.
//
//Finer layering gets you better results.  At .1mm layer height, my M4 threads kick ass.
//
//This is all metric, but you can translate US diameters and pitch to mm easily enough.


module threads(diameter=4,pitch=undef,length=10,scale=1,rez=20){
	pitch = (pitch!=undef) ? pitch : get_coarse_pitch(diameter);
	twist = length/pitch*360;
	depth=pitch*.6;
	linear_extrude(height = length, center = false, convexity = 10, twist = -twist, $fn = rez)
		translate([depth/2, 0, 0]){
			circle(r = scale*diameter/2-depth/2);
		}
}	

module hex_nut(	diameter = 4,
				height = undef, 
				span = undef,  
				pitch = undef, 
				scale = 1, 
				rez = 20){
	height = (height!=undef) ? height : hex_nut_hi(diameter);
	span = (span!=undef) ? span : hex_nut_dia(diameter);
	
	difference(){
		cylinder(h=height,r=span/2, $fn=6); //six sided cylinder
		threads(diameter,pitch,height,scale,rez);
		cylinder(h=diameter/2, r1=diameter/2, r2=0, $fn=rez);
		translate([0,0,height+.0001])
		rotate([180,0,0])
		cylinder(h=diameter/2, r1=diameter/2, r2=0, $fn=rez);
	}
}

module hex_screw(diameter = 4, 
				length = 10, 
				height = undef, 
				span = undef, 
				pitch = undef, 
				scale = 1, 
				rez = 20){
	height = (height!=undef) ? height : hex_bolt_hi(diameter);
	span = (span!=undef) ? span : hex_bolt_dia(diameter);
	cylinder(h=height,r=span/2,$fn=6); //six sided cylinder
	translate([0,0,height])
	threads(diameter,pitch,length,scale,rez);
}

// Lookups shamelessly stolen from ISOThread.scad by Trevor Moseley
// function for thread pitch
function get_coarse_pitch(dia) = lookup(dia, [
[1,0.25],[1.2,0.25],[1.4,0.3],[1.6,0.35],[1.8,0.35],[2,0.4],[2.5,0.45],[3,0.5],[3.5,0.6],[4,0.7],[5,0.8],[6,1],[7,1],[8,1.25],[10,1.5],[12,1.75],[14,2],[16,2],[18,2.5],[20,2.5],[22,2.5],[24,3],[27,3],[30,3.5],[33,3.5],[36,4],[39,4],[42,4.5],[45,4.5],[48,5],[52,5],[56,5.5],[60,5.5],[64,6],[78,5]]);

// function for hex nut diameter from thread size
function hex_nut_dia(dia) = lookup(dia, [
[3,6.4],[4,8.1],[5,9.2],[6,11.5],[8,16.0],[10,19.6],[12,22.1],[16,27.7],[20,34.6],[24,41.6],[30,53.1],[36,63.5]]);
// function for hex nut height from thread size
function hex_nut_hi(dia) = lookup(dia, [
[3,2.4],[4,3.2],[5,4],[6,3],[8,5],[10,5],[12,10],[16,13],[20,16],[24,19],[30,24],[36,29]]);


// function for hex bolt head diameter from thread size
function hex_bolt_dia(dia) = lookup(dia, [
[3,6.4],[4,8.1],[5,9.2],[6,11.5],[8,14.0],[10,16],[12,22.1],[16,27.7],[20,34.6],[24,41.6],[30,53.1],[36,63.5]]);
// function for hex bolt head height from thread size
function hex_bolt_hi(dia) = lookup(dia, [
[3,2.4],[4,3.2],[5,4],[6,3.5],[8,4.5],[10,5],[12,10],[16,13],[20,16],[24,19],[30,24],[36,29]]);


