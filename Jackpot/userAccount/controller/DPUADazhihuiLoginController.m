//
//  DPUADazhihuiLoginController.m
//  Jackpot
//
//  Created by mu on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面注释由sxf提供,如有更改，请标示

#import "DPUADazhihuiLoginController.h"
#import "DPIconTextCell.h"
@interface DPUADazhihuiLoginController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/*
 *  内容表单
 */
@property (nonatomic, strong) UITableView *contentTable;
/*
 *  headerView
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  footView
 */
@property (nonatomic, strong) UIView *footerView;
//====================data
/**
 *  表单数据
 */
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation DPUADazhihuiLoginController
#pragma mark---------lifeRecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"大智慧登录";
    [self.view addSubview:self.contentTable];
}

#pragma mark---------headerView
//大智慧头部logo
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIImageView *icon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"bigSmartLogo.png")];
        [_headerView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.centerY.mas_equalTo(_headerView.mas_centerY);
        }];
    }
    return _headerView;
}
#pragma mark---------contentTable
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _contentTable.tableFooterView = self.footerView;
        _contentTable.tableHeaderView = self.headerView;
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        UITapGestureRecognizer *gestures = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
        [_contentTable addGestureRecognizer:gestures];
    }
    return _contentTable;
}
//关闭键盘
- (void)closeKeyboard:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
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
    DPIconTextCell *cell = [[DPIconTextCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.text.tag = indexPath.row;
    cell.text.delegate = self;
    DPUAObject *object = self.tableData[indexPath.row];
    cell.object = object;
    return cell;
}
//textfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    DPUAObject *object = self.tableData[textField.tag];
    object.value = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark---------footerView

//底部登录
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
        _footerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        UIButton *loginBtn = [UIButton dp_buttonWithTitle:@"登录" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:UIColorFromRGB(0xdc4e4c)
 font:[UIFont systemFontOfSize:14]];
        loginBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        loginBtn.layer.cornerRadius = 5;
        loginBtn.dp_eventId = DPAnalyticsTypeLoginDzhButton ;
        [loginBtn addTarget:self action:@selector(loginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *subTitleLab =[UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xb2b2b2) font:[UIFont systemFontOfSize:10]];
        subTitleLab.textAlignment =NSTextAlignmentCenter;
        subTitleLab.text = @"客服热线：021-20219995";
        [_footerView addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loginBtn.mas_bottom).offset(18);
            make.centerX.equalTo(_footerView.mas_centerX);
            make.height.mas_equalTo(12);
        }];
        
    }
    return _footerView;
}
- (void)loginBtnTapped{
  
}
#pragma mark---------data
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        NSArray *imageNames = @[@"userName",@"password"];
        NSArray *placeHoldTitles = @[@"用户名/手机帐号",@"请输入密码"];
        for (NSInteger i = 0; i < 2; i++) {
            DPUAObject *object = [[DPUAObject alloc]init];
            object.subTitle = imageNames[i];
            object.title = placeHoldTitles[i];
            [_tableData addObject:object];
        }
    }
    return _tableData;
}
@end
