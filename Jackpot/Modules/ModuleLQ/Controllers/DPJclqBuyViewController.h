//
//  DPJclqBuyViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//篮彩投注页面

#import "DPSportFilterView.h"
#import <UIKit/UIKit.h>

@interface DPJclqBuyViewController : UIViewController
@property (nonatomic, assign) GameTypeId gameType;              //彩种类型
@property (nonatomic, strong) NSMutableDictionary *commands;    //筛选内容
@property (nonatomic, assign) BOOL isProject;                   //0:首页  1:方案详情
@property (nonatomic, assign) int gameIndex;                    //玩法标识

@end
