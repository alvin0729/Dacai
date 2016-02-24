//
//  DPSecurityCenterViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/19.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLogoutAccountViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPSecurityCenterCell.h"
#import "DPSecurityCenterInfoViewController.h"
#import "DPSecurityCenterViewController.h"
#import "DPUARequestData.h"
#import "Security.pbobjc.h"
@interface DPSecurityCenterViewController () <UITableViewDelegate, UITableViewDataSource, DPSecurityCenterCellDelegate> {
@private
    int _renzheng[4]; //0:开通账户  1:手机号   2:登录密码  3:支付密码
    UITableView *_tableView;
    UIButton *_sureButton;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIButton *sureButton;
@property (nonatomic, strong) PBMSecurityHome *dataBase;
@end

@implementation DPSecurityCenterViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < 4; i++) {
        _renzheng[i] = 0;
    }
    self.view.backgroundColor = UIColorFromRGB(0xfaf9f4);
    self.title = @"安全中心";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 75, 0));
    }];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.height.equalTo(@44);
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAllData];
}
//请求安全中心数据
- (void)requestAllData
{
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/SecurityCenter"
        parameters:nil
        success:^(NSURLSessionDataTask* task, id responseObject) {

            [self dismissHUD];
            self.dataBase = [PBMSecurityHome parseFromData:responseObject error:nil];
            //是否开通账户
            _renzheng[0] = self.dataBase.showAccount;
            //是否手机认证
            _renzheng[1] = self.dataBase.showPhone;
            //是否设置登录密码
            _renzheng[2] = self.dataBase.showLoginPassword;
           //是否设置支付密码
            _renzheng[3] = self.dataBase.showPayPassword;
            [self.sureButton setTitle:_renzheng[0] ? @"注销账户" : @"开通投注账户" forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _renzheng[0] > 0 ? 4 : 2;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        NSString* CellIdentifier = [NSString stringWithFormat:@"cell%d", _renzheng[0]];

        if (_renzheng[0])//开通账户
        {
            DPAcountInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPAcountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            PBMSecurityHome_RealNameItem* item = self.dataBase.nameItem;
            PBMSecurityHome_BankInfoItem* bankItem = self.dataBase.bankItem;
            //用户姓名
            [cell setUsernameText:[NSString stringWithFormat:@"%@", item.realName]];
            //身份证信息
            [cell setCardIdText:[NSString stringWithFormat:@"%@", item.cardId]];
            //银行卡信息
            [cell setBankInfoText:[NSString stringWithFormat:@"%@（尾号%@）", bankItem.bankName, bankItem.bankNumber]];
            //归属地信息
            [cell setAddressText:[NSString stringWithFormat:@"归属地：%@", bankItem.bankAddress]];
            return cell;
        }

        DPSecurityCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSecurityCenterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if (_renzheng[1])//手机已认证
        {
            [cell setTitleLabelText:[NSString stringWithFormat:@"手机: %@", self.dataBase.phoneNumber]];
            [cell setInfoLabelText:@"手机可享受登录、找回密码、大奖通知等服务"];
            [cell setChangeLabelShow:YES];
        }
        else {
            [cell setTitleLabelText:@"绑定手机"];
            [cell setInfoLabelText:@"可享受手机号码登录、找回密码、大奖通知等服务"];
            [cell setChangeLabelShow:NO];
        }

        return cell;
    }
    if ((indexPath.row == 1) && _renzheng[0]) {
        NSString* CellIdentifier = [NSString stringWithFormat:@"cell%d", _renzheng[1]];
        DPSecurityCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSecurityCenterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if (_renzheng[1])//手机已认证
        {
            [cell setTitleLabelText:[NSString stringWithFormat:@"手机: %@", self.dataBase.phoneNumber]];
            [cell setInfoLabelText:@"手机可享受登录、找回密码、大奖通知等服务"];
            [cell setChangeLabelShow:YES];
        }
        else {
            [cell setTitleLabelText:@"绑定手机"];
            [cell setInfoLabelText:@"可享受手机号码登录、找回密码、大奖通知等服务"];
            [cell setChangeLabelShow:NO];
        }

        return cell;
    }
    static NSString* CellIdentifier = @"securityCenter";
    DPAredgeAccountCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[DPAredgeAccountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = _renzheng[2] > 0 ? @"修改登录密码" : @"设置登录密码";
    }
    if (indexPath.row == 2) {
        if (_renzheng[0]) {
            cell.titleLabel.text = _renzheng[2] > 0 ? @"修改登录密码" : @"设置登录密码";
            return cell;
        }
        cell.titleLabel.text = _renzheng[3] > 0 ? @"修改支付密码" : @"设置支付密码";
    }
    if (indexPath.row == 3) {
        cell.titleLabel.text = _renzheng[3] > 0 ? @"修改支付密码" : @"设置支付密码";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        return _renzheng[0] > 0 ? 260 : 60;
    }
    if (indexPath.row == 1) {
        return _renzheng[0] > 0 ? 60 : 48;
    }
    return 48;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_renzheng[0]) {
        return 0;
    }
    return 12;
}
- (nullable UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    if (_renzheng[0]) {
        return nil;
    }
    UIView* view = [UIView dp_viewWithColor:[UIColor clearColor]];
    return view;
}
//设置/修改手机认证
- (void)changePhoneForCell:(DPSecurityCenterCell*)cell
{
    if (!_renzheng[1]) {
        DPBindingPhoneViewController* vc = [[DPBindingPhoneViewController alloc] init];
        vc.vcType = newPhoneTypeFromVerPhone;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    DPTestOldPhoneViewController* vc = [[DPTestOldPhoneViewController alloc] init];
    vc.vcType = verPhoneTypeVCPhone;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改提款银行卡信息
- (void)changeDrawBankForCell:(DPAcountInfoCell*)cell
{
    DPTestOldPhoneViewController* vc = [[DPTestOldPhoneViewController alloc] init];
    vc.vcType = verPhoneTypeVCForChangeBank;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改/设置登录密码/支付密码
- (void)changePassWordForCell:(DPAredgeAccountCell*)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];

    if ((_renzheng[0] && indexPath.row == 2) || (!_renzheng[0] && indexPath.row == 1)) {
        if (_renzheng[2]) {
            DPChangeLoginPassWordViewController* vc = [[DPChangeLoginPassWordViewController alloc] init];
            vc.pageType = 0;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        DPSetLoginPassWordViewController* vc = [[DPSetLoginPassWordViewController alloc] init];
        vc.pageType = 2;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ((_renzheng[0] && indexPath.row == 3) || (!_renzheng[0] && indexPath.row == 2)) {
        if (_renzheng[3]) {
            DPChangeLoginPassWordViewController* vc = [[DPChangeLoginPassWordViewController alloc] init];
            vc.pageType = 1;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        DPSetLoginPassWordViewController* vc = [[DPSetLoginPassWordViewController alloc] init];
        vc.pageType = 1;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}
//开通投注账户/注销账户
- (void)accoutButtonClick
{
    if (_renzheng[0]) {
        DPLogoutAccountViewController* vc = [[DPLogoutAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    DPOpenBetServiceController* vc = [[DPOpenBetServiceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (UIButton*)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.backgroundColor = UIColorFromRGB(0xdb4e4c);
        [_sureButton setTitle:@"开通投注账户" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _sureButton.layer.cornerRadius = 5;
        [_sureButton addTarget:self action:@selector(accoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
};
- (void)didReceiveMemoryWarning
{
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
