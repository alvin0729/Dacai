//
//  DPHLHomeViewModel.m
//  Jackpot
//
//  Created by mu on 15/12/29.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHomeViewModel.h"

@interface DPHLHomeViewModel()
@end

@implementation DPHLHomeViewModel

#pragma mark---------headerObject
- (DPHLObject *)headerObject{
    if (!_headerObject) {
        _headerObject = [[DPHLObject alloc]init];
    }
    return _headerObject;
}
#pragma mark---------tableData
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
      
    }
    return _tableData;
}

- (void)setHomeData:(WagesHome *)homeData{
    _homeData = homeData;
    for (NSInteger i = 0; i < _homeData.wagesItemsArray.count; i++) {
        Wages *item = _homeData.wagesItemsArray[i];
        DPHLObject *object = [[DPHLObject alloc]init];
        object.isFree = item.isFree;
        object.haveBuy = item.isBuy;
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
        object.wagesId = item.id_p;
        object.userId = item.userId;
        object.endDate = bet.endDate;
        [self.tableData addObject:object];
    }
    
    self.headerObject.value = [NSString stringWithFormat:@"top1:%zd",self.homeData.fansCount];
    self.headerObject.detail = self.homeData.profit.length>0?[NSString stringWithFormat:@"top1:%@",self.homeData.profit]:@"top1:--";
    self.headerObject.iconName = self.homeData.backgroudImg;
}
@end
