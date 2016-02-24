//
//  DPIconTextCell.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  大智慧cell

#import <UIKit/UIKit.h>
#import "DPUABaseCell.h"
@interface DPIconTextCell : DPUABaseCell
/**
 *  icon
 */
@property (nonatomic, strong) UIImageView *iconImage;//图标
/**
 *  tf
 */
@property (nonatomic, strong) UITextField *text;//输入框
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
