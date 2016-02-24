//
//  DPNoteCalculater.m
//  Jackpot
//
//  Created by wufan on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPNoteCalculater.h"
#import "DPBetOptionStore+Private.h"
#import "BetCalculater.h"

using namespace LotteryCalculater;

@implementation DPNoteCalculater

+ (DPNoteBonusResult)calcJczqWithOption:(NSArray *)optionList passMode:(NSArray *)passModeList {
    NSAssert(optionList.count <= 15, @"failure...");
    NSAssert(passModeList.count < 100, @"failure...");
    
    JczqCalculaterOption options[20] = { 0 };
    for (int i = 0; i < optionList.count; i++) {
        DPJczqBetStore *betStore = optionList[i];
        JczqCalculaterOption &option = options[i];
        option = betStore.betOption;
    }
    
    // 过关方式
    int passModes[100] = { 0 };
    for (int i = 0; i < passModeList.count; i++) {
        passModes[i] = [passModeList[i] intValue];
    }
   
    int64_t note = 0; float minBonus = 0; float maxBonus = 0;
    JczqCalculater(options, (int)optionList.count, passModes, (int)passModeList.count, note, minBonus, maxBonus);
    
    DPNoteBonusResult result;
    result.note = note >= 0 ? note : 0;
    result.max = note >= 0 ? maxBonus : 0;
    result.min = note >= 0 ? minBonus : 0;
    return result;
}

+ (DPNoteBonusResult)calcJclqWithOption:(NSArray *)optionList passMode:(NSArray *)passModeList {
    NSAssert(optionList.count <= 15, @"failure...");
    NSAssert(passModeList.count < 100, @"failure...");
    
    JclqCalculaterOption options[20] = { 0 };
    for (int i = 0; i < optionList.count; i++) {
        DPJclqBetStore *betStore = optionList[i];
        JclqCalculaterOption &option = options[i];
        option = betStore.betOption;
        

    }
    
    // 过关方式
    int passModes[100] = { 0 };
    for (int i = 0; i < passModeList.count; i++) {
        passModes[i] = [passModeList[i] intValue];
    }
   
    int64_t note = 0; float minBonus = 0; float maxBonus = 0;
    JclqCalculater(options, (int)optionList.count, passModes, (int)passModeList.count, note, minBonus, maxBonus);
    
    DPNoteBonusResult result;
    result.note = note >= 0 ? note : 0;
    result.max = note >= 0 ? maxBonus : 0;
    result.min = note >= 0 ? minBonus : 0;
    return result;
}

+ (int)calcDltWithRed:(int [])red blue:(int [])blue {
    return DltCalculater(red, blue);
}

+ (int)calcDltWithRedTuo:(int)redTuo redDan:(int)redDan blueTuo:(int)blueTuo blueDan:(int)blueDan {
    return DltCalculater(redTuo, redDan, blueTuo, blueDan);
}

+ (NSArray<DPJczqOptimize *> *)optimizeJczqWithOption:(NSArray<DPJczqBetStore *> *)optionList passMode:(NSArray *)passModeList note:(NSInteger)note output:(DPNoteBonusResult *)output {
    NSAssert(optionList.count <= 15, @"failure...");
    NSAssert(passModeList.count < 100, @"failure...");
    
    JczqCalculaterOption options[20] = { 0 };
    for (int i = 0; i < optionList.count; i++) {
        DPJczqBetStore *betStore = optionList[i];
        JczqCalculaterOption &option = options[i];
        option = betStore.betOption;
    }
    
    // 过关方式
    int passModes[100] = { 0 };
    for (int i = 0; i < passModeList.count; i++) {
        passModes[i] = [passModeList[i] intValue];
    }
    
    OptimizeResult result = JczqOptimize(options, (int)optionList.count, passModes, (int)passModeList.count, (int)note);
    int realMultiple = 0;
    float max = 0, min = 0;
    NSMutableArray *optimizeList = [NSMutableArray array];
    for (int i = 0; i < result.result.size(); i++) {
        NSMutableArray *optionList = [NSMutableArray array];
        for (int j = 0; j < result.result[i].size(); j++) {
            DPJczqOptimizeOption *option = [[DPJczqOptimizeOption alloc] init];
            option.gameType = result.result[i][j].gameType;
            option.matchId = result.result[i][j].matchId;
            option.index = result.result[i][j].index;
            option.sp = result.result[i][j].sp;
            [optionList addObject:option];
        }
        DPJczqOptimize *optimize = [[DPJczqOptimize alloc] init];
        optimize.options = optionList;
        optimize.spCount = result.sp[i];
        optimize.multiple = MIN(9999, result.multiple[i]) ;
        [optimizeList addObject:optimize];
        
        if (i == 0) {
            max = min = result.sp[i];
        } else {
            max = MAX(max, result.sp[i]);
            min = MIN(min, result.sp[i]);
        }
        
        realMultiple += optimize.multiple;
    }
    
    output->note = realMultiple;
    output->min = min;
    output->max = max;
    
    return optimizeList;
}

@end
