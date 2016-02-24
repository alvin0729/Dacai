//
//  DPFootballCenterCompetitionController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterTableController+Private.h"
#import "DPFootballCenterCompetitionController.h"
#import "DPFootballCenterCompetitionViewModel.h"
#import "DPLiveCompetitionViews.h"
#import "DPLiveDataCenterViews.h"
#import "FootballDataCenter.pbobjc.h"

@interface DPFootballCenterCompetitionController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_colorsArray;    //首发和替补字体颜色
    NSArray *_colorArr;       //技术统计颜色
}
@property (nonatomic, strong) DPFootballCenterCompetitionViewModel *viewModel;
@property (nonatomic, strong) MTStringParser *parser;
@end

@implementation DPFootballCenterCompetitionController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"赛事";
        _viewModel = [[DPFootballCenterCompetitionViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        _colorsArray = @[ UIColorFromRGB(0x333333), UIColorFromRGB(0x97989a) ];
        _colorArr = @[ UIColorFromRGB(0xf89e9e), UIColorFromRGB(0xfbca90), UIColorFromRGB(0x83bff5) ];

        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel];
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (self.viewModel.message.eventListArray.count == 0) {
                return 35;
            } else if (indexPath.row == 0 || indexPath.row == self.viewModel.message.eventListArray.count + 1) {
                return 30;
            }
            return 31.5;
        } break;
        case 1: {
            if (self.viewModel.message.skillListArray.count <= 0) {
                return 35;
            }
        } break;
        case 2: {
            if (MAX(self.viewModel.message.homeListArray.count, self.viewModel.message.awayListArray.count) <= 0) {
                return 35;
            }

        } break;
        case 3: {
            return 25;
        } break;
        default:
            return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderTitles[] = { @"赛事实况",
                                        @"技术统计",
                                        @"球队阵容",
                                        @"替补阵容" };
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 1;
    }

    switch (section) {
        case 0:    // 赛事实况
            //            return 1;
            return self.viewModel.message.eventListArray.count > 0 ? self.viewModel.message.eventListArray.count + 2 : 1;
        case 1:    // 技术统计
            return self.viewModel.message.skillListArray.count + 1;
        case 2:    // 首发阵容
        {
            if (MAX(self.viewModel.message.homeListArray.count, self.viewModel.message.awayListArray.count) == 0) {
                return 1;
            } else {
                return MAX(self.viewModel.message.homeListArray.count, self.viewModel.message.awayListArray.count) + 1;
            }
        }
        default:
            return 0;
    }
}

#define CompetionCEllTag 1234

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {    //赛事实况

            if (indexPath.row == 0) {
                static NSString *nameAndTimeIdentitifers = @"nameAndTimeIdentitifers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameAndTimeIdentitifers];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameAndTimeIdentitifers];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];

                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:15], [NSNumber numberWithFloat:(kScreenWidth - 100) / 2.0], [NSNumber numberWithFloat:60], [NSNumber numberWithFloat:(kScreenWidth - 100) / 2.0], [NSNumber numberWithFloat:15], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
                    [headView changeTextAlignWithIndex:1 withAlig:NSTextAlignmentLeft];
                    [headView changeTextAlignWithIndex:3 withAlig:NSTextAlignmentRight];
                    [headView settitleColors:@[ [UIColor clearColor], UIColorFromRGB(0x666666), UIColorFromRGB(0xa9a896), UIColorFromRGB(0x666666), [UIColor clearColor] ]];
                    headView.tag = CompetionCEllTag + 5;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];

                    UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
                    _noDataImgLabel.hidden = YES;
                    _noDataImgLabel.tag = CompetionCEllTag + 6;
                    _noDataImgLabel.image = dp_SportLiveImage(@"foot_left.png");
                    _noDataImgLabel.contentMode = UIViewContentModeCenter;

                    _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
                    [cell.contentView addSubview:_noDataImgLabel];
                    [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                    }];
                }

                DPImageLabel *imgLab = (DPImageLabel *)[cell.contentView viewWithTag:CompetionCEllTag + 6];
                if (self.viewModel.message.eventListArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;

                DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CompetionCEllTag + 5];
                NSString *firstStr = self.viewModel.homeName;
                NSString *secondStr = @"时间";
                NSString *thirdStr = self.viewModel.awayName;
                NSArray *titlesAray = [NSArray arrayWithObjects:@" ", firstStr, secondStr, thirdStr, @" ", nil];
                [cellView setTitles:titlesAray];

                return cell;
            } else if (indexPath.row == self.viewModel.message.eventListArray.count + 1) {
                static NSString *HeaderFootIndentifier = @"HeaderFootIndentifier";
                UITableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:HeaderFootIndentifier];
                if (celll == nil) {
                    celll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderFootIndentifier];
                    celll.backgroundColor = [UIColor clearColor];
                    celll.contentView.backgroundColor = [UIColor clearColor];
                    celll.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIView *bottomView = ({
                        UIView *view = [[UIView alloc] init];
                        view.backgroundColor = [UIColor clearColor];

                        NSArray *subViews = @[ [[DPImageLabel alloc] init],
                                               [[DPImageLabel alloc] init],
                                               [[DPImageLabel alloc] init],
                                               [[DPImageLabel alloc] init],
                                               [[DPImageLabel alloc] init],
                                               [[DPImageLabel alloc] init] ];

                        static NSString *LabelImages[] = { @"jinqu.png",
                                                           @"dianqiu.png",
                                                           @"wulong.png",
                                                           @"huangpai.png",
                                                           @"hongpai.png",
                                                           @"honghuangpai.png",
                        };

                        static NSString *LabelTitles[] = { @"进球",
                                                           @"点球",
                                                           @"乌龙",
                                                           @"黄牌",
                                                           @"红牌",
                                                           @"两黄变红",
                        };

                        [subViews enumerateObjectsUsingBlock:^(DPImageLabel *obj, NSUInteger idx, BOOL *stop) {
                            obj.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.54 alpha:1];
                            obj.font = [UIFont dp_systemFontOfSize:11];
                            obj.imagePosition = DPImagePositionLeft;
                            obj.spacing = 2;
                            obj.image = dp_GameLiveImage(LabelImages[idx]);
                            obj.text = LabelTitles[idx];
                            [view addSubview:obj];
                        }];
                        [[subViews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(view).offset(10);
                            make.centerY.equalTo(view);
                        }];
                        [subViews dp_enumeratePairsUsingBlock:^(UIView *obj1, NSUInteger idx1, UIView *obj2, NSUInteger idx2, BOOL *stop) {
                            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(obj1.mas_right).offset(5);
                                make.centerY.equalTo(obj1);
                            }];
                        }];
                        view;
                    });

                    [celll.contentView addSubview:bottomView];
                    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(celll.contentView);
                        make.right.equalTo(celll.contentView);
                        make.top.equalTo(celll.contentView);
                        make.height.equalTo(@30);
                    }];
                }

                return celll;
            }

            static NSString *LiveCellIdentitifer = @"LiveCellIdentitifer";
            DPLiveCompetitionLiveContentCell *cell = [tableView dequeueReusableCellWithIdentifier:LiveCellIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionLiveContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LiveCellIdentitifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            if (indexPath.row == self.viewModel.message.eventListArray.count) {
                cell.bottomView.hidden = NO;
            } else {
                cell.bottomView.hidden = YES;
            }

            PBMFootEventData_MatchEventInfo *matchInfo = [self.viewModel.message.eventListArray objectAtIndex:indexPath.row - 1];
            DPImageLabel *homeLabel = cell.liveView.homeLabel;
            DPImageLabel *awayLabel = cell.liveView.awayLabel;
            // 1:进球, 2:红牌, 3:黄牌, 6:进球不算, 7:点球, 8:乌龙, 9:红牌(2黄牌->红牌)
            const NSDictionary *imageMapping = @{ @1 : @"jinqu.png",
                                                  @7 : @"dianqiu.png",
                                                  @8 : @"wulong.png",
                                                  @3 : @"huangpai.png",
                                                  @2 : @"hongpai.png",
                                                  @9 : @"honghuangpai.png",
            };

            UIImage *image = dp_GameLiveImage(imageMapping[@(matchInfo.event)]);

            cell.liveView.timeLabel.text = [NSString stringWithFormat:@"%d'", matchInfo.time];
            if (matchInfo.homeOrAway) {
                homeLabel.superview.hidden = NO;
                awayLabel.superview.hidden = YES;
                homeLabel.text = matchInfo.player;
                homeLabel.image = image;
            } else {
                homeLabel.superview.hidden = YES;
                awayLabel.superview.hidden = NO;
                awayLabel.text = matchInfo.player;
                ;
                awayLabel.image = image;
            }
            return cell;
        }

        case 1: {    //技术统计
            if (indexPath.row == 0) {
                static NSString *nameIdentitifers = @"nameIdentitifers";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameIdentitifers];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameIdentitifers];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:15], [NSNumber numberWithFloat:(kScreenWidth - 120) / 2.0], [NSNumber numberWithFloat:80], [NSNumber numberWithFloat:(kScreenWidth - 120) / 2.0], [NSNumber numberWithFloat:15], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSeg:NO];
                    [headView changeTextAlignWithIndex:1 withAlig:NSTextAlignmentLeft];
                    [headView changeTextAlignWithIndex:3 withAlig:NSTextAlignmentRight];
                    [headView settitleColors:@[ [UIColor clearColor], UIColorFromRGB(0x666666), UIColorFromRGB(0xa9a896), UIColorFromRGB(0x666666), [UIColor clearColor] ]];

                    headView.tag = CompetionCEllTag + 1;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView).offset(5);
                        make.height.equalTo(@30);
                        make.right.equalTo(cell.contentView).offset(-5);
                    }];
                    UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
                    _noDataImgLabel.hidden = YES;
                    _noDataImgLabel.tag = CompetionCEllTag + 2;
                    _noDataImgLabel.image = dp_SportLiveImage(@"foot_left.png");
                    _noDataImgLabel.contentMode = UIViewContentModeCenter;

                    _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
                    [cell.contentView addSubview:_noDataImgLabel];
                    [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                    }];
                }

                DPImageLabel *imgLab = (DPImageLabel *)[cell.contentView viewWithTag:CompetionCEllTag + 2];
                if (self.viewModel.message.skillListArray.count <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;

                DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CompetionCEllTag + 1];
                NSString *firstStr = [NSString stringWithFormat:@"%@   ", self.viewModel.homeName];
                NSString *secondStr = [NSString stringWithFormat:@"   %@", self.viewModel.awayName];
                NSArray *titlesAray = [NSArray arrayWithObjects:@" ", firstStr, @"技术统计", secondStr, @" ", nil];
                [cellView setTitles:titlesAray];

                return cell;
            }

            static NSString *TechCellIdentitifer = @"TechCellIdentitifer";
            DPLiveCompetitionStateCell *cell = [tableView dequeueReusableCellWithIdentifier:TechCellIdentitifer];
            if (cell == nil) {
                cell = [[DPLiveCompetitionStateCell alloc] initWithItemWithArray:[NSArray arrayWithObjects:[NSNumber numberWithFloat:15], [NSNumber numberWithFloat:(kScreenWidth - 105) / 2.0], [NSNumber numberWithFloat:65], [NSNumber numberWithFloat:(kScreenWidth - 105) / 2.0], [NSNumber numberWithFloat:15], nil] reuseIdentifier:TechCellIdentitifer withHigh:30];
            }

            PBMFootEventData_SkillDetailInfo *skillInfo = [self.viewModel.message.skillListArray objectAtIndex:indexPath.row - 1];

            NSArray *titlesArray = [NSArray arrayWithObjects:@"", skillInfo.homeText, skillInfo.name, skillInfo.awayText, @"", nil];
            if ([skillInfo.name isEqualToString:@"控球率"]) {
                titlesArray = [NSArray arrayWithObjects:@"", [NSString stringWithFormat:@"%@%%", skillInfo.homeText], skillInfo.name, [NSString stringWithFormat:@"%@%%", skillInfo.awayText], @"", nil];
            }
            [cell.cellView setTitles:titlesArray];

            NSInteger count = self.viewModel.message.skillListArray.count;
            if (count == indexPath.row) {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            } else {
                cell.bottmoLayer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            }

            UIView *homeBar = cell.homeBar;
            UIView *awayBar = cell.awayBar;

            if (skillInfo.homeCount > skillInfo.awayCount) {
                homeBar.backgroundColor = _colorArr[0];
                awayBar.backgroundColor = _colorArr[2];
            } else if (skillInfo.homeCount < skillInfo.awayCount) {
                homeBar.backgroundColor = _colorArr[2];
                awayBar.backgroundColor = _colorArr[0];

            } else
                homeBar.backgroundColor = awayBar.backgroundColor = _colorArr[1];

            [cell.homeBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == homeBar) {
                    obj.constant = (kScreenWidth - 105) / 2.0 * skillInfo.homeCount / ((skillInfo.homeCount + skillInfo.awayCount) > 0 ? (skillInfo.homeCount + skillInfo.awayCount) : 1);
                    *stop = YES;
                }
            }];
            [cell.awayBar.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
                if (obj.firstAttribute == NSLayoutAttributeWidth && obj.firstItem == awayBar) {
                    obj.constant = (kScreenWidth - 105) / 2.0 * skillInfo.awayCount / ((skillInfo.homeCount + skillInfo.awayCount) > 0 ? (skillInfo.homeCount + skillInfo.awayCount) : 1);
                    *stop = YES;
                }
            }];

            return cell;
        }
        case 2: {    //首发阵容
            if (indexPath.row == 0) {
                static NSString *PlayerHeaderCell = @"PlayerHeaderCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerHeaderCell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerHeaderCell];

                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
                    headView.textColors = UIColorFromRGB(0x666666);
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:15], [NSNumber numberWithFloat:(kScreenWidth - 40) / 2.0], [NSNumber numberWithFloat:(kScreenWidth - 40) / 2.0], [NSNumber numberWithFloat:15], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSegIndexArray:@[ @"0", @"1", @"0", @"0" ]];
                    [headView changeTextAlignWithIndex:1 withAlig:NSTextAlignmentLeft];
                    [headView changeTextAlignWithIndex:2 withAlig:NSTextAlignmentRight];
                    headView.tag = CompetionCEllTag + 13;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                    }];

                    UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
                    _noDataImgLabel.hidden = YES;
                    _noDataImgLabel.contentMode = UIViewContentModeCenter;
                    _noDataImgLabel.tag = CompetionCEllTag + 3;
                    _noDataImgLabel.image = dp_SportLiveImage(@"foot_left.png");
                    _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
                    [cell.contentView addSubview:_noDataImgLabel];
                    [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                    }];
                }

                UIImageView *imgLab = (UIImageView *)[cell.contentView viewWithTag:CompetionCEllTag + 3];
                if (MAX(self.viewModel.message.homeListArray.count, self.viewModel.message.awayListArray.count) <= 0) {
                    imgLab.hidden = NO;
                    return cell;
                } else
                    imgLab.hidden = YES;

                DPLiveOddsHeaderView *view = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CompetionCEllTag + 13];
                NSString *homeTeam = self.viewModel.homeName ? self.viewModel.homeName : @" ";
                NSString *teamName = self.viewModel.awayName ? self.viewModel.awayName : @" ";
                [view setTitles:@[ @" ", homeTeam, teamName, @" " ]];

                return cell;
            } else {
                static NSString *PlayerCellIdentitifer = @"PlayerCellIdentitifer";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentitifer];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerCellIdentitifer];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.contentView.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:30 withWidth:kScreenWidth - 10];
                    headView.titleFont = [UIFont dp_systemFontOfSize:12];
                    NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:10], [NSNumber numberWithFloat:25], [NSNumber numberWithFloat:(kScreenWidth - 10 - 70) / 2], [NSNumber numberWithFloat:(kScreenWidth - 10 - 70) / 2], [NSNumber numberWithFloat:25], [NSNumber numberWithFloat:10], nil];
                    [headView createHeaderWithWidthArray:arr whithHigh:30 withSegIndexArray:@[ @"0", @"0", @"1", @"0", @"0", @"0" ]];
                    headView.backgroundColor = [UIColor dp_flatWhiteColor];
                    [headView settitleColors:[NSArray arrayWithObjects:UIColorFromRGB(0x6F6B68), [UIColor dp_flatBlackColor], UIColorFromRGB(0x6F6B68), [UIColor dp_flatBlackColor], nil]];
                    ;

                    headView.tag = CompetionCEllTag + 7;
                    [cell.contentView addSubview:headView];
                    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                    }];
                }

                PBMFootEventData_FormationDetailInfo *homePalyerInfo = (indexPath.row <= self.viewModel.message.homeListArray.count) ? [self.viewModel.message.homeListArray objectAtIndex:indexPath.row - 1] : nil;
                PBMFootEventData_FormationDetailInfo *awayPalyerInfo = (indexPath.row <= self.viewModel.message.awayListArray.count) ? [self.viewModel.message.awayListArray objectAtIndex:indexPath.row - 1] : nil;

                NSString *homeRank = @" ", *homeTeam = @" ", *awayTeam = @" ", *awayRank = @" ";
                UIColor *homeColor = [UIColor clearColor], *awayColor = [UIColor clearColor];

                if (homePalyerInfo) {
                    homeRank = [NSString stringWithFormat:@"%@", homePalyerInfo.number > 0 ? [NSString stringWithFormat:@"%d", homePalyerInfo.number] : @" "];
                    homeTeam = homePalyerInfo.player;

                    if (homePalyerInfo.firstPlayer) {
                        homeColor = _colorsArray[0];
                    } else
                        homeColor = _colorsArray[1];

                } else {
                    homeRank = homeTeam = @" ";
                }

                if (awayPalyerInfo) {
                    awayRank = [NSString stringWithFormat:@"%@", awayPalyerInfo.number > 0 ? [NSString stringWithFormat:@"%d", awayPalyerInfo.number] : @" "];
                    awayTeam = awayPalyerInfo.player;

                    if (awayPalyerInfo.firstPlayer) {
                        awayColor = _colorsArray[0];
                    } else
                        awayColor = _colorsArray[1];

                } else {
                    awayRank = awayTeam = @" ";
                }

                DPLiveOddsHeaderView *view = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:CompetionCEllTag + 7];
                [view settitleColors:@[ homeColor, homeColor, homeColor, awayColor, awayColor, awayColor ]];
                [view setTitles:@[ @" ", homeRank, homeTeam, awayTeam, awayRank, @" " ]];

                return cell;
            }
        }
        case 3: {
            static NSString *BenchPlayerIdentitifer = @"BenchPlayerIdentitifer";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BenchPlayerIdentitifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BenchPlayerIdentitifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];

                UILabel *bottomLabel = [[UILabel alloc] init];
                bottomLabel.backgroundColor = [UIColor clearColor];
                bottomLabel.attributedText = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<sizeColor1><size>■</size></sizeColor1>首发   <sizeColor2><size>■</size></sizeColor2>替补"]];

                [cell.contentView addSubview:bottomLabel];
                [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(10);
                    make.centerY.equalTo(cell.contentView);
                }];
            }

            return cell;
        }

        break;
        default:
            return nil;
    }
}

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.textColor = [UIColor dp_flatBlackColor];
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr;
                 })];
        [_parser addStyleWithTagName:@"size" font:[UIFont dp_systemFontOfSize:12]];
        [_parser addStyleWithTagName:@"sizeColor1" color:_colorsArray[0]];
        [_parser addStyleWithTagName:@"sizeColor2" color:_colorsArray[1]];
    }

    return _parser;
}

@end
