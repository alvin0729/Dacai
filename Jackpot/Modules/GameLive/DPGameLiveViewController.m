//
//  DPGameLiveViewController.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <OAStackView/OAStackView.h>
#import "DZNEmptyDataView.h"
#import "SVPullToRefresh.h"
#import "DPSegmentedControl.h"
#import "DPWebViewController.h"

#import "DPGameLiveViewController.h"
#import "DPGameLiveViewModel.h"
#import "DPGameLiveBasketballCell.h"
#import "DPGameLiveFootballCell.h"
#import "DPGameLiveViews.h"
#import "DPGameLiveFilterView.h"

#import "DPGameLiveSettingViewController.h"
#import "DPDataCenterViewController.h"
#import "DPLogOnViewController.h"
#import "DPUANoTroubleController.h"
#import "DPJczqBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPLoginViewController.h"
#import "UIViewController+Transitions.h"

@interface DPGameLiveViewController () <UITableViewDelegate, UITableViewDataSource, DPGameLiveViewDelegate, DPGameLiveCellDelegate, DPGameLiveFilterViewDelegate>
@property (nonatomic, strong) DPSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) DPGameLiveViewModel *viewModel;

@property (nonatomic, strong) DPGameLiveTabBar *tabBarView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) OAStackView *stackView;
@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, assign) CGFloat cellInfoHeight;
@property (nonatomic, strong) MSWeakTimer *statusTimer;
@property (nonatomic, strong) NSDate *updateDate;
@end

@implementation DPGameLiveViewController

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _defaultItem = -1;
        
        // 进球事件通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScoreChanged:) name:kDPGameLiveScoreChangeNotifyKey object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 导航栏原色
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"比分直播";
    if (self.defaultItem > 2 || self.defaultItem < 0) {
        self.defaultItem = 0;
    }

    // 页面
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.stackView];
    [self.segmentedControl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];

    // 布局
    [self makeViewConstraints];

    // 请求数据
    [self showHUD];
    [self fetch];

    // 切换tab, 定位tab
    @weakify(self);
    [self.tabBarView.rac_signalForSelectedItem subscribeNext:^(DPGameLiveTabBarItem *item) {
        @strongify(self);
        [self.scrollView scrollRectToVisible:CGRectMake(self.tabBarView.selectedIndex * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.bounds)) animated:YES];
    }];
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if (self.scrollView == tuple.first) {
            NSInteger index = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
            DPGameLiveTabBarItem *item = self.tabBarView.items[index];
            self.tabBarView.selectedItem = item;
        }
    }];
    // 判断是否登录, 未登录弹出登陆窗口
    [[[RACObserve(self.tabBarView, selectedIndex) distinctUntilChanged] skip:1] subscribeNext:^(NSNumber *selectedIndex) {
        @strongify(self);
        if (selectedIndex.integerValue == 2 && ![DPMemberManager sharedInstance].isLogin) {
            DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
            [self presentViewController:[UINavigationController dp_controllerWithRootViewController:viewController] animated:YES completion:nil];
        }
    }];

    // 更新数据的阀值
    static const NSTimeInterval kTimeInterval = 60 * 60;
    // 根据比分直播模块是否是当前控制器, 激活或者注销轮询
    [[[RACObserve(self.tabBarController, selectedViewController) distinctUntilChanged] skip:1] subscribeNext:^(UIViewController *selectedViewController) {
        @strongify(self);
        if (self.navigationController == selectedViewController) {
            // 上次获取间隔大于阀值, 则重新拉取数据
            if (!self.updateDate || [[NSDate dp_date] timeIntervalSinceDate:self.updateDate] > kTimeInterval) {
                [self showHUD];
                [self fetch];
            } else {
                [self activateBackground];
            }
        } else {
            [self deactivateBackground];
        }
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        if (self.isViewLoaded && self.view.window) {
            [self reloadData];
            // 上次获取间隔大于阀值, 则重新拉取数据
            if (!self.updateDate || [[NSDate dp_date] timeIntervalSinceDate:self.updateDate] > kTimeInterval) {
                [self showHUD];
                [self fetch];
            }
        }
    }];
    
    // 监听用户登录状态，实时改变关注列表
    RACSignal *viewWillAppearSignal = [[self rac_signalForSelector:@selector(viewWillAppear:)] take:1];
    [[[RACObserve([DPMemberManager sharedInstance], isLogin) distinctUntilChanged] skip:1] subscribeNext:^(NSNumber *isLogin) {
        @strongify(self);
        if (self.isViewLoaded && self.view.window) {
            [self showHUD];
            [self fetch];
        } else {
            static RACDisposable *disposable;
            if (disposable) {
                [disposable dispose];
            }
            disposable = [viewWillAppearSignal subscribeNext:^(id x) {
                @strongify(self);
                [self showHUD];
                [self fetch];
                disposable = nil;
            }];
        }
    }];

    // 默认定位
    self.segmentedControl.selectedIndex = self.defaultIndex;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.defaultItem <= 2 && self.defaultItem >= 0) {
        [self.scrollView setContentOffset:CGPointMake(self.defaultItem * kScreenWidth, 0)];
        [self.tabBarView setSelectedItem:[self.tabBarView.items objectAtIndex:self.defaultItem] animation:NO execute:NO];

        self.defaultItem = -1;
    }
}

#pragma mark - Layout

- (void)makeViewConstraints {
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarView.mas_bottom).offset(-0.5);  // 偏移0.5, 处理2根分割线叠加问题
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    [self.view bringSubviewToFront:self.tabBarView];
    
    for (UITableView *tableView in self.tableViews) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
    }
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

- (void)activateBackground {
    if (!self.statusTimer) {
        self.statusTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(backgroundTimerFunc)
                                                              userInfo:nil
                                                               repeats:YES
                                                         dispatchQueue:dispatch_get_main_queue()];
    }
    [self.viewModel activateUpdateLoop];
}

- (void)deactivateBackground {
    self.statusTimer = nil;
    [self.viewModel deactivateUpdateLoop];
}

- (void)backgroundTimerFunc {
    // 每秒遍历依次所有可见的cell, 修改赛事状态
    for (UITableView *tableView in self.tableViews) {
        NSArray *visibleCells = [tableView visibleCells];
        for (DPGameLiveBaseCell *cell in visibleCells) {
            // 同一彩种
            if (cell.tag == self.viewModel.gameLiveType) {
                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                if (indexPath.section >= [self.viewModel numberOfSectionsForTab:tableView.tag] ||
                    indexPath.row >= [self.viewModel numberOfRowsInSection:indexPath.section forTab:tableView.tag]) {
                    continue;
                }
                NSArray *matchStatusTexts = [self.viewModel matchStatusAtIndexPath:indexPath forTab:tableView.tag];
                [cell.infoView setMatchStatusAttributedTexts:matchStatusTexts];
            }
        }
    }
}

/**
 *  拉取数据, 并启动轮询
 */
- (void)fetch {
    if (!self.statusTimer) {
        self.statusTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(backgroundTimerFunc)
                                                              userInfo:nil
                                                               repeats:YES
                                                         dispatchQueue:dispatch_get_main_queue()];
    }
    [self.viewModel fetch];
}

- (void)reloadData {
    for (UITableView *tableView in self.stackView.subviews) {
        [tableView.pullToRefreshView stopAnimating];
        [tableView reloadData];
    }
}

- (UITableView *)generateTableViewWithTab:(DPGameLiveTab)tab {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor dp_flatBackgroundColor];
    tableView.separatorColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.76 alpha:1];
    tableView.alwaysBounceVertical = NO;
    tableView.directionalLockEnabled = NO;
    tableView.scrollsToTop = YES;
    tableView.tag = tab;
    tableView.tableFooterView = [[UIView alloc] init];
    
    [tableView registerClass:[DPGameLiveBaseCell class] forCellReuseIdentifier:self.viewModel.baseIdentifier];
    [tableView registerClass:[DPGameLiveFootballCell class] forCellReuseIdentifier:self.viewModel.footballIdentifier];
    [tableView registerClass:[DPGameLiveBasketballCell class] forCellReuseIdentifier:self.viewModel.basketballIdentifier];
    return tableView;
}

- (UITableView *)tableViewForTab:(DPGameLiveTab)tab {
    for (UITableView *tableView in self.tableViews) {
        if (tableView.tag == tab) {
            return tableView;
        }
    }
    NSAssert(NO, @"failure...");
    return nil;
}

#pragma mark - Override

#pragma mark - User Interaction

- (void)leftBarItemTapped {
    if (self.viewModel.allCompetition.count == 0) {
        return;
    }
    // 构造数据源
    NSArray *allCompetition = self.viewModel.allCompetition;
    NSArray *visibleCompetition = self.viewModel.visibleCompetition;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:allCompetition.count];
    for (NSString *competition in allCompetition) {
        DPGameLiveFilterItem *item = [[DPGameLiveFilterItem alloc] init];
        item.name = competition;
        item.selected = [visibleCompetition containsObject:competition];
        [items addObject:item];
    }
    DPGameLiveFilterGroup *group = [[DPGameLiveFilterGroup alloc] init];
    group.title = @"选择赛事";
    group.items = items;

    // UI布局
    DPGameLiveFilterView *filterView = ({
        DPGameLiveFilterView *view = [[DPGameLiveFilterView alloc] init];
        view.dataSource = @[ group ];
        view.delegate = self;
        view.visibleCount = [self.viewModel matchCountForCompetition:self.viewModel.visibleCompetition];
        view.layer.cornerRadius = 10;
        view.clipsToBounds = YES;
        view;
    });
    
    // modal 弹出
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:filterView];
    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewController.view);
        make.left.equalTo(viewController.view).offset(15);
        make.right.equalTo(viewController.view).offset(-15);
        make.top.greaterThanOrEqualTo(viewController.view).offset(80);
    }];
    [self dp_showViewController:viewController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    
    // delegate事件
    @weakify(self, filterView, viewController);
    NSArray * (^visibleCompetitionBlock)() = ^NSArray *() {
        @strongify(filterView);
        NSMutableArray *visibleCompetition = [NSMutableArray array];
        DPGameLiveFilterGroup *group = filterView.dataSource.firstObject;
        for (DPGameLiveFilterItem *item in group.items) {
            if (item.selected) {
                [visibleCompetition addObject:item.name];
            }
        }
        return visibleCompetition;
    };
    [[self rac_signalForSelector:@selector(confirmFilterView:) fromProtocol:@protocol(DPGameLiveFilterViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self, viewController);
        NSArray *visibleCompetition = visibleCompetitionBlock();
        [self.viewModel filterWithVisibleCompetition:visibleCompetition];
        for (UITableView *tableView in self.tableViews) {
            [tableView reloadData];
        }
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [[self rac_signalForSelector:@selector(cancelFilterView:) fromProtocol:@protocol(DPGameLiveFilterViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(viewController);
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [[self rac_signalForSelector:@selector(changeFilterView:) fromProtocol:@protocol(DPGameLiveFilterViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self, filterView);
        NSArray *visibleCompetition = visibleCompetitionBlock();
        filterView.visibleCount = [self.viewModel matchCountForCompetition:visibleCompetition];
    }];
    
}

- (void)rightBarItemTapped {
    DPUANoTroubleController *viewController = [[DPUANoTroubleController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)segmentedValueChanged:(DPSegmentedControl *)segmented {
    self.viewModel.gameLiveType = segmented.selectedIndex == 0 ? DPGameLiveTypeFootball : DPGameLiveTypeBasketball;
    self.defaultIndex = segmented.selectedIndex;
    [self showHUD];
    [self fetch];
}

#pragma mark - Notification
// 发生进球事件
- (void)didScoreChanged:(NSNotification *)notification {
    // 当前控制器在视图栈上
    if ([self isViewLoaded] && self.view.window) {
        NSArray *goalArray = [[[notification userInfo] objectForKey:kDPGameLiveScoreGoalSetKey] allObjects];
        
        NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < goalArray.count && i < 5; i++) {
            DPGameLiveGoalModel *goalModel = [goalArray objectAtIndex:i];
            [self.viewModel fetchImageIfNeeded:goalModel.model];
            
            DPGameLiveGoalView *goalView = [[DPGameLiveGoalView alloc] init];
            goalView.homeName = goalModel.model.homeName;
            goalView.awayName = goalModel.model.awayName;
            goalView.attributedString = goalModel.scoreAttributedString;
            // 球队图片
            RAC(goalView, homeIcon, dp_SportLiveImage(@"default.png")) = RACObserve(goalModel.model, homeLogo);
            RAC(goalView, awayIcon, dp_SportLiveImage(@"default.png")) = RACObserve(goalModel.model, awayLogo);
            
            [subviews addObject:goalView];
        }
        OAStackView *view = [[OAStackView alloc] initWithArrangedSubviews:subviews];
        view.distribution = OAStackViewDistributionFill;
        view.axis = UILayoutConstraintAxisVertical;
        view.alignment = OAStackViewAlignmentCenter;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-10);
        }];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        @weakify(view);
        [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(view);
            [view removeFromSuperview];
        }];
        [view addGestureRecognizer:tapGesture];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
        });
    }
}

#pragma mark - Delegate

#pragma mark - DPGameLiveCellDelegate

- (void)gameLiveCell:(DPGameLiveBaseCell *)cell attention:(BOOL)attention {
    UITableView *tableView = cell.ownerTable;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];

    @weakify(self);
    void (^block)(void) = ^() {
        @strongify(self);

        [self.viewModel attentionMatch:attention atIndexPath:indexPath forTab:tableView.tag needLoad:YES];

        if (attention) {
            CGRect fromFrame = [self.view convertRect:cell.infoView.startButton.frame fromView:cell.infoView];
            CGRect toFrame = CGRectMake(CGRectGetMaxX(self.tabBarView.frame) - CGRectGetWidth(fromFrame) - 10,
                                        CGRectGetHeight(self.tabBarView.frame) - CGRectGetHeight(fromFrame),
                                        CGRectGetWidth(fromFrame),
                                        CGRectGetHeight(fromFrame));
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"guanzhuselected.png")];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.frame = fromFrame;
            [self.view addSubview:imageView];

            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 imageView.frame = toFrame;
                             }
                             completion:nil];
            [UIView animateWithDuration:0.1
                delay:0.2
                options:UIViewAnimationOptionCurveLinear
                animations:^{
                    imageView.alpha = 0;
                }
                completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];
            
            if ([self.viewModel matchGoingAtIndexPath:indexPath forTab:tableView.tag]) {
                [[DPToast makeText:@"将会给您推送被关注比赛的进球以及结束信息"] show];
            } else {
                [[DPToast makeText:@"您关注的比赛将会在开赛前推送通知"] show];
            }
        }

        [self reloadData];

    };

    if ([DPMemberManager sharedInstance].isLogin) {
        block();
    } else {
        DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didToggleCell:(DPGameLiveBaseCell *)cell {
    UITableView *tableView = cell.ownerTable;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];

    [self.viewModel toggleCellAtIndexPath:indexPath forTab:tableView.tag];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (void)didTappedCell:(DPGameLiveBaseCell *)cell {
}

#pragma mark - DPGameLiveViewModelDelegate
- (void)fetchFinished:(NSError *)error needLocationTab:(BOOL)needLocationTab {
    for (UITableView *tableView in self.tableViews) {
        tableView.emptyDataView.requestSuccess = error == nil;
    }
    if (!error) {
        self.updateDate = [NSDate dp_date];
    }
    
    [self dismissHUD];
    [self reloadData];
    
    // 定位tab
    if (needLocationTab) {
        NSInteger index = self.tabBarView.selectedIndex;
        if ([self.viewModel numberOfSectionsForTab:DPGameLiveTabUnfinished]) {
            // 定位到未结束
            index = 0;
        } else if ([self.viewModel numberOfSectionsForTab:DPGameLiveTabCompleted]) {
            // 定位到已结束
            index = 1;
        }
        if (index != self.tabBarView.selectedIndex) {
            DPGameLiveTabBarItem *item = self.tabBarView.items[index];
            self.tabBarView.selectedItem = item;
            [self.tabBarView setSelectedItem:item animation:YES execute:YES];
        }
    }
    
    // 提示错误信息
    if (error) {
        // 如果提示空页面已经提示了网络相关错误, 则不提示浮框
        if (error.dp_networkError && !self.viewModel.hasMatches) {
            return;
        }
        [[DPToast makeText:error.dp_errorMessage] show];
    }
}

- (void)updateMatchInfo {
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSectionsForTab:tableView.tag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section forTab:tableView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPGameLiveType type = self.viewModel.gameLiveType;
    NSString *cellIdentifier = [self.viewModel cellIdentifierAtIndexPath:indexPath forTab:tableView.tag];
    DPGameLiveBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DPGameLiveMatchModel *model = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag];
    cell.delegate = self;
    cell.ownerTable = tableView;
    // 篮球主客相反
    if (type == DPGameLiveTypeFootball) {
        cell.infoView.homeNameLabel.text = model.homeName;
        cell.infoView.awayNameLabel.text = model.awayName;
        cell.infoView.homeRankLabel.text = model.homeRank;
        cell.infoView.awayRankLabel.text = model.awayRank;
    } else {
        cell.infoView.homeNameLabel.text = model.awayName;
        cell.infoView.awayNameLabel.text = model.homeName;
        cell.infoView.homeRankLabel.text = model.awayRank;
        cell.infoView.awayRankLabel.text = model.homeRank;
    }
    cell.infoView.matchTitleLabel.text = model.matchTitle;
    cell.infoView.startButton.selected = model.attention;
    cell.infoView.startButton.hidden = ![self.viewModel shouldAttentionAtIndexPath:indexPath forTab:tableView.tag];
    cell.infoView.toggleButton.selected = model.unfold;
    cell.infoView.toggleButton.hidden = ![self.viewModel shouldUnfoldAtIndexPath:indexPath forTab:tableView.tag];

    [cell.infoView setMatchStatusAttributedTexts:[self.viewModel matchStatusAtIndexPath:indexPath forTab:tableView.tag]];
    [cell.infoView.commentButton setTitle:[NSString stringWithFormat:@"%d条", (int)model.comment] forState:UIControlStateNormal];

    // 篮球主客相反
    @weakify(cell);
    [[RACObserve(model, homeLogo) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIImage *image) {
        @strongify(cell);
        if (type == DPGameLiveTypeFootball) {
            cell.infoView.homeLogoView.image = image ?: dp_SportLotteryImage(@"default.png");
        } else {
            cell.infoView.awayLogoView.image = image ?: dp_SportLotteryImage(@"default.png");
        }
    }];
    [[RACObserve(model, awayLogo) takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIImage *image) {
        @strongify(cell);
        if (type == DPGameLiveTypeFootball) {
            cell.infoView.awayLogoView.image = image ?: dp_SportLotteryImage(@"default.png");
        } else {
            cell.infoView.homeLogoView.image = image ?: dp_SportLotteryImage(@"default.png");
        }
    }];
    // 下载图片
    [self.viewModel fetchImageIfNeeded:model];

    // 展开视图
    if ([cell respondsToSelector:@selector(unfoldView)]) {
        // 篮球
        if ([cell isKindOfClass:[DPGameLiveBasketballCell class]]) {
            DPGameLiveBasketballUnfoldView *unfoldView = cell.unfoldView;
            [unfoldView setPointDiff:model.homeScore - model.awayScore];
            [unfoldView setTotalScore:model.homeScore + model.awayScore];
            [unfoldView setHomeName:model.homeName];
            [unfoldView setAwayName:model.awayName];
            [unfoldView setHomeScore:[self.viewModel basketballHomeScoresAtIndexPath:indexPath forTab:tableView.tag]];
            [unfoldView setAwayScore:[self.viewModel basketballAwayScoresAtIndexPath:indexPath forTab:tableView.tag]];
            [unfoldView setExtra:[self.viewModel extraBasketballAtIndexPath:indexPath forTab:tableView.tag]];
        }
        // 足球
        if ([cell isKindOfClass:[DPGameLiveFootballCell class]]) {
            DPGameLiveFootballUnfoldView *unfoldView = cell.unfoldView;
            [unfoldView setEvents:model.events];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPDataCenterViewController *viewController = [[DPDataCenterViewController alloc] init];
    
    DPGameLiveMatchModel *model = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag] ;
    viewController.titleString = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag].competition;
    viewController.matchId = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag].matchId;
    viewController.gameType = self.viewModel.gameLiveType == DPGameLiveTypeFootball ? GameTypeJcNone : GameTypeLcNone;
    viewController.selectedIndex = 1;
    
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.font = [UIFont dp_systemFontOfSize:13];
        attr.textColor = [UIColor dp_flatBlackColor];
        attr;
    })];
    [parser addStyleWithTagName:@"rank" font:[UIFont dp_systemFontOfSize:9] color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    NSString *homeMarkupText, *awayMarkupText;
    
    // 球队名+排名
    if (model.homeRank.length) {
        homeMarkupText =self.viewModel.gameLiveType == DPGameLiveTypeFootball? [NSString stringWithFormat:@"<rank>%@</rank>%@", model.homeRank, model.homeName]:[NSString stringWithFormat:@"%@<rank>%@</rank>",model.homeName, model.homeRank];
    } else {
        homeMarkupText = [NSString stringWithFormat:@"%@", model.homeName];
    }
    if (model.awayRank.length) {
        awayMarkupText = self.viewModel.gameLiveType == DPGameLiveTypeFootball? [NSString stringWithFormat:@"%@<rank>%@</rank>", model.awayName, model.awayRank] : [NSString stringWithFormat:@"<rank>%@</rank>%@",model.awayRank, model.awayName ];
    } else {
        awayMarkupText = [NSString stringWithFormat:@"%@", model.awayName];
    }
    
    viewController.homeTeamName = [parser attributedStringFromMarkup:homeMarkupText];
    viewController.awayTeamName = [parser attributedStringFromMarkup:awayMarkupText];
    @weakify(self);
    viewController.actionBlock = ^(BOOL action) {    //关注事件
        @strongify(self);
        DPGameLiveMatchModel *model = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag];

        if(model.attention != action){
            [self.viewModel attentionMatch:action atIndexPath:indexPath forTab:tableView.tag needLoad:NO];
        }
    };

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DPGameLiveBaseCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 修正 iOS 8 上的偏移
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    DPGameLiveType type = self.viewModel.gameLiveType;
    BOOL going = [self.viewModel matchGoingAtIndexPath:indexPath forTab:tableView.tag];
    static NSString *kAnimationKey = @"Pulse";

    cell.infoView.footballPulseLabel.hidden = !(type == DPGameLiveTypeFootball && going);
    cell.infoView.basketballPulseLabel.hidden = !(type == DPGameLiveTypeBasketball && going);
    [cell.infoView.footballPulseLabel.layer removeAnimationForKey:kAnimationKey];
    [cell.infoView.basketballPulseLabel.layer removeAnimationForKey:kAnimationKey];
    if (going) {
        UILabel *pulseLabel = type == DPGameLiveTypeFootball ? cell.infoView.footballPulseLabel : cell.infoView.basketballPulseLabel;
        // 秒针动画
        if ([pulseLabel.layer animationForKey:kAnimationKey] == nil) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.autoreverses = YES;
            animation.repeatCount = HUGE_VALF;
            animation.duration = 0.5f;
            [pulseLabel.layer addAnimation:animation forKey:kAnimationKey];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.viewModel cellIdentifierAtIndexPath:indexPath forTab:tableView.tag];
    DPGameLiveMatchModel *model = [self.viewModel matchModelAtIndexPath:indexPath forTab:tableView.tag];
    if ([cellIdentifier isEqualToString:self.viewModel.baseIdentifier]) {
        return [DPGameLiveBaseCell infoViewHeight];
    } else if ([cellIdentifier isEqualToString:self.viewModel.footballIdentifier]) {
        return [DPGameLiveBaseCell infoViewHeight] + [DPGameLiveFootballCell unfoldHeightForRowCount:model.events.count];
    } else if ([cellIdentifier isEqualToString:self.viewModel.basketballIdentifier]) {
        return [DPGameLiveBaseCell infoViewHeight] + kDPGameLiveBasketballUnfoldViewHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DPGameLiveHeaderView *view = [[DPGameLiveHeaderView alloc] init];
    view.title = [self.viewModel titleForSection:section forTab:tableView.tag];
    view.unfold = [self.viewModel unfoldSection:section forTab:tableView.tag];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    @weakify(self, tableView);
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self, tableView);

        CGRect rect = [tableView rectForHeaderInSection:section];
        [self.viewModel toggleSection:section forTab:tableView.tag];
        [tableView reloadData];
        [tableView scrollRectToVisible:rect animated:NO];
    }];
    [view addGestureRecognizer:tapGesture];

    return view;
}

 #pragma mark - Properties (getter, setter)

- (OAStackView *)stackView {
    if (_stackView == nil) {
        _stackView = [[OAStackView alloc] initWithArrangedSubviews:self.tableViews];
        _stackView.alignment = OAStackViewAlignmentFill;
        _stackView.distribution = OAStackViewDistributionFillEqually;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _stackView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSArray *)tableViews {
    if (_tableViews == nil) {
        UITableView *unfinishedTable = [self generateTableViewWithTab:DPGameLiveTabUnfinished];
        UITableView *completedTable = [self generateTableViewWithTab:DPGameLiveTabCompleted];
        UITableView *attentionTable = [self generateTableViewWithTab:DPGameLiveTabAttention];
        unfinishedTable.sectionHeaderHeight = 25;
        completedTable.sectionHeaderHeight = 25;
        attentionTable.sectionHeaderHeight = 0;
        
        DZNEmptyDataView *view = [DZNEmptyDataView emptyDataView];
        view.imageForNoData = dp_LoadingImage(@"noMatch.png");
        view.textForNoData = @"没比赛?去买两场试试运气";
        @weakify(self);
        view.buttonTappedEvent = ^(DZNEmptyDataViewType type) {
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData: {
                    // 去投注
                    if (self.viewModel.gameLiveType == DPGameLiveTypeFootball) {
                        DPJczqBuyViewController *viewController = [[DPJczqBuyViewController alloc] init];
                        viewController.gameType = GameTypeJcHt;
                        [self.navigationController pushViewController:viewController animated:YES];
                    } else {
                        DPJclqBuyViewController *viewController = [[DPJclqBuyViewController alloc] init];
                        viewController.gameType = GameTypeLcHt;
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                    break;
                }
                case DZNEmptyDataViewTypeFailure: {
                    // 重试
                    [self showHUD];
                    [self fetch];
                    break;
                }
                case DZNEmptyDataViewTypeNoNetwork: {
                    // 设置
                    DPWebViewController *viewController = [DPWebViewController setNetWebController];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                default:
                    break;
            }
        };
        
        unfinishedTable.emptyDataView = view.copy;
        completedTable.emptyDataView = view.copy;
        
        view.imageForNoData = dp_LoadingImage(@"noAttention.png");
        view.textForNoData = @"点击赛事星星，可以关注比赛哦！";
        view.showButtonForNoData = NO;
        attentionTable.emptyDataView = view.copy;

        void (^refresh)() = ^{
            @strongify(self);
            [self fetch];
        };
        [unfinishedTable addPullToRefreshWithActionHandler:refresh];
        [completedTable addPullToRefreshWithActionHandler:refresh];
        [attentionTable addPullToRefreshWithActionHandler:refresh];

        _tableViews = @[ unfinishedTable, completedTable, attentionTable ];
    }
    return _tableViews;
}

- (DPSegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[DPSegmentedControl alloc] initWithItems:@[ @"足球", @"篮球" ]];
        _segmentedControl.tintColor = [UIColor colorWithRed:0.73 green:0.1 blue:0.06 alpha:1];
        _segmentedControl.containerView.backgroundColor = [UIColor clearColor];
        _segmentedControl.bounds = CGRectMake(0, 0, 110, 30);
        
        [_segmentedControl.containerView.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            label.textColor = UIColorFromRGB(0xffb9b9);
            label.font = [UIFont dp_systemFontOfSize:18];
        }];
    }
    return _segmentedControl;
}

- (UIBarButtonItem *)leftItem {
    if (_leftItem == nil) {
        _leftItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(leftBarItemTapped)];
    }
    return _leftItem;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"clock.png") target:self action:@selector(rightBarItemTapped)];
    }
    return _rightItem;
}

- (DPGameLiveTabBar *)tabBarView {
    if (_tabBarView == nil) {
        DPGameLiveTabBarItem *unfinishedItem = [[DPGameLiveTabBarItem alloc] initWithTitle:@"未结束"];
        DPGameLiveTabBarItem *completedItem = [[DPGameLiveTabBarItem alloc] initWithTitle:@"已结束"];
        DPGameLiveTabBarItem *attentionItem = [[DPGameLiveTabBarItem alloc] initWithTitle:@"关注"];

        RAC(attentionItem, badgeValue) = [[RACObserve(self.viewModel, attentionCount) distinctUntilChanged] map:^id(NSNumber *value) {
            return [value stringValue];
        }];

        _tabBarView = [[DPGameLiveTabBar alloc] init];
        _tabBarView.items = @[ unfinishedItem, completedItem, attentionItem ];
    }
    return _tabBarView;
}

- (DPGameLiveViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DPGameLiveViewModel alloc] initWithDelegate:self];
    }
    return _viewModel;
}

@end
