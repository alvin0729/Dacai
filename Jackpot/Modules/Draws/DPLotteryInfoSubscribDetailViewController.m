//
//  DPLotteryInfoSubscribDetailViewController.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoSubscribDetailViewController.h"
#import "DPLotteryInfoSubscribCategoryCell.h"
#import "SVPullToRefresh.h"
#import "DZNEmptyDataView.h"
#import "DPWebViewController.h"
#import "DPLotterySubscribInfosCell.h"

@interface DPLotteryInfoSubscribDetailViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) DZNEmptyDataView *emptyView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation DPLotteryInfoSubscribDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:self.isSubscrib?@"取消订阅":@"订阅" target:self action:@selector(didCancelSubscrib)];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
}

- (void)didCancelSubscrib{
    [self.navigationItem.rightBarButtonItem setTitle:self.isSubscrib?@"取消订阅成功":@"订阅成功"];
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
    return 77;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPLotterySubscribInfosCell *cell = [[DPLotterySubscribInfosCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.tableData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
            object.title = @"坚决答应脱贫攻坚战";
            object.subTitle = @"坚决答应脱贫攻坚战坚决答应脱贫攻坚战坚决答应脱贫攻坚战坚决答应脱贫攻坚";
            object.value = @"0";
            [_tableData addObject:object];
        }
    }
    return _tableData;
}

@end
