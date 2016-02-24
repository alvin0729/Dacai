//
//  DPLBNumberBasicModel.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  投注底层数据模型

#import <Foundation/Foundation.h>
#import "DPLBNumberProtocol.h"

static NSString * kDPHistoryTendencyCell = @"DPHistoryTendencyCell";
static NSString * kDPDigitalBallCell = @"DPDigitalBallCell";
 #define yilouSpace  20
#define noYilouSpace 7
#define ballHeight   35
@interface DPLBNumberBasicModel : NSObject <DPLBNumberCommonDataSource, DPLBNumberHandlerDataSource>
{
@protected
    BOOL            _isOpenSwitch;
    NSInteger       _indexPathRow;
    NSInteger       _gameIndex;
    NSDictionary*    _ballUIDict;
}
+ (id <DPLBNumberCommonDataSource, DPLBNumberHandlerDataSource>)numberDataModelForGameType:(GameTypeId)gameType;
- (void)partRandom:(int)count total:(int)total target2:(int *)target;                   // 产生随机数

@end
