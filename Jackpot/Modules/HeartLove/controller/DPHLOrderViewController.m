//
//  DPHLOrderViewController.m
//  Jackpot
//
//  Created by mu on 16/1/4.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPHLOrderViewController.h"
#import "Wages.pbobjc.h"
@interface DPHLOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UILabel *headerLab;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *valuesArray;
@end

@implementation DPHLOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单确认";
    
    [self setupData];
    [self setupUI];
}
- (void)setupUI{
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([self.contentTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contentTable setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    }
    if ([self.contentTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contentTable setLayoutMargins:UIEdgeInsetsMake(0, 16, 0, 0)];
    }
}
#pragma mark---------contentTable
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.sectionHeaderHeight = 40;
        _contentTable.sectionFooterHeight = 0;
        _contentTable.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _contentTable.tableFooterView = self.footerView;
    }
    return _contentTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = [UIColor clearColor];

    self.headerLab = [UILabel dp_labelWithText:[NSString stringWithFormat:@"购买 %@ 发起的心水",self.wagesObject.userNameLabelStr] backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
    [headerView addSubview:self.headerLab];
    [self.headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(16);
    }];

    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"defaltCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor dp_flatRedColor];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc]initWithString:self.valuesArray[indexPath.row]];
    [attributes addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333)} range:NSMakeRange(attributes.length>0?attributes.length-1:0, attributes.length>0?1:0)];
    cell.detailTextLabel.attributedText = attributes;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.contentTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contentTable setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    }
    if ([self.contentTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contentTable setLayoutMargins:UIEdgeInsetsMake(0, 16, 0, 0)];
    }
}
#pragma mark---------footer
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        self.buyBtn = [UIButton dp_buttonWithTitle:@"立即支付" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont boldSystemFontOfSize:18]];
        self.buyBtn.layer.cornerRadius = 8;
        @weakify(self);
        [[self.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            @strongify(self);

        }];
        [_footerView addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.centerX.equalTo(_footerView.mas_centerX);
            make.width.mas_equalTo(kScreenWidth-32);
            make.height.mas_equalTo(44);
        }];
    }
    return _footerView;
}
#pragma mark---------data
- (void)setupData{
    self.titleArray = @[@"心水金额",@"账户余额"];
    self.valuesArray = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%@元",self.wagesObject.buyBtnStr],@"--元"]];
    
    [self requestDataFromServer];
}
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:@"/wages/UserInfo" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        WagesUserInfo *userInfo = [WagesUserInfo parseFromData:responseObject error:nil];
        [self.valuesArray setObject:[NSString stringWithFormat:@"%@元",userInfo.amount] atIndexedSubscript:1];
        [self.contentTable reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
    }];
}
@end
