//
//  DPAccountFunctionCell.h
//  Jackpot
//
//  Created by mu on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUABaseCell.h"

@interface DPAccountFunctionCell : DPUABaseCell
@property (nonatomic,strong)UILabel *messageCountLab;
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subTitleLabel;
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
