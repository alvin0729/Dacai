//
//  DPDltBetData.h
//  Jackpot
//
//  Created by sxf on 15/8/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  大乐透投注内容信息

#import <Foundation/Foundation.h>

@interface DPDltBetData : NSObject

@property (nonatomic, strong) NSMutableArray *red;//红球
@property (nonatomic, strong) NSMutableArray *blue;//篮球
@property (nonatomic, strong) NSNumber *note;//注数
@property (nonatomic, assign) BOOL mark;//是否胆拖

@end
