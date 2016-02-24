//
//  UILabel+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (KTMAdditions)

+ (instancetype)dp_labelWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;

+ (instancetype)dp_labelWithText:(NSString *)text
                 backgroundColor:(UIColor *)backgroundColor
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;

+ (instancetype)dp_labelWithText:(NSString *)text
                   textAlignment:(NSTextAlignment)textAlignment
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;

+ (instancetype)dp_labelWithText:(NSString *)text
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;

+ (instancetype)dp_labelWithText:(NSString *)text
                 backgroundColor:(UIColor *)backgroundColor
                   textAlignment:(NSTextAlignment)textAlignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font;

@end
