//
//  DPHLHomeViewController.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLHomeViewController.h"
#import "DPHLRankingViewController.h"
#import "DPHLUserCenterViewController.h"
#import "DPHLHotMatchViewController.h"
#import "DPHLHeartLoveDetailViewController.h"
#import "DPHLMakeMoneyRankingViewController.h"
#import "DPHLExpertViewController.h"
#import "DPAlterViewController.h"
#import "DPLogOnViewController.h"
#import "DPHLOrderViewController.h"
#import "DPPayRedPacketViewController.h"
#import "DPOpenBetServiceController.h"
//=========================view
#import "DPItemsScrollView.h"
#import "DPHLItemCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
//=========================data
#import "UIImageView+DPExtension.h"
#import "DPHLHomeViewModel.h"
#import "Order.pbobjc.h"

@interface DPHLHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  控制器说明，控制器试图由userHeader和contentView组成
 */
//header
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *bottomBg;
@property (nonatomic, strong) UIImageView *headerBgImage;
@property (nonatomic, strong) UILabel *fansRankingValueLabel;
@property (nonatomic, strong) UILabel *winRankingValueLabel;
//content
@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, assign) NSInteger pi;
//data
@property (nonatomic, strong) WagesHome *homeData;
@property (nonatomic, strong) DPHLObject *headerObject;
@property (nonatomic, strong) DPHLHomeViewModel *viewModel;
@end

@implementation DPHLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  页面逻辑：首先加载UI，然后请求数据，数据请求成功后刷新页面
     */
    [self setupNav];
    [self setupUI];
    [self setupData];
}
/**
 *  初始化导航栏
 */
- (void)setupNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_HeartLoveImage(@"HLUserCenter.png") title:@"我的" target:self action:@selector(didRightItemTapped)];
}

- (void)didRightItemTapped{
    if ([DPMemberManager sharedInstance].isLogin) {
        [self.navigationController pushViewController:[[DPHLUserCenterViewController alloc]init] animated:YES];
        return;
    }
    DPLogOnViewController *controller = [[DPLogOnViewController alloc]init];
    @weakify(self);
    controller.finishBlock = ^{
        @strongify(self);
        [self.navigationController pushViewController:[[DPHLUserCenterViewController alloc]init] animated:YES];
    };
    UINavigationController *nav = [UINavigationController dp_controllerWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
/**
 *  初始化UI
 */
- (void)setupUI{
    self.title = @"心水交易";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(156);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark---------headerView
/**
 *  表头
 */
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        /**
         背景图
         */
        UIImageView *imageView = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLMatchBg.jpg")];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *HeaderTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapped:)];
        [imageView addGestureRecognizer:HeaderTapGesture];
        [_headerView addSubview:imageView];
        self.headerBgImage = imageView;
        
        /**
         底部阴影遮罩
         */
        UIView *bottomBg = [[UIView alloc]init];
        bottomBg.backgroundColor = [UIColor dp_flatBlackColor];
        bottomBg.alpha = 0.36;
        bottomBg.userInteractionEnabled = NO;
        [_headerView addSubview:bottomBg];
        self.bottomBg = bottomBg;
        
        /**
         *  人气排行
         */
        UILabel *fansRankingTitleLabel = [UILabel dp_labelWithText:@"人气排行 >" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter lineBreakMode:NSLineBreakByWordWrapping textColor:[UIColor dp_flatWhiteColor] font:[UIFont boldSystemFontOfSize:17]];
        [_headerView addSubview:fansRankingTitleLabel];
        
        self.fansRankingValueLabel = [UILabel dp_labelWithText:@"top1:--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        [_headerView addSubview:self.fansRankingValueLabel];
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor = UIColorFromRGB(0x666666);
        [_headerView addSubview:seperatorLine];
        /**
         *  赚钱排行
         */
        UILabel *winRankingTitleLabel = [UILabel dp_labelWithText:@"赚钱排行 >" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping textColor:[UIColor dp_flatWhiteColor] font:[UIFont boldSystemFontOfSize:17]];
        [_headerView addSubview:winRankingTitleLabel];
        
        self.winRankingValueLabel = [UILabel dp_labelWithText:@"top1:--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        [_headerView addSubview:self.winRankingValueLabel];
        
        
        /**
         *  header布局
         */
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView);
        }];
        
        [bottomBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(54);
        }];
        
        [fansRankingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBg.mas_top).offset(11);
            make.centerX.equalTo(_headerView.mas_centerX).offset(-kScreenWidth*0.25);
        }];
        
        [self.fansRankingValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fansRankingTitleLabel.mas_bottom).offset(4);
            make.centerX.equalTo(fansRankingTitleLabel.mas_centerX);
        }];
        
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48);
            make.centerX.equalTo(bottomBg.mas_centerX);
            make.bottom.mas_equalTo(-4);
            make.width.mas_equalTo(1);
        }];
        
        [winRankingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBg.mas_top).offset(11);
            make.centerX.equalTo(_headerView.mas_centerX).offset(kScreenWidth*0.25);
        }];
        
        [self.winRankingValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(winRankingTitleLabel.mas_bottom).offset(4);
            make.centerX.equalTo(winRankingTitleLabel.mas_centerX);
        }];
    }
    return _headerView;
}
/**
 *  重写表头数据set方法
 *
 *  @param headerObject 表头数据
 */
- (void)setHeaderObject:(DPHLObject *)headerObject{
    _headerObject = headerObject;
    [self.headerBgImage dp_setImageWithURL:_headerObject.iconName andPlaceholderImage:dp_HeartLoveImage(@"HLMatchBg.jpg")];
    self.fansRankingValueLabel.text = _headerObject.value;
    self.winRankingValueLabel.text = _headerObject.detail;
}
/**
 *  表头点击事件
 *
 *  @param gesture 点击表头手势
 */
- (void)headerTapped:(UITapGestureRecognizer *)gesture {
    CGPoint touchInHeaderPoint = [gesture locationInView:self.headerView];
    if (CGRectContainsPoint(self.bottomBg.frame, touchInHeaderPoint)) {
        //点击人气排行
        if (touchInHeaderPoint.x<kScreenWidth*0.5) {
            [self.navigationController pushViewController:[[DPHLRankingViewController alloc]init] animated:YES];
            return;
        }
        //点击赚钱排行
        [self.navigationController pushViewController:[[DPHLMakeMoneyRankingViewController alloc]init] animated:YES];
        return;
    }
    //点击比赛
    [self.navigationController pushViewController:[[DPHLHotMatchViewController alloc]init] animated:YES];
}
#pragma mark---------contentView
/**
 *  表内容
 */
- (UITableView *)contentView {
    if (!_contentView) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.separatorColor = UIColorFromRGB(0xd0cfcd);
        table.emptyDataView = [self creatEmptyView];
        table.backgroundColor = [UIColor dp_flatBackgroundColor];
        table.sectionIndexBackgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.tableFooterView = [[UIView alloc]init];
        
        _contentView = table;
        //下拉刷新
        @weakify(self);
        [table addPullToRefreshWithActionHandler:^{
            @strongify(self);
            self.pi = 1;
            [self requestDataFromServer];
        }];
      
        //上拉加载
        [table addInfiniteScrollingWithActionHandler:^{
            @strongify(self);
            self.pi ++;
            [self requestDataFromServer];
        }];

        //空视图
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
        table.showsInfiniteScrolling = NO;
        [table reloadData];
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
//table's delegate and datasourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.viewModel.tableData.count-1?0:10.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPHLItemCell *cell = [[DPHLItemCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    @weakify(self);
    //分享item 头像位置点击-》专家详情
    cell.iconBtnTappedBlock = ^(DPHLObject *object){
        @strongify(self);
        if(object.userId == [[DPMemberManager sharedInstance].userId integerValue]){
            [self didRightItemTapped];
            return;
        }
        
        DPHLExpertViewController *controller = [[DPHLExpertViewController alloc]init];
        controller.uid = object.userId;
        [self.navigationController pushViewController:controller animated:YES];
    };
    //分享item心水价格按钮点击->购买心水订单确认
    cell.heartLoveOrderBlock = ^(DPHLObject *object){
        @strongify(self);
        [self createHeartLoveOrderWithObject:object];
    };
    DPHLObject *object = self.viewModel.tableData[indexPath.section];
    cell.object = object;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //分享item整行点击-》分享详情
    DPHLObject *object = self.viewModel.tableData[indexPath.section];
    DPHLHeartLoveDetailViewController *controller = [[DPHLHeartLoveDetailViewController alloc]init];
    controller.wagesId = object.wagesId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark---------data
/**
 *  初始化数据
 */
- (void)setupData{
    self.pi = 1;
    self.viewModel = [[DPHLHomeViewModel alloc]init];
    [self requestDataFromServer];
}
/**
 *  请求网络数据
 */
- (void)requestDataFromServer {
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager]GET:[NSString stringWithFormat:@"/wages/home?pi=%zd&ps=20",self.pi] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        self.homeData = [WagesHome parseFromData:responseObject error:nil];
        if (self.pi == 1) {//self.pi == 1说明是下拉刷新或首次加载
            [self.viewModel.tableData removeAllObjects];
        }
        //给viewModel赋值
        self.viewModel.homeData = self.homeData;
        //给表头复试
        self.headerObject = self.viewModel.headerObject;
        //刷新表
        self.contentView.emptyDataView.requestSuccess = YES;
        [self.contentView.infiniteScrollingView stopAnimating];
        [self.contentView.pullToRefreshView stopAnimating];
        [self.contentView reloadData];
        self.contentView.showsInfiniteScrolling = self.contentView.contentSize.height>self.contentView.frame.size.height;
        self.contentView.infiniteScrollingView.enabled = self.viewModel.tableData.count<self.homeData.wagesCount;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]]show];
        self.contentView.emptyDataView.requestSuccess = NO;
        [self.contentView.infiniteScrollingView stopAnimating];
        [self.contentView.pullToRefreshView stopAnimating];
        [self.contentView reloadData];
        self.contentView.infiniteScrollingView.enabled = self.viewModel.tableData.count<self.homeData.wagesCount;
        self.contentView.showsInfiniteScrolling = self.contentView.contentSize.height>self.contentView.frame.size.height;
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
    
        [self showHUD];
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
                [self requestDataFromServer];
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
