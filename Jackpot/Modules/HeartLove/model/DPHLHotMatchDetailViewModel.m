//
//  DPHLHotMatchDetailViewModel.m
//  Jackpot
//
//  Created by mu on 15/12/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHotMatchDetailViewModel.h"

@implementation DPHLHotMatchDetailViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.headerObject = [[DPHLObject alloc]init];
        self.matchWagesArray = [NSMutableArray array];
        self.matchCommentsArray = [NSMutableArray array];
    }
    return self;
}
#pragma mark---------header
- (void)setHeaderObjectWithUserInfo:(Match *)matchInfo{
    self.headerObject.title = matchInfo.competitionName;
    self.headerObject.value = matchInfo.homeTeamIcon;
    self.headerObject.subValue = matchInfo.homeTeamName;
    self.headerObject.detail = matchInfo.awayTemaIcon;
    self.headerObject.subDetail = matchInfo.awayTemaName;
    self.headerObject.matchTime = [NSString stringWithFormat:@"%@截止",[NSDate dp_coverDateString:matchInfo.endDate fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm]];
    self.headerObject.matchId = [NSString stringWithFormat:@"%zd",matchInfo.matchId];
}
#pragma mark---------myWages
- (void)setMatchWages:(MatchWages *)matchWages{
    _matchWages = matchWages;
    [self setHeaderObjectWithUserInfo:_matchWages.match];
    for (NSInteger i = 0; i < matchWages.wagesItemsArray.count; i++) {
        Wages *item = matchWages.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.userIconStr = item.userIcon;
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
        object.userNameLabelStr = item.userName;
        object.wagesId = item.id_p;
        object.userId = item.userId;
        object.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",item.userLever];
        object.userAwardRateLabelStr = item.recentWinRate;
        object.buyBtnStr = [NSString stringWithFormat:@"%zd",item.price];
        object.buyCountLabelStr = [NSString stringWithFormat:@"%zd",item.buyCount];
        object.awardValueLabelStr = item.profit;
        BetItem *bet = item.betItemsArray[0];
        object.matchTitleLabStr = [NSString stringWithFormat:@"%@ VS %@",bet.homeTeamName,bet.awayTemaName];
        object.matchValueLabStr = bet.option;
        object.endDate = bet.endDate;
        [self.matchWagesArray addObject:object];
    }
}
#pragma mark---------myBuys

@end
