//
//  DPBasketballCenterIntegralController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterIntegralController.h"
#import "DPDataCenterTableController+Private.h"
#import "DPBasketballCenterIntegralViewModel.h"
#import "BasketballDataCenter.pbobjc.h"
#import "DPSegmentedControl.h"
#import "DPLiveDataCenterViews.h"
@interface DPBasketballCenterIntegralController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DPBasketballCenterIntegralViewModel *viewModel;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) MTStringParser *parser;

@end

@implementation DPBasketballCenterIntegralController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"积分";
        _viewModel = [[DPBasketballCenterIntegralViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel] ;

    }
    return self;
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55 + 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.message.groupsArray.count <= 0) {
        return 150;
    }
    return 25;
}

#define PointLCTag 77777
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PBMBasketballIntegral *_dateCenter = self.viewModel.message;
    if (_dateCenter.groupsArray.count <= 0) {
        static NSString *HeaderNodataIdentifier = @"HeaderNodataIdentifier";
        UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderNodataIdentifier];
        if (view == nil) {
            view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderNodataIdentifier];
            view.contentView.backgroundColor = [UIColor clearColor];
            view.backgroundView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromRGB(0xfaf9f2);
                view;
            });
        }

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
        NSMutableArray *titlesArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < _dateCenter.groupsArray.count; i++) {
            [titlesArr addObject:((PBMBasketballIntegral_IntegralGroup *)_dateCenter.groupsArray[i]).title];
        }
        DPSegmentedControl *seg = [[DPSegmentedControl alloc] initWithItems:titlesArr];

        seg.indicatorColor = [UIColor dp_flatRedColor];
        seg.tag = PointLCTag + 1;
        seg.selectedIndex = self.type;
        seg.textColor = UIColorFromRGB(0x7e6a5f)  ;
        [seg setTintColor:UIColorFromRGB(0xc3c4bf)];
        [seg addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:seg];
        
        DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] init];
        headView.titleFont = [UIFont dp_systemFontOfSize:12];
        headView.textColors = [UIColor dp_colorFromRGB:0xa8a69d];
        headView.backgroundColor = [UIColor dp_flatWhiteColor];

        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:77.5], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:77.5], nil];
        [headView createHeaderWithWidthArray:arr whithHigh:25 withSeg:NO];

        headView.tag = 999;
        [view addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom);
            make.left.equalTo(view).offset(5);
            make.height.equalTo(@23);
            make.right.equalTo(view).offset(-5);
        }];
        
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView.mas_top).offset(-8);
            make.width.equalTo(@202);
            make.height.equalTo(@31);
            make.centerX.equalTo(view);
        }];

        [headView setTitles:[NSArray arrayWithObjects:@"排名", @"球队", @"胜", @"负", @"胜率", @"近期状态", nil]];
    }

    //    NSMutableArray* arr = [[NSMutableArray alloc]init];
    //    for (int i=0;i<titles.size();i++) {
    //        [arr addObject:[NSString stringWithUTF8String:titles[i].c_str()]];
    //    }
    //    [seg.containerView setItems:arr];
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.message.groupsArray.count <= 0) {
        return 1;
    }
    return ((PBMBasketballIntegral_IntegralGroup*)[self.viewModel.message.groupsArray objectAtIndex:self.type]).integralsArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_Reuse = @"cell_Reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];

        DPLiveOddsHeaderView *headView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:25 withWidth:kScreenWidth - 10];
        headView.textColors = UIColorFromRGB(0x535353);
        headView.titleFont = [UIFont dp_systemFontOfSize:11];
        NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:77.5], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:38.75], [NSNumber numberWithFloat:77.5], nil];
        [headView createHeaderWithWidthArray:arr whithHigh:25 withSeg:NO];
        headView.tag = PointLCTag + 2;
        [cell.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(5);
            make.height.equalTo(@25);
            make.right.equalTo(cell.contentView).offset(-5);
        }];

        UIImageView *_noDataImgLabel = [[UIImageView alloc] init];
        _noDataImgLabel.tag = PointLCTag + 3;
        
        _noDataImgLabel.contentMode = UIViewContentModeCenter;
        _noDataImgLabel.hidden = YES;
        _noDataImgLabel.layer.borderWidth = 0.5 ;
        _noDataImgLabel.layer.borderColor = kLayerColor.CGColor ;
        _noDataImgLabel.image = dp_SportLiveImage(@"basket_down.png");
        _noDataImgLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        [cell.contentView addSubview:_noDataImgLabel];
        [_noDataImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5));
        }];
    }

    DPImageLabel *noDataImg = (DPImageLabel *)[cell.contentView viewWithTag:PointLCTag + 3];
    if (self.viewModel.message.groupsArray.count <= 0) {
        noDataImg.hidden = NO;
        return cell;
    } else
        noDataImg.hidden = YES;

    PBMBasketballIntegral_Integral *integral = [((PBMBasketballIntegral_IntegralGroup *)self.viewModel.message.groupsArray[self.type]).integralsArray objectAtIndex:indexPath.row];

    DPLiveOddsHeaderView *cellView = (DPLiveOddsHeaderView *)[cell.contentView viewWithTag:PointLCTag + 2];

    NSString *firstStr = [NSString stringWithFormat:@"%d", integral.rank];

    BOOL homeOrAway = [integral.team isEqualToString:self.viewModel.homeName] || [integral.team isEqualToString:self.viewModel.awayName];
    id secondtStr = homeOrAway ? [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<red>%@</red>", integral.team]] : integral.team;

    NSString *thirdStr = [NSString stringWithFormat:@"%@", integral.winTimes];
    NSString *fourStr = [NSString stringWithFormat:@"%@", integral.loseTimes];
    NSString *fivStr = [NSString stringWithFormat:@"%@", integral.winPercentage];

    NSString *recentSta = integral.recentState;

    BOOL winOrLose = [recentSta hasSuffix:@"胜"];
    id sixStr = winOrLose ? [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<red>%@</red>", integral.recentState]] : [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"<blue>%@</blue>", integral.recentState]];

    NSArray *titlesAray = [NSArray arrayWithObjects:firstStr, secondtStr, thirdStr, fourStr, fivStr, sixStr, nil];

    [cellView setTitles:titlesAray];

    if (indexPath.row % 2 == 0) {
        cellView.backgroundColor = [UIColor dp_colorFromRGB:0xffffff];
    } else {
        cellView.backgroundColor = [UIColor dp_flatBackgroundColor];
    }

    return cell;
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
        [_parser addStyleWithTagName:@"red" color:UIColorFromRGB(0xdc2804)];
        [_parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x3456a4)];
    }
    return _parser;
}

- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    if (self.type != seg.selectedIndex) {
        [self setType:(seg.selectedIndex)];

        [self.tableView reloadData];
    }
}

@end
