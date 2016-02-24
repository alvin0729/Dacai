//
//  DPGameLiveViewModel.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPGameLiveModels.h"

typedef NS_ENUM(NSInteger, DPGameLiveType) {
    DPGameLiveTypeFootball,
    DPGameLiveTypeBasketball,
};

typedef NS_ENUM(NSInteger, DPGameLiveTab) {
    DPGameLiveTabUnfinished,    // 未完成
    DPGameLiveTabCompleted,     // 已结束
    DPGameLiveTabAttention,     // 关注
};

@protocol DPGameLiveViewDelegate;
@interface DPGameLiveViewModel : NSObject
@property (nonatomic, assign) DPGameLiveType gameLiveType;
@property (nonatomic, weak) id<DPGameLiveViewDelegate> delegate;
@property (nonatomic, assign) NSInteger attentionCount;

@property (nonatomic, strong, readonly) NSString *baseIdentifier;
@property (nonatomic, strong, readonly) NSString *footballIdentifier;
@property (nonatomic, strong, readonly) NSString *basketballIdentifier;

@property (nonatomic, strong, readonly) NSArray *allCompetition;      // 所有赛事
@property (nonatomic, strong, readonly) NSArray *visibleCompetition;  // 选中赛事
@property (nonatomic, assign, readonly) BOOL hasMatches;

- (instancetype)initWithDelegate:(id<DPGameLiveViewDelegate>)delegate;


/**
 *  获取指定位置上cell的重用标识
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *
 *  @return 重用字符串标识
 */
- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
/**
 *  获取指定标签下的天数
 *
 *  @param tab [in]标签
 *
 *  @return NSInteger
 */
- (NSInteger)numberOfSectionsForTab:(DPGameLiveTab)tab;
/**
 *  获取指定标签下某一天的比赛数
 *
 *  @param section [in]节索引
 *  @param tab     [in]标签
 *
 *  @return NSInteger
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section forTab:(DPGameLiveTab)tab;
/**
 *  一天的标题
 *
 *  @param section [in]节索引
 *  @param tab     [in]标签
 *
 *  @return 标题, e.g. @"2015年08月25日 星期五"
 */
- (NSString *)titleForSection:(NSInteger)section forTab:(DPGameLiveTab)tab;

/**
 *  是否展开了单元格, 查看赛事事件/各节得分
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *
 *  @return YES 表示展开
 */
- (BOOL)cellUnfoldAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
/**
 *  展开/收拢单元格
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 */
- (void)toggleCellAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;

/**
 *  是否展开了一天的比赛
 *
 *  @param section [in]节索引
 *  @param tab     [in]标签
 *
 *  @return YES 表示展开
 */
- (BOOL)unfoldSection:(NSInteger)section forTab:(DPGameLiveTab)tab;
/**
 *  展开/收拢一天的比赛
 *
 *  @param section [in]节索引
 *  @param tab     [in]标签
 */
- (void)toggleSection:(NSInteger)section forTab:(DPGameLiveTab)tab;

/**
 *  根据条件筛选比赛
 *
 *  @param competition [in]赛事条件
 */
- (void)filterWithVisibleCompetition:(NSArray *)competition;

/**
 *  获取一场比赛对应的模型
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *
 *  @return model
 */
- (DPGameLiveMatchModel *)matchModelAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
/**
 *  获取比赛状态
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *
 *  @return 比赛状态, e.g. @"未开始" or @"34'\n2:1\n半场:0:0"
 */
- (NSArray *)matchStatusAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;

/**
 *  判断比赛是否在进行中
 *
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *
 *  @return 进行中返回 YES, 否则返回 NO, 中场休息 or 各节休息返回 NO
 */
- (BOOL)matchGoingAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;

/**
 *  关注比赛
 *
 *  @param attention [in]是否关注
 *  @param indexPath [in]行索引
 *  @param tab       [in]标签
 *  @param tab       [in]是否需要请求网络

 */
- (void)attentionMatch:(BOOL)attention atIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab needLoad:(BOOL)needLoad;

/**
 *  指定赛事的比赛总场数
 *
 *  @param competition [in]赛事数组, e.g.  @[@"英超", @"亚洲杯"]
 *
 *  @return NSInteger
 */
- (NSInteger)matchCountForCompetition:(NSArray *)competition;


// 篮球各节比分
- (NSArray *)basketballHomeScoresAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
- (NSArray *)basketballAwayScoresAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;

- (BOOL)shouldAttentionAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
- (BOOL)shouldUnfoldAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;
- (BOOL)extraBasketballAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab;

@end

@interface DPGameLiveViewModel (Network)
/**
 *  获取列表数据
 */
- (void)fetch;
/**
 *  从网络加载图片
 *
 *  @param matchModel [in]指定的比赛
 */
- (void)fetchImageIfNeeded:(DPGameLiveMatchModel *)matchModel;

/**
 *  启动轮询
 */
- (void)activateUpdateLoop;
/**
 *  停止轮询
 */
- (void)deactivateUpdateLoop;

@end

@protocol DPGameLiveViewDelegate <NSObject>
@required
/**
 *  请求完成
 *
 *  @param error      [in]出错返回错误信息, 成功返回nil
 *  @param gameSwitch [in]是否发生了菜种切换, 用于定位默认tab
 */
- (void)fetchFinished:(NSError *)error needLocationTab:(BOOL)needLocationTab;
/**
 *  更新比赛信息
 */
- (void)updateMatchInfo;
@end
