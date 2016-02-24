//
//  DPMessageCenterCell.m
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPMessageCenterCell.h"
@interface DPMessageCenterCell()
/**
 *  title  标题
 */
@property (nonatomic, strong) UILabel *messageTitleLabel;
/**
 *  content 内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *  time  时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  titleToLeft
 */
@property (nonatomic, strong) MASConstraint *titleToLeft;

@end

@implementation DPMessageCenterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.selectBtn = [UIButton dp_buttonWithTitle:nil titleColor:nil backgroundColor:nil font:nil];        
        self.selectBtn.userInteractionEnabled = NO;
           [self.contentView addSubview:self.selectBtn];
         [self.selectBtn setImage:dp_AccountImage(@"nocheck.png") forState:UIControlStateNormal];
        [self.selectBtn setImage:dp_AccountImage(@"checked.png") forState:UIControlStateSelected];
         self.selectBtn.backgroundColor = [UIColor clearColor] ;

         [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            self.titleToLeft = make.left.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.messageTitleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        self.messageTitleLabel.contentMode = UIViewContentModeTop;
        [self.contentView addSubview:self.messageTitleLabel];
        [self.messageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.equalTo(self.selectBtn.mas_right).offset(10);
            make.height.mas_equalTo(14);
        }];
        
        self.timeLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x96907f) font:[UIFont systemFontOfSize:12]];
           [self.contentView addSubview:self.timeLabel];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.messageTitleLabel.mas_centerY);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(12);
        }];
        
        self.contentLabel =[UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x96907f) font:[UIFont systemFontOfSize:12]];
           [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageTitleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.messageTitleLabel.mas_left);
            make.right.mas_equalTo(-10);
            
        }];
        
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.messageTitleLabel.mas_left);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
//cell
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPMessageCenterCell";
    DPMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
//刷新数据源
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    
    self.timeLabel.text = object.subTitle;
    self.contentLabel.text = object.value;
    if (object.isEdit) {
        self.titleToLeft.mas_equalTo(5);
    }else{
        self.titleToLeft.mas_equalTo(-25);
    }
    self.selectBtn.selected = object.isSelect;
    if (object.isRead) {
        self.messageTitleLabel.text = object.title;
    }else{
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"●%@",object.title]];
        [mutableStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xdc4e4c),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, 1)];
        self.messageTitleLabel.attributedText = mutableStr;
    }
}
@end
