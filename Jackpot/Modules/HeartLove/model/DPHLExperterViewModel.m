//
//  DPHLExperterViewModel.m
//  Jackpot
//
//  Created by mu on 15/12/31.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLExperterViewModel.h"
@interface DPHLExperterViewModel()

@end
@implementation DPHLExperterViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.headerObject = [[DPHLObject alloc]init];
        self.myWagesArray = [NSMutableArray array];
        self.historyWagesArray = [NSMutableArray array];
    }
    return self;
}
#pragma mark---------header
- (void)setHeaderObjectWithUserInfo:(User *)userInfo{
    self.headerObject.userIconStr = userInfo.userIcon;
    self.headerObject.userNameLabelStr = userInfo.userName;
    self.headerObject.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",userInfo.userLever];
    self.headerObject.subTitle =  [NSString stringWithFormat:@"%zd",userInfo.fansCount];
    self.headerObject.value = userInfo.winRate;
    self.headerObject.subValue = userInfo.recentMonthProfit;
    self.headerObject.detail = userInfo.recentWeekWinRate;
    self.headerObject.subDetail = userInfo.recentWeekWinRate;
    self.headerObject.title = userInfo.userDescrption;
    self.headerObject.userId = userInfo.userId;
    NSMutableString *markStr = [NSMutableString stringWithString:userInfo.userTag];
    self.headerObject.marksArray = [NSMutableArray arrayWithArray:[markStr componentsSeparatedByString:@","]];
}
#pragma mark---------myWages
- (void)setMyWages:(ExpertWages *)myWages{
    _myWages = myWages;
    [self setHeaderObjectWithUserInfo:myWages.userInfo];
    for (NSInteger i = 0; i < myWages.wagesItemsArray.count; i++) {
        Wages *item = myWages.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.wagesId = (long)item.id_p;
        object.userId = (long)item.userId;
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
        object.userNameLabelStr = item.userName;
        object.iconName = item.userIcon;
        object.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",item.userLever];
        object.userAwardRateLabelStr = item.recentWinRate;
        object.buyBtnStr = [NSString stringWithFormat:@"%zd",item.price];
        object.buyCountLabelStr = [NSString stringWithFormat:@"%zd",item.buyCount];
        object.awardValueLabelStr = item.profit;
        BetItem *bet = item.betItemsArray[0];
        object.matchTitleLabStr = [NSString stringWithFormat:@"%@ VS %@",bet.homeTeamName,bet.awayTemaName];
        object.matchValueLabStr = bet.option;
        object.endDate = bet.endDate;
        [self.myWagesArray addObject:object];
    }
}
#pragma mark---------historyWages
- (void)setHistoryWages:(ExpertWages *)historyWages{
    _historyWages = historyWages;
    [self setHeaderObjectWithUserInfo:historyWages.userInfo];
    for (NSInteger i = 0; i < historyWages.wagesItemsArray.count; i++) {
        Wages *item = historyWages.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.wagesId = (long)item.id_p;
        object.userId = (long)item.userId;
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
        object.userNameLabelStr = item.userName;
        object.userIconStr = item.userIcon;
        object.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",item.userLever];
        object.userAwardRateLabelStr = item.recentWinRate;
        object.buyBtnStr = [NSString stringWithFormat:@"%zd",item.price];
        object.buyCountLabelStr = [NSString stringWithFormat:@"%zd",item.buyCount];
        object.awardValueLabelStr = item.profit;
        BetItem *bet = item.betItemsArray[0];
        object.matchTitleLabStr = [NSString stringWithFormat:@"%@ VS %@",bet.homeTeamName,bet.awayTemaName];
        object.matchValueLabStr = bet.option;
        object.isWin = bet.isWin;
        object.result = bet.result;
        [self.historyWagesArray addObject:object];
    }
}
@end
