//
//  UIViewController+DPUALoginToOpenBet.m
//  Jackpot
//
//  Created by mu on 15/12/24.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIViewController+DPUALoginToOpenBet.h"
#import "DPLogOnViewController.h"
#import "DPLoginViewController.h"
#import "DPThirdLoginVerifyController.h"
@implementation UIViewController (DPUALoginToOpenBet)
- (void)dpViewController:(UIViewController *)viewController removerControllerFromLogOnToOpenBetWithAnimated:(BOOL)animated{
     NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
       
        UIViewController *controller = self.navigationController.viewControllers[i];
        if ([controller isKindOfClass:[DPLoginViewController class]]) {
            [viewControllers removeObject:controller];
        }
        
        if ([controller isKindOfClass:[DPLogOnViewController class]]) {
            [viewControllers removeObject:controller];
        }
        
        if ([controller isKindOfClass:[DPThirdLoginVerifyController class]]) {
            [viewControllers removeObject:controller];
        }
    }
    [viewControllers addObject:viewController];
    [self.navigationController setViewControllers:viewControllers animated:animated];
}
@end
