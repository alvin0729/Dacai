// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: order.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN


#pragma mark - PBMOrderRoot

@interface PBMOrderRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - PBMPlaceAnOrder

typedef GPB_ENUM(PBMPlaceAnOrder_FieldNumber) {
  PBMPlaceAnOrder_FieldNumber_BetDescription = 1,
  PBMPlaceAnOrder_FieldNumber_BetOrderNumbers = 2,
  PBMPlaceAnOrder_FieldNumber_BetType = 3,
  PBMPlaceAnOrder_FieldNumber_ChannelType = 4,
  PBMPlaceAnOrder_FieldNumber_DeviceNum = 5,
  PBMPlaceAnOrder_FieldNumber_GameId = 6,
  PBMPlaceAnOrder_FieldNumber_GameTypeId = 7,
  PBMPlaceAnOrder_FieldNumber_Multiple = 8,
  PBMPlaceAnOrder_FieldNumber_PlatformType = 9,
  PBMPlaceAnOrder_FieldNumber_Quantity = 10,
  PBMPlaceAnOrder_FieldNumber_TotalAmount = 11,
  PBMPlaceAnOrder_FieldNumber_BetTypeDesc = 12,
  PBMPlaceAnOrder_FieldNumber_ProjectBuyType = 13,
  PBMPlaceAnOrder_FieldNumber_PassTypeDesc = 14,
};

// 下单请求接口（普通投注）
@interface PBMPlaceAnOrder : GPBMessage

// 投注内容
@property(nonatomic, readwrite) BOOL hasBetDescription;
@property(nonatomic, readwrite, copy) NSString *betDescription;

// 竞彩序号
@property(nonatomic, readwrite) BOOL hasBetOrderNumbers;
@property(nonatomic, readwrite, copy) NSString *betOrderNumbers;

// 投注类别（1:单式  2:复式 4:带胆复式 ）
@property(nonatomic, readwrite) BOOL hasBetType;
@property(nonatomic, readwrite) int32_t betType;

// 渠道id
@property(nonatomic, readwrite) BOOL hasChannelType;
@property(nonatomic, readwrite) int32_t channelType;

// 设备号
@property(nonatomic, readwrite) BOOL hasDeviceNum;
@property(nonatomic, readwrite, copy) NSString *deviceNum;

// 期号
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int32_t gameId;

// 彩种类型
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

// 倍数
@property(nonatomic, readwrite) BOOL hasMultiple;
@property(nonatomic, readwrite) int64_t multiple;

// 操作平台
@property(nonatomic, readwrite) BOOL hasPlatformType;
@property(nonatomic, readwrite) int32_t platformType;

// 注数
@property(nonatomic, readwrite) BOOL hasQuantity;
@property(nonatomic, readwrite) int64_t quantity;

// 方案总额
@property(nonatomic, readwrite) BOOL hasTotalAmount;
@property(nonatomic, readwrite) int32_t totalAmount;

// 投注类别描述, 竞彩:复式 数字彩:单式、复式、单式,复式
@property(nonatomic, readwrite) BOOL hasBetTypeDesc;
@property(nonatomic, readwrite, copy) NSString *betTypeDesc;

// 购买类型 (1:购买 2:合买 3:保存 4:追号)
@property(nonatomic, readwrite) BOOL hasProjectBuyType;
@property(nonatomic, readwrite) int32_t projectBuyType;

// 过关方式描述, 例: 3串1,4串1
@property(nonatomic, readwrite) BOOL hasPassTypeDesc;
@property(nonatomic, readwrite, copy) NSString *passTypeDesc;

@end

#pragma mark - PBMChaseToPlaceAnOrder

typedef GPB_ENUM(PBMChaseToPlaceAnOrder_FieldNumber) {
  PBMChaseToPlaceAnOrder_FieldNumber_Disseminate = 1,
  PBMChaseToPlaceAnOrder_FieldNumber_FollowContent = 2,
  PBMChaseToPlaceAnOrder_FieldNumber_FollowStopCondition = 3,
  PBMChaseToPlaceAnOrder_FieldNumber_FollowStopTypeId = 4,
  PBMChaseToPlaceAnOrder_FieldNumber_FollowTypeId = 5,
  PBMChaseToPlaceAnOrder_FieldNumber_GameId = 6,
  PBMChaseToPlaceAnOrder_FieldNumber_GameTypeId = 7,
  PBMChaseToPlaceAnOrder_FieldNumber_TotalAmount = 8,
  PBMChaseToPlaceAnOrder_FieldNumber_TotalCount = 9,
  PBMChaseToPlaceAnOrder_FieldNumber_GameName = 10,
};

// 下单请求接口（追号投注）
@interface PBMChaseToPlaceAnOrder : GPBMessage

// 宣传
@property(nonatomic, readwrite) BOOL hasDisseminate;
@property(nonatomic, readwrite, copy) NSString *disseminate;

// 追号内容
@property(nonatomic, readwrite) BOOL hasFollowContent;
@property(nonatomic, readwrite, copy) NSString *followContent;

// 追号停止条件（1:中奖后停止追号  2:全部追号完成后停止 3: 累计中出多少元停止 4:追号开始前号码开出则停止)
@property(nonatomic, readwrite) BOOL hasFollowStopCondition;
@property(nonatomic, readwrite, copy) NSString *followStopCondition;

// 追号停止类型
@property(nonatomic, readwrite) BOOL hasFollowStopTypeId;
@property(nonatomic, readwrite) int32_t followStopTypeId;

// 追号类型 (1: 每期随机追号内容  2:从专家库中随机抽取 3: 追号内容随机每期固定 4:用户自己设定的固定内容）
@property(nonatomic, readwrite) BOOL hasFollowTypeId;
@property(nonatomic, readwrite) int32_t followTypeId;

// 期号
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int64_t gameId;

// 彩种类型
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

// 追号总金额
@property(nonatomic, readwrite) BOOL hasTotalAmount;
@property(nonatomic, readwrite) int64_t totalAmount;

// 追号期数1~n
@property(nonatomic, readwrite) BOOL hasTotalCount;
@property(nonatomic, readwrite) int64_t totalCount;

// 期号
@property(nonatomic, readwrite) BOOL hasGameName;
@property(nonatomic, readwrite, copy) NSString *gameName;

@end

#pragma mark - PBMCreateOrderResult

typedef GPB_ENUM(PBMCreateOrderResult_FieldNumber) {
  PBMCreateOrderResult_FieldNumber_OrderId = 1,
  PBMCreateOrderResult_FieldNumber_AccountAmt = 2,
  PBMCreateOrderResult_FieldNumber_RedPacketArray = 3,
};

//生成订单接口返回
@interface PBMCreateOrderResult : GPBMessage

//订单id
@property(nonatomic, readwrite) BOOL hasOrderId;
@property(nonatomic, readwrite) int64_t orderId;

//账户余额
@property(nonatomic, readwrite) BOOL hasAccountAmt;
@property(nonatomic, readwrite, copy) NSString *accountAmt;

//红包数组
// |redPacketArray| contains |PBMCreateOrderResult_RedPacket|
@property(nonatomic, readwrite, strong) NSMutableArray *redPacketArray;

@end

#pragma mark - PBMCreateOrderResult_RedPacket

typedef GPB_ENUM(PBMCreateOrderResult_RedPacket_FieldNumber) {
  PBMCreateOrderResult_RedPacket_FieldNumber_Id_p = 1,
  PBMCreateOrderResult_RedPacket_FieldNumber_Name = 2,
  PBMCreateOrderResult_RedPacket_FieldNumber_UseDesc = 3,
  PBMCreateOrderResult_RedPacket_FieldNumber_EndDate = 4,
  PBMCreateOrderResult_RedPacket_FieldNumber_OrigAmt = 5,
  PBMCreateOrderResult_RedPacket_FieldNumber_CurAmt = 6,
};

//红包
@interface PBMCreateOrderResult_RedPacket : GPBMessage

//红包id
@property(nonatomic, readwrite) BOOL hasId_p;
@property(nonatomic, readwrite) int64_t id_p;

//红包名称
@property(nonatomic, readwrite) BOOL hasName;
@property(nonatomic, readwrite, copy) NSString *name;

//适用范围描述
@property(nonatomic, readwrite) BOOL hasUseDesc;
@property(nonatomic, readwrite, copy) NSString *useDesc;

//红包到期时间
@property(nonatomic, readwrite) BOOL hasEndDate;
@property(nonatomic, readwrite, copy) NSString *endDate;

//红包原始金额
@property(nonatomic, readwrite) BOOL hasOrigAmt;
@property(nonatomic, readwrite) int32_t origAmt;

//红包当前金额
@property(nonatomic, readwrite) BOOL hasCurAmt;
@property(nonatomic, readwrite) int32_t curAmt;

@end

#pragma mark - PBMPayParams

typedef GPB_ENUM(PBMPayParams_FieldNumber) {
  PBMPayParams_FieldNumber_SourceId = 1,
  PBMPayParams_FieldNumber_PayPassword = 2,
  PBMPayParams_FieldNumber_Amt = 3,
  PBMPayParams_FieldNumber_SourceType = 4,
  PBMPayParams_FieldNumber_NightPay = 5,
};

// 获取三方支付参数接口 请求
@interface PBMPayParams : GPBMessage

// 订单id
@property(nonatomic, readwrite) BOOL hasSourceId;
@property(nonatomic, readwrite) int64_t sourceId;

// 支付密码
@property(nonatomic, readwrite) BOOL hasPayPassword;
@property(nonatomic, readwrite, copy) NSString *payPassword;

// 待支付金额
@property(nonatomic, readwrite) BOOL hasAmt;
@property(nonatomic, readwrite, copy) NSString *amt;

// 订单类型  1 普通 ，2 追号
@property(nonatomic, readwrite) BOOL hasSourceType;
@property(nonatomic, readwrite) int32_t sourceType;

// 是否夜间支付,true为夜间也进行支付; false为不需要支付,返回错误码由客户端弹窗确认是否需要夜间支付
@property(nonatomic, readwrite) BOOL hasNightPay;
@property(nonatomic, readwrite) BOOL nightPay;

@end

#pragma mark - PBMPayParamsResult

typedef GPB_ENUM(PBMPayParamsResult_FieldNumber) {
  PBMPayParamsResult_FieldNumber_Params = 1,
  PBMPayParamsResult_FieldNumber_DrawTime = 2,
  PBMPayParamsResult_FieldNumber_GameNameNew = 3,
  PBMPayParamsResult_FieldNumber_GameIdNew = 4,
};

// 获取三方支付参数接口 返回
@interface PBMPayParamsResult : GPBMessage

// 三方支付参数串
@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, copy) NSString *params;

// 开奖时间
@property(nonatomic, readwrite) BOOL hasDrawTime;
@property(nonatomic, readwrite, copy) NSString *drawTime;

// 新期号
@property(nonatomic, readwrite) BOOL hasGameNameNew;
@property(nonatomic, readwrite, copy) NSString *gameNameNew;

// 新期主键id
@property(nonatomic, readwrite) BOOL hasGameIdNew;
@property(nonatomic, readwrite) int32_t gameIdNew;

@end

#pragma mark - PBMPay

typedef GPB_ENUM(PBMPay_FieldNumber) {
  PBMPay_FieldNumber_OrderId = 1,
  PBMPay_FieldNumber_RedPkgId = 2,
  PBMPay_FieldNumber_GameTypeId = 3,
  PBMPay_FieldNumber_Token = 4,
  PBMPay_FieldNumber_PayPassword = 5,
  PBMPay_FieldNumber_NightPay = 6,
  PBMPay_FieldNumber_GameName = 7,
  PBMPay_FieldNumber_GameId = 8,
};

// 支付请求接口
@interface PBMPay : GPBMessage

// 订单id
@property(nonatomic, readwrite) BOOL hasOrderId;
@property(nonatomic, readwrite) int64_t orderId;

// 红包id
@property(nonatomic, readwrite) BOOL hasRedPkgId;
@property(nonatomic, readwrite) int64_t redPkgId;

// 彩种类型
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

//IOS专用,Android无
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

// 支付密码
@property(nonatomic, readwrite) BOOL hasPayPassword;
@property(nonatomic, readwrite, copy) NSString *payPassword;

// 是否夜间支付,true为夜间也进行支付; false为不需要支付,返回错误码由客户端弹窗确认是否需要夜间支付
@property(nonatomic, readwrite) BOOL hasNightPay;
@property(nonatomic, readwrite) BOOL nightPay;

// 期号
@property(nonatomic, readwrite) BOOL hasGameName;
@property(nonatomic, readwrite, copy) NSString *gameName;

// 期号主键id
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int64_t gameId;

@end

#pragma mark - PBMPayResult

typedef GPB_ENUM(PBMPayResult_FieldNumber) {
  PBMPayResult_FieldNumber_ProjectId = 1,
  PBMPayResult_FieldNumber_DrawDate = 2,
  PBMPayResult_FieldNumber_Token = 3,
  PBMPayResult_FieldNumber_GameNameNew = 4,
  PBMPayResult_FieldNumber_GameIdNew = 5,
};

// 支付成功接口返回
@interface PBMPayResult : GPBMessage

// 方案id
@property(nonatomic, readwrite) BOOL hasProjectId;
@property(nonatomic, readwrite) int64_t projectId;

// 开奖时间
@property(nonatomic, readwrite) BOOL hasDrawDate;
@property(nonatomic, readwrite, copy) NSString *drawDate;

//IOS专用,Android无
@property(nonatomic, readwrite) BOOL hasToken;
@property(nonatomic, readwrite, copy) NSString *token;

// 新期号
@property(nonatomic, readwrite) BOOL hasGameNameNew;
@property(nonatomic, readwrite, copy) NSString *gameNameNew;

// 新期主键id
@property(nonatomic, readwrite) BOOL hasGameIdNew;
@property(nonatomic, readwrite) int32_t gameIdNew;

@end

#pragma mark - PBMOrderDetailResult

typedef GPB_ENUM(PBMOrderDetailResult_FieldNumber) {
  PBMOrderDetailResult_FieldNumber_TotalNum = 1,
  PBMOrderDetailResult_FieldNumber_TotalMoney = 2,
  PBMOrderDetailResult_FieldNumber_GameType = 3,
  PBMOrderDetailResult_FieldNumber_DltItemsArray = 4,
  PBMOrderDetailResult_FieldNumber_WinIssue = 5,
  PBMOrderDetailResult_FieldNumber_WinDate = 6,
  PBMOrderDetailResult_FieldNumber_WinRedsArray = 7,
  PBMOrderDetailResult_FieldNumber_WinBluesArray = 8,
  PBMOrderDetailResult_FieldNumber_JcItemsArray = 9,
};

//订单详情接口返回
@interface PBMOrderDetailResult : GPBMessage

//订单总票数
@property(nonatomic, readwrite) BOOL hasTotalNum;
@property(nonatomic, readwrite) int32_t totalNum;

//订单总金额
@property(nonatomic, readwrite) BOOL hasTotalMoney;
@property(nonatomic, readwrite) int64_t totalMoney;

//彩种,类型为整型int,共分为三种类型：大乐透、竞彩足球、竞彩篮球
@property(nonatomic, readwrite) BOOL hasGameType;
@property(nonatomic, readwrite) int32_t gameType;

//大乐透子订单数组
// |dltItemsArray| contains |PBMOrderDetailResult_DltItem|
@property(nonatomic, readwrite, strong) NSMutableArray *dltItemsArray;

//大乐透独有, 竞彩无这些字段
@property(nonatomic, readwrite) BOOL hasWinIssue;
@property(nonatomic, readwrite, copy) NSString *winIssue;

//开奖时间
@property(nonatomic, readwrite) BOOL hasWinDate;
@property(nonatomic, readwrite, copy) NSString *winDate;

//开奖号码, 红球
// |winRedsArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *winRedsArray;

//开奖号码, 蓝球
// |winBluesArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *winBluesArray;

//竞彩篮球、竞彩足球子订单数组
// |jcItemsArray| contains |PBMOrderDetailResult_JcItem|
@property(nonatomic, readwrite, strong) NSMutableArray *jcItemsArray;

@end

#pragma mark - PBMOrderDetailResult_DltResult

typedef GPB_ENUM(PBMOrderDetailResult_DltResult_FieldNumber) {
  PBMOrderDetailResult_DltResult_FieldNumber_RedsArray = 1,
  PBMOrderDetailResult_DltResult_FieldNumber_BluesArray = 2,
};

@interface PBMOrderDetailResult_DltResult : GPBMessage

//前区选择数组
// |redsArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *redsArray;

//后区选择数组
// |bluesArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *bluesArray;

@end

#pragma mark - PBMOrderDetailResult_DltDTResult

typedef GPB_ENUM(PBMOrderDetailResult_DltDTResult_FieldNumber) {
  PBMOrderDetailResult_DltDTResult_FieldNumber_RedDansArray = 1,
  PBMOrderDetailResult_DltDTResult_FieldNumber_RedTuosArray = 2,
  PBMOrderDetailResult_DltDTResult_FieldNumber_BlueDansArray = 3,
  PBMOrderDetailResult_DltDTResult_FieldNumber_BlueTuosArray = 4,
};

@interface PBMOrderDetailResult_DltDTResult : GPBMessage

//前区胆码选择数组
// |redDansArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *redDansArray;

//前区拖码选择数组
// |redTuosArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *redTuosArray;

//后区胆码选择数组
// |blueDansArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *blueDansArray;

//后区拖码选择数组
// |blueTuosArray| contains |NSString|
@property(nonatomic, readwrite, strong) NSMutableArray *blueTuosArray;

@end

#pragma mark - PBMOrderDetailResult_DltItem

typedef GPB_ENUM(PBMOrderDetailResult_DltItem_FieldNumber) {
  PBMOrderDetailResult_DltItem_FieldNumber_OrderNum = 1,
  PBMOrderDetailResult_DltItem_FieldNumber_Issue = 2,
  PBMOrderDetailResult_DltItem_FieldNumber_GamePlayId = 3,
  PBMOrderDetailResult_DltItem_FieldNumber_GamePlay = 4,
  PBMOrderDetailResult_DltItem_FieldNumber_Quantity = 5,
  PBMOrderDetailResult_DltItem_FieldNumber_Multiple = 6,
  PBMOrderDetailResult_DltItem_FieldNumber_Money = 7,
  PBMOrderDetailResult_DltItem_FieldNumber_DltResultsArray = 8,
  PBMOrderDetailResult_DltItem_FieldNumber_DltDtResultsArray = 9,
  PBMOrderDetailResult_DltItem_FieldNumber_TicketStatus = 10,
  PBMOrderDetailResult_DltItem_FieldNumber_TicketStatusDesc = 11,
  PBMOrderDetailResult_DltItem_FieldNumber_IsWin = 12,
  PBMOrderDetailResult_DltItem_FieldNumber_WinDesc = 13,
  PBMOrderDetailResult_DltItem_FieldNumber_IsAppend = 14,
};

@interface PBMOrderDetailResult_DltItem : GPBMessage

//子订单序号或出票序号
@property(nonatomic, readwrite) BOOL hasOrderNum;
@property(nonatomic, readwrite, copy) NSString *orderNum;

//期号
@property(nonatomic, readwrite) BOOL hasIssue;
@property(nonatomic, readwrite, copy) NSString *issue;

//玩法id
@property(nonatomic, readwrite) BOOL hasGamePlayId;
@property(nonatomic, readwrite) int32_t gamePlayId;

//玩法:单式、复式
@property(nonatomic, readwrite) BOOL hasGamePlay;
@property(nonatomic, readwrite, copy) NSString *gamePlay;

//注数
@property(nonatomic, readwrite) BOOL hasQuantity;
@property(nonatomic, readwrite) int64_t quantity;

//倍数
@property(nonatomic, readwrite) BOOL hasMultiple;
@property(nonatomic, readwrite) int64_t multiple;

//子订单金额
@property(nonatomic, readwrite) BOOL hasMoney;
@property(nonatomic, readwrite) int32_t money;

//普通玩法选择区数组
// |dltResultsArray| contains |PBMOrderDetailResult_DltResult|
@property(nonatomic, readwrite, strong) NSMutableArray *dltResultsArray;

//胆拖玩法选择区数组
// |dltDtResultsArray| contains |PBMOrderDetailResult_DltDTResult|
@property(nonatomic, readwrite, strong) NSMutableArray *dltDtResultsArray;

//已支付时存在这些字段
@property(nonatomic, readwrite) BOOL hasTicketStatus;
@property(nonatomic, readwrite) int32_t ticketStatus;

//出票状态描述
@property(nonatomic, readwrite) BOOL hasTicketStatusDesc;
@property(nonatomic, readwrite, copy) NSString *ticketStatusDesc;

//是否中奖
@property(nonatomic, readwrite) BOOL hasIsWin;
@property(nonatomic, readwrite) BOOL isWin;

//中奖描述, 如果有中奖金额, 需要服务器端对这金额部分用<font>标签格式化成红色字体
@property(nonatomic, readwrite) BOOL hasWinDesc;
@property(nonatomic, readwrite, copy) NSString *winDesc;

//是否追加
@property(nonatomic, readwrite) BOOL hasIsAppend;
@property(nonatomic, readwrite) BOOL isAppend;

@end

#pragma mark - PBMOrderDetailResult_JcResultItem

typedef GPB_ENUM(PBMOrderDetailResult_JcResultItem_FieldNumber) {
  PBMOrderDetailResult_JcResultItem_FieldNumber_IsWin = 1,
  PBMOrderDetailResult_JcResultItem_FieldNumber_Result = 2,
};

@interface PBMOrderDetailResult_JcResultItem : GPBMessage

//是否中奖
@property(nonatomic, readwrite) BOOL hasIsWin;
@property(nonatomic, readwrite) BOOL isWin;

//选择区内容
@property(nonatomic, readwrite) BOOL hasResult;
@property(nonatomic, readwrite, copy) NSString *result;

@end

#pragma mark - PBMOrderDetailResult_JcResult

typedef GPB_ENUM(PBMOrderDetailResult_JcResult_FieldNumber) {
  PBMOrderDetailResult_JcResult_FieldNumber_DateNum = 1,
  PBMOrderDetailResult_JcResult_FieldNumber_JcResultItemsArray = 2,
  PBMOrderDetailResult_JcResult_FieldNumber_GameType = 3,
  PBMOrderDetailResult_JcResult_FieldNumber_Rqs = 4,
};

@interface PBMOrderDetailResult_JcResult : GPBMessage

//选择区日期编号数组
@property(nonatomic, readwrite) BOOL hasDateNum;
@property(nonatomic, readwrite, copy) NSString *dateNum;

//选择区内容数组
// |jcResultItemsArray| contains |PBMOrderDetailResult_JcResultItem|
@property(nonatomic, readwrite, strong) NSMutableArray *jcResultItemsArray;

//小彩种类别, 跟game_name对应, 如: 128、121
@property(nonatomic, readwrite) BOOL hasGameType;
@property(nonatomic, readwrite) int32_t gameType;

//让球数、让分、总分共用
@property(nonatomic, readwrite) BOOL hasRqs;
@property(nonatomic, readwrite, copy) NSString *rqs;

@end

#pragma mark - PBMOrderDetailResult_JcItem

typedef GPB_ENUM(PBMOrderDetailResult_JcItem_FieldNumber) {
  PBMOrderDetailResult_JcItem_FieldNumber_OrderNum = 1,
  PBMOrderDetailResult_JcItem_FieldNumber_GameName = 2,
  PBMOrderDetailResult_JcItem_FieldNumber_GamePlay = 3,
  PBMOrderDetailResult_JcItem_FieldNumber_Multiple = 4,
  PBMOrderDetailResult_JcItem_FieldNumber_Money = 5,
  PBMOrderDetailResult_JcItem_FieldNumber_JcResultsArray = 6,
  PBMOrderDetailResult_JcItem_FieldNumber_TicketStatus = 8,
  PBMOrderDetailResult_JcItem_FieldNumber_TicketStatusDesc = 9,
  PBMOrderDetailResult_JcItem_FieldNumber_IsWin = 10,
  PBMOrderDetailResult_JcItem_FieldNumber_WinDesc = 11,
};

@interface PBMOrderDetailResult_JcItem : GPBMessage

//子订单序号或出票序号
@property(nonatomic, readwrite) BOOL hasOrderNum;
@property(nonatomic, readwrite, copy) NSString *orderNum;

//小彩种名称, 如: 胜平负、让球胜平负等
@property(nonatomic, readwrite) BOOL hasGameName;
@property(nonatomic, readwrite, copy) NSString *gameName;

//玩法:单关、n串n等, 类型为字符串
@property(nonatomic, readwrite) BOOL hasGamePlay;
@property(nonatomic, readwrite, copy) NSString *gamePlay;

//倍数
@property(nonatomic, readwrite) BOOL hasMultiple;
@property(nonatomic, readwrite) int32_t multiple;

//子订单金额
@property(nonatomic, readwrite) BOOL hasMoney;
@property(nonatomic, readwrite) int32_t money;

//竞彩选择区数组
// |jcResultsArray| contains |PBMOrderDetailResult_JcResult|
@property(nonatomic, readwrite, strong) NSMutableArray *jcResultsArray;

//已支付时存在这些字段
@property(nonatomic, readwrite) BOOL hasTicketStatus;
@property(nonatomic, readwrite) int32_t ticketStatus;

//出票状态描述
@property(nonatomic, readwrite) BOOL hasTicketStatusDesc;
@property(nonatomic, readwrite, copy) NSString *ticketStatusDesc;

//是否中奖
@property(nonatomic, readwrite) BOOL hasIsWin;
@property(nonatomic, readwrite) BOOL isWin;

//中奖描述, 如果有中奖金额, 需要服务器端对这金额部分用<font>标签格式化成红色字体
@property(nonatomic, readwrite) BOOL hasWinDesc;
@property(nonatomic, readwrite, copy) NSString *winDesc;

@end

#pragma mark - PBMCopyOrderAndPay

typedef GPB_ENUM(PBMCopyOrderAndPay_FieldNumber) {
  PBMCopyOrderAndPay_FieldNumber_ProjectId = 1,
  PBMCopyOrderAndPay_FieldNumber_GameId = 2,
  PBMCopyOrderAndPay_FieldNumber_GameTypeId = 3,
  PBMCopyOrderAndPay_FieldNumber_Password = 4,
};

//复制订单加支付接口 请求
@interface PBMCopyOrderAndPay : GPBMessage

// 方案id
@property(nonatomic, readwrite) BOOL hasProjectId;
@property(nonatomic, readwrite) int64_t projectId;

// 新期主键id
@property(nonatomic, readwrite) BOOL hasGameId;
@property(nonatomic, readwrite) int32_t gameId;

// 彩种类型
@property(nonatomic, readwrite) BOOL hasGameTypeId;
@property(nonatomic, readwrite) int32_t gameTypeId;

// 支付密码
@property(nonatomic, readwrite) BOOL hasPassword;
@property(nonatomic, readwrite, copy) NSString *password;

@end

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
