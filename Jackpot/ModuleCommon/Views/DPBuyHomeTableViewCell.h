//
//  DPBuyHomeTableViewCell.h
//  Jackpot
//
//  Created by sxf on 15/7/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  首页注释

#import "DPHomeDateModel.h"
#import "DPJcdgTableCells.h"
#import "DPTHomeBuyViews.h"
#import <UIKit/UIKit.h>

#define kSingleViewTagBase 20
#define KCommunityButtonTag 30

@protocol DPHomeBallViewCellDelegate;

//任选一注（大乐透）
@interface DPSelectedBallViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *lotteryTitle;    //标题
@property (nonatomic, strong, readonly) UIButton *payButton;      //投注
@property (nonatomic, strong) NSString *gameName;                 //期号

@property (nonatomic, strong) NSString *endTime;    //结束时间

@property (nonatomic, strong, readonly) UILabel *bonusMoney;    //奖池
@property (nonatomic, strong, readonly) NSArray *balls;         //小球数组
@property (nonatomic, weak) id<DPHomeBallViewCellDelegate> delegate;

@end
//选择竞彩系列
@interface DPSelectedJCViewCell : UITableViewCell <DPHomeBuyJCViewDelegate>

@property (nonatomic, assign) int gameCount;                       // 比赛场次
@property (nonatomic, assign) int gameFirst;                       //默认那个页面 足彩---篮彩
@property (nonatomic, strong) NSMutableArray *singleTeamsArray;    // 存放滚动的单一视图
@property (nonatomic, weak) id<DPHomeBallViewCellDelegate> delegate;

/**
 *  更新快速投注竞彩数据
 *
 *  @param quickBet PBMHomePage_SportQuickBet
 */
- (void)updateHomeBuyJCData:(PBMHomePage_SportQuickBet *)quickBet;

@end

//彩种投注cell
@interface DPLotteryInfoViewCell : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPHomeBallViewCellDelegate> delegate;
//设置图片
- (void)setlottteryImage:(UIImage *)image;
//设置彩种名称
- (void)settitleLabel:(NSString *)title;
//设置彩种宣传文字
- (void)setadvertiseLabel:(NSString *)advertise;
//设置奖池
- (void)setbonusMoneyLabel:(NSString *)BonusMoney;
//设置参与数
- (void)setparticipantsLabel:(NSString *)numberString;
//设置角标
- (void)setMarkLabel:(NSString *)markString;
@end

//社区板块
@interface DPCommunityViewCell : UITableViewCell

@property (nonatomic, assign) id<DPHomeBallViewCellDelegate> delegate;
//获取社区信息
- (void)communityWithArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;
//获取描述标签
- (UILabel *)labelForIndex:(NSInteger)index;
//获取logo
- (UIImageView *)imageViewForIndex:(NSInteger)index;
@end

@protocol DPHomeBallViewCellDelegate <NSObject>

@optional

- (void)updateDataForTime;
//随机一注
- (void)randomSelectedBallViewCell:(DPSelectedBallViewCell *)cell;
//付款-双色球
- (void)payForSelectedBallViewCell:(DPSelectedBallViewCell *)cell;
//获取社区点击信息
- (void)buttonClickForCommunityView:(NSInteger)index;
//获取点击的彩种
- (void)buttonClickForLotteryView:(GameTypeId)gameType;

//竞彩选择
- (void)jcSelectedView:(DPHomeBuyJCView *)view isSelected:(BOOL)isSelected index:(NSInteger)index gameType:(GameTypeId)gameType;

- (void)jcSelectedView:(DPHomeBuyJCView *)view isSelected:(BOOL)isSelected index:(NSInteger)index gameType:(GameTypeId)gameType isUserTouch:(BOOL)isTouched;

//竞彩快速投注付款
- (void)jcSelectedToPay:(GameTypeId)gameType;

//竞彩快速投注玩法介绍
- (void)jcGameInfoView:(DPHomeBuyJCView *)view;
@end
