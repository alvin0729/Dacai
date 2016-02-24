//
//  DPAnalyticsKit+UMeng.m
//  DacaiProject
//
//  Created by wufan on 15/4/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAnalyticsKit.h"

#if (ANALYTICS_KIT_TYPE == ANALYTICS_KIT_UMENG)

#import "DPAnalyticsKit.h"
#import "DPAppConfigurator.h"
#import "MobClick.h"

@implementation DPAnalyticsKit

+ (void)setup {
#ifdef DEBUG
    Class cls = NSClassFromString(@"UMANUtil");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL deviceIDSelector = @selector(openUDIDString);
#pragma clang diagnostic pop
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        deviceID = [cls performSelector:deviceIDSelector];
#pragma clang diagnostic pop
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:0
                                                         error:nil];
    
    NSLog(@"UMLOG: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
#endif
    
    [MobClick setAppVersion:[KTMUtilities applicationVersion]];
#ifdef DEBUG
//    [MobClick setLogEnabled:YES];
    [MobClick setLogEnabled:NO];

    [MobClick setCrashReportEnabled:NO];
#else
    [MobClick setLogEnabled:NO];
    [MobClick setCrashReportEnabled:YES];
#endif
    [MobClick setBackgroundTaskEnabled:YES];
    [MobClick setEncryptEnabled:NO];
    [MobClick setLatency:0];
    
    // 启动统计
    [MobClick startWithAppkey:kUMengAnalyticsAppKey reportPolicy:REALTIME channelId:[DPAppConfigurator channelId]];
}

+ (void)logPageBegin:(NSString *)page {
    if (page.length > 0) {
        NSLog(@"%@ page begin", page);
        [MobClick beginLogPageView:page];
    }
}
+ (void)logPageEnd:(NSString *)page {
    if (page.length > 0) {
        NSLog(@"%@ page end", page);
        [MobClick endLogPageView:page];
    }
}
+ (void)logKeyValueEvent:(NSString *)event {
    [self logKeyValueEvent:event props:nil];
}
+ (void)logKeyValueEvent:(NSString *)event props:(NSDictionary *)kvs {
    if (kvs.count == 0) {
        [MobClick event:event];
    } else {
        [MobClick event:event attributes:kvs];
    }
}
+ (void)logKeyValueEventBegin:(NSString *)event props:(NSDictionary *)kvs {
    [MobClick beginEvent:event primarykey:event attributes:kvs];
}
+ (void)logKeyValueEventEnd:(NSString *)event props:(NSDictionary *)kvs {
    [MobClick endEvent:event primarykey:event];
}
+ (void)logNetworking:(NSString *)interface
                  req:(NSInteger)requestBodySize
                  rsp:(NSInteger)rspBodySize
                 msec:(NSInteger)millisecond
                 code:(NSInteger)returnCode
                 succ:(BOOL)success {}

+ (NSString *)appKeyDigest {
    return [KTMCrypto MD5String:[kUMengAnalyticsAppKey dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

#endif

