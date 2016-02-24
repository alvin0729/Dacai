//
//  DPBankCell.h
//  Jackpot
//
//  Created by mu on 15/9/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUABaseCell.h"

@interface DPBankCell : DPUABaseCell

@property (nonatomic, strong)UIView *indirectorView;
/**
 *  icon
 */
@property (nonatomic, strong)UIImageView *bankIcon;
/**
 *  title
 */
@property (nonatomic, strong)UILabel *bankNameLabel;
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
