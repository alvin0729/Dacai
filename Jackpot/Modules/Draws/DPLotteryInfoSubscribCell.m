//
//  DPLotteryInfoSubscribCell.m
//  Jackpot
//
//  Created by mu on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoSubscribCell.h"

@interface DPLotteryInfoSubscribCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *subscribBtn;
@property (nonatomic, strong) UILabel *subscribCountLabel;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation DPLotteryInfoSubscribCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.icon.backgroundColor = randomColor;
        [self.contentView addSubview:self.icon];
     
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        
        self.titleLabel = [UILabel dp_labelWithText:@"titleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [UILabel dp_labelWithText:@"subTitleLabel" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        [self.subTitleLabel sizeToFit];
        self.subTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.subTitleLabel];
        
        self.subscribBtn = [UIButton dp_buttonWithTitle:@"订阅" titleColor:[UIColor dp_flatRedColor] backgroundColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:14]];
        [self.subscribBtn setTitle:@"已订阅" forState:UIControlStateSelected];
        [self.subscribBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
        self.subscribBtn.layer.cornerRadius = 5;
        self.subscribBtn.layer.borderWidth = 0.5;
        self.subscribBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        [[self.subscribBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
            if (self.btnBlock) {
                self.btnBlock(btn);
            }
        }];
        [self.contentView addSubview:self.subscribBtn];
        
        self.subscribCountLabel = [UILabel dp_labelWithText:@"订阅数：0" backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight lineBreakMode:NSLineBreakByWordWrapping textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.subscribCountLabel];
  
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.equalTo(self.icon.mas_right).offset(10);
            make.height.mas_equalTo(17);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.subscribBtn.mas_left).offset(-30);
        }];
        
        [self.subscribBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_top);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(60, 24));
        }];
        
        [self.subscribCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.subscribBtn.mas_bottom).offset(11);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(11);
        }];
        
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPLotteryInfoSubscribCell";
    DPLotteryInfoSubscribCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}

- (void)setObject:(DPLotteryInfoObject *)object{
    _object = object;
    self.titleLabel.text = _object.title;
    self.subTitleLabel.text = _object.subTitle;
    self.subscribCountLabel.text = [NSString stringWithFormat:@"订阅数：%@",_object.value];
    self.subscribBtn.selected = _object.isSubscrib;
}
@end
