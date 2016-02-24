//
//  DPGameLiveModels.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPGameLiveEnum.h"

extern NSString *kDPGameLiveScoreChangeNotifyKey;
extern NSString *kDPGameLiveScoreGoalSetKey;

@interface DPGameLiveMatchModel : NSObject
/**
 *  主队名称, e.g. @"巴萨"
 */
@property (nonatomic, copy) NSString *homeName;
/**
 *  客队名称, e.g. @"皇马"
 */
@property (nonatomic, copy) NSString *awayName;
/**
 *  主队排名, e.g. @"[13]"
 */
@property (nonatomic, copy) NSString *homeRank;
/**
 *  客队排名, e.g. @"[A4]"
 */
@property (nonatomic, copy) NSString *awayRank;
/**
 *  赛事描述, 包括序号、赛事、时间, e.g. @"周四001 挪威杯 08-13 23:59"
 */
@property (nonatomic, copy) NSString *matchTitle;
/**
 *  主队得分
 */
@property (nonatomic, assign) int32_t homeScore;
/**
 *  客队得分
 */
@property (nonatomic, assign) int32_t awayScore;
/**
 *  主队半场得分
 */
@property (nonatomic, assign) int32_t homeHalfScore;
/**
 *  客队半场得分
 */
@property (nonatomic, assign) int32_t awayHalfScore;
/**
 *  主队图片
 */
@property (nonatomic, strong) UIImage *homeLogo;
/**
 *  客队图片
 */
@property (nonatomic, strong) UIImage *awayLogo;
/**
 *  赛事状态
 */
@property (nonatomic, assign) NSInteger matchStatus;
/**
 *  赛事名
 */
@property (nonatomic, copy) NSString *competition;
/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL unfold;
/**
 *  是否关注
 */
@property (nonatomic, assign) BOOL attention;
/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comment;

/**
 *  篮球, 进行时间(秒)
 */
@property (nonatomic, strong) NSString *onTime;

@property (nonatomic, strong) NSArray *homeSectionScore;
@property (nonatomic, strong) NSArray *awaySectionScore;

/**
 *  足球, 事件列表
 */
@property (nonatomic, strong) NSArray *events;
// ===================================
@property (nonatomic, strong) NSString *homeLogoURL;
@property (nonatomic, strong) NSString *awayLogoURL;
@property (nonatomic, assign) NSInteger matchId;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *halfTime;

@end

@interface DPGameLiveDailyModel : NSObject
@property (nonatomic, copy) NSString *gameTime;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, assign) BOOL unfold;
@end

@interface DPGameLiveFootballEvent : NSObject
@property (nonatomic, readwrite) BOOL homeOrAway;           // 主队事件 true, 客队事件 false
@property (nonatomic, readwrite, copy) NSString *player;    // 球员名
@property (nonatomic, readwrite) int32_t time;              // 发生时间
@property (nonatomic, readwrite) NSInteger type;            // 事件类型 DPGameLiveFootballEventType
@end

@interface DPGameLiveGoalModel : NSObject
@property (nonatomic, strong) DPGameLiveMatchModel *model;
@property (nonatomic, strong) NSAttributedString *scoreAttributedString;
@end