//
//  DPDrawMoneyViewController.m
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPDrawMoneyViewController.h"
#import "DPUADWSuccessController.h"
#import "DPAlterViewController.h"
#import "DPPayPasswordView.h"
#import "DPUABaseCell.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "MTStringAttributes.h"
@interface DPDrawMoneyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
@property (nonatomic, strong)UIView *headerView;//头部视图
@property (nonatomic, copy)NSAttributedString *bankLabelStr;//银行卡号
@property (nonatomic, copy)NSAttributedString *canDrawCountLabelStr;//可提款金额
@property (nonatomic, strong)UILabel *realGetMoneyLabel;//实际到账金额
@property (nonatomic, strong)UILabel *feeLabel;//手续费
@property (nonatomic, strong)UITableView *drawMoneyTable;//提款银行卡列表
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, strong)UITextField *drawMoneyText;//提款金额输入框
@property (nonatomic, strong)UITextField *passwordText;//支付密码输入框
@property (nonatomic, strong)NSMutableDictionary *param;
@property (nonatomic, strong)PBMGetDrawMoneyInfo *drawMoneyInfo;//获取提款信息
@property (nonatomic, strong)NSMutableDictionary *feeParam;//提款金额
@property (nonatomic, strong)DPPayPasswordView *passwordView;//目前没用到
@end

#define kHeaderForwardAttribure @"headerForwardAttribure"
#define kFooterBackAttribure @"footerBackAttribure"
@implementation DPDrawMoneyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clearFee];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.feeParam = [NSMutableDictionary dictionary];
    self.param = [NSMutableDictionary dictionary];
    [self requestData];
    [self.view addSubview:self.drawMoneyTable];
    
    [[MTStringParser sharedParser]addStyleWithTagName:@"headerF" font:[UIFont systemFontOfSize:16] color:UIColorFromRGB(0x666666)];
    [[MTStringParser sharedParser]addStyleWithTagName:@"footerF" font:[UIFont systemFontOfSize:16] color:UIColorFromRGB(0x666666)];
    [[MTStringParser sharedParser]addStyleWithTagName:@"footerB" font:[UIFont systemFontOfSize:16] color:UIColorFromRGB(0xdc4e4c)];
}

#pragma mark---------headerView

//头部信息
-(UIView *)headerView{
    if (!_headerView) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 94)];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        //提现银行卡
        UILabel *bankLabel = [UILabel dp_labelWithText:@"提现银行卡：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:16]];
        [_headerView addSubview:bankLabel];
        RAC(bankLabel, attributedText) = RACObserve(self,bankLabelStr);
        [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        //可提现现金
        UILabel *canDrawCountLabel = [UILabel dp_labelWithText:@"可提现金额：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:16]];
        [_headerView addSubview:canDrawCountLabel];
        RAC(canDrawCountLabel,attributedText) = RACObserve(self, canDrawCountLabelStr);
        [canDrawCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        
        UITapGestureRecognizer *closeKeyBoardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardGestureTapped)];
        [_headerView addGestureRecognizer:closeKeyBoardGesture];
       
    }
    return _headerView;
}
//关闭键盘
- (void)closeKeyBoardGestureTapped{
    [self.view endEditing:YES];
}
#pragma mark---------drawMoneyTabel
//提款银行卡列表
- (UITableView *)drawMoneyTable{
    if (!_drawMoneyTable) {
        _drawMoneyTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _drawMoneyTable.dataSource = self;
        _drawMoneyTable.delegate = self;
        _drawMoneyTable.tableFooterView = self.footerView;
        _drawMoneyTable.tableHeaderView = self.headerView;
        _drawMoneyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _drawMoneyTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        UITapGestureRecognizer *closeKeyBoardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardGestureTapped)];
        [_drawMoneyTable addGestureRecognizer:closeKeyBoardGesture];
    }
    return _drawMoneyTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DPUABaseCell *cell = [[DPUABaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.separatorLine.backgroundColor = UIColorFromRGB(0xb5b5b3);
    [cell.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    NSArray *placeholds = @[@"至少提款5元",@"请输入支付密码"];
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholds[indexPath.row];
    textField.font = [UIFont systemFontOfSize:13];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(98);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
   
    if (indexPath.row == 0) {
        self.drawMoneyText = textField;
        self.drawMoneyText.keyboardType = UIKeyboardTypeDecimalPad;
        cell.firstLine.hidden = NO;
    }else if (indexPath.row == 1){
        self.passwordText = textField;
        self.passwordText.secureTextEntry = YES;
    }
    
    
    NSArray *titles = @[@"提款金额：",@"支付密码:"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColorFromRGB(0x676767);
    [cell.textLabel sizeToFit];

    return cell;
}
//textfield's delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.drawMoneyText) {
        NSString *str = [textField.text stringByAppendingString:string];
        //检查当前输入是否符合规则，不符合，则禁止输入
        return [NSString checkMoneyRoleText:str];
    }else{
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.navigationController.topViewController != self) {
        return;
    }
    
    if (self.drawMoneyText.text.length==0) {
        [[DPToast makeText:@"请输入提款金额" color:[UIColor dp_flatBlackColor]] show];
        [self clearFee];
        return;
    }
    
    if ([self.drawMoneyText.text floatValue]<5) {
        [[DPToast makeText:@"至少提款5元" color:[UIColor dp_flatBlackColor]] show];
        [self clearFee];
        return;
    }
    
    if ([self.drawMoneyText.text floatValue]>[self.drawMoneyInfo.maxDrawCount floatValue]) {
        [[DPToast makeText:@"提款金额不能超过可提款金额" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    
    if (textField == self.drawMoneyText) {
        [self getFeeDrawMoney];
    }

}
//赋值
- (void)clearFee{
    self.realGetMoneyLabel.attributedText = [[MTStringParser sharedParser]attributedStringFromMarkup:@"<footerF>实际到账金额：</footerF><footerB>--</footerB>元"];
    self.feeLabel.attributedText = [[MTStringParser sharedParser]attributedStringFromMarkup:@"<footerF>手续费：</footerF><footerB>--</footerB>元"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark---------footerView
//列表底部信息
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 500)];
        _footerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        //实际到账金额
        self.realGetMoneyLabel =[UILabel dp_labelWithText:@"实际到账金额：" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x676767) font:[UIFont systemFontOfSize:16]];
        [_footerView addSubview:self.realGetMoneyLabel];
        [self.realGetMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        //手续费
        self.feeLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x676767) font:[UIFont systemFontOfSize:16]];
        [_footerView addSubview:self.feeLabel];
        [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.realGetMoneyLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        
        [self clearFee];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.layer.cornerRadius = 8;
        [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"确认提现" forState:UIControlStateNormal];
        btn.dp_eventId = DPAnalyticsTypeDrawSure ;
        [btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.feeLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        
        //注意事项
        UILabel *focusLabel = [UILabel dp_labelWithText:@"注意事项" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x2870d3) font:[UIFont systemFontOfSize:16]];
        focusLabel.text = @"注意事项";
        focusLabel.userInteractionEnabled = YES;
        focusLabel.textAlignment = NSTextAlignmentRight;
        UITapGestureRecognizer *focusGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusLabelTapped:)];
        [focusLabel addGestureRecognizer:focusGesture];
        [_footerView addSubview:focusLabel];
        [focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(14);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(16);
        }];
        
        UILabel *warningLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x676767) font:[UIFont systemFontOfSize:12]];
        NSString *warningText1 = @"1、提款手续费是根据不同银行的标准资费由银行扣除，网站不会收取您任何提款费用；";
        NSString *warningText2 = @"2、为了防止利用信用卡套现、洗钱等违法行为，网站针对异常提款做出以下规定： 凡消费金额（购买彩票成功）小于存入金额（不包含奖金）30%的账户发起提款申请时，本站不予受理；如确实需要处理的，网站将加收10%的异常提款处理费用并延长审核时间，审核时间不少于15个工作日；";
        NSString *warinText = [NSString stringWithFormat:@"%@\n%@\n%@",@"温馨提示:",warningText1,warningText2];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:warinText];
        [text addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 5)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 5)];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        [paragraph setLineSpacing:10];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, warinText.length)];
        warningLabel.attributedText = text;
        [_footerView addSubview:warningLabel];
        [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(50);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(220);
        }];
        
    }
    return _footerView;
}
//注意事项详情
- (void)focusLabelTapped:(UITapGestureRecognizer *)gesture{
    DPWebViewController *controller = [[DPWebViewController alloc]init];
    controller.title = @"注意事项";
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerBaseURL,@"/web/help/DrawAttention"];
    controller.requset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:controller animated:YES];
}

//确认体现
- (void)btnTapped{
    
    if (self.drawMoneyText.text.length==0) {
        [[DPToast makeText:@"请输入提款金额" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    
    if ([self.drawMoneyText.text floatValue]<5) {
        [[DPToast makeText:@"至少提款5元" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    
    
    if (self.passwordText.text.length==0){
        [[DPToast makeText:@"请输入支付密码" color:[UIColor dp_flatBlackColor]] show];
        return;
    }
    
  
    [self showHUD];
    PBMSubmitDrawMoneyParam *param = [[PBMSubmitDrawMoneyParam alloc]init];
    param.password = self.passwordText.text;
    param.amount = self.drawMoneyText.text;
    @weakify(self);
    [DPUARequestData submitDrawMoneyInfoWithParam:param Success:^(PBMSubmitDrawMoneyInfo *submitDrawMoneyInfo) {
        @strongify(self);
        [self dismissHUD];
        //提现成功则跳转到成功页面
        DPUADWSuccessController *controller = [[DPUADWSuccessController alloc]init];
        controller.reChangeResult = submitDrawMoneyInfo;
         [self.navigationController pushViewController:controller animated:YES];
    } andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
         [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}

#pragma mark---------requestData
//请求数据
- (void)requestData{
    @weakify(self);
    [DPUARequestData getDrawMoneyInfoWithParam:self.param Success:^(PBMGetDrawMoneyInfo *drawMoneyInfo) {
        @strongify(self);
        self.drawMoneyInfo = drawMoneyInfo;
     
        NSString *bankStr = [NSString stringWithFormat:@"<headerF>提现银行卡：</headerF>%@(尾号%@)",drawMoneyInfo.bankItem.bankName,drawMoneyInfo.bankItem.bankNum];
        self.bankLabelStr = [[MTStringParser sharedParser]attributedStringFromMarkup:bankStr];
      
        NSString *drawCountStr = [NSString stringWithFormat:@"<headerF>可提现金额：</headerF>%@元",drawMoneyInfo.maxDrawCount];
        self.canDrawCountLabelStr = [[MTStringParser sharedParser]attributedStringFromMarkup:drawCountStr];
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
    

}
//获取手续费
- (void)getFeeDrawMoney{
    [self showHUD];
    [self.feeParam setValue:self.drawMoneyText.text forKey:@"amount"];
    @weakify(self);
    [DPUARequestData getDrawMoneyFeeWithParam:self.feeParam Success:^(PBMFeeItem *feeItem) {
        @strongify(self);
        [self dismissHUD];
        NSString *realMoney = [NSString stringWithFormat:@"<footerF>实际到账金额：</footerF><footerB>%@</footerB>元",feeItem.realGetCount];
        self.realGetMoneyLabel.attributedText = [[MTStringParser sharedParser]attributedStringFromMarkup:realMoney];
        NSString *fee = [NSString stringWithFormat:@"<footerF>手续费：</footerF><footerB>%@</footerB>元",feeItem.feeCount];
        self.feeLabel.attributedText = [[MTStringParser sharedParser]attributedStringFromMarkup:fee];
    } andFail:^(NSString *failMessage) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}

@end
