//
//  DPBetDescription.m
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBetDescription.h"
#import "BetCalculater.h"
#import "DPBetOptionStore+Private.h"
//#import "DPDltBetData.h"

using namespace LotteryCalculater;

@implementation DPBetDescription

+ (NSString *)descriptionJczqWithOption:(NSArray<DPJczqBetStore *> *)optionList
                               passMode:(NSArray *)passModeList
                               gameType:(NSInteger)gameType
                                   note:(NSInteger)note {
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
    
    std::string desc = JczqBetDescription(options, (int)optionList.count, passModes, (int)passModeList.count, (int)gameType, (int)note);
    return [[NSString alloc] initWithUTF8String:desc.c_str()];
}

+ (NSString *)descriptionJclqWithOption:(NSArray<DPJclqBetStore *> *)optionList
                               passMode:(NSArray *)passModeList
                               gameType:(NSInteger)gameType
                                   note:(NSInteger)note {
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
    
    std::string desc = JclqBetDescription(options, (int)optionList.count, passModes, (int)passModeList.count, (int)gameType, (int)note);
    return [[NSString alloc] initWithUTF8String:desc.c_str()];
}

+ (NSString *)descriptionDltWithOption:(NSArray<DPDltBetStore *> *)optionList addition:(BOOL)addition {
    NSAssert(optionList.count <= 100, @"failure...");
    
    NumberBetOption options[100] = { 0 };
    for (int i = 0; i < optionList.count && i < 100; i++) {
        NumberBetOption &betOption = options[i];
        DPDltBetStore *betStore = [optionList objectAtIndex:i];
        
        NSAssert(betStore.red.count >= kDltRedCount && betStore.blue.count >= kDltBlueCount, @"failure...");
        for (int i = 0; i < kDltRedCount; i++) {
            betOption.betRed[i] = [betStore.red[i] intValue];
        }
        for (int i = 0; i < kDltBlueCount; i++) {
            betOption.betBlue[i] = [betStore.blue[i] intValue];
        }
    }
    std::string desc = DltBetDescription(options, (int)MIN(optionList.count, 100), addition);
    return [[NSString alloc] initWithUTF8String:desc.c_str()];
}

+ (NSString *)descriptionDltWithOption:(NSArray<DPDltBetStore *> *)optionList addition:(BOOL)addition multiple:(NSInteger)multiple followCount:(NSInteger)followCount {
    NSAssert(optionList.count <= 100, @"failure...");
    NSAssert(followCount > 1, @"failure...");
    
    NumberBetOption options[100] = { 0 };
    for (int i = 0; i < optionList.count && i < 100; i++) {
        NumberBetOption &betOption = options[i];
        DPDltBetStore *betStore = [optionList objectAtIndex:i];
        
        NSAssert(betStore.red.count >= kDltRedCount && betStore.blue.count >= kDltBlueCount, @"failure...");
        for (int i = 0; i < kDltRedCount; i++) {
            betOption.betRed[i] = [betStore.red[i] intValue];
        }
        for (int i = 0; i < kDltBlueCount; i++) {
            betOption.betBlue[i] = [betStore.blue[i] intValue];
        }
    }
    
    std::string desc = DltFollowDescription(options, (int)MIN(optionList.count, 100), addition, (int)multiple, (int)followCount);
    return [[NSString alloc] initWithUTF8String:desc.c_str()];
}

+ (NSString *)descriptionOptimizeWithOption:(NSArray<DPJczqBetStore *> *)optionList
                                   passMode:(NSArray *)passModeList
                                   optimize:(NSArray<DPJczqOptimize *> *)optimize
                                   gameType:(NSInteger)gameType {
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
    
    OptimizeResult result;
    for (DPJczqOptimize *optimizeItem in optimize) {
        std::vector<OptimizeOption> vOptimize;
        for (DPJczqOptimizeOption *optionItem in optimizeItem.options) {
            OptimizeOption vOption;
            vOption.gameType = optionItem.gameType;
            vOption.sp = optionItem.sp;
            vOption.index = optionItem.index;
            vOption.matchId = (int)optionItem.matchId;
            vOptimize.push_back(vOption);
        }
        result.multiple.push_back(optimizeItem.multiple);
        result.sp.push_back(optimizeItem.spCount);
        result.result.push_back(vOptimize);
    }
    
    std::string desc = JczqOptimizeDescription(options, (int)optionList.count, passModes, (int)passModeList.count, result, (int)gameType);
    return [[NSString alloc] initWithUTF8String:desc.c_str()];
}

@end
