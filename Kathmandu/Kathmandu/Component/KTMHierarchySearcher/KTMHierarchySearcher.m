//
//  KTMHierarchySearcher.m
//  Kathmandu
//
//  Created by WUFAN on 15/10/29.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMHierarchySearcher.h"

@implementation KTMHierarchySearcher

+ (__kindof UIViewController *)topmostViewController {
    return [self topmostViewControllerFrom:[[self baseWindow] rootViewController]
                              includeModal:YES];
}

+ (__kindof UIViewController *)topmostNonModalViewController {
    return [self topmostViewControllerFrom:[[self baseWindow] rootViewController]
                              includeModal:NO];
}

+ (__kindof UINavigationController *)topmostNavigationController {
    return [self topmostNavigationControllerFrom:[self topmostViewController]];
}

+ (__kindof UINavigationController *)topmostNavigationControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]])
        return (UINavigationController *)vc;
    if ([vc navigationController])
        return [vc navigationController];

    return nil;
}

+ (__kindof UIViewController *)topmostViewControllerFrom:(UIViewController *)viewController
                                   includeModal:(BOOL)includeModal {
    if ([viewController isKindOfClass:[UITabBarController class]] && [viewController respondsToSelector:@selector(selectedViewController)])
        return [self topmostViewControllerFrom:[(id)viewController selectedViewController]
                                  includeModal:includeModal];

    if (includeModal && viewController.presentedViewController)
        return [self topmostViewControllerFrom:viewController.presentedViewController
                                  includeModal:includeModal];

    if ([viewController isKindOfClass:[UINavigationController class]] && [viewController respondsToSelector:@selector(topViewController)])
        return [self topmostViewControllerFrom:[(id)viewController topViewController]
                                  includeModal:includeModal];

    return viewController;
}

+ (UIWindow *)baseWindow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (!window)
        window = [[UIApplication sharedApplication] keyWindow];

    NSAssert(window != nil, @"No window to calculate hierarchy from");
    return window;
}

@end
