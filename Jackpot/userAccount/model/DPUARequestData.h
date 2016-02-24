//
//  DPUARequest.h
//  Jackpot
//
//  Created by mu on 15/8/27.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPUARequest.h"
#import "UserAccount.pbobjc.h"
#import "LotteryHistory.pbobjc.h"
#import "Security.pbobjc.h"
#import "Order.pbobjc.h"
#import "Growthsystem.pbobjc.h"
@interface DPUARequestData : NSObject
/**
 *  登录接口
 */
+ (void)loginWithParam:(PBMLogOnParam *)param Success:(void(^)(PBMLoginItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  获取支付宝登录授权字符串
 */
+ (void)aliPayLoginSuccess:(void(^)(PBMAlipayAuthInfo *alipayStr))success andFail:(void(^)(NSString *failMessage))fail;
#pragma mark---------第三方登录接口
+ (void)thirdLoginWithParam:(PBMThirdLogOnParam *)param Success:(void(^)(PBMThirdLogOnItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  注册接口
 */
+ (void)logonWithParam:(PBMLogInParam *)param Success:(void(^)(PBMLoginItem *loginItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  获取验证码
 */
+ (void)verityWithParam:(PBMPhoneVerCodeRes *)param Success:(void(^)(PBMVerityItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  获取绑定手机号验证码
 */
+ (void)bangdingSendVerityWithParam:(PBMPhoneVerCodeRes *)param Success:(void(^)(PBMVerityItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail;
#pragma mark---------绑定手机号
+ (void)bangdingVerityWithParam:(PBMPhoneBindingRes *)param Success:(void(^)(PBMLoginItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail;
#pragma mark---------第三方绑定手机号
+ (void)thirdBangdingVerityWithParam:(PBMThirdBangdingPhoneParam *)param Success:(void(^)(PBMLoginItem *verityItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  开通投注
 */
+ (void)openBetWithParam:(id)param Success:(void(^)(PBMOpenBetItem *openBetItem))success andFail:(void(^)(NSString *failMessage))fail;

/**
 *  用户信息
 */
+ (void)userInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMMyInforItem *myInforItem))success andFail:(void(^)(NSError *failMessage))fail;
/**
 *  安全中心首页
 */

+ (void)getSecurityHomeDataBufWithUrlStr:(NSString *)urlStr
                                 Success:(void(^)(id responseObject))success
                                 andFail:(void(^)(NSString *failMessage))fail;
/**
 * 获取推送设置信息
 */
+ (void)pushSetWithParam:(PBMPushItem *)param Success:(void(^)(PBMPushItem *pushItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 保存推送设置信息
 */
+ (void)savePushSetWithParam:(PBMPushItem *)param Success:(void(^)())success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 保存比分直播推送设置信息
 */
+ (void)saveLivePushSetWithParam:(PBMPushItem *)param Success:(void(^)())success andFail:(void(^)(NSString *failMessage))fail;

/**
 * 提款信息
 */
+ (void)getDrawMoneyInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMGetDrawMoneyInfo *drawMoneyInfo))success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 获取手续费
 */
+ (void)getDrawMoneyFeeWithParam:(NSDictionary *)param Success:(void(^)(PBMFeeItem *feeItem))success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 校验提款支付密码
 */
+ (void)checkDrawMoneyPasswordWithParam:(PBMSubmitDrawMoneyParam *)param Success:(void(^)(NSInteger result))success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 提交提款信息
 */
+ (void)submitDrawMoneyInfoWithParam:(PBMSubmitDrawMoneyParam *)param Success:(void(^)(PBMSubmitDrawMoneyInfo *submitDrawMoneyInfo))success andFail:(void(^)(NSString *failMessage))fail;
/**
 * 资金明细
 */
+ (void)getFundDetailInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMFundDetailInfo *fundInfo))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  红包明细
 */
+ (void)getRedGiftInfoWithParam:(NSDictionary *)param Success:(void(^)(PBMRedGiftInfo *giftInfo))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  购彩记录
 */
+ (void)getlotteryHistoryInfoWithParam:(NSDictionary *)param Success:(void(^)(LotteryHistoryResult *lotteryHistoryInfo))success andFail:(void(^)(NSString *failMessage))fail;
#pragma mark---------支付宝充值
+ (void)reChangeByAlipayWithParam:(PBMPayParams *)param Success:(void(^)(PBMRechangeAlipay *alipay))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  银联充值
 */
+ (void)reChangeByYinLianWithParam:(NSDictionary *)param Success:(void(^)(PBMRechangeYinlian *yinlian))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  连连充值
 */
+ (void)reChangeByLianlianWithParam:(NSDictionary *)param Success:(void(^)(PBMRechangeLianlian *lianlian))success andFail:(void(^)(NSString *failMessage))fail;
#pragma mark---------设置头像和昵称
+ (void)setHeaderIconAndNicknameWithParam:(PBMUserNameIconParam *)param Success:(void(^)(PBMUserNameIconItem *result))success andFail:(void(^)(NSString *failMessage))fail;

/**
 *  获取消息记录
 */
+ (void)getMessagesWithParam:(NSDictionary *)param Success:(void(^)(PBMMsgListResult *result))success andFail:(void(^)(NSString *failMessage))fail;

/**
 *  已读消息
 */
+ (void)readMessageWithParam:(PBMDeleteMsgRequest *)param Success:(void(^)(PBMMsgStatusResult *result))success andFail:(void(^)(NSString *failMessage))fail;
/**
 *  删除消息
 */
+ (void)deleteMessagesWithParam:(PBMDeleteMsgRequest *)param Success:(void(^)(PBMMsgStatusResult *result))success andFail:(void(^)(NSString *failMessage))fail;
// 成长体系，首页接口
+ (void)growSystemHomeDataSuccess:(void (^)(PBMGrowthHome *homeData))success fail:(void (^)(NSString *error))failError;
//领取任务奖励接口
+ (void)getTaskAwardWithParam:(NSString*)taskId success:(void (^)(PBMGrowthDrawTask *award))success fail:(void (^)(NSString *error))failError;
//签到接口
+ (void)signInSuccess:(void (^)(PBMGrowthCheckIn *checkResult))success fail:(void (^)(NSString *error))failError;
//排行接口
+ (void)growSystemRankingDataSuccess:(void (^)(PBMGrowthRanking *rankingData))success fail:(void (^)(NSString *error))failError;
//排行历史接口
+ (void)growSystemHistoryRankingDataWithParam:(PBMRankingAwardParam *)param success:(void (^)(PBMRankingAward *rankingData))success fail:(void (^)(NSString *error))failError;
//排行奖励接口
+ (void)growSystemRankingGiftDataWithParam:(PBMRankingAwardParam *)rankingAwardParam success:(void (^)(PBMGrowthDrawTask *rankingData))success fail:(void (^)(NSString *error))failError;
//激活任务接口
+ (void)reactiveTasksuccess:(void (^)())success fail:(void (^)(NSString *error))failError;
#pragma mark---------获取开通投注服务中的用户信息
+ (void)getUserInfoInOpenBetSuccess:(void (^)(PBMUserInfo *result))success andFail:(void(^)(NSString *failMessage))fail;
@end
