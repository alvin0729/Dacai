//
//  DPHomeDateModel.h
//  Jackpot
//
//  Created by Ray on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  快速投注竞彩数据

#import <Foundation/Foundation.h>
#import "Home.pbobjc.h"

 

typedef struct HomeOption {
    int betJczqOption[3] ;//竞彩足球
     int betLcOption[2] ; //竞彩篮球  客队 -- 主队
 }HomeOption;

 
@interface HomeBetOption : NSObject

@property(nonatomic,assign)HomeOption betOption ;
-(void)resetQuickBet ;


@end

//投注内容
@interface PBMHomePage_SportQuickBet(Addation)

 
@property(nonatomic, strong, readonly) HomeBetOption *homeBetOption;

//更新竞彩投注选项所选择的状态
- (void)updateSelectStatusWithGmaeType:(GameTypeId)gametype  index:(NSInteger)index select:(BOOL)isSelect ;
//计算奖金范围
-(void)getMinBounds:(float*)min maxBouns:(float*)max gameType:(GameTypeId)gameType ;
//计算注数
-(NSInteger)getSelectedCount:(GameTypeId)gameType ;
//设置默认选择选项
-(NSInteger)setDefaultSelected:(GameTypeId)gameType ;

@end