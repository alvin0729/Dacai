//
//  KTMUtilities.h
//  Kathmandu
//
//  Created by wufan on 15/9/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMUtilities : NSObject

/**
 *  应用程序正式版本号
 */
+ (NSString *)applicationVersion;

/**
 *  应用程序内部版本号
 */
+ (NSString *)buildNumber;

/**
 *  设备唯一标识
 */
+ (NSString *)deviceUUID;

/**
 *  设备推送Token
 */
+ (NSString *)pushDeviceToken;

/**
 *  首次安装应用(卸载后重新安装无效)
 */
+ (BOOL)isFirstInstall;

/**
 *  升级或者安装(包括卸载后重新安装)应用后首次打开
 */
+ (BOOL)isFirstStartup;

/**
 *  从低版本升级到当前版本后首次打开应用
 */
+ (BOOL)isUpgrade;

/**
 *  设置推送token
 *
 *  @param deviceToken [in]推送token
 */
+ (void)setPushDeviceToken:(NSString *)deviceToken;

@end
