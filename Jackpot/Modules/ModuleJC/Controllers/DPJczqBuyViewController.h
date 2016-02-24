//
//  DPJczqBuyViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 竞彩足球投注页面

#import "DPSportFilterView.h"
#import <UIKit/UIKit.h>

@interface DPJczqBuyViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;              //彩种类型
@property (nonatomic, strong) DPSportFilterView *filterView;    //筛选
@property (nonatomic, strong) NSMutableDictionary *commands;    //筛选内容
@property (nonatomic, assign) NSInteger isProject;              //是否方案详情里进的
@property (nonatomic, assign) int gameIndex;                    //玩法标识

@end
