//
//  DPGameLiveViewModel+Private.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveViewModel.h"

@interface DPGameLiveViewModel ()
@property (nonatomic, assign) DPGameLiveType dataType;       // 当前数据类型
@property (nonatomic, strong) NSMutableArray *allMatches;   // 所有比赛
@property (nonatomic, strong) NSMutableArray *allUnfinished;// 所有未完成, DPGameLiveDailyModel
@property (nonatomic, strong) NSMutableArray *allCompleted; // 所有已结束, DPGameLiveDailyModel
@property (nonatomic, strong) NSMutableArray *attention;    // 关注, DPGameLiveMatchModel

@property (nonatomic, strong) NSArray *allCompetition;      // 所有赛事
@property (nonatomic, strong) NSArray *visibleCompetition;  // 选中赛事

@property (nonatomic, strong) NSArray *visibleUnfinished;   // 可见的未完成比赛
@property (nonatomic, strong) NSArray *visibleCompleted;    // 可间的已完成比赛

@property (nonatomic, strong) NSString *timeTicks;          // 时间戳
@property (nonatomic, strong) NSMutableSet *goalSet;        // 进球的比赛集合

@end

@interface DPGameLiveViewModel (Private)

// 解析列表数据
- (void)parserFootballHome:(NSData *)data;
- (void)parserBasketballHome:(NSData *)data;

// 解析轮询数据, 并返回是否需要更新
- (BOOL)parserFootballUpdate:(NSData *)data goalSet:(NSMutableSet *)goalSet;
- (BOOL)parserBasketballUpdate:(NSData *)data;

// 排序关注列表
- (void)sortAttentionList;

- (NSArray *)filterAllArray:(NSArray *)allArray withCompetition:(NSArray *)competiton;

@end
