//
//  DPGameLiveModels.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveModels.h"

NSString *kDPGameLiveScoreChangeNotifyKey = @"kDPGameLiveScoreChangeKey";;
NSString *kDPGameLiveScoreGoalSetKey = @"kDPGameLiveScoreGoalSetKey";

@implementation DPGameLiveMatchModel

@end

@implementation DPGameLiveDailyModel
- (instancetype)init {
    if (self = [super init]) {
        _unfold = YES;
    }
    return self;
}
@end

@implementation DPGameLiveFootballEvent
@end

@implementation DPGameLiveGoalModel
@end