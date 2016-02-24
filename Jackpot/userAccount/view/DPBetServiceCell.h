//
//  DPBetServiceCell.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUALoginCell.h"

@interface DPBetServiceCell : DPUALoginCell
/**
 *
 */
@property (nonatomic, strong)MASConstraint *lineToLeft;

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
