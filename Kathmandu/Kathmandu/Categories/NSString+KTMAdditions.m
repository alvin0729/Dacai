//
//  NSString+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSString+KTMAdditions.h"

@implementation NSString (KTMAdditions)

+ (NSString *)dp_uuidString {
    return [[NSUUID UUID] UUIDString];
}

- (NSString *)dp_joinSeparateString:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString string];
    for (int i = 0; i < string.length; i++) {
        [mutableString appendFormat:@"%c%@", [string characterAtIndex:i], i == string.length - 1 ? @"" : string];
    }
    return mutableString;
}

+ (CGSize)dpsizeWithSting:(NSString *)string andFont:(UIFont *)font andMaxWidth:(CGFloat)maxWidth{
   
    
    return [self dpsizeWithSting:string andFont:font andMaxSize:CGSizeMake(maxWidth, MAXFLOAT)];
}
+ (CGSize)dpsizeWithSting:(NSString *)string andFont:(UIFont *)font andMaxSize:(CGSize)maxSize{
    NSDictionary *textDic = @{NSFontAttributeName:font};
    CGSize retSize = [string boundingRectWithSize:maxSize
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:textDic
                                          context:nil].size;
    return retSize;
}
- (BOOL)checkPhoneNumInput{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70|77)\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 ){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
}
/**
 *  检查金额字符串是否符合标准
 *
 *  @param moneyStr 金额字符串
 *
 *  @return bool值
 */
+ (BOOL)checkMoneyRoleText:(NSString *)moneyStr{
    if ([moneyStr integerValue]<=0) {
        return NO;
    }
    
    //判断首字母是否为零
    NSString *str = [moneyStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *firstWord = [str substringWithRange:NSMakeRange(0, 1)];
    if ([firstWord isEqual:@"0"]) {
        return NO;
    }else{
        //判断是否有几个小数点
        if ([moneyStr componentsSeparatedByString:@"."].count-1>1) {
            return NO;
        }else{
             //判断小数点后面有几位数
            if ([moneyStr rangeOfString:@"."].location==NSNotFound) {
                return YES;
            }else{
                if (moneyStr.length -[moneyStr rangeOfString:@"."].location>3) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
    }
}
@end
