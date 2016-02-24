//
//  DPJczqOptimizeModel.h
//  Jackpot
//
//  Created by Ray on 15/12/10.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "Jczq.pbobjc.h"
#import <Foundation/Foundation.h>

@interface DPOptimizeMatch : NSObject

@property (nonatomic, strong) NSString *matchName;       //赛事名
@property (nonatomic, strong) NSString *homeTeamName;    //主队名
@property (nonatomic, strong) NSString *awayTeamName;    //客队名
@property (nonatomic, strong) NSString *typeName;        //彩种名
@property (nonatomic, strong) NSString *spNum;           //sp

@end

@interface PBMJczqMatch (category)
@property (nonatomic, assign) NSInteger matchCode;

@end

static NSString *rqspfNames[] = {@"让胜", @"让平", @"让负"};

static NSString *bfNames[] = {
    @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
    @"0:0", @"1:1", @"2:2", @"3:3", @"平其他",
    @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5", @"1:5", @"2:5", @"负其他",
};
static NSString *zjqNames[] = {@"0球", @"1球", @"2球", @"3球", @"4球", @"5球", @"6球", @"7+球"};
static NSString *bqcNames[] = {@"胜-胜", @"胜-平", @"胜-负", @"平-胜", @"平-平", @"平-负", @"负-胜", @"负-平", @"负负"};
static NSString *spfNames[] = {@"胜", @"平", @"负"};

@interface DPJczqOptimizeModel : NSObject

/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL unfold;

/**
 *  过关方式
 */
@property (nonatomic, strong) NSString *passName;

@property (nonatomic, strong, readonly) NSString *cellIdentifyStr;

/**
 *  赛事数组
 */
@property (nonatomic, strong) NSMutableArray<DPOptimizeMatch *> *matchInfoArray;
/**
 *  注数
 */
@property (nonatomic, assign) NSInteger betNumber;

/**
 *  单注金额
 */
@property (nonatomic, assign) CGFloat betPrice;
/**
 *  标示符
 */
@property (nonatomic, assign) NSInteger betCode;
/**
 *  标题字符串
 *
 *  @return 字符串
 */
- (NSString *)gotTitleString;
/**
 *  sp值
 *
 *  @param match  match
 *  @param option DPJczqOptimizeOption
 *
 *  @return sp
 */
- (NSString *)gotSpWithMatch:(PBMJczqMatch *)match optiion:(DPJczqOptimizeOption *)option;
/**
 *  彩种名字符串
 *
 *  @param option DPJczqOptimizeOption
 *
 *  @return 字符串
 */
- (NSString *)gotGameTypeNameWithOption:(DPJczqOptimizeOption *)option;

@end
