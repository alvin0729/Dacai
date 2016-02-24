//
//  DPBetServiceCell.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBetServiceCell.h"
@interface DPBetServiceCell()
@end

@implementation DPBetServiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.borderWidth = 0;
        self.userInteractionEnabled = YES;
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            self.lineToLeft = make.left.mas_equalTo(90);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}


- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPBetServiceCell";
    DPBetServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        if (indexPath.row == 0) {
            UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            upLineView.backgroundColor = ycolorWithRGB(0.81, 0.81, 0.83);
            [cell.contentView addSubview:upLineView];
        }
    }
    cell.cellBtn.tag = indexPath.row;
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    
}
@end
