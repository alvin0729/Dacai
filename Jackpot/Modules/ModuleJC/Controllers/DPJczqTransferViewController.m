//
//  DPJczqTransferViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAlterViewController.h"
#import "DPBetToggleControl.h"
#import "DPFlowSets.h"
#import "DPJczqDataModel.h"
#import "DPJczqOptimizeViewController.h"
#import "DPJczqTransferCell.h"
#import "DPJczqTransferViewController.h"
#import "DPJingCaiMoreView.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPPassModeView.h"
#import "DPPayRedPacketViewController.h"
#import "DPWebViewController.h"
#import "Order.pbobjc.h"
#import "Order.pbobjc.h"

@interface DPJczqTransferViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    DPJczqTransferCellDelegate,
    DPPassModeViewDelegate,
    UIGestureRecognizerDelegate,
    UITextFieldDelegate,
    UIViewControllerSwiping> {
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    UITextField *_multipleField;
    UIButton *_passModeButton;
    NSMutableSet *_selectedPassModes;    //过关方式
    DPPassModeView *_passModeView;
    UIView *_coverView;
    UIView *_agreeView;

    BOOL _isSelectedPro;    //是否选择协议
    NSMutableArray *_optionList;

    NSInteger _noteCount;    //注数

    NSInteger _maxMark;    //最多胆数
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;              //底部提交视图
@property (nonatomic, strong, readonly) UITextField *multipleField;      //投注倍数
@property (nonatomic, strong, readonly) UIButton *passModeButton;        //过关按钮
@property (nonatomic, strong, readonly) DPPassModeView *passModeView;    //过关方式
@property (nonatomic, strong, readonly) UIView *coverView;               //灰色背景（键盘弹出）
@property (nonatomic, strong, readonly) UIView *agreeView;               //同意协议
@property (nonatomic, strong) MTStringParser *rfParser;

@end

@implementation DPJczqTransferViewController
@dynamic tableView;
@dynamic configView;
@dynamic submitView;
@dynamic multipleField;
@dynamic passModeView, agreeView;
@synthesize bottomLabel = _bottomLabel, bottomBoundLabel = _bottomBoundLabel;
- (instancetype)init {
    if (self = [super init]) {
        _optionList = [[NSMutableArray alloc] init];
        _selectedPassModes = [[NSMutableSet alloc] init];

        [DPPaymentFlow pushContextWithViewController:self];
    }
    return self;
}

- (BOOL)shouldSwipeBack {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self pvt_hiddenCoverView:YES];

    [self updatePassmodelInfo:YES];
    [self calculateAllZhushu];
    _maxMark = self.passModeView.freedoms.count;

    //键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [DPPaymentFlow popContextWithViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投注确认";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    _isSelectedPro = YES;

    UIView *contentView = self.view;
    UIView *headerView = [self createHeaderView];

    // 布局
    [contentView addSubview:headerView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.coverView];
    [contentView addSubview:self.agreeView];

    [contentView addSubview:self.configView];
    [contentView addSubview:self.passModeView];
    [contentView addSubview:self.submitView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.height.equalTo(@45);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.equalTo(self.agreeView.mas_top);
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
    }];

    [self.agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.configView.mas_top);
    }];

    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.bottom.equalTo(self.passModeView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.greaterThanOrEqualTo(headerView.mas_bottom).offset(50);
    }];
    [self.passModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.submitView.mas_top);
        make.height.equalTo(@0).priorityLow();
    }];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];
    [self buildConfigLayout];
    [self pvt_buildSubmitLayout];

    // 手势, 取消键盘
    [self.view addGestureRecognizer:({
                   UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
                   tapRecognizer.delegate = self;
                   tapRecognizer;
               })];
}

- (UIView *)createHeaderView {
    UIView *contentView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view;
    });

    UIButton *addButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 添加赛事" forState:UIControlStateNormal];
        [button setImage:dp_SportLotteryImage(@"trans_add.png") forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;

        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
        [button addTarget:self action:@selector(pvt_onModify) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIButton *reselectButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@" 重新选择" forState:UIControlStateNormal];
        [button setImage:dp_SportLotteryImage(@"trans_back.png") forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
        [button addTarget:self action:@selector(pvt_onReset) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    UIView *lineView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });
    UIView *lineHView = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1]];
    });

    [contentView addSubview:addButton];
    [contentView addSubview:reselectButton];
    [contentView addSubview:lineView];
    [contentView addSubview:lineHView];

    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView.mas_centerX);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-10);
    }];
    [reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(-1);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView).offset(-10);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];

    [lineHView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.width.equalTo(@0.5);
    }];

    return contentView;
}

- (void)buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    UIView *bottomLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });

    UIView *contentView = self.configView;

    [contentView addSubview:topLine];
    [contentView addSubview:bottomLine];

    [contentView addSubview:self.passModeButton];
    [contentView addSubview:self.multipleField];

    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];

    [self.passModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
        make.width.equalTo(@75);
        make.left.equalTo(contentView).offset(15);

    }];

    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.width.equalTo(@60);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

    UILabel *leftLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"投";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    UILabel *rightLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"倍";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });

    UIButton *optimizeBtn = ({

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"  优化投注  " forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont dp_systemFontOfSize:12];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
        [btn setTitleColor:UIColorFromRGB(0x8D7C6E) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pvt_Optimize) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });

    [contentView addSubview:leftLabel];
    [contentView addSubview:rightLabel];
    [contentView addSubview:optimizeBtn];
//    if (self.gameType == GameTypeJcHt || self.gameType == GameTypeJcRqspf || self.gameType == GameTypeJcSpf) {
        optimizeBtn.hidden = NO;
//    } else {
//        optimizeBtn.hidden = YES;
//    }

    [optimizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.height.equalTo(self.passModeButton.mas_height);
        make.right.equalTo(contentView).offset(-15);
        make.width.mas_equalTo(75);

    }];

    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.right.equalTo(self.multipleField.mas_left).offset(-5);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.left.equalTo(self.multipleField.mas_right).offset(5);
    }];

    UIView *leftLine = ({

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xd9d5cc);
        view;
    });
    [contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.right.equalTo(leftLabel.mas_left).offset(-10);
    }];

    UIView *rightLine = ({

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xd9d5cc);
        view;
    });
    [contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(rightLabel.mas_right).offset(10);
    }];
}

#pragma mark - 响应事件
//键盘弹出或退出时灰色背景处理
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 0;
            }
                completion:^(BOOL finished) {
                    self.coverView.hidden = YES;
                }];
        }
    } else {
        if (self.coverView.hidden) {
            self.coverView.alpha = 0;
            self.coverView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.coverView.alpha = 1;
            }];
        }
    }
}
//取消键盘事件
- (void)pvt_onTap {
    if (self.multipleField.isEditing) {
        [self.multipleField resignFirstResponder];
    }
    if (self.passModeButton.isSelected) {
        self.passModeButton.selected = NO;

        [self pvt_adaptPassModeHeight];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }

    [self pvt_hiddenCoverView:YES];
}

- (void)pvt_onBack {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (alertView.cancelButtonIndex != buttonIndex.integerValue) {
            for (PBMJczqMatch *match in self.matchsArray) {
                [match.matchOption initializeOptionWithType:self.gameType];
            }

            if (self.navigationController.viewControllers.count > 2) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    [alertView show];
}

// 奖金优化点击事件. pop
- (void)pvt_Optimize {
    DPLog(@" 奖金优化");

    if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    }
    if ([[self getSelectedMatchArray] count] > 8) {
        [[DPToast makeText:@"8场以上比赛不允许优化"] show];
        return;
    }

    if (_noteCount > 100) {
        [[DPToast makeText:@"投注条目超出100注不允许优化"] show];
        return;
    }

    DPJczqOptimizeViewController *vc = [[DPJczqOptimizeViewController alloc] init];
    vc.multipleField.text = self.multipleField.text;
    vc.passModeLabel.text = [NSString stringWithFormat:@"过关方式：%@", self.passModeButton.titleLabel.text];
    vc.passModeList = [[_selectedPassModes allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        int pre = GetPassModeNameSuffix(obj1.integerValue);
        int nxt = GetPassModeNameSuffix(obj2.integerValue);
        if ((pre > 1 && nxt > 1 && obj1.integerValue > obj2.integerValue) ||
            (pre == 1 && nxt == 1 && obj1.integerValue > obj2.integerValue) ||
            (pre > 1 && nxt == 1)) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];

    vc.optionList = _optionList;
    vc.matchList = [self getSelectedMatchArray];
    vc.gameType = self.gameType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 底部提交界面
- (void)pvt_buildSubmitLayout {
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *contentView = self.submitView;

    [contentView addSubview:submitButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:self.bottomBoundLabel];

    UILabel *yuanLabel = ({

        UILabel *label = [[UILabel alloc] init];
        label.text = @"元";
        label.font = [UIFont dp_systemFontOfSize:14.0f];
        label.textColor = [UIColor dp_flatWhiteColor];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [contentView addSubview:yuanLabel];
    [contentView addSubview:confirmView];

    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15);

        make.centerY.equalTo(submitButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-40);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView.mas_centerY);
    }];

    [self.bottomBoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.width.lessThanOrEqualTo(@250);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBoundLabel.mas_right);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
}

- (NSInteger)pvt_markCount {
    return 0;
}

#pragma mark - 点击过关方式
- (void)pvt_onPassMode {
    int count = (int)[self getSelectedMatchArray].count;
    if (self.gameType == GameTypeJcBf) {
        if (count == 0) {
            [[DPToast makeText:@"至少选择1场比赛！"] show];
            return;
        }
    } else {
        if (count < 2) {
            if (![self isAllSignalMatch]) {
                [[DPToast makeText:@"至少选择2场比赛！"] show];
                return;
            }
        }
    }

    self.passModeButton.selected = !self.passModeButton.isSelected;

    if (self.passModeButton.selected) {
        if (self.multipleField.isEditing) {
            [self.multipleField resignFirstResponder];
        }
    }

    [self setPassModelResult:NO];

    [self.passModeView reloadData];
    [self.passModeView layoutIfNeeded];
    [self pvt_adaptPassModeHeight];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];

    if (self.passModeButton.isSelected) {
        [self pvt_hiddenCoverView:NO];
    } else {
        [self pvt_hiddenCoverView:YES];
    }
}

#pragma mark - 提交付款

- (void)pvt_onSubmit {
    if (self.gameType == GameTypeJcBf) {
        if ([self getSelectedMatchArray].count < 1) {
            [[DPToast makeText:@"至少选择1场比赛!"] show];
            return;
        }
    } else if ([self getSelectedMatchArray].count < 2) {
        if (![self isAllSignalMatch]) {
            [[DPToast makeText:@"至少选择2场比赛!"] show];
            return;
        }
    }
    if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    }
    if (self.multipleField.text.integerValue <= 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"1"];
        [self calculateAllZhushu];
        return;
    }
    if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议！"] show];
        return;
    }
    if ((_noteCount * 2 * [self.multipleField.text integerValue]) > 200000) {
        [[DPToast makeText:dp_moneyLimitWarning] show];
        return;
    }

    [self.view endEditing:YES];
    if (self.passModeButton.selected) {
        [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

    NSMutableArray *orderNumbers = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchArray].count];
    for (PBMJczqMatch *match in [self getSelectedMatchArray]) {
        [orderNumbers addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    GameTypeId typeGame = (self.gameType == GameTypeJcDg || self.gameType == GameTypeJcDgAll) ? GameTypeJcHt : self.gameType;

    NSString *urlStr = [NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%@&gameTypeId=%d", [orderNumbers componentsJoinedByString:@","], typeGame];

    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);

        [DPPaymentFlow paymentWithOrder:[self getOrderData] gameType:typeGame inViewController:self];

    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {

            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

- (void)pvt_onModify {
    [self.navigationController popViewControllerAnimated:YES];
}
//重新选择
- (void)pvt_onReset {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (buttonIndex.integerValue != alertView.cancelButtonIndex) {
            for (PBMJczqMatch *match in self.matchsArray) {
                [match.matchOption initializeOptionWithType:self.gameType];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertView show];
}

//更改过关方式
- (void)pvt_updatePassMode {
    if (_selectedPassModes.count == 0) {
        [self.passModeButton setTitle:@"过关方式" forState:UIControlStateNormal];
        [self.passModeButton setTitle:@"过关方式" forState:UIControlStateSelected];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateSelected];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"trans_input.png") forState:UIControlStateNormal];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"trans_input.png") forState:UIControlStateSelected];

        [self.passModeButton setImage:dp_SportLotteryImage(@"trans_up.png") forState:UIControlStateNormal];
        [self.passModeButton setImage:dp_SportLotteryImage(@"trans_down.png") forState:UIControlStateSelected];

    } else {
        NSArray *passModes = [[_selectedPassModes allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            int pre = GetPassModeNameSuffix(obj1.integerValue);
            int nxt = GetPassModeNameSuffix(obj2.integerValue);
            if ((pre > 1 && nxt > 1 && obj1.integerValue > obj2.integerValue) ||
                (pre == 1 && nxt == 1 && obj1.integerValue > obj2.integerValue) ||
                (pre > 1 && nxt == 1)) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];

        NSMutableArray *passModeTitles = [NSMutableArray arrayWithCapacity:_selectedPassModes.count];
        for (int i = 0; i < passModes.count; i++) {
            int passModeTag = [passModes[i] intValue];
            if (passModeTag == PASSMODE_1_1) {
                [passModeTitles addObject:@"单关"];
            } else {
                [passModeTitles addObject:[NSString stringWithFormat:@"%d串%d", GetPassModeNamePrefix(passModeTag), GetPassModeNameSuffix(passModeTag)]];
            }
        }
        NSString *title = [passModeTitles componentsJoinedByString:@", "];

        [self.passModeButton setTitle:title forState:UIControlStateNormal];
        [self.passModeButton setTitle:title forState:UIControlStateSelected];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateNormal];
        [self.passModeButton setTitleColor:[UIColor colorWithRed:0.55 green:0.49 blue:0.43 alpha:1] forState:UIControlStateSelected];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"trans_input.png") forState:UIControlStateNormal];
        [self.passModeButton setBackgroundImage:dp_SportLotteryResizeImage(@"trans_input.png") forState:UIControlStateSelected];

        [self.passModeButton setImage:dp_SportLotteryImage(@"trans_up.png") forState:UIControlStateNormal];
        [self.passModeButton setImage:dp_SportLotteryImage(@"trans_down.png") forState:UIControlStateSelected];
    }
}

//用户合买协议选择
- (void)onBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    _isSelectedPro = button.selected;
}
//打开合买代购协议
- (void)agreementLabelClick {
    DPWebViewController *webCtrl = [[DPWebViewController alloc] init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.canHighlight = NO;
    [self.navigationController pushViewController:webCtrl animated:YES];
}

#pragma mark - getter, setter

- (UIView *)agreeView {
    if (_agreeView == nil) {
        _agreeView = [[UIView alloc] init];
        _agreeView.backgroundColor = [UIColor dp_flatBackgroundColor];

        UILabel *agreeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];

            MTStringParser *parser = [[MTStringParser alloc] init];
            [parser setDefaultAttributes:({
                        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                        attr.font = [UIFont dp_systemFontOfSize:11];
                        attr.textColor = UIColorFromRGB(0xc4bcaf);
                        attr;
                    })];
            [parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x0b76d4)];

            NSString *markupText = [NSString stringWithFormat:@"同意并勾选<blue>《代购协议》</blue>其中条款 "];

            label.attributedText = [parser attributedStringFromMarkup:markupText];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementLabelClick)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            label;
        });

        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = YES;
            [button setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            button.selected = YES;
            [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });

        UILabel *redLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0xfba09b);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont dp_systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = @"方案的赔率等信息以出票后的票样为准。";
            label;
        });

        [_agreeView addSubview:agreeLabel];
        [_agreeView addSubview:redLabel];
        [_agreeView addSubview:agreementButton];

        [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_agreeView);
            make.bottom.equalTo(_agreeView).offset(-10);
        }];

        [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(redLabel.mas_top).offset(-5);
            make.centerX.equalTo(_agreeView).offset(5);
        }];

        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(agreeLabel);
            make.right.equalTo(agreeLabel.mas_left).offset(-2);
        }];
    }

    return _agreeView;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIImageView *gearView = ({
            UIImageView *imageView = [[UIImageView alloc]
                initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            UIImage *image = dp_SportLotteryImage(@"trans_bg.png");
            imageView.image = [image
                resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0,
                                                             image.dp_height - 3, 0)
                               resizingMode:UIImageResizingModeStretch];
            imageView;
        });

        _tableView.tableFooterView = gearView;
    }
    return _tableView;
}
- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _submitView;
}

- (UITextField *)multipleField {
    if (_multipleField == nil) {
        _multipleField = [[UITextField alloc] init];
        _multipleField.borderStyle = UITextBorderStyleNone;
        _multipleField.layer.cornerRadius = 3;
        _multipleField.layer.borderWidth = 0.5;
        _multipleField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
        _multipleField.backgroundColor = [UIColor clearColor];
        _multipleField.font = [UIFont dp_systemFontOfSize:12];
        _multipleField.keyboardType = UIKeyboardTypeNumberPad;
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _multipleField.delegate = self;

        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);

            line;
        });
    }
    return _multipleField;
}

- (UIButton *)passModeButton {
    if (_passModeButton == nil) {
        _passModeButton = [[UIButton alloc] init];
        [_passModeButton.titleLabel setFont:[UIFont dp_systemFontOfSize:12]];
        [_passModeButton setImage:dp_SportLotteryImage(@"trans_up.png") forState:UIControlStateNormal];
        [_passModeButton setImage:dp_SportLotteryImage(@"trans_down.png") forState:UIControlStateSelected];
        [_passModeButton addTarget:self action:@selector(pvt_onPassMode) forControlEvents:UIControlEventTouchUpInside];
        [_passModeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 55, 0, 0)];
        [_passModeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 20)];
        [_passModeButton setAdjustsImageWhenHighlighted:NO];
        [_passModeButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return _passModeButton;
}

- (DPPassModeView *)passModeView {
    if (_passModeView == nil) {
        _passModeView = [[DPPassModeView alloc] init];
        _passModeView.passModeDelegate = self;
    }
    return _passModeView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}
- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.numberOfLines = 1;
        _bottomLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomLabel.font = [UIFont dp_systemFontOfSize:14.0f];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bottomLabel.userInteractionEnabled = NO;
    }
    return _bottomLabel;
}

- (UILabel *)bottomBoundLabel {
    if (_bottomBoundLabel == nil) {
        _bottomBoundLabel = [[UILabel alloc] init];
        _bottomBoundLabel.numberOfLines = 1;
        _bottomBoundLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomBoundLabel.font = [UIFont dp_systemFontOfSize:14.0f];
        _bottomBoundLabel.backgroundColor = [UIColor clearColor];
        _bottomBoundLabel.textAlignment = NSTextAlignmentLeft;
        _bottomBoundLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bottomBoundLabel.userInteractionEnabled = NO;
    }
    return _bottomBoundLabel;
}

- (MTStringParser *)rfParser {
    if (_rfParser == nil) {
        _rfParser = [[MTStringParser alloc] init];
        [_rfParser setDefaultAttributes:({
                       MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                       attr.font = [UIFont dp_systemFontOfSize:14];
                       attr.textColor = [UIColor dp_flatBlackColor];
                       attr.alignment = NSTextAlignmentLeft;
                       attr;
                   })];
        [_rfParser addStyleWithTagName:@"red" color:UIColorFromRGB(0xdc2804)];
        [_rfParser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x3456a4)];
    }
    return _rfParser;
}

#pragma mark -选中的数组
- (NSArray *)getSelectedMatchArray {
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (PBMJczqMatch *match in self.matchsArray) {
        if ([match getSelectedTypeArrWithType:self.gameType].count) {
            [selectedArr addObject:match];
        }
    }

    return selectedArr;
}

#pragma mark - 获得胆拖的个数

- (NSInteger)getMarkedCount {
    NSInteger mark = 0;
    for (PBMJczqMatch *match in self.matchsArray) {
        switch (self.gameType) {    //0表示未设胆, 1表示已设胆
            case GameTypeJcHt:
                mark += match.matchOption.htDanTuo ? 1 : 0;
                break;
            case GameTypeJcDg:
            case GameTypeJcDgAll:
                mark += match.matchOption.dgDanTuo ? 1 : 0;
                break;
            case GameTypeJcSpf:
                mark += match.matchOption.spfDanTuo ? 1 : 0;
                break;
            case GameTypeJcRqspf:
                mark += match.matchOption.rqspfDanTuo ? 1 : 0;
                break;
            case GameTypeJcBf:
                mark += match.matchOption.bfDanTuo ? 1 : 0;
                break;
            case GameTypeJcZjq:
                mark += match.matchOption.zjqDanTuo ? 1 : 0;
                break;
            case GameTypeJcBqc:
                mark += match.matchOption.bqcDanTuo ? 1 : 0;
                break;
            default:
                break;
        }
    }

    return mark;
}

// 是否全是单关
- (BOOL)isAllSignalMatch {
    NSInteger normalCount = 0;

    for (PBMJczqMatch *match in [self getSelectedMatchArray]) {
        normalCount += [match isSelectedAllSignalWithType:self.gameType] ? 0 : 1;
    }

    return !normalCount;
}

#pragma mark - 生成订单PB数据

- (NSString *)getOrderNumberStr {
    NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchArray].count];
    for (int i = 0; i < [self getSelectedMatchArray].count; i++) {
        PBMJczqMatch *match = [self getSelectedMatchArray][i];
        [orders addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    return [NSString stringWithFormat:@",%@,", [orders componentsJoinedByString:@","]];
}

- (PBMPlaceAnOrder *)getOrderData {
    GameTypeId typeGame = (self.gameType == GameTypeJcDg || self.gameType == GameTypeJcDgAll) ? GameTypeJcHt : self.gameType;

    NSArray *passModes = [[_selectedPassModes allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        int pre = GetPassModeNameSuffix(obj1.integerValue);
        int nxt = GetPassModeNameSuffix(obj2.integerValue);
        if ((pre > 1 && nxt > 1 && obj1.integerValue > obj2.integerValue) ||
            (pre == 1 && nxt == 1 && obj1.integerValue > obj2.integerValue) ||
            (pre > 1 && nxt == 1)) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    PBMPlaceAnOrder *order = [[PBMPlaceAnOrder alloc] init];
    order.betDescription = [DPBetDescription descriptionJczqWithOption:_optionList passMode:passModes gameType:typeGame note:(int)_noteCount];
    order.betOrderNumbers = [self getOrderNumberStr];
    order.betType = [self getMarkedCount] ? 4 : 2;
    order.channelType = 1;
    order.deviceNum = @"";
    PBMJczqMatch *match = [[self getSelectedMatchArray] firstObject];
    order.gameId = (int32_t)match.dpGameId;
    order.gameTypeId = typeGame;
    order.multiple = self.multipleField.text.intValue;
    order.platformType = 1;
    order.quantity = (int)_noteCount;
    order.totalAmount = (int)_noteCount * 2 * self.multipleField.text.intValue;
    order.passTypeDesc = self.passModeButton.titleLabel.text;
    order.betTypeDesc = @"复式";
    order.projectBuyType = 1;

    return order;
}

#pragma mark - tableView's data source and delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMJczqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    BOOL markResult = NO;
    switch (self.gameType) {
        case GameTypeJcHt:
            markResult = match.matchOption.htDanTuo;
            break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            markResult = match.matchOption.dgDanTuo;
            break;
        case GameTypeJcSpf:
            markResult = match.matchOption.spfDanTuo;
            break;
        case GameTypeJcRqspf:
            markResult = match.matchOption.rqspfDanTuo;
            break;
        case GameTypeJcBf:
            markResult = match.matchOption.bfDanTuo;
            break;
        case GameTypeJcZjq:
            markResult = match.matchOption.zjqDanTuo;
            break;
        case GameTypeJcBqc:
            markResult = match.matchOption.bqcDanTuo;
            break;

        default:
            break;
    }

    static NSString *CellIdentifier = @"Cell";
    DPJczqTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell setDelegate:self];
        [cell setGameType:self.gameType];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];

        cell.showDetail = ^(DPJczqTransferCell *curCell) {

            NSIndexPath *path = [self.tableView indexPathForCell:curCell];
            PBMJczqMatch *match = [self.matchsArray objectAtIndex:path.row];

            DPFootBallMoreViewController *controller = [[DPFootBallMoreViewController alloc] initWithGameType:self.gameType match:match];
            @weakify(self);
            controller.reloadBlock = ^(void) {
                @strongify(self);

                if (![match getSelectedTypeArrWithType:self.gameType].count) {
                    curCell.markButton.selected = NO;
                    [match.matchOption exchangeMarkStatus:self.gameType mark:NO];
                    curCell.markButton.enabled = NO;
                } else {
                    curCell.markButton.enabled = YES;
                }

                [self updatePassmodelInfo:YES];
                [self calculateAllZhushu];
                [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        };
    }

    if ((match.matchOption.htSelect.numRqspf != 0 && self.gameType == GameTypeJcHt) || (match.matchOption.dgSelect.numRqspf != 0 && (self.gameType == GameTypeJcDgAll || self.gameType == GameTypeJcDg)) || self.gameType == GameTypeJcRqspf) {
        NSString *markupText = match.rqs > 0 ? [NSString stringWithFormat:@"%@(<red>%+zd</red>)", match.homeTeamName, match.rqs] : [NSString stringWithFormat:@"%@(<blue>%+zd</blue>)", match.homeTeamName, match.rqs];
        cell.homeNameLabel.attributedText = [self.rfParser attributedStringFromMarkup:markupText];
    } else {
        cell.homeNameLabel.text = match.homeTeamName;
    }

    cell.awayNameLabel.text = match.awayTeamName;
    cell.middleLabel.text = @"VS";
    cell.orderNumberLabel.text = match.orderNumberName;

    if (![match getSelectedTypeArrWithType:self.gameType].count) {
        cell.markButton.selected = NO;
        [match.matchOption exchangeMarkStatus:self.gameType mark:NO];
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
        cell.markButton.selected = markResult;
    }

    static NSString *rqspfNames[] = { @"让球胜",
                                      @"让球平",
                                      @"让球负" };
    static NSString *bfNames[] = {
        @"1:0",
        @"2:0",
        @"2:1",
        @"3:0",
        @"3:1",
        @"3:2",
        @"4:0",
        @"4:1",
        @"4:2",
        @"5:0",
        @"5:1",
        @"5:2",
        @"胜其他",
        @"0:0",
        @"1:1",
        @"2:2",
        @"3:3",
        @"平其他",
        @"0:1",
        @"0:2",
        @"1:2",
        @"0:3",
        @"1:3",
        @"2:3",
        @"0:4",
        @"1:4",
        @"2:4",
        @"0:5",
        @"1:5",
        @"2:5",
        @"负其他",
    };
    static NSString *zjqNames[] = { @"0球",
                                    @"1球",
                                    @"2球",
                                    @"3球",
                                    @"4球",
                                    @"5球",
                                    @"6球",
                                    @"7+球" };
    static NSString *bqcNames[] = { @"胜胜",
                                    @"胜平",
                                    @"胜负",
                                    @"平胜",
                                    @"平平",
                                    @"平负",
                                    @"负胜",
                                    @"负平",
                                    @"负负" };
    static NSString *spfNames[] = { @"胜",
                                    @"平",
                                    @"负" };

    switch (self.gameType) {
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 3; i++)
                if (match.matchOption.dgOption.betSpf[i])
                    [items addObject:spfNames[i]];

            for (int i = 0; i < 3; i++)
                if (match.matchOption.dgOption.betRqspf[i])
                    [items addObject:rqspfNames[i]];
            for (int i = 0; i < 31; i++)
                if (match.matchOption.dgOption.betBf[i])
                    [items addObject:bfNames[i]];
            for (int i = 0; i < 8; i++)
                if (match.matchOption.dgOption.betZjq[i])
                    [items addObject:zjqNames[i]];
            for (int i = 0; i < 9; i++)
                if (match.matchOption.dgOption.betBqc[i])
                    [items addObject:bqcNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeJcHt: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 3; i++)
                if (match.matchOption.htOption.betSpf[i])
                    [items addObject:spfNames[i]];

            for (int i = 0; i < 3; i++)
                if (match.matchOption.htOption.betRqspf[i])
                    [items addObject:rqspfNames[i]];
            for (int i = 0; i < 31; i++)
                if (match.matchOption.htOption.betBf[i])
                    [items addObject:bfNames[i]];
            for (int i = 0; i < 8; i++)
                if (match.matchOption.htOption.betZjq[i])
                    [items addObject:zjqNames[i]];
            for (int i = 0; i < 9; i++)
                if (match.matchOption.htOption.betBqc[i])
                    [items addObject:bqcNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);

        } break;
        case GameTypeJcRqspf: {
            for (int i = 0; i < cell.betOptionSpf.count; i++) {
                [cell.betOptionSpf[i] setSelected:match.matchOption.normalOption.betRqspf[i]];
                DPBetToggleControl *toggle = cell.betOptionSpf[i];
                toggle.oddsText = [match.rqspfItem.spListArray dp_safeObjectAtIndex:i];
            }
        } break;
        case GameTypeJcSpf: {
            for (int i = 0; i < cell.betOptionSpf.count; i++) {
                [cell.betOptionSpf[i] setSelected:match.matchOption.normalOption.betSpf[i]];
                DPBetToggleControl *toggle = cell.betOptionSpf[i];
                toggle.oddsText = [match.spfItem.spListArray dp_safeObjectAtIndex:i];
            }
        } break;
        case GameTypeJcBf: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 31; i++)
                if (match.matchOption.normalOption.betBf[i])
                    [items addObject:bfNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeJcZjq: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 8; i++)
                if (match.matchOption.normalOption.betZjq[i])
                    [items addObject:zjqNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeJcBqc: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 9; i++)
                if (match.matchOption.normalOption.betBqc[i])
                    [items addObject:bqcNames[i]];
            NSString *text = [items componentsJoinedByString:@"  "];
            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        default:
            break;
    }

    return cell;
}

#pragma mark - UIGestureRecognizerDelegate

// 处理手势事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击过关方式界面, 不处理事件. pop
    if ([touch.view isDescendantOfView:self.passModeView]) {
        return NO;
    }
    // 只处理 UIView 的点击事件, 忽略 UIControl 控件. pop
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPJczqTransferCellDelegate

//胜平负-让球胜平负  修改选择概率
- (void)jczqTransferCell:(DPJczqTransferCell *)cell gameType:(GameTypeId)gameType index:(int)index selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    PBMJczqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];
    [match updateSelectStatusWithBaseType:self.gameType selectGmaeType:self.gameType index:index select:selected isAllSub:NO];

    if (![match getSelectedTypeArrWithType:self.gameType].count) {
        cell.markButton.selected = NO;
        [match.matchOption exchangeMarkStatus:self.gameType mark:NO];
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
    }

    [self updatePassmodelInfo:YES];
    [self calculateAllZhushu];
}
//设置胆拖
- (void)jczqTransferCell:(DPJczqTransferCell *)cell mark:(BOOL)selected {
    if (selected && [self getMarkedCount] >= _maxMark) {
        [[DPToast makeText:[NSString stringWithFormat:@"当前玩法最多设置%zd个胆", _maxMark]] show];
        return;
    }
    cell.markButton.selected = selected;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PBMJczqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    switch (self.gameType) {
        case GameTypeJcHt:
            match.matchOption.htDanTuo = selected;
            break;
        case GameTypeJcDgAll:
        case GameTypeJcDg:
            match.matchOption.dgDanTuo = selected;
            break;
        case GameTypeJcSpf:
            match.matchOption.spfDanTuo = selected;
            break;
        case GameTypeJcRqspf:
            match.matchOption.rqspfDanTuo = selected;
            break;
        case GameTypeJcBf:
            match.matchOption.bfDanTuo = selected;
            break;
        case GameTypeJcZjq:
            match.matchOption.zjqDanTuo = selected;
            break;
        case GameTypeJcBqc:
            match.matchOption.bqcDanTuo = selected;
            break;
        default:
            break;
    }

    [self updatePassmodelInfo:YES];
    [self calculateAllZhushu];
}

//设置胆拖
- (BOOL)shouldMarkJczqTransferCell:(DPJczqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    PBMJczqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    if ([match.matchOption getMarkedStatus:self.gameType]) {
        return YES;
    }
    if (![match getSelectedTypeArrWithType:self.gameType]) {
        return NO;
    }

    NSInteger mark = [self getMarkedCount];

    //    vector<int> freedoms, combines;
    //    _jczqInstance->GetEnablePassMode(freedoms, combines);
    //    int maxMark = MAX(freedoms.size() ? GetPassModeNamePrefix(freedoms.back()) : 0, combines.size() ? GetPassModeNamePrefix(combines.back()) : 0);
    //    if (mark >= maxMark) {
    //        [[DPToast makeText:[NSString stringWithFormat:@"最多设置%d个胆", maxMark]] show];
    //        return NO;
    //    }

    return YES;
}
//删除本条赛事
- (void)deleteJczqTransferCell:(DPJczqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    PBMJczqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];
    [match.matchOption initializeOptionWithType:self.gameType];
    [self.matchsArray removeObject:match];

    [self.tableView reloadData];

    [self updatePassmodelInfo:YES];
    [self calculateAllZhushu];

    if (self.matchsArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 设置过关方式
- (void)setPassModelResult:(BOOL)needDefault {
    NSMutableSet *typeSet = [[NSMutableSet alloc] init];
    for (PBMJczqMatch *match in [self getSelectedMatchArray]) {
        for (NSNumber *number in [match getSelectedTypeArrWithType:self.gameType]) {
            [typeSet addObject:number];
        }
    }

    NSInteger markCount = [self getMarkedCount];

    if ([self isAllSignalMatch]) {
        self.passModeView.freedoms = [DPPassModeFactor freedomWithTypes:[typeSet allObjects] matchCount:[self getSelectedMatchArray].count markCount:markCount allSingle:YES];
    } else {
        self.passModeView.freedoms = [DPPassModeFactor freedomWithTypes:[typeSet allObjects] matchCount:[self getSelectedMatchArray].count markCount:markCount allSingle:NO];
    }
    self.passModeView.combines = [DPPassModeFactor combineWithTypes:[typeSet allObjects] matchCount:[self getSelectedMatchArray].count markCount:markCount];

    NSMutableSet *set = [NSMutableSet setWithSet:_selectedPassModes];
    [_selectedPassModes removeAllObjects];
    for (NSNumber *ss in set) {
        if ([self.passModeView.freedoms containsObject:ss] || [self.passModeView.combines containsObject:ss]) {
            [_selectedPassModes addObject:ss];
        }
    }

    if (!_selectedPassModes.count && needDefault) {
        [_selectedPassModes addObject:self.passModeView.freedoms.lastObject];
    }
}

#pragma mark - 更新过关方式
- (void)updatePassmodelInfo:(BOOL)needDefault {
    [self setPassModelResult:needDefault];

    [self.passModeView reloadData];

    [self pvt_updatePassMode];
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });

    });
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self calculateAllZhushu];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![KTMValidator isNumber:string]) {
        return NO;
    }

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([newString intValue] > 100000) {
        textField.text = @"100000";
        [self calculateAllZhushu];
        //        [[DPToast makeText:@"最大倍数不得超过100000"] show];
        return NO;
    }
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushu];
        return NO;
    }

    if ([newString intValue] <= 0) {
        newString = @"1";
    }
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;    // fix iOS8
    }
    textField.text = newString;
    [self calculateAllZhushu];
    return NO;
}
#pragma mark - 键盘事件
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.submitView && obj.firstAttribute == NSLayoutAttributeBottom) {
            obj.constant = keyboardY - screenHeight;

            if (keyboardY != UIScreen.mainScreen.bounds.size.height && self.passModeButton.selected) {
                self.passModeButton.selected = NO;
                [self pvt_adaptPassModeHeight];
            }

            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration
                                  delay:0
                                options:curve << 16
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];

            *stop = YES;
        }
    }];

    if (keyboardY != UIScreen.mainScreen.bounds.size.height || self.passModeButton.isSelected) {
        [self pvt_hiddenCoverView:NO];
    } else {
    }
}

// 改变过关方式高度, 处理键盘弹出界面. pop
- (void)pvt_adaptPassModeHeight {
    [self.passModeView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.passModeView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = self.passModeButton.selected ? (self.passModeView.contentSize.height + 20) : 0;
            *stop = YES;
        }
    }];
}

#pragma mark - 获取存储对象
- (DPJczqBetStore *)getBetStore:(PBMJczqMatch *)match {
    DPJczqBetStore *betOption = [[DPJczqBetStore alloc] init];

    switch (self.gameType) {
        case GameTypeJcHt: {
            [betOption setSpfBetOption:match.matchOption.htOption.betSpf];
            [betOption setRqspfBetOption:match.matchOption.htOption.betRqspf];
            [betOption setZjqBetOption:match.matchOption.htOption.betZjq];
            [betOption setBqcBetOption:match.matchOption.htOption.betBqc];
            [betOption setBfBetOption:match.matchOption.htOption.betBf];

            betOption.mark = match.matchOption.htDanTuo;

            betOption.spfSpList = match.spfItem.spListArray;
            betOption.rqspfSpList = match.rqspfItem.spListArray;
            betOption.zjqSpList = match.zjqItem.spListArray;
            betOption.bqcSpList = match.bqcItem.spListArray;
            betOption.bfSpList = match.bfItem.spListArray;

        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            [betOption setSpfBetOption:match.matchOption.dgOption.betSpf];
            [betOption setRqspfBetOption:match.matchOption.dgOption.betRqspf];
            [betOption setZjqBetOption:match.matchOption.dgOption.betZjq];
            [betOption setBqcBetOption:match.matchOption.dgOption.betBqc];
            [betOption setBfBetOption:match.matchOption.dgOption.betBf];

            betOption.mark = match.matchOption.dgDanTuo;

            betOption.spfSpList = match.spfItem.spListArray;
            betOption.rqspfSpList = match.rqspfItem.spListArray;
            betOption.zjqSpList = match.zjqItem.spListArray;
            betOption.bqcSpList = match.bqcItem.spListArray;
            betOption.bfSpList = match.bfItem.spListArray;

        } break;
        case GameTypeJcSpf: {
            [betOption setSpfBetOption:match.matchOption.normalOption.betSpf];
            betOption.mark = match.matchOption.spfDanTuo;
            betOption.spfSpList = match.spfItem.spListArray;

        } break;
        case GameTypeJcRqspf: {
            [betOption setRqspfBetOption:match.matchOption.normalOption.betRqspf];
            betOption.mark = match.matchOption.rqspfDanTuo;
            betOption.rqspfSpList = match.rqspfItem.spListArray;

        } break;
        case GameTypeJcBf: {
            [betOption setBfBetOption:match.matchOption.normalOption.betBf];
            betOption.mark = match.matchOption.bfDanTuo;
            betOption.bfSpList = match.bfItem.spListArray;

        } break;
        case GameTypeJcZjq: {
            [betOption setZjqBetOption:match.matchOption.normalOption.betZjq];
            betOption.mark = match.matchOption.zjqDanTuo;
            betOption.zjqSpList = match.zjqItem.spListArray;

        } break;
        case GameTypeJcBqc: {
            [betOption setBqcBetOption:match.matchOption.normalOption.betBqc];
            betOption.mark = match.matchOption.bqcDanTuo;
            betOption.bqcSpList = match.bqcItem.spListArray;

        } break;
        default:

            break;
    }

    betOption.rqs = match.rqs;
    betOption.matchId = match.gameMatchId;
    betOption.orderNumberName = match.orderNumberName;

    return betOption;
}

#pragma mark - 计算注数
- (void)calculateAllZhushu {
    [_optionList removeAllObjects];
    for (PBMJczqMatch *match in [self getSelectedMatchArray]) {
        [_optionList addObject:[self getBetStore:match]];
    }

    DPNoteBonusResult result = [DPNoteCalculater calcJczqWithOption:_optionList passMode:[_selectedPassModes allObjects]];

    int note = (int)result.note;
    int multiple = [self.multipleField.text intValue];
    float minBonus = result.min;
    float maxBonus = result.max;

    self.bottomLabel.text = [NSString stringWithFormat:@"%d注 %d倍 共%d元", note, multiple, 2 * note * multiple];

    NSString *maxBound = maxBonus * multiple * 2 >= 0 ? [NSString stringWithFormat:@"%.2f", maxBonus * multiple * 2] : @"?";
    NSString *minBound = minBonus * multiple * 2 >= 0 ? [NSString stringWithFormat:@"%.2f", minBonus * multiple * 2] : @"0.00";
    if ([minBound isEqualToString:maxBound]) {
        self.bottomBoundLabel.text = [NSString stringWithFormat:@"奖金: %@", minBound];

    } else {
        self.bottomBoundLabel.text = [NSString stringWithFormat:@"奖金: %@~%@", minBound, maxBound];
    }

    _noteCount = result.note;
}

#pragma mark - DPPassModeViewDelegate
//点击多串过关
- (void)passModeView:(DPPassModeView *)passModeView expand:(BOOL)expand {
    [self.passModeView reloadData];
    [self.passModeView layoutIfNeeded];
    [self pvt_adaptPassModeHeight];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}
//选择过关方式
- (void)passModeView:(DPPassModeView *)passModeView toggle:(NSInteger)passModeTag {
    //    if (![_selectedPassModes containsObject:@(passModeTag)] && _selectedPassModes.count>=5) {
    //
    //        [[DPToast makeText:@"过关方式最多选择5种"]show];
    //        return ;
    //    }

    [_selectedPassModes dp_turnObject:@(passModeTag)];
    [self updatePassmodelInfo:NO];
    [self calculateAllZhushu];
}
//获取过关信息
- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag {
    return [_selectedPassModes containsObject:@(passModeTag)];
}

@end
