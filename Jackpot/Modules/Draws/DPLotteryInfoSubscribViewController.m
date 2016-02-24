//
//  DPLotteryInfoSubscribViewController.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoSubscribViewController.h"
#import "DPLotteryInfoSubscribManagerViewController.h"
#import "DPLotteryInfoSubscribDetailViewController.h"
//view
#import "DPLotteryInfoSubscribCategoryCell.h"
#import "SVPullToRefresh.h"
#import "DZNEmptyDataView.h"
#import "DPWebViewController.h"

@interface DPLotteryInfoSubscribViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) DZNEmptyDataView *emptyView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation DPLotteryInfoSubscribViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self requestDataFrowServer];
    
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark---------headerView
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
        _headerView.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        UIButton *moreSubscribBtn = [UIButton dp_buttonWithTitle:@"+ 添加更多咨询内容" titleColor:UIColorFromRGB(0x6b5847) backgroundColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18]];
        moreSubscribBtn.layer.cornerRadius = 5;
        moreSubscribBtn.layer.borderWidth = 0.5;
        moreSubscribBtn.layer.borderColor = UIColorFromRGB(0xccbeb1).CGColor;
        [[moreSubscribBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [self.navigationController pushViewController:[[DPLotteryInfoSubscribManagerViewController alloc]init] animated:YES];
        }];
        [_headerView addSubview:moreSubscribBtn];
        [moreSubscribBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(44);
        }];
        
        UIView *downLine = [[UIView alloc]init];
        downLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [_headerView addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return _headerView;
}
#pragma mark---------contentTable
//view
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTable.dataSource = self;
        _contentTable.delegate = self;
        _contentTable.tableFooterView = [[UIView alloc]init];
        _contentTable.emptyDataView = self.emptyView;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        downLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        _contentTable.tableFooterView = downLine;
    
    }
    return _contentTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPLotteryInfoSubscribCategoryCell *cell = [[DPLotteryInfoSubscribCategoryCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.tableData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.navigationController pushViewController:[[DPLotteryInfoSubscribDetailViewController alloc]init] animated:YES];
}
#pragma mark---------emptyView
- (void)requestDataFrowServer{
    [self showHUD];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissHUD];
        self.contentTable.emptyDataView.requestSuccess = YES;
        [self.contentTable reloadData];
    });
}

- (DZNEmptyDataView *)emptyView{
    if (!_emptyView) {
        _emptyView = [DZNEmptyDataView emptyDataView];
        _emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
        _emptyView.textForNoData = @"订阅您关心的事件";
        _emptyView.buttonTitleForNoData = @"去添加订阅";
        @weakify(self);
        _emptyView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
                {
                     [self.navigationController pushViewController:[[DPLotteryInfoSubscribManagerViewController alloc]init] animated:YES];
                }
                    break;
                case DZNEmptyDataViewTypeFailure:
                {
                    [self requestDataFrowServer];
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
    return _emptyView;
}
#pragma mark---------data
- (NSMutableArray *)tableData{
    if (!_tableData) {
        _tableData = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            DPLotteryInfoObject *object = [[DPLotteryInfoObject alloc]init];
            object.title = @"订阅类别";
            object.subTitle = @"订阅类别说明订阅类别说明订阅类别说明订阅类别说明订阅类别说明";
            object.value = @"刚刚";
            [_tableData addObject:object];
        }
    }
    return _tableData;
}

@end
