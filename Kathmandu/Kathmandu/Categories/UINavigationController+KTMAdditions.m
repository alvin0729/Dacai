//
//  UINavigationController+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UINavigationController+KTMAdditions.h"
#import "UIImage+KTMAdditions.h"
#import "UIColor+KTMAdditions.h"
#import "UIFont+KTMAdditions.h"

@implementation UINavigationController (KTMAdditions)

- (void)dp_applyGlobalTheme {
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont dp_boldSystemFontOfSize:17]}];
}

- (void)dp_replaceTopViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers removeLastObject];
    [viewControllers addObject:viewController];
    [self setViewControllers:viewControllers animated:animated];
}

@end
