//
//  DPBuyTicketCell.h
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUABaseCell.h"

@interface DPBuyTicketCell : DPUABaseCell
/**
 *   分割线
 */
@property (nonatomic, strong)UIView *downSeparatorLine;
/**
 *  初始化cell
 *
 *  @param tableView cell所在的tableview
 *  @param indexPath cell所在的行和section
 *
 *  @return DPBuyTicketCell
 */
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
