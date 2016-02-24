//
//  DPLBNumberBaseViewController.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//
//  数字彩投注页面基类
//
//  Dacai Project Lottery Buy(DPLB)
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPNavigationTitleButton.h"
#import "DPNavigationMenu.h"
#import "DPLBNumberCells.h"
#import "SevenSwitch.h"
#import "DPLTNumberBaseViewController.h"
#import <MSWeakTimer/MSWeakTimer.h>
@class DPLTNumberBaseViewController;
#define TrendDragHeight  235

static BOOL userPreferSwitchOn = YES; // 遗漏值打开与否用户选择偏好

@interface DPLBNumberBaseViewController : DPBaseViewController <UITableViewDataSource, UITableViewDelegate, DPLBCellDelegateProtocol>
{
    @protected
    GameTypeId                  _gameType;
    UIScrollView                *_numberTable;
    UIImageView                      *_headerView;
    DPNavigationTitleButton     *_titleButton;
    UIView                      *_menu;
    UITableView                 *_trendTableView;
    UILabel                     *_zhushuLabel;
    DPLTNumberBaseViewController  __weak *_tranViewController;
    UIView                      *_controlView;
    
    UILabel* _labelShow ;
//    UILabel* _labelShow2 ;
//    UILabel* _firstLab  ;
//    UILabel* _secondLab ;
    NSMutableArray* _recentWinArray ;
    int _index ;
    UIImageView* _adView ;
}

@property (nonatomic, assign) NSInteger indexPathRow;                                  // 中转页面索引
@property (nonatomic, strong, readonly) id <DPLBNumberCommonDataSource, DPLBNumberHandlerDataSource> dataModel;
@property (nonatomic, strong, readonly) UIImageView *headerView;
@property (nonatomic, strong, readonly) UIScrollView *numberTable;
@property (nonatomic, strong, readonly) UITableView *trendTableView;
@property (nonatomic, strong, readonly) UILabel *zhushuLabel;
@property (nonatomic, strong, readonly) UIView *bottomView;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong, readonly) UIButton *digitalRandomBtn;                     // 摇一摇按钮
@property (nonatomic, strong, readonly) UIView *menu;                                   // 标题下拉框
@property (nonatomic, strong, readonly) NSLayoutConstraint *scrollTopConstraint;
@property (nonatomic, strong) UILabel *deadlineTimeLab, *bonusLab;           //截止时间，奖池
@property (nonatomic, strong) UIView *controlView;              // table header
@property (nonatomic, strong) TTTAttributedLabel *introduceLab;           //截止时间，奖池
@property (nonatomic, strong) SevenSwitch *sevenSwitch;
@property(nonatomic,weak,readonly)DPLTNumberBaseViewController *tranViewController;
@property(nonatomic,strong)UIImageView *gonglueArrow;

@property(nonatomic,strong) UIImageView* adView ; //广告
@property (nonatomic, strong) MSWeakTimer *timer;



- (void)layOutTopView;
- (void)layOutBottomView;
- (void)buildYilouSwitch;                                                               // 摇一摇和遗漏布局
- (void)customBuild;                                                                    // 自定义样式
- (void)buildNavigationStyle;                                                           // nav 布局
- (void)reloadSelectTableView:(int)titleIndex;                                          // Menu index change
- (void)buyCell:(UITableViewCell *)cell touchUp:(UIButton *)button;                     // cell delegate
- (void)clearAllSelectedData;                                                           // 清除所有选中数据
- (void)calculateZhuShu;                                                                // 重新计算注数刷新界面
- (void)submitBtnClick;
- (void)btnOnBack;                                                                     // left nav click
- (void)btnOnMore;
- (void)timeSpaceNotify;
- (void)turnArrow;
-(void)pvt_onMatchInfo;

//高概率
-(void)gonglvBottomView;
-(void)moveLabel;

- (void)pvt_switchAction:(SevenSwitch *)sender ;
- (UIViewController *)getTrendVC; // 生成走势图controller 子类实现
-(UIViewController *)getHighNumberListVC;//生成高概率排行  子类实现
@end
