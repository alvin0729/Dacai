//
//  DPHLMatchItemCell.h
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLMatchItemCell : UITableViewCell
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@property (nonatomic, strong) UILabel *hotMatchIconlab;
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
