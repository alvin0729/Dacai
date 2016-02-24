//
//  NSString+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NSStringFromUTF8String(stdlib_string)   [NSString stringWithUTF8String:stdlib_string.c_str()]

@interface NSString (KTMAdditions)

+ (NSString *)dp_uuidString;

//- (NSString *)dp_joinSeparateString:(NSString *)string;

+ (CGSize)dpsizeWithSting:(NSString *)string andFont:(UIFont *)font andMaxWidth:(CGFloat)maxWidth;
+ (CGSize)dpsizeWithSting:(NSString *)string andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;
/**
 *  金额字符串是否符合标准
 *
 *  @param moneyStr 金额字符串
 *
 *  @return bool值
 */
+ (BOOL)checkMoneyRoleText:(NSString *)moneyStr;
/**
 *  判断字符串是否是手机号
 */
- (BOOL)checkPhoneNumInput;
@end
