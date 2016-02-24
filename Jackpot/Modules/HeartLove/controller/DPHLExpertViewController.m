//
//  DPHLExpertViewController.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLExpertViewController.h"
#import "DPHLHeartLoveDetailViewController.h"
#import "DPHLOrderViewController.h"
#import "DPLogOnViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPOpenBetServiceController.h"

#import "DPHLUserHeaderView.h"
#import "DPItemsScrollView.h"
#import "DPHLItemCell.h"
#import "DPHLExpertCell.h"
#import "DPHLFocusCell.h"
#import "DPHLUserHeartLoveCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//data
#import "DPHLExperterViewModel.h"
#import "Order.pbobjc.h"
@interface DPHLExpertViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  表头
 */
@property (nonatomic, strong) DPHLUserHeaderView *headerView;
/**
 *  选择容器
 */
@property (nonatomic, strong) DPItemsScrollView *contentView;
/**
 *  当前选择索引
 */
@property (nonatomic, assign) NSInteger selectItem;
/**
 *  专家详情对应的viewModel
 */
@property (nonatomic, strong) DPHLExperterViewModel *viewModel;
/**
 *  下拉刷新和上拉加载索引
 */
@property (nonatomic, assign) NSInteger pi;
/**
 *  最近心水索引
 */
@property (nonatomic, assign) NSInteger nowPi;
/**
 *  历史心水索引
 */
@property (nonatomic, assign) NSInteger historyPi;
@end

@implementation DPHLExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
 
}
/**
 *  初始化UI
 */
- (void)setupUI{
    
    self.title = @"专家详情";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    /**
     表头
     */
    self.headerView = [[DPHLUserHeaderView alloc]initWithFrame:CGRectZero];
    [self.headerView.focusBtn addTarget:self action:@selector(focusBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.penImage.hidden = YES;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(177.5);
    }];
    
    /**
     *  心水选择容器
     */
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
/**
 *  点击关注和取消关注
 */
- (void)focusBtnTapped{
    if (![DPMemberManager sharedInstance].isLogin) {
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:[[DPLogOnViewController alloc]init]];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if (self.headerView.object.isSelect) {//取消关注
        @weakify(self);
        EditAttention *param = [[EditAttention alloc]init];
        param.userId = self.uid;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CancelAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:@"取消关注成功"]show];
            [self requrestDataFromServer];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    }else{//关注
        @weakify(self);
        EditAttention *param = [[EditAttention alloc]init];
        param.userId = self.uid;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/SetAttention" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:@"关注成功"]show];
            [self requrestDataFromServer];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    }
}
#pragma mark---------contentView
- (DPItemsScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[DPItemsScrollView alloc]initWithFrame:CGRectZero andItems:@[@"最近心水",@"历史心水"]];
        //初始化选择项容器
        _contentView.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];
        _contentView.btnViewHeight.mas_equalTo(45);
        _contentView.indirectorWidth = 108;
        //初始化选择项属性
        for (NSInteger i = 0; i < _contentView.btnArray.count; i++) {
            UIButton *btn = _contentView.btnArray[i];
            [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
            [btn setTitleColor:UIColorFromRGB(0x7e6b5a) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
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
            self.selectItem = btn.tag - 100;
            if (self.selectItem == 0 && self.viewModel.myWagesArray.count>0) {
                return ;
            }
            if (self.selectItem == 1 && self.viewModel.historyWagesArray.count>0) {
                return ;
            }
            [self requrestDataFromServer];
        };
        
        //选择项对应的容器中添加心水表单
        for (NSInteger i = 0; i < _contentView.viewArray.count; i++) {
            UIView *view = _contentView.viewArray[i];
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.emptyDataView = [self creatEmptyView];
            table.backgroundColor = [UIColor dp_flatBackgroundColor];
            table.sectionIndexBackgroundColor = [UIColor clearColor];
            table.tag = 300+i;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
            [view addSubview:table];
            [table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            table.showsInfiniteScrolling = NO;
            [table reloadData];
            @weakify(self);
            //空白页面
            table.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
                @strongify(self);
                switch (type) {
                    case DZNEmptyDataViewTypeNoData:
                    {
                        [self requrestDataFromServer];
                    }
                        break;
                    case DZNEmptyDataViewTypeFailure:
                    {
                        [self requrestDataFromServer];
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
                self.nowPi = 1;
                self.historyPi = 1;
                [self requrestDataFromServer];
            }];
            //上拉加载
            [table addInfiniteScrollingWithActionHandler:^{
                @strongify(self);
                if (self.selectItem ==0 ) {
                    self.nowPi ++;
                }else if (self.selectItem == 1){
                    self.historyPi ++;
                }
                [self requrestDataFromServer];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectItem == 0?self.viewModel.myWages.wagesItemsArray.count:self.viewModel.historyWagesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLObject *nowObject = indexPath.row<self.viewModel.myWagesArray.count?self.viewModel.myWagesArray[indexPath.row]:[[DPHLObject alloc] init];
    switch (self.selectItem) {
        case 0:
            return nowObject.isFree?98:114;
            break;
        case 1:
            return 98;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.selectItem == 1) {//最近心水
        DPHLUserHeartLoveCell *cell = [[DPHLUserHeartLoveCell alloc]initWithTableView:tableView atIndexPath:indexPath];
        cell.object = self.viewModel.historyWagesArray[indexPath.row];
        cell.upLine.hidden = indexPath.row!=0;
        return cell;
    }
  
    DPHLObject *nowObject = indexPath.row<self.viewModel.myWagesArray.count?self.viewModel.myWagesArray[indexPath.row]:[[DPHLObject alloc] init];
    if (nowObject.isFree) {
        DPHLUserHeartLoveCell *cell = [[DPHLUserHeartLoveCell alloc]initWithTableView:tableView atIndexPath:indexPath];
        cell.object = nowObject;
        cell.upLine.hidden = indexPath.row!=0;
        return cell;
    }
    //专家心水
    DPHLExpertCell *cell = [[DPHLExpertCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    @weakify(self);
    cell.heartLoveOrderBlock = ^(DPHLObject *object){
        @strongify(self);
        [self createHeartLoveOrderWithObject:object];
    };
    cell.object = nowObject;
    cell.upLine.hidden = indexPath.row!=0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到心水详情
    DPHLObject *object = self.selectItem == 1?self.viewModel.historyWagesArray[indexPath.row]:self.viewModel.myWagesArray[indexPath.row];
    DPHLHeartLoveDetailViewController *controller = [[DPHLHeartLoveDetailViewController alloc]init];
    controller.wagesId = object.wagesId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------data
//初始化数据
- (void)setupData{
    self.pi = 1;
    self.viewModel = [[DPHLExperterViewModel alloc]init];
    [self requrestDataFromServer];
}
//索引
- (NSInteger)pi{
    if (self.selectItem == 0) {
        return self.nowPi;
    }else if (self.selectItem ==1){
        return self.historyPi;
    }else{
        return 0;
    }
}
/**
 *  请求心水数据
 */
- (void)requrestDataFromServer{
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/ExpertWages?type=%zd&pi=%zd&ps=20&uid=%zd",self.selectItem+1,self.pi,self.uid] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        ExpertWages *expertWages = [ExpertWages parseFromData:responseObject error:nil];
        
        UITableView *table = [self.contentView.tablesView viewWithTag:300+self.selectItem];
        if (self.selectItem == 0) {//最近心水
            if (self.pi == 1) {
                [self.viewModel.myWagesArray removeAllObjects];
            }
            self.viewModel.myWages = expertWages;
            self.viewModel.headerObject.isSelect = self.viewModel.myWages.isFocused;
            table.infiniteScrollingView.enabled = self.viewModel.myWagesArray.count<expertWages.wagesCount;
        }else{//历史心水
            if (self.pi == 1) {
                [self.viewModel.historyWagesArray removeAllObjects];
            }
            
            self.viewModel.historyWages = expertWages;
            self.viewModel.headerObject.isSelect = self.viewModel.historyWages.isFocused;
            table.infiniteScrollingView.enabled = self.viewModel.historyWagesArray.count<expertWages.wagesCount;
        }
        self.headerView.object  = self.viewModel.headerObject;
        [table.pullToRefreshView stopAnimating];
        [table.infiniteScrollingView stopAnimating];
        table.emptyDataView.requestSuccess = YES;
        [table reloadData];
        table.showsInfiniteScrolling = table.contentSize.height>table.frame.size.height;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        UITableView *table = [self.contentView.tablesView viewWithTag:300+self.selectItem];
        [table.pullToRefreshView stopAnimating];
        table.emptyDataView.requestSuccess = NO;
        [table.infiniteScrollingView stopAnimating];
        [table reloadData];
    }];
}
/**
 *  创建订单:先判断是否登录，如果未登录跳转到登录页面，然后判断是否开通投注服务，未开通投注服务则跳转到投注服务，最后判断心水是否已截至
 *
 *  @param object 心水对象
 */
- (void)createHeartLoveOrderWithObject:(DPHLObject *)object{
    if(object.userId == [[DPMemberManager sharedInstance].userId integerValue]){
        [[DPToast makeText:@"不能购买自己的心水"]show];
        return;
    }
    
    //创建订单block
    void (^orderBlock)() = ^{
        //判断是否开通投注服务
        @weakify(self);
        if (![DPMemberManager sharedInstance].betOpen) {
            @strongify(self);
            DPOpenBetServiceController *controller = [[DPOpenBetServiceController alloc]init];
            controller.openBetBlock = ^(){
                orderBlock();
            };
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        NSDate *endDate = [NSDate dp_dateFromString:object.endDate withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        if ([[NSDate dp_date] compare:endDate]>0) {
            [[DPToast makeText:@"当前心水已截至"]show];
            return;;
        }
        
        PayWagesInput *param = [[PayWagesInput alloc]init];
        param.wagesId = object.wagesId;
        [[AFHTTPSessionManager dp_sharedManager]POST:@"/wages/CreateUnPayWages" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self dismissHUD];
            WagesUserInfo *userInfo = [WagesUserInfo parseFromData:responseObject error:nil];
            PBMCreateOrderResult *result = [[PBMCreateOrderResult alloc]init];
            result.orderId = object.wagesId;
            result.accountAmt = userInfo.amount;
            DPPayRedPacketViewController *controller = [[DPPayRedPacketViewController alloc]init];
            @weakify(self);
            controller.buyWagesSuccess = ^(){
                @strongify(self);
                [self requrestDataFromServer];
                [[DPToast makeText:@"购买心水成功"]show];
            };
            controller.orderType = HeartLoveOrderType;
            controller.projectMoney = [object.buyBtnStr intValue];
            controller.wagesUserName =  object.userNameLabelStr;
            controller.dataBase = result;
            [self.navigationController pushViewController:controller animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:[error dp_errorMessage]]show];
        }];
    };
    
    //判断是否登录
    if (![DPMemberManager sharedInstance].isLogin) {
        DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
        controller.finishBlock = ^(){
            //开通成功后->创建心水订单block
            orderBlock();
        };
        UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    orderBlock();
}
@end
