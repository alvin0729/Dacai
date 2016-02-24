//
//  DPJclqTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAgreementLabel.h"
#import "DPAlterViewController.h"
#import "DPFlowSets.h"
#import "DPJclqDataModel.h"
#import "DPJclqTransferCell.h"
#import "DPJclqTransferVC.h"
#import "DPLanCaiMoreView.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPPassModeView.h"
#import "DPPayRedPacketViewController.h"
#import "DPWebViewController.h"
#import "Order.pbobjc.h"

@interface DPJclqTransferVC () <UITableViewDelegate, UITableViewDataSource, DPPassModeViewDelegate, DPJcLqTransferCellDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
@private
    UITableView *_tableView;
    UIView *_configView;
    UIView *_submitView;
    UITextField *_multipleField;
    UIButton *_passModeButton;
    NSMutableSet *_selectedPassModes;
    DPPassModeView *_passModeView;
    UIView *_coverView;
    UIView *_agreeView;
    BOOL _isAgreement;

    NSMutableArray *_optionList;
    NSInteger _betNote;    //注数
    NSInteger _maxMark;    //最多单数
}

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIView *configView;
@property (nonatomic, strong, readonly) UIView *submitView;              //底部提交视图
@property (nonatomic, strong, readonly) UITextField *multipleField;      //投注倍数
@property (nonatomic, strong, readonly) UIButton *passModeButton;        //过关按钮
@property (nonatomic, strong, readonly) DPPassModeView *passModeView;    //过关方式
@property (nonatomic, strong, readonly) UIView *agreeView;               //同意协议

@property (nonatomic, strong) NSMutableArray *selectedIndexs;
@property (nonatomic, strong, readonly) UIView *coverView;    //灰色背景（键盘弹出）

@property (nonatomic, strong) MTStringParser *rfParser;

@end

@implementation DPJclqTransferVC
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
        _isAgreement = YES;

        [DPPaymentFlow pushContextWithViewController:self];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    [self updatePassmodelInfo:YES];
    [self calculateAllZhushu];
    _maxMark = self.passModeView.freedoms.count;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.multipleField resignFirstResponder];
    [self pvt_hiddenCoverView:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc {
    [DPPaymentFlow popContextWithViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投注确认";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];

    UIView *contentView = self.view;
    UIView *headerView = [self createHeaderView];

    [contentView addSubview:headerView];
    [contentView addSubview:self.tableView];
    [contentView addSubview:self.coverView];
    [contentView addSubview:self.agreeView];

    [contentView addSubview:self.configView];
    [contentView addSubview:self.passModeView];
    [contentView addSubview:self.submitView];

    [self.coverView setHidden:YES];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

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

    [self buildConfigLayout];
    [self buildSubmitLayout];

    [self.view addGestureRecognizer:({
                   UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
                   tapGestureRecognizer.delegate = self;
                   tapGestureRecognizer;
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
        //        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        //        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(pvt_addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000;
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
        //        [button.layer setBorderColor:[UIColor colorWithRed:0.75 green:0.73 blue:0.71 alpha:1].CGColor];
        //        [button.layer setBorderWidth:1];
        button.tag = 1001;
        [button addTarget:self action:@selector(pvt_addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
    }];
    [reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_centerX).offset(-1);
        make.right.equalTo(contentView).offset(-5);
        make.top.equalTo(contentView).offset(9);
        make.bottom.equalTo(contentView).offset(-9);
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
//倍数界面
- (void)buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    UIView *bottomLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    
    UIView *contentView = self.configView;
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"投";
    label1.textColor = [UIColor dp_flatBlackColor];
    label1.font = [UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"倍";
    label2.textColor = [UIColor dp_flatBlackColor];
    label2.font = [UIFont dp_systemFontOfSize:12.0];
    [contentView addSubview:label2];
    
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
        make.width.equalTo(@85);
        make.left.equalTo(contentView).offset(15);
    }];
    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30);
        make.width.equalTo(@70);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.multipleField.mas_left);
        make.width.equalTo(@20);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.multipleField.mas_right).offset(3);
        make.width.equalTo(@20);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
    
    UIView *middleLine = ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xd9d5cc);
        view;
    });
    [contentView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.centerX.equalTo(contentView);
    }];
}
//底部提交界面
- (void)buildSubmitLayout {
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
    [contentView addSubview:confirmView];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(submitButton).offset(-20);
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
        make.right.equalTo(contentView).offset(-40);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
}


#pragma mark - 提交付款
- (void)pvt_onSubmit {
    if (self.gameType == GameTypeLcSfc && [self getSelectedMatchArray].count < 1) {
        [[DPToast makeText:@"至少选择1注比赛!"] show];
        return;
    } else if ([self getSelectedMatchArray].count < 2 && ![self isAllSignalMatch]) {
        [[DPToast makeText:@"至少选择2场比赛!"] show];
        return;
    } else if (_selectedPassModes.count == 0) {
        [[DPToast makeText:@"请选择过关方式!"] show];
        return;
    } else if (self.multipleField.text.integerValue <= 0) {
        [[DPToast makeText:@"请设置投注倍数!"] show];
        [self.multipleField setText:@"1"];
        [self calculateAllZhushu];
        return;
    } else if ([self calculateAllZhushu] * 2 * [self.multipleField.text intValue] > 2000000) {
        [[DPToast makeText:dp_moneyLimitWarning] show];
        return;
    } else if (_isAgreement == NO) {
        [[DPToast makeText:@"请勾选用户协议！"] show];
        return;
    } else {
        [self.view endEditing:YES];
        if (self.passModeButton.selected) {
            [self.passModeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    NSMutableArray *orderNumbers = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchArray].count];
    for (PBMJclqMatch *match in [self getSelectedMatchArray]) {
        [orderNumbers addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%@&gameTypeId=%d", [orderNumbers componentsJoinedByString:@","], self.gameType];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [DPPaymentFlow paymentWithOrder:[self getOrderData] gameType:self.gameType inViewController:self];
        
    }
                                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                                             
                                             [[DPToast makeText:error.dp_errorMessage] show];
                                         }];
}

- (void)pvt_addButtonClick:(UIButton *)button {
    int index = (int)button.tag - 1000;
    switch (index) {
        case 0: {
            [self.navigationController popViewControllerAnimated:YES];
        } break;
        case 1: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重新选择将清空已选的比赛, 是否继续?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            @weakify(self, alertView);
            [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
                @strongify(self, alertView);
                if (buttonIndex.integerValue != alertView.cancelButtonIndex) {
                    for (PBMJclqMatch *match in self.matchsArray) {
                        [match.matchOption initializeOptionWithType:self.gameType];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            [alertView show];
        } break;
        default:
            break;
    }
}
//键盘弹出或退出时灰色背景处理
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2
                             animations:^{
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
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.coverView.alpha = 1;
                             }];
        }
    }
}
//返回大厅
- (void)pvt_onBack {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (alertView.cancelButtonIndex != buttonIndex.integerValue) {
            if (self.navigationController.viewControllers.count > 2) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    [alertView show];
}


//取消键盘事件
- (void)pvt_onTap {
    if (self.multipleField.isEditing) {
        [self.multipleField resignFirstResponder];
    }
    if (self.passModeButton.isSelected) {
        self.passModeButton.selected = NO;

        [self pvt_adaptPassModeHeight];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }

    [self pvt_hiddenCoverView:YES];
}


//键盘事件
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
    [self calculateAllZhushu];
}



#pragma mark - 点击过关方式
- (void)pvt_onPassMode {
    int count = (int)[self getSelectedMatchArray].count;
    if (self.gameType == GameTypeLcSfc) {
        if (count < 1) {
            [[DPToast makeText:@"至少选择1场比赛！"] show];
            return;
        }
    } else {
        if (count < 2 && ![self isAllSignalMatch]) {
            [[DPToast makeText:@"至少选择2场比赛！"] show];
            return;
        }
    }

    self.passModeButton.selected = !self.passModeButton.isSelected;
    if (self.passModeButton.selected) {
        [self setPassModelResult:NO];
        if (self.multipleField.isEditing) {
            [self.multipleField resignFirstResponder];
        }
    }

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

//打开合买代购协议
- (void)pvt_onAgreement {
    DPWebViewController *webCtrl = [[DPWebViewController alloc] init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.canHighlight = NO;
    [self.navigationController pushViewController:webCtrl animated:YES];
}
- (void)pvt_agreementBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isAgreement = sender.selected;
}

//改变过关方式高度
- (void)pvt_adaptPassModeHeight {
    [self.passModeView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self.passModeView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = self.passModeButton.selected ? self.passModeView.contentSize.height + 20 : 0;
            *stop = YES;
        }
    }];
}

#pragma mark - 设置过关方式
- (void)setPassModelResult:(BOOL)needDefault {
    NSMutableSet *typeSet = [[NSMutableSet alloc] init];
    for (PBMJclqMatch *match in [self getSelectedMatchArray]) {
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

    [self updatePassModeText];
}

//更改过关方式
- (void)updatePassModeText {
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onAgreement)];
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
            [button addTarget:self action:@selector(pvt_agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            UIImage *image = dp_SportLotteryImage(@"trans_bg.png");
            imageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, image.dp_height - 3, 0) resizingMode:UIImageResizingModeStretch];
            imageView;
        });

        _tableView.tableFooterView = gearView;
    }
    return _tableView;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomLabel.font = [UIFont dp_systemFontOfSize:14];
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
        _bottomBoundLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomBoundLabel.font = [UIFont dp_systemFontOfSize:14];
        _bottomBoundLabel.backgroundColor = [UIColor clearColor];
        _bottomBoundLabel.textAlignment = NSTextAlignmentLeft;
        _bottomBoundLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bottomBoundLabel.userInteractionEnabled = NO;
    }
    return _bottomBoundLabel;
}
- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
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
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.keyboardType = UIKeyboardTypeNumberPad;
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);

            line;
        });
        _multipleField.delegate = self;
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
        [_passModeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.passModeView]) {
        return NO;
    }
    return YES;
}

#pragma mark - tableView's data source and delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMJclqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    BOOL markResult = NO;
    switch (self.gameType) {
        case GameTypeLcHt:
            markResult = match.matchOption.htDanTuo;
            break;

        case GameTypeLcSf:
            markResult = match.matchOption.sfcDanTuo;
            break;
        case GameTypeLcRfsf:
            markResult = match.matchOption.rfsfDanTuo;
            break;
        case GameTypeLcDxf:
            markResult = match.matchOption.dxfDanTuo;
            break;
        case GameTypeLcSfc:
            markResult = match.matchOption.sfcDanTuo;
            break;

        default:
            break;
    }

    static NSString *CellIdentifier = @"Cell";
    DPJcLqTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJcLqTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell buildLayout];

        switch (self.gameType) {
            case GameTypeLcHt:
            case GameTypeLcSfc:
                [cell loadDragView];
                break;
            default:
                [cell loadRfDragView];
                break;
        }
        @weakify(self);

        cell.showDetail = ^(DPJcLqTransferCell *curCell) {
            @strongify(self);

            NSIndexPath *path = [self.tableView indexPathForCell:curCell];
            PBMJclqMatch *match = [self.matchsArray objectAtIndex:path.row];

            DPBasketMoreViewController *controller = [[DPBasketMoreViewController alloc] initWithGameType:self.gameType match:match];
            @weakify(self);
            controller.reloadBlock = ^(void) {
                @strongify(self);

                if (![match isSelectedWithType:self.gameType]) {
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
    if ((self.gameType == GameTypeLcHt && match.matchOption.htSelect.numRfsf != 0) || self.gameType == GameTypeLcRfsf) {
        NSString *markupText = match.rf.floatValue > 0 ? [NSString stringWithFormat:@"%@(<red>+%@</red>)", match.homeTeamName, match.rf] : [NSString stringWithFormat:@"%@(<blue>%@</blue>)", match.homeTeamName, match.rf];
        cell.homeNameLabel.attributedText = [self.rfParser attributedStringFromMarkup:markupText];
    } else {
        cell.homeNameLabel.text = match.homeTeamName;
    }

    cell.awayNameLabel.text = match.awayTeamName;
    cell.orderNumberLabel.text = match.orderNumberName;
    if (![match isSelectedWithType:self.gameType]) {
        cell.markButton.selected = NO;
        [match.matchOption exchangeMarkStatus:self.gameType mark:NO];
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
        cell.markButton.selected = markResult;
    }
    cell.middleLabel.text = @"VS";
    cell.middleLabel.textColor = [UIColor colorWithRed:0.79 green:0.74 blue:0.62 alpha:1];

    switch (self.gameType) {
        case GameTypeLcHt: {
            NSMutableArray *items = [NSMutableArray array];

            for (int i = 0; i < 2; i++) {
                if (match.matchOption.htOption.betRfsf[i]) {
                    [items addObject:dp_TransferOptionNameLcRqsf[i]];
                }
            }

            for (int i = 0; i < 2; i++) {
                if (match.matchOption.htOption.betDxf[i]) {
                    [items addObject:dp_TransferOptionNameLcDxf[i]];
                }
            }
            for (int i = 0; i < 2; i++) {
                if (match.matchOption.htOption.betSf[i]) {
                    [items addObject:dp_TransferOptionNameLcSf[i]];
                }
            }

            for (int i = 0; i < 12; i++) {
                if (match.matchOption.htOption.betSfc[i]) {
                    [items addObject:dp_TransferOptionNameLcSfc[i]];
                }
            }

            NSString *text = [items componentsJoinedByString:@"  "];

            cell.contentLabel.text = text.length ? text : @"更多选择";
            cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
            cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
        } break;
        case GameTypeLcSfc: {
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < 12; i++) {
                if (match.matchOption.normalOption.betSfc[i]) {
                    [items addObject:dp_TransferOptionNameLcSfc[i]];
                }
                NSString *text = [items componentsJoinedByString:@"  "];

                cell.contentLabel.text = text.length ? text : @"更多选择";
                cell.contentLabel.textColor = text.length ? [UIColor dp_flatRedColor] : [UIColor dp_flatGrayColor];
                cell.contentLabel.frame = CGRectMake(0, 0, cell.contentLabel.intrinsicContentSize.width, 25);
            }
        } break;
        case GameTypeLcSf:

            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"主负 %@", match.sfItem.spListArray[1]] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"主胜 %@", match.sfItem.spListArray[0]] forState:UIControlStateNormal];
            if (match.matchOption.normalOption.betSf[0]) {
                cell.jclqtleftBtn.selected = YES;
            } else {
                cell.jclqtleftBtn.selected = NO;
            }
            if (match.matchOption.normalOption.betSf[1]) {
                cell.jclqtRightBtn.selected = YES;
            } else {
                cell.jclqtRightBtn.selected = NO;
            }

            break;
        case GameTypeLcRfsf:

            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"主负 %@", match.rfsfItem.spListArray[1]] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"主胜 %@", match.rfsfItem.spListArray[0]] forState:UIControlStateNormal];
            if (match.matchOption.normalOption.betRfsf[0]) {
                cell.jclqtleftBtn.selected = YES;
            } else {
                cell.jclqtleftBtn.selected = NO;
            }

            if (match.matchOption.normalOption.betRfsf[1]) {
                cell.jclqtRightBtn.selected = YES;
            } else {
                cell.jclqtRightBtn.selected = NO;
            }

            break;
        case GameTypeLcDxf:
            cell.middleLabel.text = match.zf;
            cell.middleLabel.textColor = [UIColor dp_flatRedColor];

            [cell.jclqtleftBtn setTitle:[NSString stringWithFormat:@"大分 %@", match.dxfItem.spListArray[0]] forState:UIControlStateNormal];
            [cell.jclqtRightBtn setTitle:[NSString stringWithFormat:@"小分 %@", match.dxfItem.spListArray[1]] forState:UIControlStateNormal];
            if (match.matchOption.normalOption.betDxf[0]) {
                cell.jclqtleftBtn.selected = YES;
            } else {
                cell.jclqtleftBtn.selected = NO;
            }
            if (match.matchOption.normalOption.betDxf[1]) {
                cell.jclqtRightBtn.selected = YES;
            } else {
                cell.jclqtRightBtn.selected = NO;
            }

            break;
        default:
            break;
    }
    //    cell.contentLabel

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - UITextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
    });
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self calculateAllZhushu];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![KTMValidator isNumber:string]) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    int aString = [newString intValue];
    if (newString.length == 0) {
        textField.text = @"";
        [self calculateAllZhushu];
        return NO;
    }

    if (aString <= 0) {
        aString = 1;
    }

    if (textField == self.multipleField) {
        if ([newString intValue] > 100000) {
            self.multipleField.text = @"100000";
            [self calculateAllZhushu];
            return NO;
        }
        if (newString.length == 0) {
            textField.text = @"";
            [self calculateAllZhushu];
            return NO;
        }

        if (newString.intValue <= 0) {
            textField.text = @"1";
            [self calculateAllZhushu];
            return NO;
        }
    }
    newString = [NSString stringWithFormat:@"%d", aString];
    if ([textField.text isEqualToString:newString]) {
        textField.text = nil;    // fix iOS8
    }
    textField.text = newString;
    [self calculateAllZhushu];
    return NO;
}
#pragma mark - DPJclqTransferCellDelegate

- (void)jclqTransferCell:(DPJcLqTransferCell *)cell event:(DPJclqTransferCellEvent)event {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PBMJclqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    switch (event) {
        case DPJclqTransferCellEventDelete: {
            [match.matchOption initializeOptionWithType:self.gameType];
            [self.matchsArray removeObject:match];

            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            if (self.matchsArray.count <= 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }

        } break;
        case DPJclqTransferCellEventMark: {    //设置胆拖

            BOOL lastResult = [match.matchOption getMarkedStatus:self.gameType];

            if (!lastResult && [self getMarkedCount] >= _maxMark) {
                [[DPToast makeText:[NSString stringWithFormat:@"当前玩法最多设置%zd个胆", _maxMark]] show];
                return;
            }

            cell.markButton.selected = !lastResult;
            [match.matchOption exchangeMarkStatus:self.gameType mark:!lastResult];
        }
        default:
            break;
    }
    [self updatePassmodelInfo:YES];

    [self calculateAllZhushu];
}
- (void)jclqTranCell:(DPJcLqTransferCell *)cell selectedIndex:(int)selectedIndex isSelected:(int)isSelected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PBMJclqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];
    [match updateSelectStatusWithBaseType:self.gameType selectGmaeType:self.gameType index:selectedIndex select:isSelected isAllSub:NO];

    if (![match isSelectedWithType:self.gameType]) {
        cell.markButton.selected = NO;
        [match.matchOption exchangeMarkStatus:self.gameType mark:NO];
        cell.markButton.enabled = NO;
    } else {
        cell.markButton.enabled = YES;
    }

    [self updatePassmodelInfo:YES];

    [self calculateAllZhushu];
}


#pragma mark -选中的数组
- (NSArray *)getSelectedMatchArray {
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (PBMJclqMatch *match in self.matchsArray) {
        if ([match getSelectedTypeArrWithType:self.gameType].count) {
            [selectedArr addObject:match];
        }
    }

    return selectedArr;
}
// 是否全是单关. pop
- (BOOL)isAllSignalMatch {
    NSInteger normalCount = 0;
    
    for (PBMJclqMatch *match in [self getSelectedMatchArray]) {
        normalCount += [match isSelectedAllSignalWithType:self.gameType] ? 0 : 1;
    }
    
    return !normalCount;
}


#pragma mark - 获得胆拖的个数

- (NSInteger)getMarkedCount {
    NSInteger mark = 0;
    for (PBMJclqMatch *match in self.matchsArray) {
        switch (self.gameType) {    //0表示未设胆, 1表示已设胆
            case GameTypeLcHt:
                mark += match.matchOption.htDanTuo ? 1 : 0;
                break;

            case GameTypeLcSf:
                mark += match.matchOption.sfDanTuo ? 1 : 0;
                break;
            case GameTypeLcRfsf:
                mark += match.matchOption.rfsfDanTuo ? 1 : 0;
                break;
            case GameTypeLcDxf:
                mark += match.matchOption.dxfDanTuo ? 1 : 0;
                break;
            case GameTypeLcSfc:
                mark += match.matchOption.sfcDanTuo ? 1 : 0;
                break;

            default:
                break;
        }
    }

    return mark;
}

//设置胆拖
- (BOOL)shouldMarkJclqTransferCell:(DPJcLqTransferCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PBMJclqMatch *match = [self.matchsArray objectAtIndex:indexPath.row];

    if ([match.matchOption getMarkedStatus:self.gameType]) {
        return YES;
    }
    if (![match isSelectedWithType:self.gameType]) {
        return NO;
    }

    NSInteger mark = [self getMarkedCount];

    return YES;
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

#pragma mark - 生成订单PB数据

- (NSString *)getOrderNumberStr {
    NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchArray].count];
    for (int i = 0; i < [self getSelectedMatchArray].count; i++) {
        PBMJclqMatch *match = [self getSelectedMatchArray][i];
        [orders addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    return [NSString stringWithFormat:@",%@,", [orders componentsJoinedByString:@","]];
}

- (PBMPlaceAnOrder *)getOrderData {
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
    order.betDescription = [DPBetDescription descriptionJclqWithOption:_optionList passMode:passModes gameType:self.gameType note:(int)[self calculateAllZhushu]];
    order.betOrderNumbers = [self getOrderNumberStr];
    order.betType = [self getMarkedCount] ? 4 : 2;
    order.channelType = 1;
    order.deviceNum = @"";
    PBMJclqMatch *match = [[self getSelectedMatchArray] firstObject];
    order.gameId = match.dp_gameId;
    order.gameTypeId = self.gameType;
    order.multiple = self.multipleField.text.intValue;
    order.platformType = 1;
    order.quantity = (int)[self calculateAllZhushu];
    order.totalAmount = (int)[self calculateAllZhushu] * 2 * self.multipleField.text.intValue;
    order.passTypeDesc = self.passModeButton.titleLabel.text;
    order.betTypeDesc = @"复式";
    order.projectBuyType = 1;

    return order;
}


#pragma mark - 获取存储对象
- (DPJclqBetStore *)getBetStore:(PBMJclqMatch *)match {
    DPJclqBetStore *betOption = [[DPJclqBetStore alloc] init];

    switch (self.gameType) {
        case GameTypeLcHt: {
            [betOption setSfBetOption:match.matchOption.htOption.betSf];
            [betOption setRfsfBetOption:match.matchOption.htOption.betRfsf];
            [betOption setDxfBetOption:match.matchOption.htOption.betDxf];
            [betOption setSfcBetOption:match.matchOption.htOption.betSfc];

            betOption.mark = match.matchOption.htDanTuo;

            betOption.sfSpList = match.sfItem.spListArray;
            betOption.rfsfSpList = match.rfsfItem.spListArray;
            betOption.dxfSpList = match.dxfItem.spListArray;
            betOption.sfcSpList = match.sfcItem.spListArray;

        } break;

        case GameTypeLcSf: {
            [betOption setSfBetOption:match.matchOption.normalOption.betSf];
            betOption.mark = match.matchOption.sfDanTuo;
            betOption.sfSpList = match.sfItem.spListArray;

        } break;
        case GameTypeLcRfsf: {
            [betOption setRfsfBetOption:match.matchOption.normalOption.betRfsf];
            betOption.mark = match.matchOption.rfsfDanTuo;
            betOption.rfsfSpList = match.rfsfItem.spListArray;
        } break;
        case GameTypeLcDxf: {
            [betOption setDxfBetOption:match.matchOption.normalOption.betDxf];
            betOption.mark = match.matchOption.dxfDanTuo;
            betOption.dxfSpList = match.dxfItem.spListArray;

        } break;
        case GameTypeLcSfc: {
            [betOption setSfcBetOption:match.matchOption.normalOption.betSfc];
            betOption.mark = match.matchOption.sfcDanTuo;
            betOption.sfcSpList = match.sfcItem.spListArray;

        } break;

        default:

            break;
    }

    betOption.rf = [match.rf floatValue];
    betOption.zf = [match.zf floatValue];
    betOption.matchId = match.gameMatchId;
    betOption.orderNumberName = match.orderNumberName;

    return betOption;
}

#pragma mark - 计算注数

- (NSInteger)calculateAllZhushu {
    [_optionList removeAllObjects];
    for (PBMJclqMatch *match in [self getSelectedMatchArray]) {
        [_optionList addObject:[self getBetStore:match]];
    }

    DPNoteBonusResult result = [DPNoteCalculater calcJclqWithOption:_optionList passMode:[_selectedPassModes allObjects]];

    int note = (int)result.note;
    int multiple = [self.multipleField.text intValue];
    float minBonus = result.min;
    float maxBonus = result.max;

    NSString *maxBound = maxBonus * multiple * 2 >= 0 ? [NSString stringWithFormat:@"%.2f", maxBonus * multiple * 2] : @"?";
    NSString *minBound = minBonus * multiple * 2 >= 0 ? [NSString stringWithFormat:@"%.2f", minBonus * multiple * 2] : @"0.00";

    NSString *markupText = [NSString stringWithFormat:@"%d注 %d倍 共%d元", note, multiple, 2 * note * multiple];
    self.bottomLabel.text = markupText;

    if ([maxBound isEqualToString:minBound]) {
        markupText = [NSString stringWithFormat:@"奖金:%@元", minBound];
    } else {
        markupText = [NSString stringWithFormat:@"奖金:%@~%@元", minBound, maxBound];
    }
    self.bottomBoundLabel.text = markupText;

    return result.note;
}


@end
