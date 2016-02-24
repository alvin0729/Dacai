//
//  DPUARedGiftCell.m
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUARedGiftCell.h"
@interface DPUARedGiftCell()
/**
 *  title距离顶部的高度
 */
@property (nonatomic, strong) MASConstraint *titleToTop;
@end

@implementation DPUARedGiftCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        self.redGiftIcon = [[UIImageView alloc]init];
        self.redGiftIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.redGiftIcon];
        [self.redGiftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.left.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(68, 50));
        }];
        
        self.redGiftTitleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x1a1a1a) font:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.redGiftTitleLabel];
        [self.redGiftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            self.titleToTop  = make.top.mas_equalTo(14);
            make.left.equalTo(self.redGiftIcon.mas_right).offset(12);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        
        self.redGiftSubTitleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x867d6c) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.redGiftSubTitleLabel];
        [self.redGiftSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.redGiftTitleLabel.mas_bottom).offset(6);
            make.left.equalTo(self.redGiftIcon.mas_right).offset(12);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];

        self.redGiftTimeLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x867d6c) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.redGiftTimeLabel];
        [self.redGiftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.redGiftSubTitleLabel.mas_bottom).offset(6);
            make.left.equalTo(self.redGiftIcon.mas_right).offset(12);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];

        self.redGiftValueLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x1a1a1a) font:[UIFont systemFontOfSize:14]];
        self.redGiftValueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.redGiftValueLabel];
        [self.redGiftValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.redGiftTitleLabel.mas_centerY);
            make.right.mas_equalTo(-8);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];

    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPUARedGiftCell";
    DPUARedGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }

    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    self.redGiftIcon.image = dp_AccountImage(object.imageName);
    self.redGiftTitleLabel.text = object.title;
    self.redGiftSubTitleLabel.text = object.subTitle;
    self.redGiftTimeLabel.text = object.redGiftTime;
    self.redGiftValueLabel.text = object.value;
    [self setRedGiftState:object.giftState];
}
- (void)setRedGiftState:(DPRedGiftState)cellState{
    if (cellState == DPRedGiftUseableState) {
        NSString *valueStr = [NSString stringWithFormat:@"剩余%@元",self.object.value];
        NSMutableAttributedString *valueAtrribut = [[NSMutableAttributedString alloc]initWithString:valueStr];
        [valueAtrribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xde4f4b) range:NSMakeRange(valueStr.length-self.object.value.length-1, self.object.value.length)];
        self.redGiftValueLabel.attributedText = valueAtrribut;
    }else if(cellState == DPRedGiftComingState){
        self.redGiftTimeLabel.textColor = UIColorFromRGB(0xf17170);
        self.redGiftValueLabel.text = @"";
    }else if (cellState == DPRedGiftUnUsedState){
        self.titleToTop.mas_equalTo(24);
        self.redGiftTitleLabel.textColor = UIColorFromRGB(0x666666);
        self.redGiftTimeLabel.text = @"";
        self.redGiftValueLabel.textColor = UIColorFromRGB(0xf17170);
        self.redGiftValueLabel.text = self.object.subValue;
    }
}
@end
