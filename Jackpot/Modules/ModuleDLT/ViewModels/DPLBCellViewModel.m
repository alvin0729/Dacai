//
//  DPLBCellViewModel.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLBCellViewModel.h"

@implementation DPLBTrendCellViewModel
@synthesize gameType = _gameType;
@synthesize ballViewImg = _ballViewImg;
@synthesize gameNameColor = _gameNameColor;
@synthesize gameNameText = _gameNameText;
@synthesize gameInfoAttText = _gameInfoAttText;

@end

   
@implementation DPLBDigitalCellViewModel
@synthesize gameType = _gameType;//彩种类型
@synthesize gameIndex = _gameIndex;//玩法类型
@synthesize indexPath = _indexPath;//当前行
@synthesize isOpenSwitch = _isOpenSwitch;//是否开启遗漏
@synthesize btnSelectArray = _btnSelectArray;//经过选择后的
@synthesize total = _total;
@synthesize labelColorArray = _labelColorArray;//遗漏值颜色
@synthesize labelTextArray = _labelTextArray;//遗漏值

@end

 