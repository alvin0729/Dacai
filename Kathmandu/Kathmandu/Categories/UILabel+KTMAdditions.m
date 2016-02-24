//
//  UILabel+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UILabel+KTMAdditions.h"

@implementation UILabel (KTMAdditions)

+ (instancetype)dp_labelWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font {
    return [self dp_labelWithText:text
                  backgroundColor:nil
                    textAlignment:NSTextAlignmentLeft
                    lineBreakMode:NSLineBreakByTruncatingTail
                        textColor:textColor
                             font:font];
}

+ (instancetype)dp_labelWithText:(NSString *)text
                 backgroundColor:(UIColor *)backgroundColor
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font {
    return [self dp_labelWithText:text
                  backgroundColor:backgroundColor
                    textAlignment:NSTextAlignmentLeft
                    lineBreakMode:NSLineBreakByTruncatingTail
                        textColor:textColor
                             font:font];
}

+ (instancetype)dp_labelWithText:(NSString *)text
                   textAlignment:(NSTextAlignment)textAlignment
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font {
    return [self dp_labelWithText:text
                  backgroundColor:nil
                    textAlignment:textAlignment
                    lineBreakMode:NSLineBreakByTruncatingTail
                        textColor:textColor
                             font:font];
}

+ (instancetype)dp_labelWithText:(NSString *)text
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font {
    return [self dp_labelWithText:text
                  backgroundColor:nil
                    textAlignment:NSTextAlignmentLeft
                    lineBreakMode:lineBreakMode
                        textColor:textColor
                             font:font];
}

+ (instancetype)dp_labelWithText:(NSString *)text
                 backgroundColor:(UIColor *)backgroundColor
                   textAlignment:(NSTextAlignment)textAlignment
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font {
    UILabel *label = [[[self class] alloc] init];
    label.text = text;
    label.backgroundColor = backgroundColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = 0;
    label.lineBreakMode = lineBreakMode;
    label.textColor = textColor;
    label.font = font;
    return label;
}

@end
