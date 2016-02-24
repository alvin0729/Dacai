//
//  DPHLCreateHeartLoveViewController.m
//  Jackpot
//
//  Created by mu on 15/12/21.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPBetToggleControl.h"
#import "DPHLCreateHeartLoveViewController.h"
#import "DPHLHeartConfrimVC.h"
#import "DPHLMatchDetailCell.h"
#import "DPSportFilterView.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "UIScrollView+SVPullToRefresh.h"

//data
#import "Wages.pbobjc.h"

@interface DPHLCreateHeartLoveViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableSet *_collapseSections;    //展开列表集合
    NSMutableSet *_completionsSet;      //赛事列表
    NSMutableSet *_rqsSet;              //让球列表, 非让球胜平负玩法忽略该参数

    PBMJczqBuy *_dataBase;       //原始数据
    PBMJczqBuy *_currentData;    //当前筛选条件下的数据

    PBMJczqMatch *_currentMatch;    //当前选择的比赛
    NSInteger _selectIndex;         //选中的位置
}
@property (nonatomic, strong) UIView *footerView;    //底部视图

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *promptLabel;    //底部文字

@property (nonatomic, strong) NSMutableArray *competitionList;    //筛选-赛事选择
@property (nonatomic, strong) NSMutableArray *rqsList;            //筛选-让球

@property (nonatomic, assign) GameTypeId gameType;    //筛选-让球

@end

@implementation DPHLCreateHeartLoveViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentData = [PBMJczqBuy message];
         _collapseSections = [NSMutableSet setWithCapacity:10];
        _completionsSet = [[NSMutableSet alloc] init];
        _rqsSet = [[NSMutableSet alloc] init];

        _competitionList = [NSMutableArray array];
        _rqsList = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresBottomLabs];
    [[DPToast sharedToast] dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DPToast sharedToast] dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起心水";
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];

    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.footerView.mas_top);
    }];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"filter.png") target:self action:@selector(pvt_onFilter)];

    [self showHUD];
    [self getDataFromeNet];

    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self getDataFromeNet];
    }];
}

#pragma mark - 数据请求
- (void)getDataFromeNet {
    DPLog(@"获取网络数据");
    [[AFHTTPSessionManager dp_sharedManager] GET:@"wages/jczqbuy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            self.tableView.emptyDataView.requestSuccess = YES;
            _dataBase = [PBMJczqBuy parseFromData:responseObject error:nil];
            [self filterData];
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

#pragma mark - 数据筛选
- (void)filterData {
    _currentMatch = nil;
    [_currentData.gamesArray removeAllObjects];
    [_completionsSet removeAllObjects];
    [_rqsSet removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJczqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJczqGame *cGame = [PBMJczqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJczqMatch *match = [game.matchesArray objectAtIndex:j];

            [cMatchArray addObject:match];
            [_completionsSet addObject:match.competitionName];
            [_rqsSet addObject:[NSNumber numberWithLongLong:match.rqs]];
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;
            cGame.gameStatusId = game.gameStatusId;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }

    [self pvt_reloadFilterInfo];
    [self refresBottomLabs];

    [self.tableView reloadData];
}

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

#pragma mark - 点击事件
- (void)didBackTapped {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)pvt_onFilter {
    if (_rqsSet.count == 0 && _completionsSet.count == 0) {
        return;
    }

    NSMutableArray *titlesArr = [[NSMutableArray alloc] init];
    NSMutableArray *groupsArr = [[NSMutableArray alloc] init];

    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];

    NSArray *sortDesc = @[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ];

    NSArray *competitionsList = [_completionsSet sortedArrayUsingDescriptors:sortDesc];

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
- (void)pvt_resetFilterInfo {
    NSSet *rqList = [self getTransletedRQS];

    [self filterDataCompletion:[NSSet setWithArray:self.competitionList] rqs:rqList];
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

    return [NSString stringWithFormat:@"%@ %@   %lu场比赛可投", dateString,
                                      [date dp_weekdayName], (unsigned long)numberOfRows];
}

- (void)pvt_onConfirm {
    if (_currentMatch) {
        DPHLHeartConfrimVC *confirmVC = [[DPHLHeartConfrimVC alloc] init];
        confirmVC.match = _currentMatch;
        confirmVC.gameType = self.gameType;
        confirmVC.userInfo = self.userInfo;
        confirmVC.selectedIndex = _selectIndex;
        [self.navigationController pushViewController:confirmVC animated:YES];
    } else {
        [[DPToast makeText:@"请选择1场比赛"] show];
    }
}

- (void)pvt_onCleanup {
    if (_currentMatch) {
        [_currentMatch.matchOption initializeOptionWithType:GameTypeJcHt];
        [self refresBottomLabs];
        [self.tableView reloadData];
        _currentMatch = nil;
    }
}

#pragma mark - 根据筛选条件进行数据筛选
- (void)filterDataCompletion:(NSSet *)completions rqs:(NSSet *)rqs {
    [_currentData.gamesArray removeAllObjects];

    NSMutableArray *cGamesArray = _currentData.gamesArray;

    for (int i = 0; i < _dataBase.gamesArray.count; i++) {
        PBMJczqGame *game = [_dataBase.gamesArray objectAtIndex:i];

        PBMJczqGame *cGame = [PBMJczqGame message];
        NSMutableArray *cMatchArray = cGame.matchesArray;

        for (int j = 0; j < game.matchesArray.count; j++) {
            PBMJczqMatch *match = [game.matchesArray objectAtIndex:j];

            if ([completions containsObject:match.competitionName] && [rqs containsObject:[NSNumber numberWithLongLong:match.rqs]]) {
                [cMatchArray addObject:match];
            }
        }

        if (cMatchArray.count) {
            cGame.gameName = game.gameName;
            cGame.gameStatusId = game.gameStatusId;

            cGame.gameId = game.gameId;

            [cGamesArray addObject:cGame];
        }
    }
    [self refresBottomLabs];

    [self.tableView reloadData];
}

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

- (void)updateSelectStatusWithMatch:(PBMJczqMatch *)match
                     selectGmaeType:(GameTypeId)gametype
                              index:(int)index
                             select:(BOOL)isSelect {
    PBMJczqMatch *baseMatch = [self getBaseMatchWithMatch:match];
    NSAssert(baseMatch, @"未找到相符的match");

    [baseMatch updateSelectStatusWithBaseType:GameTypeJcHt selectGmaeType:gametype index:index select:isSelect isAllSub:NO];
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

#pragma mark -
#pragma mark---------footerView
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];

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
        [_footerView addSubview:cleanupButton];
        [_footerView addSubview:confirmButton];
        [_footerView addSubview:self.promptLabel];
        [_footerView addSubview:confirmView];
        [_footerView addSubview:lineView];

        // layout
        [cleanupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView);
            make.bottom.equalTo(_footerView);
            make.left.equalTo(_footerView);
            make.width.equalTo(@50);
        }];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView);
            make.bottom.equalTo(_footerView);
            make.left.equalTo(cleanupButton.mas_right);
            make.right.equalTo(_footerView);
        }];

        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(confirmButton).offset(10);
            make.centerY.equalTo(_footerView.mas_centerY);
        }];

        [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(confirmButton).offset(-20);
            make.centerY.equalTo(confirmButton);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView);
            make.left.equalTo(_footerView);
            make.right.equalTo(_footerView);
            make.height.equalTo(@0.5);
        }];
    }
    return _footerView;
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(0xd0cfcd);
        _tableView.backgroundColor = [UIColor dp_flatBackgroundColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];

        DZNEmptyDataView *recomEmpty = [[DZNEmptyDataView alloc] init];
        recomEmpty.textForNoData = @"暂无数据";
        recomEmpty.imageForNoData = dp_LoadingImage(@"noMatch.png");

        _tableView.emptyDataView = recomEmpty;
        _tableView.emptyDataView.showButtonForNoData = NO;
        @weakify(self);

        _tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type) {
            @strongify(self);
            if (type == DZNEmptyDataViewTypeNoNetwork) {
                @strongify(self);
                [self.navigationController pushViewController:[DPWebViewController setNetWebController] animated:YES];
            } else if (type == DZNEmptyDataViewTypeFailure) {
                @strongify(self);
                [self showHUD];
                [self getDataFromeNet];
            }
        };
    }
    return _tableView;
}
#pragma mark---------UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int section = MAX(0, (int)_currentData.gamesArray.count);

    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_collapseSections containsObject:@(section)]) {
        return 0;
    }

    return MAX(0, ((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:section])
                      .matchesArray.count);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPHLMatchDetailCell *cell = [[DPHLMatchDetailCell alloc] initWithTableView:tableView atIndexPath:indexPath];

    @weakify(self);
    cell.betControlSelected = ^(DPHLMatchDetailCell *currentCell, DPBetToggleControl *control, GameTypeId gameType, int index, BOOL selected) {
        @strongify(self);
        DPLog(@"点击index= %d  选中select = %d", index, selected);

        NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];

        PBMJczqMatch *match =
            [((PBMJczqGame *)
                  [_currentData.gamesArray objectAtIndex:indexPath.section])
                    .matchesArray objectAtIndex:indexPath.row];

        if ([match isSelectedWithType:GameTypeJcHt] && selected) {
            [[DPToast makeText:@"一场比赛只能选择一个选项"] show];

        } else {
            if (selected) {
                if (_currentMatch) {
                    [[DPToast makeText:@"一次只能发起一场比赛的心水"] show];
                } else {
                    _currentMatch = match;
                    _selectIndex = index;
                    self.gameType = gameType;

                    control.selected = selected;

                    [self updateSelectStatusWithMatch:match
                                       selectGmaeType:gameType
                                                index:index
                                               select:selected];
                    [self refresBottomLabs];
                }
            } else {
                _currentMatch = nil;

                control.selected = selected;

                [self updateSelectStatusWithMatch:match
                                   selectGmaeType:gameType
                                            index:index
                                           select:selected];
                [self refresBottomLabs];
            }
        }

    };

    cell.match = [((PBMJczqGame *)[_currentData.gamesArray objectAtIndex:indexPath.section]).matchesArray objectAtIndex:indexPath.row];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView dp_viewWithColor:[UIColor colorWithWhite:1 alpha:0.8]];
    view.tag = section;

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor =
        [UIColor colorWithRed:0.84
                        green:0.84
                         blue:0.82
                        alpha:1];
    line1.userInteractionEnabled = NO;
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor =
        [UIColor colorWithRed:0.84
                        green:0.84
                         blue:0.82
                        alpha:1];
    line2.userInteractionEnabled = NO;

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    label.text = [self pvt_titleForSection:section];

    UIImageView *imageView = [[UIImageView alloc]
        initWithImage:[_collapseSections containsObject:@(section)]
                          ? dp_CommonImage(@"black_arrow_down.png")
                          : dp_CommonImage(@"black_arrow_up.png")];

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

#pragma mark - 更新底部提交文字

- (void)refresBottomLabs {
    DPLog(@"更新选中文字信息");

    int count = 0;

    for (PBMJczqGame *game in _dataBase.gamesArray) {
        for (PBMJczqMatch *match in game.matchesArray) {
            if ([match.matchOption hasSelectedWithType:GameTypeJcHt]) {
                count += 1;
            }
        }
    }

    if (count < 1) {
        self.promptLabel.text = @"请选择1场比赛";
        return;
    }

    self.promptLabel.text = [NSString stringWithFormat:@"已选%d场比赛", count];
}

@end
