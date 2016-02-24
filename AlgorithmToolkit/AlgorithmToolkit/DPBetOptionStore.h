//
//  DPBetOptionStore.h
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 足球存储对象
@interface DPJczqBetStore : NSObject
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger rqs;
@property (nonatomic, strong) NSArray *spfSpList;
@property (nonatomic, strong) NSArray *rqspfSpList;
@property (nonatomic, strong) NSArray *zjqSpList;
@property (nonatomic, strong) NSArray *bqcSpList;
@property (nonatomic, strong) NSArray *bfSpList;
@property (nonatomic, strong) NSString *orderNumberName;
@property (nonatomic, assign) BOOL mark;

- (void)setSpfBetOption:(int[3])betOption;
- (void)setRqspfBetOption:(int[3])betOption;
- (void)setZjqBetOption:(int[8])betOption;
- (void)setBqcBetOption:(int[9])betOption;
- (void)setBfBetOption:(int[31])betOption;
@end

// 篮球存储对象
@interface DPJclqBetStore : NSObject
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) CGFloat rf;
@property (nonatomic, assign) CGFloat zf;
@property (nonatomic, strong) NSArray *sfSpList;
@property (nonatomic, strong) NSArray *rfsfSpList;
@property (nonatomic, strong) NSArray *dxfSpList;
@property (nonatomic, strong) NSArray *sfcSpList;
@property (nonatomic, strong) NSString *orderNumberName;
@property (nonatomic, assign) BOOL mark;

- (void)setSfBetOption:(int[2])betOption;
- (void)setRfsfBetOption:(int[2])betOption;
- (void)setDxfBetOption:(int[2])betOption;
- (void)setSfcBetOption:(int[12])betOption;
@end

// 大乐透存储对象
@interface DPDltBetStore : NSObject
@property (nonatomic, strong) NSMutableArray<NSNumber *> *red;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *blue;
@end

// 优化投注
@interface DPJczqOptimizeOption : NSObject
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) int gameType;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) float sp;
@end

@interface DPJczqOptimize : NSObject
@property (nonatomic, strong) NSArray<DPJczqOptimizeOption *> *options;
@property (nonatomic, assign) CGFloat spCount;
@property (nonatomic, assign) int multiple;
@end
