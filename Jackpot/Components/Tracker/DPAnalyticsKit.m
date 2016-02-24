//
//  DPAnalyticsKit.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/29.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAnalyticsKit.h"

// 统计平台 app key
NSString *const kUMengAnalyticsAppKey = @"561dcac567e58e5a53004b2c";

#if (ANALYTICS_KIT_TYPE == ANALYTICS_KIT_NONE)

@implementation DPAnalyticsKit
+ (void)setup {}
+ (void)logPageBegin:(NSString *)page {}
+ (void)logPageEnd:(NSString *)page {}
+ (void)logKeyValueEvent:(NSString *)event props:(NSDictionary *)kvs {}
+ (void)logKeyValueEventBegin:(NSString *)event props:(NSDictionary *)kvs {}
+ (void)logKeyValueEventEnd:(NSString *)event props:(NSDictionary *)kvs {}
+ (void)logNetworking:(NSString *)interface
                  req:(NSInteger)requestBodySize
                  rsp:(NSInteger)rspBodySize
                 msec:(NSInteger)millisecond
                 code:(NSInteger)returnCode
                 succ:(BOOL)success {}
+ (NSString *)appKeyDigest { return nil; }
@end

#endif
