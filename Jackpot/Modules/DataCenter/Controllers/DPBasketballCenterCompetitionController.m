//
//  DPBasketballCenterCompetitionController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterCompetitionController.h"
#import "DPBasketballCenterCompetitionViewModel.h"
#import "DPDataCenterTableController+Private.h"

#import "BasketballDataCenter.pbobjc.h"
#import "DPLiveDataCenterViews.h"
#import "Gamelive.pbobjc.h"
@interface DPBasketballCenterCompetitionController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_colorArr;           //技术统计条颜色
    NSArray *_textcolorsArray;    //首发和替补文字颜色
}

@property (nonatomic, strong) DPBasketballCenterCompetitionViewModel *viewModel;
@end

@implementation DPBasketballCenterCompetitionController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"赛事";
        _viewModel = [[DPBasketballCenterCompetitionViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;

        _colorArr = @[ UIColorFromRGB(0xf89e9e), UIColorFromRGB(0xfbca90), UIColorFromRGB(0x83bff5) ];
        _textcolorsArray = @[ UIColorFromRGB(0x333333), UIColorFromRGB(0x97989a) ];
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel];
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4)
        return 0;
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            if (self.viewModel.message.highestsArray.count <= 0) {
                return 35;
            }
            break;
        case 2: {
            if (self.viewModel.message.statisticsArray.count <= 0) {
                return 35;
            }
        } break;
        case 3: {
            if (MAX(self.viewModel.message.homeLineupsArray.count, self.viewModel.message.awayLineupsArray.count) <= 0) {
                return 35;
            }
        } break;
        case 4: {
            return 25;
        } break;
        default:
            break;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderTitles[] = { @"赛事实况",
                                        @"各项最高",
                                        @"技术统计",
                                        @"阵容" };
    static NSString *HeaderIndentifier = @"Header";
    DPLiveDataCenterSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIndentifier];
    if (view == nil) {
        view = [[DPLiveDataCenterSectionHeaderView alloc] initWithReuseIdentifier:HeaderIndentifier];
    }
    view.titleLabel.text = HeaderTitles[section];
    view.tag = section;
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:    // 比赛事件
            return 3;
        case 1:    // 各项高分
            return self.viewModel.message.highestsArray.count + 1;
        case 2:    // 技术统计
            return self.viewModel.message.statisticsArray.count + 1;
        case 3:    //阵容
        {
            return MAX(self.viewModel.message.homeLineupsArray.count, self.viewModel.message.awayLineupsArray.count) + 1;
        }
        case 4:
            return 1;
            break;
        default:
            return 0;
    }

    return 0;
}
#define CEllTag 1111

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fac = 320.0 / kScreenWidth;
    PBMBasketballCompetition *_dateCenter = self.viewModel.message;
    if (indexPath.row == 0 && indexPath.section != 4) {
        if (indexPath.section == 0) {
            BOOL overTime = (_dateCenter.match.status == -4 || _dateCenter.match.status == 5 || _dateCenter.match.status == -5 || _dateCenter.match.status == 11) ? YES : NO;

            if (overTime) {
                static NSString *completeIdentitifersOverHead = @"completeIdentitifersOverHead";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersOverHead];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersOverHead];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:YES withHigh:30 withWidth:kScreenWidth - 10];
                    headView.textColors = UIColorFromRGB(0x6F6B68);
                    headView.backgroundColor = [UIColor dp_flatWhiteColor];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:90], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    NSArray *titlesAray = [NSArray arrayWithObjects:@"   ", @"第1节", @"第2节", @"第3节", @"第4节", @"加时", nil];
                    [headView setTitles:titlesAray];
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }

                return cell;

            } else {
                static NSString *completeIdentitifersHead = @"completeIdentitifersHead";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersHead];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersHead];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:YES withHigh:30 withWidth:kScreenWidth - 10];
                    headView.textColors = UIColorFromRGB(0x6F6B68);
                    headView.backgroundColor = [UIColor dp_flatWhiteColor];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:106], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    NSArray *titlesAray = [NSArray arrayWithObjects:@"   ", @"第1节", @"第2节", @"第3节", @"第4节", nil];
                    [headView setTitles:titlesAray];
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }

                return cell;
            }
        }
        static NSString *nameIdentitifers = @"nameIdentitifers";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameIdentitifers];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameIdentitifers];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
            headView.textColors = UIColorFromRGB(0x6F6B68);

            headView.titleFont = [UIFont dp_systemFontOfSize:12];
            NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:155], [NSNumber numberWithFloat:155], nil];
            [headView createHeaderWithWidthArray:arr whithHigh:35 withSeg:NO];
            headView.tag = CEllTag + 3;
            [cell.contentView addSubview:headView];
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(5);
                make.height.equalTo(@30);
                make.right.equalTo(cell.contentView).offset(-5);
            }];

            UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
            _noDataImgLabel.hidden = YES;
            _noDataImgLabel.layer.borderWidth = 0.5;
            _noDataImgLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            _noDataImgLabel.tag = CEllTag + 7;
            _noDataImgLabel.image = dp_SportLiveImage(@"basket_left.png");
            _noDataImgLabel.contentMode = UIViewContentModeCenter;
            _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:_noDataImgLabel];
            [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }

        DPImageLabel *imgLab = (DPImageLabel *)[cell.contentView viewWithTag:CEllTag + 7];
        switch (indexPath.section) {
            case 1: {
                if (_dateCenter.highestsArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;
            } break;
            case 2: {
                if (_dateCenter.statisticsArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;
            } break;
            case 3: {
                if (MAX(_dateCenter.homeLineupsArray.count, _dateCenter.awayLineupsArray.count) <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;
            } break;
            default:
                break;
        }

        DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CEllTag + 3];
        NSString *firstStr = [NSString stringWithFormat:@"%@(客)", self.viewModel.awayName];     // @"快船(客)" ;
        NSString *secondStr = [NSString stringWithFormat:@"%@(主)", self.viewModel.homeName];    // @"湖人(主)";
        NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, secondStr, nil];
        [cellView setTitles:titlesAray];

        return cell;
    }

    switch (indexPath.section) {
        case 0: {    //比赛事件
            BOOL overTime = (_dateCenter.match.status == -4 || _dateCenter.match.status == 5 || _dateCenter.match.status == -5 || _dateCenter.match.status == 11) ? YES : NO;

            int count = 0;
            switch (_dateCenter.match.status) {
                case PBMBasketballMatchStatus_BasketballNotStart:
                    count = 0;
                    break;
                case PBMBasketballMatchStatus_BasketballFirstSection:
                case PBMBasketballMatchStatus_BasketballFirstBreak:
                    count = 1;
                    break;
                case PBMBasketballMatchStatus_BasketballSecondSection:
                case PBMBasketballMatchStatus_BasketballSecondBreak:
                    count = 2;
                    break;
                case PBMBasketballMatchStatus_BasketballThirdSection:
                case PBMBasketballMatchStatus_BasketballThirdBreak:
                    count = 3;
                    break;
                case PBMBasketballMatchStatus_BasketballFourthSection:
                case PBMBasketballMatchStatus_BasketballNormalEnded:
                    count = 4;
                    break;
                case PBMBasketballMatchStatus_BasketballFourthBreak:
                case PBMBasketballMatchStatus_BasketballExtraSection:
                case PBMBasketballMatchStatus_BasketballExtraBreak:
                case PBMBasketballMatchStatus_BasketballExtraEnded:
                    count = 5;
                    break;

                default:
                    break;
            }

            if (overTime) {
                static NSString *completeIdentitifersOver = @"completeIdentitifersOver";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifersOver];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifersOver];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth - 10];
                    headView.textColors = UIColorFromRGB(0x6F6B68);
                    headView.backgroundColor = [UIColor dp_flatWhiteColor];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:90], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], [NSNumber numberWithFloat:44], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.tag = CEllTag + 1;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CEllTag + 1];
                NSString *firstStr, *secondStr, *thirdStr, *fourStr, *fivStr, *sixStr;

                if (indexPath.row == 1) {
                    firstStr = [NSString stringWithFormat:@"%@(主)", self.viewModel.homeName];    //@"圣约韩璐(主)";
                    secondStr = count <= 0 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:0]];
                    thirdStr = count <= 1 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:1]];
                    fourStr = count <= 2 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:2]];
                    fivStr = count <= 3 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:3]];
                    sixStr = count <= 4 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:4]];
                } else {
                    firstStr = [NSString stringWithFormat:@"%@(客)", self.viewModel.awayName];    //@"圣约韩璐(主)";
                    secondStr = count <= 0 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:0]];
                    thirdStr = count <= 1 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:1]];
                    fourStr = count <= 2 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:2]];
                    fivStr = count <= 3 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:3]];
                    sixStr = count <= 4 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:4]];
                }

                NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, secondStr, thirdStr, fourStr, fivStr, sixStr, nil];
                [cellView setTitles:titlesAray];

                return cell;

            } else {
                static NSString *completeIdentitifers = @"completeIdentitifers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentitifers];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentitifers];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth - 10];
                    headView.textColors = UIColorFromRGB(0x6F6B68);
                    headView.backgroundColor = [UIColor dp_flatWhiteColor];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:106], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:51], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                    headView.tag = CEllTag + 2;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                }
                DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CEllTag + 2];
                NSString *firstStr, *secondStr, *thirdStr, *fourStr, *fivStr;
                if (indexPath.row == 1) {
                    firstStr = [NSString stringWithFormat:@"%@(主)", self.viewModel.homeName];    // @"圣约韩璐(主)";
                    secondStr = count <= 0 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:0]];
                    thirdStr = count <= 1 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:1]];
                    fourStr = count <= 2 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:2]];
                    fivStr = count <= 3 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.homeScoresArray valueAtIndex:3]];
                } else {
                    firstStr = [NSString stringWithFormat:@"%@(客)", self.viewModel.awayName];    // @"圣约韩璐(主)";
                    secondStr = count <= 0 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:0]];
                    thirdStr = count <= 1 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:1]];
                    fourStr = count <= 2 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:2]];
                    fivStr = count <= 3 ? @"-" : [NSString stringWithFormat:@"%d", [_dateCenter.matchAction.awayScoresArray valueAtIndex:3]];
                }

                NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, secondStr, thirdStr, fourStr, fivStr, nil];
                [cellView setTitles:titlesAray];

                return cell;
            }
        }
        case 1: {    //各项高分

            static NSString *scoreIdentitifers = @"scoreIdentitifers";
            DPLCCompetitionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreIdentitifers];

            if (cell == nil) {
                NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5],[NSNumber numberWithFloat:105], [NSNumber numberWithFloat:20], [NSNumber numberWithFloat:50], [NSNumber numberWithFloat:20], [NSNumber numberWithFloat:105],[NSNumber numberWithFloat:5], nil];
                cell = [[DPLCCompetitionStateCell alloc] initWithItemWithArray:arr reuseIdentifier:scoreIdentitifers withHigh:30 segIndexArray:[NSArray arrayWithObjects:@"0",@"0", @"1", @"1", @"0", @"0", @"0", nil]];
                [cell.cellView changeTextAlignWithIndex:1 withAlig:NSTextAlignmentLeft];
                [cell.cellView changeTextAlignWithIndex:5 withAlig:NSTextAlignmentRight];
                
            }

            PBMBasketballCompetition_EachHighest *higest = [_dateCenter.highestsArray objectAtIndex:indexPath.row - 1];

            NSString *firstStr, *secondStr, *thirdStr, *fourStr, *fivStr;

            firstStr = [NSString stringWithFormat:@"%@", higest.homePlayer];
            secondStr = [NSString stringWithFormat:@"%d", higest.homeScore];
            thirdStr = higest.itemType;
            ;
            fourStr = [NSString stringWithFormat:@"%d", higest.awayScore];
            fivStr = [NSString stringWithFormat:@"%@", higest.awayPlayer];

            NSArray *titlesAray = [NSArray arrayWithObjects:@"",fivStr, fourStr, thirdStr, secondStr, firstStr,@"", nil];
            [cell.cellView setTitles:titlesAray];

            int count = (int)_dateCenter.statisticsArray.count;
            if (count == indexPath.row) {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            } else {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            }

            UIView *homeBar = cell.homeBar;
            UIView *awayBar = cell.awayBar;
            if (higest.awayScore > higest.homeScore) {
                homeBar.backgroundColor = _colorArr[0];
                awayBar.backgroundColor = _colorArr[2];
            } else if (higest.awayScore < higest.homeScore) {
                homeBar.backgroundColor = _colorArr[2];
                awayBar.backgroundColor = _colorArr[0];

            } else
                homeBar.backgroundColor = awayBar.backgroundColor = _colorArr[1];

            [cell.homeBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == homeBar) {
                    obj.constant = 110 * fac * higest.awayScore / ((higest.homeScore + higest.awayScore) > 0 ? (higest.homeScore + higest.awayScore) : 1);
                    *stop = YES;
                }
            }];
            [cell.awayBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == awayBar) {
                    obj.constant = 110 * fac * higest.homeScore / ((higest.homeScore + higest.awayScore) > 0 ? (higest.homeScore + higest.awayScore) : 1);
                    *stop = YES;
                }
            }];

            return cell;
        }

        case 2: {    //技术统计

            static NSString *CellIdentitifer = @"StatCell";
            DPLCCompetitionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentitifer];
            if (cell == nil) {
                cell = [[DPLCCompetitionStateCell alloc] initWithItemWithArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:116.25], [NSNumber numberWithFloat:77.5], [NSNumber numberWithFloat:111.25], nil] reuseIdentifier:CellIdentitifer withHigh:30 segIndexArray:nil];
            }

            PBMBasketballCompetition_SkillStatistics *skillInfo = [_dateCenter.statisticsArray objectAtIndex:indexPath.row - 1];

            NSArray *titlesArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"  %@", skillInfo.awayResult], skillInfo.itemType, skillInfo.homeResult, nil];
            [cell.cellView setTitles:titlesArray];

            int count = (int)_dateCenter.statisticsArray.count;
            if (count == indexPath.row) {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            } else {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            }

            UIView *homeBar = cell.homeBar;
            UIView *awayBar = cell.awayBar;

            if (skillInfo.awayPercentage > skillInfo.homePercentage) {
                homeBar.backgroundColor = _colorArr[0];
                awayBar.backgroundColor = _colorArr[2];
            } else if (skillInfo.awayPercentage < skillInfo.homePercentage) {
                homeBar.backgroundColor = _colorArr[2];
                awayBar.backgroundColor = _colorArr[0];

            } else
                homeBar.backgroundColor = awayBar.backgroundColor = _colorArr[1];
            [cell.homeBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == homeBar) {
                    obj.constant = 116.25 * skillInfo.awayPercentage / ((skillInfo.homePercentage + skillInfo.awayPercentage) > 0 ? (skillInfo.homePercentage + skillInfo.awayPercentage) : 1);
                    *stop = YES;
                }
            }];
            [cell.awayBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == awayBar) {
                    obj.constant = 116.25 * skillInfo.homePercentage / ((skillInfo.homePercentage + skillInfo.awayPercentage) > 0 ? (skillInfo.homePercentage + skillInfo.awayPercentage) : 1);
                    *stop = YES;
                }
            }];

            return cell;
        }

        case 3: {
            static NSString *PlayerIdentifer = @"PlayerIdentifer";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerIdentifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerIdentifer];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth - 10];
                headView.titleFont = [UIFont dp_systemFontOfSize:12];
                NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:51], [NSNumber numberWithFloat:104], [NSNumber numberWithFloat:51], [NSNumber numberWithFloat:104], nil];
                [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:YES];
                headView.backgroundColor = [UIColor dp_flatWhiteColor];
                [headView settitleColors:[NSArray arrayWithObjects:UIColorFromRGB(0x6F6B68), [UIColor dp_flatBlackColor], UIColorFromRGB(0x6F6B68), [UIColor dp_flatBlackColor], nil]];
                ;

                headView.tag = CEllTag + 6;
                [cell.contentView addSubview:headView];
                [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(5);
                    make.height.equalTo(@30);
                    make.right.equalTo(cell.contentView).offset(-5);
                }];
            }

            PBMBasketballCompetition_TeamLineup *homePlayer = (indexPath.row <= _dateCenter.homeLineupsArray.count) ? [_dateCenter.homeLineupsArray objectAtIndex:indexPath.row - 1] : nil;
            PBMBasketballCompetition_TeamLineup *awayPlayer = (indexPath.row <= _dateCenter.awayLineupsArray.count) ? [_dateCenter.awayLineupsArray objectAtIndex:indexPath.row - 1] : nil;

            DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CEllTag + 6];
            NSString *firstStr = homePlayer.positon ? homePlayer.positon : @"";    // @"后卫" ;
            NSString *secondStr = homePlayer.player ? homePlayer.player : @"";     // @"乔丹" ;
            NSString *thirdStr = awayPlayer.positon ? awayPlayer.positon : @"";    // @"前锋" ;
            NSString *fourStr = awayPlayer.player ? awayPlayer.player : @"";       //@"罗纳尔多" ;

            NSArray *titlesAray = [NSArray arrayWithObjects:thirdStr, fourStr, firstStr, secondStr, nil];
            [cellView setTitles:titlesAray];

            UIColor *firstColor = homePlayer.isSubstitutes ? _textcolorsArray[1] : _textcolorsArray[0];     // @"后卫" ;
            UIColor *secondColor = awayPlayer.isSubstitutes ? _textcolorsArray[1] : _textcolorsArray[0];    // @"乔丹" ;

            [cellView settitleColors:[NSArray arrayWithObjects:secondColor, secondColor, firstColor, firstColor, nil]];
            return cell;
        }
        case 4: {
            static NSString *BenchPlayerIdentitifer = @"BenchPlayerIdentitifer";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BenchPlayerIdentitifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BenchPlayerIdentitifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];

                MTStringParser *parser = [[MTStringParser alloc] init];
                [parser setDefaultAttributes:({
                            MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                            attr.textColor = [UIColor dp_flatBlackColor];
                            attr.font = [UIFont dp_systemFontOfSize:11];
                            attr;
                        })];
                [parser addStyleWithTagName:@"size" font:[UIFont dp_systemFontOfSize:12]];
                [parser addStyleWithTagName:@"sizeColor1" color:_textcolorsArray[0]];
                [parser addStyleWithTagName:@"sizeColor2" color:_textcolorsArray[1]];

                UILabel *bottomLabel = [[UILabel alloc] init];
                bottomLabel.backgroundColor = [UIColor clearColor];
                bottomLabel.attributedText = [parser attributedStringFromMarkup:[NSString stringWithFormat:@"<sizeColor1><size>■</size></sizeColor1>首发   <sizeColor2><size>■</size></sizeColor2>替补"]];

                [cell.contentView addSubview:bottomLabel];
                [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(10);
                    make.centerY.equalTo(cell.contentView);
                }];
            }

            return cell;
        }
        default:
            break;
    }

    return nil;
}

@end
