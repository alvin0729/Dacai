//
//  DPSpecifyInfoViewController.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSpecifyInfoViewController.h"
#import "DPLotteryInfoTableViewCell.h"
#import "SVPullToRefresh.h"
#import "DPLotteryInfoWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DPLotteryInfoViewModel.h"

@interface DPSpecifyInfoViewController () <DPLotteryInfoViewModelDelegate> {
    GameTypeId _gameType;
    NSString *_navTitle;
}

 @property (nonatomic, strong) DPLotteryInfoViewModel *viewModel;
@end

@implementation DPSpecifyInfoViewController
@dynamic navTitle;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor dp_flatBackgroundColor] ;
    self.tableView.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view;
    });
    
    DZNEmptyDataView *recomEmpty = [[DZNEmptyDataView alloc]init];
    recomEmpty.textForNoData = @"暂无数据" ;
    recomEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png") ;
    recomEmpty.showButtonForNoData = NO ;
    self.tableView.emptyDataView = recomEmpty ;

    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.viewModel fetch];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self.viewModel fetchMore];
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    [self showHUD];
     [self.viewModel fetch];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (DPLotteryInfoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    DPLotteryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DPLotteryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DPLotteryInfoViewModel *viewModel = self.viewModel;
    [cell setTitle:[viewModel titleAtIndex:indexPath.row]
          subTitle:[viewModel dateTextAtIndex:indexPath.row]
         urlString:[viewModel URLAtIndex:indexPath.row]
         indexPath:indexPath];
    [cell setGameType:(GameTypeId)[viewModel gameTypeAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoTableViewCell *cell = (DPLotteryInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[DPToast sharedToast] dismiss];
    [self.navigationController pushViewController:({
                                   DPLotteryInfoWebViewController *viewController = [[DPLotteryInfoWebViewController alloc] initWithGameType:cell.gameType];
                                   viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:cell.urlString]];
                                   viewController.title = @"资讯详情";
                                   viewController.canHighlight = NO;
                                   viewController;
                               })animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPLotteryInfoViewModel *viewModel = self.viewModel;
    NSString *headTitle = [viewModel titleAtIndex:indexPath.row];
    CGSize size = [NSString dpsizeWithSting:headTitle andFont:[UIFont dp_systemFontOfSize:kInfoTableViewCellTitleFont] andMaxWidth:300];
    DPLog(@"size height = %f", size.height);
    return size.height + kInfoTabelViewCellHeightDelta;
}

#pragma mark - Delegate
#pragma mark - DPLotteryInfoViewModelDelegate
- (void)viewModel:(DPLotteryInfoViewModel *)viewModel fetchFinished:(NSError *)error {
  
    @weakify(self) ;
     self.tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
        if (type == DZNEmptyDataViewTypeNoNetwork) {
            @strongify(self) ;
            [self.navigationController pushViewController:[DPWebViewController setNetWebController ] animated:YES];
        }else if (type == DZNEmptyDataViewTypeFailure) {
            @strongify(self) ;
            [self showHUD];
            [self.viewModel fetch];
         }
        
    } ;
    self.tableView.emptyDataView.requestSuccess = error == nil;

    
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView setShowsInfiniteScrolling:viewModel.count];
    [self.tableView.infiniteScrollingView setEnabled:viewModel.hasMore];
    
    [self dismissHUD];
}

#pragma mark - getter和setter

- (NSString *)navTitle {
    return _navTitle;
}

- (void)setNavTitle:(NSString *)navTitle {
    if (navTitle != nil && navTitle.length > 0) {
        self.title = navTitle;
        _navTitle = navTitle;
    }
}

#pragma mark - 数据加载代理方法

- (DPLotteryInfoViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DPLotteryInfoViewModel alloc] init];
        _viewModel.url = [NSString stringWithFormat:@"/news/getnews?type=%d", (int)self.gameType];
        _viewModel.delegate = self;
    }
    return _viewModel;
}


@end
