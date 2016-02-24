//
//  UIButton+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KTMAdditions)

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                             image:(UIImage *)image
                              font:(UIFont *)font;

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                   backgroundImage:(UIImage *)backgroundImage
                              font:(UIFont *)font;

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                   backgroundColor:(UIColor *)backgroundColor
                              font:(UIFont *)font;

@end
