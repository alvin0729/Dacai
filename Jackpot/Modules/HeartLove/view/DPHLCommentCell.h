//
//  DPHLCommentCell.h
//  Jackpot
//
//  Created by mu on 16/1/7.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"

@interface DPHLCommentCell : UITableViewCell
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@property (nonatomic, strong) DPHLObject *object;
@property (nonatomic, copy) void (^contentTappedBlock)(DPHLObject *object);
@property (nonatomic, copy) void (^likeBtnTappedBlock)(DPHLObject *object);
@property (nonatomic, copy) void (^cellTappedBlock)();
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
