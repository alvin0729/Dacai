//
//  DPLosePayPassWordViewController.m
//  Jackpot
//
//  Created by feifei on 15/8/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLosePayPassWordViewController.h"
#import "DPSecurityCenterInfoViewController.h"
#import "JKCountDownButton.h"
#import "Security.pbobjc.h"
#import "UserAccount.pbobjc.h"
@interface DPLosePayPassWordViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate> {
@private
    UITableView *_tableView;
    UITextField *_aceNameTf;
    UITextField *_cardIdTf;
    UITextField *_phoneNumberTf;
    UITextField *_verTf;
    JKCountDownButton *_verButton;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UITextField *aceNameTf;//用户姓名
@property (nonatomic, strong, readonly) UITextField *cardIdTf;//用户身份证号
;
@property (nonatomic, strong, readonly) UITextField *phoneNumberTf;//手机号码
@property (nonatomic, strong, readonly) UITextField *verTf;//验证码
@property (nonatomic, strong, readonly) JKCountDownButton *verButton;//获取验证码
@end

@implementation DPLosePayPassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"验证信息";

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(25, 0, 0, 0));
    }];

    //底部
    UIView* tableviewFootView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tableviewFootView.frame = CGRectMake(0, 0, kScreenWidth, 90);
    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [tableviewFootView addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(tableviewFootView);
        make.width.equalTo(@(kScreenWidth - 30));
        make.top.equalTo(tableviewFootView).offset(17);
        make.height.equalTo(@44);
    }];
    self.tableView.tableFooterView = tableviewFootView;
    ;

    // Do any additional setup after loading the view.
    UITapGestureRecognizer* tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)pvt_onTap
{
    [self.view endEditing:YES];
}
- (void)keyboardWillChange:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    if (screenHeight == keyboardY) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(endFrame), 0);
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"changeCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        [self createTableViewCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 220;
}
//生成cell
- (void)createTableViewCell:(UITableViewCell*)cell
{
    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [cell.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(@220);
    }];
    UIView* aceView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* cardIdView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* phoneView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* verView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [infoView addSubview:aceView];
    [infoView addSubview:cardIdView];
    [infoView addSubview:phoneView];
    [infoView addSubview:verView];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UIView* line4 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line4];
    UIView* line5 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line5];
    [aceView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [cardIdView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceView.mas_left).offset(-5);
        make.right.equalTo(infoView);
        make.top.equalTo(aceView.mas_bottom);
        make.height.equalTo(@55);
    }];
    [phoneView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(cardIdView.mas_bottom);
        make.height.equalTo(@55);
    }];
    [verView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(cardIdView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(phoneView);
        make.height.equalTo(@0.5);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(verView);
        make.height.equalTo(@0.5);
    }];
    [line5 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(verView);
        make.height.equalTo(@0.5);
    }];

    UILabel* aceName = [self createLabel:@"姓       名:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* cardId = [self createLabel:@"身份证号:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* phoneNumber = [self createLabel:@"手机号码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* verLabel = [self createLabel:@"验 证  码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];

    [aceView addSubview:aceName];
    [aceView addSubview:self.aceNameTf];
    [cardIdView addSubview:cardId];
    [cardIdView addSubview:self.cardIdTf];
    [phoneView addSubview:phoneNumber];
    [phoneView addSubview:self.phoneNumberTf];
    [verView addSubview:self.verTf];
    [verView addSubview:verLabel];
    [verView addSubview:self.verButton];

    [aceName mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceView).offset(16);
        make.width.equalTo(@73);
        make.top.equalTo(aceView);
        make.bottom.equalTo(aceView);
    }];
    [self.aceNameTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName.mas_right).offset(5);
        make.right.equalTo(aceView);
        make.top.equalTo(aceName);
        make.bottom.equalTo(aceName);
    }];
    [cardId mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName);
        make.right.equalTo(aceName);
        make.centerY.equalTo(cardIdView);
        make.bottom.equalTo(cardIdView);
    }];
    [self.cardIdTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.aceNameTf);
        make.right.equalTo(self.aceNameTf);
        make.top.equalTo(cardId);
        make.bottom.equalTo(cardId);
    }];
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName);
        make.right.equalTo(aceName);
        make.top.equalTo(phoneView);
        make.height.equalTo(phoneView);
    }];
    [self.phoneNumberTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.aceNameTf);
        make.right.equalTo(self.aceNameTf);
        make.top.equalTo(phoneNumber);
        make.bottom.equalTo(phoneNumber);
    }];
    [verLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName);
        make.right.equalTo(aceName);
        make.top.equalTo(verView);
        make.height.equalTo(verView);
    }];
    [self.verButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(verView).offset(-16);
        make.width.equalTo(@90);
        make.centerY.equalTo(verView);
        make.height.equalTo(@35);
    }];
    [self.verTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.aceNameTf);
        make.right.equalTo(self.verButton.mas_left).offset(-5);
        make.top.equalTo(verView);
        make.bottom.equalTo(verView);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//验证信息
- (void)nextClick
{
    [self.view endEditing:YES];
    if (self.aceNameTf.text.length < 1) {
        [[DPToast makeText:@"请输入姓名"] show];
        return;
    }
    if (self.cardIdTf.text.length < 1) {
        [[DPToast makeText:@"请输入身份证号"] show];
        return;
    }

    if (self.phoneNumberTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (self.verTf.text.length < 1) {
        [[DPToast makeText:@"请输入验证码"] show];
        return;
    }

    if (self.phoneNumberTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }
    PBMFindPassWordRes* item = [[PBMFindPassWordRes alloc] init];
    item.aceName = self.aceNameTf.text;
    item.cardId = self.cardIdTf.text;
    item.phoneNumber = self.phoneNumberTf.text;
    item.verCode = self.verTf.text;
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ValidateFindPayPasswordSms"
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            PBMGetTokenRes* verItem = [PBMGetTokenRes parseFromData:responseObject error:nil];
            DPSetLoginPassWordViewController* vc = [[DPSetLoginPassWordViewController alloc] init];
            vc.pageType = 1;
            vc.isForPay = YES;
            vc.phoneNumber = self.phoneNumberTf.text;
            vc.token = verItem.token;
            [self.navigationController pushViewController:vc animated:YES];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

//获取验证码
- (void)verButtonClick
{
    [self.view endEditing:YES];
    if (self.aceNameTf.text.length < 1) {
        [[DPToast makeText:@"请输入姓名"] show];
        return;
    }
    if (self.cardIdTf.text.length < 1) {
        [[DPToast makeText:@"请输入身份证号"] show];
        return;
    }

    if (self.phoneNumberTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }

    if (self.phoneNumberTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }
    PBMFindPassWordRes* item = [[PBMFindPassWordRes alloc] init];
    item.aceName = self.aceNameTf.text;
    item.cardId = self.cardIdTf.text;
    item.phoneNumber = self.phoneNumberTf.text;
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/SendFindPayPasswordSms"
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            self.verButton.enabled = NO;
            PBMVerityItem* verItem = [PBMVerityItem parseFromData:responseObject error:nil];
            [self.verButton setTitle:[NSString stringWithFormat:@"%d秒后重发", verItem.endTime] forState:UIControlStateNormal];
            [self.verButton setBackgroundColor:[UIColor grayColor]];
            [self.verButton startWithSecond:verItem.endTime];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];

    [self.verButton addToucheHandler:^(JKCountDownButton* sender, NSInteger tag) {

        [sender didChange:^NSString*(JKCountDownButton* countDownButton, int second) {
            NSString* title = [NSString stringWithFormat:@"%d秒后重发", second];
            return title;
        }];
        [sender didFinished:^NSString*(JKCountDownButton* countDownButton, int second) {
            countDownButton.enabled = YES;
            countDownButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
            return @"重发验证码";

        }];

    }];
}

#pragma mark - getter, setter

- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
//用户姓名
- (UITextField*)aceNameTf
{
    if (_aceNameTf == nil) {
        _aceNameTf = [[UITextField alloc] init];
        _aceNameTf.backgroundColor = [UIColor clearColor];
        _aceNameTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _aceNameTf.textColor = UIColorFromRGB(0x676767);
        _aceNameTf.textAlignment = NSTextAlignmentLeft;
        _aceNameTf.font = [UIFont dp_systemFontOfSize:17];
        _aceNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _aceNameTf.placeholder = @"请输入姓名";
    }
    return _aceNameTf;
}
//用户身份证
- (UITextField*)cardIdTf
{
    if (_cardIdTf == nil) {
        _cardIdTf = [[UITextField alloc] init];
        _cardIdTf.backgroundColor = [UIColor clearColor];
        _cardIdTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _cardIdTf.textColor = UIColorFromRGB(0x676767);
        _cardIdTf.textAlignment = NSTextAlignmentLeft;
        _cardIdTf.font = [UIFont dp_systemFontOfSize:17];
        _cardIdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardIdTf.placeholder = @"请输入身份证号";
    }
    return _cardIdTf;
}
//手机号码
- (UITextField*)phoneNumberTf
{
    if (_phoneNumberTf == nil) {
        _phoneNumberTf = [[UITextField alloc] init];
        _phoneNumberTf.backgroundColor = [UIColor clearColor];
        _phoneNumberTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberTf.textColor = UIColorFromRGB(0x676767);
        _phoneNumberTf.textAlignment = NSTextAlignmentLeft;
        _phoneNumberTf.font = [UIFont dp_systemFontOfSize:17];
        _phoneNumberTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberTf.placeholder = @"请输入手机号码";
        _phoneNumberTf.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _phoneNumberTf;
}
//验证码
- (UITextField*)verTf
{
    if (_verTf == nil) {
        _verTf = [[UITextField alloc] init];
        _verTf.backgroundColor = [UIColor clearColor];
        _verTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _verTf.textColor = UIColorFromRGB(0x676767);
        _verTf.textAlignment = NSTextAlignmentLeft;
        _verTf.font = [UIFont dp_systemFontOfSize:17];
        _verTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verTf.placeholder = @"请输入验证码";
        _verTf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _verTf;
}
//获取验证码
- (JKCountDownButton*)verButton
{
    if (_verButton == nil) {
        _verButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_verButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        _verButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
        _verButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _verButton.layer.cornerRadius = 5;
        [_verButton addTarget:self action:@selector(verButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verButton;
}

- (UILabel*)createLabel:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

@end
