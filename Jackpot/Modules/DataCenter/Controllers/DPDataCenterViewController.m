//
//  DPDataCenterViewController.m
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTabBar.h"
#import "SVPullToRefresh.h"
#import <OAStackView/OAStackView.h>

#import "DPDataCenterViewController+Private.h"
#import "DPDataCenterViewController.h"

#import "DPDataCenterHeaderController.h"
#import "DPDataCenterTableController.h"

#import "DPFootballCenterAnalysisController.h"
#import "DPFootballCenterCommentController.h"
#import "DPFootballCenterCompetitionController.h"
#import "DPFootballCenterIntegralController.h"
#import "DPFootballCenterOddsHandicapController.h"

#import "DPBasketballCenterAnalysisController.h"
#import "DPBasketballCenterCommentController.h"
#import "DPBasketballCenterCompetitionController.h"
#import "DPBasketballCenterIntegralController.h"
#import "DPBasketballCenterOddsHandicapController.h"
#import "DPDataCenterRefreshControl.h"
#import "DPLogOnViewController.h"
#import "Gamelive.pbobjc.h"

typedef NS_ENUM(NSInteger, DPDataCenterTab) {
    DPDataCenterTabComment = 1,
    DPDataCenterTabCompetition,
    DPDataCenterTabAnalysis,
    DPDataCenterTabIntegral,
    DPDataCenterTabOddsHandicap,
};

typedef NS_ENUM(NSInteger, DPDataCenterRefreshStatus) {
    DPDataCenterRefreshStatusNormal,
    DPDataCenterRefreshStatusLoading,
    DPDataCenterRefreshStatusPreplay,
};

static const CGFloat kCommentHeight = 40;
static const CGFloat kRefreshHeight = 60;
static const CGFloat kHeaderHeight = 105;
static const CGFloat kTabBarHeight = 36;

@interface DPDataCenterViewController () <UIScrollViewDelegate, DPTabBarDelegate, DPDataCenterTableControllerDelegate>
@property (nonatomic, strong) DPDataCenterRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) DPTabBar *tabBar;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) DPDataCenterHeaderController *headerController;
@property (nonatomic, strong) NSArray *tableControllers;
@property (nonatomic, strong) NSArray *tableViews;

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) BOOL firstLoad;
/**
 *  收藏按钮
 */
@property (nonatomic, strong) UIButton *barButton;

@property (nonatomic, weak) MASConstraint *commitViewLeft;

@end

@implementation DPDataCenterViewController

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(0xfaf9f2);
    self.view.clipsToBounds = YES;

    self.title = self.titleString;
    self.firstLoad = YES;

    // 初始化变量
    DPTabBarItem * (^tabBarItemFunc)(NSString *) = ^DPTabBarItem *(NSString *title) {
        DPTabBarItem *item = [[DPTabBarItem alloc] init];
        item.title = title;
        return item;
    };
    self.tabBar = ({
        DPTabBar *tabBar = [[DPTabBar alloc] init];
        tabBar.backgroundColor = [UIColor dp_flatWhiteColor];
        tabBar.items = @[ tabBarItemFunc(@"评论"),
                          tabBarItemFunc(@"赛事"),
                          tabBarItemFunc(@"分析"),
                          tabBarItemFunc(@"积分"),
                          tabBarItemFunc(@"赔盘") ];
        tabBar.delegate = self;
        tabBar;
    });
    self.containerView = ({
        UIScrollView *view = [[UIScrollView alloc] init];
        view.delegate = self;
        view.pagingEnabled = YES;
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.alwaysBounceHorizontal = YES;
        view.alwaysBounceVertical = NO;
        view.backgroundColor = UIColorFromRGB(0xfaf9f2);
        view;
    });

    // 初始化子控制器, 子视图 table view

    DPDataCenterHeaderController *headerController;

    NSArray *tableControllers;
    if (self.gameType == GameTypeJcNone) {
        headerController = [[DPFootballCenterHeaderController alloc] init];
        headerController.viewModel.matchId = self.matchId;

        tableControllers = @[ [[DPFootballCenterCommentController alloc] initWithMatchId:self.matchId delegate:self],
                              [[DPFootballCenterCompetitionController alloc] initWithMatchId:self.matchId
                                                                                    delegate:self],
                              [[DPFootballCenterAnalysisController alloc] initWithMatchId:self.matchId
                                                                                 delegate:self],
                              [[DPFootballCenterIntegralController alloc] initWithMatchId:self.matchId
                                                                                 delegate:self],
                              [[DPFootballCenterOddsHandicapController alloc] initWithMatchId:self.matchId
                                                                                     delegate:self] ];

    } else {
        headerController = [[DPBasketballCenterHeaderController alloc] init];
        headerController.viewModel.matchId = self.matchId;
        tableControllers = @[ [[DPBasketballCenterCommentController alloc] initWithMatchId:self.matchId delegate:self],
                              [[DPBasketballCenterCompetitionController alloc] initWithMatchId:self.matchId
                                                                                      delegate:self],
                              [[DPBasketballCenterAnalysisController alloc] initWithMatchId:self.matchId
                                                                                   delegate:self],
                              [[DPBasketballCenterIntegralController alloc] initWithMatchId:self.matchId
                                                                                   delegate:self],
                              [[DPBasketballCenterOddsHandicapController alloc] initWithMatchId:self.matchId
                                                                                       delegate:self] ];
    }

    headerController.viewModel.homeText = self.homeTeamName;
    headerController.viewModel.awayText = self.awayTeamName;

    for (DPDataCenterTableController *tableController in tableControllers) {
        tableController.delegate = self;
        tableController.navController = self.navigationController;
        tableController.tableView.contentInset = UIEdgeInsetsMake(kTabBarHeight + kHeaderHeight, 0, 0, 0);
        tableController.tableView.contentOffset = CGPointMake(0, -kTabBarHeight - kHeaderHeight);

        UIScrollView *scrollView = tableController.tableView;
        DPDataCenterRefreshControl *refreshControl = self.refreshControl;

        @weakify(self, scrollView, refreshControl);
        // 监听 scroll view 的偏移, 控制下拉刷新控件
        [RACObserve(tableController.tableView, contentOffset) subscribeNext:^(NSValue *value) {
            @strongify(self, scrollView, refreshControl);

            CGFloat scrollOffsetThreshold = -kTabBarHeight - kHeaderHeight - kRefreshHeight;
            if (!refreshControl.isRefreshing) {
                if (!scrollView.isDragging && refreshControl.refreshState == DPDataCenterRefreshStateTriggered) {
                    refreshControl.refreshState = DPDataCenterRefreshStateLoading;

                } else if (scrollView.contentOffset.y < scrollOffsetThreshold && scrollView.isDragging && refreshControl.refreshState == DPDataCenterRefreshStateStopped) {
                    refreshControl.refreshState = DPDataCenterRefreshStateTriggered;

                } else if (scrollView.contentOffset.y >= scrollOffsetThreshold && refreshControl.refreshState != DPDataCenterRefreshStateStopped) {
                    refreshControl.refreshState = DPDataCenterRefreshStateStopped;
                }
            }

            UIEdgeInsets contentInset;

            if (!refreshControl.isRefreshing) {
                contentInset = UIEdgeInsetsMake(kHeaderHeight + kTabBarHeight, 0, 0, 0);
            } else {
                contentInset = UIEdgeInsetsMake(kHeaderHeight + kTabBarHeight + kRefreshHeight, 0, 0, 0);
            }
            if (!UIEdgeInsetsEqualToEdgeInsets(contentInset, scrollView.contentInset)) {
                [scrollView setContentOffset:CGPointMake(0, -contentInset.top) animated:NO];
                [scrollView setContentInset:contentInset];
            }

            [self layoutHeaderAndTabBar];
        }];
    }
    NSArray *tableViews = [tableControllers dp_mapObjectUsingBlock:^id(DPDataCenterTableController *controller, NSUInteger idx, BOOL *stop) {
        return controller.tableView;
    }];

    self.tableControllers = tableControllers;
    self.tableViews = tableViews;
    self.headerController = headerController;
    self.headerView = self.headerController.view;
    // 使用线性布局
    OAStackView *stackView = ({
        OAStackView *view = [[OAStackView alloc] initWithArrangedSubviews:self.tableViews];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.distribution = OAStackViewDistributionFill;
        view.alignment = OAStackViewAlignmentTop;
        view.backgroundColor = UIColorFromRGB(0xfaf9f2);
        view;
    });
    [self.containerView addSubview:stackView];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.refreshControl];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tabBar];

    // 布局
    for (UITableView *tableView in self.tableViews) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.containerView);
        }];
    }
    // 跳转评论页面布局
    UIView *commentView = self.tableViews.firstObject;
    commentView.backgroundColor = UIColorFromRGB(0xfaf9f2);
    [commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.height.equalTo(self.containerView).offset(-kCommentHeight);
        make.height.equalTo(self.containerView).valueOffset([NSNumber numberWithInteger:-kCommentHeight]);

        make.width.equalTo(self.containerView);
    }];
    UIView *view = [self.tableControllers.firstObject commentView];
    view.backgroundColor = [UIColor dp_flatWhiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        self.commitViewLeft = make.left.mas_equalTo(-kScreenWidth * self.selectedIndex);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(kCommentHeight));
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];

    // 触发更新
    @weakify(self);
    [[RACObserve(self.refreshControl, refreshState) distinctUntilChanged] subscribeNext:^(NSNumber *value) {
        @strongify(self);
        DPDataCenterRefreshState refreshState = [value integerValue];
        if (refreshState == DPDataCenterRefreshStateLoading) {
            DPDataCenterTableController *tableController = self.tableControllers[self.selectedIndex];
            if (self.selectedIndex == 0) {
                tableController.isDownLoad = YES;
            }
            [tableController request];
        }
    }];

    // 触发数据更新操作
    DPDataCenterTableController *tableController = self.tableControllers[self.selectedIndex];
    if (self.selectedIndex == 0) {
        tableController.isDownLoad = YES;
    }
    [tableController request];

#ifdef DEBUG
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
#endif

    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:self.barButton];
    self.navigationItem.rightBarButtonItem = bar;
    self.barButton.selected = NO;
    self.barButton.hidden = NO;
    RAC(self.barButton, selected) = [RACObserve(self.headerController.viewModel, action) distinctUntilChanged];

    [[RACObserve(self.headerController.viewModel, statusText) filter:^BOOL(NSAttributedString *value) {
        NSString *stringValue = value.string;
        if ([stringValue hasSuffix:@"已结束"] || [stringValue hasSuffix:@"中断"] || [stringValue hasSuffix:@"腰斩"] || [stringValue hasSuffix:@"已取消"] || [stringValue hasSuffix:@"待定"]) {
            return YES;
        }
        return NO;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.barButton.hidden = YES;
    }];
}

- (UIButton *)barButton {
    if (_barButton == nil) {
        _barButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barButton setImage:dp_NavigationImage(@"follow.png") forState:UIControlStateNormal];
        [_barButton setImage:dp_NavigationImage(@"follow_select.png") forState:UIControlStateSelected];
        [_barButton addTarget:self action:@selector(pvt_follow:) forControlEvents:UIControlEventTouchUpInside];
        _barButton.backgroundColor = [UIColor clearColor];
        [_barButton setFrame:CGRectMake(0, 0, _barButton.dp_intrinsicWidth + 3, _barButton.dp_intrinsicHeight)];
    }

    return _barButton;
}

- (void)setScrollViewContentInsetForLoading {
}

- (void)pvt_follow:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;

    @weakify(self);
    void (^block)(void) = ^() {
        @strongify(self);

        PBMActionStatus *status = [PBMActionStatus message];
        status.deviceToken = @"";
        status.gameType = self.gameType == GameTypeJcNone ? GameTypeJcHt : GameTypeLcHt;
        status.matchId = self.matchId;
        status.beginDate = self.headerController.viewModel.startTime;
        status.focus = btn.selected;

        if ([self.task.dp_userInfo isEqualToString:[NSString stringWithFormat:@"%zd", self.matchId]]) {
            [self.task cancel];
        }

        self.task = [[AFHTTPSessionManager dp_sharedManager] POST:@"/live/setlivematch"
            parameters:status
            success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(self);
                self.task = nil;

                //关注/取消成功
                if (self.actionBlock) {
                    self.actionBlock(status.focus);
                }

                NSString *stringValue = self.headerController.viewModel.statusText.string;
                if (status.focus) {
                    if ([stringValue hasSuffix:@"未开始"]) {
                        [[DPToast makeText:@"您关注的比赛将会在开赛前推送通知"] show];
                    } else if (!([stringValue hasSuffix:@"未开始"] || [stringValue hasSuffix:@"已结束"] || [stringValue hasSuffix:@"中断"] || [stringValue hasSuffix:@"腰斩"] || [stringValue hasSuffix:@"已取消"] || [stringValue hasSuffix:@"待定"])) {
                        [[DPToast makeText:@"将会给您推送被关注比赛的进球以及结束信息"] show];
                    }

                } else {
                    [[DPToast makeText:@"已经取消关注比赛"] show];
                }

            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(self);
                self.task = nil;
                [[DPToast makeText:error.dp_errorMessage] show];

            }];
        self.task.dp_userInfo = [NSString stringWithFormat:@"%ld", (long)self.matchId];

    };

    if ([DPMemberManager sharedInstance].isLogin) {
        block();
    } else {
        DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
        viewController.finishBlock = block;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     [self.view endEditing:YES];
}

#pragma mark - Keyboard Notification

- (void)keyboardFrameChanged:(NSNotification *)notification {
    static const NSInteger kConverTag = 12345;
    NSDictionary *userInfo = notification.userInfo;

    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    UIView *commentView = [self.tableControllers.firstObject commentView];

    if (CGRectGetMaxY(endFrame) == CGRectGetMaxY([[UIScreen mainScreen] bounds]) && ![self.view viewWithTag:kConverTag]) {
        UIView *converView = [[UIView alloc] initWithFrame:self.view.bounds];
        converView.tag = kConverTag;
        converView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        converView.alpha = 0;
        [self.view addSubview:converView];
        [self.view bringSubviewToFront:commentView];

        [UIView animateWithDuration:0.25
                         animations:^{
                             converView.alpha = 1;
                         }];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        @weakify(self, converView);
        [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self, converView);

            [self.view endEditing:YES];
            [UIView animateWithDuration:0.2
                animations:^{
                    converView.alpha = 0;
                }
                completion:^(BOOL finished) {
                    [converView removeFromSuperview];
                }];

        }];
        [converView addGestureRecognizer:tapGesture];
    }

    if (keyboardY == screenHeight && [self.view viewWithTag:kConverTag]) {
        [UIView animateWithDuration:0.2
            animations:^{
                [self.view viewWithTag:kConverTag].alpha = 0;
            }
            completion:^(BOOL finished) {
                [[self.view viewWithTag:kConverTag] removeFromSuperview];
            }];
    }

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == commentView && obj.firstAttribute == NSLayoutAttributeBottom) {
            obj.constant = keyboardY - screenHeight;

            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration
                                  delay:0
                                options:curve << 16
                             animations:^{

                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];
            *stop = YES;
        }
    }];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutHeaderAndTabBar];

    if (self.firstLoad) {
        if (self.selectedIndex >= self.tableControllers.count) {
            self.selectedIndex = 0;
        } else {
            // 滚动到指定的位置

            self.tabBar.selectedIndex = self.selectedIndex;
            [self.containerView setContentOffset:CGPointMake(self.selectedIndex * kScreenWidth, 0)];
        }
        self.firstLoad = NO;
    }
}

- (void)layoutHeaderAndTabBar {
    UIScrollView *scrollView = self.tableViews[self.selectedIndex];
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    if (offsetY <= 0) {
        // 向下滚动(偏移)
        if (self.refreshControl.isRefreshing) {
            self.refreshControl.frame = CGRectMake(0, -offsetY, kScreenWidth, kRefreshHeight);
        } else {
            self.refreshControl.frame = CGRectMake(0, -offsetY - kRefreshHeight, kScreenWidth, kRefreshHeight);
        }
    } else {
        // 向上滚动(偏移)
        if (self.refreshControl.isRefreshing) {
            self.refreshControl.frame = CGRectMake(0, 0, kScreenWidth, kRefreshHeight);
        } else {
            self.refreshControl.frame = CGRectMake(0, -kRefreshHeight, kScreenWidth, kRefreshHeight);
        }
    }

    self.headerView.frame = CGRectMake(0, CGRectGetMaxY(self.refreshControl.frame), kScreenWidth, kHeaderHeight);
    self.tabBar.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, kTabBarHeight);

    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.tabBar.frame), 0, 0, 0);
}

- (void)setupProperty {
}

- (void)setupViewConstraints {
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

#pragma mark - Override

#pragma mark - User Interaction

#pragma mark - Delegate

#pragma mark - DPTabBarDelegate

- (void)tabBar:(DPTabBar *)tabBar didSelectItem:(DPTabBarItem *)item {
    self.selectedIndex = tabBar.selectedIndex;

    DPDataCenterTableController *tableController = self.tableControllers[self.selectedIndex];
    [tableController requestIfNeeded];
    [self.containerView setContentOffset:CGPointMake(CGRectGetWidth(self.containerView.bounds) * tabBar.selectedIndex, 0) animated:YES];
}

#pragma mark - DPDataCenterTableController

- (void)requestDidStart:(DPDataCenterTableController *)controller {
    self.view.userInteractionEnabled = NO;
    [self showHUD];
}

- (void)requestDidFinish:(DPDataCenterTableController *)controller error:(NSError *)error {
    self.view.userInteractionEnabled = YES;

    self.refreshControl.refreshState = DPDataCenterRefreshStateStopped;

    UIEdgeInsets contentInset = UIEdgeInsetsMake(kHeaderHeight + kTabBarHeight, 0, 0, 0);
    UIScrollView *scrollView = self.tableViews[self.selectedIndex];

    // 防止抖动
    [UIView animateWithDuration:0.2
                     animations:^{
                         //                         [scrollView setContentOffset:CGPointMake(0, -contentInset.top) animated:NO];
                         [scrollView setContentInset:contentInset];

                     }];

    [self dismissHUD];

    [self reach];
}

#pragma mark - 检测网络连接
- (void)reach {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [[DPToast makeText:@"当前网络不可用"] show];
    }
}
#pragma mark - UIScrollViewDelegate
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSAssert(scrollView == self.containerView, @"failure...");

    self.commitViewLeft.mas_equalTo(-scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSAssert(scrollView == self.containerView, @"failure...");

    NSUInteger numberOfViewControllers = self.tableViews.count;
    NSInteger newSelectedIndex = round(scrollView.contentOffset.x / scrollView.contentSize.width * numberOfViewControllers);
    newSelectedIndex = MIN(numberOfViewControllers - 1, MAX(0, newSelectedIndex));
    if (self.selectedIndex != newSelectedIndex) {
        self.tabBar.selectedIndex = newSelectedIndex;
        self.selectedIndex = newSelectedIndex;

        DPDataCenterTableController *tableController = self.tableControllers[self.selectedIndex];
        [tableController requestIfNeeded];
    }
}

#pragma mark - Properties (getter, setter)

- (DPDataCenterRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl = [[DPDataCenterRefreshControl alloc] init];
    }
    return _refreshControl;
}

@end
