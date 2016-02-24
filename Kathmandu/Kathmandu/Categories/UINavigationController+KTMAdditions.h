//
//  UINavigationController+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (KTMAdditions)
- (void)dp_applyGlobalTheme;
- (void)dp_replaceTopViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
