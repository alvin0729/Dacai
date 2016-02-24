//
//  DPAppMacro.h
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#ifndef __DPAppMacro_h__
#define __DPAppMacro_h__

extern NSString *server_base_url();
extern NSString *server_ssl_url();

#define kServerBaseURL  server_base_url()
#define kServerSSLURL   server_ssl_url()

#if TARGET_OS_IPHONE
#define IOS_VERSION_5_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_4_3 )
#define IOS_VERSION_6_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1 )
#define IOS_VERSION_7_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
#define IOS_VERSION_8_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 )
#define IOS_VERSION_9_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4 )
#else
#define IOS_VERSION_5_OR_ABOVE     NO
#define IOS_VERSION_6_OR_ABOVE     NO
#define IOS_VERSION_7_OR_ABOVE     NO
#define IOS_VERSION_8_OR_ABOVE     NO
#define IOS_VERSION_9_OR_ABOVE     NO
#endif

#ifdef DEBUG
#define DPLog(format, ...)              NSLog(@"DacaiProject ==> " format, ##__VA_ARGS__)
#define DPAssert(condition)             NSCAssert(condition, @"DacaiProject ==> assert fail!")
#define DPAssertMsg(condition, msg)     NSCAssert(condition, msg)
#define DPException(output)             @throw [NSException exceptionWithName:NSGenericException reason:output userInfo:nil]
#else   /* DEBUG */
#define DPLog(...)                      {}
#define DPAssert(condition)             {}
#define DPAssertMsg(condition, msg)     {}
#define DPException(output)             @throw [NSException exceptionWithName:NSGenericException reason:output userInfo:nil]
#endif  /* DEBUG */

// 屏幕大小
#define kAppDelegate    [[UIApplication sharedApplication] delegate]
#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)

#endif
