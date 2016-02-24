//
//  DPJcdgProtocols.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  单关协议

#ifndef DacaiProject_DPJcdgProtocols_h
#define DacaiProject_DPJcdgProtocols_h
#import "DPJcdgDataModel.h"

typedef NS_ENUM(NSUInteger, MyGameType) {
    
    GameTypeFootBall=0,
    GameTypeBasketBall,
};


// 每个比赛头部的数据模型
@protocol DPJcdgPerTeamData <NSObject>
@required
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *homeRank;
@property (nonatomic, strong) NSString *awayRank;
@property (nonatomic, strong) NSString *homeImg;
@property (nonatomic, strong) NSString *awayImg;
@property (nonatomic, strong) NSString *compitionName;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *sugest;
@end

@protocol DPJcdgBasketDataModel <NSObject>

@required
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int zhushu; //注数
@property (nonatomic, assign) float minBonus; //最小奖金
@property (nonatomic, assign) float maxBonus; //最大奖金


@property (nonatomic, strong) NSString *warnContent;

@optional
@property (nonatomic, strong) NSArray *sp_Numbers; //sp 值

@property (nonatomic, strong) NSArray *defaultOption; //投注选项
@property (nonatomic, strong) NSArray *percents; //投注比例

@end

// 让球胜平负，胜平负cell model
@protocol DPJcdgSpfCellData <NSObject>
@required
@property (nonatomic, strong) NSArray *teamsName;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong) NSArray *defaultOption;
@property (nonatomic, strong) NSArray *percents;
@property (nonatomic, strong) NSString *warnContent;
@property (nonatomic, assign) int zhushu; //注数
@property (nonatomic, assign) float minBonus; //最小奖金
@property (nonatomic, assign) float maxBonus; //最大奖金
@end

// 总进球
@protocol DPJcdgZjqCellData <NSObject>
@required
@property (nonatomic, strong) NSArray *sp_Numbers;
@property (nonatomic, strong) NSArray *defaultOption;
@property (nonatomic, strong) NSString *warnContent;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int zhushu; //注数
@property (nonatomic, assign) float minBonus; //最小奖金
@property (nonatomic, assign) float maxBonus; //最大奖金

@end

// 猜赢球
@protocol DPJcdgGuessCellData <NSObject>
@required
@property (nonatomic, strong) NSString *leftTeamName;
@property (nonatomic, strong) NSString *rightTeamName;
@property (nonatomic, strong) NSArray *defaultOption;
@property (nonatomic, strong) NSString *warnContent;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) int zhushu; //注数
@property (nonatomic, assign) float minBonus; //最小奖金
@property (nonatomic, assign) float maxBonus; //最大奖金

@end


// 单关主要数据模型
@protocol DPJcdgDataSoure <NSObject>
@required
@property (nonatomic, assign, readonly) int gameCountFootBall;                              //比赛数量
@property (nonatomic, assign, readonly) int gameCountBasketBall;                              //比赛数量

@property (nonatomic, assign) int curGameIndex;                                     //当前比赛索引
@property (nonatomic, strong, readonly) NSMutableArray *visibleGamesFootBall;      //当前比赛的玩法类型
@property (nonatomic, strong, readonly) NSMutableArray *visibleGamesBasket;      //当前比赛的玩法类型

/**
 *  获取每组行数
 *
 *  @param section 组号
 *
 *  @return 行数
 */
- (NSInteger)dp_numberOfRowsInSection:(NSInteger)section;

//- (NSString *)dp_cellClassForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)dp_cellClassForRowAtIndexPath:(NSIndexPath *)indexPath type:(MyGameType)type ;


//- (NSString *)dp_cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)dp_cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath withType:(MyGameType)type;

- (id)dp_cellModelForIndexPath:(NSIndexPath *)indexPath;
/**
 *  删除倍数缓存数据
 */
- (void)dp_removeTimesData;
/**
 *  获取每种玩法默认选中情况
 *
 *  @param gameType 玩法类型
 *
 *  @return 选中数组
 */
- (NSArray *)dp_getOpenOptionWithGameType:(GameTypeId)gameType;
/**
 *  获取每场比赛的顶部数据
 *
 *  @param index 比赛的场次
 *  @param type  区分足球、篮球
 *
 *  @return 每场比赛的顶部数据模型
 */
- (id<DPJcdgPerTeamData>)dp_perTeamModelForIndex:(NSInteger)index withGameType:(MyGameType)type ;
@end

@protocol DPJcdgMutualDelegate <NSObject>
@required
@property (nonatomic, assign, readonly) GameTypeId  payGameType;
@property (nonatomic, assign, readonly) NSInteger   payNote;
@property (nonatomic, assign, readonly) NSInteger   payMultiple;
@property (nonatomic, assign, readonly) NSInteger   balanceCost;                    // 奖金优化方案金额
@property (nonatomic, strong) NSMutableDictionary*  timesDict;                      // 倍数输入记录
- (void)dp_becomeDelegate;                                                          // 注册底层回调代理
- (NSInteger)dp_sendJcdgDataRequest;                                                // 向底层请求数据
- (void)dp_sendGoPayRequest;                                                        // 付款请求
- (void)dp_goPayWithGameType:(GameTypeId)gameType times:(int)times;                 // 付款记录数据
- (void)dp_setOpenOptionWithGameType:(GameTypeId)gameType index:(NSInteger)index isSelected:(BOOL)isSelected; // cell 的点击交互
- (void)dp_getWebPayMentWithRet:(int)ret;                                           // 红包支付回调
// 奖金优化相关
- (void)dp_setSingleSelectedTargetWithGameType:(GameTypeId)gameType;
- (NSInteger)dp_getNoteWithGameType:(GameTypeId)gameType note:(out int *)note;
- (NSInteger)dp_sendNetBalance;
- (void)dp_setProjectBuyType:(NSInteger)type;
@end


#endif


