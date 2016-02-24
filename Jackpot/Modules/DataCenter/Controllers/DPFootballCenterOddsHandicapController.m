//
//  DPFootballCenterOddsHandicapController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterOddsHandicapController.h"
#import "DPDataCenterTableController+Private.h"
#import "DPFootballCenterOddsHandicapViewModel.h"
#import "FootballDataCenter.pbobjc.h"
#import "DPSegmentedControl.h"
#import "DPLiveOddsPositionDetailVC.h"
#import "DPLiveOddsPositionSubCell.h"

@interface DPFootballCenterOddsHandicapController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _rowNumber;    //行数
    NSInteger _matchID;
}
@property (nonatomic, strong) MTStringParser *stringParser;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) DPFootballCenterOddsHandicapViewModel *viewModel;

@end

@implementation DPFootballCenterOddsHandicapController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"赔盘";
        _matchID = matchId;
        _viewModel = [[DPFootballCenterOddsHandicapViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        self.type = 1;
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel] ;

    }
    return self;
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55 + 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_rowNumber <= 0) {
        return 150;
    }

    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderIdentifier = @"Header";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        view.contentView.backgroundColor = [UIColor clearColor];
        view.backgroundView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColorFromRGB(0xfaf9f2);
            view;
        });
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[ @"欧赔", @"亚盘", @"大小球", @"盈亏" ]];
        seg.selectedIndex = self.type - 1;
        seg.indicatorColor = [UIColor dp_flatRedColor];
         seg.textColor = UIColorFromRGB(0x7e6a5f)  ;
        [seg setTintColor:UIColorFromRGB(0xc3c4bf)];

        [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:seg];
        
        DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
        headView.titleFont = [UIFont dp_systemFontOfSize:12];
        headView.textColors = [UIColor dp_colorFromRGB:0x817e7c];
        headView.backgroundColor = [UIColor dp_flatWhiteColor];

        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:120], [NSNumber numberWithFloat:130], nil];
        if (self.type == 4) {
            arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:75], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:75], nil];
 
        }
        
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];

        headView.tag = 999;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom);
            make.centerX.equalTo(view);
            make.width.mas_equalTo(kScreenWidth-10);
            make.height.equalTo(@30);
        }];
        
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView.mas_top).offset(-8);
            make.left.equalTo(view).offset(40);
            make.right.equalTo(view).offset(-40);
            make.height.equalTo(@30);
            make.centerX.equalTo(view);
        }];

    }

    DPLiveOddsHeaderView *headView = (DPLiveOddsHeaderView *)[view viewWithTag:999];
    if (self.type == 1) {
        [headView setTitles:[NSArray arrayWithObjects:@"公司", @"初始赔率", @"最新赔率", nil]];
    } else if (self.type == 4) {
        [headView setTitles:[NSArray arrayWithObjects:@"项目", @"成交额", @"赔率", @"比例", @"庄家盈亏", nil]];

    } else {
        [headView setTitles:[NSArray arrayWithObjects:@"公司", @"初始盘口", @"即时盘口", nil]];
    }
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case 1: {
            _rowNumber = self.viewModel.message.oupeiList.oddsInfoListArray.count;
        } break;
        case 2: {
            _rowNumber = self.viewModel.message.yapanList.oddsInfoListArray.count;
        } break;
        case 3: {
            _rowNumber = self.viewModel.message.daXiaoqiuList.oddsInfoListArray.count;
        } break;
        case 4: {
            _rowNumber = self.viewModel.message.breakListArray.count;
        } break;

        default:
            break;
    }

    if (_rowNumber > 0) {
        return _rowNumber;
    } else
        return 1;
}

#define breakCEllTag 1111

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMFootOddsHandicap *_dateCenter = self.viewModel.message;
    if (self.type == 4) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth - 10];
            headView.titleFont = [UIFont dp_systemFontOfSize:11];
            headView.textColors = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
            headView.titleFont = [UIFont dp_systemFontOfSize:12];
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:75], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:75], nil];
            [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
            [headView changeFontWithIndex:0 withFont:[UIFont dp_systemFontOfSize:12]];
            headView.backgroundColor = [UIColor dp_flatWhiteColor];

            headView.tag = breakCEllTag + 1;
            [cell.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(5);
                make.height.equalTo(@30);
                make.right.equalTo(cell.contentView).offset(-5);
            }];

            UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
            _noDataImgLabel.hidden = YES;
            _noDataImgLabel.layer.borderWidth = 0.5 ;
            _noDataImgLabel.layer.borderColor = kLayerColor.CGColor ;
            _noDataImgLabel.tag = breakCEllTag + 4;
            _noDataImgLabel.contentMode = UIViewContentModeCenter;
            _noDataImgLabel.image = dp_SportLiveImage(@"foot_down.png");
            _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5));
            }];
        }
        DPImageLabel *imgLabe = (DPImageLabel *)[cell.contentView viewWithTag:breakCEllTag + 4];

        if (_rowNumber <= 0) {
            imgLabe.hidden = NO;
            return cell;
        } else
            imgLabe.hidden = YES;

        DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:breakCEllTag + 1];

        PBMFootOddsHandicap_BreakInfo *breakInfo = [_dateCenter.breakListArray objectAtIndex:indexPath.row];

        NSString *projecttext = breakInfo.title;
        NSString *amounttext = breakInfo.amount;
        NSString *oddstext = breakInfo.odds;
        NSString *ratiotext = [breakInfo.ratio stringByAppendingString:@"%"];
        NSString *breakeventext = breakInfo.breakeven;
        NSArray *titleArray = [NSArray arrayWithObjects:projecttext, amounttext, oddstext, ratiotext, breakeventext, nil];
        [cellView setTitles:titleArray];

        return cell;
    }

    static NSString *cell_Reuse = @"cell_Reuse";
    DPLiveOddsPositionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse];
    if (cell == nil) {
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:60], [NSNumber numberWithFloat:35], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:35], [NSNumber numberWithFloat:35], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:45], nil];
        cell = [[DPLiveOddsPositionSubCell alloc] initWithWidArray:arr reuseIdentifier:cell_Reuse withHigh:30];
    }
    if (_rowNumber <= 0) {
        cell.noDataImgLabel.hidden = NO;
        return cell;
    } else
        cell.noDataImgLabel.hidden = YES;

    PBMFootOddsHandicap_OddsInfo *oddsInfo;
    switch (self.type) {
        case 1:
            oddsInfo = [_dateCenter.oupeiList.oddsInfoListArray objectAtIndex:indexPath.row];
            break;
        case 2:
            oddsInfo = [_dateCenter.yapanList.oddsInfoListArray objectAtIndex:indexPath.row];
            break;
        case 3:
            oddsInfo = [_dateCenter.daXiaoqiuList.oddsInfoListArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    NSString *firstStr = oddsInfo.companyName;
    NSAttributedString *secondStr1 = [self.stringParser attributedStringFromMarkup:[NSString stringWithFormat:@"<init>%@</init>", oddsInfo.initOddsArray[0]]];
    NSAttributedString *secondStr2 = [self.stringParser attributedStringFromMarkup:[NSString stringWithFormat:@"<init>%@</init>", oddsInfo.initOddsArray[1]]];
    NSAttributedString *secondStr3 = [self.stringParser attributedStringFromMarkup:[NSString stringWithFormat:@"<init>%@</init>", oddsInfo.initOddsArray[2]]];

    NSAttributedString *thirdStr1, *thirdStr2, *thirdStr3;
    NSAttributedString *__strong *thirdStr[] = {&thirdStr1, &thirdStr2, &thirdStr3};
    for (int i = 0; i < 3; i++) {
        NSString *markupText;
        if ([oddsInfo.trendListArray valueAtIndex:i] > 0) {
            markupText = [NSString stringWithFormat:@"<red>%@↑</red>", oddsInfo.currOddsArray[i]];
        } else if ([oddsInfo.trendListArray valueAtIndex:i] < 0) {
            markupText = [NSString stringWithFormat:@"<blue>%@↓</blue>", oddsInfo.currOddsArray[i]];
        } else {
            markupText = [NSString stringWithFormat:@"<black>%@</black>", oddsInfo.currOddsArray[i]];
        }
        NSAttributedString *attr = [self.stringParser attributedStringFromMarkup:markupText];
        *thirdStr[i] = attr;
    }

    NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, secondStr1, secondStr2, secondStr3, thirdStr1, thirdStr2, thirdStr3, nil];

    [cell.itemView setTitles:titlesAray];
    
    if (indexPath.row == _rowNumber-1) {
        cell.itemView.bottmoLayer.hidden = NO ;
    }else{
        cell.itemView.bottmoLayer.hidden = YES ;
    }

    if (indexPath.row % 2 == 0) {
        cell.itemView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff];
    } else {
        cell.itemView.backgroundColor = kBackColor;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMFootOddsHandicap *_dateCenter = self.viewModel.message;
    if (self.type == 4 || !_rowNumber) {
        return;
    }
    DPLiveOddsPositionDetailVC *vc = [[DPLiveOddsPositionDetailVC alloc] initWIthGameType:GameTypeJcNone withSelectIndex:self.type companyIndx:(int)indexPath.row withMatchId:_matchID];

    switch (self.type) {
        case 1: {
            vc.companyNames = _dateCenter.oupeiList.companyNameListArray;

        } break;
        case 2: {
            vc.companyNames = _dateCenter.yapanList.companyNameListArray;
        } break;
        case 3: {
            vc.companyNames = _dateCenter.daXiaoqiuList.companyNameListArray;
        } break;

        default:
            break;
    }

    //    vc.defaultIndexPath = indexPath ;
    [self.navController pushViewController:vc animated:YES];
}

- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    PBMFootOddsHandicap *_dateCenter = self.viewModel.message;
    if (self.type != seg.selectedIndex + 1) {
        [self setType:(seg.selectedIndex + 1)];
        switch (self.type) {
            case 1: {
                _rowNumber = _dateCenter.oupeiList.oddsInfoListArray.count;
                [self.tableView reloadData];

            } break;
            case 2: {
                _rowNumber = _dateCenter.yapanList.oddsInfoListArray.count;
                [self.tableView reloadData];

            } break;
            case 3: {
                _rowNumber = _dateCenter.daXiaoqiuList.oddsInfoListArray.count;
                [self.tableView reloadData];
            }
            case 4: {
                _rowNumber = _dateCenter.breakListArray.count;
                [self.tableView reloadData];

            } break;
            default:
                break;
        }
    }
}

- (MTStringParser *)stringParser {
    if (_stringParser == nil) {
        _stringParser = [[MTStringParser alloc] init];
        [_stringParser setDefaultAttributes:({
                           MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                           attr.alignment = NSTextAlignmentCenter;
                           attr;
                       })];
        [_stringParser addStyleWithTagName:@"init" font:[UIFont dp_systemFontOfSize:10] color:UIColorFromRGB(0x535353)];
        [_stringParser addStyleWithTagName:@"red" font:[UIFont dp_systemFontOfSize:10] color:UIColorFromRGB(0xdc2804)];
        [_stringParser addStyleWithTagName:@"black" font:[UIFont dp_systemFontOfSize:10] color:UIColorFromRGB(0x2f2f2f)];
        [_stringParser addStyleWithTagName:@"blue" font:[UIFont dp_systemFontOfSize:10] color:UIColorFromRGB(0x3456a4)];
    }
    return _stringParser;
}

@end