//
//  DPDltContentModel.h
//  Jackpot
//
//  Created by WUFAN on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//  sxf注释

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface DPProjectDltBaseModel : NSObject <YYModel>
@property (nonatomic, assign, getter=isAdd) BOOL add;//是否追加
@property (nonatomic, assign, getter=isSingle) BOOL single;//单式复式
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger note;//注数
@end

//大乐透复式
@interface DPProjectDltDuplex : DPProjectDltBaseModel
@property (nonatomic, strong) NSArray<NSString *> *backAreaNums;//后区
@property (nonatomic, strong) NSArray<NSString *> *propAreaNums;//前区
@end

//大乐透单式
@interface DPProjectDltSingle : DPProjectDltBaseModel
@property (nonatomic, strong) NSArray<NSString *> *bets;
@end

//大乐透胆拖
@interface DPProjectDltGallDrag : DPProjectDltBaseModel
@property (nonatomic, strong) NSArray<NSString *> *backAreaDrags;//拖
@property (nonatomic, strong) NSArray<NSString *> *propAreaDrags;
@property (nonatomic, strong) NSArray<NSString *> *backAreaGalls;
@property (nonatomic, strong) NSArray<NSString *> *propAreaGalls;//胆
@end