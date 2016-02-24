//
//  DPResultListViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//  开奖公告单一彩种列表页面

#import "DPCalendarView.h"
#import "DPCollapseTableView.h"
#import "DPImageLabel.h"
#import "DPNavigationMenu.h"
#import "DPNavigationTitleButton.h"
#import "DPResultListViewController.h"
#import "DPResultListViews.h"
#import "DPResultZcDetailViewController.h"
#import "SVPullToRefresh.h"
#import "UIImage+ImageEffects.h"

#import "DPLTDltViewController.h"

#import "DPAnalyticsKit.h"
#import "DPJclqBuyViewController.h"
#import "DPJczqBuyViewController.h"
#import "DPNodataView.h"
#import "DPThirdCallCenter.h"
#import "DPWebViewController.h"
#import "DZNEmptyDataView.h"
#import "DrawNotice.pbobjc.h"
#import "UMSocial.h"

#define LOTTERY_RESULT_PAGE_TOTAL 20

@interface DPResultListViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    DPNavigationMenuDelegate,
    DPCalendarViewDelegate,
    UIGestureRecognizerDelegate,
    DPResultGameNameViewDelegate,
    UMSocialUIDelegate> {
@private
    DPCollapseTableView *_tableView;
    //    CLotteryResult *_resultInstance;
    DPNavigationTitleButton *_titleButton;
    DPNavigationMenu *_menu;
    UILabel *_gameNameLabel;
    DPCalendarView *_calendarView;
    DPResultGameNameView *_gameNameView;
    UIButton *_touZhuButton;

    int _cmdId;
    //无数据提示图
    DPNodataView *_noDataView;

    UIView *_headView;

    BOOL _isLoading;    //正在加载数据 1：
    int _dataTotal;     //数据总数
}

@property (nonatomic, strong, readonly) DPNodataView *noDataView;

@property (nonatomic, assign) GameTypeId internalGameType;
@property (nonatomic, assign) int internalGameIndex;
@property (nonatomic, strong) NSArray *internalGameTitles;
@property (nonatomic, strong) NSArray *internalGameImages;

@property (nonatomic, strong) NSDictionary *internalMapping;
@property (nonatomic, strong, readonly) DPCollapseTableView *tableView;
@property (nonatomic, strong, readonly) DPNavigationTitleButton *titleButton;
@property (nonatomic, strong, readonly) UIButton *touZhuButton;

@property (nonatomic, strong, readonly) DPNavigationMenu *menu;
@property (nonatomic, strong, readonly) UILabel *gameNameLabel;
@property (nonatomic, strong, readonly) DPCalendarView *calendarView;
@property (nonatomic, strong, readonly) DPResultGameNameView *gameNameView;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, copy) NSString *gameCurrentName;
@property (nonatomic, strong) MASConstraint *gameNameLabelHeight;
@end

@implementation DPResultListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.infoArray = [NSMutableArray array];
    }
    return self;
}

// 设置彩种, 同时生成对应彩种需要是数据. pop
- (void)setGameType:(GameTypeId)gameType {
    switch (gameType) {
        case GameTypeJcNone:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            _gameType = GameTypeJcNone;

            self.internalGameType = (gameType == GameTypeJcNone || gameType == GameTypeJcHt || gameType == GameTypeJcDgAll || gameType == GameTypeJcDg) ? GameTypeJcSpf : gameType;
            self.internalGameTitles = @[ @"胜平负", @"让球胜平负", @"比分", @"总进球", @"半全场" ];
            self.internalGameImages = @[ @"sfp.png", @"rq.png", @"bf.png", @"zjq.png", @"bqc.png" ];
            self.internalMapping = @{ @0 : @(GameTypeJcSpf),
                                      @1 : @(GameTypeJcRqspf),
                                      @2 : @(GameTypeJcBf),
                                      @3 : @(GameTypeJcZjq),
                                      @4 : @(GameTypeJcBqc),
                                      };
            self.touZhuButton.dp_eventId = DPAnalyticsTypeResultDetailJczq ;
            break;
        case GameTypeBdNone:
        case GameTypeBdRqspf:
        case GameTypeBdBf:
        case GameTypeBdZjq:
        case GameTypeBdBqc:
        case GameTypeBdSxds:
            _gameType = GameTypeBdNone;

            self.internalGameType = gameType == GameTypeBdNone ? GameTypeBdRqspf : gameType;
            self.internalGameTitles = @[ @"胜平负", @"比分", @"总进球", @"上下单双", @"半全场" ];
            self.internalGameImages = @[ @"bjsfp.png", @"bjbf.png", @"bjzjq.png", @"bjsxds.png", @"bjbqc.png" ];

            self.internalMapping = @{ @0 : @(GameTypeBdRqspf),
                                      @1 : @(GameTypeBdBf),
                                      @2 : @(GameTypeBdZjq),
                                      @3 : @(GameTypeBdSxds),
                                      @4 : @(GameTypeBdBqc),
                                      };
            break;
        case GameTypeLcNone:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            _gameType = GameTypeLcNone;

            self.internalGameType = (gameType == GameTypeLcNone || gameType == GameTypeLcHt) ? GameTypeLcSf : gameType;
            self.internalGameTitles = @[ @"胜负", @"让分胜负", @"大小分", @"胜分差" ];
            self.internalGameImages = @[ @"sf.png", @"rf.png", @"dxf.png", @"sfc.png" ];

            self.internalMapping = @{ @0 : @(GameTypeLcSf),
                                      @1 : @(GameTypeLcRfsf),
                                      @2 : @(GameTypeLcDxf),
                                      @3 : @(GameTypeLcSfc),
            };
            self.touZhuButton.dp_eventId = DPAnalyticsTypeResultDetailJclq ;
            break;
        default:
            _gameType = gameType;

            
            self.internalGameType = gameType;
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 布局. pop
    switch (self.gameType) {
        case GameTypeBdNone:
        case GameTypeJcNone:
        case GameTypeLcNone: {
            self.internalGameIndex = [[[self.internalMapping allKeysForObject:@(self.internalGameType)] firstObject] intValue];
            self.titleButton.titleText = self.internalGameTitles[self.internalGameIndex];
            self.navigationItem.titleView = self.titleButton;
            [self.touZhuButton setTitle:[NSString stringWithFormat:@"竞彩%@投注", self.internalGameTitles[self.internalGameIndex]] forState:UIControlStateNormal];

            _headView = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
                UIView *titleView = [[UIView alloc] init];
                titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.87 alpha:1];
                UILabel *label1 = [[UILabel alloc] init];
                UILabel *label2 = [[UILabel alloc] init];
                UILabel *label3 = [[UILabel alloc] init];
                UILabel *label4 = [[UILabel alloc] init];
                label1.backgroundColor = label2.backgroundColor = label3.backgroundColor = label4.backgroundColor = [UIColor clearColor];
                label1.textColor = label2.textColor = label3.textColor = label4.textColor = [UIColor dp_flatBlackColor];
                label1.font = label2.font = label3.font = label4.font = [UIFont dp_systemFontOfSize:12];
                label1.textAlignment = label2.textAlignment = label3.textAlignment = label4.textAlignment = NSTextAlignmentCenter;
                label2.layer.borderColor = label3.layer.borderColor = [UIColor colorWithRed:0.87 green:0.86 blue:0.82 alpha:1].CGColor;
                label2.layer.borderWidth = label3.layer.borderWidth = 0.5;
                label1.text = @"赛事";
                label2.text = self.gameType == GameTypeLcNone ? @"客队" : @"主队";
                label3.text = @"彩果\n比分";
                label4.text = self.gameType == GameTypeLcNone ? @"主队" : @"客队";
                label3.numberOfLines = 0;
                [titleView addSubview:label1];
                [titleView addSubview:label2];
                [titleView addSubview:label3];
                [titleView addSubview:label4];
                [view addSubview:self.gameNameLabel];
                [view addSubview:titleView];
                CGFloat width = floor(kScreenWidth / 4);
                [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@(width - 5));
                    make.left.equalTo(titleView);
                }];
                [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@(width + 5));
                    make.left.equalTo(label1.mas_right);
                }];
                [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@(width - 5));
                    make.left.equalTo(label2.mas_right).offset(-0.5);
                }];
                [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleView);
                    make.bottom.equalTo(titleView);
                    make.width.equalTo(@(width + 5));
                    make.left.equalTo(label3.mas_right);
                }];

                [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.top.equalTo(view);
                    make.height.equalTo(@28);
                }];
                [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.top.equalTo(self.gameNameLabel.mas_bottom);
                    make.bottom.equalTo(view);
                }];

                UIView *line1 = [[UIView alloc] init];
                UIView *line2 = [[UIView alloc] init];
                line1.backgroundColor = [UIColor colorWithRed:0.81 green:0.8 blue:0.78 alpha:1];
                line2.backgroundColor = [UIColor colorWithRed:0.87 green:0.86 blue:0.82 alpha:1];
                [view addSubview:line1];
                [view addSubview:line2];
                [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.height.equalTo(@0.5);
                    make.top.equalTo(titleView);
                }];
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view);
                    make.right.equalTo(view);
                    make.height.equalTo(@0.5);
                    make.bottom.equalTo(titleView);
                }];

                view;
            });

            self.tableView.tableHeaderView = _headView;
            [self.titleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onNavTitle)]];

            UIBarButtonItem *gamesItem = [UIBarButtonItem dp_itemWithTitle:@"往期" target:self action:@selector(pvt_onGames)];
//            UIBarButtonItem *shareItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(pvt_onShare)];

            self.navigationItem.rightBarButtonItem = gamesItem;
            self.title = [NSString stringWithFormat:@"%@开奖公告", dp_GameTypeFirstName(self.gameType)];
        } break;
        case GameTypeZcNone:
            self.title = @"胜负彩(任九)开奖公告";
            [self.touZhuButton setTitle:@"竞彩胜负彩投注" forState:UIControlStateNormal];

            break;
        case GameTypeSd:
        case GameTypeSsq:
        case GameTypeQlc:
        case GameTypeDlt:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:

            self.title = [dp_GameTypeFullName(self.gameType) stringByAppendingString:@"开奖公告"];
            [self.touZhuButton setTitle:[NSString stringWithFormat:@"%@投注", dp_GameTypeFullName(self.gameType)] forState:UIControlStateNormal];
            self.touZhuButton.dp_eventId = DPAnalyticsTypeResultDetailDlt ;
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    if (!IsGameTypeLc(self.internalGameType) && !IsGameTypeJc(self.internalGameType) && self.internalGameType != GameTypeDlt) {
        self.isFromClickMore = YES;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isFromClickMore) {
            make.edges.equalTo(self.view);
        } else {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 50, 0));
        }
    }];

    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        self.tableView.showsInfiniteScrolling = NO;
        [self requestDrawInfoList:YES];
        _isLoading = YES;
    }];
    if (!IsGameTypeLc(self.internalGameType) && !IsGameTypeJc(self.internalGameType)) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            @strongify(self);
            if (!(self->_isLoading)) {
                [self requestDrawInfoList:NO];
                _isLoading = YES;
            }
        }];
        
        self.tableView.showsInfiniteScrolling = NO;
    }

    [self requestDrawInfoList:YES];

    if (self.isFromClickMore) {
        return;
    }

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor dp_colorFromRGB:0xDAD5CC];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    [self.view addSubview:self.touZhuButton];
    [self.touZhuButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.view).offset(-5);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(lineView.mas_bottom).offset(5);
    }];
    

}


- (void)requestDrawInfoList:(BOOL)reload {
    int ps = LOTTERY_RESULT_PAGE_TOTAL;
    int pi = 1;
    if (!reload) {
        pi = (int)[self.infoArray count] / ps + 1;
    } else {
        [_infoArray removeAllObjects];
    }
    NSString *urlString = @"";
    switch (self.internalGameType) {
        case GameTypeSsq:
            urlString = [NSString stringWithFormat:@"/draw/GetSsqDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeDlt:
            urlString = [NSString stringWithFormat:@"/draw/GetDltDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeQlc:
            urlString = [NSString stringWithFormat:@"/draw/GetQlcDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeQxc:
            urlString = [NSString stringWithFormat:@"/draw/GetQxcDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeSd:
            urlString = [NSString stringWithFormat:@"/draw/GetSdDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypePs:
            urlString = [NSString stringWithFormat:@"/draw/GetPsDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypePw:
            urlString = [NSString stringWithFormat:@"/draw/GetPwDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeZcNone:
        case GameTypeZc14:
        case GameTypeZc9:
            urlString = [NSString stringWithFormat:@"/draw/GetZcDrawList?pi=%d&ps=%d", pi, ps];
            break;
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcSpf: {
            
            if (self.gameTime.length<1) {
                urlString = [NSString stringWithFormat:@"/draw/GetJczqDrawDetail?gameTime=%@&gametypeid=%d&gameid=0",@"", self.internalGameType];
            }else{
                urlString = [NSString stringWithFormat:@"/draw/GetJczqDrawDetail?gameTime=%d&gametypeid=%d&gameid=0", [[NSDate dp_coverDateString:self.gameTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"yyyyMMdd"] intValue], self.internalGameType];
            }
//            urlString = [NSString stringWithFormat:@"/draw/GetJczqDrawDetail?gameTime=%@&gametypeid=%d&gameid=0", [NSDate dp_coverDateString:self.gameTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"yyyyMMdd"] , self.internalGameType];
        } break;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf: {
            if (self.gameTime.length<1) {
                  urlString = [NSString stringWithFormat:@"/draw/GetJclqDrawDetail?gameTime=%@&gametypeid=%d&gameid=0",@"", self.internalGameType];
            }else{
            urlString = [NSString stringWithFormat:@"/draw/GetJclqDrawDetail?gameTime=%d&gametypeid=%d&gameid=0", [[NSDate dp_coverDateString:self.gameTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"yyyyMMdd"] intValue], self.internalGameType];
            }
        } break;
        default:
//            NSParameterAssert(NO);
            break;
    }
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] GET:urlString
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            self.tableView.emptyDataView.requestSuccess = YES;
            [self dismissHUD];
            switch (self.internalGameType) {
                case GameTypeSsq:
                case GameTypeDlt:
                case GameTypeQlc:
                case GameTypeQxc:
                case GameTypeSd:
                case GameTypePs:
                case GameTypePw: {
                    PBMDrawNumDetailList *buy = [PBMDrawNumDetailList parseFromData:responseObject error:nil];
                    [self.infoArray addObjectsFromArray:buy.itemsArray];
                    [self showOrHiddenNodataView:0];
                    _dataTotal = buy.total;

                } break;
                case GameTypeZcNone:
                case GameTypeZc14:
                case GameTypeZc9: {
                    PBMDrawZcDetailList *buy = [PBMDrawZcDetailList parseFromData:responseObject error:nil];
                    [self.infoArray addObjectsFromArray:buy.itemsArray];
                    [self showOrHiddenNodataView:0];
                    _dataTotal = buy.total;

                } break;
                case GameTypeJcRqspf:
                case GameTypeJcBf:
                case GameTypeJcZjq:
                case GameTypeJcBqc:
                case GameTypeJcSpf:
                case GameTypeLcSf:
                case GameTypeLcRfsf:
                case GameTypeLcSfc:
                case GameTypeLcDxf: {
                    PBMDrawSportDetailList *buy = [PBMDrawSportDetailList parseFromData:responseObject error:nil];
                    [self.infoArray addObjectsFromArray:buy.itemsArray];
                    self.gameCurrentName = buy.gameName;

                    [self showOrHiddenNodataView:0];

                } break;

                default:
                    break;
            }

        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self dismissHUD];
            self.tableView.emptyDataView.requestSuccess = NO;
            [self.tableView reloadData];
//            self.tableView.infiniteScrollingView
            [[DPToast makeText:error.dp_errorMessage] show];
        }];
}

// 无数据界面
- (void)showOrHiddenNodataView:(NSInteger)ret {
    if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
        [self.tableView closeAllCells];
    }
    NSInteger sectionCount = self.infoArray.count;
    BOOL showInfiniteScroll = YES;    // 是否显示下拉刷新
    if ([AFNetworkReachabilityManager sharedManager].reachable == NO) {
        if (sectionCount <= 0) {
            self.noDataView.noDataState = DPNoDataNoworkNet;
            self.tableView.tableHeaderView = self.noDataView;
        } else {
            [[DPToast makeText:kNoWorkNet_] show];
        }
        showInfiniteScroll = NO;
//    } else if (ret == ERROR_TimeOut || ret == ERROR_ConnectHostFail || ret == ERROR_NET || ret == ERROR_DATA) {
//        if (sectionCount <= 0) {
//            self.noDataView.noDataState = DPNoDataWorkNetFail;
//            self.tableView.tableHeaderView = self.noDataView;
//        } else {
//            [[DPToast makeText:kWorkNetFail_] show];
//        }
//        showInfiniteScroll = NO;
    } else if (sectionCount <= 0) {
        self.noDataView.noDataState = DPNoData;
        self.tableView.tableHeaderView = self.noDataView;
        showInfiniteScroll = NO;
    }
    BOOL numGame = IsGameTypeJc(self.internalGameType) || IsGameTypeLc(self.internalGameType);
    if (numGame) {
        self.gameNameLabel.text = [[NSDate dp_dateFromString:self.gameCurrentName withFormat:@"yyyyMMdd"]dp_stringWithFormat:@"yyyy年MM月dd日  EEEE"];
//        self.gameNameLabelHeight.equalTo(@0);
    }
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
    if (numGame == NO) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView openCellAtModelIndex:path animation:0];
    }

//    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    [self dismissHUD];
    _isLoading = NO;

    if (self.tableView.infiniteScrollingView) {
        [self.tableView.infiniteScrollingView stopAnimating];
        if (showInfiniteScroll) [self.tableView setShowsInfiniteScrolling:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController dp_applyGlobalTheme];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

#pragma mark - event

- (void)pvt_onNavTitle {
    [self.titleButton turnArrow];
    [self.menu setSelectedIndex:self.internalGameIndex];
    [self.menu show];
}

- (void)pvt_onGames {
    //    if (self.gameType == GameTypeBdNone && _resultInstance->GetListGameCount() == 0) {
    //        return;
    //    }

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onCover:)];
    tapGestureRecognizer.delegate = self;
    
    UIImage *image = [self.navigationController.view dp_screenshot];
    image = [image dp_applyBlurWithRadius:10 tintColor:nil saturationDeltaFactor:1.1 maskImage:nil];

    UIImageView *coverView = [[UIImageView alloc] init];
    coverView.image = image;
    coverView.alpha = 0;
    coverView.userInteractionEnabled = YES;
    [coverView addGestureRecognizer:tapGestureRecognizer];
    [self.navigationController.view addSubview:coverView];

    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];

    if (self.gameType == GameTypeLcNone ) {
        [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeResultDetailPreviousJczq)] props:nil];

    }else if(self.gameType == GameTypeJcNone){

        [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(DPAnalyticsTypeResultDetailPreviousJclq)] props:nil];

    }
    if (self.gameType == GameTypeLcNone || self.gameType == GameTypeJcNone) {
        NSDate *date = [NSDate dp_dateFromString:self.gameCurrentName withFormat:@"yyyyMMdd"];

         [coverView addSubview:self.calendarView];
        [self.calendarView setSelectedDate:date];
        [self.calendarView setToday:[NSDate dp_date]];
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IOS_VERSION_7_OR_ABOVE) {
                make.edges.insets(UIEdgeInsetsMake(20, 0, 0, 0));
            } else {
                make.edges.equalTo(coverView);
            }
        }];
    }
    /*
    else {
        string gameName;
        _resultInstance->GetListCurrentGameName(gameName);
        int selected = [[NSString stringWithUTF8String:gameName.c_str()] intValue];
        for (int i = 0; i < _resultInstance->GetListGameCount(); i++) {
            int gameName, gameId;
            _resultInstance->GetListGameId(i, gameId, gameName);
            if (selected == gameName) {
                selected = i;
            }
        }
        [self.gameNameView setSelectedIndex:selected];
        [coverView addSubview:self.gameNameView];
        [self.gameNameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IOS_VERSION_7_OR_ABOVE) {
                make.edges.insets(UIEdgeInsetsMake(80, 0, 0, 0));
            } else {
                make.edges.insets(UIEdgeInsetsMake(60, 0, 0, 0));
            }
        }];
        
        UIView* bgv = [[UIView alloc]init];
        bgv.backgroundColor = [UIColor dp_flatRedColor] ;
        [coverView addSubview:bgv];
        [bgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(coverView) ;
            if (IOS_VERSION_7_OR_ABOVE) {
                make.height.equalTo(@70) ;
            } else {
                make.height.equalTo(@50);
            }
            make.width.equalTo(coverView);
            make.left.equalTo(coverView) ;
        }];

    }
     */

    [UIView animateWithDuration:0.2
                     animations:^{
                         coverView.alpha = 1;
                     }];
}

- (void)pvt_onShare {
    
}
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
}

- (void)pvt_onCover:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UIView *view = [sender view];
        [UIView animateWithDuration:0.3
            animations:^{
                [view setAlpha:0];
            }
            completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
    } else if ([sender isKindOfClass:[UIView class]]) {
        [UIView animateWithDuration:0.3
            animations:^{
                [sender setAlpha:0];
            }
            completion:^(BOOL finished) {
                [sender removeFromSuperview];
            }];
    }
}

#pragma mark - table view's data source and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsGameTypeJc(self.internalGameType) || IsGameTypeBd(self.internalGameType) || IsGameTypeLc(self.internalGameType)) {
        static NSString *CellIdentifier = @"Cell";
        DPSportsResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPSportsResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell buildLayout:self.gameType == GameTypeLcNone];    // 篮彩主客相反
        }
        if (self.infoArray.count <= indexPath.row) {
            return cell;
        }
        PBMDrawSportDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];

        cell.competitionLabel.text = item.competition;
        cell.orderNumberLabel.text = item.orderNumber;
        cell.startTimeLabel.text = [NSDate dp_coverDateString:item.stratTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm];

        // 大小分(总分)
        if (self.internalGameType == GameTypeLcDxf) {
            cell.resultLabel.text = [NSString stringWithFormat:@"%@(%@)", item.resluts, item.balance];
        } else {
            cell.resultLabel.text = item.resluts;
        }
        // 让球, 让分

        cell.awayLabel.text = item.awayName;
        if (self.internalGameType == GameTypeLcRfsf || self.internalGameType == GameTypeJcRqspf || self.internalGameType == GameTypeBdRqspf) {
            NSString *homeName = item.homeName;
            NSString *regulated = item.balance;

            if (regulated.integerValue == 0) {
                cell.homeLabel.text = homeName;
            } else {
                MTStringParser *parser = [[MTStringParser alloc] init];
                [parser setDefaultAttributes:({
                            MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                            attr.textColor = [UIColor dp_flatBlackColor];
                            attr.font = [UIFont dp_systemFontOfSize:12];
                            attr.alignment = NSTextAlignmentCenter;
                            attr;
                        })];
                [parser addStyleWithTagName:@"red" font:[UIFont dp_systemFontOfSize:10] color:[UIColor dp_flatRedColor]];
                [parser addStyleWithTagName:@"blue" font:[UIFont dp_systemFontOfSize:10] color:[UIColor dp_flatBlueColor]];

                if (regulated.floatValue < 0) {
                    regulated = [NSString stringWithFormat:@"<blue>(%@)</blue>", regulated];
                } else {
                    regulated = [NSString stringWithFormat:@"<red>(+%@)</red>", regulated];
                }

                cell.homeLabel.attributedText = [parser attributedStringFromMarkup:[homeName stringByAppendingString:regulated]];
            }
        } else {
            cell.homeLabel.text = item.homeName;
        }
        // 篮彩主客相反
        if (item.homeScore<0||item.awayScore<0) {
             cell.scoreLabel.text =@"-:-";
        }else{
        if (self.gameType == GameTypeLcNone) {
            cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", item.awayScore, item.homeScore];
        } else {
            cell.scoreLabel.text = [NSString stringWithFormat:@"%d:%d", item.homeScore, item.awayScore];
        }
        }
        // 彩果色值
        switch (self.internalGameType) {
            case GameTypeLcSf:
            case GameTypeLcRfsf:
            case GameTypeJcRqspf:
            case GameTypeJcSpf:
            case GameTypeBdRqspf:
                if (([cell.resultLabel.text rangeOfString:@"胜"]).location != NSNotFound) {
                    cell.resultView.backgroundColor = [UIColor colorWithRed:0.97 green:0.79 blue:0.76 alpha:1];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.76 green:0.32 blue:0.32 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.76 green:0.32 blue:0.32 alpha:1];
                } else if (([cell.resultLabel.text rangeOfString:@"负"]).location != NSNotFound) {
                    cell.resultView.backgroundColor = [UIColor colorWithRed:0.82 green:0.99 blue:0.81 alpha:1];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.13 green:0.37 blue:0.07 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.13 green:0.37 blue:0.07 alpha:1];
                } else {
                    cell.resultView.backgroundColor = [UIColor clearColor];
                    cell.scoreLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
                    cell.resultLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
                }
                break;
            case GameTypeJcBf:
            case GameTypeJcBqc:
            case GameTypeJcZjq:
            case GameTypeBdBf:
            case GameTypeBdBqc:
            case GameTypeBdZjq:
            case GameTypeBdSxds:
            case GameTypeLcSfc:
            case GameTypeLcDxf:
                cell.resultView.backgroundColor = [UIColor dp_flatWhiteColor];
                cell.scoreLabel.textColor = [UIColor dp_flatRedColor];
                cell.resultLabel.textColor = [UIColor dp_flatRedColor];
                break;
            default:
                break;
        }
        return cell;

    } else {
        NSString *CellIdentifier = (indexPath.row == 0 ? @"Cell0" : @"Cell");
        DPNumberResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DPNumberResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell layoutWithType:self.internalGameType prettyStyle:indexPath.row == 0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (self.infoArray.count <= indexPath.row) {
            return cell;
        }
        int gameName, gameId;
        NSString *drawTime = @"";
        if (IsGameTypeZc(self.internalGameType)) {
            PBMDrawZcDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
            gameId = (int)item.gameId;
            gameName = [item.gameName intValue];
            drawTime = item.drawTime;
        } else {
            PBMDrawNumDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
            gameId = (int)item.gameId;
            gameName = [item.gameName intValue];
            drawTime = item.drawTime;
        }
        //        _resultInstance->GetListTarget((int)indexPath.row, result, gameName, gameId, drawTime);

        cell.gameNameLabel.text = [NSString stringWithFormat:@"第%d期截止", gameName];
        cell.drawTimeLabel.text = [NSDate dp_coverDateString:drawTime
                                                  fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                                    toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
        cell.arrowView.highlighted = [tableView isExpandAtModelIndex:indexPath];

        switch (self.internalGameType) {
            case GameTypeSsq:
            case GameTypeQlc:
            case GameTypeDlt: {
                PBMDrawNumDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
                NSString *resultString = [item.resluts stringByReplacingOccurrencesOfString:@"|" withString:@","];
                resultString = [resultString stringByReplacingOccurrencesOfString:@",," withString:@","];
                NSArray *array = [resultString componentsSeparatedByString:@","];
                if (array.count < cell.drawItems.count) {
                    return cell;
                }
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    label.text = [NSString stringWithFormat:@"%@", array[i]];
                }
            } break;
            case GameTypeSd: {
                PBMDrawNumDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
                NSArray *array = [item.resluts componentsSeparatedByString:@"|"];
                NSString *resultString = [array objectAtIndex:0];
                NSString *proResultString = [array objectAtIndex:1];
                // 设置试机号
                if (proResultString.length >= 3) {
                    cell.preResultLabel.text = [NSString stringWithFormat:@"%@  %@  %@", [proResultString substringWithRange:NSMakeRange(0, 1)], [proResultString substringWithRange:NSMakeRange(1, 1)], [proResultString substringWithRange:NSMakeRange(2, 1)]];
                }

                // 只有试机号没有奖号时隐藏
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    label.hidden = resultString.length < 3 ? YES : NO;
                    if (resultString.length == 3) {
                        label.text = [resultString substringWithRange:NSMakeRange(i, 1)];
                    }
                }
            }
            case GameTypePs:
            case GameTypePw:
            case GameTypeQxc: {
                PBMDrawNumDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    if (i < item.resluts.length) {
                        label.text = [NSString stringWithFormat:@"%@", [item.resluts substringWithRange:NSMakeRange(i, 1)]];
                    }
                }
            }
            case GameTypeZcNone: {
                PBMDrawZcDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
                for (int i = 0; i < cell.drawItems.count; i++) {
                    UILabel *label = cell.drawItems[i];
                    if (i < item.resluts.length) {
                        label.text = [NSString stringWithFormat:@"%@", [item.resluts substringWithRange:NSMakeRange(i, 1)]];
                    }
                }
            } break;

            default:
                break;
        }

        return cell;
    }
}

- (void)tableView:(DPCollapseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameType == GameTypeJcNone || self.gameType == GameTypeLcNone || self.gameType == GameTypeBdNone) {
        return;
    }
  DPNumberResultListCell *cell = (DPNumberResultListCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL expand = NO;
    NSIndexPath *modelIndex = [tableView modelIndexFromTableIndex:indexPath expand:&expand];

    if (!expand) {
//        NSIndexPath *indexPath = tableView.expandModelIndexs.firstObject;
//        if (indexPath && indexPath != modelIndex) {
//            DPNumberResultListCell *cell = (DPNumberResultListCell *)[tableView cellForRowAtModelIndex:indexPath expand:NO];
//            cell.arrowView.highlighted = NO;
//        }

        BOOL isexpande = [tableView isExpandAtModelIndex:modelIndex];
        [tableView toggleCellAtModelIndex:modelIndex animation:YES];

        if (!isexpande) {
            NSIndexPath *newIndexPath = [tableView tableIndexFromModelIndex:tableView.expandModelIndexs.firstObject expand:NO];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

       
        cell.arrowView.highlighted = [tableView isExpandAtModelIndex:modelIndex];
    }
}

- (CGFloat)tableView:(DPCollapseTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IsGameTypeJc(self.internalGameType) || IsGameTypeBd(self.internalGameType) || IsGameTypeLc(self.internalGameType)) {
        return 35;
    }
    return 60;
    //    return indexPath.row == 0 ? 60 : 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    BOOL numGame = IsGameTypeJc(self.internalGameType) || IsGameTypeLc(self.internalGameType);
//    if (numGame) {
//        return 65;
//    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headView;
}
- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.gameType) {
        case GameTypeSsq:
        case GameTypeQxc:
            return 250;
        case GameTypeQlc:
            return 275;
        case GameTypeDlt:
            return 375;
        case GameTypeSd:
        case GameTypePs:
            return 175;
        case GameTypePw:
            return 125;
        case GameTypeZcNone:
            return 275 + 40;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InfoCell";
    DPNumberResultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DPNumberResultInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setGameType:self.gameType];

        __weak DPCollapseTableView *weakTableView = tableView;
        __weak DPResultListViewController *weakSelf = self;
        //        __block CLotteryResult *weakResultInstance = _resultInstance;
        [cell buildLayout:^(DPNumberResultInfoCell *cell) {
            NSIndexPath *indexPath = [weakTableView modelIndexForCell:cell];
            //            int gameName, gameId; string drawTime;
            //            weakResultInstance->GetListTarget((int)indexPath.row, NULL, gameName, gameId, drawTime);
            PBMDrawZcDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
            DPResultZcDetailViewController *viewController = [[DPResultZcDetailViewController alloc] init];
            viewController.gameId = (int)item.gameId;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }];
    }
    int count = self.gameType == GameTypeZcNone ? 2 : 1;
    for (int i = 0; i < count; i++) {
        int64_t globalAmount, globalSurplus;
        int winCount[15] = {0}, winAmt[15] = {0};
        //        _resultInstance->GetListTargetInfo((int)indexPath.row, globalAmount, globalSurplus, winCount, winAmt, i);
        if (self.gameType == GameTypeZcNone) {
            PBMDrawZcDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
            globalAmount = (int)item.zc14GlobalAmount;
            globalSurplus = (int)item.zc14GlobalSurplus;
            for (int j = 0; j < 15; j++) {
                if (item.zc14WinCountArray.count > j) {
                    winCount[j] = (int)[item.zc14WinCountArray valueAtIndex:j];
                }
                if (item.zc14WinAmountArray.count > j) {
                    winAmt[j] = (int)[item.zc14WinAmountArray valueAtIndex:j];
                }
            }
        } else {
            PBMDrawNumDetailList_Item *item = [self.infoArray objectAtIndex:indexPath.row];
            globalAmount = (int64_t)item.globalAmount;
            globalSurplus = (int64_t)item.globalSurplus;
            for (int j = 0; j < 15; j++) {
                if (item.winCountArray.count > j) {
                    winCount[j] = (int)[item.winCountArray valueAtIndex:j];
                }
                if (item.winAmountArray.count > j) {
                    winAmt[j] = (int)[item.winAmountArray valueAtIndex:j];
                }
            }
        }

        DPResultInfoGirdView *titleView = cell.titleList[i];
        DPResultInfoGirdView *detailView = cell.detailList[i];

        [titleView setTitle:[NSString stringWithFormat:@"%lld", globalAmount] forRow:1 column:0];
        [titleView setTitle:[NSString stringWithFormat:@"%lld", globalSurplus] forRow:1 column:1];

        if (self.gameType == GameTypeDlt) {
            for (int i = 0; i < 15; i++) {
                [detailView setTitle:[NSString stringWithFormat:@"%d", winCount[i]] forRow:i column:1];
                [detailView setTitle:[NSString stringWithFormat:@"%d", winAmt[i]] forRow:i column:2];
            }
        } else {
            for (int i = 0; i < 15; i++) {
                [detailView setTitle:[NSString stringWithFormat:@"%d", winCount[i]] forRow:i + 1 column:1];
                [detailView setTitle:[NSString stringWithFormat:@"%d", winAmt[i]] forRow:i + 1 column:2];
            }
        }
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (self.gameType != GameTypeJcNone &&
    //        self.gameType != GameTypeLcNone &&
    //        self.gameType != GameTypeBdNone) {

    CGFloat rowHeight = 0;
    if (IsGameTypeJc(self.internalGameType) || IsGameTypeBd(self.internalGameType) || IsGameTypeLc(self.internalGameType)) {
        rowHeight = 35;
    } else
        rowHeight = 60;

    //         CGFloat scrollViewContentHeight = scrollView.contentSize.height;
    //        CGFloat scrollOffsetThreshold = scrollViewContentHeight- scrollView.bounds.size.height - 5*rowHeight ;
    //
    //        if (!_isLoading && scrollView.contentOffset.y < scrollOffsetThreshold+5*rowHeight && scrollView.contentOffset.y > scrollOffsetThreshold && scrollView.infiniteScrollingView.state !=  SVInfiniteScrollingStateLoading) {
    //            _isLoading = YES ;
    ////            [self requestDrawInfoList:NO];
    ////             [self dpn_rebindId:_resultInstance->Net_RefreshList() type:DRAW_REFRESH_LIST];
    //         }

    //    }
}

#pragma mark - UIGestureRecognizerDelegate

// 处理竞彩日历. pop
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.gameType == GameTypeLcNone || self.gameType == GameTypeJcNone) {
        CGPoint point = [touch locationInView:self.calendarView];
        CGSize size = self.calendarView.contentSize;
        if (CGRectContainsPoint(CGRectMake(0, 0, size.width, size.height), point)) {
            return NO;
        }
//    } else {
//        CGPoint point = [touch locationInView:self.gameNameView];
//        CGFloat height = 43 * ((_resultInstance->GetListGameCount() - 1) / 3 + 1);
//        if (CGRectContainsPoint(CGRectMake(0, 0, 320, height), point)) {
//            return NO;
//        }
    }

    return YES;
}

#pragma mark - DPNavigationMenuDelegate
- (void)navigationMenu:(DPNavigationMenu *)menu selectedAtIndex:(int)index {
    self.internalGameIndex = index;
    self.internalGameType = (GameTypeId)[self.internalMapping[@(index)] integerValue];
    //    _resultInstance->SetGameType(self.internalGameType);
    //    [self dpn_rebindId:_resultInstance->Net_RefreshList() type:DRAW_REFRESH_LIST];
    [self.infoArray removeAllObjects];
    [self requestDrawInfoList:YES];
}

- (void)dismissNavigationMenu:(DPNavigationMenu *)menu {
    [self.titleButton restoreArrow];
    [self.titleButton setTitleText:self.menu.items[self.menu.selectedIndex]];
    [self.touZhuButton setTitle:[NSString stringWithFormat:@"竞彩%@投注", self.menu.items[self.menu.selectedIndex]] forState:UIControlStateNormal];
}

#pragma mark - DPCalendarViewDelegate
- (BOOL)calendarView:(DPCalendarView *)calendarView shouldSelectedDate:(NSDate *)date {
    if ([date dp_timeIntervalSinceNow] <= 0) {
        return YES;
    } else {
        [[DPToast makeText:@"不能大于今天!"] show];
        return NO;
    }
}

- (void)calendarView:(DPCalendarView *)calendarView didSelectedDate:(NSDate *)date {
    [self pvt_onCover:calendarView.superview];
    self.gameTime = [date dp_stringWithFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    //    [self dpn_rebindId:_resultInstance->Net_RefreshList(gameId) type:DRAW_REFRESH_LIST];
    [self.infoArray removeAllObjects];
    [self showHUD];
    [self requestDrawInfoList:YES];
}

#pragma mark - DPResultGameNameViewDelegate
- (NSString *)view:(DPResultGameNameView *)view titleAtIndex:(int)index {
    //    int gameId, gameName;
    //    _resultInstance->GetListGameId(index, gameId, gameName);
    //    return [NSString stringWithFormat:@"%d", gameName];
    return nil;
}

- (NSInteger)gameCountForView:(DPResultGameNameView *)view {
    //    return _resultInstance->GetListGameCount();
    return 0;
}

- (void)view:(DPResultGameNameView *)view didSelectedAtIndex:(int)index {
    [self pvt_onCover:view.superview];
    //    int gameId, gameName;
    //    _resultInstance->GetListGameId(index, gameId, gameName);
    //    [self dpn_rebindId:_resultInstance->Net_RefreshList(gameId) type:DRAW_REFRESH_LIST];
    //    [self showHUD];
}

#pragma mark - getter

- (DPNodataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[DPNodataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        //        _noDataView.gameType = GameTypeLcNone ;
        __weak __typeof(self) weakSelf = self;
        //        __block CLotteryResult *weak_resultInstance= _resultInstance;

        [_noDataView setClickBlock:^(BOOL setOrUpDate) {
            //            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (setOrUpDate) {
                DPWebViewController *webView = [[DPWebViewController alloc] init];
                webView.title = @"网络设置";
                NSString *path = [[NSBundle mainBundle] pathForResource:@"noNet" ofType:@"html"];
                NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSURL *url = [[NSBundle mainBundle] bundleURL];
                DPLog(@"html string =%@, url = %@ ", str, url);
                [webView.webView loadHTMLString:str baseURL:url];
                [weakSelf.navigationController pushViewController:webView animated:YES];
            } else {
                //                [weakSelf dpn_rebindId:weak_resultInstance->Net_RefreshList() type:DRAW_REFRESH_LIST];
                [weakSelf.infoArray removeAllObjects];
                [weakSelf requestDrawInfoList:YES];
            }

        }];
    }
    return _noDataView;
}

- (DPCollapseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DPCollapseTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.expandMutual = YES;
        
        _tableView.emptyDataView = [DZNEmptyDataView emptyDataView];
        @weakify(self);
        _tableView.emptyDataView.buttonTappedEvent = ^(DZNEmptyDataViewType type){
            @strongify(self);
            switch (type) {
                case DZNEmptyDataViewTypeNoData:
                {
                    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                    [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
                }
                    break;
                case DZNEmptyDataViewTypeFailure:
                {
                    [self requestDrawInfoList:YES];
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
    }
    return _tableView;
}

- (DPNavigationTitleButton *)titleButton {
    if (_titleButton == nil) {
        _titleButton = [[DPNavigationTitleButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    }
    return _titleButton;
}

- (UIButton *)touZhuButton {
    if (_touZhuButton == nil) {
        _touZhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touZhuButton.backgroundColor = [UIColor dp_flatRedColor];
        _touZhuButton.titleLabel.font = [UIFont dp_boldSystemFontOfSize:17];
        [_touZhuButton addTarget:self action:@selector(pv_touZhu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touZhuButton;
}

- (void)pv_touZhu {
    switch (self.gameType) {
        case GameTypeDlt: {
            [self.navigationController pushViewController:[[DPLTDltViewController alloc] init] animated:YES];
        } break;

        case GameTypeLcNone: {
            DPJclqBuyViewController *vc = [[DPJclqBuyViewController alloc] init];
            vc.gameType = self.internalGameType;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case GameTypeJcNone: {
            DPJczqBuyViewController *vc = [[DPJczqBuyViewController alloc] init];
            vc.gameType = self.internalGameType;
            [self.navigationController pushViewController:vc animated:YES];
        } break;

        default:
            break;
    }
}

- (DPNavigationMenu *)menu {
    if (_menu == nil) {
        _menu = [[DPNavigationMenu alloc] init];
        _menu.viewController = self;
        _menu.itemsImage = self.internalGameImages;

        _menu.items = self.internalGameTitles;
    }
    return _menu;
}

- (UILabel *)gameNameLabel {
    if (_gameNameLabel == nil) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        _gameNameLabel.textColor = [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1];
        _gameNameLabel.textAlignment = NSTextAlignmentCenter;
        _gameNameLabel.font = [UIFont dp_systemFontOfSize:13];
    }
    return _gameNameLabel;
}

- (DPCalendarView *)calendarView {
    if (_calendarView == nil) {
        _calendarView = [[DPCalendarView alloc] init];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (DPResultGameNameView *)gameNameView {
    if (_gameNameView == nil) {
        _gameNameView = [[DPResultGameNameView alloc] init];
        _gameNameView.delegate = self;
    }
    return _gameNameView;
}

@end
