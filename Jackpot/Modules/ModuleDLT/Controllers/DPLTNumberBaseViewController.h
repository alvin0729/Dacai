//
//  DPNumberBaseViewController.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  数字中转基础页面

#import <UIKit/UIKit.h>
#import "DPLTNumberProtocol.h"
#import "DPDigitalBottomView.h"
#import "DPDigitalTimeSpaceView.h"
#import "DPAgreementLabel.h"

@class DPLTNumberViewModel;

@interface DPLTNumberBaseViewController : UIViewController <DPLTNumberMutualDelegate,DPLTNumberTimerDataSource,UIGestureRecognizerDelegate,    UITableViewDelegate> {
}

@property (nonatomic, assign, readonly) NSInteger gameType;
@property (nonatomic, strong, readonly) id<DPLTNumberBaseProtocol,
                                           DPLTNumberMainDataSource,
                                           DPLTNumberMutualDataSource,
                                           DPLTNumberTimerDataSource> viewModel;
@property (nonatomic, strong, readonly) DPDigitalTimeSpaceView *timeView;//倒计时视图
// 控件
@property (nonatomic, strong, readonly) UITableView *tableView; //选号列表view
@property (nonatomic, strong, readonly) DPDigitalBottomView *bottomView;     // 底部交互view
@property (nonatomic, strong, readonly) DPAgreementLabel *agreementLabel; // 同意协议
@property (nonatomic,assign)NSInteger openType;
//@property (nonatomic, assign) int gameIndex; // 玩法，如果彩种无玩法之分，默认为-1
// 事件
// 返回
- (void)onBtnBack;
 // 手动添加
- (void)onBtnAdd;
 // 自定义样式, 布局
- (void)buildLayout;
- (void)customStyle;
// 刷新底部金额数据
- (void)dp_refreshBottomData;
//更新倒计时
- (void)upDateSpaceTime;
- (BOOL)isBuyController:(UIViewController *)viewController;
// 隐藏蒙版
- (void)pvt_hiddenCoverView:(BOOL)hidden;
// 绑定逻辑
//- (void)eventBinding;

@end
