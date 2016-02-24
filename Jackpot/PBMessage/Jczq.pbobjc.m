// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: jczq.proto

#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "Jczq.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma mark - PBMJczqRoot

@implementation PBMJczqRoot

@end

static GPBFileDescriptor *PBMJczqRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"Dacai.Protobuf"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - PBMJczqItem

@implementation PBMJczqItem

@dynamic spListArray;
@dynamic hasGameVisible, gameVisible;
@dynamic hasSupportSingle, supportSingle;

typedef struct PBMJczqItem_Storage {
  uint32_t _has_storage_[1];
  BOOL gameVisible;
  BOOL supportSingle;
  NSMutableArray *spListArray;
} PBMJczqItem_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "spListArray",
        .number = PBMJczqItem_FieldNumber_SpListArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqItem_Storage, spListArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameVisible",
        .number = PBMJczqItem_FieldNumber_GameVisible,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqItem_Storage, gameVisible),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "supportSingle",
        .number = PBMJczqItem_FieldNumber_SupportSingle,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqItem_Storage, supportSingle),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJczqItem class]
                                              rootClass:[PBMJczqRoot class]
                                                   file:PBMJczqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJczqItem_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJczqAnalysis

@implementation PBMJczqAnalysis

@dynamic spfBetRatioArray;
@dynamic rqspfBetRatioArray;
@dynamic homeRecentArray;
@dynamic awayRecentArray;
@dynamic avgOddsArray;
@dynamic hasHistoryCount, historyCount;
@dynamic historyBattleArray;

typedef struct PBMJczqAnalysis_Storage {
  uint32_t _has_storage_[1];
  int32_t historyCount;
  NSMutableArray *spfBetRatioArray;
  NSMutableArray *rqspfBetRatioArray;
  NSMutableArray *homeRecentArray;
  NSMutableArray *awayRecentArray;
  NSMutableArray *avgOddsArray;
  GPBInt32Array *historyBattleArray;
} PBMJczqAnalysis_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "spfBetRatioArray",
        .number = PBMJczqAnalysis_FieldNumber_SpfBetRatioArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqAnalysis_Storage, spfBetRatioArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "rqspfBetRatioArray",
        .number = PBMJczqAnalysis_FieldNumber_RqspfBetRatioArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqAnalysis_Storage, rqspfBetRatioArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeRecentArray",
        .number = PBMJczqAnalysis_FieldNumber_HomeRecentArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqAnalysis_Storage, homeRecentArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayRecentArray",
        .number = PBMJczqAnalysis_FieldNumber_AwayRecentArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqAnalysis_Storage, awayRecentArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "avgOddsArray",
        .number = PBMJczqAnalysis_FieldNumber_AvgOddsArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqAnalysis_Storage, avgOddsArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "historyCount",
        .number = PBMJczqAnalysis_FieldNumber_HistoryCount,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMJczqAnalysis_Storage, historyCount),
        .defaultValue.valueInt32 = 0,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "historyBattleArray",
        .number = PBMJczqAnalysis_FieldNumber_HistoryBattleArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMJczqAnalysis_Storage, historyBattleArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJczqAnalysis class]
                                              rootClass:[PBMJczqRoot class]
                                                   file:PBMJczqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJczqAnalysis_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJczqMatch

@implementation PBMJczqMatch

@dynamic hasDataMatchId, dataMatchId;
@dynamic hasGameMatchId, gameMatchId;
@dynamic hasOrderNubmer, orderNubmer;
@dynamic hasOrderNumberName, orderNumberName;
@dynamic hasCompetitionName, competitionName;
@dynamic hasHomeTeamName, homeTeamName;
@dynamic hasAwayTeamName, awayTeamName;
@dynamic hasHomeTeamRank, homeTeamRank;
@dynamic hasAwayTeamRank, awayTeamRank;
@dynamic hasStartTime, startTime;
@dynamic hasEndTime, endTime;
@dynamic hasIsHot, isHot;
@dynamic hasSpfItem, spfItem;
@dynamic hasRqspfItem, rqspfItem;
@dynamic hasBfItem, bfItem;
@dynamic hasBqcItem, bqcItem;
@dynamic hasZjqItem, zjqItem;
@dynamic hasRqs, rqs;
@dynamic hasAnalysis, analysis;

typedef struct PBMJczqMatch_Storage {
  uint32_t _has_storage_[1];
  BOOL isHot;
  NSString *orderNumberName;
  NSString *competitionName;
  NSString *homeTeamName;
  NSString *awayTeamName;
  NSString *homeTeamRank;
  NSString *awayTeamRank;
  NSString *startTime;
  NSString *endTime;
  PBMJczqItem *spfItem;
  PBMJczqItem *rqspfItem;
  PBMJczqItem *bfItem;
  PBMJczqItem *bqcItem;
  PBMJczqItem *zjqItem;
  PBMJczqAnalysis *analysis;
  int64_t dataMatchId;
  int64_t gameMatchId;
  int64_t orderNubmer;
  int64_t rqs;
} PBMJczqMatch_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "dataMatchId",
        .number = PBMJczqMatch_FieldNumber_DataMatchId,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJczqMatch_Storage, dataMatchId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameMatchId",
        .number = PBMJczqMatch_FieldNumber_GameMatchId,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJczqMatch_Storage, gameMatchId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "orderNubmer",
        .number = PBMJczqMatch_FieldNumber_OrderNubmer,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJczqMatch_Storage, orderNubmer),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "orderNumberName",
        .number = PBMJczqMatch_FieldNumber_OrderNumberName,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, orderNumberName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "competitionName",
        .number = PBMJczqMatch_FieldNumber_CompetitionName,
        .hasIndex = 4,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, competitionName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeTeamName",
        .number = PBMJczqMatch_FieldNumber_HomeTeamName,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, homeTeamName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayTeamName",
        .number = PBMJczqMatch_FieldNumber_AwayTeamName,
        .hasIndex = 6,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, awayTeamName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeTeamRank",
        .number = PBMJczqMatch_FieldNumber_HomeTeamRank,
        .hasIndex = 7,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, homeTeamRank),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayTeamRank",
        .number = PBMJczqMatch_FieldNumber_AwayTeamRank,
        .hasIndex = 8,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, awayTeamRank),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "startTime",
        .number = PBMJczqMatch_FieldNumber_StartTime,
        .hasIndex = 9,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, startTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "endTime",
        .number = PBMJczqMatch_FieldNumber_EndTime,
        .hasIndex = 10,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqMatch_Storage, endTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "isHot",
        .number = PBMJczqMatch_FieldNumber_IsHot,
        .hasIndex = 11,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqMatch_Storage, isHot),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "spfItem",
        .number = PBMJczqMatch_FieldNumber_SpfItem,
        .hasIndex = 12,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, spfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "rqspfItem",
        .number = PBMJczqMatch_FieldNumber_RqspfItem,
        .hasIndex = 13,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, rqspfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "bfItem",
        .number = PBMJczqMatch_FieldNumber_BfItem,
        .hasIndex = 14,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, bfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "bqcItem",
        .number = PBMJczqMatch_FieldNumber_BqcItem,
        .hasIndex = 15,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, bqcItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "zjqItem",
        .number = PBMJczqMatch_FieldNumber_ZjqItem,
        .hasIndex = 16,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, zjqItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "rqs",
        .number = PBMJczqMatch_FieldNumber_Rqs,
        .hasIndex = 17,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJczqMatch_Storage, rqs),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "analysis",
        .number = PBMJczqMatch_FieldNumber_Analysis,
        .hasIndex = 18,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqMatch_Storage, analysis),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqAnalysis),
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJczqMatch class]
                                              rootClass:[PBMJczqRoot class]
                                                   file:PBMJczqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJczqMatch_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJczqGame

@implementation PBMJczqGame

@dynamic hasGameName, gameName;
@dynamic hasGameStatusId, gameStatusId;
@dynamic matchesArray;
@dynamic hasGameId, gameId;

typedef struct PBMJczqGame_Storage {
  uint32_t _has_storage_[1];
  int32_t gameStatusId;
  NSString *gameName;
  NSMutableArray *matchesArray;
  int64_t gameId;
} PBMJczqGame_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gameName",
        .number = PBMJczqGame_FieldNumber_GameName,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJczqGame_Storage, gameName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameStatusId",
        .number = PBMJczqGame_FieldNumber_GameStatusId,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMJczqGame_Storage, gameStatusId),
        .defaultValue.valueInt32 = 0,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "matchesArray",
        .number = PBMJczqGame_FieldNumber_MatchesArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqGame_Storage, matchesArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqMatch),
        .fieldOptions = NULL,
      },
      {
        .name = "gameId",
        .number = PBMJczqGame_FieldNumber_GameId,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJczqGame_Storage, gameId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJczqGame class]
                                              rootClass:[PBMJczqRoot class]
                                                   file:PBMJczqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJczqGame_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJczqBuy

@implementation PBMJczqBuy

@dynamic gamesArray;
@dynamic hasSpfSaleStop, spfSaleStop;
@dynamic hasRqspfSaleStop, rqspfSaleStop;
@dynamic hasBfSaleStop, bfSaleStop;
@dynamic hasZjqSaleStop, zjqSaleStop;
@dynamic hasBqcSaleStop, bqcSaleStop;
@dynamic hasNightStopTicket, nightStopTicket;

typedef struct PBMJczqBuy_Storage {
  uint32_t _has_storage_[1];
  BOOL spfSaleStop;
  BOOL rqspfSaleStop;
  BOOL bfSaleStop;
  BOOL zjqSaleStop;
  BOOL bqcSaleStop;
  BOOL nightStopTicket;
  NSMutableArray *gamesArray;
} PBMJczqBuy_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gamesArray",
        .number = PBMJczqBuy_FieldNumber_GamesArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJczqBuy_Storage, gamesArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJczqGame),
        .fieldOptions = NULL,
      },
      {
        .name = "spfSaleStop",
        .number = PBMJczqBuy_FieldNumber_SpfSaleStop,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, spfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "rqspfSaleStop",
        .number = PBMJczqBuy_FieldNumber_RqspfSaleStop,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, rqspfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "bfSaleStop",
        .number = PBMJczqBuy_FieldNumber_BfSaleStop,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, bfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "zjqSaleStop",
        .number = PBMJczqBuy_FieldNumber_ZjqSaleStop,
        .hasIndex = 4,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, zjqSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "bqcSaleStop",
        .number = PBMJczqBuy_FieldNumber_BqcSaleStop,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, bqcSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "nightStopTicket",
        .number = PBMJczqBuy_FieldNumber_NightStopTicket,
        .hasIndex = 6,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJczqBuy_Storage, nightStopTicket),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJczqBuy class]
                                              rootClass:[PBMJczqRoot class]
                                                   file:PBMJczqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJczqBuy_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end


// @@protoc_insertion_point(global_scope)
