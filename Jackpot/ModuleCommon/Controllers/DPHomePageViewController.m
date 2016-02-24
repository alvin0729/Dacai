//
//  DPHomePageViewController.m
//  Jackpot
//
//  Created by sxf on 15/7/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPHomePageViewController+Layout.h"
#import "DPHomePageViewController.h"

#import "DPBuyHomeTableViewCell.h"
#import "DPImageLabel.h"

#import "AFImageDiskCache.h"
#import "DPWebViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"

#import "DPJcdgTableCells.h"
#import "DPJclqBuyViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPLTDltViewController.h"

#import "DPAnalyticsKit.h"
#import "DPDltBetData.h"
#import "DPHomeDateModel.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPPayRedPacketViewController.h"
#import "DPTimerCenter.h"
#import "Order.pbobjc.h"

#import "DPFlowSets.h"
#import "DPHomeBannerViewPage.h"
#import "DPHomePageViewModel.h"

#define kBannerDuration 5.0

static CGFloat const kTableHeaderHeight = 38;
static NSInteger const kBetMultiple = 10;
static NSString *const kBannerPageIdentifier = @"Page";

@interface DPHomePageViewController () <DPHomeBallViewCellDelegate> {
    BOOL _showQuickFirst;    // 是否先显示快速投注   0:快速投注  1：大家都在玩

    int _normalRed[DLTREDNUM];      //大乐透红色号码
    int _normalBlue[DLTBLUENUM];    //大乐透蓝色号码
    int _jcSelected[3];
    int _lcSelected[2];
    GameTypeId _selectedType;    //当前所选竞彩彩种类型
    BOOL _isUpdateJCData;        //是否更新竞彩数据

    BOOL _isInHomeViewController;    //是否在首页
    NSUInteger _timeCount;

    PBMHomePage *_homePage;    //首页数据

    BOOL _isJczqShow;    //快速投注是否展示竞彩足球
    BOOL _isJclqShow;    //快速投注是否展示竞彩篮球

    PBMHomePage_SportQuickBet *_zcLastBet;    //足球快速投注
    PBMHomePage_SportQuickBet *_lcLastBet;    //蓝球快速投注
}

@property (nonatomic, strong) DPHomePageViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *ballsArray;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation DPHomePageViewController
@synthesize tableView = _tableView;
@synthesize bannerView = _bannerView;
@synthesize recommendButton = _recommendButton;
@synthesize noticeLabel = _noticeLabel;
@synthesize effectView = _effectView;

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _viewModel = [[DPHomePageViewModel alloc] init];
        //保存当前付款上下文, 必须在 init 方法中调用
        [DPPaymentFlow pushContextWithViewController:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTimer:) name:kDPNumberTimerNotificationKey object:nil];
        _zcLastBet = [PBMHomePage_SportQuickBet message];
        _lcLastBet = [PBMHomePage_SportQuickBet message];
    }
    return self;
}

- (void)dealloc {
    //销毁当前付款上下文, 必须在 dealloc 方法方法中调用
    [DPPaymentFlow popContextWithViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDPNumberTimerNotificationKey object:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self setupViewConstraints];

    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.dp_shouldNavigationBarHidden = YES;
    self.ballsArray = [[NSMutableArray alloc] initWithCapacity:7];

    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self getDataFromeNet];
    }];

    [self getDataFromeNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.bannerView.autoMoving = YES;
    //倒计时
    [[DPTimerCenter defaultCenter] startWithControllerName:@"DPHomePageViewController"];

    _isInHomeViewController = YES;
    _timeCount = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.bannerView.autoMoving = NO;

    [[DPTimerCenter defaultCenter] stopWithControllerName:@"DPHomePageViewController"];

    _isInHomeViewController = NO;
    _timeCount = 0;
}

#pragma mark - Layout

- (void)setupProperty {
}

//视图搭建
- (void)setupViewConstraints {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self setupHeaderView];
    [self setupFooterView];
    [self.view addSubview:self.effectView];
    [self.noticeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_notice)]];
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

#pragma mark - Override

#pragma mark - User Interaction

// - (void)foobarButtonTapped;

#pragma mark - Delegate

#pragma mark - KTMBannerViewDelegate
//轮播图点击事件
- (void)bannerView:(KTMBannerView *)bannerView didTappedAtIndex:(NSInteger)index {
    if (index >= self.viewModel.numberOfBannerItem) {
        return;
    }
    DPBannerItemModel *item = [self.viewModel bannerItemModelAtIndex:index];
    if (!item.image) {
        return;
    }
    // 图片加载完成, 触发点击事件
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeHomeFirstAdv + index)] props:nil];
    [DPAppURLRoutes handleURL:[NSURL URLWithString:item.eventURL]];
}

#pragma mark - KTMBannerViewDataSource
//轮播图协议方法
//生成几个轮播图
- (NSInteger)numberOfPageInBannerView:(KTMBannerView *)bannerView {
    return MAX(1, self.viewModel.numberOfBannerItem);
}
//轮播图赋值
- (KTMBannerViewPage *)bannerView:(KTMBannerView *)bannerView pageAtIndex:(NSInteger)index {
    DPHomeBannerViewPage *page = [bannerView dequeueReusablePageWithIdentifier:kBannerPageIdentifier];
    UIImage *defaultImage = dp_CommonImage(@"努力加载.jpg");
    if (self.viewModel.numberOfBannerItem == 0) {
        page.imageView.image = defaultImage;
    } else {
        DPBannerItemModel *item = [self.viewModel bannerItemModelAtIndex:index];
        [self.viewModel requestImageIfNeeded:item];
        [[RACObserve(item, image) takeUntil:page.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            page.imageView.image = x ?: defaultImage;
        }];
    }
    return page;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断快速投注  和大家都在玩在哪个分区，由服务控制
    int xingyun = 2;
    int dajiawan = 1;
    if (_showQuickFirst) {    //这个是快速投注优先
        xingyun = 1;
        dajiawan = 2;
    }
    if (indexPath.section == dajiawan)    //所有彩种类型->大家都在玩
    {
        static NSString *CellIdentifier = @"selectedBallCell";
        DPLotteryInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPLotteryInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }

        PBMHomePage_LotteryItem *lotteryItem = nil;

        if (indexPath.row == 0) {
            [cell settitleLabel:@"大乐透"];
            cell.gameType = GameTypeDlt;
            [cell setlottteryImage:dp_AppRootImage(@"dlt.png")];
            lotteryItem = _homePage.lotteryDlt;
        }

        if (indexPath.row == 1) {
            [cell settitleLabel:@"竞彩足球"];
            cell.gameType = GameTypeJcNone;
            [cell setlottteryImage:dp_AppRootImage(@"jczq.png")];
            lotteryItem = _homePage.lotteryJczq;
        } else if (indexPath.row == 2) {
            [cell settitleLabel:@"竞彩篮球"];
            cell.gameType = GameTypeLcNone;
            [cell setlottteryImage:dp_AppRootImage(@"jclq.png")];
            lotteryItem = _homePage.lotteryJclq;
        }

        [cell setadvertiseLabel:lotteryItem.title];
        [cell setbonusMoneyLabel:lotteryItem.desc];
        [cell setMarkLabel:lotteryItem.mark];
        //        [cell setparticipantsLabel:[NSString stringWithFormat:@"参与人数：%d",
        //                                                              lotteryItem.count]];
        return cell;
    }
    if (indexPath.section == xingyun) {                              //快速投注
        if (indexPath.row == 0 && (_isJclqShow || _isJczqShow)) {    //快速投注 竞彩

            BOOL showJczqFirst = (_homePage.showJczqFirst || (!_isJclqShow)) && _isJczqShow;    //是否优先展示竞彩足球

            NSString *CellIdentifier = [NSString stringWithFormat:@"SelectedJCCell%d%d", (int)_isJclqShow, (int)_isJczqShow];
            DPSelectedJCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPSelectedJCViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.gameFirst = showJczqFirst;
                [cell setGameCount:(int)_isJczqShow + (int)_isJclqShow];
                cell.delegate = self;
            }
            //是否更新竞彩数据
            if (!_isUpdateJCData) {
                return cell;
            }

            if (_isJczqShow) {
                [cell updateHomeBuyJCData:_zcLastBet];
            }

            if (_isJclqShow) {
                [cell updateHomeBuyJCData:_lcLastBet];
            }

            _isUpdateJCData = NO;
            return cell;
        }

        //任选一注（大乐透）
        static NSString *CellIdentifier = @"LotteryCell";
        DPSelectedBallViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSelectedBallViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            //随机一注
            [self digitalDataRandom];
        }

        if (self.ballsArray.count != cell.balls.count) {
            return cell;
        }
        for (int i = 0; i < cell.balls.count; i++) {
            UIButton *button = [cell.balls objectAtIndex:i];
            [button setTitle:[self.ballsArray objectAtIndex:i] forState:UIControlStateNormal];
        }

        if (_homePage.lotteryDlt.enable) {
            [cell.payButton setTitle:@"投注" forState:UIControlStateNormal];
            [cell.payButton setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
            cell.payButton.backgroundColor = UIColorFromRGB(0xd44649);

        } else {
            [cell.payButton setTitle:@"停售" forState:UIControlStateNormal];
            [cell.payButton setTitleColor:UIColorFromRGB(0x999999)
                                 forState:UIControlStateNormal];
            cell.payButton.backgroundColor = UIColorFromRGB(0xc2c2c2);
        }

        cell.gameName = _homePage.quickDlt.gameName;
        cell.endTime = _homePage.quickDlt.endTime;

        return cell;
    }

    //社区
    static NSString *CellIdentifier = @"communityCell";
    DPCommunityViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPCommunityViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    for (int i = 0; i < 3; i++) {
        DPHomeLinkItemModel *itemModel = [self.viewModel linkItemModelAtIndex:i];
        UIImageView *imageView = [cell imageViewForIndex:i];
        UILabel *label = [cell labelForIndex:i];

        [[RACObserve(itemModel, image) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            imageView.image = x;
        }];
        label.text = itemModel.title;
        [self.viewModel requestImageIfNeeded:itemModel];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 105;
    }
    int xingyun = 2;
    if (_showQuickFirst) {
        xingyun = 1;
    }
    if (indexPath.section == xingyun) {
        if (indexPath.row == 0 && (_isJczqShow || _isJclqShow)) {
            return 218;
        }
        return 80;
    }
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? kTableHeaderHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    NSArray *array = !_showQuickFirst ? [NSArray arrayWithObjects:@"大家都在玩", @"快速投注", nil] : [NSArray arrayWithObjects:@"快速投注", @"大家都在玩", nil];
    UIView *view = [UIView dp_viewWithColor:[UIColor dp_flatBackgroundColor]];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = [array objectAtIndex:section - 1];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.right.equalTo(view);
        make.height.equalTo(@25);

    }];
    UIView *line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
    UIView *line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
    [view addSubview:line1];
    [view addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    return view;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return !_showQuickFirst ? 3 : (_isJclqShow || _isJczqShow) ? 2 : 1;
    }
    if (section == 2) {
        return !_showQuickFirst ? ((_isJclqShow || _isJczqShow) ? 2 : 1) : 3;
    }
    return 1;
}

#pragma mark - Properties (getter, setter)

#pragma mark -获取网络数据
- (void)getDataFromeNet {
    if (self.task) {
        return;
    }
    self.task = [[AFHTTPSessionManager dp_sharedManager] GET:@"home/buy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            _homePage = [PBMHomePage parseFromData:responseObject error:nil];

            [self.viewModel parser:_homePage];

            // 重载数据
            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];

            [self reloadHome];
            self.task = nil;
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissHUD];
            DPLog(@"error === %@", error);
            [self.tableView.pullToRefreshView stopAnimating];
            [[DPToast makeText:error.dp_errorMessage] show];
            self.task = nil;
        }];
}

//测试
- (void)pvt_onTestWebView {
#ifdef DEBUG

    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.dp_shouldNavigationBarHidden = NO;
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    viewController.view.backgroundColor = [UIColor dp_flatBackgroundColor];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth, 100);
    [viewController.view addSubview:scrollView];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 50)];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 20)];
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor yellowColor];
    view3.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:view1];
    [scrollView addSubview:view2];
    [scrollView addSubview:view3];

    [scrollView ktm_addPullToRefreshWithHandler:^{
        NSLog(@"tirgger");
    }];

    [self.navigationController pushViewController:viewController animated:YES];

    return;
//    DPWebViewController *controller = [[DPWebViewController alloc] init];
//    controller.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.12.2.37:99/Web/Help/Buy"]];
//    UITabBarController *tabBarController = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
//    UINavigationController *nav = tabBarController.selectedViewController;
//    [nav pushViewController:controller animated:YES];
#endif
}

#pragma mark -tableView dataSource and delegate
//产生随机一注
- (void)digitalDataRandom {
    memset(_normalRed, 0, sizeof(_normalRed));
    memset(_normalBlue, 0, sizeof(_normalBlue));
    [self.ballsArray removeAllObjects];

    int red[DLTREDNUM] = {0};

    [self partRandom:5 total:DLTREDNUM target2:red];
    for (int i = 0; i < DLTREDNUM; i++) {
        _normalRed[i] = red[i];

        if (_normalRed[i] == 1) {
            [self.ballsArray addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }
    }

    int blue[DLTBLUENUM] = {0};
    [self partRandom:2 total:DLTBLUENUM target2:blue];
    for (int i = 0; i < DLTBLUENUM; i++) {
        _normalBlue[i] = blue[i];
        if (_normalBlue[i] == 1) {
            [self.ballsArray addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }
    }
}
// 产生随机数
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0 ? 1 : (total - i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}

#pragma mark -DPHomeBuyJCViewDelegate

//竞彩足球，篮球
//点击比赛选项

- (void)jcSelectedView:(DPHomeBuyJCView *)view
            isSelected:(BOOL)isSelected
                 index:(NSInteger)index
              gameType:(GameTypeId)gameType
           isUserTouch:(BOOL)isTouched {
    PBMHomePage_SportQuickBet *sportQuick;
    float maxBonus, minBonus;

    if (IsGameTypeLc(gameType)) {
        sportQuick = _lcLastBet;    // _homePage.quickJclq;
        if (isTouched) {
            [sportQuick updateSelectStatusWithGmaeType:GameTypeLcNone index:index select:isSelected];
        }
        [sportQuick getMinBounds:&minBonus maxBouns:&maxBonus gameType:GameTypeLcNone];
    } else {
        sportQuick = _zcLastBet;    // _homePage.quickJczq;
        if (isTouched) {
            [sportQuick updateSelectStatusWithGmaeType:GameTypeJcNone index:index select:isSelected];
        }
        [sportQuick getMinBounds:&minBonus maxBouns:&maxBonus gameType:GameTypeJcNone];
    }

    NSString *bonusString = @"";
    if (maxBonus == minBonus) {
        bonusString =
            [NSString stringWithFormat:@"%.2f", minBonus * kBetMultiple];
    } else {
        bonusString =
            [NSString stringWithFormat:@"%.2f-%.2f", minBonus * 10,
                                       maxBonus * kBetMultiple];
    }
    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc]
        initWithString:[NSString
                           stringWithFormat:@"预计奖金:%@元", bonusString]];
    [hinstring addAttribute:NSForegroundColorAttributeName
                      value:UIColorFromRGB(0xca5c5d)
                      range:NSMakeRange(5, bonusString.length)];
    view.bonusLabel.attributedText = hinstring;

    [view.bonusButton
        setTitle:[NSString stringWithFormat:@"%ld元 购买",
                                            [self note:gameType] * 2 * kBetMultiple]
        forState:UIControlStateNormal];
}

//快速投注--竞彩付款
- (void)jcSelectedToPay:(GameTypeId)gameType {
    //    @weakify(self);

    PBMHomePage_SportQuickBet *sportQuick;

    if (gameType == GameTypeLcNone) {
        sportQuick = _lcLastBet;    // _homePage.quickJclq;
    } else {
        sportQuick = _zcLastBet;    // _homePage.quickJczq;
    }
    // 下单请求接口（普通投注）
    PBMPlaceAnOrder *order = [self getOrderData:sportQuick.gameType quickBet:sportQuick];
    [DPPaymentFlow paymentWithOrder:order gameType:sportQuick.gameType inViewController:self];
}

// 下单请求接口（普通投注）
- (PBMPlaceAnOrder *)getOrderData:(GameTypeId)gameType quickBet:(PBMHomePage_SportQuickBet *)quickBet {
    PBMPlaceAnOrder *order = [[PBMPlaceAnOrder alloc] init];

    if (IsGameTypeJc(gameType)) {
        DPJczqBetStore *betStore = [[DPJczqBetStore alloc] init];

        if (gameType == GameTypeJcRqspf) {
            [betStore setRqspfBetOption:quickBet.homeBetOption.betOption.betJczqOption];
            betStore.rqspfSpList = quickBet.spListArray;

        } else {
            [betStore setSpfBetOption:quickBet.homeBetOption.betOption.betJczqOption];
            betStore.spfSpList = quickBet.spListArray;
        }

        betStore.rqs = [quickBet.balance integerValue];
        betStore.matchId = quickBet.gameMatchId;
        betStore.orderNumberName = quickBet.orderNumberName;
        order.betDescription = [DPBetDescription descriptionJczqWithOption:[NSArray arrayWithObjects:betStore, nil] passMode:@[ @(0x01010101) ] gameType:gameType note:(int)[self note:gameType]];

    } else {
        DPJclqBetStore *betStore = [[DPJclqBetStore alloc] init];
        if (gameType == GameTypeLcRfsf) {
            [betStore setRfsfBetOption:quickBet.homeBetOption.betOption.betLcOption];
            betStore.rfsfSpList = quickBet.spListArray;
            betStore.rf = [quickBet.balance integerValue];

        } else {
            [betStore setSfBetOption:quickBet.homeBetOption.betOption.betLcOption];
            betStore.sfSpList = quickBet.spListArray;
            betStore.zf = [quickBet.balance integerValue];
        }

        betStore.matchId = quickBet.gameMatchId;
        betStore.orderNumberName = quickBet.orderNumberName;

        order.betDescription = [DPBetDescription descriptionJclqWithOption:[NSArray arrayWithObjects:betStore, nil] passMode:@[ @(0x01010101) ] gameType:gameType note:(int)[self note:gameType]];
    }

    order.betOrderNumbers = [NSString stringWithFormat:@",%lld,", quickBet.gameMatchId];
    order.betType = 2;
    order.channelType = 1;
    order.deviceNum = @"";
    order.gameId = (int32_t)quickBet.gameId;
    order.gameTypeId = gameType;
    order.multiple = kBetMultiple;
    order.platformType = 1;
    order.quantity = (int)[self note:gameType];
    order.totalAmount = (int)[self note:gameType] * 2 * kBetMultiple;
    order.passTypeDesc = @"单关";
    order.betTypeDesc = @"复式";
    order.projectBuyType = 1;

    return order;
}

#pragma mark -  竞彩快速投注玩法介绍
- (void)jcGameInfoView:(DPHomeBuyJCView *)view {
    DPLog(@"竞彩快速投注玩法介绍");
    DPJcdgWarnView *warnView = [[DPJcdgWarnView alloc] init];

    PBMHomePage_SportQuickBet *sportQuick;

    if (view.gameId == GameTypeLcNone) {
        sportQuick = _lcLastBet;    // _homePage.quickJclq;
    } else {
        sportQuick = _zcLastBet;    //  _homePage.quickJczq;
    }

    if (IsGameTypeJc((GameTypeId)sportQuick.gameType)) {
        if (sportQuick.gameType == GameTypeJcRqspf) {
            warnView.gameTypeLabel.text = @"竞彩足球让球胜平负玩法介绍";
            warnView.titleText = @"竞猜90分钟包含伤停补时，比赛的胜平负结果进行投注，所选结果需计算让球。";

        } else {
            warnView.gameTypeLabel.text = @"竞彩足球胜平负玩法介绍";
            warnView.titleText = @"竞猜90分钟包含伤停补时，比赛的胜平负结果进行投注，所选结果均不让球。";
        }

    } else if (IsGameTypeLc((GameTypeId)sportQuick.gameType)) {
        if (sportQuick.gameType == GameTypeLcRfsf) {
            warnView.gameTypeLabel.text = @"竞彩篮球让分胜负玩法介绍";
            warnView.titleText = @"竞猜比赛场次在全场（含加时赛）的比赛结果进行投注，所选结果需计算让分。";

        } else {
            warnView.gameTypeLabel.text = @"竞彩篮球胜负玩法介绍";
            warnView.titleText = @"竞猜比赛场次在全场（含加时赛）的比赛结果进行投注，所选结果均不让分。";
        }
    }

    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:warnView];
    [warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    [self dp_showViewController:viewController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

#pragma mark -homeBallViewCellDelegate
//随机一注
- (void)randomSelectedBallViewCell:(DPSelectedBallViewCell *)cell {
    [self digitalDataRandom];
    //    [self.tableView reloadData];

    //    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];

    for (int i = 0; i < cell.balls.count; i++) {
        UIButton *button = [cell.balls objectAtIndex:i];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:(M_PI * 6 + 2 * M_PI * i)];
        animation.duration = 1.5 + 0.15 * i;
        animation.repeatCount = 1;
        animation.removedOnCompletion = YES;
        [button.layer addAnimation:animation forKey:@"Roation"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < cell.balls.count; i++) {
            UIButton *button = [cell.balls objectAtIndex:i];
            [button setTitle:[self.ballsArray objectAtIndex:i] forState:UIControlStateNormal];
        }
    });
}
//大乐透付款
- (void)payForSelectedBallViewCell:(DPSelectedBallViewCell *)cell {
    _selectedType = GameTypeDlt;
    PBMPlaceAnOrder *item = [[PBMPlaceAnOrder alloc] init];
    item.betDescription = [self dltPayForString];
    item.betOrderNumbers = @"";
    item.betType = 1;
    item.channelType = 1;
    item.deviceNum = @"";
    item.gameId = (int)_homePage.quickDlt.gameId;
    item.gameTypeId = _selectedType;
    item.multiple = 10;
    item.platformType = 1;
    item.quantity = 1;
    item.totalAmount = (int)item.quantity * (int)item.multiple * 2;
    item.betTypeDesc = @"单式";
    item.projectBuyType = 1;
    item.passTypeDesc = @"";
    [DPPaymentFlow paymentWithOrder:item gameType:_selectedType gameName:_homePage.quickDlt.gameName.intValue inViewController:self];
}
//大乐透下单格式
- (NSString *)dltPayForString {
    DPDltBetData *data = [[DPDltBetData alloc] init];
    for (int i = 0; i < DLTREDNUM; i++) {
        [data.red addObject:[NSNumber numberWithInt:_normalRed[i]]];
    }
    for (int i = 0; i < DLTBLUENUM; i++) {
        [data.blue addObject:[NSNumber numberWithInt:_normalBlue[i]]];
    }
    data.mark = NO;
    data.note = [NSNumber numberWithInt:1];
    NSArray *array = [NSArray arrayWithObjects:data, nil];
    NSArray *options = [array dp_mapObjectUsingBlock:^DPDltBetStore *(DPDltBetData *obj, NSUInteger idx, BOOL *stop) {
        DPDltBetStore *store = [[DPDltBetStore alloc] init];
        store.red = obj.red;
        store.blue = obj.blue;
        return store;
    }];
    //大乐透下单格式
    NSString *string = [DPBetDescription descriptionDltWithOption:options addition:NO];
    return string;
}

#pragma mark - 获取社区点击信息
- (void)buttonClickForCommunityView:(NSInteger)index {
    DPLog(@"社区点击 %ld", (long)index);
    if (index >= _homePage.communityAreaArray.count) {
        return;
    }
    [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeHomeCommunityFirst + index)] props:nil];
    PBMHomePage_LinkItem *item = _homePage.communityAreaArray[index];
    [DPAppURLRoutes handleURL:[NSURL URLWithString:item.event]];
}
//获取点击的彩种
- (void)buttonClickForLotteryView:(GameTypeId)gameType {
    switch (gameType) {
        case GameTypeDlt:
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeHomeDlt)] props:nil];
            [self.navigationController pushViewController:[[DPLTDltViewController alloc] init] animated:YES];
            break;
        case GameTypeJcNone: {
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeHomeJczq)] props:nil];
            DPJczqBuyViewController *viewController = [[DPJczqBuyViewController alloc] init];
            viewController.gameType = GameTypeJcHt;
            [self.navigationController pushViewController:viewController animated:YES];
        } break;
        case GameTypeLcNone: {
            [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeHomeJclq)] props:nil];
            DPJclqBuyViewController *viewController = [[DPJclqBuyViewController alloc] init];
            viewController.gameType = GameTypeLcHt;
            [self.navigationController pushViewController:viewController animated:YES];
        } break;
        default:
            break;
    }
}

//首页主体内容
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
//轮播图片
- (KTMBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[KTMBannerView alloc] init];
        _bannerView.backgroundColor = [UIColor clearColor];
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.bottomMargin = 10;

        [_bannerView registerClass:[DPHomeBannerViewPage class] forPageReuseIdentifier:kBannerPageIdentifier];
    }
    return _bannerView;
}
// 公告视图
- (UILabel *)noticeLabel {
    if (_noticeLabel == nil) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.backgroundColor = UIColorFromRGB(0xbf3031);
        _noticeLabel.textColor = [UIColor whiteColor];
        _noticeLabel.font = [UIFont systemFontOfSize:12.0];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.userInteractionEnabled=YES;
    }
    return _noticeLabel;
}
// 资讯
- (UIButton *)recommendButton {
    if (_recommendButton == nil) {
        _recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendButton.layer.cornerRadius = 17.5;
        _recommendButton.backgroundColor = UIColorFromRGB(0xffffff);
        [_recommendButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_recommendButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
        [_recommendButton setImage:dp_AppRootImage(@"zixun.png") forState:UIControlStateNormal];
        _recommendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_recommendButton addTarget:self action:@selector(pvt_recommend) forControlEvents:UIControlEventTouchUpInside];
        _recommendButton.dp_eventId = DPAnalyticsTypeHomeLottery;
        [_recommendButton setTitleColor:UIColorFromRGB(0x6b6e6e) forState:UIControlStateNormal];
        _recommendButton.titleLabel.font = [UIFont dp_systemFontOfSize:14.0];
    }

    return _recommendButton;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 38;
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }

        CGFloat offset = scrollView.contentOffset.y;
        self.effectView.alpha = MIN(0.9, MAX(0, (offset - 125.0) / 40.0));
    }
}

//资讯
- (void)pvt_recommend {
    [DPAppURLRoutes handleURL:[NSURL URLWithString:_homePage.recommend.event]];
}
//公告
- (void)pvt_notice {
    [DPAppURLRoutes handleURL:[NSURL URLWithString:_homePage.announcement.event]];
}
- (NSInteger)note:(GameTypeId)gameType {
    NSInteger count = 0;
    if (IsGameTypeJc(gameType)) {
        //        count = [_homePage.quickJczq getSelectedCount:GameTypeJcNone];
        count = [_zcLastBet getSelectedCount:GameTypeJcNone];

    } else if (IsGameTypeLc(gameType)) {
        //        count = [_homePage.quickJclq getSelectedCount:GameTypeLcNone];
        count = [_lcLastBet getSelectedCount:GameTypeLcNone];

    } else if (gameType == GameTypeDlt) {
        count = 1;
    }
    return count;
}

#pragma mark - 定时器相关

- (void)onTimer:(NSNotificationCenter *)notify {
    if (_isInHomeViewController) {
        _timeCount++;
        if (_timeCount >= 5 * 60) {
            DPLog(@"首页自动刷新");
            _timeCount = 0;
            [self getDataFromeNet];
        }
    }
}

#pragma mark - 更新首页内容
- (void)reloadHome {
    //是否优先显示快速投注
    _showQuickFirst = _homePage.showQuickFirst;

    _isJczqShow = _homePage.quickJczq.gameMatchId && _homePage.lotteryJczq.enable;
    _isJclqShow = _homePage.quickJclq.gameMatchId && _homePage.lotteryJclq.enable;

    if (_isJczqShow) {
        if (_zcLastBet.gameType != _homePage.quickJczq.gameType || _zcLastBet.gameMatchId != _homePage.quickJczq.gameMatchId) {
            [_zcLastBet clear];
            [_zcLastBet mergeFrom:_homePage.quickJczq];
            [_zcLastBet.homeBetOption resetQuickBet];
        }
    }

    if (_isJclqShow) {
        if (_lcLastBet.gameType != _homePage.quickJclq.gameType || _lcLastBet.gameMatchId != _homePage.quickJclq.gameMatchId) {
            [_lcLastBet clear];
            [_lcLastBet mergeFrom:_homePage.quickJclq];
            [_lcLastBet.homeBetOption resetQuickBet];
        }
    }

    _isUpdateJCData = YES;

    //公告
    self.noticeLabel.hidden = _homePage.announcement.title.length > 0 ? NO : YES;
    self.noticeLabel.text = _homePage.announcement.title;

    //推荐
    [self reloadRecommend];

    //社区板块
    [self.bannerView reloadData];
    [self.tableView reloadData];
}

#pragma mark - 更新推荐区图片
- (void)reloadRecommend {
    [self.viewModel requestImageIfNeeded:self.viewModel.recommend];
    [self.recommendButton setTitle:self.viewModel.recommend.title forState:UIControlStateNormal];
    @weakify(self)
        [RACObserve(self.viewModel.recommend, image) subscribeNext:^(id x) {
            @strongify(self);
            [self.recommendButton setImage:x ?: dp_AppRootImage(@"zixun.png") forState:UIControlStateNormal];
        }];
}
//倒计时
- (void)updateDataForTime {
    [self getDataFromeNet];
}

- (UIView *)effectView {
    if (!_effectView) {
        _effectView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        _effectView.backgroundColor = [UIColor dp_flatRedColor];
        _effectView.alpha = 0;
    }
    return _effectView;
}

@end
