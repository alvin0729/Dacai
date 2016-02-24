//
//  DPJczqAnalysisCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  竞彩足球投注分析视图

#import <UIKit/UIKit.h>

@class DPJczqAnalysisCell;
typedef void (^clickAnalysisBlock)(DPJczqAnalysisCell *nalysisCell);

@interface DPJczqAnalysisCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong, readonly) UILabel *rqs;
@property (nonatomic, strong, readonly) UILabel *rqWinLabel, *rqTieLabel, *rqLoseLabel;                // 让球 胜 平 负
@property (nonatomic, strong, readonly) UILabel *ratioWinLabel, *ratioTieLabel, *ratioLoseLabel;       // 胜 平 负
@property (nonatomic, strong, readonly) UILabel *historyLabel;                                         // 历史交锋
@property (nonatomic, strong, readonly) UILabel *zhanJiLabel;                                          // 近期战绩
@property (nonatomic, strong, readonly) UILabel *newestWinLabel, *newestTieLabel, *newestLoseLabel;    // 平均赔率  胜 平 负
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;                //
- (void)clearAllData;

@property (nonatomic, copy) clickAnalysisBlock clickBlock;

@end
