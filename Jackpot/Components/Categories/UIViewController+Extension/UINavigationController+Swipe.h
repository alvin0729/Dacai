//
//  UINavigationController+Swipe.h
//  Jackpot
//
//  Created by WUFAN on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerSwiping <NSObject>
@optional
- (BOOL)shouldSwipeBack;
@end

@interface UINavigationController (Swipe)
+ (instancetype)dp_controllerWithRootViewController:(UIViewController *)viewController;
@end
