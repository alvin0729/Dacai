//
//  DPGSTaskObject.m
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSTaskObject.h"

@implementation DPGSTaskObject
- (NSMutableArray *)kindArray{
    if (!_kindArray) {
        _kindArray = [NSMutableArray array];
    }
    return _kindArray;
}
@end
