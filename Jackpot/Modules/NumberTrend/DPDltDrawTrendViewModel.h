//
//  DPDltDrawTrendViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPDltDrawTrendViewModelDelegate;
@interface DPDltDrawTrendViewModel : NSObject
@property (nonatomic, weak) id<DPDltDrawTrendViewModelDelegate> delegate;

/**
 *  是否有数据
 */
- (BOOL)hasData;

/**
 *  拉取数据
 */
- (void)fetch;

/**
 *  获取期号
 *
 *  @param gameNames [out]期号数组
 *  @param count     [in]获取的期数
 */
- (void)getChartGameNames:(int[200])gameNames count:(int)count;

/**
 *  获取常规走势
 *
 *  @param redValue  [out]红球走势
 *  @param blueValue [out]蓝球走势
 *  @param count     [in]获取的期数
 */
- (void)getChartNormalRed:(int[200][35])redValue blue:(int[200][12])blueValue count:(int)count;

/**
 *  获取三区比一区走势
 *
 *  @param redValue  [out]红球走势
 *  @param areaValue [out]一区走势
 *  @param count     [in]获取的期数
 */
- (void)getChartOneAreaRed:(int[200][12])redValue area:(int[200][6])areaValue count:(int)count;

/**
 *  获取三区比二区走势
 *
 *  @param redValue  [out]红球走势
 *  @param areaValue [out]二区走势
 *  @param count     [in]获取的期数
 */
- (void)getChartTwoAreaRed:(int[200][11])redValue area:(int[200][6])areaValue count:(int)count;

/**
 *  获取三区比三区走势
 *
 *  @param redValue  [out]红球走势
 *  @param areaValue [out]三区走势
 *  @param count     [in]获取的期数
 */
- (void)getChartThreeAreaRed:(int[200][12])redValue area:(int[200][6])areaValue count:(int)count;

/**
 *  获取数据统计
 *
 *  @param value [out]统计结果
 *  @param type  [in]0表示常规, 1表示一区, 2表示二区, 3表示三区
 *  @param count [in]0表示统计所有期数, >0表示统计指定count期数
 */
- (void)getChartStatisticsValue:(int[4][47])value type:(int)type count:(int)count;

@end

@protocol DPDltDrawTrendViewModelDelegate <NSObject>
@optional
- (void)trendViewModel:(DPDltDrawTrendViewModel *)viewModel error:(NSError *)error;
@end