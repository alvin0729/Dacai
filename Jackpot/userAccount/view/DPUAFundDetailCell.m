//
//  DPUAFundDetailCell.m
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUAFundDetailCell.h"
@interface DPUAFundDetailCell()
@property (nonatomic, strong) UILabel *fundValueLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DPUAFundDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon= [[UIImageView alloc]init];
        [self.contentView addSubview:self.icon];
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [self.dateFormatter setDateFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(16);
        }];
        
        self.titleLabel =[UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13);
            make.left.mas_equalTo(64);
            make.height.mas_equalTo(14);
        }];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 64, 0, 0)];
        
        self.subTitleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xb3b3b3) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.titleLabel.mas_left);
            make.height.mas_equalTo(12);
        }];
        
        self.fundValueLabel = [[UILabel alloc]init];
        self.fundValueLabel.textColor = UIColorFromRGB(0x343434);
        self.fundValueLabel.textAlignment = NSTextAlignmentRight;
        self.fundValueLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.fundValueLabel];
        [self.fundValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.subTitleLabel.mas_bottom);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(14);
        }];

    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPUAFundDetailCell";
    DPUAFundDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return cell;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    self.titleLabel.text = object.fundTitle;
    NSString *fundTime = [NSString stringWithFormat:@"%@ 00:00:00",[NSDate dp_coverDateString:object.fundTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]];
    NSDate *fundDate = [NSDate dp_dateFromString:fundTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss ];
    NSString *nowDateStr = [NSString stringWithFormat:@"%@ 00:00:00", [NSDate dp_coverDateString:[self.dateFormatter stringFromDate:[NSDate date]] fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd]];
    NSDate *nowDate = [NSDate dp_dateFromString:nowDateStr withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    NSDate *lastDate = [nowDate dateByAddingTimeInterval:-60*60*24];
    if ([fundDate compare:nowDate]==0) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"今天%@",[NSDate dp_coverDateString:object.fundTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm]];
    }else if ([fundDate compare:lastDate]==0) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"昨天%@",[NSDate dp_coverDateString:object.fundTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm]];
    }else{
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@",[NSDate dp_coverDateString:object.fundTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_MM_dd_HH_mm]];
    }
//    NSDate
    self.icon.image = dp_AccountImage(object.fundIconName);
    if ([object.fundValue integerValue]>0) {
         self.fundValueLabel.text = [NSString stringWithFormat:@"+%@元",object.fundValue];
    }else{
         self.fundValueLabel.text = [NSString stringWithFormat:@"%@元",object.fundValue];
    }
}
@end
