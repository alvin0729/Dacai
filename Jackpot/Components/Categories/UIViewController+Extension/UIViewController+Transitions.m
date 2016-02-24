//
//  UIViewController+Transitions.m
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIViewController+Transitions.h"
#import "DPTransitioningDelegateController.h"
#import "DPTransitionAnimator.h"
#import <objc/runtime.h>

static const void *kTransitioningDelegateControllerKey = &kTransitioningDelegateControllerKey;

@interface UIViewController ()
@property (nonatomic, strong, setter=dp_setTransitioningDelegateController:) DPTransitioningDelegateController *dp_transitioningDelegateController;
@end

@implementation UIViewController (Transitions)

- (void)dp_showViewController:(UIViewController *)vc animatorType:(DPTransitionAnimatorType)type completion:(void (^)(void))completion {
    switch (type) {
        case DPTransitionAnimatorTypeNone:
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.dp_transitioningDelegateController = nil;
            break;
        case DPTransitionAnimatorTypeAlert:
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.dp_transitioningDelegateController = [DPTransitioningDelegateController controllerWithAnimator:[DPAlertTransitionAnimator animator]];
            break;
        case DPTransitionAnimatorTypeSheet:
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.dp_transitioningDelegateController = [DPTransitioningDelegateController controllerWithAnimator:[DPSheetTransitionAnimator animator]];
            break;
        default:
            break;
    }
    vc.transitioningDelegate = vc.dp_transitioningDelegateController;
    [self presentViewController:vc animated:YES completion:completion];
}

#pragma mark - Property (getter, setter)

- (void)dp_setTransitioningDelegateController:(DPTransitioningDelegateController *)transitioningDelegateController {
    objc_setAssociatedObject(self, kTransitioningDelegateControllerKey, transitioningDelegateController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DPTransitioningDelegateController *)dp_transitioningDelegateController {
    return objc_getAssociatedObject(self, kTransitioningDelegateControllerKey);
}

@end
