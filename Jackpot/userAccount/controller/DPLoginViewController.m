//
//  DPLoginViewController.m
//  Jackpot
//
//  Created by mu on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面注释由sxf提供，如有更改请标示

//controller

#import "DPLoginViewController.h"
#import "DPThirdCallCenter.h"
#import "DPThirdLoginVerifyController.h"
#import "DPOpenBetServiceController.h"
#import "DPUADazhihuiLoginController.h"
#import "UIViewController+DPUALoginToOpenBet.h"
//view
#import "DPUALoginCell.h"
//data
#import "DPUARequestData.h"
//BASE
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"

@interface DPLoginViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *contentTable;//列表
@property (nonatomic, strong) NSMutableArray *tableData;//列表数据源
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) DPThirdLoginOnView *thirdLogOnView;//第三方登录视图
@property (nonatomic, strong) UIButton *loginBtn;//注册
@property (nonatomic, strong) UITextField *phoneNumTF;//手机号码
@property (nonatomic, strong) UITextField *veritifyTF;//验证码
@property (nonatomic, strong) UITextField *passwordTf;//密码
@property (nonatomic, strong) UIButton *verifyBtn;//获取验证码
@property (nonatomic, assign) NSInteger waitTime;//倒计时间隔
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *contractBtn;
@end

@implementation DPLoginViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.waitTime = 12;

    [self.view addSubview:self.contentTable];
    //注册第三方登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLogOnSuccess:) name:dp_ThirdLoginSuccess object:nil];
}

#pragma mark---------contentTable
//列表
- (UITableView *)contentTable {
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.tableFooterView = self.footView;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _contentTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        UITapGestureRecognizer *closeKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboardTapped)];
        [_contentTable addGestureRecognizer:closeKeyboard];
    }
    return _contentTable;
}
//function 关闭键盘
- (void)closeKeyboardTapped {
    [self.view endEditing:YES];
}
//table's delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPUALoginCell *cell = [[DPUALoginCell alloc] initWithTableView:tableView atIndexPath:indexPath];
    cell.textField.delegate = self;
    if (indexPath.row == 0) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneNumTF = cell.textField;
    } else if (indexPath.row == 1) {
        self.veritifyTF = cell.textField;
        self.verifyBtn = cell.cellBtn;
        self.veritifyTF.keyboardType = UIKeyboardTypeNumberPad;
        
    } else if (indexPath.row == 2) {
        cell.textField.secureTextEntry = YES;
        self.passwordTf = cell.textField;
    }
    @weakify(self);
    cell.btnBlock = ^(UIButton *btn) {
        @strongify(self);
        if (indexPath.row == 1) {
            if (self.phoneNumTF.text.length <= 0) {
                [[DPToast makeText:@"请输入手机号码" color:[UIColor dp_flatBlackColor]] show];
                return ;
            }
            if (![self.phoneNumTF.text checkPhoneNumInput]) {
                [[DPToast makeText:@"手机号码格式错误" color:[UIColor dp_flatBlackColor]] show];
                return;
            }
            [self virityPhoneNum];
        } else if (indexPath.row == 2) {
            btn.selected = !btn.selected;
        }
    };
    cell.object = self.tableData[indexPath.row];
    return cell;
}
//text's delegete in table
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//tableData  数据源
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            switch (i) {
                case 0: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"手机号码:";
                    object.subTitle = @"请输入手机号（可用于登录）";
                    object.describTitle = @"";
                    object.describValue = @"";
                    [_tableData addObject:object];
                } break;
                case 1: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"验  证  码:";
                    object.subTitle = @"请输入验证码";
                    object.describTitle = @"获取验证码";
                    object.describValue = @"";
                    [_tableData addObject:object];
                } break;
                case 2: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"密       码:";
                    object.subTitle = @"请输入密码";
                    object.subValue = @"passopen.png";
                    object.describValue = @"passclose.png";
                    [_tableData addObject:object];
                } break;
                default:
                    break;
            }
        }
    }
    return _tableData;
}
#pragma mark---------footView

//底部视图 协议和注册
- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 365)];
        UILabel *contractLabel = [[UILabel alloc] init];
        contractLabel.textColor = colorWithRGB(185, 181, 168);
        NSMutableAttributedString *contractText = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意《大彩网购彩票服务协议》"];
        [contractText addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatBlueColor] range:NSMakeRange(5, contractText.length - 5)];
        contractLabel.attributedText = contractText;
        contractLabel.userInteractionEnabled = YES;
        contractLabel.font = [UIFont systemFontOfSize:12];
        contractLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *contractTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contractLabelTapped)];
        [contractLabel addGestureRecognizer:contractTapped];
        [_footView addSubview:contractLabel];
        [contractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];

        UIButton *contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contractBtn.layer.cornerRadius = 3;
        contractBtn.selected = YES;
        [contractBtn setImage:dp_AccountImage(@"unRememberPassword.png") forState:UIControlStateNormal];
        [contractBtn setImage:dp_AccountImage(@"rememberPassword.png") forState:UIControlStateSelected];
        [contractBtn addTarget:self action:@selector(contractBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:contractBtn];
        self.contractBtn = contractBtn;
        CGSize contractLabelSize = [NSString dpsizeWithSting:contractLabel.text andFont:[UIFont systemFontOfSize:12] andMaxWidth:MAXFLOAT];
        [contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contractLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.right.mas_equalTo(contractLabel.mas_centerX).offset(-contractLabelSize.width * 0.5 - 5);
        }];

        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        loginBtn.layer.cornerRadius = 5;
        [loginBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        loginBtn.dp_eventId = DPAnalyticsTypeRegistButton;
        [loginBtn addTarget:self action:@selector(loginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contractLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        self.loginBtn = loginBtn;

        DPThirdLoginOnView *thirdLoginOnView = [[DPThirdLoginOnView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 0)];
        thirdLoginOnView.fromLogInVC = NO;
        thirdLoginOnView.items = @[ @"QQ.png", @"weiXin_Login.png", @"daZhiHui.png", @"aliPay.png", @"sinaWeibo.png" ];
        @weakify(self);
        thirdLoginOnView.btnBlock = ^(UIButton *btn) {
            @strongify(self);
            DPUADazhihuiLoginController *controller = [[DPUADazhihuiLoginController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        };
        [_footView addSubview:thirdLoginOnView];
        self.thirdLogOnView = thirdLoginOnView;
        [thirdLoginOnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loginBtn.mas_bottom).offset(50);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(100);
        }];
    }
    return _footView;
}
//协议选择
- (void)contractBtnTapped:(UIButton *)btn {
    btn.selected = !btn.selected;
}
//协议跳转
- (void)contractLabelTapped {
    DPWebViewController *controller = [[DPWebViewController alloc] init];
    controller.title = @"购彩协议";
    NSString *url = [NSString stringWithFormat:@"%@%@", kServerBaseURL, @"/web/help/BuyProtocol"];
    controller.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}
//注册判断
- (void)loginBtnTapped {
    if (self.phoneNumTF.text.length <= 0) {
        [[DPToast makeText:@"请输入手机号码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.veritifyTF.text.length <= 0) {
        [[DPToast makeText:@"请输入验证码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.passwordTf.text.length <= 0) {
        [[DPToast makeText:@"请输入密码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.phoneNumTF.text.length!=11) {
        [[DPToast makeText:@"手机号码格式错误" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (!self.contractBtn.selected) {
        [[DPToast makeText:@"请勾选大彩网购彩服务协议" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    [self requestLogin];
    
}
//注册请求
- (void)requestLogin{
    PBMLogInParam *param = [[PBMLogInParam alloc] init];
    param.userPhonenum = self.phoneNumTF.text;
    param.userPassword = self.passwordTf.text;
    param.veritynum = self.veritifyTF.text;
    param.pushToken = [KTMUtilities pushDeviceToken];
    [self showHUD];
    @weakify(self);
    [DPUARequestData logonWithParam:param Success:^(PBMLoginItem *loginItem) {
        @strongify(self);
        [self dismissHUD];
        [[DPMemberManager sharedInstance] loginWithName:loginItem.userNickName nickName:loginItem.userNickName userId:[NSString stringWithFormat:@"%zd", loginItem.userId] sessionToken:loginItem.sessionContent secureKey:loginItem.secureKey bangdingPhoneNum:loginItem.bangdingPhoneNum betOpen:loginItem.betOpen];
        DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
        controller.pathSource = DPPathSourceSignUp;
        [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
    }
    andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
#pragma mark---------function
//验证码获取
- (void)virityPhoneNum {
    [self showHUD];
    PBMPhoneVerCodeRes *param = [[PBMPhoneVerCodeRes alloc] init];
    param.phoneNumber = self.phoneNumTF.text;
    @weakify(self);
    [DPUARequestData verityWithParam:param
                             Success:^(PBMVerityItem *verityItem) {
                                 @strongify(self);
                                [self dismissHUD];
                                self.waitTime = verityItem.endTime;
                                self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lunXun) userInfo:nil repeats:YES];
                                [self.timer fire];
                            }
                             andFail:^(NSString *failMessage) {
                                 @strongify(self);
                                [self dismissHUD];
                                [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
                            }];
}
//倒计时
- (void)lunXun {
    self.waitTime --;
    if (self.waitTime > 0){
        self.verifyBtn.enabled = NO;
        self.verifyBtn.backgroundColor = [UIColor lightGrayColor];
        NSString *tempStr = [NSString stringWithFormat:@"%zd秒后重发", self.waitTime];
        [self.verifyBtn setTitle:tempStr forState:UIControlStateNormal];
        [self.verifyBtn setTitle:tempStr forState:UIControlStateDisabled];
    }else{
        self.verifyBtn.enabled = YES;
        self.verifyBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        [self.verifyBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}
//第三方注册成功回调
- (void)thirdLogOnSuccess:(NSNotification *)notice {
    if (self == self.navigationController.topViewController) {
        NSDictionary *userInfo = notice.userInfo;
        PBMThirdLogOnParam *param = [[PBMThirdLogOnParam alloc] init];
        param.openid = userInfo[dp_ThirdOauthUserIDKey];
        param.accessToken = userInfo[dp_ThirdOauthAccessToken];
        param.type = [userInfo[dp_ThirdType] intValue];
        param.pushToken = [KTMUtilities pushDeviceToken];
        @weakify(self);
        [DPUARequestData thirdLoginWithParam:param
                                     Success:^(PBMThirdLogOnItem *thirdLogonItem) {
                                         @strongify(self);

                                        [[DPMemberManager sharedInstance]loginWithName:thirdLogonItem.loginItem.userNickName nickName:thirdLogonItem.loginItem.userNickName userId:[NSString stringWithFormat:@"%zd",thirdLogonItem.loginItem.userId] sessionToken:thirdLogonItem.loginItem.sessionContent secureKey:thirdLogonItem.loginItem.secureKey bangdingPhoneNum:thirdLogonItem.loginItem.bangdingPhoneNum betOpen:thirdLogonItem.loginItem.betOpen];
                                        [DPMemberManager sharedInstance].iconImageURL = thirdLogonItem.iconURL;
                                        if (thirdLogonItem.loginItem.bangdingPhoneNum) {
                                            if (thirdLogonItem.loginItem.betOpen || [[DPMemberManager sharedInstance].loginTime integerValue] > 1) {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            } else {
                                                DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
                                                controller.pathSource = DPPathSourceOAuth;
                                                [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
                                            }
                                        } else {
                                            DPThirdLoginVerifyController *controller = [[DPThirdLoginVerifyController alloc] init];
                                            controller.thirdLogonItem = thirdLogonItem;
                                            [self.navigationController pushViewController:controller animated:YES];
                                        }
                                    }
                                    andFail:^(NSString *failMessage) {
                                        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
                                    }];
    }
}

@end
