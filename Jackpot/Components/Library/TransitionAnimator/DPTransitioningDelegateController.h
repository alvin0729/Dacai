//
//  DPTransitioningDelegateController.h
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPTransitionAnimator;
@interface DPTransitioningDelegateController : NSObject<UIViewControllerTransitioningDelegate>
+ (instancetype)controllerWithAnimator:(DPTransitionAnimator *)animator;
@end