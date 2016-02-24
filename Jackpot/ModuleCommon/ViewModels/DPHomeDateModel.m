//
//  DPHomeDateModel.m
//  Jackpot
//
//  Created by Ray on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPHomeDateModel.h"

#import <objc/runtime.h>

@interface HomeBetOption ()

@end

@implementation HomeBetOption

- (instancetype)init {
    self = [super init];
    if (self) {
        memset(&_betOption, 0, sizeof(_betOption));
    }
    return self;
}

- (void)resetQuickBet {
    memset(&_betOption, 0, sizeof(_betOption));
}

@end

static const char *option_key = "option_key";

@implementation PBMHomePage_SportQuickBet (Addation)
@dynamic homeBetOption;

- (HomeBetOption *)homeBetOption {
    HomeBetOption *option = objc_getAssociatedObject(self, option_key);
    if (option == nil) {
        option = [[HomeBetOption alloc] init];
        objc_setAssociatedObject(self, option_key, option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return option;
}

//更新竞彩投注选项所选择的状态
- (void)updateSelectStatusWithGmaeType:(GameTypeId)gametype index:(NSInteger)index select:(BOOL)isSelect {
    HomeOption option = self.homeBetOption.betOption;
    switch (gametype) {
        case GameTypeLcNone:
            option.betLcOption[index] = isSelect;
            break;
        case GameTypeJcNone:
            option.betJczqOption[index] = isSelect;
            break;

        default:
            NSAssert(0, @"没有对应彩种");
            break;
    }

    self.homeBetOption.betOption = option;
}

//计算奖金范围
- (void)getMinBounds:(float *)min maxBouns:(float *)max gameType:(GameTypeId)gameType {
    HomeOption option = self.homeBetOption.betOption;
    switch (gameType) {
        case GameTypeLcNone:
            if ((option.betLcOption[0] && !option.betLcOption[1]) || (!option.betLcOption[0] && option.betLcOption[1]) || (!option.betLcOption[0] && !option.betLcOption[1])) {
                *max = *min = (option.betLcOption[0] * 2 * [self.spListArray[0] floatValue] + option.betLcOption[1] * 2 * [self.spListArray[1] floatValue]);
            } else {
                if ([self.spListArray[0] floatValue] > [self.spListArray[1] floatValue]) {
                    *min = [self.spListArray[1] floatValue] * 2;
                    *max = [self.spListArray[0] floatValue] * 2;
                } else {
                    *max = [self.spListArray[1] floatValue] * 2;
                    *min = [self.spListArray[0] floatValue] * 2;
                }
            }
            break;
        case GameTypeJcNone: {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:3];
            for (int i = 0; i < 3; i++) {
                NSNumber *num = [NSNumber numberWithFloat:[self.spListArray[i] floatValue] * option.betJczqOption[i] * 2];
                [arr addObject:num];
            }

            NSArray *sortArr = [arr sortedArrayUsingSelector:@selector(compare:)];

            if ([self getSelectedCount:GameTypeJcNone] == 0 || [self getSelectedCount:GameTypeJcNone] == 1) {
                *min = *max = [sortArr[2] floatValue];
            } else if ([self getSelectedCount:GameTypeJcNone] == 2) {
                *min = [sortArr[1] floatValue];
                *max = [sortArr[2] floatValue];
            } else {
                *min = [sortArr[0] floatValue];
                *max = [sortArr[2] floatValue];
            }

        } break;

        default:
            NSAssert(0, @"没有对应彩种");
            break;
    }
}
//计算注数
- (NSInteger)getSelectedCount:(GameTypeId)gameType {
    NSInteger count = 0;
    switch (gameType) {
        case GameTypeLcNone: {
            for (int i = 0; i < 2; i++) {
                if (self.homeBetOption.betOption.betLcOption[i]) {
                    count++;
                }
            }
        } break;
        case GameTypeJcNone: {
            for (int i = 0; i < 3; i++) {
                if (self.homeBetOption.betOption.betJczqOption[i]) {
                    count++;
                }
            }

        } break;

        default:
            break;
    }

    return count;
}
//设置默认选择选项
- (NSInteger)setDefaultSelected:(GameTypeId)gameType {
    HomeOption option = self.homeBetOption.betOption;

    int index = 0;

    switch (gameType) {
        case GameTypeLcNone: {
            if ([self.spListArray[0] floatValue] > [self.spListArray[1] floatValue]) {
                option.betLcOption[0] = 1;
                index = 0;
            } else {
                option.betLcOption[1] = 1;
                index = 1;
            }
        } break;
        case GameTypeJcNone: {
            float minSp = 0;
            for (int i = 0; i < 3; i++) {
                float sp = [self.spListArray[i] floatValue];
                if (i == 0) {
                    minSp = sp;
                    index = 0;
                } else if (sp < minSp) {
                    minSp = sp;
                    index = i;
                }
            }
            option.betJczqOption[index] = 1;

        } break;

        default:
            break;
    }

    self.homeBetOption.betOption = option;

    return index;
}

@end