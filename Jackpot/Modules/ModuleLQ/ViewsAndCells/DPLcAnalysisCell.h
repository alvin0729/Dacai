//
//  DPLcAnalysisCell.h
//  DacaiProject
//
//  Created by sxf on 15/3/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
//篮彩分析-数据中心视图
@class DPLcAnalysisCell;
typedef void (^clickAnalysisBlock)(DPLcAnalysisCell *nalysisCell);
@interface DPLcAnalysisCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong, readonly) UILabel *rqWinLabel, *rqLoseLabel;          //让分 ；篮彩左右相反，则依次为主负，主胜
@property (nonatomic, strong, readonly) UILabel *ratioWinLabel, *ratioLoseLabel;    //大小分
@property (nonatomic, strong, readonly) UILabel *historyLabel;                      //历史交锋
@property (nonatomic, strong, readonly) UILabel *zhanJiLabel;                       //近期战绩
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
- (void)clearAllData;

@property (nonatomic, copy) clickAnalysisBlock clickBlock;
@end
