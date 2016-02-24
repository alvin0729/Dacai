//
//  DPGSRankingAwardCell.h
//  Jackpot
//
//  Created by mu on 15/11/13.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUABaseCell.h"
typedef void (^getBtnTappedBlock)();
@interface DPGSRankingAwardCell : DPUABaseCell
/**
 *  btnTapped
 */
@property (nonatomic, copy)getBtnTappedBlock getBtnBlock;
/**
 *  初始化cell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return cell
 */
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
