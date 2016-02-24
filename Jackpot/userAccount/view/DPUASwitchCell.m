//
//  DPUASwitchCell.m
//  Jackpot
//
//  Created by mu on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUASwitchCell.h"

@implementation DPUASwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellSwitch = [[UISwitch alloc]init];
        [self.contentView addSubview:self.cellSwitch];
        [self.cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-20);
        }];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
