// common values for esp32_cam_mb_enclosure

boxFrontPanelThickness=2.25;
boxSideWallThickness=1.5;

backPlateWallThickness=1.5;

boxInnerHeight=41;
boxInnerWidth=28;
boxInnerDepth=21;

mountClipSlotHeight=15.5;  // positioned relative to boxInnerHeight
mountClipSlotDepth=2; // positioned relative to boxInnerDepth
mountClipSlotHeightPosition=17;  // bottom of the slot
mountClipSlotInsetFromBack=7; // rearmost edge


// calculated
boxOuterWidth=boxInnerWidth+boxSideWallThickness*2;
boxOuterHeight=boxInnerHeight+boxSideWallThickness*2;
boxOuterDepth=boxInnerDepth+boxFrontPanelThickness;

usbAccessHoleWidth=11;  // centered relative to boxInnerWidth

resetButtonAccessHoleHeight=6;

mountClipHingeOuterDia=10;
mountClipHingeInnerDia=3.8;

/*
 * The inner dia of the mount-clip hinge is 3.8, so...
 * Asked https://www.perplexity.ai : "what is the outer diameter of an m4 nut"
 * and it pulled info from boltdepot's web site to yield the answer 7.2mm.
 * However, the measured nut diameter is 6mm, so adjust as needed.
 */
m4NutCountersinkDia=6.4;
