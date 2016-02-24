//
//  UIViewController+KTMAdditions.m
//  Kathmandu
//
//  Created by wufan on 15/3/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "UIViewController+KTMAdditions.h"

@implementation UIViewController (KTMAdditions)

- (BOOL)dp_isOrientationLandscape {
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }
}

@end
