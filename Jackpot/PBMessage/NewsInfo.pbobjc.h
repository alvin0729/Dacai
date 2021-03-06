// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: news_info.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class PBMShareItem;


#pragma mark - PBMNewsInfoRoot

@interface PBMNewsInfoRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBMShareItem

typedef GPB_ENUM(PBMShareItem_FieldNumber) {
  PBMShareItem_FieldNumber_ShareTitle = 1,
  PBMShareItem_FieldNumber_ShareContent = 2,
  PBMShareItem_FieldNumber_ShareURL = 3,
};

//分享item
@interface PBMShareItem : GPBMessage

//分享标题
@property(nonatomic, readwrite) BOOL hasShareTitle;
@property(nonatomic, readwrite, copy) NSString *shareTitle;

//分享内容
@property(nonatomic, readwrite) BOOL hasShareContent;
@property(nonatomic, readwrite, copy) NSString *shareContent;

//分享URL
@property(nonatomic, readwrite) BOOL hasShareURL;
@property(nonatomic, readwrite, copy) NSString *shareURL;

@end

#pragma mark - PBMSubscribDetailItem

typedef GPB_ENUM(PBMSubscribDetailItem_FieldNumber) {
  PBMSubscribDetailItem_FieldNumber_SubscribDetailId = 1,
  PBMSubscribDetailItem_FieldNumber_SubscribDetailIcon = 2,
  PBMSubscribDetailItem_FieldNumber_SubscribDetailTitle = 3,
  PBMSubscribDetailItem_FieldNumber_SubscribDetailSubTitle = 4,
  PBMSubscribDetailItem_FieldNumber_SubscribDetailReadCount = 5,
  PBMSubscribDetailItem_FieldNumber_GameTypeId = 6,
  PBMSubscribDetailItem_FieldNumber_SubscribDetailURL = 7,
  PBMSubscribDetailItem_FieldNumber_ShareItem = 8,
};

//订阅详情item
@interface PBMSubscribDetailItem : GPBMessage

// 订阅详情ID
@property(nonatomic, readwrite) BOOL hasSubscribDetailId;
@property(nonatomic, readwrite) int32_t subscribDetailId;

// 订阅详情图标
@property(nonatomic, readwrite) BOOL hasSubscribDetailIcon;
@property(nonatomic, readwrite, copy) NSString *subscribDetailIcon;

// 订阅标题
@property(nonatomic, readwrite) BOOL hasSubscribDetailTitle;
@property(nonatomic, readwrite, copy) NSString *subscribDetailTitle;

// 订阅副标题
@property(nonatomic, readwrite) BOOL hasSubscribDetailSubTitle;
@property(nonatomic, readwrite, copy) NSString *subscribDetailSubTitle;

// 阅读数量
@property(nonatomic, readwrite) BOOL hasSubscribDetailReadCount;
@property(nonatomic, readwrite) int32_t subscribDetailReadCount;

// 详情彩种
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

// 详情地址
@property(nonatomic, readwrite) BOOL hasSubscribDetailURL;
@property(nonatomic, readwrite, copy) NSString *subscribDetailURL;

// 第三方分享item
@property(nonatomic, readwrite) BOOL hasShareItem;
@property(nonatomic, readwrite, strong) PBMShareItem *shareItem;

@end

#pragma mark - PBMSubscribItem

typedef GPB_ENUM(PBMSubscribItem_FieldNumber) {
  PBMSubscribItem_FieldNumber_SubscribeId = 1,
  PBMSubscribItem_FieldNumber_SubscribeIcon = 2,
  PBMSubscribItem_FieldNumber_SubscribeName = 3,
  PBMSubscribItem_FieldNumber_SubscribeDesc = 4,
  PBMSubscribItem_FieldNumber_IsSubscribe = 5,
  PBMSubscribItem_FieldNumber_SubscribeCount = 6,
  PBMSubscribItem_FieldNumber_SubscribTime = 7,
};

//订阅类别item
@interface PBMSubscribItem : GPBMessage

// 类别ID
@property(nonatomic, readwrite) BOOL hasSubscribeId;
@property(nonatomic, readwrite) int32_t subscribeId;

// 类别图片
@property(nonatomic, readwrite) BOOL hasSubscribeIcon;
@property(nonatomic, readwrite, copy) NSString *subscribeIcon;

// 类别名称
@property(nonatomic, readwrite) BOOL hasSubscribeName;
@property(nonatomic, readwrite, copy) NSString *subscribeName;

// 类别描述
@property(nonatomic, readwrite) BOOL hasSubscribeDesc;
@property(nonatomic, readwrite, copy) NSString *subscribeDesc;

// 类别是否订阅
@property(nonatomic, readwrite) BOOL hasIsSubscribe;
@property(nonatomic, readwrite) BOOL isSubscribe;

// 类别订阅数
@property(nonatomic, readwrite) BOOL hasSubscribeCount;
@property(nonatomic, readwrite) int32_t subscribeCount;

// 订阅时间
@property(nonatomic, readwrite) BOOL hasSubscribTime;
@property(nonatomic, readwrite, copy) NSString *subscribTime;

@end

#pragma mark - PBMNewsInfo

typedef GPB_ENUM(PBMNewsInfo_FieldNumber) {
  PBMNewsInfo_FieldNumber_InfoArray = 1,
};

// 资讯中心
@interface PBMNewsInfo : GPBMessage

// 列表
// |infoArray| contains |PBMNewsInfo_Item|
@property(nonatomic, readwrite, strong) NSMutableArray *infoArray;

@end

#pragma mark - PBMNewsInfo_Item

typedef GPB_ENUM(PBMNewsInfo_Item_FieldNumber) {
  PBMNewsInfo_Item_FieldNumber_NewsId = 1,
  PBMNewsInfo_Item_FieldNumber_Title = 2,
  PBMNewsInfo_Item_FieldNumber_Time = 3,
  PBMNewsInfo_Item_FieldNumber_URL = 4,
  PBMNewsInfo_Item_FieldNumber_GameTypeId = 5,
  PBMNewsInfo_Item_FieldNumber_ShareItem = 6,
};

//咨询item
@interface PBMNewsInfo_Item : GPBMessage

// id
@property(nonatomic, readwrite) BOOL hasNewsId;
@property(nonatomic, readwrite) int32_t newsId;

// 标题
@property(nonatomic, readwrite) BOOL hasTitle;
@property(nonatomic, readwrite, copy) NSString *title;

// 时间
@property(nonatomic, readwrite) BOOL hasTime;
@property(nonatomic, readwrite, copy) NSString *time;

// 地址
@property(nonatomic, readwrite) BOOL hasURL;
@property(nonatomic, readwrite, copy) NSString *uRL;

// 彩种
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

// 第三方分享item
@property(nonatomic, readwrite) BOOL hasShareItem;
@property(nonatomic, readwrite, strong) PBMShareItem *shareItem;

@end

#pragma mark - PBMsubscirbTypeInfo

typedef GPB_ENUM(PBMsubscirbTypeInfo_FieldNumber) {
  PBMsubscirbTypeInfo_FieldNumber_SubscribItemsArray = 1,
};

// 出参：请求咨询订阅类别列表
@interface PBMsubscirbTypeInfo : GPBMessage

//咨询订阅列表
// |subscribItemsArray| contains |PBMSubscribItem|
@property(nonatomic, readwrite, strong) NSMutableArray *subscribItemsArray;

@end

#pragma mark - PBMsubscribDetailInfo

typedef GPB_ENUM(PBMsubscribDetailInfo_FieldNumber) {
  PBMsubscribDetailInfo_FieldNumber_SubscribDetailItemsArray = 1,
};

// 出参：请求咨询订阅详情列表
@interface PBMsubscribDetailInfo : GPBMessage

//订阅详情数组
// |subscribDetailItemsArray| contains |PBMSubscribDetailItem|
@property(nonatomic, readwrite, strong) NSMutableArray *subscribDetailItemsArray;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
