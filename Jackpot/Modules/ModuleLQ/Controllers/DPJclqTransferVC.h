//
//  DPJclqTransferVC.h
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//篮彩中转页面

#import <UIKit/UIKit.h>

@interface DPJclqTransferVC : UIViewController
@property (nonatomic, assign) GameTypeId gameType;    //彩种类型

@property (nonatomic, strong) UILabel *bottomLabel;           //底部投注注数详情
@property (nonatomic, strong) UILabel *bottomBoundLabel;      //底部奖金
@property (nonatomic, strong) NSMutableArray *matchsArray;    //比赛列表

@end
