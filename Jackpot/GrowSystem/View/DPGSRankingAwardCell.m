//
//  DPGSRankingAwardCell.m
//  Jackpot
//
//  Created by mu on 15/11/13.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPGSRankingAwardCell.h"
@interface DPGSRankingAwardCell()
/**
 *  dateLabel:日期
 */
@property (nonatomic, strong)UILabel *dateLabel;
/**
 *  rankingLabel:排名
 */
@property (nonatomic, strong)UILabel *rankingLabel;
/**
 *  getBtn:领取按钮
 */
@property (nonatomic, strong)UIButton *getBtn;
/**
 *  awardIcon:奖励icon
 */
@property (nonatomic, strong)UIImageView *awardIcon;
@end


@implementation DPGSRankingAwardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        self.imageView.image = dp_GropSystemResizeImage(@"dateEdge.png");
        
        UILabel *dateLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xcfc192) font:[UIFont systemFontOfSize:12]];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = UIColorFromRGB(0x666666);
        self.textLabel.text = @"排名: ";
        
        UILabel *rankingLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:rankingLabel];
        [rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.textLabel.mas_right);
        }];
        self.rankingLabel = rankingLabel;
        
        UIButton *getBtn = [UIButton dp_buttonWithTitle:@"领取" titleColor:[UIColor whiteColor] backgroundColor:UIColorFromRGB(0xfd6b6b) font:[UIFont systemFontOfSize:14]];
        getBtn.layer.cornerRadius = 5;
        getBtn.userInteractionEnabled = NO;
        @weakify(self);
        [[getBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.getBtnBlock) {
                self.getBtnBlock();
            }
        }] ;
        [self.contentView addSubview:getBtn];
        self.getBtn = getBtn;
        [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(62.5, 26));
        }];
        
        UIImageView *awardIcon = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"UAAwardGetted.png")];
        [self.contentView addSubview:awardIcon];
        self.awardIcon = awardIcon;
        [awardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-16);
        }];
        
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPGSRankingAwardCell";
    DPGSRankingAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        if (indexPath.row ==  0) {
            UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            upLine.backgroundColor = ycolorWithRGB(0.81, 0.81, 0.83);
            [cell addSubview:upLine];
        }
    }
    
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    NSString *dateStr = @"";
    dateStr = [NSString stringWithFormat:@"%@日",object.subTitle];
    NSMutableAttributedString *dateAttri = [[NSMutableAttributedString alloc]initWithString:dateStr];
    [dateAttri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(dateStr.length-1, 1)];
    self.dateLabel.attributedText = dateAttri;
    
    self.rankingLabel.text = [object.title integerValue]<=100?object.title:@"百名开外";
    
    if ([object.title integerValue]<=10) {
        self.getBtn.hidden = object.isRead;
        self.awardIcon.hidden = !object.isRead;
    }else{
        self.getBtn.hidden = YES;
        self.awardIcon.hidden = YES;
    }

    
}
@end
