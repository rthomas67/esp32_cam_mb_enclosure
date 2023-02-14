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

overlap=0.01;
$fn=50;

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