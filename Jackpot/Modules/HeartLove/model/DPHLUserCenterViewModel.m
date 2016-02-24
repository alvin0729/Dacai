//
//  DPHLUserCenterViewModel.m
//  Jackpot
//
//  Created by mu on 15/12/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLUserCenterViewModel.h"
@interface DPHLUserCenterViewModel()
@end

@implementation DPHLUserCenterViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.headerObject = [[DPHLObject alloc]init];
        self.myWagesArray = [NSMutableArray array];
        self.myBuysArray = [NSMutableArray array];
        self.myFocusArray = [NSMutableArray array];
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
        self.headerObject.userIconStr = userInfo.userIcon;
        NSMutableString *markStr = [NSMutableString stringWithString:userInfo.userTag];
        self.headerObject.marksArray = [NSMutableArray arrayWithArray:[markStr componentsSeparatedByString:@","]];
}
#pragma mark---------myWages
- (void)setMyWages:(MyWages *)myWages{
    _myWages = myWages;
    [self setHeaderObjectWithUserInfo:myWages.userInfo];
    for (NSInteger i = 0; i < myWages.wagesItemsArray.count; i++) {
        Wages *item = myWages.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
        object.userNameLabelStr = item.userName;
        object.wagesId = (long)item.id_p;
        object.userId = (long)item.userId;
        object.userIconStr = item.userIcon;
        object.userLVLabelStr = [NSString stringWithFormat:@"LV%zd",item.userLever];
        object.userAwardRateLabelStr = item.recentWinRate;
        object.buyBtnStr = [NSString stringWithFormat:@"%zd",item.price];
        object.buyCountLabelStr = [NSString stringWithFormat:@"%zd",item.buyCount];
        object.awardValueLabelStr = item.profit;
        BetItem *bet = item.betItemsArray[0];
        object.matchTitleLabStr = [NSString stringWithFormat:@"%@ VS %@",bet.homeTeamName,bet.awayTemaName];
        object.matchValueLabStr = bet.option;
        object.endDate = bet.endDate;
        object.isWin = bet.isWin;
        object.result = bet.result;
        [self.myWagesArray addObject:object];
    }
}
#pragma mark---------myBuys
- (void)setMyBuys:(MyWages *)myBuys{
    _myBuys = myBuys;
    [self setHeaderObjectWithUserInfo:myBuys.userInfo];
    for (NSInteger i = 0; i < myBuys.wagesItemsArray.count; i++) {
        Wages *item = myBuys.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
        object.wagesId = (long)item.id_p;
        object.userId = (long)item.userId;
        object.userIconStr = item.userIcon;
        object.userNameLabelStr = item.userName;
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
        [self.myBuysArray addObject:object];
    }
}
#pragma mark---------myFocus
- (void)setMyFollows:(MyFollow *)myFollows{
    _myFollows = myFollows;
    [self setHeaderObjectWithUserInfo:myFollows.userInfo];
    for (NSInteger i = 0; i < myFollows.followUsersArray.count; i++) {
        User *userItem = myFollows.followUsersArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.userId = (long)userItem.userId;
        object.iconName = userItem.userIcon;
        object.title = userItem.userName;
        object.subTitle = [NSString stringWithFormat:@"%zd",userItem.fansCount];
        object.isSelect = YES;
        NSMutableString *markStr = [NSMutableString stringWithString:userItem.userTag];
        object.marksArray = [NSMutableArray arrayWithArray:[markStr componentsSeparatedByString:@","]];
        [self.myFocusArray addObject:object];
    }
}
@end
