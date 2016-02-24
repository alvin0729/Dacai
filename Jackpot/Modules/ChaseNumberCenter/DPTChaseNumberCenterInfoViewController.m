//
//  DPTChaseNumberCenterInfoViewController.m
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPTChaseNumberCenterInfoViewController.h"

#import "DPLTDltViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPProjectDetailViewController.h"
#import "SVPullToRefresh.h"

#import "DPAlterViewController.h"
#import "DPChaseNumberInfoCell.h"
#import "DPDltBetData.h"
#import "DPDltContentModel.h"
#import "DPProjectDetailCell.h"
#import "LotteryHistory.pbobjc.h"
#import "Order.pbobjc.h"
@interface DPTChaseNumberCenterInfoViewController () <UITableViewDelegate, UITableViewDataSource> {
@private
    UITableView *_tableView;
    UILabel *_totalMoney;
    UILabel *_moneyed;
    UILabel *_totalIssue;
    UILabel *_issued;
    UILabel *_startTime;
    UILabel *_currentState;
    UIButton *_gotobutton, *_selectedButton, *_payButton;
    UILabel *_chaseProjectId;
    UIButton *_stopChaseButton;
}
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIButton *stopChaseButton; //停止追号
@property (nonatomic, strong, readonly) UILabel *totalMoney; //追号金额
@property (nonatomic, strong, readonly) UILabel *moneyed; //已追金额
@property (nonatomic, strong, readonly) UILabel *totalIssue; //追号期数
@property (nonatomic, strong, readonly) UILabel *issued; //已追期号
@property (nonatomic, strong, readonly) UILabel *startTime; //发起时间
@property (nonatomic, strong, readonly) UILabel *currentState; //追号状态
@property (nonatomic, strong, readonly) UIButton *gotobutton, *selectedButton, *payButton; //继续追号   重新选号   立即投注
@property (nonatomic, strong) NSMutableArray *indexPathArray;
@property (nonatomic, strong, readonly) UILabel *chaseProjectId; //追号id
@property (nonatomic, strong) NSArray *betArray;//投注数组

@property (nonatomic, strong) PBMChaseCenterInfo* dataBase;//追号数据
@end

@implementation DPTChaseNumberCenterInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.indexPathArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 55, 0));
    }];
    [self bulidLayOutForHeader];
    [self bulidlayOutForTableFooterView];
    [self bulidLayOutForBottom];

    // Do any additional setup after loading the view.
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf reqeustInfoForProejectDetail];
    }];
    [self reqeustInfoForProejectDetail];
}
//请求追号内容
- (void)reqeustInfoForProejectDetail
{
    [self showHUD];
    //由于传输途径不一样，因此这地方获取方案id(后期优化)
    if (self.projectId <= 0 || self.ChaseCenterListItem) {
        self.projectId = self.ChaseCenterListItem.chaseId;
    }
    self.title = @"追号详情";

    [[AFHTTPSessionManager dp_sharedManager] GET:@"/Project/FollowDetail"
        parameters:@{ @"followid" : @(self.projectId) }
        success:^(NSURLSessionDataTask* task, id responseObject) {

            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
            self.dataBase = [PBMChaseCenterInfo parseFromData:responseObject error:nil];

            [self requestAllData];
        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
            [[DPToast makeText:error.dp_errorMessage] show];
            [self requestAllData]; //请求失败删掉
        }];
}
//刷新数据源
- (void)requestAllData
{
    if ((self.dataBase.payStatus == 1)&&(self.dataBase.chasedState==1))//当前未支付状态且未流标或者过期
    {
        [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        self.payButton.hidden = NO;
        self.gotobutton.hidden = YES;
        self.selectedButton.hidden = YES;
    }
    else {
        self.payButton.hidden = YES;
        self.gotobutton.hidden = NO;
        self.selectedButton.hidden = NO;
    }
    //根据当前追号状态来判断是否显示停止追号
    if (self.dataBase.chaseInfoArray.count < 1 || (self.dataBase.chasedState != 2)) {
        self.stopChaseButton.hidden = YES;
    }
    else {
        self.stopChaseButton.hidden = NO;
    }
   //获取投注信息（json解析）
    self.betArray = [NSArray yy_modelArrayWithClass:[DPProjectDltBaseModel class] json:self.dataBase.betContent];
    
    self.chaseProjectId.text = [NSString stringWithFormat:@"方案号:%lld", self.projectId];
    NSMutableAttributedString* totalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld元", self.dataBase.chaseTotalMoney]];
    [totalString addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xdc4e4e) range:NSMakeRange(0, totalString.length - 1)];
    self.totalMoney.attributedText = totalString;
    self.moneyed.text = [NSString stringWithFormat:@"%lld元", self.dataBase.chasedMoney];
    self.totalIssue.text = [NSString stringWithFormat:@"%d期", self.dataBase.totalIssueCount];
    self.issued.text = [NSString stringWithFormat:@"%d期", self.dataBase.chasedIssueCount];
    self.startTime.text = [NSDate dp_coverDateString:self.dataBase.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
    ;
    self.currentState.text = [self chaseStringForState:self.dataBase.chasedState];

    [self.tableView reloadData];
}
//获取追号状态
- (NSString*)chaseStringForState:(NSInteger)index
{
    NSString* chaseString = @"";
    switch (index) {
    case 1:
        chaseString = @"未支付";
        break;
    case 2:
        chaseString = @"进行中";
        break;
    case 3:
        chaseString = @"流标";
        break;
    case 4:
        chaseString = @"部分期次已停止追号";
        break;
    case 5:
        chaseString = @"已完成";
        break;

    default:
        break;
    }
    return chaseString;
}
//顶部
- (void)bulidLayOutForHeader
{
    UIView* headerView = [UIView dp_viewWithColor:[UIColor clearColor]];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 185);
    UIView* topView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [headerView addSubview:topView];
    UIView* bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [headerView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.top.equalTo(headerView);
        make.height.equalTo(@56);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.top.equalTo(topView.mas_bottom);
    }];
    UIView* line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
    [topView addSubview:line1];
    UIView* line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
    [bottomView addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(topView);
        make.right.equalTo(topView);
        make.bottom.equalTo(topView);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    UIImageView* lotteryIcon = [[UIImageView alloc] init];
    lotteryIcon.backgroundColor = [UIColor clearColor];
    UILabel* lotteryTitle = [self createLabel:@"" textColor:UIColorFromRGB(0x000000) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:18.0]];
    lotteryTitle.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:lotteryIcon];
    [topView addSubview:lotteryTitle];
    [topView addSubview:self.chaseProjectId];
    [lotteryIcon mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(topView).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(topView);
    }];
    [lotteryTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(lotteryIcon.mas_right).offset(10);
        make.height.equalTo(@20);
        make.centerY.equalTo(topView).offset(-8);
    }];
    [self.chaseProjectId mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(lotteryTitle);
        make.height.equalTo(@13);
        make.top.equalTo(lotteryTitle.mas_bottom).offset(4);
    }];

    if (self.gameType == GameTypeDlt) {
        lotteryIcon.image = dp_AppRootImage(@"dlt.png");
        lotteryTitle.text = @"大乐透";
    }

    UILabel* totalMoneyLabel = [self createLabel:@"追号金额:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel* moneyedLabel = [self createLabel:@"已追金额:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel* issueLabel = [self createLabel:@"追号期号:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel* issuedLabel = [self createLabel:@"已追期数:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel* startTimeLabel = [self createLabel:@"发起时间:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel* stateLabel = [self createLabel:@"追号状态:" textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    totalMoneyLabel.adjustsFontSizeToFitWidth = YES;
    moneyedLabel.adjustsFontSizeToFitWidth = YES;
    issueLabel.adjustsFontSizeToFitWidth = YES;
    issuedLabel.adjustsFontSizeToFitWidth = YES;
    startTimeLabel.adjustsFontSizeToFitWidth = YES;
    stateLabel.adjustsFontSizeToFitWidth = YES;
    self.totalMoney.adjustsFontSizeToFitWidth = YES;
    self.moneyed.adjustsFontSizeToFitWidth = YES;
    self.totalIssue.adjustsFontSizeToFitWidth = YES;
    self.issued.adjustsFontSizeToFitWidth = YES;
    self.startTime.adjustsFontSizeToFitWidth = YES;
    self.currentState.adjustsFontSizeToFitWidth = YES;
    [bottomView addSubview:totalMoneyLabel];
    [bottomView addSubview:moneyedLabel];
    [bottomView addSubview:issueLabel];
    [bottomView addSubview:issuedLabel];
    [bottomView addSubview:startTimeLabel];
    [bottomView addSubview:stateLabel];
    [bottomView addSubview:self.totalMoney];
    [bottomView addSubview:self.moneyed];
    [bottomView addSubview:self.totalIssue];
    [bottomView addSubview:self.issued];
    [bottomView addSubview:self.startTime];
    [bottomView addSubview:self.currentState];
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(bottomView).offset(16);
        make.top.equalTo(bottomView).offset(12);
        make.height.equalTo(@12);
    }];
    [moneyedLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(bottomView.mas_centerX).offset(10);
        make.top.equalTo(totalMoneyLabel);
        make.bottom.equalTo(totalMoneyLabel);
    }];
    [issueLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(totalMoneyLabel);
        make.top.equalTo(totalMoneyLabel.mas_bottom).offset(19);
        make.height.equalTo(@12);
    }];
    [issuedLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(moneyedLabel);
        make.top.equalTo(issueLabel);
        make.bottom.equalTo(issuedLabel);
    }];
    [startTimeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(totalMoneyLabel);
        make.top.equalTo(issueLabel.mas_bottom).offset(19);
        make.height.equalTo(@12);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(totalMoneyLabel);
        make.top.equalTo(startTimeLabel.mas_bottom).offset(19);
        make.height.equalTo(@12);
    }];

    [self.totalMoney mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(totalMoneyLabel.mas_right).offset(5);
        make.top.equalTo(totalMoneyLabel);
        make.bottom.equalTo(totalMoneyLabel);
    }];
    [self.moneyed mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(moneyedLabel.mas_right).offset(5);
        make.top.equalTo(moneyedLabel);
        make.bottom.equalTo(moneyedLabel);
    }];
    [self.totalIssue mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(issueLabel.mas_right).offset(5);
        make.top.equalTo(issueLabel);
        make.bottom.equalTo(issueLabel);
    }];
    [self.issued mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(issuedLabel.mas_right).offset(5);
        make.top.equalTo(issuedLabel);
        make.bottom.equalTo(issuedLabel);
    }];
    [self.startTime mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(startTimeLabel.mas_right).offset(5);
        make.top.equalTo(startTimeLabel);
        make.bottom.equalTo(startTimeLabel);
    }];
    [self.currentState mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(stateLabel.mas_right).offset(5);
        make.top.equalTo(stateLabel);
        make.bottom.equalTo(stateLabel);
    }];

    self.tableView.tableHeaderView = headerView;
}
//tableView底部
- (void)bulidlayOutForTableFooterView
{
    UIView* backView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xd0cfcd)];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
    backView.frame = CGRectMake(0, 0, kScreenWidth, 30);
    [backView addSubview:self.stopChaseButton];
    [self.stopChaseButton addTarget:self action:@selector(stopChaseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.stopChaseButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-16);
        make.width.equalTo(@45);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = backView;
}
//底部
- (void)bulidLayOutForBottom
{
    UIView* bottomView = [UIView dp_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    UIView* lineView = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [bottomView addSubview:lineView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(bottomView);
        make.height.equalTo(@1);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);

    }];
    [bottomView addSubview:self.gotobutton];
    [bottomView addSubview:self.selectedButton];
    [bottomView addSubview:self.payButton];
    [self.gotobutton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView).offset(16);
        make.right.equalTo(bottomView.mas_centerX).offset(-8.5);
    }];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.right.equalTo(bottomView).offset(-16);
        make.left.equalTo(bottomView.mas_centerX).offset(8.5);
    }];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView).offset(16);
        make.right.equalTo(bottomView).offset(-16);
    }];
    if (self.gameType == GameTypeDlt) {
        self.payButton.hidden = YES;
        self.gotobutton.hidden = NO;
        self.selectedButton.hidden = NO;
    }
    if (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) {
        [self.payButton setTitle:@"继续投注" forState:UIControlStateNormal];
        self.payButton.hidden = NO;
        self.gotobutton.hidden = YES;
        self.selectedButton.hidden = YES;
    }
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return MAX(self.betArray.count, 0);
    }
    return MAX(self.dataBase.chaseInfoArray.count, 0);
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   //投注内容
    if (indexPath.section == 0) {
        static NSString* CellIdentifier = @"dltProjectCell";
        DPProjectDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPProjectDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == self.betArray.count - 1) {
            cell.lineView.hidden = YES;
        }
        else {
            cell.lineView.hidden = NO;
        }
        if (indexPath.row >= self.betArray.count) {
            return cell;
        }
        DPProjectDltBaseModel* model = [self.betArray objectAtIndex:indexPath.row];
        [cell infoLabelText:[self dltChaseProjectDlt:model]];
        [cell titleLabelText:model.title];
        return cell;
    }
    //追号内容
    static NSString* CellIdentifier = @"ChaseNumberInfoCell";
    DPChaseNumberInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPChaseNumberInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PBMChaseCenterInfo_ChaseCenterItem* item = [self.dataBase.chaseInfoArray objectAtIndex:indexPath.row];
    [cell setIssueLabelText:item.gameName.length > 3 ? [item.gameName substringFromIndex:item.gameName.length - 3] : item.gameName];
    [cell setStateLabel:item.chaseState];
    [cell setWinLabelText:item.winInfo];
    [cell setDrawLabelText:[self chaseDrawInfo:item.drawNumbers]];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row >= self.betArray.count) {
            return 32;
        }
        DPProjectDltBaseModel* model = [self.betArray objectAtIndex:indexPath.row];
        CGRect rect = [[self dltChaseProjectDlt:model] boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        return 35 + rect.size.height;
    }
    return 32;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 42;
    }
    return 64;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        static NSString* HeaderIdentifier = @"chaseNumber";
        DPChaseNumberContentHeaderView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
        if (view == nil) {
            view = [[DPChaseNumberContentHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
            [view bulidLayOut];
        }

        return view;
    }
    static NSString* HeaderIdentifier = @"Header";
    DPChaseNumberProjectHeaderView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[DPChaseNumberProjectHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
        [view bulidLayOut];
    }
    view.projectInfo.text = [NSString stringWithFormat:@"%lld注*%lld倍", self.dataBase.quantity, self.dataBase.multiple];
    return view;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row >= self.dataBase.chaseInfoArray.count) {
        return;
    }
    PBMChaseCenterInfo_ChaseCenterItem* item = [self.dataBase.chaseInfoArray objectAtIndex:indexPath.row];
    DPProjectDetailViewController* controller = [[DPProjectDetailViewController alloc] init];
    controller.projectId = item.projectId;
    controller.gameType = self.gameType;
    [self.navigationController pushViewController:controller animated:YES];
}
//获取大乐透的方案内容
- (NSMutableAttributedString*)dltChaseProjectDlt:(DPProjectDltBaseModel*)viewModel
{
    NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:@""];
    NSDictionary* attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:12.0], NSFontAttributeName,
                                                 UIColorFromRGB(0x867d6e), NSForegroundColorAttributeName, nil];
    NSDictionary* attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIFont systemFontOfSize:12.0], NSFontAttributeName,
                                                 UIColorFromRGB(0xd0cfcd), NSForegroundColorAttributeName, nil];
    if ([viewModel isKindOfClass:[DPProjectDltDuplex class]])////大乐透复式
    {
        DPProjectDltDuplex* model = (DPProjectDltDuplex*)viewModel;
        for (int i = 0; i < model.propAreaNums.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:i == 0 ? [model.propAreaNums objectAtIndex:i] : [NSString stringWithFormat:@"  %@  ", [model.propAreaNums objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
        for (int i = 0; i < model.backAreaNums.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ", [model.backAreaNums objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
    }
    else if ([viewModel isKindOfClass:[DPProjectDltSingle class]])//大乐透单式
    {
        DPProjectDltSingle* model = (DPProjectDltSingle*)viewModel;
        for (int i = 0; i < model.bets.count; i++) {
            if (i > 0) {
                [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }
            NSString* singleString = [[model.bets objectAtIndex:i] stringByReplacingOccurrencesOfString:@"," withString:@"  "];
            singleString = [singleString stringByReplacingOccurrencesOfString:@"|" withString:@"  |  "];
            NSMutableAttributedString* tempString = [[NSMutableAttributedString alloc] initWithString:singleString attributes:attributeDict1];
            NSRange range = [singleString rangeOfString:@"|"];
            [tempString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd0cfcd) range:range];
            [hinstring appendAttributedString:tempString];
        }
    }
    else if ([viewModel isKindOfClass:[DPProjectDltGallDrag class]])//大乐透胆拖
    {
        DPProjectDltGallDrag* model = (DPProjectDltGallDrag*)viewModel;
        for (int i = 0; i < model.propAreaGalls.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:i == 0 ? [model.propAreaGalls objectAtIndex:i] : [NSString stringWithFormat:@"  %@  ", [model.propAreaGalls objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
        for (int i = 0; i < model.propAreaDrags.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ", [model.propAreaDrags objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  |  " attributes:attributeDict2]];
        for (int i = 0; i < model.propAreaGalls.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ", [model.propAreaGalls objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  #  " attributes:attributeDict1]];
        for (int i = 0; i < model.backAreaDrags.count; i++) {
            [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ", [model.backAreaDrags objectAtIndex:i]] attributes:attributeDict1]];
            ;
        }
    }

    return hinstring;
}
//追号内容标示颜色
- (NSMutableAttributedString*)chaseDrawInfo:(NSString*)drawInfo
{
    NSMutableAttributedString* hinstring = [[NSMutableAttributedString alloc] initWithString:@""];
    if (drawInfo.length < 1) {
        return hinstring;
    }
    switch (self.gameType) {
    case GameTypeDlt: {
        NSArray* array = [drawInfo componentsSeparatedByString:@"|"];
        if (array.count < 2) {
            return hinstring;
        }
        NSString* redString = [[array objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSString* blueString = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"," withString:@" "];
        [hinstring appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", redString, blueString]]];
        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xdc4f4d) range:NSMakeRange(0, redString.length)];
        [hinstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0d77d4) range:NSMakeRange(redString.length + 1, blueString.length)];

    } break;

    default:
        break;
    }

    return hinstring;
}

//数字彩继续改号
- (void)pvt_continue
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.betArray.count; i++) {
        DPProjectDltBaseModel* model = [self.betArray objectAtIndex:i];
        if ([model isKindOfClass:[DPProjectDltDuplex class]]) {
            DPProjectDltDuplex* viewModel = (DPProjectDltDuplex*)model;
            DPDltBetData* dltData = [[DPDltBetData alloc] init];
            int red[50] = { 0 };
            int blue[50] = { 0 };
            for (int i = 0; i < viewModel.propAreaNums.count; i++) {
                NSInteger index = [[viewModel.propAreaNums objectAtIndex:i] integerValue] - 1;
                red[index] = 1;
            }
            for (int i = 0; i < viewModel.backAreaNums.count; i++) {
                NSInteger index = [[viewModel.backAreaNums objectAtIndex:i] integerValue] - 1;
                blue[index] = 1;
            }
            for (int m = 0; m < 50; m++) {
                [dltData.red addObject:[NSNumber numberWithInt:red[m]]];
            }
            for (int m = 0; m < 50; m++) {
                [dltData.blue addObject:[NSNumber numberWithInt:blue[m]]];
            }
            dltData.mark = NO;
            dltData.note = [NSNumber numberWithInteger:viewModel.note];
            [array addObject:dltData];
        }
        else if ([model isKindOfClass:[DPProjectDltSingle class]]) {
            DPProjectDltSingle* viewModel = (DPProjectDltSingle*)model;
            for (int i = 0; i < viewModel.bets.count; i++) {
                DPDltBetData* dltData = [[DPDltBetData alloc] init];
                int red[50] = { 0 };
                int blue[50] = { 0 };
                NSArray* tempArray = [[viewModel.bets objectAtIndex:i] componentsSeparatedByString:@"|"];
                if (tempArray.count == 2) {
                    NSArray* redArray = [[tempArray objectAtIndex:0] componentsSeparatedByString:@","];
                    NSArray* blueArray = [[tempArray objectAtIndex:1] componentsSeparatedByString:@","];
                    for (int m = 0; m < redArray.count; m++) {
                        NSInteger index = [[redArray objectAtIndex:m] integerValue] - 1;
                        red[index] = 1;
                    }
                    for (int m = 0; m < blueArray.count; m++) {
                        NSInteger index = [[blueArray objectAtIndex:m] integerValue] - 1;
                        blue[index] = 1;
                    }
                    for (int m = 0; m < 50; m++) {
                        [dltData.red addObject:[NSNumber numberWithInt:red[m]]];
                    }
                    for (int m = 0; m < 50; m++) {
                        [dltData.blue addObject:[NSNumber numberWithInt:blue[m]]];
                    }
                }
                dltData.mark = NO;
                dltData.note = [NSNumber numberWithInteger:1];
                [array addObject:dltData];
            }
        }
        else if ([model isKindOfClass:[DPProjectDltGallDrag class]]) {
            DPProjectDltGallDrag* viewModel = (DPProjectDltGallDrag*)model;
            DPDltBetData* dltData = [[DPDltBetData alloc] init];
            int red[50] = { 0 };
            int blue[50] = { 0 };
            for (int i = 0; i < viewModel.propAreaGalls.count; i++) {
                NSInteger index = [[viewModel.propAreaGalls objectAtIndex:i] integerValue] - 1;
                red[index] = -1;
            }
            for (int i = 0; i < viewModel.propAreaDrags.count; i++) {
                NSInteger index = [[viewModel.propAreaDrags objectAtIndex:i] integerValue] - 1;
                red[index] = 1;
            }
            for (int i = 0; i < viewModel.backAreaGalls.count; i++) {
                NSInteger index = [[viewModel.backAreaGalls objectAtIndex:i] integerValue] - 1;
                blue[index] = -1;
            }
            for (int i = 0; i < viewModel.backAreaDrags.count; i++) {
                NSInteger index = [[viewModel.backAreaDrags objectAtIndex:i] integerValue] - 1;
                blue[index] = 1;
            }
            for (int m = 0; m < 50; m++) {
                [dltData.red addObject:[NSNumber numberWithInt:red[m]]];
            }
            for (int m = 0; m < 50; m++) {
                [dltData.blue addObject:[NSNumber numberWithInt:blue[m]]];
            }
            dltData.mark = YES;
            dltData.note = [NSNumber numberWithInteger:viewModel.note];
            [array addObject:dltData];
        }
    }
    DPLTDltViewController* vc = [[DPLTDltViewController alloc] init];
    vc.viewModel.infoArray = array;
    [self.navigationController pushViewController:vc animated:YES];
}
//数字彩重新选号
- (void)pvt_selected
{
    DPLTDltViewController* vc = [[DPLTDltViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//未支付订单/竞彩重新选号
- (void)pvt_payMoney
{
    if ((self.dataBase.payStatus == 1)&&(self.dataBase.chasedState==1)) {
        [self showHUD];
        [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/UsableRegBag"
                                          parameters:@{ @"souceid" : @(self.projectId),
                                                        @"type" : @(1),
                                                        @"gametype" :@(self.gameType)  }
            success:^(NSURLSessionDataTask* task, id responseObject) {

                [self dismissHUD];
                PBMCreateOrderResult* result = [PBMCreateOrderResult parseFromData:responseObject error:nil];

                DPPayRedPacketViewController* vc = [[DPPayRedPacketViewController alloc] init];
                vc.gameType = (int)self.gameType;
                vc.dataBase = result;
                vc.isChase = YES;
                vc.gameName=self.dataBase.startGameName;
                vc.gameId=self.dataBase.startGameId;
                vc.totalIssue = self.dataBase.totalIssueCount;
                vc.projectMoney = self.dataBase.totalIssueCount;
                [self.navigationController pushViewController:vc animated:YES];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
            }];
        return;
    }
}
//停止追号
- (void)stopChaseClick
{

    DPAlterViewController* alterView = [[DPAlterViewController alloc] initWithAlterType:AlterTypeStopChase];

    @weakify(self);
    alterView.sevice = ^(UIButton* btn) {
        @strongify(self);

        PBMStopChaseParam* param = [[PBMStopChaseParam alloc] init];
        param.chaseId = self.projectId;
        [self showHUD];
        [[AFHTTPSessionManager dp_sharedManager] POST:@"/service/StopFollowProject"
            parameters:param
            success:^(NSURLSessionDataTask* task, id responseObject) {

                [self dismissHUD];
                self.stopChaseButton.hidden = YES;
                [[DPToast makeText:@"停止追号成功"] show];
                [self reqeustInfoForProejectDetail];
            }
            failure:^(NSURLSessionDataTask* task, NSError* error) {
                [self dismissHUD];
                [[DPToast makeText:error.dp_errorMessage] show];
                [self reqeustInfoForProejectDetail];
            }];
    };

    [self dp_showViewController:alterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
#pragma mark - getter, setter

//列表
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableView.estimatedRowHeight =44.0;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
//追号id
- (UILabel*)chaseProjectId
{
    if (_chaseProjectId == nil) {
        _chaseProjectId = [[UILabel alloc] init];
        _chaseProjectId.backgroundColor = [UIColor clearColor];
        //        _issueLabel.text=@"第13105期";
        _chaseProjectId.textColor = UIColorFromRGB(0x666666);
        _chaseProjectId.textAlignment = NSTextAlignmentLeft;
        _chaseProjectId.font = [UIFont systemFontOfSize:12.0];
        _chaseProjectId.adjustsFontSizeToFitWidth = YES;
    }
    return _chaseProjectId;
}
//追号金额
- (UILabel*)totalMoney
{
    if (_totalMoney == nil) {
        _totalMoney = [[UILabel alloc] init];
        _totalMoney.backgroundColor = [UIColor clearColor];
        _totalMoney.textColor = UIColorFromRGB(0x333333);
        _totalMoney.textAlignment = NSTextAlignmentLeft;
        _totalMoney.font = [UIFont systemFontOfSize:14.0];
        _totalMoney.adjustsFontSizeToFitWidth = YES;
    }
    return _totalMoney;
}
//已追金额
- (UILabel*)moneyed
{
    if (_moneyed == nil) {
        _moneyed = [[UILabel alloc] init];
        _moneyed.backgroundColor = [UIColor clearColor];
        //        _projectState.text=@"已中100.67元";
        _moneyed.textColor = UIColorFromRGB(0x333333);
        _moneyed.textAlignment = NSTextAlignmentLeft;
        _moneyed.font = [UIFont systemFontOfSize:12.0];
    }
    return _moneyed;
}
//追号期数
- (UILabel*)totalIssue
{
    if (_totalIssue == nil) {
        _totalIssue = [[UILabel alloc] init];
        _totalIssue.backgroundColor = [UIColor clearColor];
        //        _startTime.text=@"--";
        _totalIssue.textColor = UIColorFromRGB(0x333333);
        _totalIssue.textAlignment = NSTextAlignmentLeft;
        _totalIssue.font = [UIFont systemFontOfSize:12.0];
    }
    return _totalIssue;
}
//已追期号
- (UILabel*)issued
{
    if (_issued == nil) {
        _issued = [[UILabel alloc] init];
        _issued.backgroundColor = [UIColor clearColor];
        _issued.textColor = UIColorFromRGB(0x333333);
        _issued.textAlignment = NSTextAlignmentLeft;
        _issued.font = [UIFont systemFontOfSize:12.0];
    }
    return _issued;
}
//发起时间
- (UILabel*)startTime
{
    if (_startTime == nil) {
        _startTime = [[UILabel alloc] init];
        _startTime.backgroundColor = [UIColor clearColor];
        _startTime.textColor = UIColorFromRGB(0x333333);
        _startTime.textAlignment = NSTextAlignmentLeft;
        _startTime.font = [UIFont systemFontOfSize:12.0];
    }
    return _startTime;
}
//追号状态
- (UILabel*)currentState
{
    if (_currentState == nil) {
        _currentState = [[UILabel alloc] init];
        _currentState.backgroundColor = [UIColor clearColor];
        _currentState.textColor = UIColorFromRGB(0x333333);
        _currentState.textAlignment = NSTextAlignmentLeft;
        _currentState.lineBreakMode = NSLineBreakByWordWrapping;
        _currentState.font = [UIFont systemFontOfSize:12.0];
    }
    return _currentState;
}
//继续追号
- (UIButton*)gotobutton
{
    if (_gotobutton == nil) {
        _gotobutton = [[UIButton alloc] init];
        _gotobutton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_gotobutton setTitle:@"继续追号" forState:UIControlStateNormal];
        [_gotobutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gotobutton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _gotobutton.layer.cornerRadius = 5;
        [_gotobutton addTarget:self action:@selector(pvt_continue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotobutton;
}
//重新选号
- (UIButton*)selectedButton
{
    if (_selectedButton == nil) {
        _selectedButton = [[UIButton alloc] init];
        _selectedButton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_selectedButton setTitle:@"重新选号" forState:UIControlStateNormal];
        [_selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _selectedButton.layer.cornerRadius = 5;
        [_selectedButton addTarget:self action:@selector(pvt_selected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}
//立即投注
- (UIButton*)payButton
{
    if (_payButton == nil) {
        _payButton = [[UIButton alloc] init];
        _payButton.backgroundColor = UIColorFromRGB(0xd34b48);
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _payButton.layer.cornerRadius = 5;
        [_payButton addTarget:self action:@selector(pvt_payMoney) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}
//停止追号
- (UIButton*)stopChaseButton
{
    if (_stopChaseButton == nil) {
        _stopChaseButton = [[UIButton alloc] init];
        _stopChaseButton.backgroundColor = [UIColor clearColor];
        [_stopChaseButton setTitle:@"停止追号" forState:UIControlStateNormal];
        [_stopChaseButton setTitleColor:UIColorFromRGB(0x0977d4) forState:UIControlStateNormal];
        _stopChaseButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _stopChaseButton;
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

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat sectionHeaderHeight = (IsGameTypeJc(self.gameType) || IsGameTypeLc(self.gameType)) ? 70 : 40;
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
