//
//  DPBuyTicketCell.m
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBuyTicketCell.h"
#import "NSAttributedString+DDHTML.h"
@interface DPBuyTicketCell()
@property (nonatomic, strong)UILabel *buyDatelab;
@property (nonatomic, strong)UILabel *ticketKindlab;
@property (nonatomic, strong)UILabel *buyNumberlab;
@property (nonatomic, strong)UILabel *buyValuelab;
@property (nonatomic, strong)UILabel *awardValuelab;
@property (nonatomic, strong)UILabel *buyTimelab;
@property (nonatomic, strong)UIImageView *ticketStateImage;
@property (nonatomic, strong)UIImageView *rewardIcon;
@property (nonatomic, strong)UIView *leftLine;
@property (nonatomic, copy)NSString *buyDateStr;
@end

@implementation DPBuyTicketCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(35);
            make.right.mas_equalTo(35);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UIView *verLine = [[UIView alloc]init];
        verLine.backgroundColor = UIColorFromRGB(0xc7c8c3);
        [self.contentView addSubview:verLine];
        [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(35);
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
        
        self.rewardIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.rewardIcon];
        [self.rewardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(verLine.mas_centerY);
            make.centerX.equalTo(verLine.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        self.leftLine = [[UIView alloc]init];
        self.leftLine.backgroundColor = UIColorFromRGB(0xc7c8c3);
        [self.contentView addSubview:self.leftLine];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(0);
            make.right.equalTo(verLine.mas_left);
            make.top.mas_equalTo(0);
        }];
        
        self.buyDatelab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x8f8f8f) font:[UIFont systemFontOfSize:14]];
        self.buyDatelab.textAlignment = NSTextAlignmentRight;
        self.buyDatelab.font = [UIFont boldSystemFontOfSize:18];
           [self.contentView addSubview:self.buyDatelab];
        [self.buyDatelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(verLine.mas_left).offset(-8);
            make.left.mas_equalTo(0);
        }];
        
        self.ticketKindlab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
           [self.contentView addSubview:self.ticketKindlab];
        [self.ticketKindlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(verLine.mas_right).offset(8);
            make.height.mas_equalTo(15);
        }];
        
        self.buyNumberlab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:12]];
           [self.contentView addSubview:self.buyNumberlab];
        [self.buyNumberlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.ticketKindlab.mas_centerY);
            make.left.equalTo(self.ticketKindlab.mas_right).offset(8);
            make.height.mas_equalTo(12);
        }];
        
        self.buyTimelab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xb0b0b0) font:[UIFont systemFontOfSize:10]];
           [self.contentView addSubview:self.buyTimelab];
        [self.buyTimelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ticketKindlab.mas_bottom).offset(8);
            make.left.equalTo(self.ticketKindlab.mas_left);
            make.height.mas_equalTo(10);
        }];
        
        self.buyValuelab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xd14040) font:[UIFont systemFontOfSize:14]];
           [self.contentView addSubview:self.buyValuelab];
        self.buyValuelab.textAlignment = NSTextAlignmentRight;
        self.awardValuelab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:14]];
        self.awardValuelab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.awardValuelab];
        
        [self.buyValuelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        
        [self.awardValuelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(8);
            make.left.equalTo(self.buyValuelab.mas_right).offset(10);
        }];
        
        self.ticketStateImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.ticketStateImage];
        [self.ticketStateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.equalTo(self.awardValuelab.mas_left).offset(3);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        
        self.downSeparatorLine = [[UIView alloc]init];
        self.downSeparatorLine.backgroundColor = UIColorFromRGB(0xc7c8c3);
        [self.contentView addSubview:self.downSeparatorLine];
        [self.downSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(35);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPBuyTicketCell";
    DPBuyTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    if (object.buyDate.length) {
        NSMutableAttributedString *attributeDate = [[NSMutableAttributedString alloc]initWithString:object.buyDate];
        [attributeDate addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xadadab),NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(0, 4)];
        self.buyDatelab.attributedText = attributeDate;
    }
    NSMutableAttributedString *attributeValue = [[NSMutableAttributedString alloc]initWithString:object.buyValue];
    [attributeValue addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(object.buyValue.length-1, 1)];
    self.buyValuelab.attributedText = attributeValue;
    self.ticketKindlab.text = object.ticketKind;
    self.buyNumberlab.text = object.subTitle.length>0?[NSString stringWithFormat:@"%@期",object.subTitle]:@"";
    self.buyTimelab.text = object.buyTime;
    NSMutableAttributedString *attributeAwardValue = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringFromHTML:object.awardValue]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentRight;
    [attributeAwardValue addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, 1)];
    self.awardValuelab.attributedText = attributeAwardValue;//[NSAttributedString attributedStringFromHTML:object.awardValue];
    self.buyDatelab.hidden = object.isHiddle;
    self.leftLine.hidden = object.isHiddle;
    if (object.isAward) {
        self.rewardIcon.image = dp_AccountImage(@"UARewardClock.png");
    }else{
        self.rewardIcon.image = dp_AccountImage( @"UAUnRewardClock.png");
    }
    
    if (object.state == PartSucceed) {
        self.ticketStateImage.image = dp_AccountImage(@"UAOpening.png");
    }else{
        self.ticketStateImage.image = dp_AccountImage(@"");
    }
}


@end
