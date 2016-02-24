//
//  DPLotterySubscribInfosCell.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotterySubscribInfosCell.h"

@interface DPLotterySubscribInfosCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation DPLotterySubscribInfosCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *seperatorLine = [[UIView alloc]init];
        seperatorLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:seperatorLine];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.icon.backgroundColor = randomColor;
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(82, 61));
        }];
        
        self.titleLabel = [UILabel dp_labelWithText:@"titleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.equalTo(self.icon.mas_right).offset(10);
            make.height.mas_equalTo(17);
        }];
        
        self.subTitleLabel = [UILabel dp_labelWithText:@"subTitleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:14]];
        self.subTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-8);
        }];
        
        self.commentCountLabel = [UILabel dp_labelWithText:@"timeLabel" backgroundColor:[UIColor dp_flatBackgroundColor] textAlignment:NSTextAlignmentRight lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0xb5b5b5) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.commentCountLabel];
        [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
        }];
        
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPLotterySubscribInfosCell";
    DPLotterySubscribInfosCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}

- (void)setObject:(DPLotteryInfoObject *)object{
    _object = object;
    self.titleLabel.text = _object.title;
    self.subTitleLabel.text = _object.subTitle;
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@阅读",_object.value];
}
@end
