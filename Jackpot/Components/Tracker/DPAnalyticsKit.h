//
//  DPAnalyticsKit.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/29.
//  Copyright (c) 2015年 dacai. All rights reserved.
//
//  行为统计模块
//

#import <Foundation/Foundation.h>

// APP KEY
extern NSString *const kUMengAnalyticsAppKey;

// 各种统计平台
#define ANALYTICS_KIT_NONE      0   // 不统计
#define ANALYTICS_KIT_UMENG     1   // 使用友盟
#define ANALYTICS_KIT_MTA       2   // 使用腾讯
#define ANALYTICS_KIT_BAIDU     3   // 使用百度

// 使用的统计平台
#define ANALYTICS_KIT_TYPE      ANALYTICS_KIT_UMENG

//// 模拟器不统计
//#if TARGET_IPHONE_SIMULATOR
//#  ifdef ANALYTICS_KIT_TYPE
//#    undef ANALYTICS_KIT_TYPE
//#  endif
//#  define ANALYTICS_KIT_TYPE ANALYTICS_KIT_NONE
//#endif

@interface DPAnalyticsKit : NSObject

// 启动
+ (void)setup;

// 记录页面访问
+ (void)logPageBegin:(NSString *)page;
+ (void)logPageEnd:(NSString *)page;

/**
 *  记录自定义事件
 *
 *  @param event [in]自定义事件
 *  @param kvs   [in]事件参数, 必须包含键值对, 且键值都为字符串类型
 */
+ (void)logKeyValueEvent:(NSString *)event;
+ (void)logKeyValueEvent:(NSString *)event props:(NSDictionary *)kvs;
+ (void)logKeyValueEventBegin:(NSString *)event props:(NSDictionary *)kvs;
+ (void)logKeyValueEventEnd:(NSString *)event props:(NSDictionary *)kvs;

/**
 *  统计接口请求状况
 *
 *  @param interface       [in]接口名称
 *  @param requestBodySize [in]请求包大小
 *  @param rspBodySize     [in]响应包大小
 *  @param millisecond     [in]请求时间
 *  @param returnCode      [in]状态码
 *  @param success         [in]是否成功
 */
+ (void)logNetworking:(NSString *)interface          // 接口名
                  req:(NSInteger)requestBodySize     // 请求包大小
                  rsp:(NSInteger)rspBodySize         // 响应包大小
                 msec:(NSInteger)millisecond         // 消耗毫秒数
                 code:(NSInteger)returnCode          // 业务返回的应答码
                 succ:(BOOL)success;                 // 业务是否成功

// appKey 签名, 用于对比
+ (NSString *)appKeyDigest;

@end
