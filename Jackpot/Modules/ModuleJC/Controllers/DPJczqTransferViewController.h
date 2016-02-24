//
//  DPJczqTransferViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  竞彩足球中转页面

#import <UIKit/UIKit.h>

@interface DPJczqTransferViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;                //彩种类型
@property (nonatomic, strong) UILabel *bottomLabel;    //底部投注注数详情
@property (nonatomic, strong) UILabel *bottomBoundLabel;      //底部奖金
@property (nonatomic, strong) NSMutableArray *matchsArray;//比赛列表
@end




