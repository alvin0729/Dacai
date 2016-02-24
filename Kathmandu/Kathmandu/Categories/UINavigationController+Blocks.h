//
//  UINavigationController+Blocks.h
//  Kathmandu
//
//  Created by WUFAN on 14-9-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Blocks)

- (UIViewController *)dp_popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;
- (NSArray *)dp_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;
- (NSArray *)dp_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion;

@end
