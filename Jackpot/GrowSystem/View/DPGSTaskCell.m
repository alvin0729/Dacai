//
//  DPGSTaskCell.m
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSTaskCell.h"
@interface DPGSTaskCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIImageView *finishImage;
@property (nonatomic, strong) UIView *separatorLine;

@end

#define kLabelFont 16
#define kMargin 15
@implementation DPGSTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = colorWithRGB(240,246,249);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"taskDefault.png")];
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        self.titleLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:kLabelFont]];
        self.titleLabel.textColor = [UIColor dp_flatBlackColor];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.equalTo(self.iconImage.mas_right).offset(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];

        self.subTitleLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:self.subTitleLab];
        [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.height.mas_equalTo(12);
        }];
        
        self.moneyLab = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:11]];;
        self.moneyLab.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.moneyLab];
        [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTitleLab.mas_bottom).offset(5);
            make.left.equalTo(self.subTitleLab.mas_left);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
        
        self.arrowImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"arrow.png")];
        self.arrowImage.contentMode = UIViewContentModeCenter;
        self.arrowImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(12);
        }];

        self.getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.getBtn.backgroundColor = UIColorFromRGB(0xfd6b6b);
        self.getBtn.layer.cornerRadius = 5;
        self.getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.getBtn.userInteractionEnabled = NO;
        [self.getBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.getBtn];
        [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.mas_equalTo(-8);
            make.size.mas_equalTo(CGSizeMake(62, 30));
        }];

        self.finishImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"finishedIcon.png")];
        self.finishImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.finishImage];
        [self.finishImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        self.separatorLine = [[UIView alloc]init];
        self.separatorLine.backgroundColor = UIColorFromRGB(0xb9babc);
        [self.contentView addSubview:self.separatorLine];
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)setObject:(DPGSTaskObject *)object{
    _object = object;
    //图标
    [self.iconImage setImageWithURL:[NSURL URLWithString:_object.iconImageURL] placeholderImage:dp_GropSystemResizeImage(@"taskDefault.png")];
    //任务名
    NSInteger titleLength = _object.titleLabelStr.length;
    if (titleLength>0&&_object.type == DPTaskTypeUp) {
        NSMutableAttributedString * baseStr = [[NSMutableAttributedString alloc]initWithString:_object.titleLabelStr];
        [baseStr addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0xdc4e4c) range:NSMakeRange(titleLength-4,3)];
        [baseStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:12] range:NSMakeRange(titleLength-5,5)];
        self.titleLabel.attributedText = baseStr;

    }else{
        self.titleLabel.text = _object.titleLabelStr;
    }
    //进度
    self.subTitleLab.text = _object.subTitleLabStr;
    //奖励
    self.moneyLab.text = _object.moneyLabStr;
    //初始状态，可领取状态，完成状态
    if (_object.stata == DPTaskStateInitilizer) {
        self.finishImage.hidden = YES;
        self.getBtn.hidden = YES;
        self.arrowImage.hidden = NO;
    }else if (_object.stata == DPTaskStateCanGet) {
        self.finishImage.hidden = YES;
        self.getBtn.hidden = NO;
        self.arrowImage.hidden = YES;
    }else if (_object.stata == DPTaskStateFinished) {
        self.finishImage.hidden = NO;
        self.getBtn.hidden = YES;
        self.arrowImage.hidden = YES;
    }
    
    if (object.taskEvent.length<=0) {
        self.arrowImage.hidden = YES;
    }

}



@end
