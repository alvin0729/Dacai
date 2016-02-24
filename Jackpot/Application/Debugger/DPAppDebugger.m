//
//  DPAppDebugger.m
//  Jackpot
//
//  Created by WUFAN on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifdef DEBUG

#import "DPAppDebugger.h"
#import "DPAppDebuggerViewController.h"

@interface DPAppDebugger () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIWindow *window;
@end

@implementation DPAppDebugger

+ (DPAppDebugger *)defaultDebugger {
    static DPAppDebugger *debugger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        debugger = [[DPAppDebugger alloc] init];
    });
    return debugger;
}

- (void)panHandler:(UIPanGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint velocity = [gesture velocityInView:self.window];
    if (fabs(velocity.y) <= fabs(velocity.x)) {
        return;
    }
    if (velocity.y > 0) {
        return;
    }
    
    UIViewController *topmostViewController = [KTMHierarchySearcher topmostViewController];
    UINavigationController *navigationController = [UINavigationController dp_controllerWithRootViewController:[[DPAppDebuggerViewController alloc] init]];
    [topmostViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)attach:(UIWindow *)window {
#ifdef DEBUG
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    gesture.minimumNumberOfTouches = 2;
    gesture.maximumNumberOfTouches = 5;
    gesture.delegate = self;
    [window addGestureRecognizer:gesture];
    self.window = window;
#endif
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end




#endif