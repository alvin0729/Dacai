//
//  DPMessageCenterCell.h
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUABaseCell.h"

@interface DPMessageCenterCell : DPUABaseCell
/**
 *  selectBtn
 */
@property (nonatomic, strong) UIButton *selectBtn;//选择按钮

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
