// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: jclq.proto

#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "Jclq.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma mark - PBMJclqRoot

@implementation PBMJclqRoot

@end

static GPBFileDescriptor *PBMJclqRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"Dacai.Protobuf"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - PBMJclqItem

@implementation PBMJclqItem

@dynamic spListArray;
@dynamic hasGameVisible, gameVisible;
@dynamic hasSupportSingle, supportSingle;

typedef struct PBMJclqItem_Storage {
  uint32_t _has_storage_[1];
  BOOL gameVisible;
  BOOL supportSingle;
  NSMutableArray *spListArray;
} PBMJclqItem_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "spListArray",
        .number = PBMJclqItem_FieldNumber_SpListArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqItem_Storage, spListArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameVisible",
        .number = PBMJclqItem_FieldNumber_GameVisible,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqItem_Storage, gameVisible),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "supportSingle",
        .number = PBMJclqItem_FieldNumber_SupportSingle,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqItem_Storage, supportSingle),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJclqItem class]
                                              rootClass:[PBMJclqRoot class]
                                                   file:PBMJclqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJclqItem_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJclqAnalysis

@implementation PBMJclqAnalysis

@dynamic sfBetRatioArray;
@dynamic rfsfBetRatioArray;
@dynamic dxfBetRatioArray;
@dynamic homeRecentArray;
@dynamic awayRecentArray;
@dynamic hasHistoryCount, historyCount;
@dynamic historyBattleArray;

typedef struct PBMJclqAnalysis_Storage {
  uint32_t _has_storage_[1];
  int32_t historyCount;
  NSMutableArray *sfBetRatioArray;
  NSMutableArray *rfsfBetRatioArray;
  NSMutableArray *dxfBetRatioArray;
  NSMutableArray *homeRecentArray;
  NSMutableArray *awayRecentArray;
  GPBInt32Array *historyBattleArray;
} PBMJclqAnalysis_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sfBetRatioArray",
        .number = PBMJclqAnalysis_FieldNumber_SfBetRatioArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqAnalysis_Storage, sfBetRatioArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "rfsfBetRatioArray",
        .number = PBMJclqAnalysis_FieldNumber_RfsfBetRatioArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqAnalysis_Storage, rfsfBetRatioArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "dxfBetRatioArray",
        .number = PBMJclqAnalysis_FieldNumber_DxfBetRatioArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqAnalysis_Storage, dxfBetRatioArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeRecentArray",
        .number = PBMJclqAnalysis_FieldNumber_HomeRecentArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqAnalysis_Storage, homeRecentArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayRecentArray",
        .number = PBMJclqAnalysis_FieldNumber_AwayRecentArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqAnalysis_Storage, awayRecentArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "historyCount",
        .number = PBMJclqAnalysis_FieldNumber_HistoryCount,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMJclqAnalysis_Storage, historyCount),
        .defaultValue.valueInt32 = 0,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "historyBattleArray",
        .number = PBMJclqAnalysis_FieldNumber_HistoryBattleArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMJclqAnalysis_Storage, historyBattleArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJclqAnalysis class]
                                              rootClass:[PBMJclqRoot class]
                                                   file:PBMJclqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJclqAnalysis_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJclqMatch

@implementation PBMJclqMatch

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
@dynamic hasSfItem, sfItem;
@dynamic hasRfsfItem, rfsfItem;
@dynamic hasDxfItem, dxfItem;
@dynamic hasSfcItem, sfcItem;
@dynamic hasRf, rf;
@dynamic hasZf, zf;
@dynamic hasAnalysis, analysis;

typedef struct PBMJclqMatch_Storage {
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
  PBMJclqItem *sfItem;
  PBMJclqItem *rfsfItem;
  PBMJclqItem *dxfItem;
  PBMJclqItem *sfcItem;
  NSString *rf;
  NSString *zf;
  PBMJclqAnalysis *analysis;
  int64_t dataMatchId;
  int64_t gameMatchId;
  int64_t orderNubmer;
} PBMJclqMatch_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "dataMatchId",
        .number = PBMJclqMatch_FieldNumber_DataMatchId,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJclqMatch_Storage, dataMatchId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameMatchId",
        .number = PBMJclqMatch_FieldNumber_GameMatchId,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJclqMatch_Storage, gameMatchId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "orderNubmer",
        .number = PBMJclqMatch_FieldNumber_OrderNubmer,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJclqMatch_Storage, orderNubmer),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "orderNumberName",
        .number = PBMJclqMatch_FieldNumber_OrderNumberName,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, orderNumberName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "competitionName",
        .number = PBMJclqMatch_FieldNumber_CompetitionName,
        .hasIndex = 4,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, competitionName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeTeamName",
        .number = PBMJclqMatch_FieldNumber_HomeTeamName,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, homeTeamName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayTeamName",
        .number = PBMJclqMatch_FieldNumber_AwayTeamName,
        .hasIndex = 6,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, awayTeamName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "homeTeamRank",
        .number = PBMJclqMatch_FieldNumber_HomeTeamRank,
        .hasIndex = 7,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, homeTeamRank),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "awayTeamRank",
        .number = PBMJclqMatch_FieldNumber_AwayTeamRank,
        .hasIndex = 8,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, awayTeamRank),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "startTime",
        .number = PBMJclqMatch_FieldNumber_StartTime,
        .hasIndex = 9,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, startTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "endTime",
        .number = PBMJclqMatch_FieldNumber_EndTime,
        .hasIndex = 10,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, endTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "isHot",
        .number = PBMJclqMatch_FieldNumber_IsHot,
        .hasIndex = 11,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqMatch_Storage, isHot),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "sfItem",
        .number = PBMJclqMatch_FieldNumber_SfItem,
        .hasIndex = 12,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqMatch_Storage, sfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "rfsfItem",
        .number = PBMJclqMatch_FieldNumber_RfsfItem,
        .hasIndex = 13,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqMatch_Storage, rfsfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "dxfItem",
        .number = PBMJclqMatch_FieldNumber_DxfItem,
        .hasIndex = 14,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqMatch_Storage, dxfItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "sfcItem",
        .number = PBMJclqMatch_FieldNumber_SfcItem,
        .hasIndex = 15,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqMatch_Storage, sfcItem),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqItem),
        .fieldOptions = NULL,
      },
      {
        .name = "rf",
        .number = PBMJclqMatch_FieldNumber_Rf,
        .hasIndex = 16,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, rf),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "zf",
        .number = PBMJclqMatch_FieldNumber_Zf,
        .hasIndex = 17,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqMatch_Storage, zf),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "analysis",
        .number = PBMJclqMatch_FieldNumber_Analysis,
        .hasIndex = 18,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqMatch_Storage, analysis),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqAnalysis),
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJclqMatch class]
                                              rootClass:[PBMJclqRoot class]
                                                   file:PBMJclqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJclqMatch_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJclqGame

@implementation PBMJclqGame

@dynamic hasGameName, gameName;
@dynamic matchesArray;
@dynamic hasGameId, gameId;

typedef struct PBMJclqGame_Storage {
  uint32_t _has_storage_[1];
  NSString *gameName;
  NSMutableArray *matchesArray;
  int64_t gameId;
} PBMJclqGame_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gameName",
        .number = PBMJclqGame_FieldNumber_GameName,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMJclqGame_Storage, gameName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "matchesArray",
        .number = PBMJclqGame_FieldNumber_MatchesArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqGame_Storage, matchesArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqMatch),
        .fieldOptions = NULL,
      },
      {
        .name = "gameId",
        .number = PBMJclqGame_FieldNumber_GameId,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMJclqGame_Storage, gameId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJclqGame class]
                                              rootClass:[PBMJclqRoot class]
                                                   file:PBMJclqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJclqGame_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMJclqBuy

@implementation PBMJclqBuy

@dynamic gamesArray;
@dynamic hasSfSaleStop, sfSaleStop;
@dynamic hasRfsfSaleStop, rfsfSaleStop;
@dynamic hasDxfSaleStop, dxfSaleStop;
@dynamic hasSfcSaleStop, sfcSaleStop;
@dynamic hasNightStopTicket, nightStopTicket;

typedef struct PBMJclqBuy_Storage {
  uint32_t _has_storage_[1];
  BOOL sfSaleStop;
  BOOL rfsfSaleStop;
  BOOL dxfSaleStop;
  BOOL sfcSaleStop;
  BOOL nightStopTicket;
  NSMutableArray *gamesArray;
} PBMJclqBuy_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gamesArray",
        .number = PBMJclqBuy_FieldNumber_GamesArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMJclqBuy_Storage, gamesArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMJclqGame),
        .fieldOptions = NULL,
      },
      {
        .name = "sfSaleStop",
        .number = PBMJclqBuy_FieldNumber_SfSaleStop,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqBuy_Storage, sfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "rfsfSaleStop",
        .number = PBMJclqBuy_FieldNumber_RfsfSaleStop,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqBuy_Storage, rfsfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "dxfSaleStop",
        .number = PBMJclqBuy_FieldNumber_DxfSaleStop,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqBuy_Storage, dxfSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "sfcSaleStop",
        .number = PBMJclqBuy_FieldNumber_SfcSaleStop,
        .hasIndex = 4,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqBuy_Storage, sfcSaleStop),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "nightStopTicket",
        .number = PBMJclqBuy_FieldNumber_NightStopTicket,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMJclqBuy_Storage, nightStopTicket),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMJclqBuy class]
                                              rootClass:[PBMJclqRoot class]
                                                   file:PBMJclqRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMJclqBuy_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end


// @@protoc_insertion_point(global_scope)
