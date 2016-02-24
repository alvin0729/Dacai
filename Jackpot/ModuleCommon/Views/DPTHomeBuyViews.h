//
//  DPTHomeBuyViews.h
//  Jackpot
//
//  Created by sxf on 15/7/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPJcdgTableCells.h"

@protocol DPHomeBuyJCViewDelegate;
#define  JCButtonTag  100
#define  LCButtonTag   200
@interface DPHomeBuyJCView : UIView

@property(nonatomic,strong,readonly) UILabel *titleLabel;//比赛信息
@property(nonatomic,strong,readonly) UILabel *bonusLabel;//预计奖金
@property(nonatomic,strong,readonly) UIButton *bonusButton;//购买现金
@property(nonatomic,strong,readonly)UUBar *leftSingleView;//左侧支持率
@property(nonatomic,strong,readonly)UUBar *middleSingleView;//中间支持率
@property(nonatomic,strong,readonly)UUBar *rightSingleView;//右侧支持率
@property(nonatomic,assign)GameTypeId gameId;
@property(nonatomic,weak)id<DPHomeBuyJCViewDelegate>delegate;

- (instancetype)initWithGameTye:(GameTypeId)gameType;
@end


@protocol DPHomeBuyJCViewDelegate <NSObject>

//点击比赛选项
- (void)clickHomeBuyJCView:(DPHomeBuyJCView *)view  isSelected:(BOOL)isSelected  index:(NSInteger)index   gameType:(GameTypeId)gameType;
//点击购买
- (void)clickJcPayMoney:(GameTypeId)gameType;
//投注玩法详情
- (void)clickGameInfo:(DPHomeBuyJCView *)view;
@end



