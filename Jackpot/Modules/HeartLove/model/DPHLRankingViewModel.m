//
//  DPHLRankingViewModel.m
//  Jackpot
//
//  Created by mu on 15/12/31.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLRankingViewModel.h"

@implementation DPHLRankingViewModel
@synthesize weekRankingArray;
@synthesize monthRankingArray;
@synthesize totalRankingArray;
- (instancetype)init{
    self = [super init];
    if (self) {
        weekRankingArray = [NSMutableArray array];
        monthRankingArray = [NSMutableArray array];
        totalRankingArray = [NSMutableArray array];
    }
    return self;
}

- (void)setWeekFansRanking:(FansRanking *)weekFansRanking{
    _weekFansRanking = weekFansRanking;
    for (NSInteger i = 0; i < _weekFansRanking.fansItemsArray.count; i++) {
        FansRanking_FansItem *item = _weekFansRanking.fansItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.iconName = item.userIcon;
        object.title = item.userName;
        object.userId = item.userId;
        object.subTitle = [NSString stringWithFormat:@"新增粉丝：%zd",item.newFans];
        object.isSelect = item.isFocused;
        [weekRankingArray addObject:object];
    }
}

- (void)setMonthFansRanking:(FansRanking *)monthFansRanking{
    _monthFansRanking = monthFansRanking;
    for (NSInteger i = 0; i < _monthFansRanking.fansItemsArray.count; i++) {
        FansRanking_FansItem *item = _monthFansRanking.fansItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.iconName = item.userIcon;
        object.title = item.userName;
        object.userId = item.userId;
        object.userIconStr = item.userIcon;
        object.subTitle = [NSString stringWithFormat:@"新增粉丝：%zd",item.newFans];
        object.isSelect = item.isFocused;
        [monthRankingArray addObject:object];
        
    }
}

- (void)setTotalFansRanking:(FansRanking *)totalFansRanking{
    _totalFansRanking = totalFansRanking;
    for (NSInteger i = 0; i < _totalFansRanking.fansItemsArray.count; i++) {
        FansRanking_FansItem *item = _totalFansRanking.fansItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.iconName = item.userIcon;
        object.title = item.userName;
        object.userId = item.userId;
        object.userIconStr = item.userIcon;
        object.subTitle = [NSString stringWithFormat:@"粉丝：%zd",item.newFans];
        object.isSelect = item.isFocused;
        [totalRankingArray addObject:object];
        
    }
}
@end
