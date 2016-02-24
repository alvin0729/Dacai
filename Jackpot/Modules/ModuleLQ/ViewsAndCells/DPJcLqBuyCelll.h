//
//  DPJcLqBuyCelll.h
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//篮彩投注单元格

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DPJcLqBuyCellEvent) {
    DPJcLqBuyCellEventMore,
    DPJCLqBuyCellEventOption,
};
@protocol DPJcLqBuyCellDelegate;
@interface DPJcLqBuyCelll : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;    //彩种类型
@property (nonatomic, assign) id<DPJcLqBuyCellDelegate> delegate;

@property (nonatomic, strong, readonly) UILabel *competitionLabel;    //赛事号
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;      //赛事名字
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;      // start time or end time 截止时间
@property (nonatomic, strong, readonly) UIImageView *analysisView;    //分析
@property (nonatomic, strong, readonly) UIImageView *htSpfDGView;     // 单关标志
@property (nonatomic, strong, readonly) UIImageView *htRqDGView;
@property (nonatomic, strong, readonly) UIImageView *otherDGView;    //其他单玩法单关(除混投)

@property (nonatomic, strong, readonly) UILabel *homeNameLabel;    //主队名字
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;    //客队名字
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;    //主队排名
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;    //客队排名
@property (nonatomic, strong, readonly) UILabel *middleLabel;      //中间   VS  让球数

@property (nonatomic, strong, readonly) UIButton *moreButton;    //更多玩法
@property (nonatomic, strong, readonly) UILabel *rangfenLabel;
@property (nonatomic, strong, readonly) UILabel *dxfLabel;

@property (nonatomic, strong, readonly) UILabel *rfTitleLabel;     //让分
@property (nonatomic, strong, readonly) UILabel *dxfTitleLabel;    //比分

@property (nonatomic, strong, readonly) UILabel *rfNoDataLabel;     //让分
@property (nonatomic, strong, readonly) UILabel *dxfNoDataLabel;    //比分

- (void)buildLayout;
- (void)analysisViewIsExpand:(BOOL)isExpand;    //箭头变化
// 135: 混投
// 131: 胜负
// 132: 让分胜负
// 134: 大小分
// 133: 胜分差

@property (nonatomic, strong, readonly) NSArray *options131;
@property (nonatomic, strong, readonly) NSArray *options132;
@property (nonatomic, strong, readonly) NSArray *options133;
@property (nonatomic, strong, readonly) NSArray *options134;
@end

@protocol DPJcLqBuyCellDelegate <NSObject>
@optional
- (void)jcLqBuyCell:(DPJcLqBuyCelll *)cell event:(DPJcLqBuyCellEvent)event info:(NSDictionary *)info;
- (void)jcLqBuyCellInfo:(DPJcLqBuyCelll *)cell;
@end