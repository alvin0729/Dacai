//
//  DPLotteryBetInfoViewController.h
//  Jackpot
//
//  Created by sxf on 15/8/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

//订单投注详情
@interface DPLotteryBetInfoViewController : UIViewController

@property(nonatomic,assign)GameTypeId gameType;//彩种id
@property(nonatomic,assign)long long projectId;//方案or订单id
@end
