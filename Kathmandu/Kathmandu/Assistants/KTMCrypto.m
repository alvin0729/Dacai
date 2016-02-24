//
//  KTMCrypto.m
//  Kathmandu
//
//  Created by wufan on 15/9/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "KTMCrypto.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation KTMCrypto

#pragma mark - 编码方式

/**
 *  对二进制进行base64编码
 */
+ (NSString *)base64Encoding:(NSData *)data {
    NSString *encoded = nil;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        encoded = [data base64Encoding];
#pragma clang diagnostic pop
    } else
#endif
    {
        encoded = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    }
    
    return encoded;
}

/**
 *  对base64字符串进行解码
 */
+ (NSData *)base64Decoding:(NSString *)string {
    if (!string.length) {
        return nil;
    }
    
    NSData *decoded = nil;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        decoded = [[NSData alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    } else
#endif
    {
        decoded = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return [decoded length] ? decoded : nil;
}

+ (NSString *)URLEncoding:(NSString *)string {
    // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
    // some characters that should be escaped in URL parameters, like / and ?;
    // we'll use CFURL to force the encoding of those
    //
    // We'll explicitly leave spaces unescaped now, and replace them with +'s
    //
    // Reference: <a href="%5C%22http://www.ietf.org/rfc/rfc3986.txt%5C%22" target="\"_blank\"" onclick='\"return' checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
    
#if __has_feature(objc_arc)
    CFStringRef originalString = (__bridge CFStringRef)string;
#else
    CFStringRef originalString = (CFStringRef)string;
#endif
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if (escapedStr) {
#if __has_feature(objc_arc)
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
#else
        NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)escapedStr];
#endif
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        string = mutableStr;
    }
    
    return string;
}

+ (NSString *)URLDecoding:(NSString *)string {
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)MD5:(NSData *)data {
    unsigned char * digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSData * md5 = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return md5;
}

+ (NSString *)MD5String:(NSData *)data {
    NSData *md5 = [self MD5:data];
    if (!md5.length) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i = 0; i < md5.length; i++) {
        [string appendFormat:@"%02X", ((const unsigned char *)md5.bytes)[i]];
    }
    return string;
}

@end
