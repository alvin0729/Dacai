//
//  DPFootballCenterIntegralController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterIntegralController.h"
#import "DPDataCenterTableController+Private.h"
#import "DPFootballCenterIntegralViewModel.h"
#import "DPHorizontalMultipleLabelView.h"
#import "DPImageLabel.h"

@interface DPFootballCenterIntegralController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) DPFootballCenterIntegralViewModel *viewModel;
@end

@implementation DPFootballCenterIntegralController
@dynamic viewModel;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"积分";
        _viewModel = [[DPFootballCenterIntegralViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        self.tableView.tableFooterView = [DPDataCenterTableController signlLabel] ;

    }
    return self;
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 63 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.rowCount == 0) {
        return 150;
    }
    return indexPath.section == 0 ? 30 : 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderIdentifier = @"Header";
    static NSString *TitleLabelKey = @"TitleLabel";
    
    UITableViewHeaderFooterView *reusableHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if (reusableHeaderView == nil) {
        reusableHeaderView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        reusableHeaderView.contentView.backgroundColor = UIColorFromRGB(0xfaf9f2);
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.font = [UIFont dp_systemFontOfSize:15];
        titleLable.textColor = UIColorFromRGB(0x7e6b5a);
        
        DPHorizontalMultipleLabelView *headerView = [[DPHorizontalMultipleLabelView alloc] init];
        headerView.labelCount = 7;
        headerView.widths = @[ @47, @80, @34, @34, @34, @34, @47];
        headerView.texts = @[ @"排名", @"球队", @"已赛", @"胜", @"平", @"负", @"积分" ];
        headerView.textColor = UIColorFromRGB(0xa8a69d);
        headerView.font = [UIFont dp_systemFontOfSize:12];
        headerView.alignment = NSTextAlignmentCenter;
        headerView.direction = DPBorderDirectionTop | DPBorderDirectionBottom | DPBorderDirectionLeft | DPBorderDirectionRight;
        headerView.borderWidth = 0.5;
        headerView.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1];
        headerView.backgroundColor = [UIColor dp_flatWhiteColor];
        
        [reusableHeaderView.contentView addSubview:titleLable];
        [reusableHeaderView.contentView addSubview:headerView];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView.mas_top).offset(-8);
            make.left.equalTo(reusableHeaderView.contentView) ;
            make.right.equalTo(reusableHeaderView.contentView) ;
         }];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(reusableHeaderView.contentView) ;
            make.centerX.equalTo(reusableHeaderView.contentView) ;
            make.width.mas_equalTo(kScreenWidth-10) ;
            make.height.equalTo(@23) ;
        }] ;
        
        [reusableHeaderView dp_setWeakObject:titleLable forKey:TitleLabelKey];
    }
    UILabel *titleLabel = [reusableHeaderView dp_weakObjectForKey:TitleLabelKey];
    titleLabel.text = self.viewModel.title;
    return reusableHeaderView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.rowCount == 0 ? 1 : (self.viewModel.areaText.length ?2:1);
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? MAX(1, self.viewModel.rowCount) : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 显示无数据图片
    if (self.viewModel.rowCount == 0) {
        static NSString *CellIdentifier = @"EmptyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor =
            cell.contentView.backgroundColor = [UIColor clearColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *imageLabel = [[UIImageView alloc] init];
             imageLabel.layer.borderWidth = 0.5;
            imageLabel.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            imageLabel.contentMode =UIViewContentModeCenter;
            imageLabel.image = dp_SportLiveImage(@"foot_down.png");
            imageLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            [cell.contentView addSubview:imageLabel];
            [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(-0.5, 5, 0, 5));
            }];
         }
        
        return cell;
    }
    
    switch (indexPath.section) {
        case 0: {
            // 显示球队cell
            static NSString *CellIdentifier = @"TeamCell";
            static NSString *kTeamLabelKey = @"TeamLabel";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor =
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                DPHorizontalMultipleLabelView *teamLabel = [[DPHorizontalMultipleLabelView alloc] init];
                teamLabel.labelCount = 7;
                teamLabel.widths = @[ @47, @80, @34, @34, @34, @34, @47];
                teamLabel.font = [UIFont dp_systemFontOfSize:10];
                teamLabel.alignment = NSTextAlignmentCenter;
                teamLabel.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1];
                teamLabel.borderWidth = 0.5;
                teamLabel.direction = DPBorderDirectionLeft | DPBorderDirectionRight | DPBorderDirectionBottom;
                
                [cell.contentView addSubview:teamLabel];
                [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                }];
                
                [cell dp_setWeakObject:teamLabel forKey:kTeamLabelKey];
            }
            DPHorizontalMultipleLabelView *teamLabel = [cell dp_weakObjectForKey:kTeamLabelKey];
            teamLabel.texts = [self.viewModel textListAtIndex:indexPath.row];
            teamLabel.textColor = [self.viewModel textColorAtIndex:indexPath.row];
             [teamLabel changeTexColorWithIndex:0 color:UIColorFromRGB(0xa8a69d)];
            teamLabel.backgroundColor = [self.viewModel backgroundColorAtIndex:indexPath.row];
            return cell;
        }
        default: {
            // 显示积分区域cell
            static NSString *CellIdentifier = @"AreaCell";
            static NSString *kAreaLabelKey = @"AreaLabel";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor =
                cell.contentView.backgroundColor = [UIColor clearColor] ;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *areaLabel = [[UILabel alloc] init];
                [cell.contentView addSubview:areaLabel];
                [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
                }];
                
                [cell dp_setWeakObject:areaLabel forKey:kAreaLabelKey];
            }
            UILabel *areaLabel = [cell dp_weakObjectForKey:kAreaLabelKey];
            areaLabel.attributedText = self.viewModel.areaText;
            return cell;
        }
    }
}

@end


