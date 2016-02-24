//
//  DPBetDescription.h
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBetOptionStore.h"

@interface DPBetDescription : NSObject

/**
 *  竞彩足球下单格式
 *
 *  @param optionList   [in]比赛选项数组, 最多20场比赛
 *  @param passModeList [in]过关方式数组
 *
 *  @return
 */
+ (NSString *)descriptionJczqWithOption:(NSArray<DPJczqBetStore *> *)optionList
                               passMode:(NSArray *)passModeList
                               gameType:(NSInteger)gameType
                                   note:(NSInteger)note;

/**
 *  竞彩足球优化投注下单格式
 *
 *  @param optionList   [in]比赛选项数组, 最多20场比赛
 *  @param passModeList [in]过关方式数组
 *  @param optimize     [in]优化方式
 *  @param gameType     [in]彩种
 *
 *  @return
 */
+ (NSString *)descriptionOptimizeWithOption:(NSArray<DPJczqBetStore *> *)optionList
                                   passMode:(NSArray *)passModeList
                                   optimize:(NSArray<DPJczqOptimize *> *)optimize
                                   gameType:(NSInteger)gameType;

/**
 *  竞彩篮球下单格式
 *
 *  @param optionList   [in]比赛选项数组, 最多20场比赛
 *  @param passModeList [in]过关方式数组
 *
 *  @return
 */
+ (NSString *)descriptionJclqWithOption:(NSArray<DPJclqBetStore *> *)optionList
                               passMode:(NSArray *)passModeList
                               gameType:(NSInteger)gameType
                                   note:(NSInteger)note;

/**
 *  大乐透下单格式
 *
 *  @param optionList [in]投注内容, 最多100注(中转界面的行)
 *  @param addition   [in]是否追加
 *
 *  @return
 */
+ (NSString *)descriptionDltWithOption:(NSArray<DPDltBetStore *> *)optionList addition:(BOOL)addition;

/**
 *  大乐透追号下单格式
 *
 *  @param optionList  [in]投注内容, 最多100注(中转界面的行)
 *  @param addition    [in]是否追加
 *  @param followCount [in]追号期数
 *
 *  @return
 */
+ (NSString *)descriptionDltWithOption:(NSArray<DPDltBetStore *> *)optionList addition:(BOOL)addition multiple:(NSInteger)multiple followCount:(NSInteger)followCount;

@end
