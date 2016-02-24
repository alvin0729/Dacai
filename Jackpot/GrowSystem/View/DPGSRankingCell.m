//
//  DPGSRankingCell.m
//  Jackpot
//
//  Created by mu on 15/7/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGSRankingCell.h"
@interface DPGSRankingCell()
/**
 *  bgView
 */
@property (nonatomic, strong)UIView *bgView;
/**
 *  progressBackView
 */
@property (nonatomic, strong)UIView *progressBackView;
/**
 *  progressView
 */
@property (nonatomic, strong)UIView *progressView;
/**
 *  number
 */
@property (nonatomic, strong)UILabel *numberLabel;
/**
 *  name
 */
@property (nonatomic, strong)UILabel *nameLabel;
/**
 *  intergral
 */
@property (nonatomic, strong)UILabel *intergralLabel;
/**
 *  rankingLabel
 */
@property (nonatomic, strong)UILabel *rankingLabel;

/**
 *  upImage
 */
@property (nonatomic, strong)UIImageView *upImage;

@end


@implementation DPGSRankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        self.userInteractionEnabled = NO;
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = colorWithRGB(207, 207, 207);
        [self.contentView addSubview:self.bgView];
        
        self.progressBackView = [[UIView alloc]init];
        self.progressBackView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.progressBackView];
        
        self.progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 2)];
        self.progressView.backgroundColor = UIColorFromRGB(0xdc4e4c);
        [self.progressBackView addSubview:self.progressView];
        
        self.numberLabel = [self creatLabel];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor lightGrayColor];
        self.numberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.layer.borderWidth = 2;
        self.numberLabel.layer.cornerRadius = 12.5;
        self.numberLabel.font = [UIFont boldSystemFontOfSize:10];
        [self.contentView addSubview:self.numberLabel];
    
        self.nameLabel = [self creatLabel];
        self.nameLabel.textColor = [UIColor dp_flatBlackColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.intergralLabel = [self creatLabel];
        self.intergralLabel.hidden = YES;
        self.intergralLabel.textColor = [UIColor lightGrayColor];
        self.intergralLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.intergralLabel];
        
        self.rankingLabel = [self creatLabel];
        self.rankingLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rankingLabel];
        
        self.upImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"downArrow.png")];
        self.upImage.backgroundColor = [UIColor clearColor];
        self.upImage.hidden = YES;
        [self.upImage setContentMode:UIViewContentModeCenter];
        [self.contentView addSubview:self.upImage];
        
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [self.progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.left.equalTo(self.numberLabel.mas_right).offset(8);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(2);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressBackView.mas_left);
            make.right.equalTo(self.progressBackView.mas_right);
            make.bottom.equalTo(self.progressBackView.mas_top).offset(-6);
        }];
        
        [self.intergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressBackView.mas_left);
            make.right.equalTo(self.upImage.mas_left);
            make.height.mas_equalTo(18);
            make.bottom.equalTo(self.progressBackView.mas_top).offset(-6);
        }];
    }
    return self;
}

- (UILabel *)creatLabel{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:18];
    return lab;
}

- (void)setObject:(DPGSRankingObject *)object{
    _object = object;
    
    self.numberLabel.text = _object.numberLabelStr;
    self.nameLabel.text = _object.nameLabelStr;
    self.intergralLabel.text =_object.intergralLabelStr;
    if (_object.trend == DPGSTrendTypeRise) {
        self.upImage.image = dp_GropSystemResizeImage(@"upArrow.png");
    }else if(_object.trend == DPGSTrendTypeDrop){
        self.upImage.image = dp_GropSystemResizeImage(@"downArrow.png");
    }else{
        self.upImage.image = dp_GropSystemResizeImage(@"");
    }
    self.rankingLabel.text = _object.rankingLabelStr;
    
    self.progressView.frame = CGRectMake(0, 0, 0, 2);
    [UIView animateWithDuration:1 animations:^{
        self.progressView.frame = CGRectMake(0, 0, self.object.width*(kScreenWidth-78), 2);
    } completion:^(BOOL finished) {
        self.intergralLabel.hidden= NO;
    }];
    
    [self reLayoutUI];
}

- (void)reLayoutUI {
    
    if ([self.object.nameLabelStr isEqualToString:[DPMemberManager sharedInstance].nickName]) {
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
        }];
        self.numberLabel.layer.borderColor = colorWithRGB(194, 168, 63).CGColor;
        self.numberLabel.backgroundColor =  colorWithRGB(249, 235, 3);
    }else{
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
        }];
        self.numberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.numberLabel.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    
 
    
    if (!self.object.isDayRanking) {
        
        [self.upImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.equalTo(self.progressBackView.mas_right);
            make.height.mas_equalTo(18);
            make.bottom.equalTo(self.progressBackView.mas_top).offset(-6);
        }];
        self.upImage.hidden =YES;
        
    }else{
        
        [self.upImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8);
            make.right.equalTo(self.progressBackView.mas_right);
            make.height.mas_equalTo(18);
            make.bottom.equalTo(self.progressBackView.mas_top).offset(-6);
        }];
        self.upImage.hidden =NO;
    }
}
@end












