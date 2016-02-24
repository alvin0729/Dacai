//
//  DPLTDltViewController.m
//  DacaiProject
//
//  Created by sxf on 15/1/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPAlterViewController.h"
#import "DPLBDltViewController.h"
#import "DPLTDltViewController.h"
@protocol IndroduceViewDelegate;

//追加投注弹框
@interface IndroduceView : UIView
@property (nonatomic, weak) id<IndroduceViewDelegate> delegate;
@end

@protocol IndroduceViewDelegate <NSObject>
//取消弹框
- (void)cancle:(IndroduceView *)view;
@end

@implementation IndroduceView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self buildLayout];
    }
}

/**
 *  行视图
 *
 *  @param top        顶部位置
 *  @param off        距离顶部多少
 *  @param bgcolor    背景颜色
 *  @param heigh      行高度
 *  @param BaseView   行所在视图
 *  @param title1     第一列数据
 *  @param title2     第二列数据
 *  @param titlecolor 第二列字的颜色
 *  @param fonts      字大小
 *
 *  @return
 */
- (UIView *)creaTableLayout:(MASViewAttribute *)top
                     offset:(NSInteger)off
                     bgCloor:(UIColor *)bgcolor
                      heigh:(NSInteger)heigh
                  superView:(UIView *)BaseView
                   titleFir:(NSString *)title1
                   titleSec:(NSString *)title2
                 titlecolor:(UIColor *)titlecolor
                  titleFont:(UIFont *)fonts
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = bgcolor;
    backView.layer.borderColor = UIColorFromRGB(0xDEDBD5).CGColor;
    backView.layer.borderWidth = 1;
    [BaseView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top).offset(off);
        make.width.equalTo(BaseView);
        make.centerX.equalTo(BaseView);
        make.height.equalTo(@(heigh));
    }];

    UILabel *gradeLabel = [[UILabel alloc] init];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.layer.borderWidth = 0;
    gradeLabel.font = fonts;
    gradeLabel.backgroundColor = [UIColor clearColor];
    gradeLabel.text = title1;
    gradeLabel.textColor = UIColorFromRGB(0x686868);
    [backView addSubview:gradeLabel];

    UILabel *line1 = [[UILabel alloc] init];
    line1.textAlignment = NSTextAlignmentCenter;
    line1.layer.borderWidth = 0;
    line1.font = [UIFont dp_systemFontOfSize:11];
    line1.backgroundColor = [UIColor clearColor];
    line1.text = @"|";
    line1.textColor = UIColorFromRGB(0xDEDBD5);
    [backView addSubview:line1];

    UILabel *precentLabel = [[UILabel alloc] init];
    precentLabel.textAlignment = NSTextAlignmentCenter;
    precentLabel.layer.borderWidth = 0;
    precentLabel.font = fonts;
    precentLabel.backgroundColor = [UIColor clearColor];
    precentLabel.text = title2;
    precentLabel.textColor = titlecolor;
    [backView addSubview:precentLabel];

    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(backView.mas_width).multipliedBy(0.6);
        make.top.equalTo(backView.mas_top);
        make.left.equalTo(backView);
        make.height.equalTo(backView);
    }];

    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.left.equalTo(gradeLabel.mas_right);
        make.width.equalTo(@2);
        make.height.equalTo(backView);
    }];

    [precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.right.equalTo(backView);
        make.left.equalTo(line1.mas_right);
        make.height.equalTo(backView);
    }];

    return backView;
}
- (void)buildLayout {
    self.backgroundColor = [UIColor dp_flatBackgroundColor];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"追加投注奖金规则";
    titleLabel.font = [UIFont dp_systemFontOfSize:17.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:titleLabel];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = UIColorFromRGB(0xDEDBD5).CGColor;
    [self addSubview:backView];

    UILabel *egLabel = [[UILabel alloc] init];
    egLabel.text = @"例如：投一注2元的大乐透，若追加投注则投注金额为2+2x50%=3元，若中奖，奖金追加额度参考上面的表格。";
    egLabel.font = [UIFont dp_systemFontOfSize:11.0];
    egLabel.backgroundColor = [UIColor clearColor];
    egLabel.textAlignment = NSTextAlignmentCenter;
    egLabel.textColor = UIColorFromRGB(0xb9b0b1);
    egLabel.textAlignment = NSTextAlignmentLeft;
    egLabel.numberOfLines = 0;
    [self addSubview:egLabel];

    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor dp_flatRedColor];
    confirmButton.layer.cornerRadius = 8;
    confirmButton.titleLabel.font = [UIFont dp_boldSystemFontOfSize:17.0];
    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pv_cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.9);
        make.top.equalTo(self).offset(15);
        make.height.equalTo(@17);

    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(13);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.equalTo(@125);
    }];

    [egLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.equalTo(backView.mas_bottom).offset(5);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self).offset(-20);
    }];

    UIView *view1 = [self creaTableLayout:backView.mas_top offset:0 bgCloor:UIColorFromRGB(0xF1EFEA) heigh:23 superView:backView titleFir:@"等级" titleSec:@"奖金追加额度" titlecolor:UIColorFromRGB(0xbbb2b2) titleFont:[UIFont systemFontOfSize:11]];
    UIView *view2 = [self creaTableLayout:view1.mas_bottom offset:-1 bgCloor:[UIColor clearColor] heigh:35 superView:backView titleFir:@"一等奖、二等奖" titleSec:@"+60%" titlecolor:[UIColor dp_flatRedColor] titleFont:[UIFont systemFontOfSize:12]];
    UIView *view3 = [self creaTableLayout:view2.mas_bottom offset:-1 bgCloor:[UIColor clearColor] heigh:35 superView:backView titleFir:@"三等奖、四等奖、五等奖" titleSec:@"+50%" titlecolor:[UIColor dp_flatRedColor] titleFont:[UIFont systemFontOfSize:12]];
    [self creaTableLayout:view3.mas_bottom offset:-1 bgCloor:[UIColor clearColor] heigh:35 superView:backView titleFir:@"六等奖" titleSec:@"不追加" titlecolor:UIColorFromRGB(0x686868) titleFont:[UIFont systemFontOfSize:12]];
}

- (void)pv_cancle {
    DPLog(@"我知道了===");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancle:)]) {
        [self.delegate cancle:self];
    }
}

@end

//大乐透中转
@interface DPLTDltViewController () <IndroduceViewDelegate>

@end

@implementation DPLTDltViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
//获取彩种信息
- (NSInteger)gameType {
    return GameTypeDlt;
}

- (void)buildLayout {
    [super buildLayout];
    [self.view addSubview:self.timeView];
    [self.view sendSubviewToBack:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@33);

    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.timeView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-39);    //现在合作协议放下边固定了，因此需减去他的高度
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLBDltViewController *vc = [[DPLBDltViewController alloc] init];
    vc.indexPathRow = indexPath.row;

    //    DPBigLotteryVC *vc=[[DPBigLotteryVC alloc]init];
    //    vc.indexpathRow = indexPath.row;
    //    [vc jumpToSelectPage:(int)indexPath.row gameType:[self.viewModel buyTypeForOneRow:(int)indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)customStyle {
    //    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
}
//判断控制器是否是投注页面
- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPLBDltViewController class]];
}
//更新倒计时
- (void)upDateSpaceTime {
    [self.timeView timeInfoString:self.viewModel.countDownAttString];
    [self.timeView bonusString:self.viewModel.bonusMoney];
    self.bottomView.mulTotal = self.viewModel.globalMultiple;
    [self.bottomView mulLabelText:[NSString stringWithFormat:@"%ld倍", self.viewModel.globalMultiple]];
    [self.bottomView bonusLabel:self.viewModel.globalSurplusText];
    //    [self.timeView bonusString:self.viewModel.bonusMoney];
}
// 大乐透加倍投注介绍
- (void)onBtnIntroduce
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIViewController *viewController = [[UIViewController alloc] init];

    IndroduceView *Intview = [[IndroduceView alloc] init];
    Intview.alpha = 1;
    Intview.layer.cornerRadius = 10;
    Intview.backgroundColor = [UIColor blackColor];
    Intview.delegate = self;
    [viewController.view addSubview:Intview];
    [Intview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(256, 295));
        make.centerY.equalTo(viewController.view.mas_centerY);
        make.centerX.equalTo(viewController.view.mas_centerX);
    }];
    [self dp_showViewController:viewController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

//是否追加投注
- (void)onBtnaddition:(BOOL)isAddition {
    self.viewModel.addition = isAddition;
    [self.tableView reloadData];
}
//添加一注
- (void)onBtnAdd {
    [self.view endEditing:YES];
    DPLBDltViewController *vc = [[self.viewModel.lotteryClass alloc] init];
    vc.dataModel.gameIndex = self.viewModel.gameIndex;
    [self.navigationController pushViewController:vc animated:YES];
}
//追加投注介绍
- (void)cancle:(IndroduceView *)view {
    [view.dp_viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
