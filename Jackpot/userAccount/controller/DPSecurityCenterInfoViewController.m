//
//  DPSecurityCenterInfoViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPChangeBankViewController.h"
#import "DPLosePayPassWordViewController.h"
#import "DPLosePayPassWordViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPSecurityCenterInfoViewController.h"
#import "DPSecurityCenterViewController.h"
#import "JKCountDownButton.h"
#import "Security.pbobjc.h"
#import "UserAccount.pbobjc.h"
@interface DPTestOldPhoneViewController () {
@private
    UITextField *_oldPhoneTf;
    UITextField *_testTf;
    JKCountDownButton *_verButton;
}

@property (nonatomic, strong, readonly) UITextField *oldPhoneTf;//手机号码
@property (nonatomic, strong, readonly) UITextField *testTf;//验证码
@property (nonatomic, strong, readonly) JKCountDownButton *verButton;//获取验证码

@end

@implementation DPTestOldPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"验证手机";
    [self layOutView];
}
- (void)layOutView
{

    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.height.equalTo(@113);
    }];
    [infoView addSubview:self.oldPhoneTf];
    [infoView addSubview:self.testTf];
    [infoView addSubview:self.verButton];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UILabel* oldLabel = [self createLabel:@"手机号码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentRight font:[UIFont dp_systemFontOfSize:17.0]];
    oldLabel.adjustsFontSizeToFitWidth = YES;
    UILabel* verLabel = [self createLabel:@"验 证  码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentRight font:[UIFont dp_systemFontOfSize:17.0]];
    [infoView addSubview:oldLabel];
    [infoView addSubview:verLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@75);
        make.top.equalTo(infoView);
        make.bottom.equalTo(infoView.mas_centerY);
    }];
    [self.oldPhoneTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(oldLabel.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.centerY.equalTo(oldLabel);
        make.height.equalTo(@35);
    }];
    [verLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(oldLabel);
        make.right.equalTo(oldLabel);
        make.bottom.equalTo(infoView);
        make.top.equalTo(infoView.mas_centerY);
    }];
    [self.verButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.equalTo(@95);
        make.right.equalTo(infoView).offset(-15);
        make.height.equalTo(@36);
        make.centerY.equalTo(self.testTf);
    }];
    [self.testTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(verLabel.mas_right).offset(5);
        make.right.equalTo(self.verButton.mas_left).offset(-5);
        make.centerY.equalTo(verLabel);
        make.height.equalTo(@35);
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
        make.centerY.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(infoView.mas_bottom).offset(15);
        make.height.equalTo(@44);
    }];
    if (self.vcType == verPhoneTypeVCPhone) {
        //号码已丢失
        UIButton* loseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loseButton.backgroundColor = [UIColor clearColor];
        [loseButton setTitle:@"号码已丢失" forState:UIControlStateNormal];
        [loseButton setTitleColor:UIColorFromRGB(0x227ad7) forState:UIControlStateNormal];
        loseButton.backgroundColor = [UIColor clearColor];
        loseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [loseButton addTarget:self action:@selector(loseClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loseButton];

        [loseButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(nextButton);
            make.width.equalTo(@70);
            make.top.equalTo(nextButton.mas_bottom).offset(15);
            make.height.equalTo(@20);
        }];
    }
}

//获取验证码
- (void)verButtonClick
{
    [self.view endEditing:YES];
    if (self.oldPhoneTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (self.oldPhoneTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }
    PBMPhoneVerCodeRes* item = [[PBMPhoneVerCodeRes alloc] init];
    item.phoneNumber = self.oldPhoneTf.text;
    [self showHUD];
    if (self.vcType == verPhoneTypeVCPhone)//手机认证页面进入
    {
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/SendModifyMobileStepOne"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                self.verButton.enabled = NO;
                PBMVerityItem* veritem = [PBMVerityItem parseFromData:responseObject error:nil];
                [self.verButton setTitle:[NSString stringWithFormat:@"%d秒后重发", veritem.endTime] forState:UIControlStateNormal];
                [self.verButton setBackgroundColor:[UIColor grayColor]];
                [self.verButton startWithSecond:veritem.endTime];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    else if (self.vcType == verPhoneTypeVCForChangeBank)//修改提款银行卡页面进入
    {
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/SendModifyDrawBankSms"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                self.verButton.enabled = NO;
                PBMVerityItem* veritem = [PBMVerityItem parseFromData:responseObject error:nil];
                [self.verButton setTitle:[NSString stringWithFormat:@"%d秒后重发", veritem.endTime] forState:UIControlStateNormal];
                [self.verButton setBackgroundColor:[UIColor grayColor]];
                [self.verButton startWithSecond:veritem.endTime];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    else if (self.vcType == verPhoneTypeVCForLogin)//找回登录密码进入
    {
        [[AFHTTPSessionManager dp_sharedSSLManager] POST:@"/account/SendFindLoginPasswordSms"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                self.verButton.enabled = NO;
                PBMVerityItem* veritem = [PBMVerityItem parseFromData:responseObject error:nil];
                [self.verButton setTitle:[NSString stringWithFormat:@"%d秒后重发", veritem.endTime] forState:UIControlStateNormal];
                [self.verButton setBackgroundColor:[UIColor grayColor]];
                [self.verButton startWithSecond:veritem.endTime];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }

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
//验证手机
- (void)nextClick
{
    [self.view endEditing:YES];
    if (self.oldPhoneTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (self.testTf.text.length <= 0) {
        [[DPToast makeText:@"请输入验证码"] show];
        return;
    }
    if (self.oldPhoneTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }

    PBMPhoneBindingRes* item = [[PBMPhoneBindingRes alloc] init];
    item.phoneNumber = self.oldPhoneTf.text;
    item.verCode = self.testTf.text;
    [self showHUD];
    if (self.vcType == verPhoneTypeVCPhone)//手机认证页面进入
    {
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ValidateModifyMobileStepOne"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                PBMGetTokenRes* dataBase = [PBMGetTokenRes parseFromData:responseObject error:nil];
                NSMutableArray* viewControllers = self.navigationController.viewControllers.mutableCopy;
                DPBindingPhoneViewController* vc = [[DPBindingPhoneViewController alloc] init];
                vc.token = dataBase.token;
                [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    if (self.vcType == verPhoneTypeVCForChangeBank)//修改提款银行卡页面进入
    {

        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ValidateModifyDrawBankSms"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                PBMGetTokenRes* dataBase = [PBMGetTokenRes parseFromData:responseObject error:nil];
                NSMutableArray* viewControllers = self.navigationController.viewControllers.mutableCopy;
                DPChangeBankViewController* vc = [[DPChangeBankViewController alloc] init];
                vc.token = dataBase.token;
                [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    if (self.vcType == verPhoneTypeVCForLogin)//找回登录密码进入
    {
        [[AFHTTPSessionManager dp_sharedSSLManager] POST:@"/account/ValidateLoginPasswordSms"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                PBMGetTokenRes* dataBase = [PBMGetTokenRes parseFromData:responseObject error:nil];
                NSMutableArray* viewControllers = self.navigationController.viewControllers.mutableCopy;
                DPSetLoginPassWordViewController* vc = [[DPSetLoginPassWordViewController alloc] init];
                vc.pageType = 0;
                vc.token = dataBase.token;
                vc.phoneNumber = self.oldPhoneTf.text;
                [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
}
//手机号码已丢失
- (void)loseClick
{
    [self.view endEditing:YES];
    DPLosePhoneViewController* vc = [[DPLosePhoneViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
#pragma mark - getter, setter

//手机号码
- (UITextField*)oldPhoneTf
{
    if (_oldPhoneTf == nil) {
        _oldPhoneTf = [[UITextField alloc] init];
        _oldPhoneTf.backgroundColor = [UIColor clearColor];
        _oldPhoneTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _oldPhoneTf.textColor = UIColorFromRGB(0x676767);
        _oldPhoneTf.textAlignment = NSTextAlignmentLeft;
        _oldPhoneTf.font = [UIFont dp_systemFontOfSize:17];
        _oldPhoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPhoneTf.placeholder = @"请输入手机号码";
        _oldPhoneTf.keyboardType = UIKeyboardTypeNumberPad;
        //        _oldPhoneTf.returnKeyType = UIReturnKeyNext;
        //        _passTextfieldOld.delegate = self;
    }
    return _oldPhoneTf;
}
//验证码
- (UITextField*)testTf
{
    if (_testTf == nil) {
        _testTf = [[UITextField alloc] init];
        _testTf.backgroundColor = [UIColor clearColor];
        _testTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _testTf.textColor = UIColorFromRGB(0x676767);
        _testTf.textAlignment = NSTextAlignmentLeft;
        _testTf.font = [UIFont dp_systemFontOfSize:17];
        _testTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _testTf.placeholder = @"请输入验证码";
        _testTf.keyboardType = UIKeyboardTypeNumberPad;
        //        _oldPhoneTf.returnKeyType = UIReturnKeyNext;
        //        _passTextfieldOld.delegate = self;
    }
    return _testTf;
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
//生成标签
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

//绑定新手机
@interface DPBindingPhoneViewController () {
@private
    UITextField *_newPhoneTf;
    UITextField *_testTf;
    JKCountDownButton *_verButton;
}

@property (nonatomic, strong, readonly) UITextField *newPhoneTf;//新手机
@property (nonatomic, strong, readonly) UITextField *testTf;//验证码
@property (nonatomic, strong, readonly) JKCountDownButton *verButton;//获取验证码

@end

@implementation DPBindingPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"绑定新手机";
    [self layOutView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    // Do any additional setup after loading the view.
}
- (void)layOutView
{
    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.height.equalTo(@113);
    }];
    [infoView addSubview:self.newPhoneTf];
    [infoView addSubview:self.testTf];
    [infoView addSubview:self.verButton];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UILabel* oldLabel = [self createLabel:@"新手机:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentRight font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* verLabel = [self createLabel:@"验证码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentRight font:[UIFont dp_systemFontOfSize:17.0]];
    [infoView addSubview:oldLabel];
    [infoView addSubview:verLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@60);
        make.top.equalTo(infoView);
        make.bottom.equalTo(infoView.mas_centerY);
    }];
    [self.newPhoneTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(oldLabel.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.bottom.equalTo(infoView.mas_centerY);
    }];
    [verLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(oldLabel);
        make.right.equalTo(oldLabel);
        make.bottom.equalTo(infoView);
        make.top.equalTo(infoView.mas_centerY);
    }];
    [self.verButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.width.equalTo(@95);
        make.right.equalTo(infoView).offset(-15);
        make.height.equalTo(@36);
        make.centerY.equalTo(verLabel);
    }];
    [self.testTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(verLabel.mas_right).offset(5);
        make.right.equalTo(self.verButton.mas_left).offset(-5);
        make.centerY.equalTo(verLabel);
        make.height.equalTo(@35);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(10);
        make.right.equalTo(infoView);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"验证" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(infoView.mas_bottom).offset(15);
        make.height.equalTo(@44);
    }];
}
//返回到安全中心
- (void)pvt_onBack
{
    [[DPToast sharedToast] dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//验证
- (void)verButtonClick
{
    [self.view endEditing:YES];
    if (self.newPhoneTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (self.newPhoneTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }
    PBMNewPhoneVerCodeRes* item = [[PBMNewPhoneVerCodeRes alloc] init];
    item.phoneNumber = self.newPhoneTf.text;
    item.token = self.token;
    [self showHUD];
    NSString* urlString = @"/account/SendModifyMobileStepTwo";
    if (self.vcType == newPhoneTypeFromVerPhone) {
        urlString = @"/account/SendBindPhoneSms";
    }
    [[AFHTTPSessionManager dp_sharedManager] POST:urlString
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            self.verButton.enabled = NO;
            PBMVerityItem* item = [PBMVerityItem parseFromData:responseObject error:nil];
            [self.verButton setTitle:[NSString stringWithFormat:@"%d秒后重发", item.endTime] forState:UIControlStateNormal];
            [self.verButton setBackgroundColor:[UIColor grayColor]];
            [self.verButton startWithSecond:item.endTime];

        }
        failure:^(NSURLSessionDataTask* tas·k, NSError* error) {
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
//绑定
- (void)nextClick
{
    [self.view endEditing:YES];
    if (self.newPhoneTf.text.length < 1) {
        [[DPToast makeText:@"请输入手机号码"] show];
        return;
    }
    if (self.testTf.text.length <= 0) {
        [[DPToast makeText:@"请输入验证码"] show];
        return;
    }
    if (self.newPhoneTf.text.length != 11) {
        [[DPToast makeText:@"手机号码格式错误"] show];
        return;
    }

    PBMPhoneBindingRes* item = [[PBMPhoneBindingRes alloc] init];
    item.phoneNumber = self.newPhoneTf.text;
    item.verCode = self.testTf.text;
    item.token = self.token;
    NSString* urlString = @"/account/ValidateModifyMobileStepTwo";
    if (self.vcType == newPhoneTypeFromVerPhone) {
        urlString = @"/account/ValidateBindPhoneSms";
    }
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:urlString
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            [[DPToast makeText:@"手机号码修改成功"] show];
            [self.navigationController popViewControllerAnimated:YES];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

#pragma mark - getter, setter

//新手机号码
- (UITextField*)newPhoneTf
{
    if (_newPhoneTf == nil) {
        _newPhoneTf = [[UITextField alloc] init];
        _newPhoneTf.backgroundColor = [UIColor clearColor];
        _newPhoneTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPhoneTf.textColor = UIColorFromRGB(0x676767);
        _newPhoneTf.textAlignment = NSTextAlignmentLeft;
        _newPhoneTf.font = [UIFont dp_systemFontOfSize:17];
        _newPhoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPhoneTf.placeholder = @"请输入新手机号码";
        _newPhoneTf.keyboardType = UIKeyboardTypeNumberPad;
        //        _oldPhoneTf.returnKeyType = UIReturnKeyNext;
        //        _passTextfieldOld.delegate = self;
    }
    return _newPhoneTf;
}
//验证码
- (UITextField*)testTf
{
    if (_testTf == nil) {
        _testTf = [[UITextField alloc] init];
        _testTf.backgroundColor = [UIColor clearColor];
        _testTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _testTf.textColor = UIColorFromRGB(0x676767);
        _testTf.textAlignment = NSTextAlignmentLeft;
        _testTf.font = [UIFont dp_systemFontOfSize:16];
        _testTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _testTf.placeholder = @"请输入验证码";
        _testTf.keyboardType = UIKeyboardTypeNumberPad;
        //        _oldPhoneTf.returnKeyType = UIReturnKeyNext;
        //        _passTextfieldOld.delegate = self;
    }
    return _testTf;
}
//获取验证码
- (JKCountDownButton*)verButton
{
    if (_verButton == nil) {
        _verButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_verButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        _verButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
        _verButton.titleLabel.font = [UIFont systemFontOfSize:17];
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


//手机号码已丢失的情况下
@interface DPLosePhoneViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate> {
@private
    UITextField *_aceNameTf;
    UITextField *_cardIdTf;
    UITextField *_bankNumberTf;
    UITableView *_tableView;
}

@property (nonatomic, strong, readonly) UITextField *aceNameTf;//用户姓名
@property (nonatomic, strong, readonly) UITextField *cardIdTf;//用户身份证信息
@property (nonatomic, strong, readonly) UITextField *bankNumberTf;//用户提款银行卡号
@property (nonatomic, strong, readonly) UITableView *tableView;
@end

@implementation DPLosePhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"验证信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    //下一步
    UIView* tableviewFootView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tableviewFootView.frame = CGRectMake(0, 0, kScreenWidth, 59);
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
        make.left.equalTo(tableviewFootView).offset(15);
        make.right.equalTo(tableviewFootView).offset(-15);
        make.top.equalTo(tableviewFootView).offset(15);
        make.height.equalTo(@44);
    }];
    self.tableView.tableFooterView = tableviewFootView;
    UITapGestureRecognizer* tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];

    // Do any additional setup after loading the view.
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
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 190;
}
- (void)createTableViewCell:(UITableViewCell*)cell
{
    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [cell.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView).offset(25);
        make.height.equalTo(@165);
    }];
    [infoView addSubview:self.aceNameTf];
    [infoView addSubview:self.cardIdTf];
    [infoView addSubview:self.bankNumberTf];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UIView* line4 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line4];
    UILabel* aceName = [self createLabel:@"姓名:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* cardId = [self createLabel:@"身份证:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    cardId.adjustsFontSizeToFitWidth = YES;
    UILabel* bankNumber = [self createLabel:@"提款银行卡:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    bankNumber.adjustsFontSizeToFitWidth = YES;
    [infoView addSubview:aceName];
    [infoView addSubview:cardId];
    [infoView addSubview:bankNumber];
    [aceName mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@40);
        make.top.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [self.aceNameTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(aceName);
        make.bottom.equalTo(aceName);
    }];
    [cardId mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        //        make.width.equalTo(@55);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [self.cardIdTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(cardId.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(cardId);
        make.bottom.equalTo(cardId);
    }];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        //        make.width.equalTo(@80);
        make.top.equalTo(cardId.mas_bottom);
        make.height.equalTo(@55);
    }];
    [self.bankNumberTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(bankNumber.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(bankNumber);
        make.bottom.equalTo(bankNumber);
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
        make.bottom.equalTo(aceName);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.bottom.equalTo(cardId);
        make.height.equalTo(@0.5);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(bankNumber);
        make.height.equalTo(@0.5);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//绑定新手机
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

    if (self.bankNumberTf.text.length < 1) {
        [[DPToast makeText:@"请输入提现卡号"] show];
        return;
    }

    PBMPhoneLoseRes* item = [[PBMPhoneLoseRes alloc] init];
    item.aceName = self.aceNameTf.text;
    item.cardNumber = self.cardIdTf.text;
    item.bankNumber = self.bankNumberTf.text;
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ValidateUserInfo"
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            PBMGetTokenRes* item = [PBMGetTokenRes parseFromData:responseObject error:nil];
            DPBindingPhoneViewController* vc = [[DPBindingPhoneViewController alloc] init];
            vc.token = item.token;
            [self.navigationController pushViewController:vc animated:YES];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
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
//用户身份证信息
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
        _cardIdTf.placeholder = @"请输入身份证信息";
    }
    return _cardIdTf;
}
//用户提款银行卡号
- (UITextField*)bankNumberTf
{
    if (_bankNumberTf == nil) {
        _bankNumberTf = [[UITextField alloc] init];
        _bankNumberTf.backgroundColor = [UIColor clearColor];
        _bankNumberTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _bankNumberTf.textColor = UIColorFromRGB(0x676767);
        _bankNumberTf.textAlignment = NSTextAlignmentLeft;
        _bankNumberTf.font = [UIFont dp_systemFontOfSize:17];
        _bankNumberTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankNumberTf.placeholder = @"请输入提款银行卡";
        _bankNumberTf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _bankNumberTf;
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



//修改登录密码/修改支付密码
@interface DPChangeLoginPassWordViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate> {
@private
    UITextField* _oldPassWordTf;
    UITextField* _newPassWordTf;
    UITextField* _surePassWordTf;
    UITableView* _tableView;
}

@property (nonatomic, strong, readonly) UITextField* oldPassWordTf;//原密码
@property (nonatomic, strong, readonly) UITextField* newPassWordTf;//新密码
@property (nonatomic, strong, readonly) UITextField* surePassWordTf;//确定密码
@property (nonatomic, strong, readonly) UITableView* tableView;
@end

@implementation DPChangeLoginPassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"修改登录密码";
    if (self.pageType) {
        self.title = @"修改支付密码";
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 70, 0));
    }];
    UIView* tableviewFootView = [UIView dp_viewWithColor:[UIColor clearColor]];
    tableviewFootView.frame = CGRectMake(0, 0, kScreenWidth, 90);
    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [tableviewFootView addSubview:nextButton];

    //找回密码
    UIButton* loseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loseButton.backgroundColor = [UIColor clearColor];
    [loseButton setTitle:@"找回登录密码" forState:UIControlStateNormal];
    if (self.pageType == 1) {
        [loseButton setTitle:@"找回支付密码" forState:UIControlStateNormal];
    }
    [loseButton setTitleColor:UIColorFromRGB(0x227ad7) forState:UIControlStateNormal];
    loseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loseButton addTarget:self action:@selector(loseClick) forControlEvents:UIControlEventTouchUpInside];
    [tableviewFootView addSubview:loseButton];

    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(tableviewFootView);
        make.width.equalTo(@(kScreenWidth - 30));
        make.top.equalTo(tableviewFootView).offset(18);
        make.height.equalTo(@44);
    }];
    [loseButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(nextButton);
        make.width.equalTo(@90);
        make.top.equalTo(nextButton.mas_bottom).offset(15);
        make.height.equalTo(@20);
    }];
    self.tableView.tableFooterView = tableviewFootView;
    ;

    UITapGestureRecognizer* tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 185;
}
//生成cell
- (void)createTableViewCell:(UITableViewCell*)cell
{
    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [cell.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView).offset(25);
        make.height.equalTo(@165);
    }];
    [infoView addSubview:self.oldPassWordTf];
    [infoView addSubview:self.newPassWordTf];
    [infoView addSubview:self.surePassWordTf];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UIView* line4 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line4];
    UILabel* aceName = [self createLabel:@"原登录密码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* cardId = [self createLabel:@"新登录密码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* bankNumber = [self createLabel:@"确认新密码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    if (self.pageType == 1) {
        aceName.text = @"原支付密码:";
        cardId.text = @"新支付密码:";
        self.oldPassWordTf.placeholder = @"请输入原支付密码";
        self.newPassWordTf.placeholder = @"请输入新支付密码";
    }
    [infoView addSubview:aceName];
    [infoView addSubview:cardId];
    [infoView addSubview:bankNumber];
    [aceName mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@90);
        make.top.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [self.oldPassWordTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(aceName.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(aceName);
        make.bottom.equalTo(aceName);
    }];
    [cardId mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@90);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [self.newPassWordTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(cardId.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(cardId);
        make.bottom.equalTo(cardId);
    }];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.width.equalTo(@90);
        make.top.equalTo(cardId.mas_bottom);
        make.height.equalTo(@55);
    }];
    [self.surePassWordTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(bankNumber.mas_right).offset(5);
        make.right.equalTo(infoView);
        make.top.equalTo(bankNumber);
        make.bottom.equalTo(bankNumber);
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
        make.top.equalTo(cardId);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(bankNumber);
        make.height.equalTo(@0.5);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(bankNumber);
        make.height.equalTo(@0.5);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//提交新密码
- (void)nextClick
{
    [self.view endEditing:YES];
    if (self.oldPassWordTf.text.length < 1) {
        [[DPToast makeText:self.pageType ? @"请输入原支付密码" : @"请输入原登录密码"] show];
        return;
    }
    if (self.newPassWordTf.text.length < 1) {
        [[DPToast makeText:self.pageType ? @"请输入新支付密码" : @"请输入新登录密码"] show];
        return;
    }
    if (![self.newPassWordTf.text isEqualToString:self.surePassWordTf.text]) {
        [[DPToast makeText:@"2次密码不相同"] show];
        return;
    }
    PBMChangePassWordRes* item = [[PBMChangePassWordRes alloc] init];
    item.oldPassword = self.oldPassWordTf.text;
    item.newPassword = self.newPassWordTf.text;
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:[NSString stringWithFormat:@"/account/%@", (self.pageType == 1) ? @"ModifyPayPassword" : @"ModifyPassword"]
        parameters:item
        success:^(NSURLSessionDataTask* task, id responseObject) {
            [self dismissHUD];
            [self.navigationController popViewControllerAnimated:YES];
            [[DPToast makeText:@"密码修改成功"] show];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}
//找回密码
- (void)loseClick
{
    [self.view endEditing:YES];
    if (self.pageType == 0) {
        DPTestOldPhoneViewController* vc = [[DPTestOldPhoneViewController alloc] init];
        vc.vcType = verPhoneTypeVCForLogin;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    DPLosePayPassWordViewController* vc = [[DPLosePayPassWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 145, 0);
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark - getter, setter

//原密码
- (UITextField*)oldPassWordTf
{
    if (_oldPassWordTf == nil) {
        _oldPassWordTf = [[UITextField alloc] init];
        _oldPassWordTf.backgroundColor = [UIColor clearColor];
        _oldPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _oldPassWordTf.textColor = UIColorFromRGB(0x676767);
        _oldPassWordTf.textAlignment = NSTextAlignmentLeft;
        _oldPassWordTf.secureTextEntry = YES;
        _oldPassWordTf.font = [UIFont dp_systemFontOfSize:17];
        _oldPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPassWordTf.placeholder = @"请输入原登录密码";
    }
    return _oldPassWordTf;
}

//新密码
- (UITextField*)newPassWordTf
{
    if (_newPassWordTf == nil) {
        _newPassWordTf = [[UITextField alloc] init];
        _newPassWordTf.backgroundColor = [UIColor clearColor];
        _newPassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPassWordTf.textColor = UIColorFromRGB(0x676767);
        _newPassWordTf.textAlignment = NSTextAlignmentLeft;
        _newPassWordTf.secureTextEntry = YES;
        _newPassWordTf.font = [UIFont dp_systemFontOfSize:17];
        _newPassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPassWordTf.placeholder = @"请输入新登录密码";
    }
    return _newPassWordTf;
}

//确定密码
- (UITextField*)surePassWordTf
{
    if (_surePassWordTf == nil) {
        _surePassWordTf = [[UITextField alloc] init];
        _surePassWordTf.backgroundColor = [UIColor clearColor];
        _surePassWordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _surePassWordTf.textColor = UIColorFromRGB(0x676767);
        _surePassWordTf.textAlignment = NSTextAlignmentLeft;
        _surePassWordTf.secureTextEntry = YES;
        _surePassWordTf.font = [UIFont dp_systemFontOfSize:17];
        _surePassWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _surePassWordTf.placeholder = @"请确认新密码";
    }
    return _surePassWordTf;
}
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


//设置登录密码/修改密码
@interface DPSetLoginPassWordViewController () {
@private
    UITextField *_oldPhoneTf;
    UITextField *_testTf;
}

@property (nonatomic, strong, readonly) UITextField *oldPhoneTf;//密码
@property (nonatomic, strong, readonly) UITextField *testTf;//确认密码
@end

@implementation DPSetLoginPassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"设置登录密码";
    if (self.pageType == 1) {
        self.title = @"设置支付密码";
    }
    [self layOutView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    // Do any additional setup after loading the view.
}
- (void)layOutView
{
    UIView* infoView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.height.equalTo(@110);
    }];
    [infoView addSubview:self.oldPhoneTf];
    [infoView addSubview:self.testTf];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView* line3 = [UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UILabel* oldLabel = [self createLabel:@"新登录密码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel* verLabel = [self createLabel:@"确认新密码:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    if (self.pageType == 1) {
        oldLabel.text = @"新支付密码:";
        self.testTf.placeholder = @"请输入新支付密码";
    }
    else if (self.pageType == 2) {
        oldLabel.text = @"登录密码:";
        self.oldPhoneTf.placeholder = @"请输入登录密码";
        verLabel.text = @"确认密码:";
    }
    [infoView addSubview:oldLabel];
    [infoView addSubview:verLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(16);
        if (self.pageType == 2) {
            make.width.equalTo(@75);
        }
        else {
            make.width.equalTo(@90);
        }
        make.top.equalTo(infoView);
        make.bottom.equalTo(infoView.mas_centerY);
    }];
    [self.oldPhoneTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(oldLabel.mas_right).offset(5);
        make.right.equalTo(infoView).offset(-10);
        make.centerY.equalTo(oldLabel);
        make.height.equalTo(@35);
    }];
    [verLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(16);
        make.right.equalTo(oldLabel);
        make.bottom.equalTo(infoView);
        make.top.equalTo(infoView.mas_centerY);
    }];

    [self.testTf mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(verLabel.mas_right).offset(5);
        make.right.equalTo(self.oldPhoneTf);
        make.centerY.equalTo(verLabel);
        make.height.equalTo(@35);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView).offset(16);
        make.right.equalTo(infoView);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    //下一步
    UIButton* nextButton = [[UIButton alloc] init];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(infoView.mas_bottom).offset(17);
        make.height.equalTo(@44);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提交新密码
- (void)nextClick
{
    [self.view endEditing:YES];
    if (self.oldPhoneTf.text.length < 1) {
        if (self.pageType == 2) {
            [[DPToast makeText:@"请输入登录密码"] show];
        }
        else {
            [[DPToast makeText:self.pageType ? @"请输入新支付密码" : @"请输入新登录密码"] show];
        }
        return;
    }

    if (![self.oldPhoneTf.text isEqualToString:self.testTf.text]) {
        [[DPToast makeText:@"2次密码不相同"] show];
        return;
    }

    PBMFindToSetPassWordRes* item = [[PBMFindToSetPassWordRes alloc] init];
    item.password = self.oldPhoneTf.text;
    item.token = self.token;
    item.phoneNumber = self.phoneNumber;
    [self showHUD];
    if (self.pageType == 1) {
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ResetPayPassword"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                [[DPToast makeText:@"重置密码成功"] show];
                [self.navigationController popViewControllerAnimated:YES];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    else if (self.pageType == 0) {
        [[AFHTTPSessionManager dp_sharedSSLManager] POST:@"/account/ResetLoginPassword"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                [[DPToast makeText:@"重置密码成功"] show];
                [self.navigationController popViewControllerAnimated:YES];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
    else if (self.pageType == 2) {
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/SetLoginPassword"
            parameters:item
            success:^(NSURLSessionDataTask* task, id responseObject) {
                [self dismissHUD];
                [[DPToast makeText:@"设置密码成功"] show];
                [self.navigationController popViewControllerAnimated:YES];

            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
    }
}
- (void)pvt_onBack
{
    [self.view endEditing:YES];
    [[DPToast sharedToast] dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter, setter

//密码
- (UITextField*)oldPhoneTf
{
    if (_oldPhoneTf == nil) {
        _oldPhoneTf = [[UITextField alloc] init];
        _oldPhoneTf.backgroundColor = [UIColor clearColor];
        _oldPhoneTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _oldPhoneTf.textColor = UIColorFromRGB(0x676767);
        _oldPhoneTf.textAlignment = NSTextAlignmentLeft;
        _oldPhoneTf.secureTextEntry = YES;
        _oldPhoneTf.font = [UIFont dp_systemFontOfSize:17];
        _oldPhoneTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (self.pageType==1) {
            _oldPhoneTf.placeholder = @"请输入新支付密码";
        }else{
        _oldPhoneTf.placeholder = @"请输入新登录密码";
        }
    }
    return _oldPhoneTf;
}
//确认密码
- (UITextField*)testTf
{
    if (_testTf == nil) {
        _testTf = [[UITextField alloc] init];
        _testTf.backgroundColor = [UIColor clearColor];
        _testTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _testTf.textColor = UIColorFromRGB(0x676767);
        _testTf.textAlignment = NSTextAlignmentLeft;
        _testTf.secureTextEntry = YES;
        _testTf.font = [UIFont dp_systemFontOfSize:17];
        _testTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _testTf.placeholder = @"请输入确认密码";
    }
    return _testTf;
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
