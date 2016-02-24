//
//  DPLotteryInfoSubscribCategoryCell.h
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLotteryInfoObject.h"

@interface DPLotteryInfoSubscribCategoryCell : UITableViewCell
@property (nonatomic, strong) DPLotteryInfoObject *object;

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
