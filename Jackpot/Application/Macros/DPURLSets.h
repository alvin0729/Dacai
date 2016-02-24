//
//  DPURLSets.h
//  Jackpot
//
//  Created by WUFAN on 15/10/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifndef __DPURLSets_h__
#define __DPURLSets_h__

// 帮助中心
#define kHelpCenterURL                  [kServerBaseURL stringByAppendingString:@"/web/help/home"]
// 提款注意事项
#define kDrawAttentionURL               [kServerBaseURL stringByAppendingString:@"/web/help/DrawAttention"]
// 提款注意事项
#define kDrawPoundageURL                [kServerBaseURL stringByAppendingString:@"/web/help/DrawFeeAttention"]
// 红包说明页面
#define kHongbaoIntroduceURL            [kServerBaseURL stringByAppendingString:@"/web/help/HongbaoIntroduce"]
// 兑换码说明页面
#define kDuiHuanMaIntroduceURL          [kServerBaseURL stringByAppendingString:@"/web/Help/DhmIntroduce"]
// 认购协议
#define kPayAgreementURL                [kServerBaseURL stringByAppendingString:@"/web/help/BuyProtocol"]
// 注册服务协议
#define kRegisterAgreementURL           [kServerBaseURL stringByAppendingString:@"/web/help/Fuwuxy"]
//// 支付宝网页充值
//#define kAlipayTopupURL                 [kServerBaseURL stringByAppendingString:@"/account/AlipayTopup"]
// 走势图帮助
#define kTrendChartHelpURL              [kServerBaseURL stringByAppendingString:@"/web/help/TrendChart"]
//奖金优化
#define kHelpOptimizeURL                  [kServerBaseURL stringByAppendingString:@"/web/help/jjyh"]
//心水确定
#define kHelpHeartConfirmURL                  [kServerBaseURL stringByAppendingString:@"/web/help/wages"]



// 玩法说明
#define kDltPlayIntroduceURL                [kServerBaseURL stringByAppendingString:@"/web/help/dlt"]
#define kJcPlayIntroduceURL                [kServerBaseURL stringByAppendingString:@"/web/help/jczq"]
#define kLcPlayIntroduceURL                [kServerBaseURL stringByAppendingString:@"/web/help/jclq"]

//// 玩法说明
//#define kPlayIntroduceURL(gameType_internal_)   [kServerBaseURL stringByAppendingFormat:@"/web/help/PlayIntroduce?gameTypeId=%d", gameType_internal_]

#endif
