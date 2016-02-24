//
//  DPNoteCalculater.h
//  Jackpot
//
//  Created by wufan on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBetOptionStore.h"

// 计算结果
typedef struct {
    int64_t note;
    float max;
    float min;
} DPNoteBonusResult;

@interface DPNoteCalculater : NSObject

/**
 *  计算竞彩足球注数和奖金
 *
 *  @param optionList   [in]比赛选项数组
 *  @param passModeList [in]过关方式数组
 *
 *  @return 返回 注数, 最大奖金, 最小奖金
 */
+ (DPNoteBonusResult)calcJczqWithOption:(NSArray *)optionList passMode:(NSArray *)passModeList;

/**
 *  计算竞彩篮球注数和奖金
 *
 *  @param optionList   [in]比赛选项数组
 *  @param passModeList [in]过关方式数组
 *
 *  @return 返回 注数, 最大奖金, 最小奖金
 */
+ (DPNoteBonusResult)calcJclqWithOption:(NSArray *)optionList passMode:(NSArray *)passModeList;

/**
 *   计算大乐透注数
 *
 *  @param red  [in]红球选项
 *  @param blue [in]蓝球选项
 *
 *  @return 注数
 */
+ (int)calcDltWithRed:(int [])red blue:(int [])blue;

+ (int)calcDltWithRedTuo:(int)redTuo redDan:(int)redDan blueTuo:(int)blueTuo blueDan:(int)blueDan;


/**
 *  计算奖金优化
 *
 *  @param optionList   [in]比赛选项数组
 *  @param passModeList [in]过关方式数组
 *  @param note         [in]总注数, 即 总金额/2
 *
 *  @return
 */
+ (NSArray<DPJczqOptimize *> *)optimizeJczqWithOption:(NSArray<DPJczqBetStore *> *)optionList passMode:(NSArray *)passModeList note:(NSInteger)note output:(DPNoteBonusResult *)output;

@end
