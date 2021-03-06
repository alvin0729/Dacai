// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: numberbet.proto

#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "Numberbet.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma mark - PBMNumberbetRoot

@implementation PBMNumberbetRoot

@end

static GPBFileDescriptor *PBMNumberbetRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"Dacai.Protobuf"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - PBMDrawItem

@implementation PBMDrawItem

@dynamic hasGameName, gameName;
@dynamic hasResult, result;
@dynamic hasResultPreview, resultPreview;

typedef struct PBMDrawItem_Storage {
  uint32_t _has_storage_[1];
  NSString *gameName;
  NSString *result;
  NSString *resultPreview;
} PBMDrawItem_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gameName",
        .number = PBMDrawItem_FieldNumber_GameName,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMDrawItem_Storage, gameName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "result",
        .number = PBMDrawItem_FieldNumber_Result,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMDrawItem_Storage, result),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "resultPreview",
        .number = PBMDrawItem_FieldNumber_ResultPreview,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMDrawItem_Storage, resultPreview),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMDrawItem class]
                                              rootClass:[PBMNumberbetRoot class]
                                                   file:PBMNumberbetRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMDrawItem_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMGameItem

@implementation PBMGameItem

@dynamic hasGameId, gameId;
@dynamic hasGameName, gameName;
@dynamic hasBeginBuyTime, beginBuyTime;
@dynamic hasEndBuyTime, endBuyTime;
@dynamic hasDrawTime, drawTime;

typedef struct PBMGameItem_Storage {
  uint32_t _has_storage_[1];
  NSString *gameName;
  NSString *beginBuyTime;
  NSString *endBuyTime;
  NSString *drawTime;
  int64_t gameId;
} PBMGameItem_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gameId",
        .number = PBMGameItem_FieldNumber_GameId,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMGameItem_Storage, gameId),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "gameName",
        .number = PBMGameItem_FieldNumber_GameName,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMGameItem_Storage, gameName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "beginBuyTime",
        .number = PBMGameItem_FieldNumber_BeginBuyTime,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMGameItem_Storage, beginBuyTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "endBuyTime",
        .number = PBMGameItem_FieldNumber_EndBuyTime,
        .hasIndex = 3,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMGameItem_Storage, endBuyTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "drawTime",
        .number = PBMGameItem_FieldNumber_DrawTime,
        .hasIndex = 4,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMGameItem_Storage, drawTime),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMGameItem class]
                                              rootClass:[PBMNumberbetRoot class]
                                                   file:PBMNumberbetRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMGameItem_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end

#pragma mark - PBMNumberBuy

@implementation PBMNumberBuy

@dynamic hasGameType, gameType;
@dynamic hasOnsoldGame, onsoldGame;
@dynamic hasGlobalSurplus, globalSurplus;
@dynamic missDataArray;
@dynamic drawsArray;
@dynamic hasLastGameName, lastGameName;
@dynamic hasEnable, enable;

typedef struct PBMNumberBuy_Storage {
  uint32_t _has_storage_[1];
  BOOL enable;
  int32_t gameType;
  PBMGameItem *onsoldGame;
  GPBInt32Array *missDataArray;
  NSMutableArray *drawsArray;
  NSString *lastGameName;
  int64_t globalSurplus;
} PBMNumberBuy_Storage;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = NULL;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "gameType",
        .number = PBMNumberBuy_FieldNumber_GameType,
        .hasIndex = 0,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMNumberBuy_Storage, gameType),
        .defaultValue.valueInt32 = 0,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "onsoldGame",
        .number = PBMNumberBuy_FieldNumber_OnsoldGame,
        .hasIndex = 1,
        .flags = GPBFieldOptional,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMNumberBuy_Storage, onsoldGame),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMGameItem),
        .fieldOptions = NULL,
      },
      {
        .name = "globalSurplus",
        .number = PBMNumberBuy_FieldNumber_GlobalSurplus,
        .hasIndex = 2,
        .flags = GPBFieldOptional,
        .type = GPBTypeInt64,
        .offset = offsetof(PBMNumberBuy_Storage, globalSurplus),
        .defaultValue.valueInt64 = 0LL,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "missDataArray",
        .number = PBMNumberBuy_FieldNumber_MissDataArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeInt32,
        .offset = offsetof(PBMNumberBuy_Storage, missDataArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "drawsArray",
        .number = PBMNumberBuy_FieldNumber_DrawsArray,
        .hasIndex = GPBNoHasBit,
        .flags = GPBFieldRepeated,
        .type = GPBTypeMessage,
        .offset = offsetof(PBMNumberBuy_Storage, drawsArray),
        .defaultValue.valueMessage = nil,
        .typeSpecific.className = GPBStringifySymbol(PBMDrawItem),
        .fieldOptions = NULL,
      },
      {
        .name = "lastGameName",
        .number = PBMNumberBuy_FieldNumber_LastGameName,
        .hasIndex = 5,
        .flags = GPBFieldOptional,
        .type = GPBTypeString,
        .offset = offsetof(PBMNumberBuy_Storage, lastGameName),
        .defaultValue.valueString = nil,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
      {
        .name = "enable",
        .number = PBMNumberBuy_FieldNumber_Enable,
        .hasIndex = 6,
        .flags = GPBFieldOptional,
        .type = GPBTypeBool,
        .offset = offsetof(PBMNumberBuy_Storage, enable),
        .defaultValue.valueBool = NO,
        .typeSpecific.className = NULL,
        .fieldOptions = NULL,
      },
    };
    descriptor = [GPBDescriptor allocDescriptorForClass:[PBMNumberBuy class]
                                              rootClass:[PBMNumberbetRoot class]
                                                   file:PBMNumberbetRoot_FileDescriptor()
                                                 fields:fields
                                             fieldCount:sizeof(fields) / sizeof(GPBMessageFieldDescription)
                                                 oneofs:NULL
                                             oneofCount:0
                                                  enums:NULL
                                              enumCount:0
                                                 ranges:NULL
                                             rangeCount:0
                                            storageSize:sizeof(PBMNumberBuy_Storage)
                                             wireFormat:NO];
  }
  return descriptor;
}

@end


// @@protoc_insertion_point(global_scope)
