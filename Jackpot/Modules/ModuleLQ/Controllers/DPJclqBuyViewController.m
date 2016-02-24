//
//  DPJclqBuyViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAlterViewController.h"
#import "DPBetToggleControl.h"
#import "DPCollapseTableView.h"
#import "DPDataCenterViewController.h"
#import "DPDropDownList.h"
#import "DPJcLqBuyCelll.h"
#import "DPJclqBuyViewController.h"
#import "DPJclqDataModel.h"
#import "DPJclqTransferVC.h"
#import "DPLanCaiMoreView.h"
#import "DPLcAnalysisCell.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPResultListViewController.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "KTMUserDefaults+Jackpot.h"
#import "SVPullToRefresh.h"
typedef NS_ENUM(NSInteger, JczqIndex) {
    JclqIndexLcHt,      //混投
    JclqIndexLcSf,      //胜负
    JclqIndexLcRqsf,    //让球胜负
    JclqIndexLcDxf,     //大小分
    JclqIndexLcSfc,     //胜分差
};

@interface DPJclqBuyViewController () <DPCollapseTableViewDelegate, DPCollapseTableViewDataSource, DPNavigationMenuDelegate, DPJcLqBuyCellDelegate, UIGestureRecognizerDelegate, DPDropDownListDelegate> {
@private
    DPCollapseTableView *_tableView;
    UIView *_bottomView;
    UILabel *_promptLabel;

    NSMutableSet *_collapseSections;
    DPNavigationMenu *_menu;

    DPNavigationTitleButton *_titleButton;

    PBMJclqBuy *_dataBase;            //基础数据
    PBMJclqBuy *_currentData;         //当前数据
    NSMutableSet *_completionsSet;    //赛事名称
}

@property (nonatomic, strong, readonly) NSMutableArray *alertCache;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *bottomView;                      //底部
@property (nonatomic, strong, readonly) UILabel *promptLabel;                    //底部文字
@property (nonatomic, strong, readonly) DPNavigationMenu *menu;                  //彩种标题栏
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;    //彩种标题
@property (nonatomic, strong) NSMutableArray *competitionList;                   //筛选-赛事选择
@property (nonatomic, strong, readonly) UIImageView *noDataImgView;              //
@property (nonatomic, strong) NSMutableDictionary *analysisDic;
@property (nonatomic, copy) NSString *gameTime;
@end

@implementation DPJclqBuyViewController
@dynamic tableView;
@dynamic bottomView;
@dynamic promptLabel;
@dynamic menu;
@synthesize commands = _commands;

- (instancetype)init {
    if (self = [super init]) {
        _alertCache = [NSMutableArray arrayWithCapacity:5];
        _collapseSections = [NSMutableSet setWithCapacity:10];
        _currentData = [PBMJclqBuy message];
        self.gameType = GameTypeLcHt;

        _completionsSet = [[NSMutableSet alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self filterDataWithGameType:self.gameType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self buildLayout];
    [self showHUD];
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getDataFromNet];
    }];

    self.titleButton.titleText = self.menu.items[self.gameIndex];
    self.navigationItem.titleView = self.titleButton;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onNavLeft:)];

    self.navigationItem.rightBarButtonItems = ({
        UIBarButtonItem *filterItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(pvt_onFilter)];
        UIBarButtonItem *moreItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"more.png") target:self action:@selector(pvt_onMore)];
        @[ moreItem, filterItem ];
    });

    //  请求数据
    [self getDataFromNet];
}

- (void)buildLayout {
    UIView *contentView = self.view;

    [contentView addSubview:self.bottomView];
    [contentView addSubview:self.tableView];
    //    [contentView addSubview:self.noDataImgView];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
        make.height.equalTo(@44);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    self.noDataImgView.hidden = YES;
    contentView = self.bottomView;

    UIButton *cleanupButton = [[UIButton alloc] init];
    [cleanupButton setImage:[UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"delete001_21.png")] forState:UIControlStateNormal];
    UIButton *confirmButton = [[UIButton alloc] init];
    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *lineView = [UIView dp_viewWithColor:[UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1]];

    // config control
    confirmButton.backgroundColor = [UIColor dp_flatRedColor];

    // bind event
    [cleanupButton addTarget:self action:@selector(pvt_onCleanup) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(pvt_onConfirm) forControlEvents:UIControlEventTouchUpInside];

    // move to view
    [contentView addSubview:cleanupButton];
    [contentView addSubview:confirmButton];
    [contentView addSubview:self.promptLabel];
    [contentView addSubview:confirmView];
    [contentView addSubview:lineView];

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
        make.centerY.equalTo(confirmButton);
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

#pragma mark - 数据筛选
/**
 *  数据筛选
 *
 *  @param type 彩种
 */
- (void)filterDataWithGameType:(GameTypeId)type {
    [_currentData.gamesArray removeAllObjects];
    [_completionsSet removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJclqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJclqGame *cGame = [PBMJclqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJclqMatch *match = [game.matchesArray objectAtIndex:j];

            switch (type) {
                case GameTypeLcHt: {
                    [cMatchArray addObject:match];
                    [_completionsSet addObject:match.competitionName];
                } break;

                case GameTypeLcSf: {
                    if (match.sfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeLcRfsf: {
                    if (match.rfsfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeLcDxf: {
                    if (match.dxfItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;
                case GameTypeLcSfc: {
                    if (match.sfcItem.gameVisible) {
                        [cMatchArray addObject:match];
                        [_completionsSet addObject:match.competitionName];
                    }
                } break;

                default:
                    break;
            }
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }

    [self pvt_reloadFilterInfo];
    [self showOrChangeBottomText];
    [self.tableView closeAllCells];
    [self.tableView reloadData];
}

/**
 *  根据筛选条件进行数据筛选
 *
 *  @param type        [in]彩种
 *  @param completions [in]赛事
 */
- (void)filterDataWithGameType:(GameTypeId)type completion:(NSSet *)completions {
    [_currentData.gamesArray removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJclqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJclqGame *cGame = [PBMJclqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJclqMatch *match = [game.matchesArray objectAtIndex:j];

            switch (type) {
                case GameTypeLcHt: {
                    if ([completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }

                } break;

                case GameTypeLcSf: {
                    if (match.sfItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeLcRfsf: {
                    if (match.rfsfItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeLcDxf: {
                    if (match.dxfItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;
                case GameTypeLcSfc: {
                    if (match.sfcItem.gameVisible && [completions containsObject:match.competitionName]) {
                        [cMatchArray addObject:match];
                    }
                } break;

                default:
                    break;
            }
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }

    [self showOrChangeBottomText];
    [self.tableView closeAllCells];
    [self.tableView reloadData];
}

- (void)getDataFromNet {
    [[AFHTTPSessionManager dp_sharedManager] GET:@"jclq/buy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            self.tableView.emptyDataView.requestSuccess = YES;
            _dataBase = [PBMJclqBuy parseFromData:responseObject error:nil];
            [self filterDataWithGameType:self.gameType];
            [self showAlertIfNeeded];
            // 重载数据
            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {

            self.tableView.emptyDataView.requestSuccess = NO;
            [self.tableView reloadData];

            [self dismissHUD];
            [self.tableView.pullToRefreshView stopAnimating];

            NSLog(@"%@", error);

        }];
}

#pragma mark - getter, setter
//彩种标题
- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        [_titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onExpandNav)]];
    }
    return _titleButton;
}
//标题选择栏
- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.itemsImage = @[
            @"ht.png",
            @"sf.png",
            @"rf.png",
            @"dxf.png",
            @"sfc.png",
        ];
        _menu.items = @[ @"混合过关", @"胜负", @"让分胜负", @"大小分", @"胜分差" ];
    }
    return _menu;
}
//设置彩种类型
- (void)setGameType:(GameTypeId)gameType {
    _gameType = gameType;

    switch (gameType) {
        case GameTypeLcHt:
            _gameIndex = JclqIndexLcHt;
            break;
        case GameTypeLcSf:
            _gameIndex = JclqIndexLcSf;
            break;
        case GameTypeLcRfsf:
            _gameIndex = JclqIndexLcRqsf;
            break;
        case GameTypeLcDxf:
            _gameIndex = JclqIndexLcDxf;
            break;
        case GameTypeLcSfc:
            _gameIndex = JclqIndexLcSfc;
            break;
        default:
            DPAssert(NO);
            break;
    }
}

- (void)setGameIndex:(int)gameIndex {
    _gameIndex = gameIndex;

    switch (gameIndex) {
        case JclqIndexLcHt:
            _gameType = GameTypeLcHt;
            break;
        case JclqIndexLcSf:
            _gameType = GameTypeLcSf;
            break;
        case JclqIndexLcRqsf:
            _gameType = GameTypeLcRfsf;
            break;
        case JclqIndexLcDxf:
            _gameType = GameTypeLcDxf;
            break;
        case JclqIndexLcSfc:
            _gameType = GameTypeLcSfc;
            break;
        default:
            DPAssert(NO);
            break;
    }
}
//筛选-赛事选择
- (NSMutableArray *)competitionList {
    if (_competitionList == nil) {
        _competitionList = [NSMutableArray array];
    }
    return _competitionList;
}
//底部view
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.zOrder = DPTableViewZOrderAsec;

        DZNEmptyDataView *recomEmpty = [[DZNEmptyDataView alloc] init];
        recomEmpty.textForNoData = @"暂无数据";
        recomEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png");

        _tableView.emptyDataView = recomEmpty;
        _tableView.emptyDataView.showButtonForNoData = NO;
        @weakify(self);
        _tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type) {

            if (type == DZNEmptyDataViewTypeNoNetwork) {
                @strongify(self);
                [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
            } else if (type == DZNEmptyDataViewTypeFailure) {
                @strongify(self);
                [self showHUD];
                [self getDataFromNet];
            }
        };
    }
    return _tableView;
}
//底部文字
- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = [UIFont dp_systemFontOfSize:14];
    }
    return _promptLabel;
}

- (NSMutableArray *)getSelectedMatchs {
    NSMutableArray *matchsArr = [[NSMutableArray alloc] init];

    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *match in game.matchesArray) {
            match.dp_gameId = (int)game.gameId;

            if ([match isSelectedWithType:self.gameType]) {
                [matchsArr addObject:match];
            }
        }
    }

    return matchsArr;
}

#pragma mark - private function

/**
 *  停售弹框处理. pop
 */
- (void)showAlertIfNeeded {
    BOOL needAlertStop = NO;
    switch (self.gameType) {
        case GameTypeLcHt:
            needAlertStop = _dataBase.sfSaleStop && _dataBase.rfsfSaleStop && _dataBase.dxfSaleStop && _dataBase.sfcSaleStop;
            break;
        case GameTypeLcSf:
            needAlertStop = _dataBase.sfSaleStop;
            break;
        case GameTypeLcRfsf:
            needAlertStop = _dataBase.rfsfSaleStop;
            break;
        case GameTypeLcDxf:
            needAlertStop = _dataBase.dxfSaleStop;
            break;
        case GameTypeLcSfc:
            needAlertStop = _dataBase.sfcSaleStop;
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
    if (_dataBase.nightStopTicket && (!userDefaults.jclqAlertDate || [date timeIntervalSinceDate:userDefaults.jclqAlertDate] > 60 * 60 * 12)) {
        userDefaults.jclqAlertDate = date;

        DPAlterViewController *alertController = [[DPAlterViewController alloc] initWithAlterType:AlterTypeJcUnGetNoBuy];
        [self dp_showViewController:alertController animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        return;
    }
}

//清空所选赛事
- (void)pvt_onCleanup {
    [self cleanAllSelect];
    [self.tableView reloadData];
}

- (void)cleanAllSelect {
    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *match in game.matchesArray) {
            [match.matchOption initializeOptionWithType:self.gameType];
        }
    }
    [self showOrChangeBottomText];
}

//完成提交中转界
- (void)pvt_onConfirm {
    int count = 0;
    int danCount = 0;

    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:self.gameType]) {
                count += 1;
                if ([match isSelectedAllSignalWithType:self.gameType])
                    danCount += 1;
            }
        }
    }
    if (self.gameType == GameTypeLcSfc) {
        if (count < 1) {
            [[DPToast makeText:@"请选择比赛"] show];
            return;
        }
    } else {
        if (count < 2 && danCount < 1) {
            if (count < 1) {
                [[DPToast makeText:@"请选择比赛"] show];
            } else {
                [[DPToast makeText:@"请至少选择2场比赛"] show];
            }
            return;
        }
    }
    if (count > 15) {
        [[DPToast makeText:@"最多选择15场比赛"] show];
        return;
    }

    NSMutableArray *orderNumbers = [[NSMutableArray alloc] initWithCapacity:[self getSelectedMatchs].count];
    for (PBMJclqMatch *match in [self getSelectedMatchs]) {
        [orderNumbers addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    NSString *urlStr = [NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%@&gameTypeId=%d", [orderNumbers componentsJoinedByString:@","], self.gameType];
    [self showHUD];
    @weakify(self);
    [[AFHTTPSessionManager dp_sharedManager] GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        DPJclqTransferVC *viewController = [[DPJclqTransferVC alloc] init];
        viewController.gameType = self.gameType;
        viewController.matchsArray = [self getSelectedMatchs];
        [self.navigationController pushViewController:viewController animated:YES];
    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissHUD];
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

//列表区点击事件
- (void)pvt_onHeaderTap:(UITapGestureRecognizer *)tapRecognizer {
    [_collapseSections dp_turnObject:@(tapRecognizer.view.tag)];
    //    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tapRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationFade];
}
//列表区赋值
- (NSString *)pvt_titleForSection:(int)section {
    PBMJclqGame *game = [[_currentData gamesArray] objectAtIndex:section];
    NSUInteger numberOfRows = game.matchesArray.count;

    if (!game || numberOfRows <= 0) {
        return @"";
    }

    NSString *dateString = game.gameName;

    NSDate *date = [NSDate dp_dateFromString:dateString withFormat:dp_DateFormatter_yyyy_MM_dd];
    self.gameTime = [date dp_stringWithFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    dateString = [date dp_stringWithFormat:@"yyyy年MM月dd日"];
    return [NSString stringWithFormat:@"%@ %@   %lu场比赛可投", dateString, [date dp_weekdayName], (unsigned long)numberOfRows];
}
//点击彩种展开彩种类型
- (void)pvt_onExpandNav {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.gameIndex];
    [self.menu show];
}

//返回到购彩大厅
- (void)pvt_onNavLeft:(UIButton *)button {
    int count = 0;
    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *match in game.matchesArray) {
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

#pragma mark - 菜单
//更多菜单
- (void)pvt_onMore {
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    [coverView setBackgroundColor:[UIColor clearColor]];
    [self.view.window addSubview:coverView];

    DPDropDownList *dropDownList = [[DPDropDownList alloc] initWithItems:@[ @"开奖公告", @"玩法介绍", @"帮助" ]];
    [dropDownList setDelegate:self];
    [coverView addSubview:dropDownList];
    [dropDownList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverView).offset(64);
        make.right.equalTo(coverView).offset(-20);
    }];

    [coverView addGestureRecognizer:({
                   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
                   tap.delegate = self;
                   tap;

               })];
}

- (void)pvt_onCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (void)pvt_onFilter {
    if (_completionsSet.count <= 0) {
        return;
    }

    NSArray *sortDesc = @[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ];
    NSArray *competitionsList = [_completionsSet sortedArrayUsingDescriptors:sortDesc];

    DPSportFilterView *filterView = [[DPSportFilterView alloc]
        initWithGroupTitles:@[ @"赛事选择" ]
                   allGroup:@[ competitionsList ]
                selectGroup:@[ [self.competitionList mutableCopy] ]];
    filterView.reloadFilter = ^(NSArray *selectedGroups) {
        NSMutableArray *competitionList = nil;
        competitionList = [selectedGroups firstObject];
        [self.competitionList removeAllObjects];
        [self.competitionList addObjectsFromArray:competitionList];
        [self pvt_resetFilterInfo];
    };

    [self dp_showViewController:filterView animatorType:DPTransitionAnimatorTypeAlert completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
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
                NSLog(@"%@", self.gameTime);
                DPResultListViewController *viewController = [[DPResultListViewController alloc] init];
                viewController.gameType = self.gameType;
                viewController.isFromClickMore = YES;
                //                viewController.gameTime = self.gameTime;
                viewController;
            });
        } break;
        case 1: {    // 玩法介绍
            viewController = ({
                DPWebViewController *viewController = [[DPWebViewController alloc] init];
                viewController.requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kLcPlayIntroduceURL]];
                viewController.title = @"玩法介绍";
                viewController.canHighlight = NO;

                viewController;
            });
        } break;
        case 2: {    // 帮助
            viewController = [[DPWebViewController alloc] init];
            DPWebViewController *webCtrl = (DPWebViewController *)viewController;
            webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpCenterURL]];
        } break;
        default:
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - table view's data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(0, _currentData.gamesArray.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }

    return ((PBMJclqGame *)[_currentData.gamesArray objectAtIndex:section]).matchesArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    label.text = [self pvt_titleForSection:(int)section];

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
        ;
    }];

    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHeaderTap:)]];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMJclqMatch *match =
        [((PBMJclqGame *)
              [_currentData.gamesArray objectAtIndex:indexPath.section])
                .matchesArray objectAtIndex:indexPath.row];
    JclqOption option;
    switch (self.gameType) {
        case GameTypeLcHt:
            option = match.matchOption.htOption;
            break;
        default:
            option = match.matchOption.normalOption;
            break;
    }

    NSString *CellIdentifier = [NSString stringWithFormat:@"BuyCell%d", self.gameIndex];

    DPJcLqBuyCelll *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPJcLqBuyCelll alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.gameType = self.gameType;

        [cell buildLayout];
    }

    switch (cell.gameType) {    // 单关标示(除混投)

        case GameTypeLcSf:
            cell.otherDGView.hidden = !match.sfItem.supportSingle;
            break;
        case GameTypeLcRfsf:
            cell.otherDGView.hidden = !match.rfsfItem.supportSingle;
            break;
        case GameTypeLcDxf:
            cell.otherDGView.hidden = !match.dxfItem.supportSingle;
            break;
        case GameTypeLcSfc:
            cell.otherDGView.hidden = !match.sfcItem.supportSingle;
            break;
        default:
            break;
    }

    cell.competitionLabel.text = match.competitionName;
    cell.orderNameLabel.text = match.orderNumberName;
    cell.matchDateLabel.text = [NSDate dp_coverDateString:match.endTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm截止"];

    cell.homeNameLabel.text = match.homeTeamName;
    cell.awayNameLabel.text = match.awayTeamName;
    cell.homeRankLabel.text = match.homeTeamRank.length ? [NSString stringWithFormat:@"[%@]", match.homeTeamRank] : nil;
    cell.awayRankLabel.text = match.awayTeamRank.length ? [NSString stringWithFormat:@"[%@]", match.awayTeamRank] : nil;

    switch (self.gameType) {
        case GameTypeLcHt: {
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];

            BOOL moreBtnSelected = NO;
            for (int i = 0; i < 2; i++) {
                if (option.betSf[i] >= 1) {
                    moreBtnSelected = YES;
                    break;
                }
            }
            if (moreBtnSelected == NO) {
                for (int i = 0; i < 12; i++) {
                    if (option.betSfc[i] >= 1) {
                        moreBtnSelected = YES;
                        break;
                    }
                }
            }
            cell.moreButton.selected = moreBtnSelected;

            cell.rfNoDataLabel.hidden = match.rfsfItem.gameVisible;
            cell.dxfNoDataLabel.hidden = match.dxfItem.gameVisible;

            for (int i = 0; i < cell.options132.count; i++) {
                DPBetToggleControl *control = cell.options132[i];
                BOOL isVisiable = YES;
                isVisiable = match.rfsfItem.gameVisible;
                if (isVisiable) {
                    control.titleColor = [UIColor dp_flatBlackColor];
                    control.backgroundColor = [UIColor dp_flatWhiteColor];
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.rfsfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betRfsf[i];

                } else {
                    control.userInteractionEnabled = NO;
                    control.oddsText = @"";
                    control.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                    control.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                }
            }
            for (int i = 0; i < cell.options134.count; i++) {
                DPBetToggleControl *control = cell.options134[i];
                BOOL isVisiable = YES;
                isVisiable = match.dxfItem.gameVisible;
                if (isVisiable) {
                    control.titleColor = [UIColor dp_flatBlackColor];
                    control.backgroundColor = [UIColor dp_flatWhiteColor];
                    control.userInteractionEnabled = YES;
                    control.oddsText = [match.dxfItem.spListArray dp_safeObjectAtIndex:i];
                    control.selected = option.betDxf[i];

                } else {
                    control.userInteractionEnabled = NO;
                    control.oddsText = @"";
                    control.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                    control.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                }
            }
            cell.otherDGView.hidden = YES;
            cell.htSpfDGView.hidden = !match.rfsfItem.supportSingle;
            cell.htRqDGView.hidden = !match.dxfItem.supportSingle;

            cell.rangfenLabel.text = [NSString stringWithFormat:@"%@", match.rf];
            cell.rangfenLabel.textColor = match.rf.intValue > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];

            cell.dxfLabel.text = [NSString stringWithFormat:@"%@", match.zf];
        }

        break;
        case GameTypeLcRfsf:
            cell.middleLabel.text = [NSString stringWithFormat:@"%@", match.rf];

            cell.middleLabel.textColor = match.rf.intValue > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
            for (int i = 0; i < cell.options132.count; i++) {
                DPBetToggleControl *control = cell.options132[i];
                control.titleColor = [UIColor dp_flatBlackColor];
                control.backgroundColor = [UIColor dp_flatWhiteColor];
                control.userInteractionEnabled = YES;
                control.oddsText = [match.rfsfItem.spListArray dp_safeObjectAtIndex:i];
                control.selected = option.betRfsf[i];
            }

            break;
        case GameTypeLcSf:
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
            for (int i = 0; i < cell.options131.count; i++) {
                DPBetToggleControl *control = cell.options131[i];
                control.oddsText = [match.sfItem.spListArray dp_safeObjectAtIndex:i];
                control.selected = option.betSf[i];
            }
            break;
        case GameTypeLcSfc: {
            cell.middleLabel.text = @"VS";
            cell.middleLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
            NSArray *array = [NSArray arrayWithObjects:
                                          @"客胜1-5", @"客胜6-10", @"客胜11-15", @"客胜16-20", @"客胜21-25", @"客胜26+", @"主胜1-5", @"主胜6-10", @"主胜11-15", @"主胜16-20", @"主胜21-25", @"主胜26+", nil];

            [self upDataLcSfcDataCell:cell array:array target:option.betSfc title:@"胜分差投注" divisionString:@" "];
            return cell;
        } break;
        case GameTypeLcDxf: {
            cell.middleLabel.text = [NSString stringWithFormat:@"%@", match.zf];
            cell.middleLabel.textColor = [UIColor dp_flatRedColor];
            for (int i = 0; i < cell.options134.count; i++) {
                DPBetToggleControl *control = cell.options134[i];
                control.titleColor = [UIColor dp_flatBlackColor];
                control.backgroundColor = [UIColor dp_flatWhiteColor];
                control.userInteractionEnabled = YES;
                control.oddsText = [match.dxfItem.spListArray dp_safeObjectAtIndex:i];
                control.selected = option.betDxf[i];
            }

        }

        break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeLcHt:
            return 90 + 18;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcDxf:
        case GameTypeLcSfc:
            return 83;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"AnalysisCell%d", self.gameType];
    DPLcAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPLcAnalysisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.gameType = self.gameType;

        __weak __typeof(self) weakSelf = self;
        [cell setClickBlock:^(DPLcAnalysisCell *nalysisCell) {

            NSIndexPath *pathIndex = [weakSelf.tableView modelIndexForCell:nalysisCell];
            PBMJclqMatch *theMatch =
                [((PBMJclqGame *)
                      [_currentData.gamesArray objectAtIndex:pathIndex.section])
                        .matchesArray objectAtIndex:pathIndex.row];

            DPDataCenterViewController *viewController = [[DPDataCenterViewController alloc] init];
            viewController.matchId = theMatch.dataMatchId;
            viewController.titleString = theMatch.competitionName;
            viewController.gameType = GameTypeLcNone;
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
                homeMarkupText = [NSString stringWithFormat:@"%@<rank>[%@]</rank>", theMatch.homeTeamName, theMatch.homeTeamRank];
            } else {
                homeMarkupText = [NSString stringWithFormat:@"%@", theMatch.homeTeamName];
            }
            if (theMatch.awayTeamRank.length) {
                awayMarkupText = [NSString stringWithFormat:@"<rank>[%@]</rank>%@", theMatch.awayTeamRank, theMatch.awayTeamName];
            } else {
                awayMarkupText = [NSString stringWithFormat:@"%@", theMatch.awayTeamName];
            }

            viewController.homeTeamName = [parser attributedStringFromMarkup:homeMarkupText];
            viewController.awayTeamName = [parser attributedStringFromMarkup:awayMarkupText];

            [self.navigationController pushViewController:viewController animated:YES];

        }];
    }
    [cell clearAllData];
    //获取数据中心的数据
    [self finishDPJczqAnalysisCellData:indexPath cell:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameType == GameTypeLcHt) {
        return 140;
    }
    if ((self.gameType == GameTypeLcDxf) || (self.gameType == GameTypeLcRfsf) || (self.gameType == GameTypeLcSf)) {
        return 115;
    }
    return 95;
}

#pragma mark - 数据中心赋值
- (void)finishDPJczqAnalysisCellData:(NSIndexPath *)indexPath cell:(DPLcAnalysisCell *)cell {
    PBMJclqMatch *match =
        [((PBMJclqGame *)
              [_currentData.gamesArray objectAtIndex:indexPath.section])
                .matchesArray objectAtIndex:indexPath.row];

    [cell.activityIndicatorView stopAnimating];
    if (self.gameType == GameTypeLcHt) {    //主胜，主负篮彩前后相反
        cell.ratioWinLabel.text = [match.analysis.rfsfBetRatioArray dp_safeObjectAtIndex:1];
        cell.ratioLoseLabel.text = [match.analysis.rfsfBetRatioArray dp_safeObjectAtIndex:0];
        cell.rqWinLabel.text = [match.analysis.dxfBetRatioArray dp_safeObjectAtIndex:0];
        cell.rqLoseLabel.text = [match.analysis.dxfBetRatioArray dp_safeObjectAtIndex:1];
    } else if (self.gameType == GameTypeLcSf) {
        cell.ratioWinLabel.text = [match.analysis.sfBetRatioArray dp_safeObjectAtIndex:1];
        cell.ratioLoseLabel.text = [match.analysis.sfBetRatioArray dp_safeObjectAtIndex:0];

    } else if (self.gameType == GameTypeLcRfsf) {
        cell.ratioWinLabel.text = [match.analysis.rfsfBetRatioArray dp_safeObjectAtIndex:1];
        cell.ratioLoseLabel.text = [match.analysis.rfsfBetRatioArray dp_safeObjectAtIndex:0];

    } else if (self.gameType == GameTypeLcDxf) {
        cell.ratioWinLabel.text = [match.analysis.dxfBetRatioArray dp_safeObjectAtIndex:0];
        cell.ratioLoseLabel.text = [match.analysis.dxfBetRatioArray dp_safeObjectAtIndex:1];
    }

    NSString *homeWin = [match.analysis.homeRecentArray dp_safeObjectAtIndex:0];
    NSString *homeLose = [match.analysis.homeRecentArray dp_safeObjectAtIndex:1];
    NSString *awayWin = [match.analysis.awayRecentArray dp_safeObjectAtIndex:0];
    NSString *awayLose = [match.analysis.awayRecentArray dp_safeObjectAtIndex:1];
    NSString *recentString = [NSString stringWithFormat:@"  主队 %@ %@,客队 %@ %@", homeWin, homeLose, awayWin, awayLose];
    NSMutableAttributedString *hinString = [[NSMutableAttributedString alloc] initWithString:recentString];

    [hinString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatWhiteColor] range:NSMakeRange(0, hinString.length)];
    [hinString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf07678) range:NSMakeRange(5, homeWin.length)];
    [hinString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x66cdfc) range:NSMakeRange(6 + homeWin.length, homeLose.length)];
    [hinString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf07678) range:NSMakeRange(10 + homeWin.length + homeLose.length, awayWin.length)];
    [hinString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x66cdfc) range:NSMakeRange(11 + homeWin.length + homeLose.length + awayWin.length, awayLose.length)];
    cell.zhanJiLabel.attributedText = hinString;

    NSString *homeWinHistory = [NSString stringWithFormat:@"%d胜", [match.analysis.historyBattleArray valueAtIndex:0]];
    NSString *homeLoseHistory = [NSString stringWithFormat:@"%d负", [match.analysis.historyBattleArray valueAtIndex:1]];
    NSString *historyString = [NSString stringWithFormat:@"  近%d交战,%@ %@ %@", match.analysis.historyCount, match.homeTeamName, homeWinHistory, homeLoseHistory];
    NSMutableAttributedString *hinString2 = [[NSMutableAttributedString alloc] initWithString:historyString];
    NSRange numberRange11 = [historyString rangeOfString:homeWinHistory options:NSCaseInsensitiveSearch];
    NSRange numberRange12 = [historyString rangeOfString:homeLoseHistory options:NSCaseInsensitiveSearch];
    [hinString2 addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatWhiteColor] range:NSMakeRange(0, hinString2.length)];
    [hinString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.99 green:0.49 blue:0.50 alpha:1.0] range:numberRange11];
    [hinString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.40 green:0.81 blue:0.99 alpha:1.0] range:numberRange12];
    cell.historyLabel.attributedText = hinString2;
}

// 获取底层所有的过滤条件, 将上层条件还原
- (void)pvt_resetFilterInfo {
    [self filterDataWithGameType:self.gameType completion:[NSSet setWithArray:self.competitionList]];
}
// 向底层设置过滤条件(上层选中的)
- (void)pvt_reloadFilterInfo {
    [self.competitionList removeAllObjects];

    NSArray *sortDesc = @[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ];
    NSArray *competitionsList = [_completionsSet sortedArrayUsingDescriptors:sortDesc];

    [self.competitionList addObjectsFromArray:competitionsList];
}

- (void)showOrChangeBottomText {
    int count = 0;
    int normalCount = 0;

    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:self.gameType]) {
                count += 1;
                if (![match isSelectedAllSignalWithType:self.gameType])
                    normalCount += 1;
            }
        }
    }

    if (count < 1) {
        self.promptLabel.text = @"请选择比赛";
        return;
    }
    if (self.gameType == GameTypeLcSfc) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if (!normalCount) {
        self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
        return;
    }
    if (count < 2) {
        self.promptLabel.text = @"已选1场，还差1场";
        return;
    }
    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场", count];
}
#pragma mark - DPJcLqBuyCellDelegate
//设置所选择的赔率
- (void)jcLqBuyCell:(DPJcLqBuyCelll *)cell event:(DPJcLqBuyCellEvent)event info:(NSDictionary *)info {
    NSIndexPath *indexPath = [self.tableView modelIndexForCell:cell];
    PBMJclqMatch *match =
        [((PBMJclqGame *)
              [_currentData.gamesArray objectAtIndex:indexPath.section])
                .matchesArray objectAtIndex:indexPath.row];

    JclqOption option;
    switch (self.gameType) {
        case GameTypeLcHt:
            option = match.matchOption.htOption;
            break;
        default:
            option = match.matchOption.normalOption;
            break;
    }

    switch (event) {
        case DPJcLqBuyCellEventMore: {
            DPBasketMoreViewController *controller = [[DPBasketMoreViewController alloc] initWithGameType:self.gameType match:match];
            @weakify(self);
            controller.reloadBlock = ^(void) {
                @strongify(self);

                [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
                [self showOrChangeBottomText];
            };
            [self dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
        } break;
        case DPJCLqBuyCellEventOption: {
            int tag = [[info objectForKey:@"tag"] intValue];
            DPBetToggleControl *button = (DPBetToggleControl *)[cell viewWithTag:tag];
            //            int spIndex = 0;
            int index = button.tag & 0x0000FFFF;

            [self updateSelectStatusWithMatch:match selectGmaeType:(GameTypeId)(button.tag >> 16) index:index select:button.selected];

            [self showOrChangeBottomText];
        } break;
        default:
            break;
    }
}

//点击数据中心
- (void)jcLqBuyCellInfo:(DPJcLqBuyCelll *)cell {
    NSIndexPath *modelIndex = [self.tableView modelIndexForCell:cell];
    BOOL isexpande = [self.tableView isExpandAtModelIndex:modelIndex];
    [cell analysisViewIsExpand:[self.tableView isExpandAtModelIndex:modelIndex]];
    [self.tableView toggleCellAtModelIndex:modelIndex animation:YES];

    if (!isexpande) {
        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
        NSArray *indexPathsForVisibleRows = [self.tableView indexPathsForVisibleRows];
        NSIndexPath *tempIndexPath = [indexPathsForVisibleRows objectAtIndex:indexPathsForVisibleRows.count - 1];
        if ((indexpath.section == tempIndexPath.section) && (indexpath.row == tempIndexPath.row)) {
            NSIndexPath *newIndexPath = [self.tableView tableIndexFromModelIndex:modelIndex expand:NO];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
- (PBMJclqMatch *)getBaseMatchWithMatch:(PBMJclqMatch *)match {
    for (PBMJclqGame *game in _dataBase.gamesArray) {
        for (PBMJclqMatch *theMatch in game.matchesArray) {
            if (theMatch.dataMatchId == match.dataMatchId) {
                return theMatch;
            }
        }
    }

    return nil;
}

// 选中or取消投注选项. pop
- (void)updateSelectStatusWithMatch:(PBMJclqMatch *)match
                     selectGmaeType:(GameTypeId)gametype
                              index:(int)index
                             select:(BOOL)isSelect {
    PBMJclqMatch *baseMatch = [self getBaseMatchWithMatch:match];
    NSAssert(baseMatch, @"未找到相符的match");

    [baseMatch updateSelectStatusWithBaseType:self.gameType selectGmaeType:gametype index:index select:isSelect isAllSub:NO];
}

//更新比分，半全场数据
- (void)upDataLcSfcDataCell:(DPJcLqBuyCelll *)cell array:(NSArray *)array target:(int[])chk title:(NSString *)title divisionString:(NSString *)divisionString {
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
        [button setTitleColor:UIColorFromRGB(0xe7161a) forState:UIControlStateNormal];
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
    self.gameIndex = index;
    [_collapseSections removeAllObjects];
    [self filterDataWithGameType:self.gameType];
    [self showAlertIfNeeded];
}

//取消选中彩种
- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
}
@end
