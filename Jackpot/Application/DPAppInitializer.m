//
//  DPAppInitializer.m
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAppInitializer.h"
#import "DPConstants.h"
#import "DPAppConfigurator.h"
#import "DPAnalyticsKit.h"
#import "Common.pbobjc.h"
#import "KTMUserDefaults+Jackpot.h"

@implementation DPAppInitializer

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillFinishLaunching:) name:UIApplicationWillFinishLaunchingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishAPNS:) name:UIApplicationDidFinishAPNSNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
}

+ (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillFinishLaunchingNotification object:nil];

    [self configureFramework];
    [self configureAppearance];
    [self configureStatistics];
    [self configureSDK];
    [self configureOnlyDebug];
}

+ (void)applicationDidFinishAPNS:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishAPNSNotification object:nil];
    [self deviceReigster:notification.userInfo[UIApplicationAPNSPushToken]];
}

+ (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self syncServerDate];
}

#pragma mark - 应用初始化
/**
 *  初始化框架
 */
+ (void)configureFramework {
    // 监听网络状态变化
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    // 初始化底层框架

}

/**
 *  配置样式
 */
+ (void)configureAppearance {
    // 一定时间后锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    // 状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // 导航栏标题颜色
    if (IOS_VERSION_8_OR_ABOVE) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont dp_boldSystemFontOfSize:17]}];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]] ;
    
    // 导航栏返回按钮
    [[UINavigationBar appearance] setBackIndicatorImage:dp_NavigationImage(@"back.png")];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:dp_NavigationImage(@"back.png")];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // 通过偏移隐藏标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    
    // TableView 分割线样式
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];

    // 修正 iOS 8 上的偏移
    if (IOS_VERSION_8_OR_ABOVE) {
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (IOS_VERSION_9_OR_ABOVE) {
        [[UITableView appearance] setCellLayoutMarginsFollowReadableWidth:NO];
    }
}

/**
 *  应用统计
 */
+ (void)configureStatistics {
    [DPAnalyticsKit setup];
}

/**
 *  初始化第三方SDK
 */
+ (void)configureSDK {
}

/**
 *  配置调试模式
 */
+ (void)configureOnlyDebug {
#if defined(DEBUG)
#endif
    //    LoggerStartForBuildUser();
}


#pragma mark - 注册设备

+ (void)deviceReigster:(NSString *)pushToken {
    KTMUserDefaults *userDefaults = [KTMUserDefaults standardUserDefaults];
    NSString *currVersion = [KTMUtilities applicationVersion];
    NSString *guidVersion = userDefaults.guidVersion;
    
    if (![currVersion isEqualToString:guidVersion]) {
        PBMDeviceRegister *message = [PBMDeviceRegister message];
        message.activeType = guidVersion ? PBMDeviceRegisterType_DeviceRegisterUpdate : PBMDeviceRegisterType_DeviceRegisterActivate;
        message.deviceId = [KTMUtilities deviceUUID];
        message.pushToken = pushToken;
        [[AFHTTPSessionManager dp_sharedSSLManager] POST:@"/home/deviceregister"
            parameters:message
            success:^(NSURLSessionDataTask *task, id responseObject) {
                userDefaults.guidVersion = currVersion;
                userDefaults.lastPushToken = pushToken;
            }
            failure:^(NSURLSessionDataTask *task, NSError *error){
                NSLog(@"device register failure...");
            }];
    } else if (![pushToken isEqualToString:userDefaults.lastPushToken]) {
        PBMDeviceRegister *message = [PBMDeviceRegister message];
        message.activeType = PBMDeviceRegisterType_DevicePushTokenUpdate;
        message.deviceId = [KTMUtilities deviceUUID];
        message.pushToken = pushToken;
        [[AFHTTPSessionManager dp_sharedSSLManager] POST:@"/home/updatepushdevice"
            parameters:message
            success:^(NSURLSessionDataTask *task, id responseObject) {
                userDefaults.guidVersion = currVersion;
                userDefaults.lastPushToken = pushToken;
            }
            failure:^(NSURLSessionDataTask *task, NSError *error){
                NSLog(@"device register failure...");
            }];
    } else {
        NSLog(@"device already register...");
    }
}

+ (void)syncServerDate {
    static NSURLSessionDataTask *task = nil;
    if (task) {
        [task cancel];
    }
    task = [[AFHTTPSessionManager dp_sharedManager] GET:@"/home/getservertime"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            PBMSyncDate *message = [PBMSyncDate parseFromData:responseObject error:nil];
            NSDate *date = [NSDate dp_dateFromString:message.date withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
            [NSDate dp_correctWithDate:date];
            NSLog(@"sync server time: %@", date);
            task = nil;
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            task = nil;
        }];
}

@end
