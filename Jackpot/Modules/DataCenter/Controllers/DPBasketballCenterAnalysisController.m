//
//  DPBasketballCenterAnalysisController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterAnalysisController.h"
#import "DPDataCenterTableController+Private.h"
#import "DPBasketballCenterAnalysisViewModel.h"
#import "BasketballDataCenter.pbobjc.h"
#import <AFNetworking/AFNetworking.h>
#import "DPLiveDataCenterViews.h"
@interface DPBasketballCenterAnalysisController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _matchId;
}

@property (nonatomic, strong) DPBasketballCenterAnalysisViewModel *viewModel;
@property (nonatomic, strong) MTStringParser *parser;
@property (nonatomic, strong) AFHTTPSessionManager *imageSessionMgr;    // 图片请求回话
@end

@implementation DPBasketballCenterAnalysisController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"分析";
        _viewModel = [[DPBasketballCenterAnalysisViewModel alloc] initWithMatchId:matchId];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3)
        return 0;
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if ((self.viewModel.message.historyCombat.awayWinTimes + self.viewModel.message.historyCombat.homeWinTimes) <= 0) {
                return 35;
            }
            return 150;
            break;
        case 1: {
            if (indexPath.row == 0) {
                return 170;
            }
            return 100;
        } break;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMBasketballAnalysis *_analysisCenter = self.viewModel.message;
    switch (indexPath.section) {
        case 0: {
            static NSString *history_reuseIdentify = @"history_reuseIdentify";

            DPAnalysisLCHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:history_reuseIdentify];
            if (cell == nil) {
                cell = [[DPAnalysisLCHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:history_reuseIdentify];
            }

            PBMBasketballAnalysis_HistoryComBat *hsitoryCom = _analysisCenter.historyCombat;
            if (hsitoryCom) {
                cell.historyView.percentArray = @[ [NSString stringWithFormat:@"%d", hsitoryCom.awayWinTimes], [NSString stringWithFormat:@"%d", hsitoryCom.homeWinTimes] ];
                cell.historyView.teamNameArray = @[ _analysisCenter.matchInfo.awayName, _analysisCenter.matchInfo.homeName ];

                cell.historyView.scoreArray = @[ [NSString stringWithFormat:@"%d", hsitoryCom.bigSorceTimes], [NSString stringWithFormat:@"%d", hsitoryCom.smallSorceTimes] ];
            }

            [cell.historyView setNeedsDisplay];

            return cell;
        }
        case 1: {
            PBMBasketballAnalysis_RecentCombatGains *recentCom = _analysisCenter.recentGains;

            if (indexPath.row == 0) {
                static NSString *recent_reuseIdentify = @"recent_reuseIdentify";

                DPAnalysicRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:recent_reuseIdentify];
                if (cell == nil) {
                    cell = [[DPAnalysicRecentCell alloc] initWithGameType:GameTypeLcNone reuseIdentifier:recent_reuseIdentify];
                }

                NSMutableArray *recentLeftArr = [[NSMutableArray alloc] initWithCapacity:recentCom.awayCombatGainsArray.count];
                NSMutableArray *recentRightArr = [[NSMutableArray alloc] initWithCapacity:recentCom.homeCombatGainsArray.count];

                for (int i = 0; i < recentCom.awayCombatGainsArray.count; i++) {
                    [recentLeftArr addObject:[NSString stringWithFormat:@"%d", ([recentCom.awayCombatGainsArray valueAtIndex:i] > 0 ? 0 : -1)]];
                }

                for (int i = 0; i < recentCom.homeCombatGainsArray.count; i++) {
                    [recentRightArr addObject:[NSString stringWithFormat:@"%d", ([recentCom.homeCombatGainsArray valueAtIndex:i] > 0 ? 0 : -1)]];
                }

                cell.leftRecentView.titleLabel.text = self.viewModel.awayName;
                cell.rightRecentView.titleLabel.text = self.viewModel.homeName;

                cell.leftRecentView.recentArray = recentLeftArr;
                cell.rightRecentView.recentArray = recentRightArr;

                [cell.leftRecentView setNeedsDisplay];
                [cell.rightRecentView setNeedsDisplay];

                return cell;

            } else {
                static NSString *recent_reuseIden = @"recent_reuseIden";

                DPLCRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:recent_reuseIden];
                if (cell == nil) {
                    cell = [[DPLCRecentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recent_reuseIden];
                }

                cell.leftPlotView.scoreArray = @[ [NSString stringWithFormat:@"%d", recentCom.awayBigSorceTimes], [NSString stringWithFormat:@"%d", recentCom.awaySmallSorceTimes] ];
                cell.rightPlotView.scoreArray = @[ [NSString stringWithFormat:@"%d", recentCom.homeBigSorceTimes], [NSString stringWithFormat:@"%d", recentCom.homeSmallSorceTimes] ];
                [cell.leftPlotView setNeedsDisplay];
                [cell.rightPlotView setNeedsDisplay];

                return cell;
            }

        } break;
        case 2: {
            static NSString *reuseIdentify = @"reuseIdentify";

            DPAnalysisFutureCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
            if (cell == nil) {
                cell = [[DPAnalysisFutureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
            }

            cell.leftView.nodataView.image =
            cell.rightView.nodataView.image = dp_SportLiveImage(@"basket_down.png");

            cell.rightView.nodataView.hidden = _analysisCenter.homeFutureCombat.data.length;
            cell.leftView.nodataView.hidden = _analysisCenter.awayFutureCombat.data.length;

            cell.leftView.nameLabel.text = self.viewModel.awayName;
            cell.leftView.timeLabel.text = [NSString stringWithFormat:@"%@开赛",[[_analysisCenter.awayFutureCombat.startTime componentsSeparatedByString:@" "]firstObject ]]  ;
            cell.leftView.leftLabel.text = _analysisCenter.awayFutureCombat.awayName;
            cell.leftView.rightLabel.text = _analysisCenter.awayFutureCombat.homeName;

            cell.rightView.nameLabel.text = self.viewModel.homeName;
            cell.rightView.timeLabel.text = [NSString stringWithFormat:@"%@开赛",[[_analysisCenter.homeFutureCombat.startTime componentsSeparatedByString:@" "]firstObject ]] ;
            cell.rightView.leftLabel.text = _analysisCenter.homeFutureCombat.awayName;
            cell.rightView.rightLabel.text = _analysisCenter.homeFutureCombat.homeName;

            [self setImageWitImgLabel:cell.rightView.leftImgView imgLink:_analysisCenter.homeFutureCombat.awayLogo];
            [self setImageWitImgLabel:cell.rightView.rightImgView imgLink:_analysisCenter.homeFutureCombat.homeLogo];

            [self setImageWitImgLabel:cell.leftView.leftImgView imgLink:_analysisCenter.awayFutureCombat.awayLogo];
            [self setImageWitImgLabel:cell.leftView.rightImgView imgLink:_analysisCenter.awayFutureCombat.homeLogo];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        return;
    }

    DPBasketballAnalysisDetailController *vc = [[DPBasketballAnalysisDetailController alloc] init];
    vc.title = [NSString stringWithFormat:@"%@ VS %@", self.viewModel.awayName, self.viewModel.homeName];
    vc.matchId = _matchId;
    vc.homeName = self.viewModel.homeName;
    vc.awayName = self.viewModel.awayName;
    [self.navController pushViewController:vc animated:YES];
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

            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgLabel.image = roundImage;
                                          }]];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgLabel.image = dp_SportLotteryImage(@"defaultIcon.png");
                                          }]];

        }];
}

@end

@interface DPBasketballAnalysisDetailController () {
@private
    PBMBasketballAnalysisDetail *_dateCenter;
    UILabel *_signlLabel;

    NSInteger _historyAgainstCount;       //历史行数
    NSInteger _homeAgainstCount;          //主队行数
    NSInteger _homeFutureAgainstCount;    //未来行数
}
@property (nonatomic, strong, readonly) UILabel *signlLabel;
@property (nonatomic, strong) MTStringParser *parser;

@end

@implementation DPBasketballAnalysisDetailController

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

//- (void)loadView {
//    self.tableView = ({
//        DPNoInsetOffsetTableView *view = [[DPNoInsetOffsetTableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//        //        view.sectionOffset = -185;
//        view.sectionOffset = -85;
//
//        view;
//    });
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.view.backgroundColor = self.tableView.backgroundColor = kBackColor ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyAgainstCount = 0;
    _homeAgainstCount = 0;
    _homeFutureAgainstCount = 0;
    self.tableView.tableFooterView = self.signlLabel;

    [self showHUD];
    @weakify(self) ;
    [[AFHTTPSessionManager dp_sharedManager] GET:@"datacenter/GetBasketballMatchAnalysisDetail"
        parameters:@{ @"matchid" : @(self.matchId) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self) ;
            [self dismissHUD];
            _dateCenter = [PBMBasketballAnalysisDetail parseFromData:responseObject error:nil];
             _historyAgainstCount = _dateCenter.history.matchInfoListArray.count;
            _homeAgainstCount = _dateCenter.homeRecent.matchInfoListArray.count;
            _homeFutureAgainstCount = _dateCenter.homeFuture.matchInfoListArray.count;
            [self.tableView reloadData];

        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self) ;
            [self dismissHUD];
            [[DPToast makeText:[NSString stringWithFormat:@"%@",error.dp_errorMessage]]show];
 
        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _historyAgainstCount <= 0 ? 1 : _historyAgainstCount + 2;
        case 1:
            return _homeAgainstCount <= 0 ? 1 : _homeAgainstCount + _dateCenter.awayRecent.matchInfoListArray.count + 4;
        case 2:
            return _homeFutureAgainstCount <= 0 ? 1 : _dateCenter.homeFuture.matchInfoListArray.count + _dateCenter.awayFuture.matchInfoListArray.count + 4;
        default:
            return 0;
    }
}

#define AnalysisLCTag 6776
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = 0, future = 0;
    switch (indexPath.section) {
        case 0: {
            //            type = 0;
            index = (int)indexPath.row - 2;
            future = 0;
        } break;
        case 1: {
            future = 0;
            if (indexPath.row < _homeAgainstCount + 2) {
                index = (int)indexPath.row - 2;
            } else {
                index = (int)indexPath.row - _dateCenter.homeRecent.matchInfoListArray.count - 4;
            }
        } break;
        case 2: {
            future = 1;
            if (indexPath.row < _homeFutureAgainstCount + 2) {
                index = (int)indexPath.row - 2;
            } else {
                index = (int)indexPath.row - _dateCenter.homeFuture.matchInfoListArray.count - 4;
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
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *textLab = [[UILabel alloc] init];
            textLab.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:textLab];
            textLab.tag = AnalysisLCTag + 1;
            textLab.layer.borderWidth = 0.5;
            textLab.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1].CGColor;

            [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(-0.5, 5, -0.5, 5)) ;

            }];
            
            UILabel *lineView = [[UILabel alloc]init];
            lineView.tag = AnalysisLCTag +22 ;
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
            _noDataImgLabel.tag = AnalysisLCTag + 4;
            _noDataImgLabel.contentMode = UIViewContentModeCenter;
            _noDataImgLabel.image = dp_SportLiveImage(@"basket_left.png");
            _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }

        UIView *lineView = [cell.contentView viewWithTag:AnalysisLCTag+22] ;
        lineView.hidden = !(indexPath.row == 0) ;
        DPImageLabel *imgLab = (DPImageLabel *)[cell.contentView viewWithTag:AnalysisLCTag + 4];
        switch (indexPath.section) {
            case 0: {
                if (_dateCenter.history.matchInfoListArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else {
                    imgLab.hidden = YES;
                }
            } break;
            case 1: {
                if (_dateCenter.homeRecent.matchInfoListArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else {
                    imgLab.hidden = YES;
                }

            } break;
            case 2: {
                if (_dateCenter.homeFuture.matchInfoListArray.count <= 0) {
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
                    MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                    attr.font = [UIFont dp_systemFontOfSize:11];
                    attr.textColor = UIColorFromRGB(0x7E725C);
                    attr;
                })];
        [parser addStyleWithTagName:@"font12" font:[UIFont dp_systemFontOfSize:13] color:UIColorFromRGB(0x272727)];
        [parser addStyleWithTagName:@"red" color:UIColorFromRGB(0xEA2D30)];
        [parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x424F9C)];
        [parser addStyleWithTagName:@"grown" color:UIColorFromRGB(0x7E725C)];

        UILabel *lab = (UILabel *)[cell.contentView viewWithTag:AnalysisLCTag + 1];

        PBMBasketballAnalysisDetail_MatchInfoTitle *titleInfo;
        NSString *teamName;

        if (indexPath.section == 0) {
            titleInfo = _dateCenter.history;
            teamName = self.homeName;
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                titleInfo = _dateCenter.homeRecent;
                teamName = self.homeName;
            } else {
                titleInfo = _dateCenter.awayRecent;
                teamName = self.awayName;
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                titleInfo = _dateCenter.homeFuture;
                lab.attributedText = [parser attributedStringFromMarkup:[NSString stringWithFormat:@"   <font12>%@</font12>", self.homeName]];
            } else {
                titleInfo = _dateCenter.awayRecent;
                ;
                lab.attributedText = [parser attributedStringFromMarkup:[NSString stringWithFormat:@"   <font12>%@</font12>", self.awayName]];
            }

            return cell;
        }
        NSString *markupText = [NSString stringWithFormat:@"    <font12>%@</font12> <red>%d胜</red><blue>%d负</blue>  主场 <red>%d胜</red><blue>%d负</blue>  大球<red>%d</red> 小球<blue>%d</blue>", teamName, titleInfo.totalWin, titleInfo.totalLose, titleInfo.homeWinTimes, titleInfo.homeLoseTimes, titleInfo.bigScoreTime, titleInfo.smallScoreTime];
        lab.attributedText = [parser attributedStringFromMarkup:markupText];
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
                nameView.tag = AnalysisLCTag + 2;
                nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
                nameView.titleFont = [UIFont dp_systemFontOfSize:12];
                [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:103], [NSNumber numberWithFloat:103], nil] whithHigh:30 withSeg:NO];
                nameView.backgroundColor = [UIColor dp_flatWhiteColor];
                [cell.contentView addSubview:nameView];

                [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                }];
            }
            DPLiveOddsHeaderView *nameView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:AnalysisLCTag + 2];
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
            nameView.tag = AnalysisLCTag + 3;
            nameView.textColors = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
            nameView.titleFont = [UIFont dp_systemFontOfSize:12];
            [nameView createHeaderWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84], [NSNumber numberWithFloat:84], [NSNumber numberWithFloat:58], [NSNumber numberWithFloat:84], nil] whithHigh:30 withSeg:NO];
            nameView.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:nameView];

            [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
        DPLiveOddsHeaderView *nameView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:AnalysisLCTag + 3];
        [nameView setTitles:[NSArray arrayWithObjects:@"赛事和时间", @"主队", @"比分", @"客队", nil]];

        return cell;
    }

    if (future == 1) {    //未来赛事表格
        static NSString *contentFuture = @"contentFuture";
        DPLiveAnalysisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentFuture];
        if (cell == nil) {
            cell = [[DPLiveAnalysisViewCell alloc] initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:103], [NSNumber numberWithFloat:103], nil] reuseIdentifier:contentFuture withHight:30];
        }
        [cell.rootbgView changeNumberOfLinesWithIndex:0 withNumber:2];

        PBMBasketballAnalysisDetail_MatchInfoDetailInfo *futureInfo;
        if (indexPath.row < _dateCenter.homeFuture.matchInfoListArray.count + 2) {
            futureInfo = [_dateCenter.homeFuture.matchInfoListArray objectAtIndex:index];

        } else {
            futureInfo = [_dateCenter.awayFuture.matchInfoListArray objectAtIndex:index];
        }

        NSAttributedString *firstStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%@\n<font8>%@</font8>", futureInfo.completion, [NSDate dp_coverDateString:futureInfo.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]]];
        NSAttributedString *secondStr = [self.parser attributedStringFromMarkup:futureInfo.homeTeamName];
        NSAttributedString *fourStr = [self.parser attributedStringFromMarkup:futureInfo.awayTeamName];
        NSArray *titleArray = [NSArray arrayWithObjects:firstStr, secondStr, fourStr, nil];
        [cell.rootbgView setTitles:titleArray];
        return cell;
    }

    //历史和近期战绩表格
    static NSString *contentIdentifier = @"contentIdentifier";
    DPLiveAnalysisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentIdentifier];
    if (cell == nil) {
        cell = [[DPLiveAnalysisViewCell alloc] initWithWidthArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:84], [NSNumber numberWithFloat:84], [NSNumber numberWithFloat:58], [NSNumber numberWithFloat:84], nil] reuseIdentifier:contentIdentifier withHight:30];
        [cell.rootbgView changeNumberOfLinesWithIndex:0 withNumber:2];
    }

    PBMBasketballAnalysisDetail_MatchInfoDetailInfo *detailInfo;

    NSString *homeMarkupText, *awayMarkupText, *homeTeamName;
    if (indexPath.section == 0) {
        detailInfo = [_dateCenter.history.matchInfoListArray objectAtIndex:index];
        homeTeamName = self.homeName;
    } else if (indexPath.row < _homeAgainstCount + 2) {
        detailInfo = [_dateCenter.homeRecent.matchInfoListArray objectAtIndex:index];
        homeTeamName = self.homeName;
    } else {
        detailInfo = [_dateCenter.awayRecent.matchInfoListArray objectAtIndex:index];
        homeTeamName = self.awayName;
    }

    if ([detailInfo.homeTeamName isEqualToString:homeTeamName]) {
        homeMarkupText = detailInfo.homeScore > detailInfo.awayScore ? [NSString stringWithFormat:@"<red>%@</red>", detailInfo.homeTeamName] : [NSString stringWithFormat:@"<blue>%@</blue>", detailInfo.homeTeamName];
        awayMarkupText = detailInfo.awayTeamName;
    } else {
        homeMarkupText = detailInfo.homeTeamName;
        awayMarkupText = detailInfo.homeScore < detailInfo.awayScore ? [NSString stringWithFormat:@"<red>%@</red>", detailInfo.awayTeamName] : [NSString stringWithFormat:@"<blue>%@</blue>", detailInfo.awayTeamName];
    }

    NSAttributedString *firstStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%@<font8>\n%@</font8>", detailInfo.completion, [NSDate dp_coverDateString:detailInfo.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]]];
    NSAttributedString *secondeStr = [self.parser attributedStringFromMarkup:homeMarkupText];
    NSAttributedString *thirdStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%d:%d", detailInfo.homeScore, detailInfo.awayScore]];
    NSAttributedString *fourStr = [self.parser attributedStringFromMarkup:awayMarkupText];
    NSArray *titleArray = [NSArray arrayWithObjects:firstStr, secondeStr, thirdStr, fourStr, nil];
    [cell.rootbgView setTitles:titleArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (_dateCenter.history.matchInfoListArray.count <= 0) {
                return 35;
            } else if (indexPath.row == 1) {
                return 26;
            }
        } break;
        case 1: {
            if (_dateCenter.homeRecent.matchInfoListArray.count <= 0) {
                return 35;
            } else if (indexPath.row == 1 || indexPath.row == _dateCenter.homeRecent.matchInfoListArray.count + 3) {
                return 26;
            }
        } break;
        case 2: {
            if (_dateCenter.homeFuture.matchInfoListArray.count <= 0) {
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
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr.textColor = UIColorFromRGB(0x5c5c5c);
                     attr.alignment = NSTextAlignmentCenter;
                     attr;
                 })];
        [_parser addStyleWithTagName:@"font8" font:[UIFont dp_systemFontOfSize:8] color:UIColorFromRGB(0xa2a2a2)];
        [_parser addStyleWithTagName:@"red" color:UIColorFromRGB(0xea2d30)];
        [_parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x424f9c)];
    }
    return _parser;
}

@end
