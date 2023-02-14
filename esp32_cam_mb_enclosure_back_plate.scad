// esp32cam_mb_enclosure - back plate

include <esp32_cam_mb_enclosure_common.scad>

overlap=0.01;
$fn=50;

usbBackPlateFillDepth=1;
usbBackPlateFillTolerance=0.05;

resetBackPlateFillDepth=1;

backPlateSupportDepth=1.5;

backPlateTopSupportHeight=2;

backPlateBottomSupportHeight=7.5;
backPlateBottomSupportInsetFromBottom=8;

union() {
    cube([boxOuterWidth,boxOuterHeight,backPlateWallThickness]);
    
    translate([(boxOuterWidth/2-usbAccessHoleWidth/2)+usbBackPlateFillTolerance,0,backPlateWallThickness-overlap])
        cube([usbAccessHoleWidth-usbBackPlateFillTolerance*2,boxSideWallThickness,usbBackPlateFillDepth+overlap]);
        
    translate([boxSideWallThickness+boxInnerWidth,boxSideWallThickness,backPlateWallThickness-overlap])
        cube([boxSideWallThickness,resetButtonAccessHoleHeight,resetBackPlateFillDepth+overlap]);

    // top support
    translate([boxSideWallThickness,boxSideWallThickness+boxInnerHeight-backPlateTopSupportHeight,backPlateWallThickness-overlap])
        cube([boxInnerWidth,backPlateTopSupportHeight,backPlateSupportDepth+overlap]);

    // bottom support
    translate([boxSideWallThickness,boxSideWallThickness+backPlateBottomSupportInsetFromBottom,backPlateWallThickness-overlap])
        cube([boxInnerWidth,backPlateBottomSupportHeight,backPlateSupportDepth+overlap]);

}