// esp32cam_mb_enclosure - clip-mount

include <esp32_cam_mb_enclosure_common.scad>

mountClipHingeOuterDia=10;
mountClipHingeInnerDia=3.8;

mountClipWallThickness=2;
mountClipSlotInsertDepth=boxSideWallThickness-0.1;  // how deep into the slot the clip goes
mountClipSlotInsertTolerance=0;  // how much to shave off the insert for fit.

mountClipOuterWidth=boxOuterWidth+mountClipWallThickness*2;

overlap=0.01;
$fn=50;

// calculated
slotInsertHeight=mountClipSlotHeight-mountClipSlotInsertTolerance*2;
slotInsertDepth=mountClipSlotInsertDepth-mountClipSlotInsertTolerance*2;
// accommodates backplate thickness too
mountClipOuterDepth=mountClipWallThickness+mountClipSlotInsetFromBack+slotInsertDepth
    +mountClipSlotInsertTolerance+backPlateWallThickness;

hingeClip();
// check symmetry
* translate([0,0,overlap])
    mirror([1,0,0])
        color([1,0,0])
            hingeClip();
module hingeClip() {
    union() {
        // hinge part
        difference() {
            hull() {
                translate([0,-mountClipHingeOuterDia/2,0])
                    cylinder(d=mountClipHingeOuterDia, h=slotInsertHeight);

                translate([-mountClipHingeOuterDia/2,0,0])
                    cube([mountClipHingeOuterDia,overlap,slotInsertHeight]);
            }
            // hinge hole
            translate([0,-mountClipHingeOuterDia/2,-overlap])
                cylinder(d=mountClipHingeInnerDia, h=slotInsertHeight+overlap*2);
        }
        translate([-mountClipOuterWidth/2,0,0]) // center on y-axis
            difference() {
                cube([mountClipOuterWidth,mountClipOuterDepth,slotInsertHeight]);
                // cutout wide part (that goes around the box)
                translate([mountClipWallThickness,mountClipWallThickness,-overlap])
                    cube([boxOuterWidth,backPlateWallThickness+mountClipSlotInsetFromBack,slotInsertHeight+overlap*2]);
                // cutout the narrow part (between the inserts)    
                translate([mountClipWallThickness+mountClipSlotInsertDepth,
                        mountClipWallThickness+backPlateWallThickness+mountClipSlotInsetFromBack-overlap,
                        -overlap])
                    cube([boxOuterWidth-mountClipSlotInsertDepth*2,mountClipSlotDepth+overlap*2,slotInsertHeight+overlap*2]);
            }
    }
}