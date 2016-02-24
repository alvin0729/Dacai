//
//  DPUARequest.m
//  Jackpot
//
//  Created by mu on 15/8/27.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUARequestData.h"
#import "Security.pbobjc.h"
#import "DPUARequest.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager+Jackpot.h"
@interface DPUARequestData()
/**
 *  模拟开关
 */
@property (nonatomic, assign) BOOL test;
@end

@implementation DPUARequestData
/**
 *  登录接口
 */
+ (void)loginWithParam:(PBMLogOnParam *)param Success:(void(^)(PBMLoginItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail{

    [DPUARequest postWithUrl:@"/account/login"params:param success:^(NSData *json) {
        
        PBMLoginItem *loginItem = [PBMLoginItem parseFromData:json error:nil];
        success(loginItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  获取支付宝登录授权字符串
 */
+ (void)aliPayLoginSuccess:(void(^)(PBMAlipayAuthInfo *alipayStr))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/AlipayLoginOAuthString"params:nil success:^(id json) {
        PBMAlipayAuthInfo *alipayStr = [PBMAlipayAuthInfo parseFromData:json error:nil];
        success(alipayStr);
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------第三方登录接口
+ (void)thirdLoginWithParam:(PBMThirdLogOnParam *)param Success:(void(^)(PBMThirdLogOnItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"account/OauthLogin"params:param success:^(NSData *json) {
        
        PBMThirdLogOnItem *loginItem = [PBMThirdLogOnItem parseFromData:json error:nil];
        success(loginItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  注册接口
 */
+ (void)logonWithParam:(PBMLogInParam *)param Success:(void(^)(PBMLoginItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail{
    
    [DPUARequest postWithUrl:@"account/RegByMobile" params:param success:^(NSData *json) {
        PBMLoginItem *loginItem = [PBMLoginItem parseFromData:json error:nil];
        success(loginItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  获取验证码
 */
+ (void)verityWithParam:(PBMPhoneVerCodeRes *)param Success:(void(^)(PBMVerityItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"account/SendRegSms" params:param success:^(id json) {
        
        PBMVerityItem *verityItem = [PBMVerityItem parseFromData:json error:nil];
        success(verityItem);
       
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  获取绑定手机号验证码
 */
+ (void)bangdingSendVerityWithParam:(PBMPhoneVerCodeRes *)param Success:(void(^)(PBMVerityItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail{
//    [DPUARequest postWithUrl:@"account/SendBindPhoneSms" params:param success:^(id json) {
//        
//        PBMVerityItem *verityItem = [PBMVerityItem parseFromData:json error:nil];
//        success(verityItem);
//        
//    } failure:^(NSString *error) {
//        fail(error);
//    }];
    
    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"account/SendBindPhoneSms" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        PBMVerityItem *verityItem = [PBMVerityItem parseFromData:responseObject error:nil];
        success(verityItem);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            fail([error dp_errorMessage]);
        }
    }];
}
#pragma mark---------绑定手机号
+ (void)bangdingVerityWithParam:(PBMPhoneBindingRes *)param Success:(void(^)(PBMLoginItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"account/ValidateBindPhoneSms" params:param success:^(id json) {
        
        PBMLoginItem *verityItem = [PBMLoginItem parseFromData:json error:nil];
        success(verityItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
    
//    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"account/ValidateBindPhoneSms" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        PBMLoginItem *verityItem = [PBMLoginItem parseFromData:responseObject error:nil];
//        success(verityItem);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if ([error dp_errorMessage]) {
//            fail([error dp_errorMessage]);
//        }
//    }];
}
#pragma mark---------第三方绑定手机号
+ (void)thirdBangdingVerityWithParam:(PBMThirdBangdingPhoneParam *)param Success:(void(^)(PBMLoginItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail{
//    [DPUARequest postWithUrl:@"account/OauthBindPhoneLogin" params:param success:^(id json) {
//        PBMLoginItem *verityItem = [PBMLoginItem parseFromData:json error:nil];
//        success(verityItem);
//        
//    } failure:^(NSString *error) {
//        fail(error);
//    }];
    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"account/OauthBindPhoneLogin" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        PBMLoginItem *verityItem = [PBMLoginItem parseFromData:responseObject error:nil];
        success(verityItem);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            fail([error dp_errorMessage]);
        }
    }];
}
/**
 *  开通投注
 */
+ (void)openBetWithParam:(id)param Success:(void(^)(PBMOpenBetItem *openBetItem))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/account/OpenBetAccount" params:param success:^(id json) {
        PBMOpenBetItem *openBetItem = [PBMOpenBetItem parseFromData:json error:nil];
        success(openBetItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}


/**
 *  用户信息
 */
+ (void)userInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMMyInforItem *myInforItem))success andFail:(void(^)(NSError *failMessage))fail{
//    [DPUARequest getWithUrl:@"/account/home" params:param success:^(id json) {
//        
//        PBMMyInforItem *myInforItem = [PBMMyInforItem parseFromData:json error:nil];
//        success(myInforItem);
//        
//    } failure:^(NSError *error) {
//        fail(error);
//    }];
    
    [[AFHTTPSessionManager dp_sharedManager]GET:@"/account/home" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        PBMMyInforItem *myInforItem = [PBMMyInforItem parseFromData:responseObject error:nil];
        success(myInforItem);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        fail(error);
    }];
}

//安全中心首页
+ (void)getSecurityHomeDataBufWithUrlStr:(NSString *)urlStr
                                Success:(void(^)(id responseObject))success
                                 andFail:(void(^)(NSString *failMessage))fail {
    [DPUARequest getWithUrl:[NSString stringWithFormat:@"/account/%@", urlStr] params:nil success:^(id json) {
        
        PBMSecurityHome *myInforItem = [PBMSecurityHome parseFromData:json error:nil];
        success(myInforItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 * 获取推送设置信息
 */
+ (void)pushSetWithParam:(PBMPushItem *)param Success:(void(^)(PBMPushItem *pushItem))success andFail:(void(^)(NSString *failMessage))fail{
    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"/push/GetPushConfig" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        PBMPushItem *pushItem = [PBMPushItem parseFromData:responseObject error:nil];
        success(pushItem);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            fail([error dp_errorMessage]);
        }
    }];
}
/**
 * 保存推送设置信息
 */
+ (void)savePushSetWithParam:(PBMPushItem *)param Success:(void(^)())success andFail:(void(^)(NSString *failMessage))fail{
    
    
    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"/push/SetPushConfig" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            fail([error dp_errorMessage]);
        }
    }];
}
/**
 * 保存比分直播推送设置信息
 */
+ (void)saveLivePushSetWithParam:(PBMPushItem *)param Success:(void(^)())success andFail:(void(^)(NSString *failMessage))fail{
    [[AFHTTPSessionManager dp_sharedSSLManager]POST:@"/push/SetLivePushConfig" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            fail([error dp_errorMessage]);
        }
    }];
}
/**
 * 提款信息
 */
+ (void)getDrawMoneyInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMGetDrawMoneyInfo *drawMoneyInfo))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/GetDrawBank" params:param success:^(id json) {
        
        PBMGetDrawMoneyInfo *drawMoneyInfo = [PBMGetDrawMoneyInfo parseFromData:json error:nil];
        success(drawMoneyInfo);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 * 获取手续费
 */
+ (void)getDrawMoneyFeeWithParam:(NSDictionary *)param Success:(void(^)(PBMFeeItem *feeItem))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/handDrawFee" params:param success:^(id json) {
        
        PBMFeeItem *feeItem = [PBMFeeItem parseFromData:json error:nil];
        success(feeItem);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 * 校验提款密码
 */
+ (void)checkDrawMoneyPasswordWithParam:(NSDictionary *)param Success:(void(^)(NSInteger result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"" params:param success:^(id json) {
        
        success((NSInteger)json);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 * 提交提款信息
 */
+ (void)submitDrawMoneyInfoWithParam:(PBMSubmitDrawMoneyParam *)param Success:(void(^)(PBMSubmitDrawMoneyInfo *submitDrawMoneyInfo))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/account/draw" params:param success:^(id json) {
        
        PBMSubmitDrawMoneyInfo *submitDrawMoneyInfo = [PBMSubmitDrawMoneyInfo parseFromData:json error:nil];
        success(submitDrawMoneyInfo);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 * 资金明细
 */
+ (void)getFundDetailInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMFundDetailInfo *fundInfo))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/AccountLog" params:param success:^(id json) {
        
        PBMFundDetailInfo *fundDetailInfo = [PBMFundDetailInfo parseFromData:json error:nil];
        success(fundDetailInfo);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  红包明细
 */
+ (void)getRedGiftInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMRedGiftInfo *giftInfo))success andFail:(void(^)(NSString *failMessage))fail{
    
    [DPUARequest getWithUrl:@"" params:param success:^(id json) {
        
        PBMRedGiftInfo *giftInfo = [PBMRedGiftInfo parseFromData:json error:nil];
        success(giftInfo);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
/**
 *  购彩记录
 */
+ (void)getlotteryHistoryInfoWithParam:(NSDictionary *)param Success:(void(^)(LotteryHistoryResult *lotteryHistoryInfo))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/BuyRecords" params:param success:^(id json) {
        
        LotteryHistoryResult *lotteryHistoryInfo = [LotteryHistoryResult parseFromData:json error:nil];
        success(lotteryHistoryInfo);
                
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------支付宝充值
+ (void)reChangeByAlipayWithParam:(PBMPayParams *)param Success:(void(^)(PBMRechangeAlipay *alipay))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/account/Topup" params:param success:^(id json) {
        
        PBMRechangeAlipay *alipay = [PBMRechangeAlipay parseFromData:json error:nil];
        success(alipay);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------银联充值
+ (void)reChangeByYinLianWithParam:(NSDictionary *)param Success:(void(^)(PBMRechangeYinlian *yinlian))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/Topup" params:param success:^(id json) {
        
        PBMRechangeYinlian *yinlian = [PBMRechangeYinlian parseFromData:json error:nil];
        success(yinlian);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------连连充值
+ (void)reChangeByLianlianWithParam:(NSDictionary *)param Success:(void(^)(PBMRechangeLianlian *lianlian))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/Topup" params:param success:^(id json) {
        
        PBMRechangeLianlian *lianlian = [PBMRechangeLianlian parseFromData:json error:nil];
        success(lianlian);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}

#pragma mark---------设置头像和昵称
+ (void)setHeaderIconAndNicknameWithParam:(PBMUserNameIconParam *)param Success:(void(^)(PBMUserNameIconItem *result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/account/ModifyHeadIcon" params:param success:^(id json) {
        PBMUserNameIconItem *result = [PBMUserNameIconItem parseFromData:json error:nil];
        success(result);
    } failure:^(NSString *error) {
        fail(error);
    }];
}

#pragma mark---------获取消息记录
+ (void)getMessagesWithParam:(NSDictionary *)param Success:(void(^)(PBMMsgListResult *result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/news/GetLetters" params:param success:^(id json) {
        
        PBMMsgListResult *result = [PBMMsgListResult parseFromData:json error:nil];
        success(result);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------已读消息
+ (void)readMessageWithParam:(PBMDeleteMsgRequest *)param Success:(void(^)(PBMMsgStatusResult *result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/news/ReadLetter" params:param success:^(id json) {
        
        PBMMsgStatusResult *result = [PBMMsgStatusResult parseFromData:json error:nil];
        success(result);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}
#pragma mark---------删除消息
+ (void)deleteMessagesWithParam:(PBMDeleteMsgRequest *)param Success:(void(^)(PBMMsgStatusResult *result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest postWithUrl:@"/news/DeleteLetter" params:param success:^(id json) {
        
        PBMMsgStatusResult *result = [PBMMsgStatusResult parseFromData:json error:nil];
        success(result);
        
    } failure:^(NSString *error) {
        fail(error);
    }];
}

#pragma mark---------获取开通投注服务中的用户信息
+ (void)getUserInfoInOpenBetSuccess:(void (^)(PBMUserInfo *result))success andFail:(void(^)(NSString *failMessage))fail{
    [DPUARequest getWithUrl:@"/account/GetUserInfo" params:nil success:^(id json) {
        PBMUserInfo *userInfo = [PBMUserInfo parseFromData:json error:nil];
        success(userInfo);
    } failure:^(NSString *error) {
        fail(error);
    }];
}
// 成长体系，首页接口
+ (void)growSystemHomeDataSuccess:(void (^)(PBMGrowthHome *homeData))success fail:(void (^)(NSString *error))failError{
    [DPUARequest getWithUrl:@"/czz/getuserinfoandtasks" params:nil success:^(id json) {
        PBMGrowthHome *growHomeData = [PBMGrowthHome parseFromData:json error:nil];
        success(growHomeData);
    } failure:^(NSString *error) {
        failError(error);
    }];
}
//领取任务奖励接口
+ (void)getTaskAwardWithParam:(NSString*)taskId success:(void (^)(PBMGrowthDrawTask *award))success fail:(void (^)(NSString *error))failError{
    [DPUARequest getWithUrl:@"/czz/GetTaskAward" params:@{@"taskid":taskId} success:^(id json) {
        PBMGrowthDrawTask *award = [PBMGrowthDrawTask parseFromData:json error:nil];
        success(award);
    } failure:^(NSString *error) {
        failError(error);
    }];
}
//签到接口
+ (void)signInSuccess:(void (^)(PBMGrowthCheckIn *checkResult))success fail:(void (^)(NSString *error))failError{
    [DPUARequest getWithUrl:@"/czz/SignUp" params:nil success:^(id json) {
        PBMGrowthCheckIn *rankingAward = [PBMGrowthCheckIn parseFromData:json error:nil];
        success(rankingAward);
    } failure:^(NSString *error) {
        failError(error);
    }];
    
}
//排行榜接口
+ (void)growSystemRankingDataSuccess:(void (^)(PBMGrowthRanking *rankingData))success fail:(void (^)(NSString *error))failError{
    [DPUARequest getWithUrl:@"/czz/getranking" params:nil success:^(id json) {
        PBMGrowthRanking *rankingData = [PBMGrowthRanking parseFromData:json error:nil];
        success(rankingData);
    } failure:^(NSString *error) {
        failError(error);
    }];
}
//排行历史接口
+ (void)growSystemHistoryRankingDataWithParam:(PBMRankingAwardParam *)param success:(void (^)(PBMRankingAward *rankingData))success fail:(void (^)(NSString *error))failError{
    [DPUARequest postWithUrl:@"/czz/GetHistoryRanking" params:param success:^(id json) {
        PBMRankingAward *rankingData = [PBMRankingAward parseFromData:json error:nil];
        success(rankingData);
    } failure:^(NSString *error) {
        failError(error);
    }];
}
//排行奖励接口
+ (void)growSystemRankingGiftDataWithParam:(PBMRankingAwardParam *)rankingAwardParam success:(void (^)(PBMGrowthDrawTask *rankingData))success fail:(void (^)(NSString *error))failError{
    [DPUARequest postWithUrl:@"/czz/GetRankingAward" params:rankingAwardParam success:^(id json) {
        PBMGrowthDrawTask *rankingAward = [PBMGrowthDrawTask parseFromData:json error:nil];
        success(rankingAward);
    } failure:^(NSString *error) {
        failError(error);
    }];
}

//激活任务接口
+ (void)reactiveTasksuccess:(void (^)())success fail:(void (^)(NSString *error))failError{
    [DPUARequest getWithUrl:@"/czz/NotifyGrowthSystem" params:nil success:^(id json) {
        success();
    } failure:^(NSString *error) {
        failError(error);
    }];
}
@end
