//
//  列表区赋值
//  DacaiProject
//
//  Created by WUFAN on 14-6-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAlterViewController.h"
#import "DPBetToggleControl.h"
#import "DPCollapseTableView.h"
#import "DPJczqAnalysisCell.h"
#import "DPJczqBuyCell.h"
#import "DPJczqBuyViewController.h"

#import "DPBetToggleControl.h"
#import "DPDataCenterViewController.h"
#import "DPDropDownList.h"
#import "DPJczqDataModel.h"
#import "DPJczqTransferViewController.h"
#import "DPJingCaiMoreView.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "KTMUserDefaults+Jackpot.h"
#import "SVPullToRefresh.h"

typedef NS_ENUM(NSInteger, JczqIndex) {
    JczqIndexJcHt,       //混投
    JczqIndexJcSpf,      //胜平负
    JczqIndexJcRqspf,    //让球胜平负
    JczqIndexJcBf,       //比分
    JczqIndexJcZjq,      //总进球
    JczqIndexJcBqc,      //半全场
    JczqIndexJcDg        //单关
};

@interface DPJczqBuyViewController () <
    DPJczqBuyCellDelegate, DPCollapseTableViewDelegate,
    DPCollapseTableViewDataSource, DPNavigationMenuDelegate,
    UIGestureRecognizerDelegate, DPDropDownListDelegate> {
@private

    DPCollapseTableView *_tableView;
    UIView *_bottomView;
    UILabel *_promptLabel;

    NSMutableSet *_collapseSections;
    DPNavigationMenu *_menu;

    DPNavigationTitleButton *_titleButton;

    NSLayoutConstraint *_tableViewConstraint;
    UIButton *_showAllButon;    //显示全部比赛

    PBMJczqBuy *_dataBase;
    PBMJczqBuy *_currentData;

    NSMutableSet *_completionsSet;    //赛事列表
    NSMutableSet *_rqsSet;            //让球列表, 非让球胜平负玩法忽略该参数
}

@property (nonatomic, strong) NSMutableArray *alertCache;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;                      //底部
@property (nonatomic, strong, readonly) UILabel *promptLabel;                    //底部文字
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;                  //彩种标题栏
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;    //彩种标题
@property (nonatomic, strong) NSMutableArray *competitionList;                   //筛选-赛事选择
@property (nonatomic, strong) NSMutableArray *rqsList;                           //筛选-让球
//@property(nonatomic,strong)DPJczqBuyCell *jczqCell;
@property (nonatomic, strong) NSMutableDictionary *analysisDic;
@property (nonatomic, strong, readonly) NSLayoutConstraint *tableViewConstraint;
@property (nonatomic, strong, readonly) UIButton *showAllButon;    //显示全部比赛
@property (nonatomic, copy) NSString *gameTime;
@property (nonatomic, assign) BOOL showNightStopWindow;
@end

@implementation DPJczqBuyViewController
@dynamic tableView;
@dynamic bottomView;
@dynamic promptLabel;
@dynamic menu;
@synthesize commands = _commands;
@synthesize tableViewConstraint = _tableViewConstraint;

- (instancetype)init {
    if (self = [super init]) {
        _alertCache = [NSMutableArray arrayWithCapacity:6];
        _collapseSections = [NSMutableSet setWithCapacity:10];
        _competitionList = [NSMutableArray array];
        _rqsList = [NSMutableArray array];

        _currentData = [PBMJczqBuy message];

        _completionsSet = [[NSMutableSet alloc] init];
        _rqsSet = [[NSMutableSet alloc] init];

        self.gameType = GameTypeJcHt;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 重置页面数据
    [self filterDataWithGameType:self.gameType];
    [self.navigationController dp_applyGlobalTheme];

    if (self.gameIndex == 6) {
        self.tableViewConstraint.constant = -30;
    } else {
        self.tableViewConstraint.constant = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self buildLayout];
    [self showHUD];

    // 导航按钮. pop
    self.titleButton.titleText = self.menu.items[self.gameIndex];
    self.navigationItem.titleView = self.titleButton;

    self.navigationItem.leftBarButtonItem =
        [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png")
                                   target:self
                                   action:@selector(pvt_onBack)];

    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *filterItem =
            [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png")
                                       target:self
                                       action:@selector(pvt_onFilter)];
        UIBarButtonItem *moreItem =
            [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png")
                                       target:self
                                       action:@selector(pvt_onMore)];
        @[ moreItem, filterItem ];
    });

    [self showHUD];
    [self getDataFromeNet];

    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getDataFromeNet];
    }];
    //  请求数据

    self.analysisDic = [NSMutableDictionary dictionary];
}

// 样式布局. pop
- (void)buildLayout {
    UIView *contentView = self.view;

    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.showAllButon];
    [contentView addSubview:self.tableView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@44);
    }];

    [self.showAllButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.height.equalTo(@36);
        make.left.and.right.equalTo(contentView);

    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    [cleanupButton
        setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath,
                                                           @"delete001_21.png")]
        forState:UIControlStateNormal];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image =
        [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath,
                                                  @"sumit001_24.png")];
    UIView *lineView = [UIView
        dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];

    // config control
    confirmButton.backgroundColor = [UIColor dp_flatRedColor];

    // bind event
    [cleanupButton addTarget:self
                      action:@selector(pvt_onCleanup)
            forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self
                      action:@selector(pvt_onConfirm)
            forControlEvents:UIControlEventTouchUpInside];

    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.promptLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = [UIColor dp_flatWhiteColor];
    infoLabel.font = [UIFont dp_systemFontOfSize:9];
    infoLabel.text = @"页面赔率仅供参考，请以出票为准";
    [contentView addSubview:infoLabel];

    // layout
    [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.width.equalTo(@50);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.left.equalTo(cleanupButton.mas_right);
        make.right.equalTo(contentView);
    }];

    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.bottom.equalTo(confirmButton.mas_centerY);
    }];

    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton).offset(10);
        make.top.equalTo(contentView.mas_centerY).offset(5);

    }];

    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmButton).offset(-20);
        make.centerY.equalTo(confirmButton);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark -获取网络数据
- (void)getDataFromeNet {
    [[AFHTTPSessionManager dp_sharedManager] GET:@"jczq/buy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            self.tableView.emptyDataView.requestSuccess = YES;
            _dataBase = [PBMJczqBuy parseFromData:responseObject error:nil];
            [self filterDataWithGameType:self.gameType];

            // 判断是否需要提示弹框
            [self showAlertIfNeeded];
            // 重载数据
            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {

            [self dismissHUD];

            self.tableView.emptyDataView.requestSuccess = NO;
            [self.tableView reloadData];

            NSLog(@"%@", error);
            [self.tableView.pullToRefreshView stopAnimating];
        }];
}

#pragma mark - 根据筛选条件进行数据筛选
- (void)filterDataWithGameType:(GameTypeId)type completion:(NSSet *)completions rqs:(NSSet *)rqs {
    [_currentData.gamesArray removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    // 从给定是数据集合中筛选赛事. pop
    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJczqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJczqGame *cGame = [PBMJczqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJczqMatch *match = [game.matchesArray objectAtIndex:j];

            switch (type) {
                case GameTypeJcHt:
                case GameTypeJcDgAll: {
                    if ([completions containsObject:match.competitionName] && [rqs containsObject:[NSNumber numberWithLongLong:match.rqs]]) {
                        [cMatchArray addObject:match];
                    }

                } break;
                case GameTypeJcSpf: {
                    if (match.spfItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeJcRqspf: {
                    if (match.rqspfItem.gameVisible && [completions containsObject:match.competitionName] && [rqs containsObject:[NSNumber numberWithLongLong:match.rqs]]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeJcBf: {
                    if (match.bfItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeJcZjq: {
                    if (match.zjqItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeJcBqc: {
                    if (match.bqcItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;

                case GameTypeJcDg: {
                    if (((match.spfItem.gameVisible && match.spfItem.supportSingle) ||
                         (match.rqspfItem.gameVisible && match.rqspfItem.supportSingle)) &&
                        [completions containsObject:match.competitionName] && [rqs containsObject:[NSNumber numberWithLongLong:match.rqs]]) {
                        [cMatchArray addObject:match];
                    }

                } break;
                default:
                    break;
            }
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;
            cGame.gameStatusId = game.gameStatusId;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }
    [self pvt_updatePrompt];
    [self.tableView closeAllCells];

    [self.tableView reloadData];
}

/**
 *  数据筛选
 *
 *  @param type 彩种
 */
#pragma mark - 原始数据筛选
- (void)filterDataWithGameType:(GameTypeId)type {
    [_currentData.gamesArray removeAllObjects];
    [_completionsSet removeAllObjects];
    [_rqsSet removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    // 重置数据源.
    // 生成对应玩法的数据源(赛事集合, 让球数集合).  pop
    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJczqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJczqGame *cGame = [PBMJczqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJczqMatch *match = [game.matchesArray objectAtIndex:j];

            switch (type) {
                case GameTypeJcHt:
                case GameTypeJcDgAll: {
                    [cMatchArray addObject:match];
                    [_completionsSet addObject:match.competitionName];
                    [_rqsSet addObject:[NSNumber numberWithLongLong:match.rqs]];
                } break;
                case GameTypeJcSpf: {
                    if (match.spfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeJcRqspf: {
                    if (match.rqspfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                        [_rqsSet addObject:[NSNumber numberWithLongLong:match.rqs]];
                    }
                } break;
                case GameTypeJcBf: {
                    if (match.bfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeJcZjq: {
                    if (match.zjqItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeJcBqc: {
                    if (match.bqcItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;

                case GameTypeJcDg: {
                    if ((match.spfItem.gameVisible && match.spfItem.supportSingle) ||
                        (match.rqspfItem.gameVisible && match.rqspfItem.supportSingle)) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                        [_rqsSet addObject:[NSNumber numberWithLongLong:match.rqs]];
                    }

                } break;
                default:
                    break;
            }
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;
            cGame.gameStatusId = game.gameStatusId;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }

    [self pvt_reloadFilterInfo];
    [self pvt_updatePrompt];
    [self.tableView closeAllCells];

    [self.tableView reloadData];
}

#pragma mark - getter, setter

//彩种标题
- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc]
            initWithFrame:CGRectMake(0, 0, 110, 44)];
        [_titleButton
            addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                             action:@selector(pvt_onExpandNav)]];
    }
    return _titleButton;
}

//标题选择栏
- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.itemsImage = @[
            @"hh.png",
            @"sfp.png",
            @"rq.png",
            @"bf.png",
            @"zjq.png",
            @"bqc.png",
            @"jcdg.png"
        ];

        _menu.items = @[
            @"混合过关",
            @"胜平负",
            @"让球胜平负",
            @"比分",
            @"总进球",
            @"半全场",
            @"单关固定"
        ];
    }
    return _menu;
}

//设置彩种类型
- (void)setGameType:(GameTypeId)gameType {
    _gameType = gameType;

    switch (gameType) {
        case GameTypeJcSpf:
            _gameIndex = JczqIndexJcSpf;
            break;
        case GameTypeJcHt:
            _gameIndex = JczqIndexJcHt;
            break;
        case GameTypeJcRqspf:
            _gameIndex = JczqIndexJcRqspf;
            break;
        case GameTypeJcBf:
            _gameIndex = JczqIndexJcBf;
            break;
        case GameTypeJcBqc:
            _gameIndex = JczqIndexJcBqc;
            break;
        case GameTypeJcZjq:
            _gameIndex = JczqIndexJcZjq;
            break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            _gameIndex = JczqIndexJcDg;
            break;
        default:
            DPAssert(NO);
            break;
    }
}

/**
 *  设置玩法. pop
 *
 *  @param gameIndex [in]导航栏的索引
 */
- (void)setGameIndex:(int)gameIndex {
    _gameIndex = gameIndex;

    switch (gameIndex) {
        case JczqIndexJcHt:
            _gameType = GameTypeJcHt;
            break;
        case JczqIndexJcSpf:
            _gameType = GameTypeJcSpf;
            break;
        case JczqIndexJcRqspf:
            _gameType = GameTypeJcRqspf;
            break;
        case JczqIndexJcBf:
            _gameType = GameTypeJcBf;
            break;
        case JczqIndexJcBqc:
            _gameType = GameTypeJcBqc;
            break;
        case JczqIndexJcZjq:
            _gameType = GameTypeJcZjq;
            break;

        case JczqIndexJcDg: {
            _gameType = self.showAllButon.selected ? GameTypeJcDgAll : GameTypeJcDg;
        } break;
        default:
            DPAssert(NO);
            break;
    }
}

//底部view
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
//
- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor dp_flatBackgroundColor];

        DZNEmptyDataView *recomEmpty = [[DZNEmptyDataView alloc] init];
        recomEmpty.textForNoData = @"暂无数据";
        recomEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png");

        _tableView.emptyDataView = recomEmpty;
        _tableView.emptyDataView.showButtonForNoData = NO;
        @weakify(self);

        _tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type) {
            @strongify(self);
            if (type == DZNEmptyDataViewTypeNoNetwork) {
                [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
            } else if (type == DZNEmptyDataViewTypeFailure) {
                [self showHUD];
                [self getDataFromeNet];
            }
        };
    }
    return _tableView;
}

- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _promptLabel;
}

- (NSLayoutConstraint *)tableViewConstraint {
    if (_tableViewConstraint == nil) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.tableView &&
                constraint.firstAttribute == NSLayoutAttributeBottom) {
                _tableViewConstraint = constraint;
                break;
            }
        }
    }
    return _tableViewConstraint;
}

- (UIButton *)showAllButon {
    if (_showAllButon == nil) {
        _showAllButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showAllButon setTitle:@" 显示全部比赛" forState:UIControlStateNormal];
        [_showAllButon setImage:dp_CommonImage(@"uncheck.png")
                       forState:UIControlStateNormal];
        [_showAllButon setImage:dp_CommonImage(@"check@2x.png")
                       forState:UIControlStateSelected];
        [_showAllButon setTitleColor:UIColorFromRGB(0x968E82)
                            forState:UIControlStateNormal];
        _showAllButon.titleLabel.font = [UIFont dp_systemFontOfSize:16];
        _showAllButon.backgroundColor = [UIColor dp_flatWhiteColor];
        [_showAllButon addTarget:self
                          action:@selector(pvt_ShowAll:)
                forControlEvents:UIControlEventTouchUpInside];
        _showAllButon.selected = NO;

        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.88 alpha:1].CGColor;
        layer.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
        [_showAllButon.layer addSublayer:layer];
    }

    return _showAllButon;
}

#pragma mark -  清空所选赛事
- (void)pvt_onCleanup {
    [self cleanAllSelect];
    [self.tableView reloadData];
}

- (void)cleanAllSelect {
    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            [match.matchOption initializeOptionWithType:self.gameType];
        }
    }

    [self pvt_updatePrompt];
}
//完成提交中转界面
- (void)pvt_onConfirm {
    int count = 0;
    int danCount = 0;

    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:self.gameType]) {
                count += 1;
                if ([match isSelectedAllSignalWithType:self.gameType])
                    danCount += 1;
            }
        }
    }
    if (self.gameType == GameTypeJcBf) {
        if (count == 0) {
            [[DPToast makeText:@"请选择比赛"] show];
            return;
        }
    } else {
        if (danCount < 1 && (count < 2)) {
            if (self.gameType == GameTypeJcDgAll || self.gameType == GameTypeJcDg || count < 1) {
                [[DPToast makeText:@"请选择比赛"] show];
            } else
                [[DPToast makeText:@"请至少选择2场比赛"] show];
            return;
        }
    }
    if (count > 15) {
        [[DPToast makeText:@"最多选择15场比赛"] show];
        return;
    }

    NSMutableArray *orderNumbers = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchs].count];
    for (PBMJczqMatch *match in [self getSelectedMatchs]) {
        [orderNumbers addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    GameTypeId typeGame = (self.gameType == GameTypeJcDg || self.gameType == GameTypeJcDgAll) ? GameTypeJcHt : self.gameType;

    NSString *urlStr = [NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%@&gameTypeId=%d", [orderNumbers componentsJoinedByString:@","], typeGame];

    @weakify(self);
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        DPJczqTransferViewController *viewController =
            [[DPJczqTransferViewController alloc] init];
        viewController.gameType = self.gameType;
        viewController.matchsArray = [self getSelectedMatchs];
        [self.navigationController pushViewController:viewController animated:YES];

    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

// 获取选中的比赛. pop
- (NSMutableArray *)getSelectedMatchs {
    NSMutableArray *matchsArr = [[NSMutableArray alloc] init];

    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            match.dpGameId = (int)game.gameId;
            if ([match getSelectedTypeArrWithType:self.gameType].count) {
                [matchsArr addObject:match];
            }
        }
    }

    return matchsArr;
}

//列表区点击事件
- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    [_collapseSections dp_turnObject:@(tapRecognizer.view.tag)];
    [self.tableView reloadData];
}
//列表区赋值
- (NSString *)pvt_titleForSection:(NSInteger)section {
    PBMJczqGame *game = [[_currentData gamesArray] objectAtIndex:section];

    NSUInteger numberOfRows = game.matchesArray.count;

    if (!game || numberOfRows <= 0) {
        return @"";
    }

    NSString *dateString = game.gameName;
    NSDate *date = [NSDate dp_dateFromString:dateString
                                  withFormat:dp_DateFormatter_yyyy_MM_dd];
    dateString = [date dp_stringWithFormat:@"yyyy年MM月dd日"];
    self.gameTime = [date dp_stringWithFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];

    return [NSString stringWithFormat:@"%@ %@   %lu场比赛可投", dateString,
                                      [date dp_weekdayName], (unsigned long)numberOfRows];
}
//点击彩种展开彩种类型
- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.gameIndex];
    [self.menu show];
}

- (void)pvt_onBack {
    int count = 0;
    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:self.gameType]) {
                count += 1;
            }
        }
    }

    if (count <= 0) {
        if (self.navigationController.viewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容, 是否继续?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    @weakify(self, alertView);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self, alertView);
        if (buttonIndex.integerValue != alertView.cancelButtonIndex) {
            if (self.navigationController.viewControllers.firstObject == self) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [alertView show];
}

#pragma mark - 过滤点击事件
- (void)pvt_onFilter {
    if (_rqsSet.count == 0 && _completionsSet.count == 0) {
        return;
    }

    NSMutableArray *titlesArr = [[NSMutableArray alloc] init];
    NSMutableArray *groupsArr = [[NSMutableArray alloc] init];

    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];

    NSArray *sortDesc = @[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ];

    NSArray *competitionsList = [_completionsSet sortedArrayUsingDescriptors:sortDesc];

    if (self.gameType == GameTypeJcRqspf || self.gameType == GameTypeJcHt ||
        self.gameType == GameTypeJcDg || self.gameType == GameTypeJcDgAll) {
        NSArray *rqsArr = [_rqsSet sortedArrayUsingDescriptors:sortDesc];

        NSMutableArray *rqsList = [NSMutableArray arrayWithCapacity:rqsArr.count];

        for (int i = 0; i < rqsArr.count; i++) {
            int num = [[rqsArr objectAtIndex:i] intValue];
            if (num > 0) {
                [rqsList addObject:[NSString stringWithFormat:@"客让%d球", num]];
            } else
                [rqsList addObject:[NSString stringWithFormat:@"主让%d球", -num]];
        }

        [titlesArr addObject:@"让球选择"];
        [groupsArr addObject:rqsList];
        [selectedArr addObject:[self.rqsList mutableCopy]];
    }

    [titlesArr addObject:@"赛事选择"];
    [groupsArr addObject:competitionsList];
    [selectedArr addObject:[self.competitionList mutableCopy]];

    DPSportFilterView *filterView = [[DPSportFilterView alloc]
        initWithGroupTitles:titlesArr
                   allGroup:groupsArr
                selectGroup:selectedArr];
    filterView.reloadFilter = ^(NSArray *selectedGroups) {
        NSMutableArray *competitionList = nil;
        NSMutableArray *rqsList = nil;

        if (selectedGroups.count == 1) {
            competitionList = [selectedGroups firstObject];
        } else if (selectedGroups.count == 2) {
            rqsList = [selectedGroups firstObject];
            competitionList = [selectedGroups lastObject];
        }
        [self.competitionList removeAllObjects];
        [self.rqsList removeAllObjects];
        [self.competitionList addObjectsFromArray:competitionList];
        [self.rqsList addObjectsFromArray:rqsList];

        [self pvt_resetFilterInfo];

    };
    [self dp_showViewController:filterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}
- (void)pvt_ShowAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.gameType = sender.selected ? GameTypeJcDgAll : GameTypeJcDg;

    [self filterDataWithGameType:self.gameType];
}

#pragma mark - 菜单

//更多菜单
- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];

    DPDropDownList *dropDownList = [[DPDropDownList alloc]
        initWithItems:@[ @"开奖公告", @"玩法介绍", @"帮助" ]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];

    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverView).offset(64);
        make.right.equalTo(coverView).offset(-20);
    }];
    [coverView addGestureRecognizer:({
                   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                       initWithTarget:self
                               action:@selector(pvt_onCover:)];
                   tap.delegate = self;
                   tap;
               })];
}

- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (void)pvt_onTapMore:(UITapGestureRecognizer *)tapGestureRecognizer {
    [tapGestureRecognizer.view removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if (![touch.view isMemberOfClass:[UIView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - DPDropDownListDelegate
//更多功能
- (void)dropDownList:(DPDropDownList *)dropDownList selectedAtIndex:(int)index {
    [dropDownList.superview removeFromSuperview];

    UIViewController *viewController;

    switch (index) {
        case 0: {    // 开奖公告
            viewController = ({
                DPResultListViewController *viewController =
                    [[DPResultListViewController alloc] init];
                viewController.gameType = self.gameType;
                viewController.isFromClickMore = YES;
                //                viewController.gameTime =  self.gameTime;
                viewController;
            });
        } break;
        case 1: {    // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc]
                    initWithURL:[NSURL URLWithString:kJcPlayIntroduceURL]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO;

                viewController;
            });
        } break;
        case 2: {    // 帮助
            viewController = [[DPWebViewController alloc] init];
            DPWebViewController *webCtrl = (DPWebViewController *)viewController;
            webCtrl.requset =
                [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpCenterURL]];
        } break;
        default:
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int section = MAX(0, (int)_currentData.gamesArray.count);

    return section;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }

    return MAX(0, ((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:section])
                      .matchesArray.count);
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView dp_viewWithColor:[UIColor colorWithWhite:1 alpha:0.8]];
    view.tag = section;

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.82 alpha:1];
    line1.userInteractionEnabled = NO;
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.82 alpha:1];
    line2.userInteractionEnabled = NO;

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    label.text = [self pvt_titleForSection:section];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[_collapseSections containsObject:@(section)] ? dp_CommonImage(@"black_arrow_down.png") : dp_CommonImage(@"black_arrow_up.png")];

    [view addSubview:label];
    [view addSubview:line1];
    [view addSubview:line2];
    [view addSubview:imageView];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-55);
    }];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                           action:@selector(pvt_onHeaderTap:)]];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMJczqMatch *match = [((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:indexPath.section]).matchesArray objectAtIndex:indexPath.row];

    JczqOption option;
    switch (self.gameType) {
        case GameTypeJcHt:
            option = match.matchOption.htOption;
            break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            option = match.matchOption.dgOption;
            break;
        default:
            option = match.matchOption.normalOption;
            break;
    }

    //单关固定
    if (self.gameType == GameTypeJcDg || self.gameType == GameTypeJcDgAll) {
        BOOL spfVisible = match.spfItem.supportSingle;        //胜平负是否支持单关
        BOOL rqspfVisible = match.rqspfItem.supportSingle;    //让球胜平负是否支持单关

        DPJczqBuyCell *cell = nil;
        if ((spfVisible && !rqspfVisible) || (!spfVisible && rqspfVisible)) {
            NSString *CellIdentifier;
            if ((spfVisible && !rqspfVisible)) {
                CellIdentifier = @"DanGuanSingleSpf";
            } else {
                CellIdentifier = @"DanGuanSingleRqspf";
            }

            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPJczqBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.gameType = self.gameType;

                if ([CellIdentifier isEqualToString:@"DanGuanSingleSpf"]) {
                    [cell buildLayoutWithSingleCell:-1];
                } else
                    [cell buildLayoutWithSingleCell:1];
            }

            if (spfVisible) {
                cell.spfLabel.text = @"0";
                cell.spfLabel.textColor = [UIColor dp_flatWhiteColor];
                cell.spfLabel.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
                cell.spfLabel.layer.borderWidth = 0;

                for (int i = 0; i < cell.optionButtonsSpf.count; i++) {
                    DPBetToggleControl *control = cell.optionButtonsSpf[i];
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.spfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betSpf[i];
                    control.titleColor = [UIColor dp_flatBlackColor];
                    cell.stopCellspf.hidden = YES;
                }

            } else {
                cell.spfLabel.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];
                cell.spfLabel.textColor = match.rqs > 0 ? [UIColor dp_flatRedColor]
                                                        : [UIColor dp_flatBlueColor];
                cell.spfLabel.backgroundColor =
                    [UIColor colorWithRed:1
                                    green:0.71
                                     blue:0.15
                                    alpha:1];
                cell.spfLabel.layer.borderWidth = 0;

                for (int i = 0; i < cell.optionButtonsSpf.count; i++) {
                    DPBetToggleControl *control = cell.optionButtonsSpf[i];
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.rqspfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betRqspf[i];
                    control.titleColor = [UIColor dp_flatBlackColor];
                    cell.stopCellspf.hidden = YES;
                }
            }

        } else {
            NSString *CellIdentifier = @"DanGuanDouble";

            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DPJczqBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.gameType = self.gameType;

                [cell buildLayoutWithSingleCell:NO];
            }

            cell.spfLabel.text = @"0";
            if (spfVisible) {
                cell.spfLabel.textColor = [UIColor dp_flatWhiteColor];
                cell.spfLabel.backgroundColor =
                    [UIColor colorWithRed:0
                                    green:0.67
                                     blue:0.51
                                    alpha:1];
                cell.spfLabel.layer.borderWidth = 0;
            }
            cell.rqspfLabel.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];

            if (rqspfVisible) {
                cell.rqspfLabel.textColor = match.rqs > 0 ? [UIColor dp_flatRedColor]
                                                          : [UIColor dp_flatBlueColor];

                cell.rqspfLabel.backgroundColor =
                    [UIColor colorWithRed:1
                                    green:0.71
                                     blue:0.15
                                    alpha:1];
                cell.rqspfLabel.layer.borderWidth = 0;
            }

            for (int i = 0; i < cell.optionButtonsSpf.count; i++) {
                DPBetToggleControl *control = cell.optionButtonsSpf[i];
                if (spfVisible) {
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.spfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betSpf[i];
                    control.titleColor = [UIColor dp_flatBlackColor];
                    cell.stopCellspf.hidden = YES;

                } else {
                    cell.stopCellspf.hidden = NO;
                    control.userInteractionEnabled = NO;
                    control.titleColor =
                        [UIColor colorWithRed:0.75
                                        green:0.72
                                         blue:0.62
                                        alpha:1.0];
                    control.backgroundColor =
                        [UIColor colorWithRed:0.94
                                        green:0.91
                                         blue:0.86
                                        alpha:1.0];
                    control.oddsText = @"";
                    cell.stopCellspf.text = @"该玩法不支持单关固定";
                    cell.stopCellspf.backgroundColor = [UIColor dp_flatWhiteColor];
                }
            }

            for (int i = 0; i < cell.optionButtonsRqspf.count; i++) {
                DPBetToggleControl *control = cell.optionButtonsRqspf[i];
                if (rqspfVisible) {
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.rqspfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betRqspf[i];
                    control.titleColor = [UIColor dp_flatBlackColor];
                    cell.stopCellLabel.hidden = YES;
                } else {
                    cell.stopCellLabel.hidden = NO;
                    control.userInteractionEnabled = NO;
                    control.titleColor =
                        [UIColor colorWithRed:0.75
                                        green:0.72
                                         blue:0.62
                                        alpha:1.0];
                    control.backgroundColor =
                        [UIColor colorWithRed:0.94
                                        green:0.91
                                         blue:0.86
                                        alpha:1.0];
                    control.oddsText = @"";

                    cell.stopCellLabel.text = @"该玩法不支持单关固定";
                    cell.stopCellLabel.backgroundColor = [UIColor dp_flatWhiteColor];
                }
            }
        }

        cell.competitionLabel.text = match.competitionName;
        cell.orderNameLabel.text = match.orderNumberName;
        cell.matchDateLabel.text = [NSDate dp_coverDateString:match.endTime
                                                   fromFormat:@"yyyy-MM-dd HH:mm:ss"
                                                     toFormat:@"HH:mm截止"];

        cell.homeNameLabel.text = match.homeTeamName;
        cell.awayNameLabel.text = match.awayTeamName;
        cell.analysisView.highlighted =
            [self.tableView isExpandAtModelIndex:indexPath];

        if (match.homeTeamRank.length && match.awayTeamRank.length) {
            cell.homeRankLabel.text =
                [NSString stringWithFormat:@"[%@]", match.homeTeamRank];
            cell.awayRankLabel.text =
                [NSString stringWithFormat:@"[%@]", match.awayTeamRank];
        } else {
            cell.homeRankLabel.text = @"";
            cell.awayRankLabel.text = @"";
        }
        cell.hotView.hidden = !match.isHot;

        BOOL moreBtnSelected = NO;
        for (int i = 0; i < 31; i++) {
            if (option.betBf[i] >= 1) {
                moreBtnSelected = YES;
                break;
            }
        }
        if (moreBtnSelected == NO) {
            for (int i = 0; i < 9; i++) {
                if (option.betBqc[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
        }
        if (moreBtnSelected == NO) {
            for (int i = 0; i < 8; i++) {
                if (option.betZjq[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
        }
        cell.moreButton.selected = moreBtnSelected;

        return cell;
    }

    //除单关固定其他玩法
    NSString *CellIdentifier =
        [NSString stringWithFormat:@"BuyCell%d", self.gameIndex];

    DPJczqBuyCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = self.gameType;

        [cell buildLayout];
    }

    cell.competitionLabel.text = match.competitionName;
    cell.orderNameLabel.text = match.orderNumberName;
    cell.matchDateLabel.text = [NSDate dp_coverDateString:match.endTime
                                               fromFormat:@"yyyy-MM-dd HH:mm:ss"
                                                 toFormat:@"HH:mm截止"];

    cell.homeNameLabel.text = match.homeTeamName;
    cell.awayNameLabel.text = match.awayTeamName;
    cell.analysisView.highlighted =
        [self.tableView isExpandAtModelIndex:indexPath];
    cell.middleLabel.text = @"VS";
    cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];

    if (match.homeTeamRank.length && match.awayTeamRank.length) {
        cell.homeRankLabel.text =
            [NSString stringWithFormat:@"[%@]", match.homeTeamRank];
        cell.awayRankLabel.text =
            [NSString stringWithFormat:@"[%@]", match.awayTeamRank];
    } else {
        cell.homeRankLabel.text = @"";
        cell.awayRankLabel.text = @"";
    }
    //是否热门赛事
    cell.hotView.hidden = !match.isHot;
    switch (self.gameType) {
        case GameTypeJcHt: {
            //是否支持投注
            BOOL isVisible1 = match.spfItem.gameVisible;
            BOOL isVisible2 = match.rqspfItem.gameVisible;

            BOOL moreBtnSelected = NO;
            for (int i = 0; i < 31; i++) {
                if (option.betBf[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 9; i++) {
                    if (option.betBqc[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 8; i++) {
                    if (option.betZjq[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            cell.moreButton.selected = moreBtnSelected;
            cell.spfLabel.text = @"0";
            if (isVisible1) {
                cell.spfLabel.textColor = [UIColor dp_flatWhiteColor];
                cell.spfLabel.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
                cell.spfLabel.layer.borderWidth = 0;
            } else {
                cell.spfLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];

                cell.spfLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                cell.spfLabel.layer.borderColor = [UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0]
                                                      .CGColor;
                cell.spfLabel.layer.borderWidth = 1;
            }
            cell.rqspfLabel.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];

            if (isVisible2) {
                cell.rqspfLabel.textColor = match.rqs > 0 ? [UIColor dp_flatRedColor]
                                                          : [UIColor dp_flatBlueColor];

                cell.rqspfLabel.backgroundColor = [UIColor colorWithRed:1 green:0.71 blue:0.15 alpha:1];
                cell.rqspfLabel.layer.borderWidth = 0;

            } else {
                cell.rqspfLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];

                cell.rqspfLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                cell.rqspfLabel.layer.borderColor = [UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
                cell.rqspfLabel.layer.borderWidth = 1;
            }

            cell.htSpfDGView.hidden = !match.spfItem.supportSingle;
            cell.htRqDGView.hidden = !match.rqspfItem.supportSingle;

        } break;
        case GameTypeJcSpf: {
            cell.otherDGView.hidden = !match.spfItem.supportSingle;

        } break;
        case GameTypeJcRqspf: {
            cell.middleLabel.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];
            cell.middleLabel.textColor =
                match.rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
            cell.otherDGView.hidden = !match.rqspfItem.supportSingle;

        } break;
        case GameTypeJcBf: {
            NSArray *array = [NSArray
                arrayWithObjects:@"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0",
                                 @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
                                 @"0:0", @"1:1", @"2:2", @"3:3", @"平其他", @"0:1",
                                 @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4",
                                 @"2:4", @"0:5", @"1:5", @"2:5", @"负其他", nil];

            [self upDataJcBfBqcDataCell:cell
                                  array:array
                                 target:option.betBf
                                  title:@"比分投注"
                         divisionString:@"  "];
            cell.otherDGView.hidden = !match.bfItem.supportSingle;
        } break;
        case GameTypeJcZjq:
            cell.otherDGView.hidden = !match.zjqItem.supportSingle;
            break;
        case GameTypeJcBqc: {
            NSArray *array = [NSArray
                arrayWithObjects:@"胜胜", @"胜平", @"胜负", @"平胜", @"平平",
                                 @"平负", @"负胜", @"负平", @"负负", nil];
            [self upDataJcBfBqcDataCell:cell
                                  array:array
                                 target:option.betBqc
                                  title:@"半全场投注"
                         divisionString:@"  "];
            cell.otherDGView.hidden = !match.bqcItem.supportSingle;
        } break;

        default:
            break;
    }

    for (int i = 0; i < cell.optionButtonsSpf.count; i++) {
        BOOL isVisible = YES;
        if (self.gameType == GameTypeJcHt) {
            isVisible = match.spfItem.gameVisible;
        }
        DPBetToggleControl *control = cell.optionButtonsSpf[i];
        if (isVisible) {
            control.userInteractionEnabled = YES;
            control.oddsText = [match.spfItem.spListArray dp_safeObjectAtIndex:i];
            control.selected = option.betSpf[i];
            control.titleColor = [UIColor dp_flatBlackColor];
            cell.stopCellspf.hidden = YES;

        } else {
            cell.stopCellspf.hidden = NO;
            control.userInteractionEnabled = NO;
            control.oddsText = @"";
        }
    }
    for (int i = 0; i < cell.optionButtonsRqspf.count; i++) {
        BOOL isVisible = YES;
        if (self.gameType == GameTypeJcHt) {
            isVisible = match.rqspfItem.gameVisible;
        }
        DPBetToggleControl *control = cell.optionButtonsRqspf[i];
        if (isVisible) {
            control.userInteractionEnabled = YES;
            control.oddsText = [match.rqspfItem.spListArray dp_safeObjectAtIndex:i];
            control.selected = option.betRqspf[i];
            cell.stopCellLabel.hidden = YES;
        } else {
            cell.stopCellLabel.hidden = NO;
            control.userInteractionEnabled = NO;
            control.oddsText = @"";
        }
    }
    for (int i = 0; i < cell.optionButtonsZjq.count; i++) {
        DPBetToggleControl *control = cell.optionButtonsZjq[i];
        control.oddsText = [match.zjqItem.spListArray dp_safeObjectAtIndex:i];
        control.selected = option.betZjq[i];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeJcHt:
            return 95;
        case GameTypeJcZjq:
            return 87;
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeJcBqc:
        case GameTypeJcBf:
            return 80;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            PBMJczqMatch *match =
                [((PBMJczqGame *)
                      [_currentData.gamesArray objectAtIndex:indexPath.section])
                        .matchesArray objectAtIndex:indexPath.row];

            BOOL spfVisible = match.spfItem.supportSingle;    //是否单关
            BOOL rqspfVisible = match.rqspfItem.supportSingle;

            if ((spfVisible && rqspfVisible) ||
                (!spfVisible && !rqspfVisible && self.showAllButon.selected)) {
                return 55 + 10 + 23 + 2;
            } else {
                return 28 + 10 + 23 + 2;
            }
        }
            return 55 + 10 + 23 + 2;

        default:
            return 0;
    }
}

// 展开的赛事 cell. pop
- (UITableViewCell *)tableView:(UITableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *appendStr = [NSString stringWithFormat:@"%d", (self.gameType == GameTypeJcDgAll || self.gameType == GameTypeJcDg || self.gameType == GameTypeJcHt) ? GameTypeJcHt : self.gameType];

    NSString *CellIdentifier =
        [NSString stringWithFormat:@"AnalysisCell%@", appendStr];
    DPJczqAnalysisCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJczqAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
        cell.gameType = self.gameType;

        @weakify(self);
        [cell setClickBlock:^(DPJczqAnalysisCell *nalysisCell) {
            @strongify(self);
            NSIndexPath *pathIndex = [self.tableView modelIndexForCell:nalysisCell];
            PBMJczqMatch *theMatch = [((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:pathIndex.section]).matchesArray objectAtIndex:pathIndex.row];

            DPDataCenterViewController *viewController = [[DPDataCenterViewController alloc] init];
            viewController.matchId = theMatch.dataMatchId;
            viewController.gameType = GameTypeJcNone;
            viewController.titleString = theMatch.competitionName;
            viewController.selectedIndex = 2;

            MTStringParser *parser = [[MTStringParser alloc] init];
            [parser setDefaultAttributes:({
                        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                        attr.font = [UIFont dp_systemFontOfSize:13];
                        attr.textColor = [UIColor dp_flatBlackColor];
                        attr;
                    })];
            [parser addStyleWithTagName:@"rank" font:[UIFont dp_systemFontOfSize:9] color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
            NSString *homeMarkupText, *awayMarkupText;
            if (theMatch.homeTeamRank.length) {
                homeMarkupText = [NSString stringWithFormat:@"<rank>[%@]</rank>%@", theMatch.homeTeamRank, theMatch.homeTeamName];
            } else {
                homeMarkupText = [NSString stringWithFormat:@"%@", theMatch.homeTeamName];
            }
            if (theMatch.awayTeamRank.length) {
                awayMarkupText = [NSString stringWithFormat:@"%@<rank>[%@]</rank>", theMatch.awayTeamName, theMatch.awayTeamRank];
            } else {
                awayMarkupText = [NSString stringWithFormat:@"%@", theMatch.awayTeamName];
            }

            viewController.homeTeamName = [parser attributedStringFromMarkup:homeMarkupText];
            viewController.awayTeamName = [parser attributedStringFromMarkup:awayMarkupText];
            [self.navigationController pushViewController:viewController animated:YES];

        }];
    }
    [cell clearAllData];

    PBMJczqMatch *match = [((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:indexPath.section]).matchesArray objectAtIndex:indexPath.row];

    cell.rqs.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];

    //获取数据中心的数据
    [self finishDPJczqAnalysisCellData:indexPath cell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameType == GameTypeJcHt || self.gameType == GameTypeJcDg ||
        self.gameType == GameTypeJcDgAll) {
        return 165;
    }
    if ((self.gameType == GameTypeJcSpf) || (self.gameType == GameTypeJcRqspf)) {
        return 140;
    }
    return 115;
}

#pragma mark - 弹框提示
/**
 *  弹框提示. pop
 */
- (void)showAlertIfNeeded {
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    BOOL needAlertStop = NO;
    switch (self.gameType) {
        case GameTypeJcHt:
            needAlertStop = _dataBase.bfSaleStop && _dataBase.zjqSaleStop && _dataBase.spfSaleStop && _dataBase.rqspfSaleStop && _dataBase.bqcSaleStop;
            break;
        case GameTypeJcZjq:
            needAlertStop = _dataBase.zjqSaleStop;
            break;
        case GameTypeJcBf:
            needAlertStop = _dataBase.bfSaleStop;
            break;
        case GameTypeJcBqc:
            needAlertStop = _dataBase.bqcSaleStop;
            break;
        case GameTypeJcSpf:
            needAlertStop = _dataBase.spfSaleStop;
            break;
        case GameTypeJcRqspf:
            needAlertStop = _dataBase.rqspfSaleStop;
            break;
        default:
            break;
    }

    if (needAlertStop && ![self.alertCache containsObject:@(self.gameType)]) {
        [self.alertCache addObject:@(self.gameType)];
        DPAlterViewController *alertController = [[DPAlterViewController alloc] initWithAlterType:AlterTypeJcStop];
        [self dp_showViewController:alertController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        return;
    }

    KTMUserDefaults *userDefaults = [KTMUserDefaults standardUserDefaults];
    NSDate *date = [NSDate dp_date];
    if (_dataBase.nightStopTicket && (!userDefaults.jczqAlertDate || [date timeIntervalSinceDate:userDefaults.jczqAlertDate] > 60 * 60 * 12)) {
        userDefaults.jczqAlertDate = date;

        DPAlterViewController *alertController = [[DPAlterViewController alloc] initWithAlterType:AlterTypeJcUnGetNoBuy];
        [self dp_showViewController:alertController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        return;
    }
}

#pragma mark - 数据中心赋值
- (void)finishDPJczqAnalysisCellData:(NSIndexPath *)indexPath
                                cell:(DPJczqAnalysisCell *)cell {
    PBMJczqMatch *match = [((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:indexPath.section]).matchesArray objectAtIndex:indexPath.row];

    [cell.activityIndicatorView stopAnimating];

    cell.ratioWinLabel.text = [match.analysis.spfBetRatioArray dp_safeObjectAtIndex:0];
    cell.ratioTieLabel.text = [match.analysis.spfBetRatioArray dp_safeObjectAtIndex:1];
    cell.ratioLoseLabel.text = [match.analysis.spfBetRatioArray dp_safeObjectAtIndex:2];

    cell.rqWinLabel.text = [match.analysis.rqspfBetRatioArray dp_safeObjectAtIndex:0];
    cell.rqTieLabel.text = [match.analysis.rqspfBetRatioArray dp_safeObjectAtIndex:1];
    cell.rqLoseLabel.text = [match.analysis.rqspfBetRatioArray dp_safeObjectAtIndex:2];

    cell.newestWinLabel.text = [match.analysis.avgOddsArray dp_safeObjectAtIndex:0];
    cell.newestTieLabel.text = [match.analysis.avgOddsArray dp_safeObjectAtIndex:1];
    cell.newestLoseLabel.text = [match.analysis.avgOddsArray dp_safeObjectAtIndex:2];

    NSString *homeWin = [match.analysis.homeRecentArray dp_safeObjectAtIndex:0];
    NSString *homeEqual = [match.analysis.homeRecentArray dp_safeObjectAtIndex:1];
    NSString *homeLose = [match.analysis.homeRecentArray dp_safeObjectAtIndex:2];
    NSString *awayWin = [match.analysis.awayRecentArray dp_safeObjectAtIndex:0];
    NSString *awayEqual = [match.analysis.awayRecentArray dp_safeObjectAtIndex:1];
    NSString *awayLose = [match.analysis.awayRecentArray dp_safeObjectAtIndex:2];

    NSString *homeWinHistory = [NSString stringWithFormat:@"%d胜", [match.analysis.historyBattleArray valueAtIndex:0]];
    NSString *homeEqualHistory = [NSString stringWithFormat:@"%d平", [match.analysis.historyBattleArray valueAtIndex:1]];
    NSString *homeLoseHistory = [NSString stringWithFormat:@"%d负", [match.analysis.historyBattleArray valueAtIndex:2]];

    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
                MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                attr.font = [UIFont dp_systemFontOfSize:12];
                attr.textColor = [UIColor dp_flatWhiteColor];
                attr;
            })];
    [parser addStyleWithTagName:@"red" color:[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0]];
    [parser addStyleWithTagName:@"green" color:[UIColor colorWithRed:0.61 green:0.98 blue:0.50 alpha:1.0]];
    [parser addStyleWithTagName:@"blue" color:[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0]];

    NSString *recentString = [NSString stringWithFormat:@"  主队 <red>%@</red> <green>%@</green> <blue>%@</blue>, 客队 <red>%@</red> <green>%@</green> <blue>%@</blue>", homeWin, homeEqual, homeLose, awayWin, awayEqual, awayLose];
    cell.zhanJiLabel.attributedText = [parser attributedStringFromMarkup:recentString];

    NSString *historyString = [NSString stringWithFormat:@"  近%d交战, %@ <red>%@</red> <green>%@</green> <blue>%@</blue>", match.analysis.historyCount, match.homeTeamName, homeWinHistory, homeEqualHistory, homeLoseHistory];
    cell.historyLabel.attributedText = [parser attributedStringFromMarkup:historyString];
}

//- (void)updateDPJczqAnalysisCellData:(NSIndexPath *)indexPath
// cell:(DPJczqAnalysisCell *)cell {
//
//}

#pragma mark - 获取底层所有的过滤条件, 将上层条件还原
/**
 *  获取底层所有的过滤条件
 */
- (void)pvt_reloadFilterInfo {
    [self.competitionList removeAllObjects];
    [self.rqsList removeAllObjects];

    NSArray *sortDesc = @[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ];
    NSArray *competitionsList = [_completionsSet sortedArrayUsingDescriptors:sortDesc];

    [self.competitionList addObjectsFromArray:competitionsList];

    NSArray *rqsArr = [_rqsSet sortedArrayUsingDescriptors:sortDesc];

    for (int i = 0; i < rqsArr.count; i++) {
        int num = [[rqsArr objectAtIndex:i] intValue];
        if (num > 0) {
            [self.rqsList addObject:[NSString stringWithFormat:@"客让%d球", num]];
        } else
            [self.rqsList addObject:[NSString stringWithFormat:@"主让%d球", -num]];
    }
}
#pragma mark - 向底层设置过滤条件(上层选中的)

//获得转换过的让球集合
- (NSSet *)getTransletedRQS {
    NSMutableSet *rqList = [[NSMutableSet alloc] init];

    for (NSString *rqs in self.rqsList) {
        NSNumber *rqNum;
        int num = [[rqs substringWithRange:NSMakeRange(2, rqs.length - 3)] intValue];

        if ([rqs hasPrefix:@"客"]) {
            rqNum = [NSNumber numberWithInt:num];
        } else
            rqNum = [NSNumber numberWithInt:-num];
        [rqList addObject:rqNum];
    }
    return rqList;
}
- (void)pvt_resetFilterInfo {
    NSSet *rqList = [self getTransletedRQS];

    [self filterDataWithGameType:self.gameType completion:[NSSet setWithArray:self.competitionList] rqs:rqList];
}

#pragma mark - DPJczqBuyCellDelegate

//设置所选择的赔率
- (void)jczqBuyCell:(DPJczqBuyCell *)cell
           gameType:(GameTypeId)gameType
              index:(int)index
           selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView modelIndexForCell:cell];

    PBMJczqMatch *match =
        [((PBMJczqGame *)
              [_currentData.gamesArray objectAtIndex:indexPath.section])
                .matchesArray objectAtIndex:indexPath.row];
    [self updateSelectStatusWithMatch:match
                       selectGmaeType:gameType
                                index:index
                               select:selected];
    [self pvt_updatePrompt];
}
//点击数据中心
- (void)jczqBuyCellInfo:(DPJczqBuyCell *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    BOOL isexpande = [self.tableView isExpandAtModelIndex:modelIndex];
    [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];

    if (!isexpande) {
        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
        NSArray *indexPathsForVisibleRows =
            [self.tableView indexPathsForVisibleRows];
        NSIndexPath *tempIndexPath = [indexPathsForVisibleRows
            objectAtIndex:indexPathsForVisibleRows.count - 1];
        if ((indexpath.section == tempIndexPath.section) &&
            (indexpath.row == tempIndexPath.row)) {
            NSIndexPath *newIndexPath =
                [self.tableView tableIndexFromModelIndex:modelIndex
                                                  expand:NO];
            [self.tableView
                scrollToRowAtIndexPath:[NSIndexPath
                                           indexPathForRow:newIndexPath.row
                                                 inSection:newIndexPath.section]
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
        }
    }
}
//更多玩法
- (void)moreJczqBuyCell:(DPJczqBuyCell *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];

    PBMJczqMatch *match =
        [((PBMJczqGame *)
              [_currentData.gamesArray objectAtIndex:modelIndex.section])
                .matchesArray objectAtIndex:modelIndex.row];

    JczqOption option;
    switch (self.gameType) {
        case GameTypeJcDgAll:
        case GameTypeJcDg:
            option = match.matchOption.dgOption;
            break;
        case GameTypeJcHt:
            option = match.matchOption.htOption;
            break;
        default:
            option = match.matchOption.normalOption;
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        DPFootBallMoreViewController *controller = [[DPFootBallMoreViewController alloc] initWithGameType:self.gameType match:match];
        controller.reloadBlock = ^(void) {
            [self.tableView reloadRowsAtIndexPaths:@[ modelIndex ] withRowAnimation:UITableViewRowAnimationNone];
            [self pvt_updatePrompt];
        };
        [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
    });

    return;
}

- (PBMJczqMatch *)getBaseMatchWithMatch:(PBMJczqMatch *)match {
    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *theMatch in game.matchesArray) {
            if (theMatch.dataMatchId == match.dataMatchId) {
                return theMatch;
            }
        }
    }

    return nil;
}
- (void)updateSelectStatusWithMatch:(PBMJczqMatch *)match
                     selectGmaeType:(GameTypeId)gametype
                              index:(int)index
                             select:(BOOL)isSelect {
    PBMJczqMatch *baseMatch = [self getBaseMatchWithMatch:match];
    NSAssert(baseMatch, @"未找到相符的match");

    [baseMatch updateSelectStatusWithBaseType:self.gameType selectGmaeType:gametype index:index select:isSelect isAllSub:NO];
}
//更新比分，半全场数据
- (void)upDataJcBfBqcDataCell:(DPJczqBuyCell *)cell
                        array:(NSArray *)array
                       target:(int[])chk
                        title:(NSString *)title
               divisionString:(NSString *)divisionString {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    int count = 0;
    for (int i = 0; i < array.count; i++) {
        if (chk[i] == 1) {
            if (count == 0) {
                [string appendFormat:@"%@", [array objectAtIndex:i]];
            } else {
                [string appendFormat:@"%@%@", divisionString, [array objectAtIndex:i]];
            }
            count = count + 1;
        }
    }
    UIButton *button = (UIButton *)[cell viewWithTag:(self.gameType << 16) | 0];
    if (string.length > 0) {
        [button setTitleColor:UIColorFromRGB(0xe7161a)
                     forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        return;
    }
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}

#pragma mark - DPNavigationMenuDelegate
//选中彩种类型
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(int)index {
    [[DPToast sharedToast] dismiss];
    self.gameIndex = index;

    [_collapseSections removeAllObjects];
    [self filterDataWithGameType:self.gameType];

    [self showAlertIfNeeded];
}

//取消选中彩种

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];

    if (self.menu.selectedIndex == 6) {
        self.tableViewConstraint.constant = -36;
    } else {
        self.tableViewConstraint.constant = 0;
    }

    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
}

#pragma mark - 底部选择比赛数
- (void)pvt_updatePrompt {
    int count = 0;
    int danCount = 0;

    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:self.gameType]) {
                count += 1;
                if ([match isSelectedAllSignalWithType:self.gameType])
                    danCount += 1;
            }
        }
    }

    if (count < 1) {
        self.promptLabel.text = @"请选择比赛";
        return;
    }
    if (self.gameType == GameTypeJcBf) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if (danCount) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if (count < 2) {
        self.promptLabel.text = @"已选1场，还差1场";
        return;
    }

    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
}

@end
