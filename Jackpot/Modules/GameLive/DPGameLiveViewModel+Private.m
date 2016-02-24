//
//  DPGameLiveViewModel+Private.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveViewModel+Private.h"
#import "Gamelive.pbobjc.h"

@implementation DPGameLiveViewModel (Private)

- (void)sortAttentionList {
    [self.attention sortUsingComparator:^NSComparisonResult(DPGameLiveMatchModel *obj1, DPGameLiveMatchModel *obj2) {
        return NSOrderedAscending;
    }];
}

- (DPGameLiveMatchModel *)matchModelWithPBFootballModel:(PBMFootballLive_Match *)match {
    DPGameLiveMatchModel *model = [[DPGameLiveMatchModel alloc] init];
    model.homeName = match.homeName;
    model.awayName = match.awayName;
    model.homeLogoURL = match.homeLogo;
    model.awayLogoURL = match.awayLogo;
    model.competition = match.competition;
    model.matchStatus = match.status;
    model.homeScore = match.homeScore;
    model.awayScore = match.awayScore;
    model.homeHalfScore = match.homeHalfScore;
    model.awayHalfScore = match.awayHalfScore;
    model.matchId = match.matchId;
    model.comment = match.commentCount;
    model.startTime = [NSDate dp_dateFromString:match.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    model.halfTime = [NSDate dp_dateFromString:match.halfTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    model.matchTitle = [NSString stringWithFormat:@"● %@  %@  %@", match.orderNumberName, match.competition, [model.startTime dp_stringWithFormat:@"HH:mm"]];
    if (match.homeRank.length) {
        model.homeRank = [NSString stringWithFormat:@"[%@]", match.homeRank];
    }
    if (match.awayRank.length) {
        model.awayRank = [NSString stringWithFormat:@"[%@]", match.awayRank];
    }
    
    model.events = [match.eventListArray dp_mapObjectUsingBlock:^id(PBMFootballLive_Event *obj, NSUInteger idx, BOOL *stop) {
        DPGameLiveFootballEvent *event = [[DPGameLiveFootballEvent alloc] init];
        event.homeOrAway = obj.homeOrAway;
        event.player = obj.player;
        event.type = obj.event;
        event.time = obj.time;
        return event;
    }];
    return model;
}

- (DPGameLiveMatchModel *)matchModelWithPBBasketballModel:(PBMBasketballLive_Match *)match {
    DPGameLiveMatchModel *model = [[DPGameLiveMatchModel alloc] init];
    model.homeName = match.homeName;
    model.awayName = match.awayName;
    model.homeLogoURL = match.homeLogo;
    model.awayLogoURL = match.awayLogo;
    model.competition = match.competition;
    model.matchStatus = match.status;
    model.matchId = match.matchId;
    model.comment = match.commentCount;
    model.startTime = [NSDate dp_dateFromString:match.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    model.onTime = match.onTime;
    model.matchTitle = [NSString stringWithFormat:@"● %@  %@  %@", match.orderNumberName, match.competition, [NSDate dp_coverDateString:match.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"HH:mm"]];
    // 主队各节得分
    NSMutableArray *homeSectionScore = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        int32_t score = i >= match.homeScoreArray.count ? 0 : [match.homeScoreArray valueAtIndex:i];
        model.homeScore += score;
        [homeSectionScore addObject:@(score)];
    }
    model.homeSectionScore = homeSectionScore;
    // 客队各节得分
    NSMutableArray *awaySectionScore = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        int32_t score = i >= match.awayScoreArray.count ? 0 : [match.awayScoreArray valueAtIndex:i];
        model.awayScore += score;
        [awaySectionScore addObject:@(score)];
    }
    model.awaySectionScore = awaySectionScore;
    
    if (match.homeRank.length) {
        model.homeRank = [NSString stringWithFormat:@"[%@]", match.homeRank];
    }
    if (match.awayRank.length) {
        model.awayRank = [NSString stringWithFormat:@"[%@]", match.awayRank];
    }
    return model;
}

/**
 *  根据筛选条件, 生产过滤后的赛事列表
 *
 *  @param visibleArray [in]过滤后的赛事列表
 *  @param allArray     [in]未过滤的赛事列表
 *  @param competiton   [in]选中的赛事
 */
- (NSArray *)filterAllArray:(NSArray *)allArray withCompetition:(NSArray *)competiton {
    NSMutableArray *visibleArray = [NSMutableArray array];
    for (DPGameLiveDailyModel *daliyModel in allArray) {
        DPGameLiveDailyModel *visibleModel = [[DPGameLiveDailyModel alloc] init];
        visibleModel.gameTime = daliyModel.gameTime;
        visibleModel.matches = [NSMutableArray array];
        for (DPGameLiveMatchModel *matchModel in daliyModel.matches) {
            if ([competiton containsObject:matchModel.competition]) {
                [visibleModel.matches addObject:matchModel];
            }
        }
        
        // 过滤后存在比赛, 则添加到列表
        if (visibleModel.matches.count) {
            [visibleArray addObject:visibleModel];
        }
    }
    return visibleArray;
}

- (void)parserFootballHome:(NSData *)data {
    PBMFootballLive *live = [PBMFootballLive parseFromData:data error:nil];
    NSMutableArray *allUnfinished = [NSMutableArray arrayWithCapacity:live.unfinishedArray.count];
    NSMutableArray *allCompleted = [NSMutableArray arrayWithCapacity:live.completedArray.count];
    
    NSMutableArray *allMatches = [[NSMutableArray alloc] init];
    NSMutableSet *competitionSet = [[NSMutableSet alloc] init];
    
    void (^pb2model)(NSMutableArray *, NSArray *) = ^(NSMutableArray *dailyArray, NSArray *groupArray) {
        for (PBMFootballLive_MatchGroup *group in groupArray) {
            NSDate *date = [NSDate dp_dateFromString:group.date withFormat:dp_DateFormatter_yyyy_MM_dd];
            DPGameLiveDailyModel *dailyModel = [[DPGameLiveDailyModel alloc] init];
            dailyModel.gameTime = [date dp_stringWithFormat:@"yyyy年MM月dd日 EEEE"];
            dailyModel.matches = [NSMutableArray arrayWithCapacity:group.matchListArray.count];
            for (PBMFootballLive_Match *match in group.matchListArray) {
                DPGameLiveMatchModel *matchModel = [self matchModelWithPBFootballModel:match];
                // 添加到每日对阵中
                [dailyModel.matches addObject:matchModel];
                // 统计所有比赛和所有赛事
                [allMatches addObject:matchModel];
                [competitionSet addObject:match.competition];
            }
            [dailyArray addObject:dailyModel];
        }
    };
    
    // 解析protobuf数据
    pb2model(allUnfinished, live.unfinishedArray);
    pb2model(allCompleted, live.completedArray);
    
    for (DPGameLiveMatchModel *oldModel in self.allMatches) {
        for (DPGameLiveMatchModel *newModel in allMatches) {
            if (oldModel.matchId == newModel.matchId) {
                newModel.unfold = oldModel.unfold;
                if ([newModel.homeLogoURL isEqualToString:oldModel.homeLogoURL]) {
                    newModel.homeLogo = oldModel.homeLogo;
                }
                if ([newModel.awayLogoURL isEqualToString:oldModel.awayLogoURL]) {
                    newModel.awayLogo = oldModel.awayLogo;
                }
                break;
            }
        }
    }
    
    // 生成关注列表
    NSMutableArray *attention = [NSMutableArray arrayWithCapacity:live.attentionIdArray.count];
    [live.attentionIdArray enumerateValuesWithBlock:^(int64_t value, NSUInteger idx, BOOL *stop) {
        for (DPGameLiveMatchModel *model in allMatches) {
            if (model.matchId == value) {
                model.attention = YES;
                [attention addObject:model];
                break;
            }
        }
    }];
    [self sortAttentionList];
    
    // 所有赛事
    self.allUnfinished = allUnfinished;
    self.allCompleted = allCompleted;
    self.allMatches = allMatches;
    self.attention = attention;
    
    // 判断赛事是否发生改变
    if (![competitionSet isEqualToSet:[NSSet setWithArray:self.allCompetition]]) {
        // 如果赛事列表发生变化, 则刷新所有数据
        self.allCompetition = [competitionSet allObjects];
        self.visibleCompetition = [competitionSet allObjects];
        
        // 重置赛事列表
        self.visibleUnfinished = allUnfinished;
        self.visibleCompleted = allCompleted;
    } else {
        // 赛事列表没有发生改变, 则用以前的过滤条件进行过滤赛事
        // 生成筛选后的赛事
        self.visibleUnfinished = [self filterAllArray:allUnfinished withCompetition:self.visibleCompetition];
        self.visibleCompleted = [self filterAllArray:allCompleted withCompetition:self.visibleCompetition];
    }
    
    // 关注的比赛场数
    self.attentionCount = self.attention.count;
    // 记录时间戳
    self.timeTicks = live.currentTicks;
    // 数据彩种类型
    self.dataType = DPGameLiveTypeFootball;
    
 }

- (void)parserBasketballHome:(NSData *)data {
    PBMBasketballLive *live = [PBMBasketballLive parseFromData:data error:nil];
    NSMutableArray *allUnfinished = [NSMutableArray arrayWithCapacity:live.unfinishedArray.count];
    NSMutableArray *allCompleted = [NSMutableArray arrayWithCapacity:live.completedArray.count];
    
    NSMutableArray *allMatches = [[NSMutableArray alloc] init];
    NSMutableSet *competitionSet = [[NSMutableSet alloc] init];
    
    void (^pb2model)(NSMutableArray *, NSArray *) = ^(NSMutableArray *dailyArray, NSArray *groupArray) {
        for (PBMBasketballLive_MatchGroup *group in groupArray) {
            NSDate *date = [NSDate dp_dateFromString:group.date withFormat:dp_DateFormatter_yyyy_MM_dd];
            DPGameLiveDailyModel *dailyModel = [[DPGameLiveDailyModel alloc] init];
            dailyModel.gameTime = [date dp_stringWithFormat:@"yyyy年MM月dd日 EEEE"];
            dailyModel.matches = [NSMutableArray arrayWithCapacity:group.matchListArray.count];
            for (PBMBasketballLive_Match *match in group.matchListArray) {
                DPGameLiveMatchModel *matchModel = [self matchModelWithPBBasketballModel:match];
                // 添加到每日对阵中
                [dailyModel.matches addObject:matchModel];
                // 统计所有比赛和所有赛事
                [allMatches addObject:matchModel];
                [competitionSet addObject:match.competition];
            }
            [dailyArray addObject:dailyModel];
        }
    };
    
    // 解析protobuf数据
    pb2model(allUnfinished, live.unfinishedArray);
    pb2model(allCompleted, live.completedArray);
    
    for (DPGameLiveMatchModel *oldModel in self.allMatches) {
        for (DPGameLiveMatchModel *newModel in allMatches) {
            if (oldModel.matchId == newModel.matchId) {
                newModel.unfold = oldModel.unfold;
                if ([newModel.homeLogoURL isEqualToString:oldModel.homeLogoURL]) {
                    newModel.homeLogo = oldModel.homeLogo;
                }
                if ([newModel.awayLogoURL isEqualToString:oldModel.awayLogoURL]) {
                    newModel.awayLogo = oldModel.awayLogo;
                }
                break;
            }
        }
    }
    
    // 生成关注列表
    NSMutableArray *attention = [NSMutableArray arrayWithCapacity:live.attentionIdArray.count];
    [live.attentionIdArray enumerateValuesWithBlock:^(int64_t value, NSUInteger idx, BOOL *stop) {
        for (DPGameLiveMatchModel *model in allMatches) {
            if (model.matchId == value) {
                model.attention = YES;
                [attention addObject:model];
                break;
            }
        }
    }];
    [self sortAttentionList];
    
    // 所有赛事
    self.allUnfinished = allUnfinished;
    self.allCompleted = allCompleted;
    self.allMatches = allMatches;
    self.attention = attention;
    
    // 判断赛事是否发生改变
    if (![competitionSet isEqualToSet:[NSSet setWithArray:self.allCompetition]]) {
        // 如果赛事列表发生变化, 则刷新所有数据
        self.allCompetition = [competitionSet allObjects];
        self.visibleCompetition = [competitionSet allObjects];
        
        // 重置赛事列表
        self.visibleUnfinished = allUnfinished;
        self.visibleCompleted = allCompleted;
    } else {
        // 赛事列表没有发生改变, 则用以前的过滤条件进行过滤赛事
        // 生成筛选后的赛事
        self.visibleUnfinished = [self filterAllArray:allUnfinished withCompetition:self.visibleCompetition];
        self.visibleCompleted = [self filterAllArray:allCompleted withCompetition:self.visibleCompetition];
    }
    
    // 关注的比赛场数
    self.attentionCount = self.attention.count;
    // 记录时间戳
    self.timeTicks = live.currentTicks;
    // 数据彩种类型
    self.dataType = DPGameLiveTypeBasketball;
}

- (BOOL)parserFootballUpdate:(NSData *)data goalSet:(NSMutableSet *)goalSet {
    BOOL upgrade = NO;
    PBMFootballLiveUpdate *update = [PBMFootballLiveUpdate parseFromData:data error:nil];
    
    NSAssert(goalSet, @"failure...");
    [goalSet removeAllObjects];
    // 比赛状态, 进球等
    for (PBMFootballLive_Match *match in update.matchesArray) {
        for (DPGameLiveMatchModel *model in self.allMatches) {
            if (match.matchId == model.matchId) {
                // 判断是否发生改变
                if (model.homeScore == match.homeScore &&
                    model.awayScore == match.awayScore &&
                    model.homeHalfScore == match.homeHalfScore &&
                    model.awayHalfScore == match.awayHalfScore &&
                    model.matchStatus == match.status &&
                    model.events.count == match.eventListArray.count) {
                    break;
                }
                // 标记需要更新
                upgrade = YES;
                
                if (match.hasStartTime) {
                    model.startTime = [NSDate dp_dateFromString:match.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
                }
                if (match.hasHalfTime) {
                    model.halfTime = [NSDate dp_dateFromString:match.halfTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
                }
                
                // 发生进球
                if (model.homeScore != match.homeScore ||
                    model.awayScore != match.awayScore) {
                    NSString *text = [NSString stringWithFormat:@"%d : %d", match.homeScore, match.awayScore];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont dp_boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor blackColor]}];
                    NSRange range = [text rangeOfString:@":"];
                    if (model.homeScore != match.homeScore) {
                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(0, range.location)];
                    }
                    if (model.awayScore != match.awayScore) {
                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(range.location + 1, text.length - range.location - 1)];
                    }
                    DPGameLiveGoalModel *goal = [[DPGameLiveGoalModel alloc] init];
                    goal.model = model;
                    goal.scoreAttributedString = attributedString;
                    [goalSet addObject:goal];
                }
                
                model.homeScore = match.homeScore;
                model.awayScore = match.awayScore;
                model.homeHalfScore = match.homeHalfScore;
                model.awayHalfScore = match.awayHalfScore;
                model.matchStatus = match.status;
                model.events = [match.eventListArray dp_mapObjectUsingBlock:^id(PBMFootballLive_Event *obj, NSUInteger idx, BOOL *stop) {
                    DPGameLiveFootballEvent *event = [[DPGameLiveFootballEvent alloc] init];
                    event.homeOrAway = obj.homeOrAway;
                    event.player = obj.player;
                    event.type = obj.event;
                    event.time = obj.time;
                    return event;
                }];
            }
        }
    }
    // 评论数
    for (PBMLiveCommentItem *item in update.commentItemsArray) {
        for (DPGameLiveMatchModel *match in self.allMatches) {
            if (match.matchId == item.matchId) {
                if (match.comment != item.commentCount) {
                    match.comment = item.commentCount;
                    upgrade = YES;
                }
                break;
            }
        }
    }
    self.timeTicks = update.currentTicks;
    return upgrade;
}

- (BOOL)parserBasketballUpdate:(NSData *)data {
    BOOL upgrade = NO;
    PBMBasketballLiveUpdate *update = [PBMBasketballLiveUpdate parseFromData:data error:nil];
    // 比赛状态, 进球等
    for (PBMBasketballLive_Match *match in update.matchesArray) {
        for (DPGameLiveMatchModel *model in self.allMatches) {
            if (match.matchId == model.matchId) {
                
                int32_t homeScore = 0;
                int32_t awayScore = 0;
                
                // 主队各节得分
                NSMutableArray *homeSectionScore = [NSMutableArray arrayWithCapacity:5];
                for (int i = 0; i < 5; i++) {
                    int32_t score = i >= match.homeScoreArray.count ? 0 : [match.homeScoreArray valueAtIndex:i];
                    homeScore += score;
                    [homeSectionScore addObject:@(score)];
                }
                // 客队各节得分
                NSMutableArray *awaySectionScore = [NSMutableArray arrayWithCapacity:5];
                for (int i = 0; i < 5; i++) {
                    int32_t score = i >= match.awayScoreArray.count ? 0 : [match.awayScoreArray valueAtIndex:i];
                    awayScore += score;
                    [awaySectionScore addObject:@(score)];
                }
                
                // 判断是否发生改变
                if (model.homeScore == homeScore &&
                    model.awayScore == awayScore &&
                    model.matchStatus == match.status) {
                    break;
                }
                // 标记需要更新
                upgrade = YES;
                
                model.homeScore = homeScore;
                model.awayScore = awayScore;
                model.matchStatus = match.status;
                model.homeSectionScore = homeSectionScore;
                model.awaySectionScore = awaySectionScore;
                model.onTime = match.onTime;
            }
        }
    }
    // 评论数
    for (PBMLiveCommentItem *item in update.commentItemsArray) {
        for (DPGameLiveMatchModel *match in self.allMatches) {
            if (match.matchId == item.matchId) {
                if (match.comment != item.commentCount) {
                    match.comment = item.commentCount;
                    upgrade = YES;
                }
                break;
            }
        }
    }
    self.timeTicks = update.currentTicks;
    return upgrade;
}

@end
