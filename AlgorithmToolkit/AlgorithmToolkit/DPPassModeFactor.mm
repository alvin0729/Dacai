//
//  DPPassModeFactor.m
//  Jackpot
//
//  Created by wufan on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPassModeFactor.h"
#import "PassModeFactor.h"
#import "PassModeDefine.h"

NSString *GetPassModeName(int passModeTag) {
    int prefix = GetPassModeNamePrefix(passModeTag);
    int suffix = GetPassModeNameSuffix(passModeTag);
    if (prefix == suffix == 1) {
        return @"单关";
    }
    return [NSString stringWithFormat:@"%d串%d", prefix, suffix];
}

@implementation DPPassModeFactor

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // TODO: 初始化不要放在这里
        CPassModeFactor::SharedInstance();
    });
}

+ (NSArray *)freedomWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount {
    NSAssert(types.count < 10, @"failure...");
    
    int gameTypes[10] = { 0 };
    for (int i = 0; i < types.count; i++) {
        gameTypes[i] = [[types objectAtIndex:i] intValue];
    }
    vector<int> freedomTags;
    CPassModeFactor::SharedInstance()->GetFreedomPassModes(gameTypes, (int)types.count, (int)markCount, (int)matchCount, freedomTags);
    if (freedomTags.size() == 0) {
        return nil;
    }
    
    NSMutableArray *passMode = [NSMutableArray arrayWithCapacity:freedomTags.size()];
    for (int i = 0; i < freedomTags.size(); i++) {
        [passMode addObject:@(freedomTags[i])];
    }
    return passMode;
}

+ (NSArray *)freedomWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount allSingle:(BOOL)allSingle {
    NSAssert(types.count < 10, @"failure...");
    
    int gameTypes[10] = { 0 };
    for (int i = 0; i < types.count; i++) {
        gameTypes[i] = [[types objectAtIndex:i] intValue];
    }
    vector<int> freedomTags;
    CPassModeFactor::SharedInstance()->GetFreedomPassModes(gameTypes, (int)types.count, (int)markCount, (int)matchCount, freedomTags);
    if (freedomTags.size() == 0 && !allSingle) {
        return nil;
    }
    
    NSMutableArray *passMode = [NSMutableArray arrayWithCapacity:freedomTags.size() + 1];
    if (allSingle && markCount <= 1) {
        [passMode addObject:@(PASSMODE_1_1)];
    }
    for (int i = 0; i < freedomTags.size(); i++) {
        if (freedomTags[i] == PASSMODE_1_1 && allSingle && markCount <= 1) {
            continue;
        }
        [passMode addObject:@(freedomTags[i])];
    }
    return passMode;
}

+ (NSArray *)combineWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount {
    NSAssert(types.count < 10, @"failure...");
    
    int gameTypes[10] = { 0 };
    for (int i = 0; i < types.count; i++) {
        gameTypes[i] = [[types objectAtIndex:i] intValue];
    }
    vector<int> combineTags;
    CPassModeFactor::SharedInstance()->GetCombinePassModes(gameTypes, (int)types.count, (int)markCount, (int)matchCount, combineTags);
    if (combineTags.size() == 0) {
        return nil;
    }
    
    NSMutableArray *passMode = [NSMutableArray arrayWithCapacity:combineTags.size()];
    for (int i = 0; i < combineTags.size(); i++) {
        [passMode addObject:@(combineTags[i])];
    }
    return passMode;
}

@end
