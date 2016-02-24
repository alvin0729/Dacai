//
//  DPOpenBetServiceController.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 本页面有sxf做注释，他人如有更改，请标明

#import "DPOpenBetServiceController.h"
#import "locationPickController.h"
#import "DPAlterViewController.h"
#import "DPAlterViewController.h"
#import "DPSecurityCenterViewController.h"

//view
#import "DPBetServiceCell.h"
//data
#import "DPUARequestData.h"
#import "DPBankListConfigure.h"
//other
#import "DPAnalyticsKit.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
@interface DPOpenBetServiceController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *tableSectionData;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UITextField *nameText;//用户名
@property (nonatomic, strong) UITextField *numText;//身份证号
@property (nonatomic, strong) UITextField *bankCardNumText;//提款卡号
@property (nonatomic, strong) UITextField *bankName;//开户行
@property (nonatomic, strong) DPBetServiceCell *passwordCell;
@property (nonatomic, strong) UITextField *bankLocation;//归属地
//=======================================data
@property (nonatomic, strong) NSMutableArray *bankArray;//银行卡号信息
@property (nonatomic, strong) PBMOpenBetParam *betParam;//开通账户投注服务
@property (nonatomic, assign) CGRect keyBoardFrame;

@end

@implementation DPOpenBetServiceController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DPToast sharedToast] dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通投注服务";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"暂不开通" target:self action:@selector(unOpenBetService)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"帮助" target:self action:@selector(help)];
    [self.view addSubview:self.contentTable];

    self.betParam = [[PBMOpenBetParam alloc] init];

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
 
    @weakify(self);
    //获取开通投注服务中的用户信息
    [DPUARequestData getUserInfoInOpenBetSuccess:^(PBMUserInfo *result) {
        @strongify(self);
        if (result.isLogout) {
            self.nameText.text = result.name;
            self.nameText.enabled = NO;

            self.numText.text = result.idCard;
            self.numText.enabled = NO;
        }
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
//键盘发生改变时的处理
- (void)keyboardChanged:(NSNotification *)notice{
    NSDictionary *info = notice.userInfo;
    NSValue *keyBoardValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardValue CGRectValue];
    self.keyBoardFrame =keyBoardRect;//CGRectMake(0, 0, kScreenWidth, 216);
    if (keyBoardRect.origin.y < kScreenHeight) {
        self.contentTable.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight - keyBoardRect.origin.y, 0);
    }
}
//暂不开通投注服务
- (void)unOpenBetService {
    
    if (self.pathSource == DPPathSourceSignIn || //登录
        self.pathSource == DPPathSourceSignUp || //注册
        self.pathSource == DPPathSourceOAuth)//第三方登录
    {
        
        DPAlterViewController *alterView = [[DPAlterViewController alloc] initWithAlterType:AlterTypeLoginSucce];
        @weakify(self);
        alterView.sevice = ^(UIButton *btn) {
            @strongify(self);
            DPSecurityCenterViewController *controller = [[DPSecurityCenterViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        };
        alterView.fullBtnTapped = ^(UIButton *btn) {
            @strongify(self);
            if (self.navigationController.viewControllers.count>1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        };
        [self dp_showViewController:alterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    }else{
        if (self.navigationController.viewControllers.count>1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
//帮助
- (void)help {
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeServiceHelp)] props:nil];
    DPWebViewController *controller = [[DPWebViewController alloc] init];
    controller.title = @"帮助";
    NSString *url = [NSString stringWithFormat:@"%@%@", kServerBaseURL, @"/web/help/bet"];
    controller.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------contentTable
- (UITableView *)contentTable {
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.tableFooterView = self.footView;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _contentTable;
}

//选择开户行
- (void)choseOpenBank {
    DPAlterViewController *controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypeBankChose];
    @weakify(self);
    controller.bankBlock = ^(DPUAObject *bankItem) {
        @strongify(self);
        self.betParam.bankName = bankItem.title;
        self.betParam.bankId = bankItem.value;
        self.bankName.text = bankItem.title;
    };
    controller.bankArray = self.bankArray;
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
//选择归属点
- (void)choseBelongToCity {
    locationPickController *controller = [[locationPickController alloc] init];
    @weakify(self);
    controller.locationBlock = ^(NSString *str, NSString *code) {
        @strongify(self);
        self.bankLocation.text = str;
        self.betParam.cityName = str;
        self.betParam.cityCode = [code integerValue];
    };
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
//table's delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.tableData.count;
    } else if (section == 1) {
        return self.tableSectionData.count;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPBetServiceCell *cell = [[DPBetServiceCell alloc] initWithTableView:tableView atIndexPath:indexPath];
    cell.textField.font = [UIFont systemFontOfSize:17];
    @weakify(self);
    //点击回调（由于是对整个cell进行点击事件，因此这个按钮和回调完全多余）
    cell.btnBlock = ^(UIButton *btn) {
        @strongify(self);
        if (btn.tag == 2) {
            [self choseBelongToCity];//归属地
        } else if (btn.tag == 1) {
            [self choseOpenBank];//开户地
        }
    };
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.lineToLeft.mas_equalTo(0);
            self.numText = cell.textField;
        } else {
            self.nameText = cell.textField;
        }
        cell.object = self.tableData[indexPath.row];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            cell.lineToLeft.mas_equalTo(0);
            self.bankLocation = cell.textField;
            cell.textField.userInteractionEnabled = NO;
        } else if (indexPath.row == 1) {
            self.bankName = cell.textField;
            cell.textField.userInteractionEnabled = NO;
        } else {
            self.bankCardNumText = cell.textField;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        cell.object = self.tableSectionData[indexPath.row];
    }
    cell.textField.delegate = self;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            //选择归属地
            [self choseBelongToCity];
        } else if (indexPath.row == 1) {
            [self choseOpenBank];
        } else {
        }
    }
}
//textfield's delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldF = [textField convertRect:textField.frame toView:self.view];
    CGFloat upTransform = CGRectGetMaxY(textFieldF) + self.keyBoardFrame.size.height - kScreenHeight;
    [UIView animateWithDuration:0.25
                     animations:^{
                         if (upTransform > 0) {
                             self.view.frame = CGRectMake(0, -upTransform, kScreenWidth, kScreenHeight);
                         }
                     }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
                     }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark---------data
//用户信息
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            switch (i) {
                case 0: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"姓        名:";
                    object.subTitle = @"请输入姓名";
                    [_tableData addObject:object];
                } break;
                case 1: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"身份证号:";
                    object.subTitle = @"请输入身份证号";
                    [_tableData addObject:object];
                } break;

                default:
                    break;
            }
        }
    }
    return _tableData;
}
//提款信息
- (NSMutableArray *)tableSectionData {
    if (!_tableSectionData) {
        _tableSectionData = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            switch (i) {
                case 0: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"提款卡号:";
                    object.subTitle = @"请输入提款卡号";
                    [_tableSectionData addObject:object];
                } break;
                case 1: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"开  户  行:";
                    object.subTitle = @"请选择银行";
                    object.describValue = @"triangle.png";
                    [_tableSectionData addObject:object];
                } break;
                case 2: {
                    DPUAObject *object = [[DPUAObject alloc] init];
                    object.title = @"归  属  地:";
                    object.subTitle = @"请选择归属地";
                    object.describValue = @"triangle.png";
                    [_tableSectionData addObject:object];
                } break;
                default:
                    break;
            }
        }
    }
    return _tableSectionData;
}
//银行卡
- (NSMutableArray *)bankArray {
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
        DPBankListConfigure *bankConfigure = [[DPBankListConfigure alloc] init];
        for (NSInteger i = 0; i < bankConfigure.bankList.count; i++) {
            DPBankInfo *bankInfo = bankConfigure.bankList[i];
            DPUAObject *object = [[DPUAObject alloc] init];
            object.title = bankInfo.name;
            object.value = bankInfo.code;
            [_bankArray addObject:object];
        }
    }
    return _bankArray;
}

#pragma mark---------footView
//支付密码处理
- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        self.passwordCell = [[DPBetServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.passwordCell.textField.secureTextEntry = YES;
        self.passwordCell.textField.font = [UIFont systemFontOfSize:17];
        self.passwordCell.separatorLine.hidden = YES;
        self.passwordCell.textField.delegate = self;
        self.passwordCell.backgroundColor = [UIColor dp_flatWhiteColor];
        self.passwordCell.layer.borderColor = UIColorFromRGB(0xC3C8CC).CGColor;
        self.passwordCell.layer.borderWidth = 0.5;
        @weakify(self);
        self.passwordCell.btnBlock = ^(UIButton *btn) {
            @strongify(self);
            btn.selected = !btn.selected;
        };
        DPUAObject *object = [[DPUAObject alloc] init];
        object.title = @"支付密码:";
        object.subTitle = @"请输入支付密码";
        object.subValue = @"passopen";
        object.describValue = @"passclose";
        self.passwordCell.object = object;
        [_footView addSubview:self.passwordCell];
        [self.passwordCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(57);
        }];

        UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        openBtn.layer.cornerRadius = 5;
        openBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [openBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [openBtn addTarget:self action:@selector(openBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        openBtn.dp_eventId = DPAnalyticsTypeServiceYes;
        [_footView addSubview:openBtn];
        [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordCell.mas_bottom).offset(18);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];

        UITapGestureRecognizer *footerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerTapped:)];
        [_footView addGestureRecognizer:footerTapGesture];
    }
    return _footView;
}
//点击表脚-->关闭键盘
- (void)footerTapped:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}
//开通投注服务点击
- (void)openBtnTapped {
    if (self.nameText.text.length == 0) {
        [[DPToast makeText:@"请输入姓名" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.numText.text.length == 0) {
        [[DPToast makeText:@"请输入身份证号" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.bankCardNumText.text.length == 0) {
        [[DPToast makeText:@"请输入提款卡号" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.bankName.text.length == 0) {
        [[DPToast makeText:@"请选择开户行" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.bankLocation.text.length == 0) {
        [[DPToast makeText:@"请选择归属地" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    if (self.passwordCell.textField.text.length == 0) {
        [[DPToast makeText:@"请输入支付密码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }

    self.betParam.userId = @"";
    self.betParam.userName = self.nameText.text;
    self.betParam.userNo = self.numText.text;
    self.betParam.bankNo = self.bankCardNumText.text;
    self.betParam.password = self.passwordCell.textField.text;
    [self showHUD];
    @weakify(self);
    [DPUARequestData openBetWithParam:self.betParam Success:^(PBMOpenBetItem *openBetItem) {
        @strongify(self);
        [self dismissHUD];
        [DPMemberManager sharedInstance].betOpen = YES;
        DPAlterViewController *alterView = [[DPAlterViewController alloc] initWithAlterType:AlterTypeOpenBetSuccess];
        alterView.sevice = ^{
            @strongify(self);
            //回调
            if (self.openBetBlock) {
                self.openBetBlock();
            }
            //回弹
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self dp_showViewController:alterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    }andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
    
}

#pragma mark---------function

@end
