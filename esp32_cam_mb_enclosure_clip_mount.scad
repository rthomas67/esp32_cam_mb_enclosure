// esp32cam_mb_enclosure - clip-mount

include <esp32_cam_mb_enclosure_common.scad>

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

antennaMountPlateThickness=2.2;
antennaMountHoleDia=6.5;
antennaMountPlateOuterDia=13;
antennaMountPlateHingeOverlap=0.5;
antennaCountersinkDepth=6;
// measured 9.1.  9.2 didn't print big enough
antennaCountersinkHexDia=9.5;

antennaWireHolderOuterDia=7;
antennaWireHolderInnerDia=4;
antennaWireHolderThickness=2.5;

overlap=0.01;
$fn=50;

// calculated

// This makes the entire clip slightly shorter so it will fit top to bottom
slotInsertHeight=mountClipSlotHeight-mountClipInsertThicknessTolerance*2;

// accommodates backplate thickness and slot insert thickness with inner tolerance amount only
mountClipOuterDepth=mountClipWallThickness + backPlateWallThickness + mountClipSlotInsetFromBack
        + mountClipInsertThicknessTolerance + mountClipSlotInsertDepth + insertInsetFromBackAdjust;

mountClipInnerCutoutDepth=backPlateWallThickness + mountClipSlotInsetFromBack
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
            // nut countersink
            translate([0,-mountClipHingeOuterDia/2,slotInsertHeight*4/5])
                cylinder(d=m4NutCountersinkDia, h=slotInsertHeight/5+overlap, $fn=6);
        }
        // clip part
        removalTabDepth=mountClipWallThickness*2/3;
        removalTabTipWidth=mountClipWallThickness/3;
        translate([-mountClipOuterWidth/2,0,0]) // center on y-axis
            difference() {
                union() {
                    cube([mountClipOuterWidth,mountClipOuterDepth,slotInsertHeight]);
                    // removal tab left
                    translate([0,mountClipOuterDepth-overlap,0])
                    hull() {
                        cube([mountClipWallThickness,overlap,slotInsertHeight]);
                        translate([0,removalTabDepth-overlap,0])
                            cube([removalTabTipWidth,overlap,slotInsertHeight]);
                    }
                    // removal tab right
                    translate([mountClipWallThickness+boxOuterWidth,mountClipOuterDepth-overlap,0])
                    hull() {
                        cube([mountClipWallThickness,overlap,slotInsertHeight]);
                        translate([mountClipWallThickness-removalTabTipWidth,removalTabDepth-overlap,0])
                            cube([removalTabTipWidth,overlap,slotInsertHeight]);
                    }
                }
                // cutout wide part (that goes around the box)
                translate([mountClipWallThickness-mountClipSideTolerance,mountClipWallThickness,-overlap])
                    cube([boxOuterWidth+mountClipSideTolerance*2,mountClipInnerCutoutDepth,slotInsertHeight+overlap*2]);
                // cutout the narrow part (between the inserts)    
                translate([mountClipWallThickness+mountClipSlotInsertDepth,
                        mountClipOuterDepth-mountClipInsertThickness-overlap,
                        -overlap])
                     cube([boxOuterWidth-mountClipSlotInsertDepth*2,mountClipInsertThickness+overlap*2,slotInsertHeight+overlap*2]);
            }
        // antenna mount plate part
        translate([mountClipHingeOuterDia/2+antennaMountPlateOuterDia/2-antennaMountPlateHingeOverlap,0,0])
            difference() {
                hull() {
                    translate([0,-antennaMountPlateOuterDia/2,0])
                        cylinder(d=antennaMountPlateOuterDia, h=antennaMountPlateThickness+antennaCountersinkDepth);

                    translate([-antennaMountPlateOuterDia/2,0,0])
                        cube([antennaMountPlateOuterDia,overlap,antennaMountPlateThickness+antennaCountersinkDepth]);
                }
                // antenna connector hole
                translate([0,-antennaMountPlateOuterDia/2,-overlap])
                    cylinder(d=antennaMountHoleDia, h=antennaMountPlateThickness+overlap*2);
                // antenna connector countersink
                translate([0,-antennaMountPlateOuterDia/2,antennaMountPlateThickness-overlap])
                    cylinder(d=antennaCountersinkHexDia, h=antennaCountersinkDepth+overlap*2, $fn=6);
            }
        // antenna wire holder
        antennaWireHolderWallThickness=(antennaWireHolderOuterDia-antennaWireHolderInnerDia)/2;
        translate([-mountClipOuterWidth/2+antennaWireHolderWallThickness,
                mountClipWallThickness+mountClipInnerCutoutDepth/2-antennaWireHolderThickness/2,
                antennaWireHolderOuterDia/2])
            rotate([0,90,90])
            difference() {
                hull() {
                    translate([0,antennaWireHolderOuterDia/2,0])
                        cylinder(d=antennaWireHolderOuterDia, h=antennaWireHolderThickness);
                    // flat base
                    translate([-antennaWireHolderOuterDia/2,0,0])
                        cube([antennaWireHolderOuterDia,overlap,antennaWireHolderThickness]);
                    // flat side (for printing against build plate w/o support)
                    // Note: 4/5 of full side tapers in but not enough to require supports
                    translate([antennaWireHolderOuterDia/2-overlap,0,0])
                        cube([overlap,antennaWireHolderOuterDia*4/5,antennaWireHolderThickness]);
                }
                // antenna wire holder hole
                translate([0,antennaWireHolderOuterDia/2,-overlap])
                    cylinder(d=antennaWireHolderInnerDia, h=antennaWireHolderThickness+overlap*2);
            }
               
    }
}