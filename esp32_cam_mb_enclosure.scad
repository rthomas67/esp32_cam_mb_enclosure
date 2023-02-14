/*
 Enclosure Box for esp32-cam + esp32-cam-mb combination
 Purchased 2/2023 from: https://www.amazon.com/dp/B09265G5Z4
 Price: including tax and Colorado's illegal "delivery fee", about $8 each
 */ 

include <esp32_cam_mb_enclosure_common.scad>

sdSlotDepth=3;
sdSlotWidth=15;
sdSlotFlareAmount=boxSideWallThickness/2;
sdSlotFlareDepth=sdSlotDepth+sdSlotFlareAmount*2;
sdSlotFlareWidth=sdSlotWidth+sdSlotFlareAmount*2;
sdSlotCenterOffset=0.2;
sdSlotInsetFromFace=2.5;

cameraHoleHeightCenterPosition=30.5;  // relative to boxInnerHeight bottom
cameraHoleWidthCenterPosition=boxInnerWidth/2;  // centered
cameraHoleDia=8;
cameraHoleFlareAmount=boxFrontPanelThickness/2;  // ~60 degree bevel
cameraHoleFlareDia=cameraHoleDia+cameraHoleFlareAmount*2;

ledHoleHeight=5;
ledHoleWidth=5;
ledHoleFlareAmount=boxFrontPanelThickness/2;
ledHoleFlareHeight=ledHoleHeight+ledHoleFlareAmount*2;
ledHoleFlareWidth=ledHoleWidth+ledHoleFlareAmount*2;
ledHoleBottomPosition=8.4;  // relative to boxInnerHeight bottom
ledHoleSideInsetPosition=0; // relative to boxInnerWidth on closest side.

usbAccessHoleDepth=8;  // relative to boxInnerDepth from rear

// this is on the same side as the LED (right when facing front of box)
resetButtonAccessHoleDepth=5;
resetButtonAccessHoleFlareDepth=resetButtonAccessHoleDepth+boxSideWallThickness*2;
resetButtonAccessHoleFlareHeight=resetButtonAccessHoleHeight+boxSideWallThickness*2;

topCornerSupportWidth=5;
topCornerSupportHeight=3.5;
topCornerSupportDepth=5.1;

bottomSupportHeight=5;
bottomSupportDepth=topCornerSupportDepth;


overlap=0.01;

$fn=50;

// calculated

union() {
    boxWithCutouts();
    // bottom support
    translate([boxSideWallThickness-overlap,boxSideWallThickness,boxInnerDepth-bottomSupportDepth])
        cube([boxInnerWidth+overlap*2,bottomSupportHeight+overlap,bottomSupportDepth+overlap]);
    // top left support
    translate([boxSideWallThickness-overlap,boxSideWallThickness+boxInnerHeight-topCornerSupportHeight,boxInnerDepth-topCornerSupportDepth])
        cube([topCornerSupportWidth+overlap,topCornerSupportHeight+overlap,topCornerSupportDepth+overlap]);
    // top right support
    translate([boxSideWallThickness+boxInnerWidth-topCornerSupportWidth,boxSideWallThickness+boxInnerHeight-topCornerSupportHeight,boxInnerDepth-topCornerSupportDepth])
        cube([topCornerSupportWidth+overlap,topCornerSupportHeight+overlap,topCornerSupportDepth+overlap]);
}

module boxWithCutouts() {
    difference() {
        cube([boxOuterWidth,boxOuterHeight,boxOuterDepth]);
        translate([boxSideWallThickness,boxSideWallThickness,-overlap])
            cube([boxInnerWidth,boxInnerHeight,boxInnerDepth+overlap]);
        translate([boxSideWallThickness,boxSideWallThickness,0]) {
            // camera hole
            translate([cameraHoleWidthCenterPosition,cameraHoleHeightCenterPosition,boxInnerDepth-overlap])
                cylinder(d1=cameraHoleDia, d2=cameraHoleFlareDia, h=boxFrontPanelThickness+overlap*2);
            // led hole
            translate([boxInnerWidth-ledHoleWidth-ledHoleSideInsetPosition,
                    ledHoleBottomPosition,boxInnerDepth-overlap])
                hull() {
                    cube([ledHoleWidth,ledHoleHeight,overlap]);
                    translate([-ledHoleFlareAmount,-ledHoleFlareAmount,boxFrontPanelThickness+overlap])
                        cube([ledHoleFlareWidth,ledHoleFlareHeight,overlap]);
                }
            // sd card slot
            translate([boxInnerWidth/2-sdSlotWidth/2+sdSlotCenterOffset,
                    boxInnerHeight-overlap,boxInnerDepth-sdSlotDepth-sdSlotInsetFromFace])
                hull() {
                    cube([sdSlotWidth,overlap,sdSlotDepth]);
                    translate([-sdSlotFlareAmount,boxSideWallThickness+overlap,-sdSlotFlareAmount])
                        cube([sdSlotFlareWidth,overlap,sdSlotFlareDepth]);
                }
            // usb access hole
            translate([boxInnerWidth/2-usbAccessHoleWidth/2,-boxSideWallThickness-overlap,-overlap])
                cube([usbAccessHoleWidth,boxSideWallThickness+overlap*2,usbAccessHoleDepth+overlap]);
            // mount clip holes (one cube cutting all the way across)
            translate([-boxSideWallThickness-overlap,mountClipSlotHeightPosition,mountClipSlotInsetFromBack])
                cube([boxOuterWidth+overlap*2,mountClipSlotHeight,mountClipSlotDepth]);
            // reset button access hole (on the right side)
            translate([boxInnerWidth-overlap,-overlap,0])
                hull() {
                    cube([overlap,resetButtonAccessHoleHeight,resetButtonAccessHoleDepth]);
                    translate([boxSideWallThickness+overlap,-boxSideWallThickness,-boxSideWallThickness])
                        cube([overlap,resetButtonAccessHoleFlareHeight,resetButtonAccessHoleFlareDepth]);
                }

        }
    }

}