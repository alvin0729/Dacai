//
//  DPHLHeartConfrimVC.m
//  Jackpot
//
//  Created by Ray on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPFlowSets.h"
#import "DPHLHeartConfrimVC.h"
#import "DPHLUserCenterViewController.h"
#import "DPLogOnViewController.h"
#import "DPSegmentedControl.h"
#import "MTStringParser.h"
#import "DPWebViewController.h"
//data
#import "Wages.pbobjc.h"
@class DPPayForCell;
/**
 *  付费按钮点击
 */
typedef void (^DPPayClick)(void);
@interface DPPayForCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *payButton; //付费按钮
@property (nonatomic, strong) UITextField *moneyTextField; //金额输入框
@property (nonatomic, strong) UILabel *introduceLabel; //费用说明
@property (nonatomic, copy) DPPayClick payClick;

@property (nonatomic, assign) NSInteger maxAmount;    ///最大金额

/**
 *  创建cell
 *
 *  @param reuseIdentifier reuseIdentifier
 *  @param pays            是否付费
 *
 *  @return cell
 */
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithPay:(BOOL)pays;

@end

@implementation DPPayForCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithPay:(BOOL)pays {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        [self buildlayoutWithPay:pays];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)buildlayoutWithPay:(BOOL)isPay {
    UIView *contentView = self.contentView;
    self.payButton.selected = isPay;
    [contentView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(5);
        make.left.equalTo(contentView).offset(15);
        make.height.mas_equalTo(35);
    }];
 
    if (isPay) {
        UILabel *yuanLabel = [[UILabel alloc] init];
        yuanLabel.text = @"元";
        yuanLabel.font = [UIFont dp_systemFontOfSize:15];
        yuanLabel.textColor = [UIColor dp_flatBlackColor];
        [contentView addSubview:yuanLabel];

        [contentView addSubview:self.moneyTextField];
        [contentView addSubview:self.introduceLabel];

        [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.moneyTextField.mas_centerY);
            make.right.equalTo(contentView).offset(-15);
            make.width.mas_equalTo(16);
        }];

        [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payButton.mas_bottom).offset(8);
            make.left.equalTo(contentView).offset(15);
            make.height.mas_equalTo(38);
            make.right.equalTo(yuanLabel.mas_left).offset(-5);
        }];

        [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.bottom.equalTo(contentView).offset(-15);
        }];
    }
}

#pragma mark - getter

- (UIButton *)payButton {
    if (_payButton == nil) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"  付费           " forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont dp_systemFontOfSize:17];
        [_payButton setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
        [_payButton setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
        [_payButton setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(pvt_pay:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.backgroundColor = [UIColor clearColor] ;
    }

    return _payButton;
}

- (UITextField *)moneyTextField {
    if (_moneyTextField == nil) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.placeholder = @"心水出售金额";
        _moneyTextField.text = @"10";
        _moneyTextField.textColor = UIColorFromRGB(0xb5b5b5);
        _moneyTextField.font = [UIFont dp_systemFontOfSize:15];
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.layer.borderColor = UIColorFromRGB(0xDAD5CC).CGColor;
        _moneyTextField.layer.borderWidth = 1;
        _moneyTextField.layer.cornerRadius = 5;
        _moneyTextField.backgroundColor = [UIColor dp_flatWhiteColor];
        _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
        _moneyTextField.leftView = ({

            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        _moneyTextField.delegate = self;
    }

    return _moneyTextField;
}

- (UILabel *)introduceLabel {
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = UIColorFromRGB(0x666666);
        _introduceLabel.font = [UIFont dp_systemFontOfSize:15];
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        _introduceLabel.text = @"当前等级发起心水的金额最大500元";
    }

    return _introduceLabel;
}

#pragma mark - 响应事件
- (void)pvt_pay:(UIButton *)sender {
    if (self.payClick) {
        self.payClick();
        self.moneyTextField.text = @"10" ;
    }
}

- (void)setMaxAmount:(NSInteger)maxAmount {
    _maxAmount = maxAmount;
    self.introduceLabel.text = [NSString stringWithFormat:@"当前等级发起心水的金额最大%zd元", maxAmount];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text integerValue] < 1) {
        textField.text = @"1";
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![KTMValidator isNumber:string]) {
        return NO;
    }

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([newString integerValue] > self.maxAmount) {
        textField.text = [NSString stringWithFormat:@"%zd", self.maxAmount];
        return NO;
    }
    return YES;
}

@end

@interface DPHLHeartConfrimVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate> {
    BOOL _ispay;           //当前是否付费
//    BOOL _hasShowToast;    //是否已经显示提示框
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *reasonTextView;    //推荐理由
@property (nonatomic, strong) DPSegmentedControl *seg;       //心水态度

@property (nonatomic, strong) UIButton *confirmButton;    //确认发起按钮
@property (nonatomic, strong) UILabel *bounceLabel;       //方案金额Label
@property (nonatomic, strong) MTStringParser *parser;

@end

@implementation DPHLHeartConfrimVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"心水确认";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.tableView];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"notice_img.png") target:self action:@selector(pvt_introduce)];

    [self buildBottomLauout];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.bounceLabel.mas_top).offset(-10);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_hiddenKdyBoard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
 }

- (void)buildBottomLauout {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor dp_flatWhiteColor];
    backView.layer.borderColor = UIColorFromRGB(0xD9D5CC).CGColor;
    backView.layer.borderWidth = 0.5;
    [self.view addSubview:backView];

    [self.view addSubview:self.bounceLabel];
    [self.view addSubview:self.confirmButton];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(-0.5);
        make.right.equalTo(self.view).offset(0.5);
        make.bottom.equalTo(self.view).offset(0.5);
        make.height.mas_equalTo(55);
    }];

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];

    CGFloat spf = 0;
    switch (self.gameType) {
        case GameTypeJcSpf:
            spf = [self.match.spfItem.spListArray[self.selectedIndex] floatValue];
            break;

        default:
            spf = [self.match.rqspfItem.spListArray[self.selectedIndex] floatValue];
            break;
    }

    NSString *markstr = [NSString stringWithFormat:@"方案金额：<red>2</red>元\n预计奖金：<red>%.2f</red>元", 2.0 * spf];
    self.bounceLabel.attributedText = [self.parser attributedStringFromMarkup:markstr];

    [self.bounceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_top).offset(-10);
        make.left.and.right.equalTo(self.view);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 }

#pragma mark -  响应事件

- (void)pvt_introduce {
    
    DPWebViewController *vc = [[DPWebViewController alloc]init];
    vc.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpHeartConfirmURL]] ;
    [self.navigationController pushViewController: vc  animated:YES];

}
- (void)pvt_hiddenKdyBoard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)pvt_comfirm {
    DPLog(@"提交");

    if (!self.userInfo.isCanCreateWages) {
        [[DPToast makeText:@"今天的发起心水数已满"] show];
        return;
    }

    if ([DPMemberManager sharedInstance].isLogin) {
        [self createProject];
    } else {
        @weakify(self);
        [self loginWithCallback:^{
            @strongify(self);
            // 从登录界面返回, 是否自动执行下一步
            [self createProject];
        }];
    }
}

- (void)loginWithCallback:(void (^)(void))block {
    DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
    viewController.finishBlock = block;
    [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
}

#pragma mark - 创建投注
- (void)createProject {
    [self showDarkHUD];

    //    NSString *urlStr = [NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%lld&gameTypeId=%d", self.match.gameMatchId, self.gameType];
    //
    //    @weakify(self);
    //    [[AFHTTPSessionManager dp_sharedManager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //        @strongify(self);

    DPPayForCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    CreateWagesInput *wagesInput = [CreateWagesInput message];
    wagesInput.userId = [[[DPMemberManager sharedInstance] userId] integerValue];
    wagesInput.gameMatchId = self.match.gameMatchId;
    wagesInput.price = _ispay ? [cell.moneyTextField.text intValue] : 0;
    wagesInput.description_p = [DPBetDescription descriptionJczqWithOption:@[ [self getBetStore:self.match] ] passMode:@[ @(0x01010101) ] gameType:GameTypeJcHt note:1];
    wagesInput.gameTypeId = self.gameType;

    wagesInput.declareType = self.seg.selectedIndex == 0 ? CreateWagesInput_DeclareTypeEnume_Solid : CreateWagesInput_DeclareTypeEnume_Radical;
    wagesInput.reason = self.reasonTextView.text;

    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/wages/CreateWages" parameters:wagesInput success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        DPLog(@"成功");
        [self dismissDarkHUD];
        [[DPToast makeText:@"发起心水成功"] show];
        //            CreateWagesOuput *outPut = [CreateWagesOuput parseFromData:responseObject error:nil];

        [self.navigationController pushViewController:[[DPHLUserCenterViewController alloc] init] animated:YES];
 
    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissDarkHUD];
            [[DPToast makeText:error.dp_errorMessage] show];

        }];

    //    }
    //        failure:^(NSURLSessionDataTask *task, NSError *error) {
    //            [self dismissDarkHUD];
    //            [[DPToast makeText:error.dp_errorMessage] show];
    //        }];
}

#pragma mark - 获取存储对象
- (DPJczqBetStore *)getBetStore:(PBMJczqMatch *)match {
    DPJczqBetStore *betOption = [[DPJczqBetStore alloc] init];

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

    betOption.rqs = match.rqs;
    betOption.matchId = match.gameMatchId;
    betOption.orderNumberName = match.orderNumberName;

    return betOption;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.seg]) {
        return NO;
    }

    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UITextView class]]) {
        return NO;
    }

    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];

        });

    });
}

/*
- (void)textViewDidChange:(UITextView *)textView {
    _hasShowToast = NO;
}
*/
- (void)textViewChangeNotify {
//    if (!_hasShowToast) {
//        [[DPToast makeText:@"字数限制50个字"] show];
//        _hasShowToast = YES;
//    }
}
 

#pragma mark - Keybaord Show Hide Notification

- (void)keyboardWillShowAction:(NSNotification *)aNotification {
    [self keyboardAction:aNotification isShow:YES];
}

- (void)keyboardWillHideAction:(NSNotification *)aNotification {
     [self keyboardAction:aNotification isShow:NO];
}


- (void)keyboardAction:(NSNotification *)aNotification isShow:(BOOL)isShow {
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve << 16];

    UIEdgeInsets inset = [self.tableView contentInset];

    if (isShow) {
        inset.bottom = keyboardFrame.size.height + 10 - 44;
    } else {
        inset.bottom = 10 - 44;
    }

    [self.tableView setContentInset:inset];

    if (isShow && [self.reasonTextView isFirstResponder]) {
        [self scrollToBottomAnimated:YES];
    }

    [UIView commitAnimations];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    //        CGFloat offset = MAX(0, self.tableView.contentSize.height - keyboardFrame.origin.y + 64 + 44);
    //        [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
    if ([self.tableView numberOfRowsInSection:0] > 1) {
        NSUInteger lastRowNumber = [self.tableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tableView scrollToRowAtIndexPath:ip
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_ispay) {
            static NSString *cellIdentifyNormal = @"cellIdentifyNormal";
            DPPayForCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyNormal];
            if (cell == nil) {
                cell = [[DPPayForCell alloc] initWithReuseIdentifier:cellIdentifyNormal WithPay:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
                 @weakify(self);
                cell.payClick = ^{
                    @strongify(self);
                     _ispay = NO;
                    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                 };
                UILabel *lineView = [[UILabel alloc] init];
                lineView.backgroundColor = UIColorFromRGB(0xD9D5CC);
                [cell.contentView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell.contentView);
                    make.left.and.right.equalTo(cell.contentView);
                    make.height.mas_equalTo(0.5);
                }];
                cell.maxAmount = self.userInfo.wagesMaxAmount;
            }

            return cell;

        } else {
            static NSString *cellIdentifySelected = @"cellIdentifySelected";
            DPPayForCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifySelected];
            if (cell == nil) {
                cell = [[DPPayForCell alloc] initWithReuseIdentifier:cellIdentifySelected WithPay:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
                 @weakify(self);

                cell.payClick = ^{
                    @strongify(self);
                    if (self.userInfo.wagesLevel > 1) {
                        _ispay = YES;
                        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
                    } else {
                        [[DPToast makeText:@"当前等级不能发起付费心水"] show];
                    }

                };
                UILabel *lineView = [[UILabel alloc] init];
                lineView.backgroundColor = UIColorFromRGB(0xD9D5CC);
                [cell.contentView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell.contentView);
                    make.left.and.right.equalTo(cell.contentView);
                    make.height.mas_equalTo(0.5);
                }];
            }
             return cell;
        }

    } else if (indexPath.row == 1) {
        static NSString *cellIdentify = @"cellIdentify";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];

            UILabel *attitudeLabel = [[UILabel alloc] init];
            attitudeLabel.text = @"心水态度:";
            attitudeLabel.font = [UIFont dp_systemFontOfSize:15];
            attitudeLabel.textColor = UIColorFromRGB(0x666666);
            [cell.contentView addSubview:attitudeLabel];
            [attitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.centerY.equalTo(cell.contentView);
            }];

            self.seg = [[DPSegmentedControl alloc] initWithItems:@[ @"稳健", @"激进" ]];
            self.seg.indicatorColor = [UIColor dp_flatRedColor];
            self.seg.textColor = [UIColor dp_flatBlackColor];
            self.seg.tintColor = UIColorFromRGB(0xDAD5CC);
            [cell.contentView addSubview:self.seg];
            [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(attitudeLabel.mas_right).offset(15);
                make.centerY.equalTo(cell.contentView);
                make.height.mas_equalTo(36);
                make.width.mas_equalTo(184.0 / 320.0 * kScreenWidth);
            }];

            UILabel *lineView = [[UILabel alloc] init];
            lineView.backgroundColor = UIColorFromRGB(0xD9D5CC);
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(15);
                make.right.equalTo(cell.contentView);
                make.height.mas_equalTo(0.5);
            }];
        }

        return cell;
    }

    static NSString *cellReasonIdentify = @"cellReasonIdentify";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReasonIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReasonIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];

        UILabel *attitudeLabel = [[UILabel alloc] init];
        attitudeLabel.text = @"推荐理由:";
        attitudeLabel.font = [UIFont dp_systemFontOfSize:15];
        attitudeLabel.textColor = UIColorFromRGB(0x666666);
        [cell.contentView addSubview:attitudeLabel];
        [attitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.top.equalTo(cell.contentView);
            make.height.mas_equalTo(46);
        }];

        self.reasonTextView = [[UITextView alloc] init];
        self.reasonTextView.layer.cornerRadius = 5;
        self.reasonTextView.layer.borderWidth = 1;
        self.reasonTextView.delegate = self;
        self.reasonTextView.layer.borderColor = UIColorFromRGB(0xDAD5CC).CGColor;
        self.reasonTextView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.reasonTextView.font = [UIFont dp_systemFontOfSize:15];
        [self.reasonTextView addTarget:self action:@selector(textViewChangeNotify) limitMax:50];
        [cell.contentView addSubview:self.reasonTextView];
        [self.reasonTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.top.equalTo(attitudeLabel.mas_bottom);
            make.height.mas_equalTo(62);
            make.right.equalTo(cell.contentView).offset(-15);
        }];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_ispay) {
            return 127;
        }

        return 49;
    }
    if (indexPath.row == 1)
        return 67;

    return 92;
}

#pragma mark - getter

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.font = [UIFont dp_systemFontOfSize:14];
                     attr.textColor = [UIColor dp_flatBlackColor];
                     attr.alignment = NSTextAlignmentCenter;
                     attr;
                 })];
        [_parser addStyleWithTagName:@"red" color:[UIColor dp_flatRedColor]];
    }

    return _parser;
}

- (UILabel *)bounceLabel {
    if (_bounceLabel == nil) {
        _bounceLabel = [[UILabel alloc] init];
        _bounceLabel.font = [UIFont dp_systemFontOfSize:14];
        _bounceLabel.numberOfLines = 2;
        _bounceLabel.textAlignment = NSTextAlignmentCenter;
        _bounceLabel.attributedText = [self.parser attributedStringFromMarkup:@"方案金额：<red>2</red>元\n预计奖金：<red>500</red>元"];
    }
    return _bounceLabel;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor dp_flatRedColor];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.titleLabel.font = [UIFont dp_boldSystemFontOfSize:18];
        [_confirmButton setTitle:@"确认发起" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(pvt_comfirm) forControlEvents:UIControlEventTouchUpInside];
    }

    return _confirmButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
