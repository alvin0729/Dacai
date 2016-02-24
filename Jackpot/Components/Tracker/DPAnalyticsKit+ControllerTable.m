//
//  DPAnalyticsKit+ControllerTable.m
//  Jackpot
//
//  Created by WUFAN on 15/11/26.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPAnalyticsKit+ControllerTable.h"

#import "DPHomePageViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPJczqTransferViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPJclqTransferVC.h"
#import "DPLBDltViewController.h"
#import "DPLTDltViewController.h"
#import "DPDltDrawVC.h"
#import "DPPayRedPacketViewController.h"
#import "DPLotteryBetInfoViewController.h"
#import "DPProjectDetailViewController.h"
#import "DPGameLiveViewController.h"
#import "DPDataCenterViewController.h"
#import "DPFindViewController.h"

#import "DPLotteryResultViewController.h"
#import "DPResultListViewController.h"
#import "DPLotteryInfoViewController.h"
#import "DPSpecifyInfoViewController.h"
#import "DPLotteryInfoWebViewController.h"

#import "DPGSRankingAwardController.h"
#import "DPGSHomeViewController.h"
#import "DPFeedbackViewController.h"
#import "DPGSRankingViewController.h"
#import "DPGSPrerogativeViewController.h"
#import "DPAlterViewController.h"
#import "DPIconNameSetViewController.h"
#import "DPUserAccountHomeViewController.h"
#import "DPUASetViewController.h"
#import "DPUAPushSetViewController.h"
#import "DPUANoTroubleController.h"
#import "DPAboutVC.h"
#import "DPDevConfigViewController.h"
#import "DPRechangeViewController.h"
#import "DPUASuccessController.h"
#import "DPBuyTicketRecordViewController.h"
#import "DPMessageCenterViewController.h"
#import "DPUADWSuccessController.h"
#import "DPDrawMoneyViewController.h"
#import "DPLoginViewController.h"
#import "locationPickController.h"
#import "DPThirdLoginVerifyController.h"
#import "DPOpenBetServiceController.h"
#import "DPLogOnViewController.h"
#import "DPUADazhihuiLoginController.h"
#import "DPUAFundDetailViewController.h"

#define KeyValuePair(cls, name)     NSStringFromClass([cls class]): name

@implementation DPAnalyticsKit (ControllerTable)

+ (NSString *)nameForViewController:(UIViewController *)viewController {
    static NSDictionary *controllerTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controllerTable = @{
            KeyValuePair(DPHomePageViewController, @"首页"),
            KeyValuePair(DPJczqBuyViewController, @"竞彩足球投注"),
            KeyValuePair(DPJczqTransferViewController, @"竞彩足球中转"),
            KeyValuePair(DPJclqBuyViewController, @"竞彩篮球投注"),
            KeyValuePair(DPJclqTransferVC, @"竞彩篮球中转"),
            KeyValuePair(DPLBDltViewController, @"大乐透投注"),
            KeyValuePair(DPLTDltViewController, @"大乐透中转"),
            KeyValuePair(DPDltDrawVC, @"大乐透走势图"),
            KeyValuePair(DPPayRedPacketViewController, @"订单确认"),
            KeyValuePair(DPLotteryBetInfoViewController, @"订单详情"),
            KeyValuePair(DPProjectDetailViewController, @"方案详情"),
            
            KeyValuePair(DPGameLiveViewController, @"比分直播"),
            KeyValuePair(DPDataCenterViewController, @"数据中心"),

            KeyValuePair(DPFindViewController, @"发现"),
            
            KeyValuePair(DPLotteryResultViewController, @"开奖公告"),
            KeyValuePair(DPResultListViewController, [NSNull null]),    // 设置为 [NSNull null], 则使用 title 属性
            KeyValuePair(DPLotteryInfoViewController, @"彩票资讯"),
            KeyValuePair(DPSpecifyInfoViewController, [NSNull null]),
            KeyValuePair(DPLotteryInfoWebViewController, @"资讯详情"),



            
//            KeyValuePair(DPUserAcountBaseViewController, @"我的彩票"),
            KeyValuePair(DPUAFundDetailViewController, @"资金明细"),
            KeyValuePair(DPDrawMoneyViewController, @"提款"),
            KeyValuePair(DPRechangeViewController, @"充值"),
            KeyValuePair(DPGSRankingAwardController, @"历史排行奖励"),
            KeyValuePair(DPGSHomeViewController, @"成长体系首页"),
            KeyValuePair(DPFeedbackViewController, @"意见反馈"),
            KeyValuePair(DPGSRankingViewController, @"用户排行"),
            KeyValuePair(DPGSPrerogativeViewController, @"用户特权"),
            KeyValuePair(DPIconNameSetViewController, @"用户头像昵称设置"),
            KeyValuePair(DPUserAccountHomeViewController, @"我的彩票"),
            KeyValuePair(DPUASetViewController, @"设置"),
            KeyValuePair(DPUAPushSetViewController, @"推送设置"),
            KeyValuePair(DPUANoTroubleController, @"免打扰设置"),
            KeyValuePair(DPAboutVC, @"关于"),
            KeyValuePair(DPUASuccessController, @"充值成功"),
            KeyValuePair(DPBuyTicketRecordViewController, @"购彩记录"),
            KeyValuePair(DPMessageCenterViewController, @"消息中心"),
            KeyValuePair(DPUADWSuccessController, @"提款成功"),
            KeyValuePair(DPLoginViewController, @"注册"),
            KeyValuePair(locationPickController, @"归属地选择"),
            KeyValuePair(DPOpenBetServiceController, @"开启投注服务"),
            KeyValuePair(DPLogOnViewController, @"登录"),
            KeyValuePair(DPUADazhihuiLoginController, @"大智慧登录"),
        };
        
#ifdef DEBUG
        NSArray *allKeys = controllerTable.allKeys;
        NSArray *allValues = controllerTable.allValues;
        NSSet *allKeysSet = [NSSet setWithArray:allKeys];
        NSSet *allValuesSet = [NSSet setWithArray:allValues];
        NSAssert(allKeys.count == allKeysSet.count, @"键存在重复");
//        NSAssert(allValues.count == allValuesSet.count, @"值存在重复");
#endif
        
    });
    NSString *className = NSStringFromClass(viewController.class);
    NSString *name = controllerTable[className];
    if ([name isEqual:[NSNull null]]) {
        return viewController.title;
    }
    return name ?: className;
}

@end
