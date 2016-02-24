//
//  DPDevConfigViewController.m
//  DacaiProject
//
//  Created by WUFAN on 15/2/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDevConfigViewController.h"
#import "DPAppConfigurator.h"
#import "DPAnalyticsKit.h"
#import "DPMemberManager+Private.h"

@interface DPDevSettingViewController : UIViewController
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UIButton *confirmButton;
@property (nonatomic, assign) BOOL ssl;

- (instancetype)initWithSSL:(BOOL)ssl;
@end

@interface DPDevConfigViewController ()

@property (nonatomic, strong) UILabel *appVerLabel;             // app版本信息
@property (nonatomic, strong) UILabel *userLabel;               // 用户token
@property (nonatomic, strong) UILabel *reqURLLabel;             // 请求地址
@property (nonatomic, strong) UILabel *reqSSLLabel;             // SSL 地址
@property (nonatomic, strong) UILabel *deviceLabel;             // 设备token
@property (nonatomic, strong) UILabel *pushLabel;               // 推送token
@property (nonatomic, strong) UILabel *buildLabel;              // app编译日期
@property (nonatomic, strong) UILabel *channelLabel;            // 渠道信息
@property (nonatomic, strong) UILabel *analysisLabel;           // 统计key hash

@property (nonatomic, strong) UILabel *appVerInfoLabel;
@property (nonatomic, strong) UILabel *userInfoLabel;
@property (nonatomic, strong) UILabel *reqURLInfoLabel;
@property (nonatomic, strong) UILabel *reqSSLInfoLabel;
@property (nonatomic, strong) UILabel *deviceInfoLabel;
@property (nonatomic, strong) UILabel *pushInfoLabel;
@property (nonatomic, strong) UILabel *buildInfoLabel;
@property (nonatomic, strong) UILabel *channelInfoLabel;
@property (nonatomic, strong) UILabel *analysisInfoLabel;

@end

@implementation DPDevConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setupDataSource];
    [self buildLayout];
}

- (void)setupView {
    self.buildLabel = [self generateLabel:NO];
    self.appVerLabel = [self generateLabel:NO];
    self.channelLabel = [self generateLabel:NO];
    self.userLabel = [self generateLabel:NO];
    self.deviceLabel = [self generateLabel:NO];
    self.pushLabel = [self generateLabel:NO];
    self.reqURLLabel = [self generateLabel:NO];
    self.reqSSLLabel = [self generateLabel:NO];
    self.analysisLabel = [self generateLabel:NO];
    self.buildInfoLabel = [self generateLabel:NO];
    self.appVerInfoLabel = [self generateLabel:NO];
    self.channelInfoLabel = [self generateLabel:NO];
    self.userInfoLabel = [self generateLabel:YES];
    self.deviceInfoLabel = [self generateLabel:YES];
    self.pushInfoLabel = [self generateLabel:YES];
    self.reqURLInfoLabel = [self generateLabel:NO];
    self.reqSSLInfoLabel = [self generateLabel:NO];
    self.analysisInfoLabel = [self generateLabel:NO];
}

- (void)setupDataSource {
    self.buildLabel.text = @"编译日期:";
    self.buildInfoLabel.text = [DPAppConfigurator buildDate];
    self.appVerLabel.text = @"版本信息:";
    self.appVerInfoLabel.text = [NSString stringWithFormat:@"v%@   build %@", [KTMUtilities applicationVersion], [KTMUtilities buildNumber]];
    self.channelLabel.text = @"渠道信息:";
    self.channelInfoLabel.text = [NSString stringWithFormat:@"%@（%@）", [DPAppConfigurator channelId], [DPAppConfigurator environment]];
    self.userLabel.text = @"用户token:";
    self.userInfoLabel.text = [DPMemberManager sharedInstance].sessionToken;
    self.deviceLabel.text = @"设备token:";
    self.deviceInfoLabel.text = [KTMUtilities deviceUUID];
    self.pushLabel.text = @"推送token:";
    self.pushInfoLabel.text = [KTMUtilities pushDeviceToken];
    self.reqURLLabel.text = @"请求地址:";
    self.reqURLInfoLabel.text = [DPAppConfigurator baseURL];
    self.reqSSLLabel.text = @"SSL 地址:";
    self.reqSSLInfoLabel.text = [DPAppConfigurator SSLURL];
    self.analysisLabel.text = @"统计key:";
    self.analysisInfoLabel.text = [DPAnalyticsKit appKeyDigest];
    
    self.buildLabel.textAlignment = NSTextAlignmentRight;
    self.appVerLabel.textAlignment = NSTextAlignmentRight;
    self.channelLabel.textAlignment = NSTextAlignmentRight;
    self.userLabel.textAlignment = NSTextAlignmentRight;
    self.deviceLabel.textAlignment = NSTextAlignmentRight;
    self.pushLabel.textAlignment = NSTextAlignmentRight;
    self.reqURLLabel.textAlignment = NSTextAlignmentRight;
    self.reqSSLLabel.textAlignment = NSTextAlignmentRight;
    self.analysisLabel.textAlignment = NSTextAlignmentRight;
}

- (void)buildLayout {
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self.view addSubview:self.buildLabel];
    [self.view addSubview:self.buildInfoLabel];
    [self.view addSubview:self.appVerLabel];
    [self.view addSubview:self.appVerInfoLabel];
    [self.view addSubview:self.channelLabel];
    [self.view addSubview:self.channelInfoLabel];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.userInfoLabel];
    [self.view addSubview:self.deviceLabel];
    [self.view addSubview:self.deviceInfoLabel];
    [self.view addSubview:self.pushLabel];
    [self.view addSubview:self.pushInfoLabel];
    [self.view addSubview:self.reqURLLabel];
    [self.view addSubview:self.reqURLInfoLabel];
    [self.view addSubview:self.reqSSLLabel];
    [self.view addSubview:self.reqSSLInfoLabel];
    [self.view addSubview:self.analysisLabel];
    [self.view addSubview:self.analysisInfoLabel];
    
    NSArray *titles = @[self.buildLabel, self.appVerLabel, self.channelLabel, self.userLabel, self.deviceLabel, self.pushLabel, self.reqURLLabel, self.reqSSLLabel, self.analysisLabel];
    NSArray *contents = @[self.buildInfoLabel, self.appVerInfoLabel, self.channelInfoLabel, self.userInfoLabel, self.deviceInfoLabel, self.pushInfoLabel, self.reqURLInfoLabel, self.reqSSLInfoLabel, self.analysisInfoLabel];
    [[titles firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view);
        make.width.equalTo(@65);
        make.height.equalTo(@25);
    }];
    [titles dp_enumeratePairsUsingBlock:^(UILabel *obj1, NSUInteger idx1, UILabel *obj2, NSUInteger idx2, BOOL *stop) {
        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj1.mas_bottom);
            make.left.equalTo(obj1);
            make.width.equalTo(obj1);
            make.height.equalTo(obj1);
        }];
    }];
    for (int i = 0; i < contents.count; i++) {
        UILabel *titleLabel = titles[i];
        UILabel *contentLabel = contents[i];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.right.equalTo(self.view);
            make.top.with.bottom.equalTo(titleLabel);
        }];
    }
    
#ifdef CONFIGURABLE
    [self.reqURLInfoLabel setUserInteractionEnabled:YES];
    [self.reqURLInfoLabel addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapURL:)];
        tapRecognizer.numberOfTapsRequired = 2;
        tapRecognizer;
    })];
    [self.reqSSLInfoLabel setUserInteractionEnabled:YES];
    [self.reqSSLInfoLabel addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSSL:)];
        tapRecognizer.numberOfTapsRequired = 2;
        tapRecognizer;
    })];
#endif
}

- (void)onTapURL:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换网络请求地址" message:nil delegate:nil cancelButtonTitle:nil
                                              otherButtonTitles:@"http://api.dacai.com/v3",
                                                                @"http://api.dacai.com/v5",
                                                                @"http://10.12.2.37:99",
                                                                @"http://10.12.7.249:99",
                                                                @"自定义", nil];
    [alertView show];
    
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (buttonIndex.integerValue == alertView.cancelButtonIndex) {
            return;
        }
        
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex.integerValue];
        if ([title isEqualToString:@"自定义"]) {
            [self.navigationController pushViewController:[[DPDevSettingViewController alloc] initWithSSL:NO] animated:YES];
        } else {
            [DPAppConfigurator switchToAddr:title];
            [[DPToast makeText:@"配置将在重启应用后生效"] show];
        }
    }];
}

- (void)onTapSSL:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换网络请求地址" message:nil delegate:nil cancelButtonTitle:nil
                                              otherButtonTitles:@"https://api.dacai.com/v3",
                                                                @"https://api.dacai.com/v5",
                                                                @"https://10.12.2.37:444",
                                                                @"https://10.12.7.249:444",
                                                                @"自定义", nil];
    [alertView show];
    
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (buttonIndex.integerValue == alertView.cancelButtonIndex) {
            return;
        }
        
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex.integerValue];
        if ([title isEqualToString:@"自定义"]) {
            [self.navigationController pushViewController:[[DPDevSettingViewController alloc] initWithSSL:YES] animated:YES];
        } else {
            [DPAppConfigurator switchToSSLAddr:title];
            [[DPToast makeText:@"配置将在重启应用后生效"] show];
        }
    }];
}

- (UILabel *)generateLabel:(BOOL)canCopy {
    UILabel *label = canCopy ? [[KTMCopyableLabel alloc] init] : [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor dp_flatBlackColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

@end

@implementation DPDevSettingViewController
@synthesize textField = _textField;
@synthesize confirmButton = _confirmButton;

- (instancetype)initWithSSL:(BOOL)ssl {
    if (self = [super init]) {
        _ssl = ssl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.title = @"自定义";
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"服务器地址:";
    label.font = [UIFont dp_systemFontOfSize:14];
    label.textColor = [UIColor dp_flatBlackColor];
    
    [self.view addSubview:label];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.confirmButton];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(15);
    }];
    [self.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.height.equalTo(@35);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(15);
        make.height.equalTo(@35);
    }];
    [self.textField becomeFirstResponder];
}

- (void)onConfirm {
    NSString *text = self.textField.text;
    if (![text hasPrefix:@"http://"] && ![text hasPrefix:@"https://"]) {
        if (self.ssl) {
            text = [@"https://" stringByAppendingString:text];
        } else {
            text = [@"http://" stringByAppendingString:text];
        }
    }
    if ([KTMValidator isURL:text]) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.ssl) {
            [DPAppConfigurator switchToSSLAddr:text];
        } else {
            [DPAppConfigurator switchToAddr:text];
        }
        [[DPToast makeText:@"配置将在重启应用后生效"] show];
    } else {
        [[DPToast makeText:@"输入的地址不合法"] show];
    }
}

- (void)textChanged:(UITextField *)textField {
    self.confirmButton.enabled = textField.text.length > 0;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"格式: 192.168.1.101:8080/v3";
        _textField.font = [UIFont dp_systemFontOfSize:14];
        _textField.layer.cornerRadius = 3;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
    }
    return _textField;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatRedColor]] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:15]];
        [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setEnabled:NO];
    }
    return _confirmButton;
}

@end
