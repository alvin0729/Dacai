//
//  UIViewController+Basic.h
//  Jackpot
//
//  Created by WUFAN on 15/11/26.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Swizzle)
/**
 *  是否隐藏导航栏, 默认为 NO
 */
@property (nonatomic, assign, setter=dp_setShouldNavigationBarHidden:) BOOL dp_shouldNavigationBarHidden;
@end
