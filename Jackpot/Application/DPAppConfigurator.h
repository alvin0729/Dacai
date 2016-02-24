//
//  DPAppConfigurator.h
//  DacaiProject
//
//  Created by wufan on 15/2/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  此处宏定义用于判断是否可以在APP中配置服务器的地址
 */
//#if (defined(DEBUG) || defined(ADHOC))
//#define CONFIGURABLE
//#endif

@interface DPAppConfigurator : NSObject

/**
 *  URL地址
 *
 *  @return e.g. @"http://api.dacai.com/v3"
 */
+ (NSString *)baseURL;

/**
 *  SSL URL 地址
 *
 *  @return e.g. @"https://ssl.dacai.com/v3"
 */
+ (NSString *)SSLURL;
/**
 *  环境
 *
 *  @return e.g. @"RELEASE" or @"DEBUG"
 */
+ (NSString *)environment;
/**
 *  渠道id
 *
 *  @return e.g. @"1" (大彩)
 */
+ (NSString *)channelId;
/**
 *  编译时间
 *
 *  @return e.g. @"2015-02-25 13:28:14"
 */
+ (NSString *)buildDate;

/**
 *  切换服务器地址
 *
 *  @param addr [in]服务器地址  e.g. @"api.dacai.com:80/v3"、@"10.12.2.34:100/v3"
 */
+ (void)switchToAddr:(NSString *)addr;

/**
 *  切换服务器地址
 *
 *  @param addr [in]服务器地址  e.g. @"api.dacai.com:80/v3"、@"10.12.2.34:100/v3"
 */
+ (void)switchToSSLAddr:(NSString *)addr;

@end
