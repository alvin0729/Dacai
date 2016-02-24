//
//  DPHLObject.h
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPHLObject : NSObject
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *subValue;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *subDetail;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isHiddle;
@property (nonatomic, assign) BOOL isWin;
//==========================DPHLItemCell
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) BOOL haveBuy;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger wagesId;
@property (nonatomic, copy) NSString *userIconStr;
@property (nonatomic, copy) NSString *userNameLabelStr;
@property (nonatomic, copy) NSString *userLVBgImageStr;
@property (nonatomic, copy) NSString *userLVLabelStr;
@property (nonatomic, copy) NSString *userAwardRateLabelStr;
@property (nonatomic, copy) NSString *buyBtnStr;
@property (nonatomic, copy) NSString *matchTitleLabStr;
@property (nonatomic, copy) NSString *matchValueLabStr;
@property (nonatomic, copy) NSString *buyCountLabelStr;
@property (nonatomic, copy) NSString *awardValueLabelStr;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *result;
//==========================HLUserHeaderView
@property (nonatomic, strong) NSMutableArray *marksArray;
//==========================热门比赛
@property (nonatomic, copy) NSString *matchTime;
@property (nonatomic, copy) NSString *matchId;
//==========================DPHLMakingMoneyRankingCell
@property (nonatomic, assign) BOOL isWeek;
@end
