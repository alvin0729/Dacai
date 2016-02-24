//
//  DPRechangeViewController.m
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  //  本页注释由sxf提供，如有更改，请标明

#import "DPRechangeViewController.h"
#import "DPUASuccessController.h"
//vie
#import "DPReChangeHeaderView.h"
#import "DPUABaseCell.h"
//other
#import "DPAnalyticsKit.h"
#import "DPAnalyticsKit.h"
#import "DPUARequestData.h"
@interface DPRechangeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) DPReChangeHeaderView *headerView;//充值头部
@property (nonatomic, strong) UITableView *payStyleTable;//第三方充值列表
@property (nonatomic, strong) UIButton *reChangeBtn;//确认支付
@property (nonatomic, strong) UIView *tableHeaderView;//头部视图
@property (nonatomic, assign) NSInteger selectedIndex;//选择充值方式
@end

@implementation DPRechangeViewController
- (void)dealloc{
    self.reChangeBtn = nil;
    self.payStyleTable = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initilizerUI];
    //注册支付宝充值消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayFinish:) name:dp_AlipayResultNotify object:nil];

}

- (void)initilizerUI{
    self.title = @"充值";
    
    [self.view addSubview:self.reChangeBtn];
    [self.reChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.payStyleTable];
    [self.payStyleTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.reChangeBtn.mas_top);
    }];
}

#pragma mark---------payStyleTable
//第三方充值列表
- (UITableView *)payStyleTable{
    if (!_payStyleTable) {
        _payStyleTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payStyleTable.dataSource = self;
        _payStyleTable.delegate = self;
        _payStyleTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _payStyleTable.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        _payStyleTable.tableHeaderView = self.tableHeaderView;
        _payStyleTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _payStyleTable.tableFooterView = [[UIView alloc]init];
         UITapGestureRecognizer *closeKeyBoardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardGestureTapped)];
        [_payStyleTable addGestureRecognizer:closeKeyBoardGesture];
    }
    return _payStyleTable;
}
//table's datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"defaltCell" ;
   
    DPUABaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[DPUABaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        [cell.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setImage:dp_AccountImage(@"UARechangeStyleUnselected.png") forState:UIControlStateNormal];
        [selectBtn setImage:dp_AccountImage(@"UARechangeStyleSelected.png") forState:UIControlStateSelected];
        selectBtn.tag = 110+indexPath.row;
        selectBtn.userInteractionEnabled = NO;
        [cell.contentView addSubview:selectBtn];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        if (indexPath.row == 0) {
            selectBtn.selected = YES;
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeRechargeZfb)] props:nil];
            UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            upLineView.backgroundColor = UIColorFromRGB(0xb4b4b2);
            [cell.contentView addSubview:upLineView];
        }
    }
    NSArray *titles = @[@"支付宝钱包",@"银行卡快捷支付",@"银联快捷支付"];
    NSArray *subTitles = @[@"支持支付宝余额和银行卡充值",@"支持银行卡快捷支付",@"无需开通网银"];
    NSArray *imageNames = @[@"UARechangeAlipay.png",@"UABankCard.png",@"UAYinlian.png"];
    cell.imageView.image = dp_AccountImage(imageNames[indexPath.row]);
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.text = subTitles[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x676767);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<3; i++) {
        if (indexPath.row == i) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:110+i];
            if (btn.selected == NO) {
                 btn.selected = !btn.selected;
                self.selectedIndex = i;
                 [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeRechargeZfb+i)] props:nil];
            }
        }else{
            UIButton *btn = (UIButton *)[self.view viewWithTag:110+i];
            btn.selected = NO;
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark---------tableHeaderView
//充值头部信息
- (UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 182)];
        _tableHeaderView.backgroundColor = [UIColor dp_flatBackgroundColor];

        DPReChangeHeaderView *headerView = [[DPReChangeHeaderView alloc]initWithFrame:CGRectZero];
        headerView.layer.borderColor = UIColorFromRGB(0xb6b5b3).CGColor;
        headerView.layer.borderWidth = 0.5;
        headerView.reChangeText.delegate = self;
        headerView.reChangeText.keyboardType = UIKeyboardTypeDecimalPad;
        [_tableHeaderView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-1);
            make.left.mas_equalTo(-1);
            make.width.mas_equalTo(kScreenWidth+2);
            make.height.mas_equalTo(131.5);
        }];
         [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeRecharge100)] props:nil];
        headerView.buttonClick = ^(NSInteger index){
             [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(index)] props:nil];
        } ;
        
        self.headerView = headerView;
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"选择充值方式";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromRGB(0x666666);
        [_tableHeaderView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-14);
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(14);
        }];
        UITapGestureRecognizer *closeKeyBoardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardGestureTapped)];
        [_tableHeaderView addGestureRecognizer:closeKeyBoardGesture];
        
    }
    return _tableHeaderView;
}
//关闭输入框
- (void)closeKeyBoardGestureTapped{
    [self.view endEditing:YES];
}
//输入框协议方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[self.headerView viewWithTag:100+i];
        btn.selected = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[self.headerView viewWithTag:100+i];
        btn.selected = NO;
    }
    NSString *textStr = [textField.text stringByAppendingString:string];
    return [NSString checkMoneyRoleText:textStr];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeRechargeCount)] props:nil];
    return  YES ;
}
#pragma mark---------function
//确认支付
- (UIButton *)reChangeBtn{
    if (!_reChangeBtn) {
        _reChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reChangeBtn.backgroundColor = UIColorFromRGB(0xdd524f);
        _reChangeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_reChangeBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [_reChangeBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_reChangeBtn addTarget:self action:@selector(reChangeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reChangeBtn;
}
//点击支付
- (void)reChangeBtnTapped{
    PBMPayParams *params = [[PBMPayParams alloc]init];
    params.sourceId = 0;
    params.amt= self.headerView.reChangeText.text;
 
     switch (self.selectedIndex) {
        case 0://支付宝充值
        {
            @weakify(self);
            [DPUARequestData reChangeByAlipayWithParam:params Success:^(PBMRechangeAlipay *alipay) {
                @strongify(self);
//                [[AlipaySDK defaultService] payOrder:alipay.orderString fromScheme:@"2014032100004368" callback:^(NSDictionary *resultDic) {
//                }];
                [self.navigationController pushViewController:[[DPUASuccessController alloc]init] animated:YES];
                
            
//                [self.navigationController popViewControllerAnimated:YES];
                
            } andFail:^(NSString *failMessage) {
                [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
            }];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
//            [DPUARequestData reChangeByYinLianWithParam:@{} Success:^(PBMRechangeYinlian *yinlian) {
//                [LTInterface getHomeViewControllerWithType:1 strOrder:yinlian.tn andDelegate:self];
//            } andFail:^(NSString *failMessage) {
//                [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
//            }];
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 支付宝客户端
- (void)alipayFinish:(NSNotification *)notify
{
    NSDictionary *resultDic = notify.userInfo;
    NSInteger resultStatus=[[resultDic objectForKey:@"resultStatus"] integerValue];
    if (resultStatus==9000) {
        
    [self.navigationController pushViewController:[[DPUASuccessController alloc]init] animated:YES];
    }
    if (resultStatus!=6001){
        [[DPToast makeText:[resultDic objectForKey:@"memo"]]show];
    }
}
#pragma make - 连连支付


#pragma make - 银联支付
- (void)returnWithResult:(NSString *)strResult {
    
}
@end
