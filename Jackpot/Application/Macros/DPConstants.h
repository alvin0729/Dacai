//
//  DPConstants.h
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#ifndef __DPConstants_h__
#define __DPConstants_h__

extern NSString *const UIApplicationWillFinishLaunchingNotification;
extern NSString *const UIApplicationDidFinishAPNSNotification;
extern NSString *const UIApplicationAPNSPushToken;

extern NSString *dp_moneyLimitWarning;
// URL
extern NSString *dp_AppIdentifier;
extern NSString *dp_URLIdentifier;
extern NSString *dp_URLScheme;

extern NSString *dp_WxAppId;
extern NSString *dp_QQAppId;
extern NSString *dp_sinaWeibo_appID;
extern NSString *dp_UM_appID;
// Notify
extern NSString *dp_ThirdLoginSuccess;
extern NSString *dp_ThirdShareSuccess;
extern NSString *dp_ThirdOauthUserIDKey;
extern NSString *dp_ThirdOauthAccessToken;
extern NSString *dp_ThirdType;
extern NSString *dp_ThirdShareFinishKey;
extern NSString *dp_ThirdShareResultKey;
extern NSString *dp_AlipayResultNotify;
extern NSString *kDPNumberTimerNotificationKey;
extern NSString *kDPNumberSwitchNotificationKey;
extern NSString *kDPNumberRefreshNotificationKey;
extern NSString *kDPUAHomeRefreshNotificationKey;
extern NSString *kDPReactiveTaskNotificationKey;
extern NSString *kDPNumberEnableNotificationKey;

typedef NS_ENUM(NSInteger, DPPathSource) {
    DPPathSourceNone        = 0,
    DPPathSourceSignIn      = 1 << 0,   // 登录
    DPPathSourceSignUp      = 1 << 1,   // 注册
    DPPathSourceOAuth       = 1 << 2,   // 第三方登录
    
    DPPathSourceUmengLib    = 1 << 3,   // 友盟
};

typedef NS_ENUM(NSInteger, DPPathSourceOption) {
    DPPathSourceOptionSign = DPPathSourceSignIn | DPPathSourceSignUp | DPPathSourceOAuth,
};

#endif /* __DPConstants_h__ */
