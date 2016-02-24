//
//  DPChangeBankViewController.m
//  Jackpot
//
//  Created by sxf on 15/8/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPChangeBankViewController.h"
#import "locationPickController.h"
#import "DPBankListConfigure.h"
#import "DPUAObject.h"
#import "DPAlterViewController.h"
#import "Security.pbobjc.h"
#import "DPSecurityCenterViewController.h"
@interface DPChangeBankViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate,
UITextFieldDelegate>
{
@private
    UITableView *_tableView;
    UITextField *_bankTf;
    UILabel *_bankName;
    UILabel *_bankAddress;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UITextField *bankTf;//提款卡号
@property (nonatomic, strong, readonly) UILabel *bankName;//开户行
@property (nonatomic, strong, readonly) UILabel *bankAddress;//归属地
@property (nonatomic, strong) NSMutableArray *bankArray;//开户行集合
@property (nonatomic, copy) NSString *bankId;           //银行id
@property (nonatomic, copy) NSString *blongToCityId;    //归属地id
@end

@implementation DPChangeBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor dp_flatBackgroundColor];
    self.title=@"修改提款银行卡";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //顶部
    UIView *tableHeaderView=[UIView dp_viewWithColor:[UIColor clearColor]];
    tableHeaderView.frame=CGRectMake(0, 0, kScreenWidth, 60);
    UIImageView *titleImageView=[[UIImageView alloc] init];
    titleImageView.backgroundColor=[UIColor clearColor];
    titleImageView.image=dp_AccountImage(@"newreminder.png");
    [tableHeaderView addSubview:titleImageView];
    UILabel *titleLabel=[self createLabel:@"银行卡信息和登记的实名信息需一致，银行卡必须是借记卡，用于提款。归属地用于兑大奖。" textColor:UIColorFromRGB(0xfa9796) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:12.0]];
    titleLabel.numberOfLines=2;
    [tableHeaderView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(titleImageView.mas_right).offset(5);
        make.right.equalTo(tableHeaderView).offset(-15);
        make.top.equalTo(tableHeaderView).offset(20);
        make.height.equalTo(@30);
    }];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(tableHeaderView).offset(10);
        make.width.equalTo(@16);
        make.centerY.equalTo(titleLabel);
        make.height.equalTo(@16);
    }];
    
    self.tableView.tableHeaderView=tableHeaderView;
    
    
    //底部
    UIView *tableviewFootView=[UIView dp_viewWithColor:[UIColor clearColor]];
    tableviewFootView.frame=CGRectMake(0, 0, kScreenWidth, 90);
    //下一步
    UIButton *nextButton=[[UIButton alloc] init];
    nextButton.backgroundColor=[UIColor clearColor];
    [nextButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorFromRGB(0xdb4e4d);
    nextButton.titleLabel.font=[UIFont systemFontOfSize:18];
    nextButton.layer.cornerRadius=5;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [tableviewFootView addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(tableviewFootView);
        make.width.equalTo(@(kScreenWidth-32));
        make.top.equalTo(tableviewFootView).offset(17);
        make.height.equalTo(@44);
    }];
    self.tableView.tableFooterView=tableviewFootView;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
    tagesture.delegate = self;
    [self.view addGestureRecognizer:tagesture];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)pvt_onTap{
    [self.view endEditing:YES];
}
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    if (screenHeight == keyboardY) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(endFrame)-30, 0);
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"changeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        [self createTableViewCell:cell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
    
}
//生成cell
-(void)createTableViewCell:(UITableViewCell *)cell{
    UIView  *infoView=[UIView dp_viewWithColor:[UIColor whiteColor]];
    [cell.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView);
        make.height.equalTo(@165);
    }];
    UIView *topView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *bottomView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *midView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [infoView addSubview:topView];
    [infoView addSubview:midView];
    [infoView addSubview:bottomView];
    UIView *line1=[UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line1];
    UIView *line2=[UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line2];
    UIView *line3=[UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line3];
    UIView *line4=[UIView dp_viewWithColor:UIColorFromRGB(0xc7c7c7)];
    [infoView addSubview:line4];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [midView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.centerY.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(infoView);
        make.height.equalTo(@55);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.top.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(midView);
        make.height.equalTo(@0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView).offset(15);
        make.right.equalTo(infoView);
        make.top.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.bottom.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *aceName=[self createLabel:@"提款卡号:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel *cardId=[self createLabel:@"开 户  行:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UILabel *bankNumber=[self createLabel:@"归 属  地:" textColor:UIColorFromRGB(0x676767) textAlignment:NSTextAlignmentLeft font:[UIFont dp_systemFontOfSize:17.0]];
    UIImageView *bankNameSelected=[[UIImageView alloc] init];
    bankNameSelected.backgroundColor=[UIColor clearColor];
    bankNameSelected.image=dp_AccountImage(@"triangle.png");
    UIImageView *bankAddressSelected=[[UIImageView alloc] init];
    bankAddressSelected.backgroundColor=[UIColor clearColor];
     bankAddressSelected.image=dp_AccountImage(@"triangle.png");
    [topView addSubview:aceName];
    [topView addSubview:self.bankTf];
    [midView addSubview:cardId];
    [midView addSubview:self.bankName];
    [midView addSubview:bankNameSelected];
    [bottomView addSubview:bankNumber];
    [bottomView addSubview:self.bankAddress];
    [bottomView addSubview:bankAddressSelected];
    
    [bankNameSelected mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(midView).offset(-20);
        make.width.equalTo(@14);
        make.centerY.equalTo(midView);
        make.height.equalTo(@7.5);
    }];
    [bankAddressSelected mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomView).offset(-20);
        make.width.equalTo(@14);
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@7.5);
    }];
    [aceName mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(topView).offset(15);
        make.width.equalTo(@75);
        make.top.equalTo(topView);
        make.bottom.equalTo(topView);
    }];
    [self.bankTf mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(aceName.mas_right).offset(5);
        make.right.equalTo(topView);
        make.top.equalTo(aceName);
        make.bottom.equalTo(aceName);
    }];
    [cardId mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(aceName);
        make.right.equalTo(aceName);
        make.centerY.equalTo(midView);
        make.height.equalTo(midView);
    }];
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(cardId.mas_right).offset(5);
        make.right.equalTo(bankNameSelected.mas_left);
        make.top.equalTo(cardId);
        make.bottom.equalTo(cardId);
    }];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(aceName);
        make.right.equalTo(aceName);
        make.top.equalTo(bottomView);
        make.height.equalTo(bottomView);
    }];
    [self.bankAddress mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bankNumber.mas_right).offset(5);
        make.right.equalTo(bankAddressSelected.mas_left);
        make.top.equalTo(bankNumber);
        make.bottom.equalTo(bankNumber);
    }];
    [midView addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_getBankName)];
        tapRecognizer;
    })];
    [bottomView addGestureRecognizer:({
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_getBankAddress)];
        tapRecognizer;
    })];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//绑定新手机
-(void)nextClick{
    [self.view endEditing:YES];
    if (self.bankTf.text.length<1) {
        [[DPToast makeText:@"请输入提现卡号"] show];
        return;
    }
    if ([self.bankName.text isEqualToString:@"请选择开户行"]) {
        [[DPToast makeText:@"请选择开户行"] show];
        return;
    }
    if ([self.bankAddress.text isEqualToString:@"请选择归属地"]) {
        [[DPToast makeText:@"请选择归属地"] show];
        return;
    }
    PBMModifyDrawingCard *item=[[PBMModifyDrawingCard alloc] init];
    item.bankNo=self.bankTf.text;
    item.bankName=self.bankName.text;
    item.bankId=self.bankId;
     item.blongToCity=[self.blongToCityId integerValue];
    item.token=self.token;
    item.attributionDesc=self.bankAddress.text;
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/account/ModifyAccountDrawBank"
                                       parameters:item
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                               [self dismissHUD];
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                          failure:^(NSURLSessionDataTask *task, NSError *error){
                                              [self dismissHUD];
                                              [[DPToast makeText:error.dp_errorMessage] show];
                                          }];

    
}

- (void)pvt_onBack {
    [[DPToast sharedToast]dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
//打开开户行的选择
-(void)pvt_getBankName{
    [self.view endEditing:YES];
    DPAlterViewController *controller = [[DPAlterViewController alloc]initWithAlterType:AlterTypeBankChose];
    controller.bankBlock = ^(DPUAObject *bankItem){
        self.bankName.text = bankItem.title;
        self.bankId = bankItem.value;
        self.bankName.text = bankItem.title;
        if (self.bankName.text.length>0) {
            self.bankName.textColor=UIColorFromRGB(0x676767);
        }
    };
    controller.bankArray = self.bankArray;
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
//打开归属地的选择
-(void)pvt_getBankAddress{
   [self.view endEditing:YES];
    locationPickController *controller = [[locationPickController alloc]init];
    controller.locationBlock = ^(NSString *str, NSString *code) {
        self.bankAddress.text = str;
        self.blongToCityId = code;
        if (self.bankAddress.text.length > 0) {
            self.bankAddress.textColor = UIColorFromRGB(0x676767);
        }
    };
    [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
#pragma mark - getter, setter
- (UITableView *)tableView {
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
//提款卡号
-(UITextField *)bankTf {
    if (_bankTf == nil) {
        _bankTf = [[UITextField alloc] init];
        _bankTf.backgroundColor = [UIColor clearColor];
//        _bankTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _bankTf.textColor = UIColorFromRGB(0x676767);
        _bankTf.textAlignment = NSTextAlignmentLeft;
//        _bankTf.secureTextEntry = YES;
        _bankTf.font = [UIFont dp_systemFontOfSize:17];
        _bankTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankTf.placeholder=@"请输入提款卡号";
        _bankTf.keyboardType=UIKeyboardTypeNumberPad;
        //        _oldPhoneTf.returnKeyType = UIReturnKeyNext;
        //        _passTextfieldOld.delegate = self;
    }
    return _bankTf;
}
//开户行
-(UILabel *)bankName{
    if (_bankName==nil) {
        _bankName=[[UILabel alloc] init];
        _bankName.text=@"请选择开户行";
        _bankName.backgroundColor=[UIColor clearColor];
        _bankName.textAlignment=NSTextAlignmentLeft;
        _bankName.textColor=UIColorFromRGB(0xc7c7cc);
        _bankName.font = [UIFont dp_systemFontOfSize:17];
        
    }
    return _bankName;
}
//归属地
-(UILabel *)bankAddress{
    if (_bankAddress==nil) {
        _bankAddress=[[UILabel alloc] init];
        _bankAddress.text=@"请选择归属地";
        _bankAddress.textAlignment=NSTextAlignmentLeft;
        _bankAddress.backgroundColor=[UIColor clearColor];
        _bankAddress.font = [UIFont dp_systemFontOfSize:17];
        _bankAddress.textColor=UIColorFromRGB(0xc7c7cc);
        
    }
    return _bankAddress;
}
//获取底层开户行集
- (NSMutableArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
        DPBankListConfigure *bankConfigure  = [[DPBankListConfigure alloc]init];
        for (NSInteger i = 0; i < bankConfigure.bankList.count; i++) {
            DPBankInfo *bankInfo = bankConfigure.bankList[i];
            DPUAObject *object = [[DPUAObject alloc]init];
            object.title = bankInfo.name;
            object.value = bankInfo.code;
            [_bankArray addObject:object];
        }
    }
    return _bankArray;
}

-(UILabel *)createLabel:(NSString *)text  textColor:(UIColor *)textColor  textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font{
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textColor=textColor;
    label.textAlignment=textAlignment;
    label.font=font;
    return label;
}


@end


