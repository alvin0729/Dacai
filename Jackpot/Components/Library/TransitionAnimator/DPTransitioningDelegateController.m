//
//  DPTransitioningDelegateController.m
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPTransitioningDelegateController.h"

@interface DPTransitioningDelegateController ()
@property (nonatomic, strong) DPTransitionAnimator<UIViewControllerAnimatedTransitioning> *animator;
@end

@implementation DPTransitioningDelegateController

+ (instancetype)controllerWithAnimator:(DPTransitionAnimator *)animator {
    DPTransitioningDelegateController *controller = [[[self class] alloc] init];
    controller.animator = (DPTransitionAnimator<UIViewControllerAnimatedTransitioning> *)animator;
    return controller;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animator;
}

@end

