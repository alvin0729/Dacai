//
//  DPBetOptionStore.m
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBetOptionStore.h"
#import "DPBetOptionStore+Private.h"
#import "BetCalculater.h"

using namespace LotteryCalculater;


@implementation DPJczqBetStore

#pragma mark -

- (int *)spfBetOption {
    return _spfBetOption;
}

- (int *)rqspfBetOption {
    return _rqspfBetOption;
}

- (int *)zjqBetOption {
    return _zjqBetOption;
}

- (int *)bqcBetOption {
    return _bqcBetOption;
}

- (int *)bfBetOption {
    return _bfBetOption;
}

- (void)setSpfBetOption:(int[3])betOption {
    memcpy(_spfBetOption, betOption, sizeof(_spfBetOption));
}

- (void)setRqspfBetOption:(int[3])betOption {
    memcpy(_rqspfBetOption, betOption, sizeof(_rqspfBetOption));
}

- (void)setZjqBetOption:(int[8])betOption {
    memcpy(_zjqBetOption, betOption, sizeof(_zjqBetOption));
}

- (void)setBqcBetOption:(int[9])betOption {
    memcpy(_bqcBetOption, betOption, sizeof(_bqcBetOption));
}

- (void)setBfBetOption:(int[31])betOption {
    memcpy(_bfBetOption, betOption, sizeof(_bfBetOption));
}

@end


@implementation DPJclqBetStore

- (void)setSfBetOption:(int [2])betOption {
    memcpy(_sfBetOption, betOption, sizeof(_sfBetOption));
}

- (void)setRfsfBetOption:(int [2])betOption {
    memcpy(_rfsfBetOption, betOption, sizeof(_rfsfBetOption));
}

- (void)setDxfBetOption:(int [2])betOption {
    memcpy(_dxfBetOption, betOption, sizeof(_dxfBetOption));
}

- (void)setSfcBetOption:(int [12])betOption {
    memcpy(_sfcBetOption, betOption, sizeof(_sfcBetOption));
}

- (int *)sfBetOption {
    return _sfBetOption;
}

- (int *)rfsfBetOption {
    return _rfsfBetOption;
}

- (int *)dxfBetOption {
    return _dxfBetOption;
}

- (int *)sfcBetOption {
    return _sfcBetOption;
}

@end

@implementation DPDltBetStore
@end

@implementation DPJczqOptimizeOption
@end
@implementation DPJczqOptimize
@end