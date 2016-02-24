//
//  DPHistoryTendencyCell.m
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPHistoryTendencyCell.h"
#import "DPLBCellViewModel.h"
@interface DPHistoryTendencyCell () {
@private
    UILabel *_gameNameLab;
    UIImageView *_ballView;
    UILabel *_gameInfoLab;
}

@end

@implementation DPHistoryTendencyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  digitalType:(int)digitalType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor dp_flatBackgroundColor]];
        self.lotteryType=digitalType;
        [self buildLayout];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
//开奖信息
- (UILabel *)gameInfoLab {
    if (_gameInfoLab == nil) {
        _gameInfoLab = [[UILabel alloc] init];
        _gameInfoLab.numberOfLines = 1;
        _gameInfoLab.textColor = [UIColor dp_flatRedColor];
        _gameInfoLab.font = [UIFont dp_systemFontOfSize:11];
        _gameInfoLab.backgroundColor = [UIColor clearColor];
        _gameInfoLab.textAlignment = NSTextAlignmentLeft;
        _gameInfoLab.lineBreakMode = NSLineBreakByWordWrapping;
        _gameInfoLab.userInteractionEnabled = NO;
    }
    return _gameInfoLab;
}
//期号
- (UILabel *)gameNameLab {
    if (_gameNameLab == nil) {
        _gameNameLab = [[UILabel alloc] init];
        _gameNameLab.backgroundColor = [UIColor clearColor];
        _gameNameLab.font = [UIFont dp_systemFontOfSize:11];
        _gameNameLab.textAlignment = NSTextAlignmentRight;
        _gameNameLab.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _gameNameLab.highlightedTextColor = [UIColor dp_flatRedColor];
    }
    return _gameNameLab;
}

- (UIImageView *)ballView {
    if (_ballView == nil) {
        _ballView = [[UIImageView alloc] initWithImage:dp_DigitLotteryImage(@"ballHistoryBonus_01.png") highlightedImage:dp_DigitLotteryImage(@"ballHistoryBonus_02.png")];
    }
    return _ballView;
}

- (void)buildLayout {
    [self.contentView addSubview:self.gameNameLab];
    [self.contentView addSubview:self.ballView];
    [self.contentView addSubview:self.gameInfoLab];
   
    [self.gameNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@60);
//        if (self.lotteryType==GameTypeJxsyxw) {
//            make.width.equalTo(self.contentView).multipliedBy(0.25);
//        }else{
//        make.width.equalTo(self.contentView).multipliedBy(0.15);
//        }
        
        
        make.centerY.equalTo(self.contentView);
    }];
    [self.ballView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameNameLab.mas_right).offset(5);
        make.width.equalTo(@8);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

    [self.gameInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ballView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView).offset(-1);
    }];
}
- (void)setDataModel:(id)dataModel
{
    if ([dataModel isKindOfClass:[DPLBTrendCellViewModel class]]) {
        DPLBTrendCellViewModel *model = (DPLBTrendCellViewModel *)dataModel;
        if (model.ballViewImg) self.ballView.image = model.ballViewImg;
        if (model.gameNameColor) self.gameNameLab.textColor = model.gameNameColor;
        self.gameNameLab.text = [NSString stringWithFormat:@"%@期",model.gameNameText];
        self.gameInfoLab.attributedText = model.gameInfoAttText;
    }
}
@end

 