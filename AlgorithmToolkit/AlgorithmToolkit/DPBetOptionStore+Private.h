//
//  DPBetOptionStore+Private.h
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBetOptionStore.h"
#import "BetCalculater.h"

@interface DPJczqBetStore () {
@private
    int _spfBetOption[3];
    int _rqspfBetOption[3];
    int _zjqBetOption[8];
    int _bqcBetOption[9];
    int _bfBetOption[31];
}

@property (nonatomic, assign, readonly) int *spfBetOption;
@property (nonatomic, assign, readonly) int *rqspfBetOption;
@property (nonatomic, assign, readonly) int *zjqBetOption;
@property (nonatomic, assign, readonly) int *bqcBetOption;
@property (nonatomic, assign, readonly) int *bfBetOption;

@end

@interface DPJclqBetStore () {
@private
    int _sfBetOption[2];
    int _rfsfBetOption[2];
    int _dxfBetOption[2];
    int _sfcBetOption[12];
}

@property (nonatomic, assign, readonly) int *sfBetOption;
@property (nonatomic, assign, readonly) int *rfsfBetOption;
@property (nonatomic, assign, readonly) int *dxfBetOption;
@property (nonatomic, assign, readonly) int *sfcBetOption;

@end

@interface DPJczqBetStore (Private)
@property (nonatomic, assign, readonly) LotteryCalculater::JczqCalculaterOption betOption;
@end

@interface DPJclqBetStore (Private)
@property (nonatomic, assign, readonly) LotteryCalculater::JclqCalculaterOption betOption;
@end
