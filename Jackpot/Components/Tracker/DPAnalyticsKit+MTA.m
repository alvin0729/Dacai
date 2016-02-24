//
//  DPAnalyticsKit+MTA.m
//  DacaiProject
//
//  Created by wufan on 15/4/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAnalyticsKit.h"

#if (ANALYTICS_KIT_TYPE == ANALYTICS_KIT_MTA)

#import "DPAnalyticsKit.h"
#import "DPAppConfigurator.h"
#import "MTA.h"
#import "MTAConfig.h"

@interface DPAnalyticsKit ()
@end

@implementation DPAnalyticsKit

+ (void)setup {
    // 配置
    MTAConfig *mtaConfig = [MTAConfig getInstance];
    mtaConfig.channel = [DPAppConfigurator channelId];     // 渠道
    mtaConfig.reportStrategy = MTA_STRATEGY_APP_LAUNCH;    // 数据上报策略
    mtaConfig.sessionTimeoutSecs = 30;                     // 回话超时时间
    mtaConfig.maxStoreEventCount = 1024;                   // 最大缓存消息数
    mtaConfig.maxLoadEventCount = 32;                      // 一次最多加载未发送消息数
    mtaConfig.minBatchReportCount = 32;                    // BATCH模式触发发送消息的条数
    mtaConfig.maxSendRetryCount = 3;                       // 最大重试次数
    mtaConfig.sendPeriodMinutes = 1440;                    // PERIOD模式发送间隔, 一天
    mtaConfig.maxParallelTimingEvents = 1024;              // 用户自定义时间类型最大并行数
    mtaConfig.smartReporting = YES;                        // WIFI模式下智能上报
    mtaConfig.autoExceptionCaught = YES;                   // 智能捕获未catch的异常
//    mtaConfig.maxReportEventLength = 0;                  // 始终上报
    mtaConfig.statEnable = YES;                            // 统计开关
    mtaConfig.maxSessionStatReportCount = 0;               // session内发送消息数无限制
    mtaConfig.customerAppVersion = [DPSystemUtilities appVersion];
    
    // 调试模式
#ifdef DEBUG
    mtaConfig.debugEnable = NO;
    mtaConfig.autoExceptionCaught = NO;
    mtaConfig.reportStrategy = MTA_STRATEGY_INSTANT;
#else
    mtaConfig.debugEnable = NO;
    mtaConfig.autoExceptionCaught = YES;
#endif
    
    [MTA startWithAppkey:kMTAAppKey.copy];
}
+ (void)reportPushDeviceToken:(NSString *)pushDeviceToken {
    [[MTAConfig getInstance] setPushDeviceToken:pushDeviceToken];
}
+ (void)logPageBegin:(NSString *)page {
    if (page.length > 0) {
        [MTA trackPageViewBegin:page];
    }
}
+ (void)logPageEnd:(NSString *)page {
    if (page.length > 0) {
        [MTA trackPageViewEnd:page];
    }
}
+ (void)logKeyValueEvent:(NSString *)event props:(NSDictionary *)kvs {
    [MTA trackCustomKeyValueEvent:event props:kvs];
}
+ (void)logKeyValueEventBegin:(NSString *)event props:(NSDictionary *)kvs {
    [MTA trackCustomKeyValueEventBegin:event props:kvs];
}
+ (void)logKeyValueEventEnd:(NSString *)event props:(NSDictionary *)kvs {
    [MTA trackCustomKeyValueEventEnd:event props:kvs];
}
+ (void)logNetworking:(NSString *)interface
                  req:(NSInteger)reqBodySize
                  rsp:(NSInteger)rspBodySize
                 msec:(NSInteger)millisecond
                 code:(NSInteger)returnCode
                 succ:(BOOL)success {
    MTAAppMonitorStat *monitorStat = [[MTAAppMonitorStat alloc] init];
    monitorStat.interface = interface;
    monitorStat.requestPackageSize = (uint32_t)reqBodySize;
    monitorStat.responsePackageSize = (uint32_t)rspBodySize;
    monitorStat.consumedMilliseconds = (uint64_t)millisecond;
    monitorStat.returnCode = (int32_t)returnCode;
    monitorStat.resultType = success ? MTA_SUCCESS : MTA_FAILURE;
    [MTA reportAppMonitorStat:monitorStat];
}

+ (NSString *)appKeyDigest {
    NSString *appKey = [[MTAConfig getInstance] appkey];
    return [KTMCrypto MD5String:[appKey dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

#endif