//
//  DPThirdLoginVerifyController.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 本页面注释由sxf提供,如有更改，请标示

#import "DPThirdLoginVerifyController.h"
#import "DPOpenBetServiceController.h"
#import "UIViewController+DPUALoginToOpenBet.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DPUAObject.h"
#import "DPUALoginCell.h"
@interface DPThirdLoginVerifyController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/**
 *  headerView
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  myTable
 */
@property (nonatomic, strong) UITableView *myTable;
/**
 *  headerView
 */
@property (nonatomic, strong) UIView *footView;
/**
 *  表数据
 */
@property (nonatomic, strong) NSMutableArray *myData;
/**
 *  loginBtn
 */
@property (nonatomic, strong) UIButton *loginBtn;
/**
 *  phoneNumTF
 */
@property (nonatomic, strong) UITextField *phoneNumTF;
/**
 *  veritifyTF
 */
@property (nonatomic, strong) UITextField *veritifyTF;
/**
 *  verifyBtn
 */
@property (nonatomic, strong) UIButton *verifyBtn;
/**
 *  验证码倒计时
 */
@property (nonatomic, assign) NSInteger waitTime;
/**
 *  勾选合同按钮
 */
@property (nonatomic, strong) UIButton *contractBtn;
@end

@implementation DPThirdLoginVerifyController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"手机绑定";
    [self.view addSubview:self.myTable];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
}
- (void)didBackTapped{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [[DPMemberManager sharedInstance] logout];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark---------headerView

//头部介绍
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.5)];
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xb9b2a5);
        label.numberOfLines = 0;
        label.text = @"绑定手机号可享受手机登录，密码找回，大奖短信提醒等服务";
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _headerView;
}

#pragma mark---------myTable
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTable.dataSource = self;
        _myTable.delegate = self;
        _myTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _myTable.tableHeaderView = self.headerView;
        _myTable.tableFooterView = self.footView;
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *closeKeyboardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoard:)];
        [_myTable addGestureRecognizer:closeKeyboardGesture];
    }
    return _myTable;
}
//关闭键盘
- (void)closeKeyBoard:(UITapGestureRecognizer *)gesture{
     [self.view endEditing:YES];
}
//table's delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUALoginCell *cell = [[DPUALoginCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.myData[indexPath.row];
    cell.textField.delegate = self;
    @weakify(self);
    cell.btnBlock = ^(UIButton *btn){
        @strongify(self);
        if (self.phoneNumTF.text.length>0) {
            if ([self.phoneNumTF.text checkPhoneNumInput]) {
                [self virityPhoneNum];
            }else{
                [[DPToast makeText:@"手机号码格式错误" color:[UIColor dp_flatBlackColor]] show];
            }
        }else{
            [[DPToast makeText:@"请输入手机号码" color:[UIColor dp_flatBlackColor]] show];
        }
    };
    if (indexPath.row == 0) {
        self.phoneNumTF = cell.textField ;
    }else{
        self.veritifyTF = cell.textField;
        self.verifyBtn = cell.cellBtn;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//textfield's delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark---------footerView
//底部信息
- (UIView *)footView{
    if (!_footView) {
        _footView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 365)];
        UILabel *contractLabel = [[UILabel alloc]init];
        contractLabel.textColor = colorWithRGB(185, 181, 168);
        NSMutableAttributedString *contractText = [[NSMutableAttributedString alloc]initWithString:@"阅读并同意《大彩网购彩票服务协议》"];
        [contractText addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatBlueColor] range:NSMakeRange(5, contractText.length-5)];
        contractLabel.attributedText = contractText;
        contractLabel.userInteractionEnabled = YES;
        contractLabel.font = [UIFont systemFontOfSize:12];
        contractLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *contractTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contractLabelTapped)];
        [contractLabel addGestureRecognizer:contractTapped];
        [_footView addSubview:contractLabel];
        [contractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
        
        //选择框
        UIButton *contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contractBtn.layer.cornerRadius =3;
        [contractBtn setImage:dp_AccountImage(@"unRememberPassword.png") forState:UIControlStateNormal];
        [contractBtn setImage:dp_AccountImage(@"rememberPassword.png") forState:UIControlStateSelected];
        [contractBtn addTarget:self action:@selector(contractBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:contractBtn];
        contractBtn.selected = YES;
        self.contractBtn = contractBtn;
        
        CGSize contractLabelSize = [NSString dpsizeWithSting:contractLabel.text andFont:[UIFont systemFontOfSize:12] andMaxWidth:MAXFLOAT];
        [contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contractLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.right.mas_equalTo(contractLabel.mas_centerX).offset(-contractLabelSize.width*0.5-5);
        }];
        
        //下一步
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        loginBtn.layer.cornerRadius = 5;
        [loginBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contractLabel.mas_bottom).offset(18);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        self.loginBtn = loginBtn;
        
    }
    return _footView;
}


- (void)contractBtnTapped:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.loginBtn.enabled = btn.selected;
}
//跳转到大彩网购物服务协议
- (void)contractLabelTapped{
    DPWebViewController *controller = [[DPWebViewController alloc]init];
    controller.title = @"购彩协议";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/BuyProtocol"];
    controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}
//下一步，提交手机绑定
- (void)loginBtnTapped {
    if (self.phoneNumTF.text.length <= 0) {
        [[DPToast makeText:@"请输入手机号码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.veritifyTF.text.length <= 0) {
        [[DPToast makeText:@"请输入验证码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (!self.contractBtn.selected) {
        [[DPToast makeText:@"请勾选大彩网购彩服务协议" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (![self.phoneNumTF.text checkPhoneNumInput]) {
        [[DPToast makeText:@"手机号码格式错误" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.thirdLogonItem) {
        PBMThirdBangdingPhoneParam *param = [[PBMThirdBangdingPhoneParam alloc] init];
        param.phoneNum = self.phoneNumTF.text;
        param.verityNum = self.veritifyTF.text;
        param.openid = self.thirdLogonItem.openid;
        param.unionid = self.thirdLogonItem.unionid;
        param.nickName = self.thirdLogonItem.loginItem.userNickName;
        param.type = self.thirdLogonItem.type;
        param.iconURL = self.thirdLogonItem.iconURL;
        param.pushToken = [KTMUtilities pushDeviceToken];
        @weakify(self);
        [DPUARequestData thirdBangdingVerityWithParam:param Success:^(PBMLoginItem *verityItem) {
            @strongify(self);
            [self bangdingSuccessWithLoginItem:verityItem];
        }andFail:^(NSString *failMessage) {
            [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
        }];
    } else {
        PBMPhoneBindingRes *param = [[PBMPhoneBindingRes alloc] init];
        param.phoneNumber = self.phoneNumTF.text;
        param.verCode = self.veritifyTF.text;
        @weakify(self);
        [DPUARequestData bangdingVerityWithParam:param Success:^(PBMLoginItem *verityItem) {
            @strongify(self);
            [[DPMemberManager sharedInstance]loginWithName:verityItem.userNickName nickName:verityItem.userNickName userId:[NSString stringWithFormat:@"%zd",verityItem.userId] sessionToken:verityItem.sessionContent secureKey:verityItem.secureKey bangdingPhoneNum:verityItem.bangdingPhoneNum betOpen:verityItem.betOpen];
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
            controller.pathSource = DPPathSourceOAuth;
            [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
        }andFail:^(NSString *failMessage) {
            [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
        }];
    }
}
//绑定成功后返回
- (void)bangdingSuccessWithLoginItem:(PBMLoginItem *)loginItem{
    [[DPMemberManager sharedInstance]loginWithName:loginItem.userNickName nickName:loginItem.userNickName userId:[NSString stringWithFormat:@"%zd",loginItem.userId] sessionToken:loginItem.sessionContent secureKey:loginItem.secureKey bangdingPhoneNum:loginItem.bangdingPhoneNum betOpen:loginItem.betOpen];
    DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
    controller.pathSource = DPPathSourceOAuth;
    [self dpViewController:controller removerControllerFromLogOnToOpenBetWithAnimated:YES];
}
//验证手机号
- (void)virityPhoneNum{
    [self showHUD];
    PBMPhoneVerCodeRes *param = [[PBMPhoneVerCodeRes alloc]init];
    param.phoneNumber = self.phoneNumTF.text;
    @weakify(self);
    [DPUARequestData bangdingSendVerityWithParam:param Success:^(PBMVerityItem *verityItem) {
        @strongify(self);
        [self dismissHUD];
        self.waitTime = verityItem.endTime;
        [self lunXun];
    } andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];

    }];
}
//倒计时
- (void)lunXun{
    self.waitTime --;
    if (self.waitTime>0) {
        self.verifyBtn.enabled = NO;
        [self performSelector:@selector(lunXun) withObject:nil afterDelay:1.0];
        self.verifyBtn.backgroundColor = [UIColor grayColor];
        
        [self.verifyBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)self.waitTime] forState:UIControlStateNormal];
        DPUAObject *cellObject = self.myData[1];
        cellObject.describTitle = [NSString stringWithFormat:@"%ld秒后重发",(long)self.waitTime];
        
    }else{
        self.verifyBtn.enabled = YES;
        DPUAObject *cellObject = self.myData[1];
        self.verifyBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        cellObject.describTitle = @"重发验证码";
        [self.myTable reloadData];
    }
    
}
#pragma mark---------data
- (NSMutableArray *)myData{
    if (!_myData) {
        _myData = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            switch (i) {
                case 0:
                {
                    DPUAObject *object = [[DPUAObject  alloc]init];
                    object.title =@"手机号码:";
                    object.subTitle = @"请输入手机号（可用于登录）";
                    object.describTitle = @"";
                    object.describValue = @"";
                    [_myData addObject:object];
                }
                    break;
                case 1:
                {
                    DPUAObject *object = [[DPUAObject  alloc]init];
                    object.title =@"验  证  码:";
                    object.subTitle = @"请输入验证码";
                    object.describTitle = @"获取验证码";
                    object.describValue = @"";
                    [_myData addObject:object];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    return _myData;
}
@end
