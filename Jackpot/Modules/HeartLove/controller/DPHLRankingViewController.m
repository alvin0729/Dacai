//
//  DPHLRankingViewController.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLRankingViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPLogOnViewController.h"
#import "DPHLExpertViewController.h"
#import "DPHLFansRankingCell.h"
#import "DPItemsScrollView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "DPHLRankingViewModel.h"
@interface DPHLRankingViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  内容容器
 */
@property (nonatomic, strong) DPItemsScrollView *contentView;
/**
 *  当前选择对应的索引
 */
@property (nonatomic, assign) NSInteger selectItem;
/**
 *  控制器对应的数据模型
 */
@property (nonatomic, strong) DPHLRankingViewModel *viewModel;
@end

@implementation DPHLRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人气排行榜";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.viewModel = [[DPHLRankingViewModel alloc]init];
    [self requestDataFromServer];
}
#pragma mark---------contentView
- (DPItemsScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[DPItemsScrollView alloc]initWithFrame:CGRectZero andItems:@[@"近7天排名",@"近30天排名",@"总排名"]];
        //设置选择项容器的属性
        _contentView.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];
        _contentView.btnViewHeight.mas_equalTo(37);
        _contentView.indirectorWidth = 77;
        //设置选择项属性
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton *btn = _contentView.btnArray[i];
            [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
            [btn setTitleColor:UIColorFromRGB(0x7e6b5a) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i==0) {
                [_contentView btnTapped:btn];
            }
            if (i != _contentView.btnArray.count-1) {
                UIView *verLiner = [[UIView alloc]init];
                verLiner.backgroundColor = UIColorFromRGB(0xd0cfcd);
                [_contentView.btnsView addSubview:verLiner];
                [verLiner mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(6);
                    make.left.equalTo(btn.mas_right);
                    make.bottom.mas_equalTo(-6);
                    make.width.mas_equalTo(0.5);
                }];
            }
        }
        @weakify(self);
        //选择项点击
        _contentView.itemTappedBlock = ^(UIButton *btn){
            @strongify(self);
            self.selectItem = btn.tag - 100;//self.selectItem == @"近7天排名"==0,@"近30天排名"==1,@"总排名"==2]
            if (self.selectItem == 1&&self.viewModel.monthRankingArray.count==0 ) {
                [self requestDataFromServer];
            }else  if (self.selectItem == 2&&self.viewModel.totalRankingArray.count==0 ) {
                [self requestDataFromServer];
            }
            
            UITableView *table = [self.contentView.tablesView viewWithTag:300+self.selectItem];
            [table reloadData];
        };
        
        //为选择项容器添加对应的表单
        for (NSInteger i = 0; i < _contentView.viewArray.count; i++) {
            UIView *view = _contentView.viewArray[i];
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.separatorColor = UIColorFromRGB(0xd0cfcd);
            table.emptyDataView = [self creatEmptyView];
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.sectionIndexBackgroundColor = [UIColor clearColor];
            table.tag = 300+i;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.tableFooterView = [[UIView alloc]init];
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
            headerView.backgroundColor = [UIColor clearColor];
            table.tableHeaderView = headerView;
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            //空视图
            @weakify(self);
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                @strongify(self);
                switch (type) {
                    case DZNEmptyDataViewTypeNoData:
                    {
                        [self requestDataFromServer];
                    }
                        break;
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
            //下拉刷新
            [table addPullToRefreshWithActionHandler:^{
                @strongify(self);
                [self requestDataFromServer];
            }];
        }
    }
    return _contentView;
}
//emptyView
- (DZNEmptyDataView *)creatEmptyView{
    DZNEmptyDataView * emptyView = [DZNEmptyDataView emptyDataView];
    emptyView.showButtonForNoData = NO;
    emptyView.imageForNoData = dp_AccountImage(@"UANodataIcon.png");
    emptyView.textForNoData = @"暂无数据";
    return emptyView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectItem==0?self.viewModel.weekRankingArray.count:(self.selectItem == 1?self.viewModel.monthRankingArray.count:self.viewModel.totalRankingArray.count);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLFansRankingCell *cell = [[DPHLFansRankingCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    DPHLObject *object =self.selectItem==0?self.viewModel.weekRankingArray[indexPath.row]:(self.selectItem == 1?self.viewModel.monthRankingArray[indexPath.row]:self.viewModel.totalRankingArray[indexPath.row]);
    cell.object = object;
    @weakify(self);
    //关注点击：先判断是否登录
    cell.focusBtnTapped = ^(DPHLObject *object){
        @strongify(self);
        if (![DPMemberManager sharedInstance].isLogin) {
            UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }

        if (object.isSelect) {
            @weakify(self);
            EditAttention *param = [[EditAttention alloc]init];
            param.userId = object.userId;
            [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CancelAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self dismissHUD];
                [[DPToast makeText:@"取消关注成功"]show];
                [self requestDataFromServer]; 
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self dismissHUD];
                [[DPToast makeText:[error dp_errorMessage]]show];
            }];
        }else{
            @weakify(self);
            EditAttention *param = [[EditAttention alloc]init];
            param.userId = object.userId;
            [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/SetAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                [self dismissHUD];
                 [[DPToast makeText:@"关注成功"]show];
                [self requestDataFromServer];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                [self dismissHUD];
                [[DPToast makeText:[error dp_errorMessage]]show];
            }];
        }
    };
    //整行点击-》专家详情
    cell.cellTapped = ^(NSIndexPath *indexPath){
        DPHLObject *object =self.selectItem==0?self.viewModel.weekRankingArray[indexPath.row]:(self.selectItem == 1?self.viewModel.monthRankingArray[indexPath.row]:self.viewModel.totalRankingArray[indexPath.row]);
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc] init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    cell.rankingLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    cell.rankingBgImage.image = dp_HeartLoveImage(indexPath.row<3?@"HLRankingfront.png":@"HLRankingBack.png");
    return cell;
}

#pragma mark---------data
- (void)requestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/FansRanking?type=%zd",self.selectItem] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        UITableView *table = [self.contentView.tablesView viewWithTag:300+self.selectItem];
        switch (self.selectItem) {
            case 0://@"近7天排名"
            {
                [self.viewModel.weekRankingArray removeAllObjects];
                self.viewModel.weekFansRanking = [FansRanking parseFromData:responseObject error:nil];
            }
                break;
            case 1://,@"近30天排名"
            {
                [self.viewModel.monthRankingArray removeAllObjects];
                self.viewModel.monthFansRanking = [FansRanking parseFromData:responseObject error:nil];
            }
                break;
            case 2://,@"总排名"
            {
                [self.viewModel.totalRankingArray removeAllObjects];
                self.viewModel.totalFansRanking = [FansRanking parseFromData:responseObject error:nil];
            }
                break;
            default:
                break;
        }
        [table.pullToRefreshView stopAnimating];
        table.emptyDataView.requestSuccess = YES;
        [table reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        UITableView *table = [self.contentView.tablesView viewWithTag:300+self.selectItem];
        [table.pullToRefreshView stopAnimating];
        table.emptyDataView.requestSuccess = NO;
        [table reloadData];
    }];
}
@end
