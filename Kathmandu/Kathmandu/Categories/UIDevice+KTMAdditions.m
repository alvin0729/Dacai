//
//  UIDevice+KTMAdditions.m
//  Kathmandu
//
//  Created by jacknathan on 15-3-9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "UIDevice+KTMAdditions.h"

@implementation UIDevice (KTMAdditions)

+ (BOOL)dp_orientationIsLandscape {
    UIInterfaceOrientation iOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;

    bool landscape = false;
    
    if (dOrientation == UIDeviceOrientationUnknown || dOrientation == UIDeviceOrientationFaceUp || dOrientation == UIDeviceOrientationFaceDown) {
        // If the device is laying down, use the UIInterfaceOrientation based on the status bar.
        landscape = UIInterfaceOrientationIsLandscape(iOrientation);
    } else {
        // If the device is not laying down, use UIDeviceOrientation.
        landscape = UIDeviceOrientationIsLandscape(dOrientation);
        
        // There's a bug in iOS!!!! http://openradar.appspot.com/7216046
        // So values needs to be reversed for landscape!
        if (dOrientation == UIDeviceOrientationLandscapeLeft)
            iOrientation = UIInterfaceOrientationLandscapeRight;
        else if (dOrientation == UIDeviceOrientationLandscapeRight)
            iOrientation = UIInterfaceOrientationLandscapeLeft;
        else if (dOrientation == UIDeviceOrientationPortrait)
            iOrientation = UIInterfaceOrientationPortrait;
        else if (dOrientation == UIDeviceOrientationPortraitUpsideDown)
            iOrientation = UIInterfaceOrientationPortraitUpsideDown;
    }
    
//    if (landscape) {
//        // Do stuff for landscape mode.
//    } else {
//        // Do stuff for portrait mode.
//    }
//    // Now manually rotate the view if needed.
//    switch (iOrientation) {
//        case UIInterfaceOrientationPortraitUpsideDown:
//            [self rotate:180.0f];
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            [self rotate:90.0f];
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//            [self rotate:-90.0f];
//            break;
//        case UIInterfaceOrientationPortrait:
//            break; //do nothing because it's fine
//        default:
//            break;
//    }
//    // Set the status bar to the right spot just in case
//    [[UIApplication sharedApplication] setStatusBarOrientation:iOrientation];
    
    return landscape;
}

@end
