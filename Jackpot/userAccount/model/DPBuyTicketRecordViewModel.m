//
//  DPBuyTicketRecordViewModel.m
//  Jackpot
//
//  Created by mu on 16/1/25.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPBuyTicketRecordViewModel.h"

@implementation DPBuyTicketRecordViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.totalArray = [NSMutableArray array];
        self.noPayArray = [NSMutableArray array];
        self.noFinishArray = [NSMutableArray array];
        self.rewardArray = [NSMutableArray array];
    }
    return self;
}

- (void)setTotalResult:(LotteryHistoryResult *)totalResult{
    _totalResult = totalResult;
    for (NSInteger i = 0; i < totalResult.lotteryHistoryItemArray.count; i++) {
        LotteryHistoryResult_LotteryHistoryItem *item = totalResult.lotteryHistoryItemArray[i];
        [self.totalArray addObject:item];
    }
    
}

- (void)setNoPayResult:(LotteryHistoryResult *)noPayResult{
    _noPayResult = noPayResult;
    for (NSInteger i = 0; i < noPayResult.lotteryHistoryItemArray.count; i++) {
        LotteryHistoryResult_LotteryHistoryItem *item = noPayResult.lotteryHistoryItemArray[i];
        [self.noPayArray addObject:item];
    }
}

- (void)setNoFinishResult:(LotteryHistoryResult *)noFinishResult{
    _noFinishResult = noFinishResult;
    for (NSInteger i = 0; i < noFinishResult.lotteryHistoryItemArray.count; i++) {
        LotteryHistoryResult_LotteryHistoryItem *item = noFinishResult.lotteryHistoryItemArray[i];
        [self.noFinishArray addObject:item];
    }
}

- (void)setRewardResult:(LotteryHistoryResult *)rewardResult{
    _rewardResult = rewardResult;
    for (NSInteger i = 0; i < rewardResult.lotteryHistoryItemArray.count; i++) {
        LotteryHistoryResult_LotteryHistoryItem *item = rewardResult.lotteryHistoryItemArray[i];
        [self.rewardArray addObject:item];
    }
}
@end
