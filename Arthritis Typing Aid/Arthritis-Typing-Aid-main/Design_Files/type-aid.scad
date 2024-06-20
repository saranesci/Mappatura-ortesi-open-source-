//radius of sphere
r=40;
//Thickness of finger
a=10;
//Reach of Finger Past Sphere
b=100;

difference(){
union(){
sphere(r=r,center=true);

difference(){
resize(newsize=[r*2,(r*2)+b,a])
    cylinder(a,r=r,center=true);
resize(newsize=[r*2-a,(r*2)+b-a,a+1])
    cylinder(a+1,r=r-(a/2),center=true);
translate([r*3,0,0])
    cube(r*6,center=true);
translate([0,-r*2,0])
    cube(r*4,center=true);
}
}
//Un-Comment to make halves for printing
//translate([0,0,-r*5])
    //cube(r*10,center=true);
}