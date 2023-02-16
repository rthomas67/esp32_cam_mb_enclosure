// esp32cam_mb_enclosure - back plate

include <esp32_cam_mb_enclosure_common.scad>

backPlateSupportDepth=1.5;

usbBackPlateFillDepth=1;
usbBackPlateFillTolerance=0.05;

resetBackPlateFillDepth=backPlateSupportDepth + 0.8;
resetBackPlateFillWidth=boxSideWallThickness*2; // circuit board corner is recessed a bit

backPlateTopSupportHeight=2;

backPlateBottomSupportHeight=7.5;
backPlateBottomSupportInsetFromBottom=8;

// Birdhouse-roof style hood, extending in front of the box, and to each side.
// Adjust dimensions after testing camera lens field-of-view interference
hoodAngle=25; // from horizontal on each side - double this for the apex angle
hoodOverhangCenter=30;
hoodOverhangSides=hoodOverhangCenter/2;
hoodPanelWidth=boxOuterWidth/2*1.75;  // TODO: calculate to account for actual slope angle
hoodPanelThickness=2;

overlap=0.01;
$fn=50;

// Calculated
hoodCenterLength=backPlateWallThickness + boxOuterDepth + hoodOverhangCenter;
hoodSideLength=backPlateWallThickness + boxOuterDepth + hoodOverhangSides;

/*
 * Calculate opposite side (center height) from adjacent side (1/2 box width) and angle.
 * tan(angle) = opposite / adjacent, so opposite = tan(angle) * adjacent
 */
gableHeight=(tan(hoodAngle) * (boxOuterWidth/2)) + overlap;


// reference model
*color([1,0,0]) 
    translate([-boxOuterWidth/2,0,backPlateWallThickness])
        import("esp32_cam_mb_enclosure_proto01.stl", convexity=3);

union() {
    // FIXME: hoodPanelThickness overlaps corners of back plate.  hood needs to be constructed outward, not inward
    //  but, that would leave a gap at the apex ridge, which needs to be filled.  maybe use extrude angle/shift??
    translate([-boxOuterWidth/2,0,0])
        plate();
    translate([0,gableHeight+boxOuterHeight,0])
        rotate([90,0,0])
            hood();
}

module plate() {
    union() {
        cube([boxOuterWidth,boxOuterHeight,backPlateWallThickness]);
        
        translate([(boxOuterWidth/2-usbAccessHoleWidth/2)+usbBackPlateFillTolerance,0,backPlateWallThickness-overlap])
            cube([usbAccessHoleWidth-usbBackPlateFillTolerance*2,boxSideWallThickness,usbBackPlateFillDepth+overlap]);

        // reset button fill-in block        
        translate([boxOuterWidth-resetBackPlateFillWidth,boxSideWallThickness,backPlateWallThickness-overlap])
            cube([resetBackPlateFillWidth,resetButtonAccessHoleHeight,resetBackPlateFillDepth+overlap]);

        // top support
        translate([boxSideWallThickness,boxSideWallThickness+boxInnerHeight-backPlateTopSupportHeight,backPlateWallThickness-overlap])
            cube([boxInnerWidth,backPlateTopSupportHeight,backPlateSupportDepth+overlap]);

        // bottom support
        translate([boxSideWallThickness,boxSideWallThickness+backPlateBottomSupportInsetFromBottom,backPlateWallThickness-overlap])
            cube([boxInnerWidth,backPlateBottomSupportHeight,backPlateSupportDepth+overlap]);

    }
}

module hood() {
    gableWallThickness=backPlateWallThickness;
    /* 
     * After rotation, adjacent side (thickness), and angle are known.  Inner vertex of hood panels
     * falls at the distance of the hypotenuse of the right triangle formed with the z-axis
     * Law of sines give hypotenuse from opposite-side/sin(angle), so complement angle to use adjacent side.
     */  
    rotatedThicknessShiftAmount=hoodPanelThickness/sin(90-hoodAngle);
    union() {
        translate([0,0,-rotatedThicknessShiftAmount])
            union() {
                // right side
                rotate([0,-hoodAngle,0])
                    hoodRoofPanel();
                // right side
                mirror([1,0,0]) rotate([0,-hoodAngle,0])
                    hoodRoofPanel();
            }
        // rear gable
        rotate([-90,0,0])
            linear_extrude(height = gableWallThickness) {
                    // note: constructed in -y quadrant to make it easier to rotate into position
                    polygon(points=[[-boxOuterWidth/2,-gableHeight],[0,0],[boxOuterWidth/2,-gableHeight]], paths=[[0,1,2,0]]);
            }
        // front gable  (note: this requires support material on the model, not just on print bed)
        translate([0,backPlateWallThickness+boxOuterDepth-gableWallThickness,0])
            hull() {
                rotate([-90,0,0])
                    linear_extrude(height = gableWallThickness) {
                            // note: constructed in -y quadrant to make it easier to rotate into position
                            polygon(points=[[-boxOuterWidth/2,-gableHeight],[0,0],[boxOuterWidth/2,-gableHeight]], paths=[[0,1,2,0]]);
                    }
                // this sloped block behind the front gable makes it possible to print w/o supports    
                translate([-overlap/2,gableWallThickness-boxOuterDepth,0])
                    cube([overlap, overlap, overlap]);
            }
    }
}

// Modeled for right, mirror for left
module hoodRoofPanel() {
    linear_extrude(height = hoodPanelThickness) {
        polygon(points=[[0,0],[0,hoodCenterLength],[hoodPanelWidth,hoodSideLength],[hoodPanelWidth,0]], 
            paths=[[0,1,2,3,0]]);
    }

}