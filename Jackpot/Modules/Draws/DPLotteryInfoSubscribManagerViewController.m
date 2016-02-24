//
//  DPLotteryInfoSubscribManagerViewController.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoSubscribManagerViewController.h"
#import "DPLotteryInfoSubscribDetailViewController.h"
#import "DPLotteryInfoSubscribCategoryCell.h"
#import "SVPullToRefresh.h"
#import "DZNEmptyDataView.h"
#import "DPWebViewController.h"
#import "DPLotteryInfoSubscribCell.h"

@interface DPLotteryInfoSubscribManagerViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) DZNEmptyDataView *emptyView;
@property (nonatomic, strong) NSMutableArray *tableData;
@end

@implementation DPLotteryInfoSubscribManagerViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.title = @"订阅管理";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
}

#pragma mark---------contentTable
//view
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTable.dataSource = self;
        _contentTable.delegate = self;
        _contentTable.tableFooterView = [[UIView alloc]init];
        _contentTable.emptyDataView = self.emptyView;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorColor = UIColorFromRGB(0xd0cfcd);
        _contentTable.sectionHeaderHeight = 12;
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
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPLotteryInfoSubscribCell *cell = [[DPLotteryInfoSubscribCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.tableData[indexPath.row];
    cell.btnBlock = ^(UIButton *btn){
        btn.selected = !btn.selected;
    };
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
            object.subTitle = @"订阅类别说明订阅类别说明订阅类别说明订阅类别";
            object.value = @"0";
            [_tableData addObject:object];
        }
    }
    return _tableData;
}

@end
