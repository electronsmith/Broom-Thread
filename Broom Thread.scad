/************** BEST VIEWED IN A CODE EDITOR 80 COLUMNS WIDE *******************
*
* Libman Broom
Thread
* Benjamen Johnson <3dprints.electronsmith.com>
* 20220730
*
* openSCAD Version: 2021.01
* Licesnse: Creative Commons - Attribution - Share Alike
*           https://creativecommons.org/licenses/by-sa/4.0/
*******************************************************************************/
/*[Hidden]*/
// add a little bit to cuts to make them render properly
$dl = 0.01;

// Mmmmmm... Pie
PI = 3.14159265358979;

/*[Broom Thread Parameters]*/
/*******************************************************************************
*******************************************************************************/
// Diameter of the stop flange
flange_dia = 24.0;

// Height of the stop flange
flange_height = 4.0;
 
// Diameter of the cylinder under the threads
cylinder_dia = 14.5;

// Length of the threaded part
threaded_length = 25.0;
 
// Diameter of the cylinders that make of the threads
thread_form_dia = 2.5;

// Number of threads per inch
thread_pitch = 5.0;
 
// How may segments in a circle (resolution of the threads) 
$fn=32;

/*[Bolt Parameters]*/
/*******************************************************************************
*******************************************************************************/

//Diameter of the bolt shaft
bolt_shaft_dia = 6.5;

//Thickness of the bolt head
bolt_head_thickness = 4.5;

// What is the wrench size of the hex head to be pressed in
bolt_head_size = 11;

// Calculate the point to point diameter of the pressed nut
pt_to_pt_hex_dia = 2*(bolt_head_size/2)/cos(30);
 
/*******************************************************************************
* Make it
*******************************************************************************/
difference(){
    union(){
        cylinder(d=cylinder_dia,h=threaded_length);
        Cyl_Thread(thread_pitch,(threaded_length - thread_form_dia/2),cylinder_dia,thread_form_dia/2,$fn);
        translate([0,0,-flange_height])
        cylinder(d=flange_dia,h=flange_height);
    }//union
    
    translate([0,0,threaded_length-bolt_head_thickness+$dl])
    cylinder(d=pt_to_pt_hex_dia,h=bolt_head_thickness,$fn=6);
    
    translate([0,0,0]) 
    cylinder(d=bolt_shaft_dia,h=10*threaded_length,center=true);
}//difference

/*******************************************************************************
* Function taken from Broom Handle Screw End Plug
* Ed Nisley March 2013
* https://softsolder.com/2013/04/01/broom-handle-screw-thread-replacement-plug/
*******************************************************************************/
module Cyl_Thread(pitch,length,pitchdia,cyl_radius,resolution=32) {
 
Cyl_Adjust = 1.25;                      // force overlap
 
    Turns = length/pitch;
    Slices = Turns*resolution;
    RotIncr = 1/resolution;
    PitchRad = pitchdia/2;
    ZIncr = length/Slices;
    helixangle = atan(pitch/(PI*pitchdia));
    cyl_len = Cyl_Adjust*(PI*pitchdia)/resolution;
 
    union() {
        for (i = [0:Slices-1]) {
            translate([PitchRad*cos(360*i/resolution),PitchRad*sin(360*i/resolution),i*ZIncr])
                rotate([90+helixangle,0,360*i/resolution])
                    cylinder(r=cyl_radius,h=cyl_len,center=true,$fn=12);
        }
    }
}
