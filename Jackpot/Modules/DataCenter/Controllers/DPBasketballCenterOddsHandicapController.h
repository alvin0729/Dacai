//
//  DPBasketballCenterOddsHandicapController.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterTableController.h"

@interface DPBasketballCenterOddsHandicapController : DPDataCenterTableController
@end

@class DPLiveOddsHeaderView;
@class DPImageLabel;
@interface DPBasketOddsPositionCell : UITableViewCell
@property (nonatomic, strong) DPLiveOddsHeaderView *cellView;
@property (nonatomic, strong) UIImageView *noDataImgLabel;

- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height;

@end
