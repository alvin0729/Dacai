//
//  DPTransitionAnimator.h
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类不能直接使用, 需要通过继承该类进行使用, 子类必须实现 DPTransitionAnimatorProtocol 协议
 */
@interface DPTransitionAnimator : NSObject
@property (nonatomic, assign) NSTimeInterval presentedDuration;     // default is 0.3
@property (nonatomic, assign) NSTimeInterval dismissedDuration;     // default is 0.2
+ (instancetype)animator;
@end

@protocol DPTransitionAnimatorProtocol <NSObject>
@required
- (void)presentedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)dismissedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
@end

@interface DPAlertTransitionAnimator : DPTransitionAnimator <DPTransitionAnimatorProtocol>
@end

@interface DPSheetTransitionAnimator : DPTransitionAnimator <DPTransitionAnimatorProtocol>
@end