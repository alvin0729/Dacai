//
//  KTMCrypto.h
//  Kathmandu
//
//  Created by wufan on 15/9/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMCrypto : NSObject
/**
 *  BASE64加码
 *
 *  @param data [in]原始二进制数据
 *
 *  @return 加码后的BASE64字符串
 */
+ (NSString *)base64Encoding:(NSData *)data;

/**
 *  BASE64解码
 *
 *  @param string [in]加过码的BASE64字符串
 *
 *  @return 返回解码后的二进制数据
 */
+ (NSData *)base64Decoding:(NSString *)string;

/**
 *  URL加码
 *
 *  @param string [in]原始URL字符串
 *
 *  @return 加码后的URL字符串
 */
+ (NSString *)URLEncoding:(NSString *)string;

/**
 *  URL解码
 *
 *  @param string [in]加码过的URL字符串
 *
 *  @return 原始URL字符串
 */
+ (NSString *)URLDecoding:(NSString *)string;

/**
 *  MD5
 *
 *  @param data [in]原始数据
 *
 *  @return HASH后的数据, 32字节
 */
+ (NSData *)MD5:(NSData *)data;

/**
 *  MD5 HASH字符串
 *
 *  @param data [in]原始数据
 *
 *  @return HASH后的数据, hex字符串
 */
+ (NSString *)MD5String:(NSData *)data;

@end
