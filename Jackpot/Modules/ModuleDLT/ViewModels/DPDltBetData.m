//
//  DPDltBetData.m
//  Jackpot
//
//  Created by sxf on 15/8/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPDltBetData.h"

@implementation DPDltBetData

- (instancetype)init {
    if (self = [super init]) {
        self.red = [NSMutableArray array];
        self.blue = [NSMutableArray array];
    }
    return self;
}
@end
