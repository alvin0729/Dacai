//
//  DPHLExpertCell.h
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLExpertCell : UITableViewCell
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, copy) void (^heartLoveOrderBlock)(DPHLObject *object);
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
