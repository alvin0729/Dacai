//
//  DPLBDltDataModel.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-26.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 大乐透

#import "DPLBNumberBasicModel.h"
#import "DPLTNumberViewModel.h"
#import "DPLTNumberViewModel+Singletons.h"
@interface DPLBDltDataModel : DPLBNumberBasicModel

@property(nonatomic,strong,readonly)NSArray * redBallArray ;//红球
@property(nonatomic,strong,readonly)NSArray * blueBallArray ;//篮球

@property (nonatomic, strong, readonly) id<DPLTNumberBaseProtocol,
DPLTNumberMainDataSource,
DPLTNumberMutualDataSource,
DPLTNumberTimerDataSource> viewModel;

- (void)refreshBalls:(int[12])blue redBalls:(int[35])red ;



@end
