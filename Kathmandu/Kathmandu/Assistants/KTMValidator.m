//
//  KTMValidator.m
//  Kathmandu
//
//  Created by wufan on 15/9/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "KTMValidator.h"

@implementation KTMValidator

+ (BOOL)isNumber:(NSString *)string {
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isEmail:(NSString *)string {
    NSString *emailRegex = @"^\\w+[-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (BOOL)isPhoneNumber:(NSString *)string {
    //手机号以13，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

+ (BOOL)isIdentifier:(NSString *)string {
    BOOL flag;
    if (string.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
}

+ (BOOL)isHanZi:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isZiMu:(NSString *)string {
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isUserName:(NSString *)string {
    NSString *regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:string];
}

+ (BOOL)isURL:(NSString *)str {
    NSString *regex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberTest evaluateWithObject:str];
}

@end
