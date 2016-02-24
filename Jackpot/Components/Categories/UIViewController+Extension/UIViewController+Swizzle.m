//
//  UIViewController+Basic.m
//  Jackpot
//
//  Created by WUFAN on 15/11/26.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "UIViewController+Swizzle.h"
#import "DPAnalyticsKit.h"
#import "DPAnalyticsKit+ControllerTable.h"

const static void *kShowsNavigationBar = &kShowsNavigationBar;

@implementation UIViewController (Swizzle)

#pragma mark - Method Swizzle
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        Method originalMethod, swizzleMethod;
        
        originalMethod = class_getInstanceMethod(cls, @selector(viewWillAppear:));
        swizzleMethod = class_getInstanceMethod(cls, @selector(dp_viewWillAppear:));
        method_exchangeImplementations(originalMethod, swizzleMethod);
        
        originalMethod = class_getInstanceMethod(cls, @selector(viewWillDisappear:));
        swizzleMethod = class_getInstanceMethod(cls, @selector(dp_viewWillDisappear:));
        method_exchangeImplementations(originalMethod, swizzleMethod);
    });
}

#pragma mark - View life cycle
- (void)dp_viewWillAppear:(BOOL)animated {
    [self dp_viewWillAppear:animated];

    if (!self.dp_isProjectViewController) {
        return;
    }
    // 自定义转场动画
    if (self.isBeingPresented && self.modalPresentationStyle == UIModalPresentationCustom) {
        return;
    }
    
    // 控制是否显示导航栏
    [self.navigationController setNavigationBarHidden:self.dp_shouldNavigationBarHidden animated:animated];
    
    // 数据统计
    [DPAnalyticsKit logPageBegin:[DPAnalyticsKit nameForViewController:self]];
}

- (void)dp_viewWillDisappear:(BOOL)animated {
    [self dp_viewWillDisappear:animated];
    
    if ([KTMKeyboardManager defaultManager].isKeyboardVisible) {
        [self.view endEditing:YES];
    }
    
    if (!self.dp_isProjectViewController) {
        return;
    }
    
    // 自定义转场动画
    if (self.isBeingDismissed && self.modalPresentationStyle == UIModalPresentationCustom) {
        return;
    }
    // 数据统计
    [DPAnalyticsKit logPageEnd:[DPAnalyticsKit nameForViewController:self]];
}

- (BOOL)dp_isProjectViewController {
    if ([self isKindOfClass:[UINavigationController class]] ||
        [self isKindOfClass:[UITabBarController class]]) {
        return NO;
    }
    NSString *className = NSStringFromClass(self.class);
    if (![className hasPrefix:@"DP"] && ![className hasPrefix:@"UM"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Property (getter, setter)
- (void)dp_setShouldNavigationBarHidden:(BOOL)shouldNavigationBarHidden {
    objc_setAssociatedObject(self, kShowsNavigationBar, @(shouldNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dp_shouldNavigationBarHidden {
    return [objc_getAssociatedObject(self, kShowsNavigationBar) boolValue];
}

@end

#pragma mark - 横屏控制
@interface UIViewController (Autorotate)
@end

@implementation UIViewController (Autorotate)

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end