//
//  DPLotteryInfoSubscribCategoryCell.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoSubscribCategoryCell.h"
@interface DPLotteryInfoSubscribCategoryCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *seperatorLine;
@end

@implementation DPLotteryInfoSubscribCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.icon.backgroundColor = randomColor;
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        self.seperatorLine = seperatorLine;
        [self.contentView addSubview:seperatorLine];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(self.icon.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.titleLabel = [UILabel dp_labelWithText:@"titleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.equalTo(self.icon.mas_right).offset(10);
            make.height.mas_equalTo(17);
        }];
        
        
        self.subTitleLabel = [UILabel dp_labelWithText:@"subTitleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        self.subTitleLabel.numberOfLines = 1;
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(11);
        }];
        
        
        self.timeLabel = [UILabel dp_labelWithText:@"timeLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(11);
        }];
        
        
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPLotteryInfoSubscribCategoryCell";
    DPLotteryInfoSubscribCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        cell.seperatorLine.hidden = indexPath.row==0;
    }
    return cell;
}

- (void)setObject:(DPLotteryInfoObject *)object{
    _object = object;
    self.titleLabel.text = _object.title;
    self.subTitleLabel.text = _object.subTitle;
    self.timeLabel.text = _object.value;
}
@end
