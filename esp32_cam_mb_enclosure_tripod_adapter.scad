// esp32cam_mb_enclosure - tripod adapter
// add threaded rod to use the hinge hole 

include <esp32_cam_mb_enclosure_common.scad>

adapterThickness=9;  // minimum that will accomodate a nutsert for 1/4 x 20

// brass threaded insert 1/4-20 outer dia is 9mm, so this needs to be slightly smaller
tripodHoleInnerDia=8;
tripodHoleWallThickness=3;
tripodHoleOuterDia=tripodHoleInnerDia+tripodHoleWallThickness*2;

/*
 * The inner dia of the mount-clip hinge is 3.8, so...
 * Asked https://www.perplexity.ai : "what is the outer diameter of an m4 nut"
 * and it pulled info from boltdepot's web site to yield the answer 7.2mm.
 * The value here has a bit of margin to avoid fitting too tightly.
 */
nutCountersinkDia=7.4;

antiRotationPinRadius=13.5; // from center of tripod mount - per online ref and measured from manfroto plate
antiRotationPinHoleDia=5; // measured from manfroto plate

tripodHoleInset=mountClipHingeOuterDia;

overlap=0.01;
$fn=50;

difference() {
    hull() {
        cylinder(d=mountClipHingeOuterDia, h=adapterThickness);
        translate([0,tripodHoleInset,0])
            cylinder(d=tripodHoleOuterDia, h=adapterThickness);
        // anti-rotation pin base "wing" 1
        translate([antiRotationPinRadius,tripodHoleInset,0])
            cylinder(d=antiRotationPinHoleDia*2, h=adapterThickness);
        // anti-rotation pin base "wing" 2
        translate([-antiRotationPinRadius,tripodHoleInset,0])
            cylinder(d=antiRotationPinHoleDia*2, h=adapterThickness);

    }
    // hinge threaded-rod through hole
    translate([0,0,-overlap])
        cylinder(d=mountClipHingeInnerDia, h=adapterThickness+overlap*2);
    // hinge threaded-rod hex-nut-countersink
    translate([0,0,adapterThickness*2/3+overlap])
        cylinder(d=nutCountersinkDia, h=adapterThickness/3+overlap, $fn=6);

    // tripod 1/4"-20 threaded insert hole
    translate([0,tripodHoleInset,-overlap])
        cylinder(d=tripodHoleInnerDia, h=adapterThickness+overlap*2);

    // anti-rotation pin hole 1
    translate([antiRotationPinRadius,tripodHoleInset,adapterThickness/3+overlap])
        cylinder(d=antiRotationPinHoleDia, h=adapterThickness*2/3+overlap);
    // anti-rotation pin hole 2
    translate([-antiRotationPinRadius,tripodHoleInset,adapterThickness/3+overlap])
        cylinder(d=antiRotationPinHoleDia, h=adapterThickness*2/3+overlap);

}