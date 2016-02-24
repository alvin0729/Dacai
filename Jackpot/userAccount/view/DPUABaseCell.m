//
//  DPUABaseCell.m
//  Jackpot
//
//  Created by mu on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUABaseCell.h"

@implementation DPUABaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.separatorLine = [[UIView alloc]init];
        self.separatorLine.backgroundColor = ycolorWithRGB(0.81, 0.81, 0.83);
        [self.contentView addSubview:self.separatorLine];
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.textLabel.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.firstLine = [[UIView alloc]init];
        self.firstLine.hidden = YES;
        self.firstLine.backgroundColor = ycolorWithRGB(0.81, 0.81, 0.83);
        [self.contentView addSubview:self.firstLine];
        [self.firstLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.lastLine = [[UIView alloc]init];
        self.lastLine.hidden = YES;
        self.lastLine.backgroundColor = ycolorWithRGB(0.81, 0.81, 0.83);
        [self.contentView addSubview:self.lastLine];
        [self.lastLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
