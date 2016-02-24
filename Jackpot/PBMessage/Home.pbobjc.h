// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: home.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class PBMHomePage_LinkItem;
@class PBMHomePage_LotteryItem;
@class PBMHomePage_NumberQuickBet;
@class PBMHomePage_SportQuickBet;


#pragma mark - PBMHomeRoot

@interface PBMHomeRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBMHomePage

typedef GPB_ENUM(PBMHomePage_FieldNumber) {
  PBMHomePage_FieldNumber_BannersArray = 1,
  PBMHomePage_FieldNumber_Announcement = 2,
  PBMHomePage_FieldNumber_Recommend = 3,
  PBMHomePage_FieldNumber_CommunityAreaArray = 4,
  PBMHomePage_FieldNumber_LotteryDlt = 5,
  PBMHomePage_FieldNumber_LotteryJczq = 6,
  PBMHomePage_FieldNumber_LotteryJclq = 7,
  PBMHomePage_FieldNumber_QuickDlt = 8,
  PBMHomePage_FieldNumber_QuickJczq = 9,
  PBMHomePage_FieldNumber_QuickJclq = 10,
  PBMHomePage_FieldNumber_ShowQuickFirst = 11,
  PBMHomePage_FieldNumber_ShowJczqFirst = 12,
};

@interface PBMHomePage : GPBMessage

// 轮播图
// |bannersArray| contains |PBMHomePage_BannerItem|
@property(nonatomic, readwrite, strong) NSMutableArray *bannersArray;

// 公告区
@property(nonatomic, readwrite) BOOL hasAnnouncement;
@property(nonatomic, readwrite, strong) PBMHomePage_LinkItem *announcement;

// 推荐标题
@property(nonatomic, readwrite) BOOL hasRecommend;
@property(nonatomic, readwrite, strong) PBMHomePage_LinkItem *recommend;

// 微社区
// |communityAreaArray| contains |PBMHomePage_LinkItem|
@property(nonatomic, readwrite, strong) NSMutableArray *communityAreaArray;

// 普通投注
@property(nonatomic, readwrite) BOOL hasLotteryDlt;
@property(nonatomic, readwrite, strong) PBMHomePage_LotteryItem *lotteryDlt;

// 竞彩足球
@property(nonatomic, readwrite) BOOL hasLotteryJczq;
@property(nonatomic, readwrite, strong) PBMHomePage_LotteryItem *lotteryJczq;

// 竞彩篮球
@property(nonatomic, readwrite) BOOL hasLotteryJclq;
@property(nonatomic, readwrite, strong) PBMHomePage_LotteryItem *lotteryJclq;

// 快速投注
@property(nonatomic, readwrite) BOOL hasQuickDlt;
@property(nonatomic, readwrite, strong) PBMHomePage_NumberQuickBet *quickDlt;

// 竞彩足球
@property(nonatomic, readwrite) BOOL hasQuickJczq;
@property(nonatomic, readwrite, strong) PBMHomePage_SportQuickBet *quickJczq;

// 竞彩篮球
@property(nonatomic, readwrite) BOOL hasQuickJclq;
@property(nonatomic, readwrite, strong) PBMHomePage_SportQuickBet *quickJclq;

// 优先显示快速投注
@property(nonatomic, readwrite) BOOL hasShowQuickFirst;
@property(nonatomic, readwrite) BOOL showQuickFirst;

// 显示快速投注时, 优先显示竞彩足球
@property(nonatomic, readwrite) BOOL hasShowJczqFirst;
@property(nonatomic, readwrite) BOOL showJczqFirst;

@end

#pragma mark - PBMHomePage_BannerItem

typedef GPB_ENUM(PBMHomePage_BannerItem_FieldNumber) {
  PBMHomePage_BannerItem_FieldNumber_ImageURL = 1,
  PBMHomePage_BannerItem_FieldNumber_Event = 2,
};

// 轮播图对象
@interface PBMHomePage_BannerItem : GPBMessage

// 图片地址
@property(nonatomic, readwrite) BOOL hasImageURL;
@property(nonatomic, readwrite, copy) NSString *imageURL;

// 事件
@property(nonatomic, readwrite) BOOL hasEvent;
@property(nonatomic, readwrite, copy) NSString *event;

@end

#pragma mark - PBMHomePage_LinkItem

typedef GPB_ENUM(PBMHomePage_LinkItem_FieldNumber) {
  PBMHomePage_LinkItem_FieldNumber_Title = 1,
  PBMHomePage_LinkItem_FieldNumber_Event = 2,
  PBMHomePage_LinkItem_FieldNumber_Image = 3,
};

// 点击事件
@interface PBMHomePage_LinkItem : GPBMessage

// 标题
@property(nonatomic, readwrite) BOOL hasTitle;
@property(nonatomic, readwrite, copy) NSString *title;

// 事件url
@property(nonatomic, readwrite) BOOL hasEvent;
@property(nonatomic, readwrite, copy) NSString *event;

// 图片地址
@property(nonatomic, readwrite) BOOL hasImage;
@property(nonatomic, readwrite, copy) NSString *image;

@end

#pragma mark - PBMHomePage_LotteryItem

typedef GPB_ENUM(PBMHomePage_LotteryItem_FieldNumber) {
  PBMHomePage_LotteryItem_FieldNumber_Title = 1,
  PBMHomePage_LotteryItem_FieldNumber_Desc = 2,
  PBMHomePage_LotteryItem_FieldNumber_Count = 3,
  PBMHomePage_LotteryItem_FieldNumber_Mark = 4,
  PBMHomePage_LotteryItem_FieldNumber_Enable = 5,
};

// 投注玩法
@interface PBMHomePage_LotteryItem : GPBMessage

// 彩种宣传文字
@property(nonatomic, readwrite) BOOL hasTitle;
@property(nonatomic, readwrite, copy) NSString *title;

// 奖池, 焦点
@property(nonatomic, readwrite) BOOL hasDesc;
@property(nonatomic, readwrite, copy) NSString *desc;

// 参与数
@property(nonatomic, readwrite) BOOL hasCount;
@property(nonatomic, readwrite) int32_t count;

// 角标
@property(nonatomic, readwrite) BOOL hasMark;
@property(nonatomic, readwrite, copy) NSString *mark;

// 是否停售
@property(nonatomic, readwrite) BOOL hasEnable;
@property(nonatomic, readwrite) BOOL enable;

@end

#pragma mark - PBMHomePage_NumberQuickBet

typedef GPB_ENUM(PBMHomePage_NumberQuickBet_FieldNumber) {
  PBMHomePage_NumberQuickBet_FieldNumber_GameId = 1,
  PBMHomePage_NumberQuickBet_FieldNumber_GameName = 2,
  PBMHomePage_NumberQuickBet_FieldNumber_EndTime = 3,
};

// 数字彩快速投注
@interface PBMHomePage_NumberQuickBet : GPBMessage

// id
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int64_t gameId;

// 期号
@property(nonatomic, readwrite) BOOL hasGameName;
@property(nonatomic, readwrite, copy) NSString *gameName;

// 截至时间
@property(nonatomic, readwrite) BOOL hasEndTime;
@property(nonatomic, readwrite, copy) NSString *endTime;

@end

#pragma mark - PBMHomePage_SportQuickBet

typedef GPB_ENUM(PBMHomePage_SportQuickBet_FieldNumber) {
  PBMHomePage_SportQuickBet_FieldNumber_GameId = 1,
  PBMHomePage_SportQuickBet_FieldNumber_GameName = 2,
  PBMHomePage_SportQuickBet_FieldNumber_GameMatchId = 3,
  PBMHomePage_SportQuickBet_FieldNumber_GameType = 4,
  PBMHomePage_SportQuickBet_FieldNumber_Title = 5,
  PBMHomePage_SportQuickBet_FieldNumber_HomeName = 6,
  PBMHomePage_SportQuickBet_FieldNumber_AwayName = 7,
  PBMHomePage_SportQuickBet_FieldNumber_EndTime = 8,
  PBMHomePage_SportQuickBet_FieldNumber_SpListArray = 9,
  PBMHomePage_SportQuickBet_FieldNumber_RateListArray = 10,
  PBMHomePage_SportQuickBet_FieldNumber_Balance = 11,
  PBMHomePage_SportQuickBet_FieldNumber_OrderNumberName = 12,
};

// 竞技彩快速投注
@interface PBMHomePage_SportQuickBet : GPBMessage

// 期号id
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int64_t gameId;

// 期号
@property(nonatomic, readwrite) BOOL hasGameName;
@property(nonatomic, readwrite, copy) NSString *gameName;

// 比赛id
@property(nonatomic, readwrite) BOOL hasGameMatchId;
@property(nonatomic, readwrite) int64_t gameMatchId;

// 彩种
@property(nonatomic, readwrite) BOOL hasGameType;
@property(nonatomic, readwrite) int32_t gameType;

// 标题
@property(nonatomic, readwrite) BOOL hasTitle;
@property(nonatomic, readwrite, copy) NSString *title;

// 主队名
@property(nonatomic, readwrite) BOOL hasHomeName;
@property(nonatomic, readwrite, copy) NSString *homeName;

// 客队名
@property(nonatomic, readwrite) BOOL hasAwayName;
@property(nonatomic, readwrite, copy) NSString *awayName;

// 截至时间
@property(nonatomic, readwrite) BOOL hasEndTime;
@property(nonatomic, readwrite, copy) NSString *endTime;

// sp值
// |spListArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *spListArray;

// 投注比例
// |rateListArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *rateListArray;

// 平衡因子 - 让球数, 让分, 总分
@property(nonatomic, readwrite) BOOL hasBalance;
@property(nonatomic, readwrite, copy) NSString *balance;

// 比赛序号
@property(nonatomic, readwrite) BOOL hasOrderNumberName;
@property(nonatomic, readwrite, copy) NSString *orderNumberName;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)