//
//  DPThirdCallCenter.m
//  DacaiProject
//
//  Created by jacknathan on 14-12-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPThirdCallCenter.h"
#import "DPUARequestData.h"

@interface DPThirdCallCenter () <WBHttpRequestDelegate, UMSocialDataDelegate, UMSocialUIDelegate> {
    //    TencentOAuth *_QQoauth;
    //    CAccount     *_account;
}
@property (nonatomic, strong) NSString *sinaWB_accessToken;
@property (nonatomic, strong) NSString *wx_accessToken;
/**
 *  qq
 */
@property (nonatomic, strong) TencentOAuth *QQoauth;
@end

static DPThirdCallCenter *sharedInstance;
@implementation DPThirdCallCenter

- (TencentOAuth *)QQoauth{
    if (!_QQoauth) {
        _QQoauth = [[TencentOAuth alloc]initWithAppId:dp_QQAppId andDelegate:self];
    }
    return _QQoauth;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}
+ (instancetype)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[DPThirdCallCenter alloc]init];
    }
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return sharedInstance;
}
- (BOOL)dp_isInstalledAPPType:(kThirdShareType)type
{
    switch (type) {
        case kThirdShareTypeWXC:
        case kThirdShareTypeWXF:
            return [WXApi isWXAppInstalled];
            break;
        case kThirdShareTypeQQzone:
            return [QQApiInterface isQQInstalled];
            break;
        case kThirdShareTypeSinaWB:
            return [WeiboSDK isWeiboAppInstalled];
        default:
            return NO;
            break;
    }
}
- (UIImage *)dp_getCommonIconImage
{
//    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"Icon-72.png" ofType:nil];
//    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
//    DPLog(@"share  with image = %@", image);
    return [UIImage imageNamed:@"Icon-Small-50.png"];
//    return image;
}
#pragma mark - 第三方登录
- (void)dp_QQLogin
{
//    [self dp_QQLogout];
    NSArray *perArray = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
//    [_self.QQoauth authorize:perArray];
    [self.QQoauth authorize:perArray inSafari:NO];
//    [_self.QQoauth authorize:perArray localAppId:dp_QQAppId inSafari:NO];
    
    
}
- (void)dp_QQLogout
{
    if ([self.QQoauth isSessionValid]) {
        DPLog(@"----------------qq登录状态有效");
        [self.QQoauth logout:self];
    }else{
        DPLog(@"----------------qq登录状态无效");
    }
}
- (void)dp_sinaWeiboLogin
{
    [self dp_sinaWeiboLogout];
    WBAuthorizeRequest *wbRequest = [WBAuthorizeRequest request];
    wbRequest.redirectURI = @"http://www.dacai.com/mem/appoauth/oauthcallback_sinaweibo";
    wbRequest.scope = @"all";
    [WeiboSDK sendRequest:wbRequest];
    
}
- (void)dp_sinaWeiboLogout
{
    if (self.sinaWB_accessToken.length > 0 && self.sinaWB_accessToken != nil) {
        DPLog(@"----------------sina登录状态有效");
        [WeiboSDK logOutWithToken:self.sinaWB_accessToken delegate:self withTag:nil];
    }else{
        DPLog(@"----------------sina登录状态无效");
    }
}

- (void)dp_wxLoginWithController:(UIViewController *)controller
{
    SendAuthReq *auth = [[SendAuthReq alloc]init];
    auth.scope = @"snsapi_userinfo,snsapi_base";
    auth.state = @"dp_state_tag";
    [WXApi sendAuthReq:auth viewController:controller delegate:self];

}
- (void)dp_aliPayLogin{

    [DPUARequestData aliPayLoginSuccess:^(PBMAlipayAuthInfo *alipayStr) {
        [[AlipaySDK defaultService]auth_V2WithInfo:alipayStr.authInfo fromScheme:@"2014032100004368" callback:^(NSDictionary *resultDic) {
            NSString *resultStr = resultDic[@"result"];
            
            if (resultStr&&resultStr.length>0) {
                NSArray *resultArr = [resultStr componentsSeparatedByString:@"&"];
                for (NSInteger i = 0; i < resultArr.count; i++) {
                    NSString *subResult = resultArr[i];
                    NSArray *subResultArr = [subResult componentsSeparatedByString:@"="];
                    if ([subResultArr[0] isEqualToString:@"auth_code"]) {
                        NSString *subResultFirstItem = subResultArr[1];
                        NSString *authCode = [subResultFirstItem stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        [self thirdLoginWithToken:authCode userID:nil oauthType:6];
                    }
                }
            }
        }];
    } andFail:^(NSString *failMessage) {
        
    }];
    
}


#pragma mark - 腾讯QQ 回调
#pragma mark - tencent session delegate
- (void)tencentDidLogin
{
    DPLog(@"腾讯QQ----------tencentDidLogin");
    DPLog(@"第三方信息----------- accessToken =%@, openId= %@", self.QQoauth.accessToken, self.QQoauth.openId);
    [self thirdLoginWithToken:self.QQoauth.accessToken userID:self.QQoauth.openId oauthType:7];
 
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    DPLog(@"腾讯QQ----------did not login cancelled = %d", cancelled);
}
- (void)tencentDidNotNetWork
{
    DPLog(@"腾讯QQ----------无网络");
}
- (void)tencentDidLogout
{
    DPLog(@"腾讯QQ----------注销登录");
}
#pragma mark - 微信 & QQ 回调代理
- (void)onResp:(id)resp
{
// 微信部分授权 onResp:(BaseResp *)resp
//    ErrCode ERR_OK = 0(用户同意)
//    
//    ERR_AUTH_DENIED = -4（用户拒绝授权）
//    
//    ERR_USER_CANCEL = -2（用户取消）
// 微信分享结果
//    WXSuccess           = 0,    /**< 成功    */
//    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//    WXErrCodeSentFail   = -3,   /**< 发送失败    */
//    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */

    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authoRsp = (SendAuthResp *)resp;
        NSString *code = authoRsp.code;
        DPLog(@"DPThirdCenter--------微信回调 code = %@, error = %d, 错误提示符=%@", code, authoRsp.errCode, authoRsp.errStr);
        if (authoRsp.errCode == 0 && [authoRsp.state isEqualToString:@"dp_state_tag"]) {
           [self thirdLoginWithToken:code userID:nil oauthType:9];
        }
        return;
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *smWXresp = (SendMessageToWXResp *)resp;
        DPLog(@"DPThirdCenter—— SendMessageToWXResp微信回调，errocode=%d, erroStr=%@, type=%d", smWXresp.errCode, smWXresp.errStr, smWXresp.type);
        if (smWXresp.errCode == 0){
             [self dp_thirdShareSuccess:smWXresp.errCode == 0 withType:9];
        }
        return;
    }
// qq部分 onResp:(QQBaseResp *)resp
    DPLog(@"QQ QQApiInterfaceDelegate ----- 回调， response=%@", resp);
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *qqResp = (SendMessageToQQResp *)resp;
        DPLog(@"QQ分享回调 ---------- result=%@, errpDescrip=%@, type=%d", qqResp.result, qqResp.errorDescription, qqResp.type);
//        if (qqResp.result.intValue == 0) [self dp_thirdShareSuccess:YES withType:7];
        [self dp_thirdShareSuccess:qqResp.result.intValue == 0 withType:7];
    }	

}
- (void)onReq:(id)req
{
    DPLog(@"DPThirdCenter--------微信/QQ回调 onReq =%@", req);
}
#pragma mark - 登录成功发通知
- (void)thirdLoginWithToken:(NSString *)token userID:(NSString *)userID oauthType:(int)oauthType
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:token forKey:dp_ThirdOauthAccessToken];
    [info setValue:@(oauthType) forKey:dp_ThirdType];
    if (userID != nil && userID.length > 0 ) {
        [info setValue:userID forKey:dp_ThirdOauthUserIDKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ThirdLoginSuccess object:nil userInfo:info];
    DPLog(@"授权登录执行一次-----------------记录");
    // 授权登出
//    if (oauthType == 7) [self dp_QQLogout];
//    if (oauthType == 2) [self dp_sinaWeiboLogout];
}
#pragma mark - 分享结束发通知
- (void)dp_thirdShareSuccess:(BOOL)success withType:(int)type
{
   
    NSDictionary *info = @{dp_ThirdShareResultKey : @(success) , dp_ThirdType : @(type)};
    [[NSNotificationCenter defaultCenter] postNotificationName:dp_ThirdShareFinishKey object:nil userInfo:info];
}
#pragma mark - sina weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DPLog(@"DPThirdCenter------sina weibo receive weiboRequest=%@", request);
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
//    WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//    WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//    WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//    WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//    WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//    WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
//    WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
//    WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//    WeiboSDKResponseStatusCodeUnknown               = -100,
    
    DPLog(@"DPThirdCenter--------新浪微博 statusCode=%d", (int)response.statusCode);
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        DPLog(@"DPThirdCenter------sina weibo receive WBSendMessageToWeiboResponse");
        WBSendMessageToWeiboResponse *smResponse = (WBSendMessageToWeiboResponse *)response;
        if (smResponse.statusCode == 0) {
            DPLog(@"新浪微博分享成功, response =%@", smResponse);
            [self dp_thirdShareSuccess:YES withType:2];
        }else{
            [self dp_thirdShareSuccess:NO withType:2];
        }
        if (smResponse.authResponse != nil) {
            // 分享过程中进行授权操作
            DPLog(@"新浪微博授权操作 --- accessToken =%@", smResponse.authResponse.accessToken);
            self.sinaWB_accessToken = smResponse.authResponse.accessToken;
        }
    } else if ([response isKindOfClass:[WBAuthorizeResponse class]]){
        DPLog(@"DPThirdCenter------sina weibo receive WBAuthorizeResponse");
        WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
        if (authResp.statusCode != 0) return;
        self.sinaWB_accessToken = authResp.accessToken;
        DPLog(@"------------新浪sina accessToken = %@, USRID=%@", self.sinaWB_accessToken, authResp.userID);
        [self thirdLoginWithToken:self.sinaWB_accessToken userID:authResp.userID oauthType:2];

    } else {
        return;
    }
}

#pragma mark - sina WBHttpRequestDelegate
/**
 收到一个来自微博Http请求的响应
 
 @param response 具体的响应对象
 */
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    DPLog(@"sina WBHttpRequest = %@, didReceiveResponse = %@",request, response);
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    DPLog(@"sina WBHttpRequest = %@, didFailWithError = %@",request, error);
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    DPLog(@"sina WBHttpRequest = %@, didFinishLoadingWithResult = %@",request, result);

}

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    DPLog(@"sina WBHttpRequest = %@, didFinishLoadingWithDataResult = %@",request, data);
}

/**
 收到快速SSO授权的重定向
 
 @param URI
 */
- (void)request:(WBHttpRequest *)request didReciveRedirectResponseWithURI:(NSURL *)redirectUrl
{
    DPLog(@"sina WBHttpRequest = %@, didReciveRedirectResponseWithURI = %@",request, redirectUrl);
}


@end
