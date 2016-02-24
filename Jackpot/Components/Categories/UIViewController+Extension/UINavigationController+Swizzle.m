//
//  UINavigationController+Swizzle.m
//  Jackpot
//
//  Created by WUFAN on 15/11/27.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UINavigationController+Swizzle.h"
#import <objc/runtime.h>

@implementation UINavigationController (Swizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        Method originalMethod, swizzleMethod;
        
        originalMethod = class_getInstanceMethod(cls, @selector(pushViewController:animated:));
        swizzleMethod = class_getInstanceMethod(cls, @selector(dp_pushViewController:animated:));
        method_exchangeImplementations(originalMethod, swizzleMethod);
        
        originalMethod = class_getInstanceMethod(cls, @selector(setViewControllers:animated:));
        swizzleMethod = class_getInstanceMethod(cls, @selector(dp_setViewControllers:animated:));
        method_exchangeImplementations(originalMethod, swizzleMethod);
    });
}

- (void)dp_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    UIViewController *someClassViewController;
    for (UIViewController *subViewController in self.viewControllers.reverseObjectEnumerator) {
        if ([subViewController isMemberOfClass:[viewController class]]) {
            someClassViewController = subViewController;
            break;
        }
    }
    
    // 视图栈存在相同的类，则删除中间的页面
    if (someClassViewController) {
        NSInteger index = [self.viewControllers indexOfObject:someClassViewController];
        NSMutableArray *viewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, index)].mutableCopy;
        [viewControllers addObject:viewController];
        [self dp_setViewControllers:viewControllers animated:animated];
    } else {
        [self dp_pushViewController:viewController animated:animated];
    }
}

- (void)dp_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    UIViewController *someClassViewController;
    UIViewController *lastViewController = viewControllers.lastObject;
    for (UIViewController *vc in viewControllers.reverseObjectEnumerator) {
        if (vc != viewControllers.firstObject) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        if (!someClassViewController && lastViewController != vc && [vc isMemberOfClass:lastViewController.class]) {
            someClassViewController = vc;
        }
    }
    
    // 视图栈存在相同的类，则删除中间的页面
    if (someClassViewController) {
        NSInteger index = [viewControllers indexOfObject:someClassViewController];
        NSMutableArray *copyViewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, index)].mutableCopy;
        [copyViewControllers addObject:lastViewController];
        viewControllers = copyViewControllers;
    }
    
    [self dp_setViewControllers:viewControllers animated:animated];
}

@end

@interface UINavigationController (Autorotate)

@end

@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate];
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end