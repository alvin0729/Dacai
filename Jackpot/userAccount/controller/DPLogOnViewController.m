//
//  DPLogOnViewController.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面注释由sxf提供,如有更改，请标示

#import "DPLogOnViewController.h"
#import "DPLoginViewController.h"
#import "DPLosePayPassWordViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPSecurityCenterInfoViewController.h"
#import "DPThirdCallCenter.h"
#import "DPThirdLoginVerifyController.h"
#import "DPUASetViewController.h"
#import "UIViewController+DPUALoginToOpenBet.h"
//view
#import "DPIconTextCell.h"
#import "DPThirdLoginOnView.h"
//UM
#import "DPUADazhihuiLoginController.h"
#import "UMComFeed.h"
#import "UMComFeedStyle.h"
#import "UMComHomeFeedViewController.h"
#import "UMComLoginManager.h"
#import "UMComManagedObject.h"
#import "UMComNavigationController.h"
#import "UMComSession.h"
#import "UMComUserAccount.h"
#import "UMCommunity.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
//data
#import "DPUARequestData.h"
#import "KTMUserDefaults+Jackpot.h"

@interface DPLogOnViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) UIView *footView;              //
@property (nonatomic, strong) UITextField *useNameTf;        //用户名输入框
@property (nonatomic, strong) UITextField *usePassowrdTF;    //用户密码输入框
@property (nonatomic, strong) UIButton *rememberBtn;         //记住用户名按钮
@property (nonatomic, strong) NSString *userName;            //用户名
@property (nonatomic, strong) NSString *password;            //用户密码
@property (nonatomic, assign) BOOL isRemember;               //是否记住用户名
@property (nonatomic, strong) PBMLoginItem *loginItem;       //  出参：登录注册接口
@property (nonatomic, strong) UMComFeed *feed;
@end

@implementation DPLogOnViewController
#pragma mark---------life

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.title = @"大彩账户登录";
    //注册的第三方通知消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLogOnSuccess:) name:dp_ThirdLoginSuccess object:nil];

    [super viewDidLoad];
    [self.view addSubview:self.contentTable];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_AccountImage(@"UASet.png") target:self action:@selector(setItemTapped)];
    //获取系统里保存的用户名
    self.userName = [KTMUserDefaults standardUserDefaults].userName;
    if (self.userName.length > 0) {
        self.isRemember = YES;
    } else {
        self.isRemember = NO;
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
}
- (void)didBackTapped {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rememberBtn.selected = self.isRemember;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)setItemTapped {
    [self.navigationController pushViewController:[[DPUASetViewController alloc] init] animated:YES];
}
#pragma mark---------data

/**
 *  普通登录
 */
- (void)requestLogon {
    //  出参：登录注册接口
    PBMLogOnParam *param = [[PBMLogOnParam alloc] init];
    param.userName = self.useNameTf.text;
    param.userPassword = self.usePassowrdTF.text;
    param.pushToken = [KTMUtilities pushDeviceToken];
    [self showHUD];
    @weakify(self);
    [DPUARequestData loginWithParam:param Success:^(PBMLoginItem *loginItem) {
        @strongify(self);
        [self dismissHUD];
        /**
         *登录成功后保存
         */
        [[DPMemberManager sharedInstance] loginWithName:loginItem.userNickName  //用户名
                                               nickName:loginItem.userNickName  //昵称
                                                 userId:[NSString stringWithFormat:@"%zd", loginItem.userId]//用户id
                                           sessionToken:loginItem.sessionContent //用户session
                                              secureKey:loginItem.secureKey // 通信密钥
                                       bangdingPhoneNum:loginItem.bangdingPhoneNum // 是否绑定手机
                                                betOpen:loginItem.betOpen]; // 是否开通服务

        if (loginItem.bangdingPhoneNum)//手机已认证
        {
            if ([[DPMemberManager sharedInstance].loginTime integerValue] > 1 || loginItem.betOpen) {
                [self rememberUserInfo];
                self.loginItem = loginItem;

                if (self.navigationController.viewControllers.count > 1) {
                    [self.navigationController dp_popViewControllerAnimated:YES completion:^{
                        if (loginItem.sessionContent && self.finishBlock) {
                            self.finishBlock();
                        }
                    }];
                } else {
                    [self dismissViewControllerAnimated:YES completion:^{
                        if (loginItem.sessionContent && self.finishBlock) {
                            self.finishBlock();
                        }
                    }];
                }

                [self umLogonWithNext:NO];
            } else {
                //跳转到开通服务
                [self rememberUserInfo];
                DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
                controller.pathSource = DPPathSourceSignIn;
                [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
            }
        } else {
            [self rememberUserInfo];
            //跳转到绑定手机
            DPThirdLoginVerifyController *controller = [[DPThirdLoginVerifyController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
        andFail:^(NSString *failMessage) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
        }];
}
#pragma mark---------contentTable
- (UITableView *)contentTable {
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _contentTable.dataSource = self;
        _contentTable.delegate = self;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.tableFooterView = self.footView;
        _contentTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        UITapGestureRecognizer *closeKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
        [_contentTable addGestureRecognizer:closeKeyboardGesture];
    }
    return _contentTable;
}
//手势关闭键盘
- (void)closeKeyBoard:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPIconTextCell *cell = [[DPIconTextCell alloc] initWithTableView:tableView atIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.iconImage.image = dp_AccountImage(@"userName.png");
        cell.text.placeholder = @"用户名/手机账号";
        self.useNameTf = cell.text;
        if (self.userName.length > 0) {
            self.useNameTf.text = self.userName;
        }
    } else {
        cell.iconImage.image = dp_AccountImage(@"password.png");
        cell.text.placeholder = @"请输入密码";
        cell.text.secureTextEntry = YES;
        self.usePassowrdTF = cell.text;
        if (self.password.length > 0) {
            self.usePassowrdTF.text = self.password;
        }
    }

    return cell;
}
#pragma mark---------footerView

//底部Ui
- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 430)];

        //rememberIcon
        UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rememberBtn.imageView.bounds = CGRectMake(0, 0, 25, 25);
        rememberBtn.imageView.contentMode = UIViewContentModeCenter;
        rememberBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        rememberBtn.backgroundColor = [UIColor clearColor];
        [rememberBtn setTitle:@" 记住用户名" forState:UIControlStateNormal];
        [rememberBtn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateNormal];
        [rememberBtn addTarget:self action:@selector(rememberBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [rememberBtn setImage:dp_AccountImage(@"unRememberPassword.png") forState:UIControlStateNormal];
        [rememberBtn setImage:dp_AccountImage(@"rememberPassword.png") forState:UIControlStateSelected];
        [_footView addSubview:rememberBtn];
        self.rememberBtn = rememberBtn;
        [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];

        UIButton *forgetButton = [[UIButton alloc] init];
        [forgetButton setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
        forgetButton.backgroundColor = [UIColor clearColor];
        forgetButton.dp_eventId = DPAnalyticsTypeLoginForget;
        [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        @weakify(self);
        [[forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            DPTestOldPhoneViewController *vc = [[DPTestOldPhoneViewController alloc] init];
            vc.vcType = verPhoneTypeVCForLogin;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_footView addSubview:forgetButton];
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rememberBtn.mas_centerY);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(18);
        }];

        UIButton *logOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logOnBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        logOnBtn.layer.cornerRadius = 5;
        logOnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [logOnBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [logOnBtn setTitle:@"登录" forState:UIControlStateNormal];
        logOnBtn.dp_eventId = DPAnalyticsTypeLoginButton;
        [logOnBtn addTarget:self action:@selector(logOnBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:logOnBtn];
        [logOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(49);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];

        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.backgroundColor = [UIColor dp_flatWhiteColor];
        loginBtn.layer.cornerRadius = 5;
        loginBtn.layer.borderWidth = 0.5;
        loginBtn.layer.borderColor = UIColorFromRGB(0xb5b5b5).CGColor;
        [loginBtn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.navigationController pushViewController:[[DPLoginViewController alloc] init] animated:YES];
        }];
        [_footView addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logOnBtn.mas_bottom).offset(12);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        
        //第三方登录
        DPThirdLoginOnView *thirdLoginOnView = [[DPThirdLoginOnView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 0)];
        thirdLoginOnView.fromLogInVC = YES;
        thirdLoginOnView.items = @[ @"QQ.png", @"weiXin_Login.png", @"daZhiHui.png", @"aliPay.png", @"sinaWeibo.png" ];
        thirdLoginOnView.btnBlock = ^(UIButton *btn) {
            @strongify(self);
            DPUADazhihuiLoginController *controller = [[DPUADazhihuiLoginController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        };
        [_footView addSubview:thirdLoginOnView];
        [thirdLoginOnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loginBtn.mas_bottom).offset(50);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(100);
        }];
    }
    return _footView;
}
//点击记住用户名
- (void)rememberBtnTapped:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self rememberUserInfo];
}

//用户名存沙盒里
- (void)rememberUserInfo {
    KTMUserDefaults *userDefaults = [KTMUserDefaults standardUserDefaults];
    if (self.rememberBtn.selected) {
        userDefaults.userName = self.useNameTf.text;
    } else {
        userDefaults.userName = nil;
    }
}
//点击登录
- (void)logOnBtnTapped:(UIButton *)btn {
    if (self.useNameTf.text.length > 0) {
        if (self.usePassowrdTF.text.length > 0) {
            //登录
            [self requestLogon];

        } else {
            [[DPToast makeText:@"请输入密码" color:[UIColor dp_flatBlackColor]] show];
        }
    } else {
        [[DPToast makeText:@"请输入用户名/手机号码" color:[UIColor dp_flatBlackColor]] show];
    }
}
//第三方登录/注册
- (void)thirdLogOnSuccess:(NSNotification *)notice {
    if (self == self.navigationController.topViewController) {
        NSDictionary *userInfo = notice.userInfo;
        PBMThirdLogOnParam *param = [[PBMThirdLogOnParam alloc] init];
        param.openid = userInfo[dp_ThirdOauthUserIDKey];
        param.accessToken = userInfo[dp_ThirdOauthAccessToken];
        param.type = [userInfo[dp_ThirdType] intValue];
        param.pushToken = [KTMUtilities pushDeviceToken];
        [self showHUD];
        @weakify(self);
        [DPUARequestData thirdLoginWithParam:param Success:^(PBMThirdLogOnItem *thirdLogonItem) {
            @strongify(self);
            [self dismissHUD];
          //第三方登录成功存入底层的数据
            [[DPMemberManager sharedInstance] loginWithName:thirdLogonItem.loginItem.userNickName   
                                                   nickName:thirdLogonItem.loginItem.userNickName
                                                     userId:[NSString stringWithFormat:@"%zd", thirdLogonItem.loginItem.userId]
                                               sessionToken:thirdLogonItem.loginItem.sessionContent
                                                  secureKey:thirdLogonItem.loginItem.secureKey bangdingPhoneNum:thirdLogonItem.loginItem.bangdingPhoneNum betOpen:thirdLogonItem.loginItem.betOpen];
            [DPMemberManager sharedInstance].iconImageURL = thirdLogonItem.iconURL;

            if (thirdLogonItem.loginItem.bangdingPhoneNum)//第三方登录绑定手机
            {
                if (thirdLogonItem.loginItem.betOpen || [[DPMemberManager sharedInstance].loginTime integerValue] > 1)//当前账号已开通投注服务
                {
                    [self didBackTapped];
                    [self umLogonWithNext:NO];
                } else //未开通投注服务时跳转到开通投注服务里
                {
                    DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc] init];
                    controller.pathSource = DPPathSourceSignIn;
                    [self umLogonWithNext:YES];
                    [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
                }
            } else//未绑定手机
            {
                [self umLogonWithNext:YES];
                DPThirdLoginVerifyController *controller = [[DPThirdLoginVerifyController alloc] init];
                controller.thirdLogonItem = thirdLogonItem;
                [self.navigationController pushViewController:controller animated:YES];
            }

        }
            andFail:^(NSString *failMessage) {
                [self dismissHUD];
                [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
            }];
    }
}

//友盟登录是否可用
- (void)umLogonWithNext:(BOOL)haveNext {
    //友盟用户注销
    [UMComLoginManager userLogout];
    UMComUserAccount *account = [[UMComUserAccount alloc] initWithSnsType:UMComSnsTypeSelfAccount];
    account.snsType = UMComSnsTypeSelfAccount; //sns对应的平台类型，例如`UMComSnsTypeSina`对应新浪
    account.usid = [DPMemberManager sharedInstance].userId;//sns平台的用户id
    account.name = [DPMemberManager sharedInstance].nickName;//sns平台的用户昵称
    account.icon_url = [DPMemberManager sharedInstance].iconImageURL;//用户头像icon地址
    [UMComLoginManager finishLoginWithAccount:account completion:^(NSArray *data, NSError *error) {
        if (haveNext == NO) {
            //第三方登录SDK登录完成并dismiss登录的页面之后，调用此方法进入社区sdk下一步的操作
            [UMComLoginManager finishDismissViewController:self data:data error:error];
        }
    }];
}
- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoadDataCompletion)loginCompletion {
    if ([DPMemberManager sharedInstance].isLogin) {
        [self umLogonWithNext:NO];
    } else {
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:self];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didSelectPlatform:(NSString *)platformName
                     feed:(UMComFeed *)feed
           viewController:(UIViewController *)viewControlller {
}
@end
