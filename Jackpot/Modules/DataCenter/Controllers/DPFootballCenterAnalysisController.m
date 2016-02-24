//
//  DPFootballCenterAnalysisController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterAnalysisController.h"
#import "DPDataCenterTableController+Private.h"
#import "DPFootballCenterAnalysisViewModel.h"
#import "DPLiveDataCenterViews.h"
#import "FootballDataCenter.pbobjc.h"

@interface DPFootballCenterAnalysisController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _matchId;
}
@property (nonatomic, strong) DPFootballCenterAnalysisViewModel *viewModel;
@property (nonatomic, strong) MTStringParser *parser;
@property (nonatomic, strong) AFHTTPSessionManager *imageSessionMgr;    // 图片请求回话
@end

@implementation DPFootballCenterAnalysisController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"分析";
        _viewModel = [[DPFootballCenterAnalysisViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        _matchId = matchId;
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel] ;

    }
    return self;
}

- (void)dealloc {
    [self.imageSessionMgr invalidateSessionCancelingTasks:NO];
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (self.viewModel.message.homeWinTimes + self.viewModel.message.historyTieTimes + self.viewModel.message.awayWinTimes <= 0) {
                return 35;
            }
            return 130;
        } break;
        case 1:
            return 170;
            break;
        case 2:
            return 125;
            break;
        case 3:
            return 30;
            break;
        default:
            break;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3)
        return 0;
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderIdentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
    }
    static NSString *HeaderTexts[] = { @"历史交锋",
                                       @"近期战绩",
                                       @"未来对阵" };
    view.titleLabel.text = HeaderTexts[section];
    view.tag = section;

    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        return;
    }

    DPFootballAnalysisDetailController *vc = [[DPFootballAnalysisDetailController alloc] init];
    vc.title = [NSString stringWithFormat:@"%@ VS %@", self.viewModel.homeName, self.viewModel.awayName];
    vc.matchId = _matchId;
    vc.homeName = self.viewModel.homeName;
    vc.awayName = self.viewModel.awayName;
    [self.navController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMFootAnalysis *_analysisCenter = self.viewModel.message;
    switch (indexPath.section) {
        case 0: {
            static NSString *history_reuseIdentify = @"history_reuseIdentify";

            DPAnalysisHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:history_reuseIdentify];
            if (cell == nil) {
                cell = [[DPAnalysisHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:history_reuseIdentify];
            }
            cell.historyView.percentArray = @[ [NSNumber numberWithInt:_analysisCenter.homeWinTimes], [NSNumber numberWithInt:_analysisCenter.historyTieTimes], [NSNumber numberWithInt:_analysisCenter.awayWinTimes] ];
            cell.historyView.titleArray = @[ [NSString stringWithFormat:@"%@%d胜", _analysisCenter.matchInfo.homeTeamName, _analysisCenter.homeWinTimes], [NSString stringWithFormat:@"%d平", _analysisCenter.historyTieTimes], [NSString stringWithFormat:@"%@%d胜", _analysisCenter.matchInfo.awayTeamName, _analysisCenter.awayWinTimes] ];
            [cell.historyView setNeedsDisplay];
            return cell;
        }
        case 1: {
            static NSString *recent_reuseIdentify = @"recent_reuseIdentify";

            DPAnalysicRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:recent_reuseIdentify];
            if (cell == nil) {
                cell = [[DPAnalysicRecentCell alloc] initWithGameType:GameTypeJcNone reuseIdentifier:recent_reuseIdentify];
            }

            NSMutableArray *arrHome = [[NSMutableArray alloc] initWithCapacity:_analysisCenter.homeRecentStatusArray.count];
            for (int i = 0; i < _analysisCenter.homeRecentStatusArray.count; i++) {
                NSString *ss = [NSString stringWithFormat:@"%d", [_analysisCenter.homeRecentStatusArray valueAtIndex:i]];
                [arrHome addObject:ss];
            }
            cell.leftRecentView.recentArray = arrHome;

            NSMutableArray *arrAway = [[NSMutableArray alloc] initWithCapacity:_analysisCenter.homeRecentStatusArray.count];
            for (int i = 0; i < _analysisCenter.homeRecentStatusArray.count; i++) {
                NSString *ss = [NSString stringWithFormat:@"%d", [_analysisCenter.awayRecentStatusArray valueAtIndex:i]];
                [arrAway addObject:ss];
            }

            cell.rightRecentView.recentArray = arrAway;

            [cell.leftRecentView setNeedsDisplay];
            [cell.rightRecentView setNeedsDisplay];
            cell.leftRecentView.titleLabel.text = self.viewModel.homeName;
            cell.rightRecentView.titleLabel.text = self.viewModel.awayName;

            return cell;

        } break;
        case 2: {
            static NSString *reuseIdentify = @"reuseIdentify";

            DPAnalysisFutureCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
            if (cell == nil) {
                cell = [[DPAnalysisFutureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
            }
            cell.leftView.nodataView.image = dp_SportLiveImage(@"foot_down.png");
            cell.leftView.nodataView.hidden = _analysisCenter.homeItem.data.length;

            cell.leftView.nameLabel.text = self.viewModel.homeName;
            cell.leftView.timeLabel.text =[NSString stringWithFormat:@"%@开赛",[[_analysisCenter.homeItem.startTime componentsSeparatedByString:@" "]firstObject ]] ;
            cell.leftView.leftLabel.text = _analysisCenter.homeItem.homeTeamName;
            cell.leftView.rightLabel.text = _analysisCenter.homeItem.awayTeamName;
            [self setImageWitImgLabel:cell.leftView.leftImgView imgLink:_analysisCenter.homeItem.homeIcon];
            [self setImageWitImgLabel:cell.leftView.rightImgView imgLink:_analysisCenter.homeItem.awayIcon];

            cell.rightView.nodataView.image = dp_SportLiveImage(@"foot_down.png");
            cell.rightView.nodataView.hidden = _analysisCenter.awayItem.data.length;
             cell.rightView.nameLabel.text = self.viewModel.awayName;
            cell.rightView.timeLabel.text = [NSString stringWithFormat:@"%@开赛",[[_analysisCenter.awayItem.startTime componentsSeparatedByString:@" "]firstObject ]] ;
            cell.rightView.leftLabel.text = _analysisCenter.awayItem.homeTeamName;
            cell.rightView.rightLabel.text = _analysisCenter.awayItem.awayTeamName;
            [self setImageWitImgLabel:cell.rightView.leftImgView imgLink:_analysisCenter.awayItem.homeIcon];
            [self setImageWitImgLabel:cell.rightView.rightImgView imgLink:_analysisCenter.awayItem.awayIcon];

            return cell;

        } break;
        case 3: {
            static NSString *reuse_Detail = @"reuse_Detail";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_Detail];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse_Detail];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *detailLabel = [[UILabel alloc] init];
                detailLabel.text = @"详细分析＞＞";
                detailLabel.textAlignment = NSTextAlignmentCenter;
                detailLabel.textColor = UIColorFromRGB(0x3B78BE);
                detailLabel.font = [UIFont dp_systemFontOfSize:15];
                [cell.contentView addSubview:detailLabel];

                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(cell.contentView);
                    make.bottom.equalTo(cell.contentView);

                }];
            }

            return cell;

        } break;
        default:
            break;
    }

    return nil;
}

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.alignment = NSTextAlignmentCenter;
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr.textColor = UIColorFromRGB(0x535353);
                     attr;
                 })];
        [_parser addStyleWithTagName:@"font8" font:[UIFont dp_systemFontOfSize:8] color:UIColorFromRGB(0xa2a2a2)];
        [_parser addStyleWithTagName:@"win" color:UIColorFromRGB(0xEA2D30)];
        [_parser addStyleWithTagName:@"tie" color:UIColorFromRGB(0x78B623)];
        [_parser addStyleWithTagName:@"lose" color:UIColorFromRGB(0x424F9C)];
    }
    return _parser;
}
- (AFHTTPSessionManager *)imageSessionMgr {
    if (_imageSessionMgr == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;

        _imageSessionMgr = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        _imageSessionMgr.responseSerializer = [[AFImageResponseSerializer alloc] init];
        _imageSessionMgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }
    return _imageSessionMgr;
}

- (void)setImageWitImgLabel:(UIImageView *)imgLabel imgLink:(NSString *)url {
    imgLabel.image = dp_SportLotteryImage(@"defaultIcon.png");
    if (!url)
        return;

    UIImage *cachImg = [[AFImageDiskCache sharedCache] cachedImageForURL:url];

    if (cachImg) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *roundImage = [cachImg dp_resizedImageToSize:CGSizeMake(23, 23)];

            dispatch_async(dispatch_get_main_queue(), ^{
                imgLabel.image = roundImage;
            });
        });
        return;
    }
    [self.imageSessionMgr GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *task, UIImage *image) {

            // 处理图片
            UIImage *roundImage = [image dp_resizedImageToSize:CGSizeMake(23, 23)];

            // 缓存图片
            [[AFImageDiskCache sharedCache] cacheImage:image forURL:url];
            DPLog(@"图片请求成功");

            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgLabel.image = roundImage;
                                          }]];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            DPLog(@"图片请求失败");
            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgLabel.image = dp_SportLotteryImage(@"defaultIcon.png");
                                          }]];

        }];
}
@end

@interface DPFootballAnalysisDetailController () {
@private
    PBMFootAnalysisDetail *_dateCenter;
    UILabel *_signlLabel;

    NSInteger _histRow;      //历史行数
    NSInteger _recentRow;    //近期行数
    NSInteger _futuRow;      //未来行数
}
@property (nonatomic, strong, readonly) UILabel *signlLabel;
@property (nonatomic, strong) MTStringParser *parser;

@end

@implementation DPFootballAnalysisDetailController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
- (UILabel *)signlLabel {
    if (_signlLabel == nil) {
        _signlLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 0, kScreenWidth - 20, 20)];
        _signlLabel.textAlignment = NSTextAlignmentRight;
        _signlLabel.backgroundColor = [UIColor clearColor];
        _signlLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _signlLabel.textColor = UIColorFromRGB(0xADABA9);
        _signlLabel.text = @"以上数据仅供参考";
    }
    return _signlLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    self.view.backgroundColor = 
    self.tableView.backgroundColor = kBackColor ;
   
    [self showHUD];
     @weakify(self) ;
     [[AFHTTPSessionManager dp_sharedManager] GET:@"datacenter/GetFootBallMatchAnalysisDetail"
        parameters:@{ @"matchid" : @(self.matchId) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self) ;
            [self dismissHUD];
            _dateCenter = [PBMFootAnalysisDetail parseFromData:responseObject error:nil];

            _histRow = _dateCenter.homeHistory.matchInfoListArray.count;
            _recentRow = _dateCenter.homeRecent.matchInfoListArray.count;
            _futuRow = _dateCenter.homeFuture.matchInfoListArray.count;
            [self.tableView reloadData];
            [self.tableView reloadData];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self) ;
            [self dismissHUD];
            [[DPToast makeText:[NSString stringWithFormat:@"%@",error.dp_errorMessage]]show];
        }];

     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _histRow = 0;
    _recentRow = 0;
    _futuRow = 0;
    self.tableView.tableFooterView = self.signlLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _histRow <= 0 ? 1 : _histRow + 2;
        case 1:
            return _recentRow <= 0 ? 1 : _recentRow + _dateCenter.awayRecent.matchInfoListArray.count + 4;
        case 2:
            return _futuRow <= 0 ? 1 : _futuRow + _dateCenter.awayFuture.matchInfoListArray.count + 4;
        default:
            return 0;
    }
}

#define AnalysisTag 7777
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int  index = 0, future = 0;

    PBMFootAnalysisDetail_MatchInfoTitle *titleInfo;
    NSString *teamName;
    switch (indexPath.section) {
        case 0: {
             index = (int)indexPath.row - 2;
            future = 0;
            titleInfo = _dateCenter.homeHistory;
            teamName = self.homeName;
        } break;
        case 1: {
            future = 0;
            if (indexPath.row < _recentRow + 2) {
                 index = (int)indexPath.row - 2;
                titleInfo = _dateCenter.homeRecent;
                teamName = self.homeName;
            } else {
                 index = (int)indexPath.row - (int)_dateCenter.homeRecent.matchInfoListArray.count - 4;
                titleInfo = _dateCenter.awayRecent;
                teamName = self.awayName;
            }
        } break;
        case 2: {
            future = 1;
            if (indexPath.row < _futuRow + 2) {
                 index = (int)indexPath.row - 2;
                titleInfo = _dateCenter.homeFuture;
                teamName = self.homeName;

            } else {
                 index = (int)indexPath.row - (int)_dateCenter.homeFuture.matchInfoListArray.count - 4;
                titleInfo = _dateCenter.awayFuture;
                teamName = self.awayName;
            }
        } break;
        default:
            break;
    }
    if (index == -2) {
        static NSString *headIdentifer = @"headIdentifer";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headIdentifer];
            cell.contentView.backgroundColor=
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *textLab = [[UILabel alloc] init];
            textLab.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:textLab];
            textLab.tag = AnalysisTag + 1;
            textLab.layer.borderWidth = 0.5;
            textLab.font = [UIFont dp_systemFontOfSize:12];
            textLab.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor;

            [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(-0.5, 5, -0.5, 5)) ;
             }];
            
            UILabel *lineView = [[UILabel alloc]init];
            lineView.tag = AnalysisTag +22 ;
            lineView.backgroundColor = kLayerColor ;
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView) ;
                make.left.and.right.equalTo(textLab) ;
                make.height.equalTo(@0.5);
            }];

            UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
            _noDataImgLabel.hidden = YES;
            _noDataImgLabel.layer.borderWidth = 0.5;
            _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            _noDataImgLabel.tag = AnalysisTag + 4;
            _noDataImgLabel.image = dp_SportLiveImage(@"foot_left.png");
            _noDataImgLabel.contentMode = UIViewContentModeCenter;

            _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
        
        UIView *lineView = [cell.contentView viewWithTag:AnalysisTag+22] ;
        lineView.hidden = !(indexPath.row == 0) ;

        DPImageLabel *imgLab = (DPImageLabel *)[cell.contentView viewWithTag:AnalysisTag + 4];
        switch (indexPath.section) {
            case 0: {
                if (_histRow <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else {
                    imgLab.hidden = YES;
                }
            } break;
            case 1: {
                if (_recentRow <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else {
                    imgLab.hidden = YES;
                }

            } break;
            case 2: {
                if (_futuRow <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else {
                    imgLab.hidden = YES;
                }
            } break;
            default:
                break;
        }

        MTStringParser *parser = [[MTStringParser alloc] init];
        [parser setDefaultAttributes:({
                    MTStringAttributes *attributes = [[MTStringAttributes alloc] init];
                    attributes.font = [UIFont dp_systemFontOfSize:11];
                    attributes;
                })];
        [parser addStyleWithTagName:@"team" font:[UIFont dp_systemFontOfSize:13] color:UIColorFromRGB(0x272727)];
        [parser addStyleWithTagName:@"win" color:UIColorFromRGB(0xEA2D30)];
        [parser addStyleWithTagName:@"tie" color:UIColorFromRGB(0x78B623)];
        [parser addStyleWithTagName:@"lose" color:UIColorFromRGB(0x424F9C)];
        [parser addStyleWithTagName:@"home" color:UIColorFromRGB(0x7E725C)];

        UILabel *lab = (UILabel *)[cell.contentView viewWithTag:AnalysisTag + 1];
        if (future == 1) {
            NSString *markupText = [NSString stringWithFormat:@"   <team>%@</team>", teamName];
            lab.attributedText = [parser attributedStringFromMarkup:markupText];
        } else {
            NSString *markupText = [NSString stringWithFormat:@"   <team>%@</team> <win>%@</win> <tie>%@</tie> <lose>%@</lose>  <home>主场</home> <win>%@</win> <tie>%@</tie> <lose>%@</lose>", teamName, [NSString stringWithFormat:@"%d胜", titleInfo.totalWin], [NSString stringWithFormat:@"%d平", titleInfo.totalTie], [NSString stringWithFormat:@"%d负", titleInfo.totalLose], [NSString stringWithFormat:@"%d胜", titleInfo.homeWinTimes], [NSString stringWithFormat:@"%d平", titleInfo.homeTieTimes], [NSString stringWithFormat:@"%d负", titleInfo.homeLoseTimes]];
            lab.attributedText = [parser attributedStringFromMarkup:markupText];
        }

        return cell;
    } else if (index == -1) {
        if (future == 1) {
            static NSString *futureComIdentifer = @"futureComIdentifer";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:futureComIdentifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:futureComIdentifer];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                DPLiveOddsHeaderView *nameView = [[DPLiveOddsHeaderView alloc] init];
                nameView.tag = AnalysisTag + 2;
                nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
                nameView.titleFont = [UIFont dp_systemFontOfSize:12];
                [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:103], [NSNumber numberWithFloat:103], nil] whithHigh:30 withSeg:NO];
                nameView.backgroundColor = [UIColor dp_flatWhiteColor];
                [cell.contentView addSubview:nameView];

                [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                }];
            }
            DPLiveOddsHeaderView *nameView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:AnalysisTag + 2];
            [nameView setTitles:[NSArray arrayWithObjects:@"赛事和时间", @"主队", @"客队", nil]];

            return cell;
        }

        static NSString *headNameIdentifer = @"headNameIdentifer";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headNameIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headNameIdentifer];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            DPLiveOddsHeaderView *nameView = [[DPLiveOddsHeaderView alloc] init];
            nameView.tag = AnalysisTag + 3;
            nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
            nameView.titleFont = [UIFont dp_systemFontOfSize:12];
            [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84], [NSNumber numberWithFloat:84], [NSNumber numberWithFloat:58], [NSNumber numberWithFloat:84], nil] whithHigh:30 withSeg:NO];
            nameView.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:nameView];

            [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
        DPLiveOddsHeaderView *nameView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:AnalysisTag + 3];
        [nameView setTitles:[NSArray arrayWithObjects:@"赛事和时间", @"主队", @"比分", @"客队", nil]];

        return cell;
    }

    PBMFootAnalysisDetail_MatchInfoDetailInfo *celDetail = [titleInfo.matchInfoListArray objectAtIndex:index];

    if (future == 1) {    //未来赛事表格
        static NSString *contentFuture = @"contentFuture";
        DPLiveAnalysisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentFuture];
        if (cell == nil) {
            cell = [[DPLiveAnalysisViewCell alloc] initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:103], [NSNumber numberWithFloat:103], nil] reuseIdentifier:contentFuture withHight:30];
        }
        [cell.rootbgView changeNumberOfLinesWithIndex:0 withNumber:2];

        NSAttributedString *firstStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%@<font8>\n%@</font8>", celDetail.completion, [NSDate dp_coverDateString:celDetail.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]]];
        NSAttributedString *secondeStr = [self.parser attributedStringFromMarkup:celDetail.homeTeamName];
        NSAttributedString *fourStr = [self.parser attributedStringFromMarkup:celDetail.awayTeamName];
        NSArray *titleArray = [NSArray arrayWithObjects:firstStr, secondeStr, fourStr, nil];
        [cell.rootbgView setTitles:titleArray];
        return cell;
    }

    //历史和近期战绩表格
    static NSString *contentIdentifier = @"contentIdentifier";
    DPLiveAnalysisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIdentifier];
    if (cell == nil) {
        cell = [[DPLiveAnalysisViewCell alloc] initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84], [NSNumber numberWithFloat:84], [NSNumber numberWithFloat:58], [NSNumber numberWithFloat:84], nil] reuseIdentifier:contentIdentifier withHight:30];
    }
    [cell.rootbgView changeNumberOfLinesWithIndex:0 withNumber:2];

    NSString *homeMarkupText, *awayMarkupText;
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSString *homeTeamName = indexPath.row < _recentRow + 2 ? self.homeName : self.awayName;
        if ([celDetail.homeTeamName isEqualToString:homeTeamName]) {
            if (celDetail.homeScore > celDetail.awayScore) {
                homeMarkupText = [NSString stringWithFormat:@"<win>%@</win>", celDetail.homeTeamName];
            } else if (celDetail.homeScore == celDetail.awayScore) {
                homeMarkupText = [NSString stringWithFormat:@"<tie>%@</tie>", celDetail.homeTeamName];
            } else {
                homeMarkupText = [NSString stringWithFormat:@"<lose>%@</lose>", celDetail.homeTeamName];
            }
            awayMarkupText = celDetail.awayTeamName;
        } else if ([celDetail.awayTeamName isEqualToString:homeTeamName]) {
            homeMarkupText = celDetail.homeTeamName;
            if (celDetail.homeScore < celDetail.awayScore) {
                awayMarkupText = [NSString stringWithFormat:@"<win>%@</win>", celDetail.awayTeamName];
            } else if (celDetail.homeScore == celDetail.awayScore) {
                awayMarkupText = [NSString stringWithFormat:@"<tie>%@</tie>", celDetail.awayTeamName];
            } else {
                awayMarkupText = [NSString stringWithFormat:@"<lose>%@</lose>", celDetail.awayTeamName];
            }
        }
    }

    NSAttributedString *firstStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%@<font8>\n%@</font8>", celDetail.completion, [NSDate dp_coverDateString:celDetail.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]]];
    NSAttributedString *secondeStr = [self.parser attributedStringFromMarkup:homeMarkupText];
    NSAttributedString *thirdStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%d:%d", celDetail.homeScore, celDetail.awayScore]];
    NSAttributedString *fourStr = [self.parser attributedStringFromMarkup:awayMarkupText];
    NSArray *titleArray = [NSArray arrayWithObjects:firstStr, secondeStr, thirdStr, fourStr, nil];
    [cell.rootbgView setTitles:titleArray];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (_histRow <= 0) {
                return 35;
            } else if (indexPath.row == 1) {
                return 26;
            }
        } break;
        case 1: {
            if (_recentRow <= 0) {
                return 35;
            } else if (indexPath.row == 1 || indexPath.row == _dateCenter.homeRecent.matchInfoListArray.count + 3) {
                return 26;
            }
        } break;
        case 2: {
            if (_futuRow <= 0) {
                return 35;
            } else if (indexPath.row == 1 || indexPath.row == _dateCenter.homeFuture.matchInfoListArray.count + 3) {
                return 26;
            }
        } break;
        default:
            break;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderIdentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
    }
    static NSString *HeaderTexts[] = { @"历史交锋",
                                       @"近期战绩",
                                       @"未来对阵" };
    view.titleLabel.text = HeaderTexts[section];
    view.tag = section;

    return view;
}

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.alignment = NSTextAlignmentCenter;
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr.textColor = UIColorFromRGB(0x535353);
                     attr;
                 })];
        [_parser addStyleWithTagName:@"font8" font:[UIFont dp_systemFontOfSize:8] color:UIColorFromRGB(0xa2a2a2)];
        [_parser addStyleWithTagName:@"win" color:UIColorFromRGB(0xEA2D30)];
        [_parser addStyleWithTagName:@"tie" color:UIColorFromRGB(0x78B623)];
        [_parser addStyleWithTagName:@"lose" color:UIColorFromRGB(0x424F9C)];
    }
    return _parser;
}

@end
