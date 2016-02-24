//
//  DPAppDelegate.m
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAppDelegate.h"
#import "DPConstants.h"
#import "DPRootPageController.h"
#import "DPStartupView.h"

//第三方登录
#import "WeiboSDK.h"
#import "WXApi.h"
#import "DPThirdCallCenter.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//友盟
#import "UMCommunity.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMFeedback.h"
#import "UMSocialConfig.h"
#import "UMSocialSinaHandler.h"

// Watch
#import "DPAppDelegate+WatchShareData.h"

#ifdef DEBUG
#import "DPAppDebugger.h"
#endif

@implementation DPAppDelegate

#define kSinaAppkey @"2581853027"
#define kWxiAppkey @"wx68e6ce83020c18e1"
#define kAppRedirectURL @"http://www.dacai.com"
#define kWXSecret @"7f80a5b87220e189150163f87f87ebd2"
#define kQQKey @"7f80a5b87220e189150163f87f87ebd2"
#pragma mark - UIApplicationDelegate
/**
 *  应用启动
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 应用启动, 在初始化UI之前发送通知, 先于UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillFinishLaunchingNotification object:nil];
    
    // 初始化界面
    [self setupWindow];
    
    // 注册推送服务
    [self registerRemoteNotification];
    
    // 处理推送消息
    [self application:application handleRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    // 处理第三方登录
    [self thirdLoginApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //处理watch数据
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    return YES;
}

/**
 *  收到远程推送
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self application:application handleRemoteNotification:userInfo];
}

/**
 *  处理外部打开的 URL
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([DPAppURLRoutes handleURL:url]) {
        return YES;
    }
    
    if ([QQApiInterface handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]) {
        return YES;
    }
    
 
    if ([WeiboSDK handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]) {
        return YES;
    }
  
    if ([WXApi handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]) {
        return YES;
    }
    
    if ([UMSocialSnsService handleOpenURL:url]) {
        return YES;
    }
    
    if ([TencentOAuth HandleOpenURL:url]) {
        return YES;
    }
    
    if ([self alipyLoginWithUrl:url]) {
        return YES;
    }
//    return  [WeiboSDK handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]||[WXApi handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]||[TencentOAuth HandleOpenURL:url]||[QQApiInterface handleOpenURL:url delegate:[DPThirdCallCenter sharedInstance]]||[UMSocialSnsService handleOpenURL:url]||[self alipyLoginWithUrl:url];
    return NO;
}

/**
 *  推送服务注册成功
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidFinishAPNSNotification object:nil userInfo:@{UIApplicationAPNSPushToken: deviceToken.dp_hexString}];
    [KTMUtilities setPushDeviceToken:deviceToken.dp_hexString];
}

/**
 *  推送服务注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidFinishAPNSNotification object:nil userInfo:nil];
    NSLog(@"register remote notification fail: %@", error);
}

/**
 *  控制屏幕旋转
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Internal Interface

/**
 *  初始化UI界面
 */
- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[DPRootPageController alloc] init];
    [self.window makeKeyAndVisible];
    
#ifdef DEBUG
    [[DPAppDebugger defaultDebugger] attach:self.window];
#else
    // 启动页、引导页
//    [self.window.rootViewController.view addSubview:[[DPStartupView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
#endif
}

/**
 *  处理推送消息
 *
 *  @param launchOptions [in]启动参数
 */
- (void)application:(UIApplication *)application handleRemoteNotification:(NSDictionary *)userInfo {
    // 推送消息未读角标
    application.applicationIconBadgeNumber = 0;
    
    if (userInfo == nil) {
        return;
    }
    // app正在前台运行, 不进行处理
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
    
    // 处理业务逻辑
    NSString *urlString = userInfo[@"Action"];
    if (urlString) {
        [DPAppURLRoutes handleURL:[NSURL URLWithString:urlString]];
    }
}

/**
 *  注册推送服务
 */
- (void)registerRemoteNotification {
    if (IOS_VERSION_8_OR_ABOVE) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
#pragma mark---------第三方登录注册
- (void)thirdLoginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //sina
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:dp_sinaWeibo_appID];
    
    //weixin
    [WXApi registerApp:dp_WxAppId];
    
    //友盟--第三方登录
    [UMCommunity setWithAppKey:dp_UM_appID];
    [UMSocialData setAppKey:dp_UM_appID];
    //友盟--第三方分享
    [UMSocialWechatHandler setWXAppId:dp_WxAppId appSecret:kWXSecret url:kAppRedirectURL];
    [UMSocialQQHandler setQQWithAppId:dp_QQAppId appKey:kQQKey url:kQQKey];
//    [UMSocialSinaHandler openSSOWithRedirectURL:kAppRedirectURL];
    //友盟--意见反馈
    [UMFeedback setAppkey:dp_UM_appID];
    
    
}

- (BOOL)alipyLoginWithUrl:(NSURL *)url{
    
    __block NSString *alipayAuthCode = @"";
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *resultStr = resultDic[@"result"];
        if (resultStr&&resultStr.length>0) {
            NSArray *resultArr = [resultStr componentsSeparatedByString:@"&"];
            for (NSInteger i = 0; i < resultArr.count; i++) {
                NSString *subResult = resultArr[i];
                NSArray *subResultArr = [subResult componentsSeparatedByString:@"="];
                if ([subResultArr[0] isEqualToString:@"auth_code"]) {
                    NSString *temp = subResultArr[1];
                    NSString *authCode = [temp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    alipayAuthCode = authCode;
                    [[DPThirdCallCenter sharedInstance] thirdLoginWithToken:authCode userID:nil oauthType:6];
                    
                }
            }
        }
    }];
    return alipayAuthCode.length>0;
}

@end
