//
//  UIViewController+HUD.m
//  Kathmandu
//
//  Created by WUFAN on 14-9-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

static const void *WINDOW_HUD_KEY = &WINDOW_HUD_KEY;
static const void *VIEW_CONTROLLER_HUD_KEY = &VIEW_CONTROLLER_HUD_KEY;

@interface UIWindow (HUD)
@property (nonatomic, strong, readonly) MBProgressHUD *progressHUD;

- (void)showDarkHUD;
- (void)showDarkHUDWithText:(NSString *)text;
- (void)dismissHUD;
@end

@implementation UIWindow (HUD)

- (void)pvt_showHUD {
    if (self.progressHUD.superview == nil) {
        [self addSubview:self.progressHUD];
    }
    
    [self.window bringSubviewToFront:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showDarkHUD {
    [self.progressHUD setLabelText:nil];
    [self.progressHUD setDimBackground:YES];
    [self pvt_showHUD];
}

- (void)showDarkHUDWithText:(NSString *)text {
    [self.progressHUD setLabelText:text];
    [self.progressHUD setDimBackground:YES];
    [self pvt_showHUD];
}

- (void)dismissHUD {
    [self.progressHUD hide:YES];
}

- (MBProgressHUD *)progressHUD {
    MBProgressHUD *progressHUD = objc_getAssociatedObject(self, WINDOW_HUD_KEY);
    if (progressHUD == nil) {
        progressHUD = [[MBProgressHUD alloc] initWithWindow:self];
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.color = [UIColor whiteColor];
        progressHUD.activityIndicatorColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        
        objc_setAssociatedObject(self, WINDOW_HUD_KEY, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return progressHUD;
}

@end

@interface UIViewController ()

@property (nonatomic, strong, readonly) MBProgressHUD *progressHUD;
@property (nonatomic, assign, readonly, getter = isHUDLoaded) BOOL HUDLoaded;

@end

@implementation UIViewController (HUD)

- (void)pvt_showHUD {
    if (self.progressHUD.superview == nil) {
        [self.view addSubview:self.progressHUD];
    }
    
    [self.view bringSubviewToFront:self.progressHUD];
    [self.progressHUD show:YES];
}

- (void)showHUD {
    [self.progressHUD setLabelText:nil];
    [self.progressHUD setDimBackground:NO];
    [self pvt_showHUD];
}

- (void)showHUDWithText:(NSString *)text {
    [self.progressHUD setLabelText:text];
    [self.progressHUD setDimBackground:NO];
    [self pvt_showHUD];
}

- (void)dismissHUD {
    if (self.isHUDLoaded) {
        [self.progressHUD hide:YES];
    }
}

- (BOOL)isHUDAppear {
    return self.isHUDLoaded && self.progressHUD.superview != nil;
    return NO;
}

- (MBProgressHUD *)progressHUD {
    MBProgressHUD *progressHUD = objc_getAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY);
    if (progressHUD == nil) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.minSize = CGSizeMake(90, 70);
        progressHUD.color = [UIColor whiteColor];
        progressHUD.activityIndicatorColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1];
        
        objc_setAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return progressHUD;
}

- (BOOL)isHUDLoaded {
    return (objc_getAssociatedObject(self, VIEW_CONTROLLER_HUD_KEY) != nil);
}

#pragma mark - dark

- (void)showDarkHUD {
    [self.window showDarkHUD];
}

- (void)showDarkHUDWithText:(NSString *)text {
    [self.window showDarkHUDWithText:text];
}

- (void)dismissDarkHUD {
    [self.window dismissHUD];
}

- (UIWindow *)window {
    return self.view.window ?: [[[UIApplication sharedApplication] delegate] window];
}

@end
