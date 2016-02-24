//
//  DPHLFocusCell.h
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLFocusCell : UITableViewCell
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, copy) void (^focusBtnTapped)(DPHLObject *object);
@property (nonatomic, copy) void (^cellTapped)(NSIndexPath *indexPath);
- (instancetype)initWithTableView:(UITableView *)tableView andMarkTitles:(NSMutableArray *)markTitlesArray atIndexPath:(NSIndexPath *)indexPath;
@end
