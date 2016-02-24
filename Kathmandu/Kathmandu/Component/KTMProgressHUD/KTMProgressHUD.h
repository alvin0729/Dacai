//
//  KTMProgressHUD.h
//  Kathmandu
//
//  Created by WUFAN on 15/11/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMProgressHUD : UIView

//+ (void)showInViewController:(UIViewController *)viewController;
//+ (void)showInWindow:(UIWindow *)window;

+ (void)showInView:(UIView *)view withText:(NSString *)text;

@end
