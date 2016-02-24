//
//  DPConstants.m
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPConstants.h"

/**
 *  @see UIApplicationDidFinishLaunchingNotification
 */
NSString *const UIApplicationWillFinishLaunchingNotification = @"UIApplicationWillFinishLaunchingNotification";
NSString *const UIApplicationDidFinishAPNSNotification = @"UIApplicationDidFinishAPNSNotification";
NSString *const UIApplicationAPNSPushToken = @"PushToken";

NSString *dp_moneyLimitWarning = @"方案总金额不能超过2000000";
// URL
NSString *dp_AppIdentifier = @"com.dacai.main";
NSString *dp_URLIdentifier = @"com.dacai.ios";
NSString *dp_URLScheme = @"hzdacai";

NSString *dp_WxAppId = @"wx68e6ce83020c18e1";
NSString *dp_QQAppId = @"100776828";
NSString *dp_sinaWeibo_appID = @"2581853027";
NSString *dp_UM_appID = @"54c71ea8fd98c5adc2000b92";

// 自定义通知
NSString *dp_ThirdLoginSuccess = @"dp_ThirdLoginSuccess"; // 第三方登录成功通知
NSString *dp_ThirdShareSuccess = @"dp_ThirdShareSuccess"; // 第三方登录成功通知
NSString *dp_ThirdOauthAccessToken = @"dp_ThirdOauthAccessToken";
NSString *dp_ThirdOauthUserIDKey = @"dp_ThirdOauthUserIdKey";
NSString *dp_ThirdType = @"dp_ThirdOauthType";
NSString *dp_ThirdShareFinishKey = @"dp_ThirdShareFinishKey";
NSString *dp_ThirdShareResultKey = @"dp_ThirdShareResultKey";
NSString *dp_AlipayResultNotify = @"dp_alipayResultNotify";
NSString *kDPNumberTimerNotificationKey = @"kDPNumberTimerNotificationKey";//倒计时
NSString *kDPNumberSwitchNotificationKey = @"kDPNumberSwitchNotificationKey";//跨期
NSString *kDPNumberRefreshNotificationKey = @"kDPNumberRefreshNotificationKey";//回调
NSString *kDPReactiveTaskNotificationKey = @"kDPReactiveTaskNotificationKey";
NSString *kDPNumberEnableNotificationKey = @"kDPNumberEnableNotificationKey";//是否可以投注