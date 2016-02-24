//
//  DPTransitionAnimator.m
//  Jackpot
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPTransitionAnimator.h"

@interface DPDimBackgroundView : UIView
@end

@implementation DPDimBackgroundView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    //Gradient center
    CGPoint gradCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    //Gradient radius
    float gradRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    //Gradient draw
    CGContextDrawRadialGradient(context, gradient, gradCenter,
                                0, gradCenter, gradRadius,
                                kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}
@end

@interface DPTransitionAnimator ()
@property (nonatomic, weak) id<DPTransitionAnimatorProtocol> child;
@property (nonatomic, strong) UIView *dimBackgroundView;
@end

@implementation DPTransitionAnimator

#pragma mark - Life cycle

+ (instancetype)animator {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        NSAssert([self conformsToProtocol:@protocol(DPTransitionAnimatorProtocol)],
                 @"DPTransitionAnimator 的子类必须实现 DPTransitionAnimatorProtocol 协议");
        
        _child = (id<DPTransitionAnimatorProtocol>)self;
        _presentedDuration = 0.3;
        _dismissedDuration = 0.2;
    }
    return self;
}

#pragma mark - Delegate
#pragma mark - UIViewControllerContextTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *const fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *const toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toController presentedViewController] != fromController) {
        return self.presentedDuration;
    } else {
        return self.dismissedDuration;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *const fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *const toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toController presentedViewController] != fromController) {
        [self.child presentedAnimateTransition:transitionContext];
    } else {
        [self.child dismissedAnimateTransition:transitionContext];
    }
}

#pragma mark - Property (getter, setter)

- (UIView *)dimBackgroundView {
    if (!_dimBackgroundView) {
//        _dimBackgroundView = [[DPDimBackgroundView alloc] init];
//        _dimBackgroundView.backgroundColor = [UIColor clearColor];
        _dimBackgroundView = [UIView dp_viewWithColor:[UIColor dp_coverColor]];
    }
    return _dimBackgroundView;
}

@end

@implementation DPAlertTransitionAnimator

- (void)presentedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *toView = toViewController.view;
    CGRect finalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    self.dimBackgroundView.alpha = 0;
    self.dimBackgroundView.frame = finalFrame;
    toView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    toView.alpha = 0;
   
    [containerView addSubview:toView];
    [containerView insertSubview:self.dimBackgroundView belowSubview:toView];
    
    [UIView animateWithDuration:duration * 0.75 animations:^{
        toView.alpha = 1;
        self.dimBackgroundView.alpha = 1;
    }];
    [UIView animateWithDuration:duration
        delay:0
        usingSpringWithDamping:1
        initialSpringVelocity:0.5
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            toView.transform = CGAffineTransformIdentity;
        }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
}

- (void)dismissedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0;
        self.dimBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dimBackgroundView removeFromSuperview];
        [fromView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

@implementation DPSheetTransitionAnimator

- (void)presentedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

- (void)dismissedAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

@end
