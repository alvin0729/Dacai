//
//  DPChaseNumberCenterVC.m
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPBuyTicketCell.h"
#import "DPChaseNumberCell.h"
#import "DPChaseNumberCenterViewController.h"
#import "DPLTDltViewController.h"
#import "DPTChaseNumberCenterInfoViewController.h"
#import "DPUAItemsScrollView.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "SVPullToRefresh.h"
//data
#import "ChaseCenter.pbobjc.h"
typedef enum {
    topRefreshType,
    downRefreshType,
} refreshType;

@interface DPChaseNumberCenterViewController () <UITableViewDataSource, UITableViewDelegate>
//======================================view
/**
 *  contentView
 */
@property (nonatomic, strong) DPUAItemsScrollView* contentView;
//======================================data
/**
 *  请求参数
 */
@property (nonatomic, strong) NSMutableDictionary* param;
@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy) NSString *pi;
@property (nonatomic, copy) NSString *ps;
/**
 *  刷新类型：上拉刷新还是下拉刷新
 */
@property (nonatomic, assign) refreshType refresh;

/**
 *  进行中
 */
@property (nonatomic, strong) NSMutableArray *runArray;

/**
 *  待支付
 */
@property (nonatomic, strong) NSMutableArray *noPayArray;
/**
 *  已结束
 */
@property (nonatomic, strong) NSMutableArray *finishArray;
/**
 *  进行中索引
 */
@property (nonatomic, copy) NSString *runIndex;

/**
 *  待支付索引
 */
@property (nonatomic, copy) NSString *noPayIndex;
/**
 *  已结束索引
 */
@property (nonatomic, copy) NSString *finishIndex;
/**
 *  表数据
 */
@property (nonatomic, strong) NSMutableArray *tableData;
/**
 *  购彩记录
 */
@property (nonatomic, strong) PBMChaseCenterList *lotteryHistoryInfo;
@end

@implementation DPChaseNumberCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"追号中心";
    [self.view addSubview:self.contentView];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self initilizerData];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentView.selectIndex = self.index - 1;
}

#pragma mark---------data
- (void)initilizerData
{
    _userId = @"", _pi = @"1", _ps = @"20";
    self.runIndex = @"1";
    self.noPayIndex = @"1";
    self.finishIndex = @"1";
    self.param = [NSMutableDictionary dictionary];
    self.runArray = [NSMutableArray array];
    self.noPayArray = [NSMutableArray array];
    self.finishArray = [NSMutableArray array];
    self.index = 1;
}
//请求追号数据
- (void)requestData
{
    [self showHUD];

    [self.param setValue:[NSString stringWithFormat:@"%d", self.index] forKey:@"type"];//当前请求那一列
    [self.param setValue:self.pi forKey:@"pi"];
    [self.param setValue:self.ps forKey:@"ps"];

    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/account/FollowRecords"
        parameters:self.param
        success:^(NSURLSessionDataTask* task, id responseObject) {

            @strongify(self);
            [self dismissHUD];
            PBMChaseCenterList* chaseInfo = [PBMChaseCenterList parseFromData:responseObject error:nil];

            if (self.refresh == topRefreshType)//下拉刷新
            {
                self.lotteryHistoryInfo = chaseInfo;
            }
            else {

                [self.lotteryHistoryInfo.chaseCenterItemsArray addObjectsFromArray:chaseInfo.chaseCenterItemsArray];//上拉加载
            }

            switch (self.index) {
            case DPChaseNumberIndexTypeRuning://进行中
                self.runArray = self.lotteryHistoryInfo.chaseCenterItemsArray;
                break;
            case DPChaseNumberIndexTypeUnPay://待支付
                self.noPayArray = self.lotteryHistoryInfo.chaseCenterItemsArray;
                break;
            case DPChaseNumberIndexTypeFinished://已完成
                self.finishArray = self.lotteryHistoryInfo.chaseCenterItemsArray;
                break;
            default:
                break;
            }

            UITableView* table = (UITableView*)[self.contentView viewWithTag:300 + self.index];
            table.emptyDataView.requestSuccess = YES;
            [table.pullToRefreshView stopAnimating];
            [table.infiniteScrollingView stopAnimating];
            table.infiniteScrollingView.enabled = self.lotteryHistoryInfo.chaseCenterItemsArray.count < chaseInfo.totalItemCount;
            table.showsInfiniteScrolling = table.contentSize.height > table.frame.size.height;
            [table reloadData];

        }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [self dismissHUD];
            UITableView* table = (UITableView*)[self.contentView viewWithTag:300 + self.index];
            [table.pullToRefreshView stopAnimating];
            [table.infiniteScrollingView stopAnimating];
            table.infiniteScrollingView.enabled = NO;
            table.showsInfiniteScrolling = NO;
            table.emptyDataView.requestSuccess = NO;
            [table reloadData];

        }];
};
//更新数据源
- (NSMutableArray*)tableData
{
    switch (self.index) {
    case DPChaseNumberIndexTypeRuning:
        _tableData = self.runArray;
        break;
    case DPChaseNumberIndexTypeUnPay:
        _tableData = self.noPayArray;
        break;
    case DPChaseNumberIndexTypeFinished:
        _tableData = self.finishArray;
        break;
    default:
        break;
    }
    return _tableData;
}
//获取当前列请求的页面数
- (NSString*)pi
{
    switch (self.index) {
    case DPChaseNumberIndexTypeRuning:
        _pi = self.runIndex;
        break;
    case DPChaseNumberIndexTypeUnPay:
        _pi = self.noPayIndex;
        break;
    case DPChaseNumberIndexTypeFinished:
        _pi = self.finishIndex;
        break;
    default:
        break;
    }
    return _pi;
}
#pragma mark---------contentView
//ui
- (DPUAItemsScrollView*)contentView
{
    if (!_contentView) {
        _contentView = [[DPUAItemsScrollView alloc] initWithFrame:self.view.frame andItems:@[ @"进行中", @"待支付", @"已结束" ]];
        _contentView.btnsView.backgroundColor = UIColorFromRGB(0xfefdfb);
        _contentView.btnsView.layer.borderWidth = 0;
        _contentView.btnViewHeight.mas_equalTo(36);
        _contentView.indirectorWidth = 50;
        //没有追号数据的时候显示
        NSMutableAttributedString* textNoData = [[NSMutableAttributedString alloc] initWithString:@"权威统计90%的中奖方案 \n都来自于追号"];
        [textNoData addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, textNoData.length)];
        [textNoData addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xd70000) range:NSMakeRange(4, 3)];

        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton* btn = (UIButton*)_contentView.btnArray[i];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }

        for (NSInteger i = 0; i < self.contentView.viewArray.count; i++) {
            UIView* view = self.contentView.viewArray[i];
            UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.backgroundColor = [UIColor clearColor];
            table.delegate = self;
            table.dataSource = self;
            table.tag = 300 + i + 1;
            table.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
            table.emptyDataView = [DZNEmptyDataView emptyDataView];
            table.emptyDataView.buttonTitleForNoData = @"去追号";
            table.emptyDataView.attrTextForNoData = textNoData;
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];

            //1,空页面
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type) {
                @strongify(self);
                switch (type) {
                case DZNEmptyDataViewTypeNoData: {
                    DPLTDltViewController* vc = [[DPLTDltViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case DZNEmptyDataViewTypeFailure: {
                    [self requestData];
                } break;
                case DZNEmptyDataViewTypeNoNetwork: {
                    [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
                } break;
                default:
                    break;
                }
            };

            //btn点击
            _contentView.itemTappedBlock = ^(UIButton* btn) {
                @strongify(self);
                NSString* indexStr = [NSString stringWithFormat:@"%zd", btn.tag - 100 + 1];
                self.index = (DPChaseNumberIndexType)[indexStr integerValue];
                 UITableView* table = (UITableView*)[self.contentView viewWithTag:300 + self.index];
                switch (btn.tag) {
                case 100:
                    //                        self.type = @"1";
                    if (self.runArray.count > 0) {
                        [table reloadData];
                        return;
                    }
                    break;
                case 101:
                    //                        self.type = @"2";
                    if (self.noPayArray.count > 0) {
                        [table reloadData];
                        return;
                    }
                    break;
                case 102:
                    //                        self.type = @"3";
                    if (self.finishArray.count > 0) {
                        [table reloadData];
                        return;
                    }
                    break;
                default:
                    break;
                }
                self.refresh = topRefreshType;
                [self requestData];
            };

            //下拉刷新
            [table addPullToRefreshWithActionHandler:^{
                @strongify(self);
                self.refresh = topRefreshType;
                self.pi = @"1";
                self.runIndex = @"1";
                self.noPayIndex = @"1";
                self.finishIndex = @"1";
                [self requestData];
            }
                                            position:SVPullToRefreshPositionTop];

            //上拉加载
            [table addInfiniteScrollingWithActionHandler:^{
                @strongify(self);
                self.refresh = downRefreshType;
                self.pi = [NSString stringWithFormat:@"%zd", [self.pi integerValue] + 1];
                switch (self.index) {
                case DPChaseNumberIndexTypeRuning:
                    self.runIndex = [NSString stringWithFormat:@"%zd", [self.pi integerValue] + 1];
                    break;
                case DPChaseNumberIndexTypeUnPay:
                    self.noPayIndex = [NSString stringWithFormat:@"%zd", [self.pi integerValue] + 1];
                    break;
                case DPChaseNumberIndexTypeFinished:
                    self.finishIndex = [NSString stringWithFormat:@"%zd", [self.pi integerValue] + 1];
                    break;
                default:
                    break;
                }
                [self requestData];
            }];
        }
        UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xc8c7c3)];
        [_contentView.btnsView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.equalTo(@0.5);
        }];
    }
    return _contentView;
}
//datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    DPChaseNumberCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPChaseNumberCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.tableData.count <= indexPath.row) {
        return cell;
    }
    PBMChaseCenterItem* item = [self.tableData objectAtIndex:indexPath.row];
    switch (item.gameType) {
    case GameTypeDlt:
        cell.iconImageView.image = dp_AppRootImage(@"dlt.png");
        [cell lotteryNameLabelText:@"大乐透"];
        break;

    default:
        break;
    }
    [cell orderTimeLabelText:[NSDate dp_coverDateString:item.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm]];
    [cell chaseInfoLabeltext:[NSString stringWithFormat:@"已共追%d期，已追%d期", item.totalIssueCount, item.chasedIssueCount]];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row >= self.tableData.count) {
        return;
    }
    //跳转到追号详情
    PBMChaseCenterItem* item = [self.tableData objectAtIndex:indexPath.row];
    DPTChaseNumberCenterInfoViewController* controller = [[DPTChaseNumberCenterInfoViewController alloc] init];
    controller.ChaseCenterListItem = item;
    controller.gameType = item.gameType;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
