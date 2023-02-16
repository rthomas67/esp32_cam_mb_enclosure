// esp32cam_mb_enclosure - clip-mount

include <esp32_cam_mb_enclosure_common.scad>

mountClipHingeOuterDia=10;
mountClipHingeInnerDia=3.8;

mountClipWallThickness=2;
mountClipSlotInsertDepth=boxSideWallThickness-0.1;  // how deep into the slot the clip goes

mountClipInsertThicknessTolerance=0.05;  // how much to shave off the insert thickness for fit.
mountClipInsertThickness=mountClipSlotDepth-mountClipInsertThicknessTolerance*2;

mountClipOuterWidth=boxOuterWidth+mountClipWallThickness*2;

// This accounts for slight variations in sliced model for 3d printer to line things
// up when the printed part is slightly off because of rounding to position lines
insertInsetFromBackAdjust=0.3;

// how much extra room to leave on either side of the box, inside the sides of the clip
mountClipSideTolerance=0.1;

overlap=0.01;
$fn=50;

// calculated

// This makes the entire clip slightly shorter so it will fit top to bottom
slotInsertHeight=mountClipSlotHeight-mountClipInsertThicknessTolerance*2;

// accommodates backplate thickness and slot insert thickness with inner tolerance amount only
mountClipOuterDepth=mountClipWallThickness + backPlateWallThickness + mountClipSlotInsetFromBack
        + mountClipInsertThicknessTolerance + mountClipSlotInsertDepth + insertInsetFromBackAdjust;

innerBoxDepth=backPlateWallThickness + mountClipSlotInsetFromBack
        + mountClipInsertThicknessTolerance + insertInsetFromBackAdjust;
//backPlateWallThickness+mountClipSlotInsetFromBack        

hingeClip();
// check symmetry
* translate([0,0,overlap])
    mirror([1,0,0])
        color([1,0,0])
            hingeClip();
// compare w/ prev
* color([1,0,0]) import("esp32_cam_mb_enclosure_clip_mount_proto01.stl", convexity=3);            
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
        // clip part
        translate([-mountClipOuterWidth/2,0,0]) // center on y-axis
            difference() {
                cube([mountClipOuterWidth,mountClipOuterDepth,slotInsertHeight]);
                // cutout wide part (that goes around the box)
                translate([mountClipWallThickness-mountClipSideTolerance,mountClipWallThickness,-overlap])
                    cube([boxOuterWidth+mountClipSideTolerance*2,innerBoxDepth,slotInsertHeight+overlap*2]);
                // cutout the narrow part (between the inserts)    
                translate([mountClipWallThickness+mountClipSlotInsertDepth,
                        mountClipOuterDepth-mountClipInsertThickness-overlap,
                        -overlap])
                     cube([boxOuterWidth-mountClipSlotInsertDepth*2,mountClipInsertThickness+overlap*2,slotInsertHeight+overlap*2]);
            }
    }
}