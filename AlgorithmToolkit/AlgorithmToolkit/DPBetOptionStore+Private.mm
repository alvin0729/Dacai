//
//  DPBetOptionStore+Private.m
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBetOptionStore+Private.h"

using namespace LotteryCalculater;

@implementation DPJczqBetStore (Private)

- (JczqCalculaterOption)betOption {
    NSAssert(!self.orderNumberName || strlen(self.orderNumberName.UTF8String) < 20, @"failure...");
    
    JczqCalculaterOption option = { 0 };
    
    // 投注选项
    memcpy(option.betOptionSpf, self.spfBetOption, sizeof(option.betOptionSpf));
    memcpy(option.betOptionRqspf, self.rqspfBetOption, sizeof(option.betOptionRqspf));
    memcpy(option.betOptionBf, self.bfBetOption, sizeof(option.betOptionBf));
    memcpy(option.betOptionZjq, self.zjqBetOption, sizeof(option.betOptionZjq));
    memcpy(option.betOptionBqc, self.bqcBetOption, sizeof(option.betOptionBqc));
    
    // sp值
    for (int i = 0; i < 3; i++) {
        NSString *sp = [self.spfSpList objectAtIndex:i];
        option.betSpListSpf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 3; i++) {
        NSString *sp = [self.rqspfSpList objectAtIndex:i];
        option.betSpListRqspf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 31; i++) {
        NSString *sp = [self.bfSpList objectAtIndex:i];
        option.betSpListBf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 9; i++) {
        NSString *sp = [self.bqcSpList objectAtIndex:i];
        option.betSpListBqc[i] = [sp doubleValue];
    }
    for (int i = 0; i < 8; i++) {
        NSString *sp = [self.zjqSpList objectAtIndex:i];
        option.betSpListZjq[i] = [sp doubleValue];
    }
    
    // 胆
    option.mark = self.mark;
    
    // 让分数
    option.betRqs = (int)self.rqs;
    option.matchId = (int)self.matchId;
    if (self.orderNumberName) {
        strcpy(option.orderNumberName, self.orderNumberName.UTF8String);
    }
    return option;
}

@end

@implementation DPJclqBetStore (Private)

- (JclqCalculaterOption)betOption {
    NSAssert(!self.orderNumberName || strlen(self.orderNumberName.UTF8String) < 20, @"failure...");
    
    JclqCalculaterOption option = { 0 };
    
    // 投注选项
    memcpy(option.betOptionSf, self.sfBetOption, sizeof(option.betOptionSf));
    memcpy(option.betOptionRfsf, self.rfsfBetOption, sizeof(option.betOptionRfsf));
    memcpy(option.betOptionDxf, self.dxfBetOption, sizeof(option.betOptionDxf));
    memcpy(option.betOptionSfc, self.sfcBetOption, sizeof(option.betOptionSfc));
    
    // sp值
    for (int i = 0; i < 2; i++) {
        NSString *sp = [self.sfSpList objectAtIndex:i];
        option.betSpListSf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 2; i++) {
        NSString *sp = [self.rfsfSpList objectAtIndex:i];
        option.betSpListRfsf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 2; i++) {
        NSString *sp = [self.dxfSpList objectAtIndex:i];
        option.betSpListDxf[i] = [sp doubleValue];
    }
    for (int i = 0; i < 12; i++) {
        NSString *sp = [self.sfcSpList objectAtIndex:i];
        option.betSpListSfc[i] = [sp doubleValue];
    }
    
    // 胆
    option.mark = self.mark;
    
    // 让分数
    option.betRf = self.rf;
    option.betZf = self.zf;
    option.matchId = (int)self.matchId;
    if (self.orderNumberName) {
        strcpy(option.orderNumberName, self.orderNumberName.UTF8String);
    }
    return option;
}

@end

