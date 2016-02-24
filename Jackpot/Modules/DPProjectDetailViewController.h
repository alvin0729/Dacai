//
//  DPProjectDetailViewController.h
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  方案详情

#import <UIKit/UIKit.h>
#import "DPUARequestData.h"
@interface DPProjectDetailViewController : UIViewController

@property (nonatomic, strong) LotteryHistoryResult_LotteryHistoryItem *lotteryItem;//购彩记录页面的购买信息
@property (nonatomic, assign) GameTypeId gameType;    //彩种类型
@property (nonatomic, assign) long long projectId;    //订单id
@end
