//
//  DPHLItemView.m
//  Jackpot
//
//  Created by mu on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLItemView.h"

@interface DPHLItemView()

@end

@implementation DPHLItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImage = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLCellBg.png")];
        [self addSubview:self.bgImage];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(36);
        }];
        
        self.hlIconImage = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLPayFee.png")];
        [self.bgImage addSubview:self.hlIconImage];
        [self.hlIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-6);
        }];
        
        UIView *verLine = [[UIView alloc]init];
        verLine.backgroundColor = UIColorFromRGB(0xccbeb1);
        [self.bgImage addSubview:verLine];
        
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.bgImage.mas_bottom).offset(-7);
            make.width.mas_equalTo(0.5);
        }];
     
        self.matchTitleLab = [UILabel dp_labelWithText:@"----VS----" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:13]];
        self.matchTitleLab.textAlignment = NSTextAlignmentCenter;
        [self.bgImage addSubview:self.matchTitleLab];
        [self.matchTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.equalTo(verLine.mas_left);
            make.bottom.mas_equalTo(0);
        }];
        
        self.matchValueLab = [UILabel dp_labelWithText:@"--/-" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:13]];
        self.matchValueLab.textAlignment = NSTextAlignmentCenter;
        [self.bgImage addSubview:self.matchValueLab];
        [self.matchValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.equalTo(verLine.mas_right);
            make.bottom.mas_equalTo(0);
        }];
  
        UIImageView *buyIcon = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLMembers.png")];
        [self addSubview:buyIcon];
        [buyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImage.mas_bottom).offset(6);
            make.left.mas_equalTo(8);
        }];
        self.buyIcon = buyIcon;
        
        self.buyCountLabel = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        [self addSubview:self.buyCountLabel];
        [self.buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(buyIcon.mas_centerY);
            make.left.equalTo(buyIcon.mas_right).offset(4);
        }];
        
        self.awardValueLabel = [UILabel dp_labelWithText:@"--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xfd692b) font:[UIFont boldSystemFontOfSize:11]];
        [self addSubview:self.awardValueLabel];
        [self.awardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImage.mas_bottom).offset(6);
            make.right.mas_equalTo(-8);
        }];
        
        UIImageView *awardIcon = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLAwardIcon.png")];
        [self addSubview:awardIcon];
        [awardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.awardValueLabel.mas_centerY);
            make.right.equalTo(self.awardValueLabel.mas_left).offset(-4);
        }];
        self.awardIcon = awardIcon;

    }
    return self;
}

@end
