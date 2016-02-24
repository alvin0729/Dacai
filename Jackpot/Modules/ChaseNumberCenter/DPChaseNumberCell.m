//
//  DPChaseNumberCell.m
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPChaseNumberCell.h"

@interface DPChaseNumberCell () {
@private
    UIImageView* _iconImageView;//彩种图标
    UILabel* _lotteryName;//彩种名称
    UILabel* _orderTime;//追号时间
    UILabel* _chaseInfo;//追号详情
}
@property (nonatomic, strong, readonly) UILabel* lotteryName;//彩种名称
@property (nonatomic, strong, readonly) UILabel* orderTime;//追号时间
@property (nonatomic, strong, readonly) UILabel* chaseInfo;//追号详情
@end
@implementation DPChaseNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* contentView = self.contentView;
        self.backgroundColor = [UIColor clearColor];
        contentView.backgroundColor = [UIColor clearColor];
        UIImageView* rightArrow = [[UIImageView alloc] init];
        rightArrow.image = dp_AccountImage(@"chaseArrow.png");
        rightArrow.backgroundColor = [UIColor clearColor];
        [contentView addSubview:rightArrow];
        [contentView addSubview:self.iconImageView];
        [contentView addSubview:self.lotteryName];
        [contentView addSubview:self.orderTime];
        [contentView addSubview:self.chaseInfo];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(8);
            make.centerY.equalTo(contentView);
            make.height.equalTo(@38);
            make.width.equalTo(@38);
        }];
        [self.lotteryName mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(6);
            make.top.equalTo(contentView).offset(15);
            make.height.equalTo(@17);

        }];
        [self.orderTime mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.lotteryName);
            make.top.equalTo(self.lotteryName.mas_bottom).offset(4);
            make.height.equalTo(@10);
        }];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(contentView).offset(-8);
            make.centerY.equalTo(contentView);

        }];
        [self.chaseInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(rightArrow.mas_left).offset(-8);
            make.centerY.equalTo(contentView);
            make.height.equalTo(@30);
        }];

        UIView* line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(contentView).offset(8);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}


//彩种名称
- (void)lotteryNameLabelText:(NSString*)text
{
    self.lotteryName.text = text;
}
//追号时间
- (void)orderTimeLabelText:(NSString*)text
{
    self.orderTime.text = text;
}
//追号信息
- (void)chaseInfoLabeltext:(NSString*)text
{
    self.chaseInfo.text = text;
}


//彩种图标
- (UIImageView*)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}
//彩种名称
- (UILabel*)lotteryName
{
    if (_lotteryName == nil) {
        _lotteryName = [[UILabel alloc] init];
        _lotteryName.backgroundColor = [UIColor clearColor];
        _lotteryName.textColor = UIColorFromRGB(0x333333);
        _lotteryName.font = [UIFont systemFontOfSize:17.0];
        _lotteryName.textAlignment = NSTextAlignmentLeft;
        _lotteryName.text = @"大乐透";
        _lotteryName.adjustsFontSizeToFitWidth = YES;
    }
    return _lotteryName;
}
//追号时间
- (UILabel*)orderTime
{
    if (_orderTime == nil) {
        _orderTime = [[UILabel alloc] init];
        _orderTime.backgroundColor = [UIColor clearColor];
        _orderTime.textColor = UIColorFromRGB(0x999999);
        _orderTime.font = [UIFont systemFontOfSize:11.0];
        _orderTime.textAlignment = NSTextAlignmentLeft;
        _orderTime.text = @"2015-11-23 10:10";
        _orderTime.adjustsFontSizeToFitWidth = YES;
    }
    return _orderTime;
}
//追号详情
- (UILabel*)chaseInfo
{
    if (_chaseInfo == nil) {
        _chaseInfo = [[UILabel alloc] init];
        _chaseInfo.backgroundColor = [UIColor clearColor];
        _chaseInfo.textColor = [UIColor dp_flatBlackColor];
        _chaseInfo.font = [UIFont systemFontOfSize:12.0];
        _chaseInfo.textAlignment = NSTextAlignmentRight;
        _chaseInfo.text = @"共追20期，已追10期";
        _chaseInfo.adjustsFontSizeToFitWidth = YES;
    }
    return _chaseInfo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
