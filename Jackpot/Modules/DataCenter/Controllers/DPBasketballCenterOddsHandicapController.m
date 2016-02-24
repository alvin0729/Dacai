//
//  DPBasketballCenterOddsHandicapController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "BasketballDataCenter.pbobjc.h"
#import "DPBasketballCenterOddsHandicapController.h"
#import "DPBasketballCenterOddsHandicapViewModel.h"
#import "DPDataCenterTableController+Private.h"
#import "DPLiveDataCenterViews.h"
#import "DPLiveOddsPositionDetailVC.h"
#import "DPSegmentedControl.h"

@interface DPBasketballCenterOddsHandicapController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _rowNumber;    //行数
    NSInteger _matchID;      //赛事id
}

@property (nonatomic, strong) DPBasketballCenterOddsHandicapViewModel *viewModel;
/**
 *  选择的赔盘类型
 */
@property (nonatomic, assign) int type;
@property (nonatomic, strong) MTStringParser *parser;
@end

@implementation DPBasketballCenterOddsHandicapController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"赔盘";
        _viewModel = [[DPBasketballCenterOddsHandicapViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        _matchID = matchId;
        self.type = 1;
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel];
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

#define OddsTag 99999
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.type == 1) {
        static NSString *WinIdentifier = @"WinIdentifier";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WinIdentifier];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:WinIdentifier];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromRGB(0xfaf9f2);
                view;
            });
            DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[ @"胜负", @"让分", @"大小" ]];
            seg.selectedIndex = self.type - 1;
            seg.indicatorColor = [UIColor dp_flatRedColor];
            seg.textColor = UIColorFromRGB(0x7e6a5f);
            [seg setTintColor:UIColorFromRGB(0xc3c4bf)];

            [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
            [view addSubview:seg];

            DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
            headView.titleFont = [UIFont dp_systemFontOfSize:12];
            headView.textColors = [UIColor dp_colorFromRGB:0x817e7c];
            headView.backgroundColor = [UIColor dp_flatWhiteColor];

            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:102], [NSNumber numberWithFloat:104], nil];
            [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];

            headView.tag = OddsTag + 1;
            [view addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view.mas_bottom);
                make.left.equalTo(view).offset(5);
                make.height.equalTo(@30);
                make.right.equalTo(view).offset(-5);
            }];

            [seg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headView.mas_top).offset(-8);
                make.width.equalTo(@202);
                make.height.equalTo(@31);
                make.centerX.equalTo(view);
            }];
        }

        DPLiveOddsHeaderView *headView = (DPLiveOddsHeaderView *)[view viewWithTag:OddsTag + 1];
        [headView setTitles:[NSArray arrayWithObjects:@"公司名", @"主负", @"主胜", nil]];

        return view;
    }

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
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:@[ @"胜负", @"让分", @"大小" ]];
        seg.selectedIndex = self.type - 1;
        seg.indicatorColor = [UIColor dp_flatRedColor];
        seg.textColor = UIColorFromRGB(0x7e6a5f);
        [seg setTintColor:UIColorFromRGB(0xc3c4bf)];

        [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:seg];

        DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
        headView.titleFont = [UIFont dp_systemFontOfSize:12];
        headView.textColors = [UIColor dp_colorFromRGB:0x817e7c];
        headView.backgroundColor = [UIColor dp_flatWhiteColor];

        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:102], [NSNumber numberWithFloat:68], [NSNumber numberWithFloat:68], [NSNumber numberWithFloat:72], nil];
        [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];

        headView.tag = OddsTag + 2;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom);
            make.left.equalTo(view).offset(5);
            make.height.equalTo(@30);
            make.right.equalTo(view).offset(-5);
        }];

        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView.mas_top).offset(-8);
            make.width.equalTo(@200);
            make.height.equalTo(@30);
            make.centerX.equalTo(view);
        }];
    }
    //主负  主胜
    //
    DPLiveOddsHeaderView *headView = (DPLiveOddsHeaderView *)[view viewWithTag:OddsTag + 2];
    if (self.type == 2) {
        [headView setTitles:[NSArray arrayWithObjects:@"公司名", @"客水", @"盘口", @"主水", nil]];
    } else {
        [headView setTitles:[NSArray arrayWithObjects:@"公司名", @"小分", @"总分", @"大分", nil]];
    }

    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PBMBasketballOdds *_dateCenter = self.viewModel.message;
    switch (self.type) {
        case 1: {
            _rowNumber = _dateCenter.sfOdds.oddsInfoListArray.count;
        } break;
        case 2: {
            _rowNumber = _dateCenter.rfOdds.oddsInfoListArray.count;
        } break;
        case 3: {
            _rowNumber = _dateCenter.dxOdds.oddsInfoListArray.count;
        } break;

        default:
            _rowNumber = 0;
            break;
    }

    if (_rowNumber > 0) {
        return _rowNumber;
    } else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMBasketballOdds *_dateCenter = self.viewModel.message;
    if (self.type == 1) {
        static NSString *cellWin_Reuse = @"cellWin_Reuse";
        DPBasketOddsPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWin_Reuse];
        if (cell == nil) {
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:104], [NSNumber numberWithFloat:102], [NSNumber numberWithFloat:104], nil];
            cell = [[DPBasketOddsPositionCell alloc] initWithItemWithArray:arr reuseIdentifier:cellWin_Reuse withHigh:30];
            cell.cellView.titleFont = [UIFont dp_systemFontOfSize:11];
        }

        if (_rowNumber <= 0) {
            cell.noDataImgLabel.hidden = NO;
            return cell;
        } else
            cell.noDataImgLabel.hidden = YES;

        PBMBasketballOdds_Odds *oddsInfo = [_dateCenter.sfOdds.oddsInfoListArray objectAtIndex:indexPath.row];
        NSAttributedString *firstStr = [[NSAttributedString alloc] initWithString:oddsInfo.companyName];
        NSAttributedString *secondStr, *thirdStr;
        if ([oddsInfo.trendArray valueAtIndex:0] > 0) {
            secondStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<red>%@↑</red>", oddsInfo.oddsArray[0]]];
        } else if ([oddsInfo.trendArray valueAtIndex:0] < 0) {
            secondStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<blue>%@↓</blue>", oddsInfo.oddsArray[0]]];
        } else {
            secondStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<black>%@</black>", oddsInfo.oddsArray[0]]];
        }
        if ([oddsInfo.trendArray valueAtIndex:1] > 0) {
            thirdStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<red>%@↑</red>", oddsInfo.oddsArray[1]]];
        } else if ([oddsInfo.trendArray valueAtIndex:1] < 0) {
            thirdStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<blue>%@↓</blue>", oddsInfo.oddsArray[1]]];
        } else {
            thirdStr = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<black>%@</black>", oddsInfo.oddsArray[1]]];
        }

        NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, thirdStr, secondStr, nil];

        [cell.cellView setTitles:titlesAray];
        if (indexPath.row == _rowNumber - 1) {
            cell.cellView.bottmoLayer.hidden = NO;
        } else {
            cell.cellView.bottmoLayer.hidden = YES;
        }
        if (indexPath.row % 2 == 0) {
            cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff];
        } else
            cell.cellView.backgroundColor = kBackColor;

        return cell;
    }

    static NSString *cell_Reuse = @"cell_Reuse";
    DPBasketOddsPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse];
    if (cell == nil) {
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:102], [NSNumber numberWithFloat:68], [NSNumber numberWithFloat:68], [NSNumber numberWithFloat:72], nil];
        cell = [[DPBasketOddsPositionCell alloc] initWithItemWithArray:arr reuseIdentifier:cell_Reuse withHigh:30];
        cell.cellView.titleFont = [UIFont dp_systemFontOfSize:11];
    }

    if (_rowNumber <= 0) {
        cell.noDataImgLabel.hidden = NO;
        return cell;
    } else {
        cell.noDataImgLabel.hidden = YES;
    }

    PBMBasketballOdds_Odds *oddsInfo;
    switch (self.type) {
        case 2:
            oddsInfo = [_dateCenter.rfOdds.oddsInfoListArray objectAtIndex:indexPath.row];
            break;
        case 3:
            oddsInfo = [_dateCenter.dxOdds.oddsInfoListArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    NSAttributedString *firstStr = [self.parser attributedStringFromMarkup:oddsInfo.companyName];
    NSAttributedString *secondStr, *thirdStr, *fourStr;
    NSAttributedString *__strong *attrList[] = {&secondStr, &thirdStr, &fourStr};
    for (int i = 0; i < 3; i++) {
        NSAttributedString *markupText;
        if ([oddsInfo.trendArray valueAtIndex:i] > 0) {
            markupText = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<red>%@↑</red>", oddsInfo.oddsArray[i]]];
        } else if ([oddsInfo.trendArray valueAtIndex:i] < 0) {
            markupText = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<blue>%@↓</blue>", oddsInfo.oddsArray[i]]];
        } else {
            markupText = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<black>%@</black>", oddsInfo.oddsArray[i]]];
        }
        *attrList[i] = markupText;
    }

    NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, fourStr, thirdStr, secondStr, nil];

    [cell.cellView setTitles:titlesAray];

    if (indexPath.row == _rowNumber - 1) {
        cell.cellView.bottmoLayer.hidden = NO;
    } else {
        cell.cellView.bottmoLayer.hidden = YES;
    }

    if (indexPath.row % 2 == 0) {
        cell.cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff];
    } else {
        cell.cellView.backgroundColor = kBackColor;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_rowNumber)
        return;
    DPLiveOddsPositionDetailVC *vc = [[DPLiveOddsPositionDetailVC alloc] initWIthGameType:GameTypeLcNone withSelectIndex:self.type companyIndx:(int)indexPath.row withMatchId:_matchID];
    PBMBasketballOdds *_dateCenter = self.viewModel.message;

    switch (self.type) {
        case 1: {
            vc.companyNames = _dateCenter.sfOdds.companyNameListArray;

        } break;
        case 2: {
            vc.companyNames = _dateCenter.rfOdds.companyNameListArray;
        } break;
        case 3: {
            vc.companyNames = _dateCenter.dxOdds.companyNameListArray;
        } break;

        default:
            break;
    }
    [self.navController pushViewController:vc animated:YES];
}

- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    PBMBasketballOdds *_dateCenter = self.viewModel.message;
    if (self.type != seg.selectedIndex + 1) {
        [self setType:((int)seg.selectedIndex + 1)];

        switch (self.type) {
            case 1: {
                _rowNumber = _dateCenter.sfOdds.oddsInfoListArray.count;
                [self.tableView reloadData];

            } break;
            case 2: {
                _rowNumber = _dateCenter.rfOdds.oddsInfoListArray.count;
                [self.tableView reloadData];
            } break;
            case 3: {
                _rowNumber = _dateCenter.dxOdds.oddsInfoListArray.count;
                [self.tableView reloadData];
            } break;
            default:
                break;
        }
    }
}

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr.textColor = UIColorFromRGB(0x535353);
                     attr.alignment = NSTextAlignmentCenter;
                     attr;
                 })];
        [_parser addStyleWithTagName:@"red" color:UIColorFromRGB(0xe7161a)];
        [_parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x3456a4)];
        [_parser addStyleWithTagName:@"black" color:UIColorFromRGB(0x2f2f2f)];
    }
    return _parser;
}

@end

@implementation DPBasketOddsPositionCell

- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.cellView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO bottomLayer:NO withHigh:height withWidth:kScreenWidth - 10];
        self.cellView.numberOfLabLines = 2;

        self.cellView.titleFont = [UIFont dp_systemFontOfSize:11];
        self.cellView.textColors = UIColorFromRGB(0x535353);
        [self.cellView createHeaderWithWidthArray:widthArray whithHigh:height withSeg:NO];
        [self.contentView addSubview:self.cellView];

        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        }];

        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = dp_ResultImage(@"arrow_right.png");

        [self.cellView addSubview:imgView];

        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@5);
            make.height.equalTo(@12);

            make.centerY.equalTo(self.cellView);
            make.right.equalTo(self.cellView.mas_right).offset(-2);
        }];

        _noDataImgLabel = [[UIImageView alloc] init];
        _noDataImgLabel.hidden = YES;
        _noDataImgLabel.layer.borderWidth = 0.5;
        _noDataImgLabel.layer.borderColor = kLayerColor.CGColor;

        _noDataImgLabel.contentMode = UIViewContentModeCenter;
        _noDataImgLabel.image = dp_SportLiveImage(@"basket_down.png");
        _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        [self.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5));
        }];
    }

    return self;
}
@end
