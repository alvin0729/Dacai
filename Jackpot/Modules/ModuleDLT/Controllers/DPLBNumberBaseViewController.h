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
#import "DPNavigationTitleButton.h"
#import "DPNavigationMenu.h"
#import "DPLBNumberCells.h"
#import "SevenSwitch.h"
#import "DPLTNumberBaseViewController.h"
#import <MSWeakTimer/MSWeakTimer.h>
@class DPLTNumberBaseViewController;
#define TrendDragHeight 235

static BOOL userPreferSwitchOn = YES;    // 遗漏值打开与否用户选择偏好

@interface DPLBNumberBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DPLBCellDelegateProtocol> {
@protected
    GameTypeId _gameType;//彩种类型
    UIScrollView *_numberTable;
    UIImageView *_headerView;
    DPNavigationTitleButton *_titleButton;
    UIView *_menu;
    UITableView *_trendTableView;
    UILabel *_zhushuLabel;
    DPLTNumberBaseViewController __weak *_tranViewController;
    UIView *_controlView;

    UILabel *_labelShow;
    //    UILabel* _labelShow2 ;
    //    UILabel* _firstLab  ;
    //    UILabel* _secondLab ;
    NSMutableArray *_recentWinArray;
    int _index;
    UIImageView *_adView;
}

@property (nonatomic, assign) NSInteger indexPathRow;    // 中转页面索引
@property (nonatomic, strong, readonly) id<DPLBNumberCommonDataSource, DPLBNumberHandlerDataSource> dataModel;
@property (nonatomic, strong, readonly) UIImageView *headerView;//头部倒计时
@property (nonatomic, strong, readonly) UIScrollView *numberTable;//投注
@property (nonatomic, strong, readonly) UITableView *trendTableView;//走势
@property (nonatomic, strong, readonly) UILabel *zhushuLabel;//注数
@property (nonatomic, strong, readonly) UIView *bottomView;//底部
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;//玩法选择按钮
@property (nonatomic, strong, readonly) UIButton *digitalRandomBtn;    // 摇一摇按钮
@property (nonatomic, strong, readonly) UIView *menu;                  // 标题下拉框
@property (nonatomic, strong, readonly) NSLayoutConstraint *scrollTopConstraint;
@property (nonatomic, strong) UILabel *deadlineTimeLab, *bonusLab;    //截止时间，奖池
@property (nonatomic, strong) UIView *controlView;                    // table header
@property (nonatomic, strong) SevenSwitch *sevenSwitch;//遗漏值开关
@property (nonatomic, weak, readonly) DPLTNumberBaseViewController *tranViewController;//中转
@property (nonatomic, strong) UIImageView *gonglueArrow;

@property (nonatomic, strong) UIImageView *adView;    //广告
@property (nonatomic, strong) MSWeakTimer *timer;//倒计时


- (void)layOutTopView;
- (void)layOutBottomView;
- (void)buildYilouSwitch;                                              // 摇一摇和遗漏布局
- (void)customBuild;                                                   // 自定义样式
- (void)buildNavigationStyle;                                          // nav 布局
- (void)reloadSelectTableView:(int)titleIndex;                         // Menu index change
- (void)buyCell:(UITableViewCell *)cell touchUp:(UIButton *)button;    // cell delegate
//- (void)clearAllSelectedData;                                          // 清除所有选中数据
- (void)calculateZhuShu;    // 重新计算注数刷新界面
- (void)submitBtnClick;//提交到中转页面
- (void)btnOnBack;    // left nav click
- (void)btnOnMore;//左侧更多
- (void)timeSpaceNotify;
- (void)turnArrow;//点击箭头
- (void)pvt_onMatchInfo;

//高概率
- (void)gonglvBottomView;

- (void)pvt_switchAction:(SevenSwitch *)sender;
- (UIViewController *)getTrendVC;             // 生成走势图controller 子类实现
- (UIViewController *)getHighNumberListVC;    //生成高概率排行  子类实现
@end
