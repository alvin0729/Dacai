//
//  DPUAFundHeaderView.m
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUAFundHeaderView.h"

@implementation DPUAFundHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        
        //账户金额
        self.fundValueLabel = [self creatLabelWithColor:UIColorFromRGB(0xda5350) andTitle:@"--" andFont:30];
        self.fundValueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.fundValueLabel];
        [self.fundValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.mas_equalTo(36);
            make.height.mas_equalTo(25);
        }];
        
       //账户总金额标示
        self.fundTitleLabel = [self creatLabelWithColor:UIColorFromRGB(0xd2cdc9) andTitle:@"账户总金额(元)" andFont:13];
        self.fundTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.fundTitleLabel];
        [self.fundTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(10);
            make.top.equalTo(self.fundValueLabel.mas_bottom).offset(14);
            make.height.mas_equalTo(14);
        }];
        //金钱标示符
        self.fundIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAFundIcon.png")];
        [self addSubview:self.fundIcon];
        [self.fundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.fundTitleLabel.mas_centerY);
            make.right.equalTo(self.fundTitleLabel.mas_left).offset(-6);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        //上分割线
        self.upHonLine = [[UIView alloc]init];
        self.upHonLine.backgroundColor = UIColorFromRGB(0xc7c7c5);
        [self addSubview:self.upHonLine];
        [self.upHonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(105);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.33);
        }];
        //下分割线
        self.downVerLine = [[UIView alloc]init];
        self.downVerLine.backgroundColor = UIColorFromRGB(0xc7c7c5);
        [self addSubview:self.downVerLine];
        [self.downVerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.upHonLine.mas_bottom).offset(8);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(0.66);
            make.bottom.mas_equalTo(-8);
        }];
        //可用余额标示
        self.useableTitleLabel = [self creatLabelWithColor:UIColorFromRGB(0xbfb7af) andTitle:@"可用余额（元）" andFont:12];
        [self addSubview:self.useableTitleLabel];
        [self.useableTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.upHonLine.mas_bottom).offset(18);
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.height.mas_equalTo(14);
        }];
        //可用余额
        self.useableValueLabel = [self creatLabelWithColor:UIColorFromRGB(0xda5350) andTitle:@"--" andFont:19];
        [self addSubview:self.useableValueLabel];
        [self.useableValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.useableTitleLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(kScreenWidth*0.5);
//            make.height.mas_equalTo(16);
        }];
        //冻结金额标示
        self.frozenTitleLabel = [self creatLabelWithColor:UIColorFromRGB(0xbfb7af) andTitle:@"冻结总额（元）" andFont:12];
        [self addSubview:self.frozenTitleLabel];
        [self.frozenTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.upHonLine.mas_bottom).offset(18);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5-15);
            make.height.mas_equalTo(14);
        }];
        //冻结金额
        self.frozenValueLabel = [self creatLabelWithColor:UIColorFromRGB(0xda5350) andTitle:@"--" andFont:19];
        [self addSubview:self.frozenValueLabel];
        [self.frozenValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frozenTitleLabel.mas_bottom).offset(12);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5-15);
//            make.height.mas_equalTo(16);
        }];
        
    }
    return self;
}

#pragma mark---------function
- (UILabel *)creatLabelWithColor:(UIColor *)color andTitle:(NSString *)title andFont:(CGFloat)font{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = color;
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}
@end
