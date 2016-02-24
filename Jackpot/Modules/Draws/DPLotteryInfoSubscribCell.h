//
//  DPLotteryInfoSubscribCell.h
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLotteryInfoObject.h"

typedef void (^cellBtnTappedBlock)(UIButton *btn);

@interface DPLotteryInfoSubscribCell : UITableViewCell
@property (nonatomic, strong) DPLotteryInfoObject *object;
@property (nonatomic, copy) cellBtnTappedBlock btnBlock;
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
