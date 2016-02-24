//
//  UITextField+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 15/11/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (KTMAdditions)

+ (instancetype)dp_textFieldWithText:(NSString *)text
                           textColor:(UIColor *)textColor
                         placeholder:(NSString *)placeholder
                                font:(UIFont *)font;

@end
