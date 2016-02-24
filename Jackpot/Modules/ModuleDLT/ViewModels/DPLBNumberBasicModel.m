//
//  DPLBNumberBasicModel.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLBNumberBasicModel.h"
#import "DPLBCellViewModel.h"
#import "DPLBDltDataModel.h"

@implementation DPLBNumberBasicModel
@synthesize isOpenSwitch = _isOpenSwitch;
@synthesize indexPathRow = _indexPathRow;
@synthesize gameIndex = _gameIndex;
@synthesize ballUIDict = _ballUIDict;
@synthesize trendDragHeight = _trendDragHeight;
+ (id<DPLBNumberCommonDataSource, DPLBNumberHandlerDataSource>)numberDataModelForGameType:(GameTypeId)gameType
{
    switch (gameType) {
                case GameTypeDlt:
            return [[DPLBDltDataModel alloc] init];
        
        default:
            DPAssert(NO);
            return nil;
    }
}
- (instancetype)init
{
    if (self = [super init]) {
        _isOpenSwitch = YES;
        _indexPathRow = - 1;
        _gameIndex = 0;
    }
    return self;
}
//更多内容
- (NSArray *)dropDownListArray
{
         return @[@"走势图", @"开奖公告", @"玩法介绍", @"帮助"];
}
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    
    for(int i=0;i<total;i++){
        target[i]=0;
    }

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random()%((total - i) == 0?1:(total-i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (NSInteger)trendDragHeight
{
    return 235;
}
- (NSString *)trendCellClass
{
    // 子类重写
    return @"";
}
- (BOOL)hasData
{
    return NO;
}
@end

