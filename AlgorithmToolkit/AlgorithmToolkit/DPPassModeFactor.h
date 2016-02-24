//
//  DPPassModeFactor.h
//  Jackpot
//
//  Created by wufan on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *GetPassModeName(int passModeTag);

@interface DPPassModeFactor : NSObject

/**
 *  获取自由过关方式
 *
 *  @param types      [in]选中彩种数组
 *  @param matchCount [in]选中比赛场数
 *  @param markCount  [in]胆的个数
 *
 *  @return 过关方式(int类型)数组, 没有匹配的过关方式则返回 nil
 */
+ (NSArray *)freedomWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount;

/**
 *  获取自由过关方式
 *
 *  @param types      [in]选中彩种数组
 *  @param matchCount [in]选中比赛场数
 *  @param markCount  [in]胆的个数
 *  @param allSingle  [in]是否所有比赛支持单关
 *
 *  @return 过关方式(int类型)数组, 没有匹配的过关方式则返回 nil
 */
+ (NSArray *)freedomWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount allSingle:(BOOL)allSingle;

/**
 *  获取自由过关方式
 *
 *  @param types      [in]选中彩种数组
 *  @param matchCount [in]选中比赛场数
 *  @param markCount  [in]胆的个数
 *
 *  @return 过关方式(int类型)数组, 没有匹配的过关方式则返回 nil
 */
+ (NSArray *)combineWithTypes:(NSArray *)types matchCount:(NSInteger)matchCount markCount:(NSInteger)markCount;

@end
