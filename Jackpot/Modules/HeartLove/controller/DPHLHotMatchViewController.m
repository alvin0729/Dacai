//
//  DPHLHotMatchViewController.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHotMatchViewController.h"
#import "DPHLHotMatchDetailViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DPHLMatchItemCell.h"
//data
#import "Wages.pbobjc.h"
@interface DPHLHotMatchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTable;//表单
@property (nonatomic, strong) HotMatches *hotMatches;//服务端返回的数据
@end

@implementation DPHLHotMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞彩足球热门比赛";
    //ui
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //data
    [self requestDataFromServer];
}

- (UITableView *)contentTable{
    if (!_contentTable) {
        //表
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.separatorColor = UIColorFromRGB(0xd0cfcd);
        table.emptyDataView = [self creatEmptyView];
        table.backgroundColor = [UIColor clearColor];
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        headerView.backgroundColor = [UIColor clearColor];
        table.tableHeaderView = headerView;
        table.tableFooterView = [[UIView alloc]init];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self);
        [table addPullToRefreshWithActionHandler:^{
            @strongify(self);
            [self requestDataFromServer];
        }];
        _contentTable = table;
        
        //空页面
        table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
                case DZNEmptyDataViewTypeFailure:
                {
                    [self requestDataFromServer];
                }
                    break;
                case DZNEmptyDataViewTypeNoNetwork:
                {
                    [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
                }
                    break;
                default:
                    break;
            }
        };

    }
    return _contentTable;
}
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
//tableview's datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotMatches.matchesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLMatchItemCell *cell = [[DPHLMatchItemCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    Match *matchItem = self.hotMatches.matchesArray[indexPath.row];
    cell.object = [self transformMatchToHLObject:matchItem];//将服务端返回的数据模型转化为cell本身绑定的数据模型
    cell.upLine.hidden = !indexPath.row==0;
    cell.hotMatchIconlab.hidden = indexPath.row>=3;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到专家详情
    Match *matchItem = self.hotMatches.matchesArray[indexPath.row];
    DPHLHotMatchDetailViewController *controller = [[DPHLHotMatchDetailViewController alloc]init];
    controller.matchId = (long)matchItem.matchId;
    controller.gameTypeId = matchItem.gameTypeId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------data
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:@"/wages/HotMatches" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.hotMatches = [HotMatches parseFromData:responseObject error:nil];
        self.contentTable.emptyDataView.requestSuccess = YES;
        [self.contentTable.pullToRefreshView stopAnimating];
        [self.contentTable reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        self.contentTable.emptyDataView.requestSuccess = NO;
        [self.contentTable.pullToRefreshView stopAnimating];
        [self.contentTable reloadData];
    }];
}
- (DPHLObject *)transformMatchToHLObject:(Match *)matchItem{
    DPHLObject *object = [[DPHLObject alloc]init];
    object.title = matchItem.competitionName;
    object.subTitle = [NSString stringWithFormat:@"%zd",matchItem.wagesCount];
    object.value = matchItem.homeTeamIcon;
    object.subValue = matchItem.homeTeamName;
    object.detail = matchItem.awayTemaIcon;
    object.subDetail = matchItem.awayTemaName;
    object.matchTime = [NSString stringWithFormat:@"%@截止",[NSDate dp_coverDateString:matchItem.endDate fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm]];
    object.matchId = [NSString stringWithFormat:@"%zd",matchItem.matchId];
    return object;
}
@end
