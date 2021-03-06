// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: growthsystem.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class PBMGrowthHome_UserInfo;
@class PBMGrowthRanking_RankItem;

#pragma mark - Enum PBMGrowthTaskItem_TaskType

typedef GPB_ENUM(PBMGrowthTaskItem_TaskType) {
  // 普通任务
  PBMGrowthTaskItem_TaskType_Normal = 0,

  // 等级任务
  PBMGrowthTaskItem_TaskType_Level = 1,

  // 混合任务
  PBMGrowthTaskItem_TaskType_Merge = 2,
};

GPBEnumDescriptor *PBMGrowthTaskItem_TaskType_EnumDescriptor(void);

BOOL PBMGrowthTaskItem_TaskType_IsValidValue(int32_t value);

#pragma mark - Enum PBMGrowthTaskItem_TaskState

typedef GPB_ENUM(PBMGrowthTaskItem_TaskState) {
  // 进行中
  PBMGrowthTaskItem_TaskState_Underway = 1,

  // 可领取
  PBMGrowthTaskItem_TaskState_Handled = 2,

  // 已完成
  PBMGrowthTaskItem_TaskState_Finished = 3,
};

GPBEnumDescriptor *PBMGrowthTaskItem_TaskState_EnumDescriptor(void);

BOOL PBMGrowthTaskItem_TaskState_IsValidValue(int32_t value);

#pragma mark - Enum PBMGrowthRanking_Trend

typedef GPB_ENUM(PBMGrowthRanking_Trend) {
  // 持平
  PBMGrowthRanking_Trend_Fair = 0,

  // 升
  PBMGrowthRanking_Trend_Rise = 1,

  // 降
  PBMGrowthRanking_Trend_Drop = -1,
};

GPBEnumDescriptor *PBMGrowthRanking_Trend_EnumDescriptor(void);

BOOL PBMGrowthRanking_Trend_IsValidValue(int32_t value);


#pragma mark - PBMGrowthsystemRoot

@interface PBMGrowthsystemRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBMGrowthTaskItem

typedef GPB_ENUM(PBMGrowthTaskItem_FieldNumber) {
  PBMGrowthTaskItem_FieldNumber_Type = 1,
  PBMGrowthTaskItem_FieldNumber_State = 2,
  PBMGrowthTaskItem_FieldNumber_TaskId = 3,
  PBMGrowthTaskItem_FieldNumber_TaskName = 4,
  PBMGrowthTaskItem_FieldNumber_TaskIcon = 5,
  PBMGrowthTaskItem_FieldNumber_TaskStep = 6,
  PBMGrowthTaskItem_FieldNumber_TaskGrowup = 7,
  PBMGrowthTaskItem_FieldNumber_TaskCredit = 8,
  PBMGrowthTaskItem_FieldNumber_TaskEvent = 9,
  PBMGrowthTaskItem_FieldNumber_TaskLevel = 10,
  PBMGrowthTaskItem_FieldNumber_SubitemListArray = 11,
};

// 单个任务结构
@interface PBMGrowthTaskItem : GPBMessage

// 任务类型
@property(nonatomic, readwrite) BOOL hasType;
@property(nonatomic, readwrite) PBMGrowthTaskItem_TaskType type;

// 任务状态
@property(nonatomic, readwrite) BOOL hasState;
@property(nonatomic, readwrite) PBMGrowthTaskItem_TaskState state;

// 任务id
@property(nonatomic, readwrite) BOOL hasTaskId;
@property(nonatomic, readwrite) int64_t taskId;

// 任务名
@property(nonatomic, readwrite) BOOL hasTaskName;
@property(nonatomic, readwrite, copy) NSString *taskName;

// 任务图标
@property(nonatomic, readwrite) BOOL hasTaskIcon;
@property(nonatomic, readwrite, copy) NSString *taskIcon;

// 任务进度
@property(nonatomic, readwrite) BOOL hasTaskStep;
@property(nonatomic, readwrite, copy) NSString *taskStep;

// 成长值奖励
@property(nonatomic, readwrite) BOOL hasTaskGrowup;
@property(nonatomic, readwrite, copy) NSString *taskGrowup;

// 积分奖励
@property(nonatomic, readwrite) BOOL hasTaskCredit;
@property(nonatomic, readwrite, copy) NSString *taskCredit;

// 任务跳转路径
@property(nonatomic, readwrite) BOOL hasTaskEvent;
@property(nonatomic, readwrite, copy) NSString *taskEvent;

// 任务等级, 仅当等级任务有效
@property(nonatomic, readwrite) BOOL hasTaskLevel;
@property(nonatomic, readwrite, copy) NSString *taskLevel;

// 子任务, 仅当达人任务有效
// |subitemListArray| contains |PBMGrowthTaskItem_SubItem|
@property(nonatomic, readwrite, strong) NSMutableArray *subitemListArray;

@end

#pragma mark - PBMGrowthTaskItem_SubItem

typedef GPB_ENUM(PBMGrowthTaskItem_SubItem_FieldNumber) {
  PBMGrowthTaskItem_SubItem_FieldNumber_GameTitle = 1,
  PBMGrowthTaskItem_SubItem_FieldNumber_GameState = 2,
};

@interface PBMGrowthTaskItem_SubItem : GPBMessage

// 玩法名 
@property(nonatomic, readwrite) BOOL hasGameTitle;
@property(nonatomic, readwrite, copy) NSString *gameTitle;

// 完成状态
@property(nonatomic, readwrite) BOOL hasGameState;
@property(nonatomic, readwrite) BOOL gameState;

@end

#pragma mark - PBMGrowthHome

typedef GPB_ENUM(PBMGrowthHome_FieldNumber) {
  PBMGrowthHome_FieldNumber_UserInfo = 1,
  PBMGrowthHome_FieldNumber_RookieArray = 2,
  PBMGrowthHome_FieldNumber_DailyArray = 3,
  PBMGrowthHome_FieldNumber_AchievementArray = 4,
  PBMGrowthHome_FieldNumber_TagIndex = 5,
};

// 成长体系, 首页接口
@interface PBMGrowthHome : GPBMessage

// 用户信息
@property(nonatomic, readwrite) BOOL hasUserInfo;
@property(nonatomic, readwrite, strong) PBMGrowthHome_UserInfo *userInfo;

// 新手任务
// |rookieArray| contains |PBMGrowthTaskItem|
@property(nonatomic, readwrite, strong) NSMutableArray *rookieArray;

// 每日任务
// |dailyArray| contains |PBMGrowthTaskItem|
@property(nonatomic, readwrite, strong) NSMutableArray *dailyArray;

// 成就任务 
// |achievementArray| contains |PBMGrowthTaskItem|
@property(nonatomic, readwrite, strong) NSMutableArray *achievementArray;

// 定位到哪一个tag
@property(nonatomic, readwrite) BOOL hasTagIndex;
@property(nonatomic, readwrite) int32_t tagIndex;

@end

#pragma mark - PBMGrowthHome_UserInfo

typedef GPB_ENUM(PBMGrowthHome_UserInfo_FieldNumber) {
  PBMGrowthHome_UserInfo_FieldNumber_IconURL = 1,
  PBMGrowthHome_UserInfo_FieldNumber_Level = 2,
  PBMGrowthHome_UserInfo_FieldNumber_Credit = 3,
  PBMGrowthHome_UserInfo_FieldNumber_Growup = 4,
  PBMGrowthHome_UserInfo_FieldNumber_CheckIn = 5,
  PBMGrowthHome_UserInfo_FieldNumber_CheckInCount = 6,
  PBMGrowthHome_UserInfo_FieldNumber_CheckContinuesCount = 7,
  PBMGrowthHome_UserInfo_FieldNumber_UserLoginTime = 8,
};

@interface PBMGrowthHome_UserInfo : GPBMessage

// 头像
@property(nonatomic, readwrite) BOOL hasIconURL;
@property(nonatomic, readwrite, copy) NSString *iconURL;

// 等级
@property(nonatomic, readwrite) BOOL hasLevel;
@property(nonatomic, readwrite) int32_t level;

// 积分
@property(nonatomic, readwrite) BOOL hasCredit;
@property(nonatomic, readwrite) int32_t credit;

// 成长值
@property(nonatomic, readwrite) BOOL hasGrowup;
@property(nonatomic, readwrite) int32_t growup;

// 是否签到
@property(nonatomic, readwrite) BOOL hasCheckIn;
@property(nonatomic, readwrite) BOOL checkIn;

// 累计签到次数
@property(nonatomic, readwrite) BOOL hasCheckInCount;
@property(nonatomic, readwrite) int32_t checkInCount;

// 连续签到次数
@property(nonatomic, readwrite) BOOL hasCheckContinuesCount;
@property(nonatomic, readwrite) int32_t checkContinuesCount;

//用户注册时间
@property(nonatomic, readwrite) BOOL hasUserLoginTime;
@property(nonatomic, readwrite, copy) NSString *userLoginTime;

@end

#pragma mark - PBMGrowthCheckIn

typedef GPB_ENUM(PBMGrowthCheckIn_FieldNumber) {
  PBMGrowthCheckIn_FieldNumber_CheckIn = 1,
  PBMGrowthCheckIn_FieldNumber_AddupDays = 2,
  PBMGrowthCheckIn_FieldNumber_RunningDays = 3,
};

// 签到接口
@interface PBMGrowthCheckIn : GPBMessage

// 是否签到成功
@property(nonatomic, readwrite) BOOL hasCheckIn;
@property(nonatomic, readwrite) BOOL checkIn;

// 累计签到天数
@property(nonatomic, readwrite) BOOL hasAddupDays;
@property(nonatomic, readwrite) int32_t addupDays;

// 连续签到天数
@property(nonatomic, readwrite) BOOL hasRunningDays;
@property(nonatomic, readwrite) int32_t runningDays;

@end

#pragma mark - PBMGrowthDrawTask

typedef GPB_ENUM(PBMGrowthDrawTask_FieldNumber) {
  PBMGrowthDrawTask_FieldNumber_Success = 1,
  PBMGrowthDrawTask_FieldNumber_Credit = 2,
  PBMGrowthDrawTask_FieldNumber_Growup = 3,
  PBMGrowthDrawTask_FieldNumber_UpgradeLevel = 4,
  PBMGrowthDrawTask_FieldNumber_NewLevel = 5,
  PBMGrowthDrawTask_FieldNumber_PrivilegeArray = 6,
};

// 领取任务/排行奖励接口
@interface PBMGrowthDrawTask : GPBMessage

// 是否领取成功
@property(nonatomic, readwrite) BOOL hasSuccess;
@property(nonatomic, readwrite) BOOL success;

// 积分
@property(nonatomic, readwrite) BOOL hasCredit;
@property(nonatomic, readwrite) int32_t credit;

// 成长值
@property(nonatomic, readwrite) BOOL hasGrowup;
@property(nonatomic, readwrite) int32_t growup;

// 用户是否升级
@property(nonatomic, readwrite) BOOL hasUpgradeLevel;
@property(nonatomic, readwrite) BOOL upgradeLevel;

// 升级后等级
@property(nonatomic, readwrite) BOOL hasNewLevel;
@property(nonatomic, readwrite) int32_t newLevel;

// 升级后特权
// |privilegeArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *privilegeArray;

@end

#pragma mark - PBMRankingAward

typedef GPB_ENUM(PBMRankingAward_FieldNumber) {
  PBMRankingAward_FieldNumber_AwardListArray = 1,
  PBMRankingAward_FieldNumber_AwardType = 2,
};

//排行奖励
@interface PBMRankingAward : GPBMessage

//排行奖励数组
// |awardListArray| contains |PBMRankingAward_RankingAwardItem|
@property(nonatomic, readwrite, strong) NSMutableArray *awardListArray;

//排行奖励类型              
@property(nonatomic, readwrite) BOOL hasAwardType;
@property(nonatomic, readwrite) int32_t awardType;

@end

#pragma mark - PBMRankingAward_RankingAwardItem

typedef GPB_ENUM(PBMRankingAward_RankingAwardItem_FieldNumber) {
  PBMRankingAward_RankingAwardItem_FieldNumber_AwardDate = 1,
  PBMRankingAward_RankingAwardItem_FieldNumber_Ranking = 2,
  PBMRankingAward_RankingAwardItem_FieldNumber_AwardGet = 3,
};

@interface PBMRankingAward_RankingAwardItem : GPBMessage

//奖励日期
@property(nonatomic, readwrite) BOOL hasAwardDate;
@property(nonatomic, readwrite, copy) NSString *awardDate;

//排名
@property(nonatomic, readwrite) BOOL hasRanking;
@property(nonatomic, readwrite) int32_t ranking;

//奖励是否已领取
@property(nonatomic, readwrite) BOOL hasAwardGet;
@property(nonatomic, readwrite) BOOL awardGet;

@end

#pragma mark - PBMRankingAwardParam

typedef GPB_ENUM(PBMRankingAwardParam_FieldNumber) {
  PBMRankingAwardParam_FieldNumber_AwardType = 1,
  PBMRankingAwardParam_FieldNumber_AwardDate = 2,
};

//领取排行奖励入参
@interface PBMRankingAwardParam : GPBMessage

//排行奖励类型:0为每日，1为每周
@property(nonatomic, readwrite) BOOL hasAwardType;
@property(nonatomic, readwrite) int32_t awardType;

//奖励日期
@property(nonatomic, readwrite) BOOL hasAwardDate;
@property(nonatomic, readwrite, copy) NSString *awardDate;

@end

#pragma mark - PBMGrowthRanking

typedef GPB_ENUM(PBMGrowthRanking_FieldNumber) {
  PBMGrowthRanking_FieldNumber_Growup = 1,
  PBMGrowthRanking_FieldNumber_GrowupDailyTitle = 2,
  PBMGrowthRanking_FieldNumber_GrowupTotalTitle = 3,
  PBMGrowthRanking_FieldNumber_TotalRankArray = 4,
  PBMGrowthRanking_FieldNumber_DailyRankArray = 5,
  PBMGrowthRanking_FieldNumber_UserTotal = 6,
  PBMGrowthRanking_FieldNumber_UserDaily = 7,
  PBMGrowthRanking_FieldNumber_DailyGrowup = 8,
};

// 成长体系, 排行榜接口
@interface PBMGrowthRanking : GPBMessage

// 成长值
@property(nonatomic, readwrite) BOOL hasGrowup;
@property(nonatomic, readwrite) int32_t growup;

// 每日成长值
@property(nonatomic, readwrite) BOOL hasDailyGrowup;
@property(nonatomic, readwrite) int32_t dailyGrowup;

// 每日排行榜描述语, 宣传内容
@property(nonatomic, readwrite) BOOL hasGrowupDailyTitle;
@property(nonatomic, readwrite, copy) NSString *growupDailyTitle;

// 总排行榜描述语, 宣传内容
@property(nonatomic, readwrite) BOOL hasGrowupTotalTitle;
@property(nonatomic, readwrite, copy) NSString *growupTotalTitle;

// 总排行榜
// |totalRankArray| contains |PBMGrowthRanking_RankItem|
@property(nonatomic, readwrite, strong) NSMutableArray *totalRankArray;

// 每日排行榜
// |dailyRankArray| contains |PBMGrowthRanking_RankItem|
@property(nonatomic, readwrite, strong) NSMutableArray *dailyRankArray;

// 用户在总排行榜中的信息
@property(nonatomic, readwrite) BOOL hasUserTotal;
@property(nonatomic, readwrite, strong) PBMGrowthRanking_RankItem *userTotal;

// 用户在每日排行榜中的信息
@property(nonatomic, readwrite) BOOL hasUserDaily;
@property(nonatomic, readwrite, strong) PBMGrowthRanking_RankItem *userDaily;

@end

#pragma mark - PBMGrowthRanking_RankItem

typedef GPB_ENUM(PBMGrowthRanking_RankItem_FieldNumber) {
  PBMGrowthRanking_RankItem_FieldNumber_UserName = 1,
  PBMGrowthRanking_RankItem_FieldNumber_Credit = 2,
  PBMGrowthRanking_RankItem_FieldNumber_Trend = 3,
  PBMGrowthRanking_RankItem_FieldNumber_Rank = 4,
  PBMGrowthRanking_RankItem_FieldNumber_Award = 5,
};

@interface PBMGrowthRanking_RankItem : GPBMessage

// 用户名
@property(nonatomic, readwrite) BOOL hasUserName;
@property(nonatomic, readwrite, copy) NSString *userName;

// 成长值
@property(nonatomic, readwrite) BOOL hasCredit;
@property(nonatomic, readwrite) int32_t credit;

// 走势
@property(nonatomic, readwrite) BOOL hasTrend;
@property(nonatomic, readwrite) PBMGrowthRanking_Trend trend;

// 排名
@property(nonatomic, readwrite) BOOL hasRank;
@property(nonatomic, readwrite) int32_t rank;

// 是否领取奖励, 仅对当前用户有效
@property(nonatomic, readwrite) BOOL hasAward;
@property(nonatomic, readwrite) BOOL award;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
