//
//  KTMValidator.h
//  Kathmandu
//
//  Created by wufan on 15/9/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMValidator : NSObject


/**
 *  验证是否是纯数字
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isNumber:(NSString *)string;

/**
 *  验证是否是邮箱地址
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isEmail:(NSString *)string;

/**
 *  验证是否是手机号码
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isPhoneNumber:(NSString *)string;

/**
 *  验证是否是身份证号
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isIdentifier:(NSString *)string;

/**
 *  验证是否是纯汉字
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isHanZi:(NSString *)string;

/**
 *  验证是否是纯字母(不区分大小写)
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isZiMu:(NSString *)string;

/**
 *  验证是否由字母、数字、文字组成
 *
 *  @param string [in]
 *
 *  @return
 */
+ (BOOL)isUserName:(NSString *)string;

/**
 *  验证是否是URL (http、https、ftp)
 *
 *  @param str [in]目标字符串
 *
 *  @return
 */
+ (BOOL)isURL:(NSString *)str;

@end
