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

