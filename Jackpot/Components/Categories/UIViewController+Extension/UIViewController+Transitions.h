//
//  UIViewController+Transitions.h
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPTransitionAnimatorType) {
    DPTransitionAnimatorTypeNone,
    DPTransitionAnimatorTypeAlert,
    DPTransitionAnimatorTypeSheet,
};

@interface UIViewController (Transitions)

- (void)dp_showViewController:(UIViewController *)vc animatorType:(DPTransitionAnimatorType)type completion:(void (^)(void))completion;

@end
