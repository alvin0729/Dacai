//
//  DPThirdCallCenter.h
//  DacaiProject
//
//  Created by jacknathan on 14-12-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>
typedef enum {
    kThirdShareTypeUnknown = 0, // 未知
    kThirdShareTypeWXC,         // 微信朋友圈
    kThirdShareTypeWXF,         // 微信好友
    kThirdShareTypeSinaWB,      // 新浪微博
    kThirdShareTypeQQzone,      // QQ空间
    kThirdShareTypeQQfriend    // QQ好友
} kThirdShareType;



@interface DPThirdCallCenter : NSObject <WeiboSDKDelegate, WXApiDelegate, QQApiInterfaceDelegate,UMSocialUIDelegate,TencentSessionDelegate>

+ (instancetype)sharedInstance;
#pragma mark---------qq,微信
- (void)dp_QQLogin; // qq登录
- (void)dp_QQLogout; // qq注销登录
- (void)dp_wxLoginWithController:(UIViewController *)controller; // 微信登陆
#pragma mark---------微博
- (void)dp_sinaWeiboLogin; // 新浪微博登录
- (void)dp_sinaWeiboLogout; // 新浪微博注销登录
#pragma mark---------支付宝
- (void)dp_aliPayLogin; // 支付宝登录

- (void)thirdLoginWithToken:(NSString *)token userID:(NSString *)userID oauthType:(int)oauthType;

- (BOOL)dp_isInstalledAPPType:(kThirdShareType)type; // 是否安装相应APP客户端

@end
