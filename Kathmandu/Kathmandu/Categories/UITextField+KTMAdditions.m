//
//  UITextField+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UITextField+KTMAdditions.h"

@implementation UITextField (KTMAdditions)

+ (instancetype)dp_textFieldWithText:(NSString *)text
                           textColor:(UIColor *)textColor
                         placeholder:(NSString *)placeholder
                                font:(UIFont *)font {
    UITextField *textField = [[[self class] alloc] init];
    textField.text = text;
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.font = font;
    return textField;
}

@end
