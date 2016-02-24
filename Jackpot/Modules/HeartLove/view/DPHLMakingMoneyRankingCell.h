//
//  DPHLMakingMoneyRankingCell.h
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLMakingMoneyRankingCell : UITableViewCell
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UIImageView *rankingBgImage;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, copy) void (^focusBtnTapped)(DPHLObject *object);
@property (nonatomic, copy) void (^cellTapped)(NSIndexPath *indexPath);
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
