//
//  DPUARedGiftCell.h
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUABaseCell.h"

@interface DPUARedGiftCell : DPUABaseCell
/**
 *  图片
 */
@property (nonatomic, strong) UIImageView *redGiftIcon;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *redGiftTitleLabel;
/**
 *  子标题
 */
@property (nonatomic, strong) UILabel *redGiftSubTitleLabel;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *redGiftTimeLabel;
/**
 *  金额
 */
@property (nonatomic, strong) UILabel *redGiftValueLabel;

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
