//
//  UIButton+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIButton+KTMAdditions.h"

@implementation UIButton (KTMAdditions)

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                             image:(UIImage *)image
                              font:(UIFont *)font {
    UIButton *button = [[[self class] alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    return button;
}

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                   backgroundImage:(UIImage *)backgroundImage
                              font:(UIFont *)font {
    UIButton *button = [[[self class] alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    return button;
}

+ (instancetype)dp_buttonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                   backgroundColor:(UIColor *)backgroundColor
                              font:(UIFont *)font {
    UIButton *button = [[[self class] alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    [button.titleLabel setFont:font];
    return button;
}

@end
