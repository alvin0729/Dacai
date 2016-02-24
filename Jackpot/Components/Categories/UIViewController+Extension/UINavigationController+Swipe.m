//
//  UINavigationController+Swipe.m
//  Jackpot
//
//  Created by WUFAN on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UINavigationController+Swipe.h"
#import <objc/runtime.h>

// 修正返回按钮的偏移
@interface DPCustomNavigationBar : UINavigationBar
@property (nonatomic, strong, readonly) UIView *backIndicatorView;
@end

@implementation DPCustomNavigationBar
@synthesize backIndicatorView = _backIndicatorView;

- (UIView *)backIndicatorView {
    if (!_backIndicatorView) {
        // 返回按钮类: _UINavigationBarBackIndicatorView, 规避私有API风险
        NSString *_UINavigationBarBackIndicatorView = [[NSString alloc] initWithData:[KTMCrypto base64Decoding:@"X1VJTmF2aWdhdGlvbkJhckJhY2tJbmRpY2F0b3JWaWV3"] encoding:NSUTF8StringEncoding];
        
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:_UINavigationBarBackIndicatorView]) {
                _backIndicatorView = view;
                break;
            }
        }
    }
    return _backIndicatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.backIndicatorView.frame;
    frame.origin.x = 16;
    self.backIndicatorView.frame = frame;
}

@end

// 处理手势
@interface DPInteractiveTransition : NSProxy <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id originDelegate;
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation DPInteractiveTransition

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.originDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

#pragma mark - Message forward
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.originDelegate respondsToSelector:aSelector]) {
        return self.originDelegate;
    }
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 控制器数量少于1时, 不触发手势
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    UIViewController<UIViewControllerSwiping> *viewController = (id)self.navigationController.topViewController;
    if ([viewController respondsToSelector:@selector(shouldSwipeBack)]) {
        return [viewController shouldSwipeBack];
    }
    return [self.originDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 控制器数量少于1时, 不触发手势
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    UIViewController<UIViewControllerSwiping> *viewController = (id)self.navigationController.topViewController;
    if ([viewController respondsToSelector:@selector(shouldSwipeBack)]) {
        return [viewController shouldSwipeBack];
    }
    return [self.originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([NSStringFromClass(otherGestureRecognizer.class) isEqualToString:@"UIScrollViewPanGestureRecognizer"]) {
//        return YES;
//    }
//    return NO;
//}

@end

const static void *kInteractiveTransitionKey = &kInteractiveTransitionKey;
@interface UINavigationController (SwipeInteractive)
@property (nonatomic, strong, readonly) DPInteractiveTransition *dp_interactiveTransition;
@end

@implementation UINavigationController (SwipeInteractive)

- (DPInteractiveTransition *)dp_interactiveTransition {
    DPInteractiveTransition *transition = objc_getAssociatedObject(self, kInteractiveTransitionKey);
    if (transition == nil) {
//        transition = [[DPInteractiveTransition alloc] init];
        transition = [DPInteractiveTransition alloc];
        transition.navigationController = self;
        objc_setAssociatedObject(self, kInteractiveTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return transition;
}

@end

@implementation UINavigationController (Swipe)

+ (instancetype)dp_controllerWithRootViewController:(UIViewController *)viewController {
    UIImage *image = [UIImage dp_imageWithColor:[UIColor dp_flatRedColor]];

    UINavigationController *navigationController = [[[self class] alloc] initWithNavigationBarClass:[DPCustomNavigationBar class]
                                                                                       toolbarClass:nil];
    [navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if (viewController) {
        [navigationController pushViewController:viewController animated:NO];
    }
    
    navigationController.dp_interactiveTransition.navigationController = navigationController;
    navigationController.dp_interactiveTransition.originDelegate = navigationController.interactivePopGestureRecognizer.delegate;
    navigationController.navigationBar.translucent = NO;
    navigationController.interactivePopGestureRecognizer.delegate = navigationController.dp_interactiveTransition;

    return navigationController;
}

@end
