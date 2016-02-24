//
//  DPHLItemCell.h
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLItemCell : UITableViewCell
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, copy) void (^iconBtnTappedBlock)(DPHLObject *object);
@property (nonatomic, copy) void (^heartLoveOrderBlock)(DPHLObject *object);
@property (nonatomic, assign) BOOL buyHlIconHiddle;
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
