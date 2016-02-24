//
//  DPHLMakingMoneyRankingCell.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLMakingMoneyRankingCell.h"

@interface DPHLMakingMoneyRankingCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@end

@implementation DPHLMakingMoneyRankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *upLine = [[UIView alloc]init];
        upLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:upLine];
        self.upLine = upLine;
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *downLine = [[UIView alloc]init];
        downLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.contentView addSubview:downLine];
        self.downLine = downLine;
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIImageView *rangkingBgImage = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(self.indexPath.row<3?@"HLRankingfront.png":@"HLRankingBack.png")];
        [self.contentView addSubview:rangkingBgImage];
        self.rankingBgImage = rangkingBgImage;
        [rangkingBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-0.5);
            make.left.mas_equalTo(0);
        }];
        
        UILabel *rankingLabel = [UILabel dp_labelWithText:[NSString stringWithFormat:@"%zd",self.indexPath.row] backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:10]];
        rankingLabel.textAlignment = NSTextAlignmentRight;
        self.rankingLabel = rankingLabel;
        [rangkingBgImage addSubview:rankingLabel];
        [rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.equalTo(rangkingBgImage.mas_centerX).offset(-2);
            make.bottom.equalTo(rangkingBgImage.mas_centerY);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iconImage = [[UIImageView alloc]initWithImage:dp_HeartLoveImage(@"HLRoundRect.png")];
        self.iconImage.layer.cornerRadius = 25;
        self.iconImage.layer.masksToBounds = YES;
        self.iconImage.alpha = self.indexPath.row<3?1:0.33;
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(40);
        }];
        
        self.rateLabel = [UILabel dp_labelWithText:@"--\n近七天盈利" backgroundColor:[UIColor clearColor] textColor:[UIColor dp_flatWhiteColor] font:[UIFont systemFontOfSize:10]];
        self.rateLabel.textAlignment = NSTextAlignmentCenter;
   
        [self.iconImage addSubview:self.rateLabel];
        [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.iconImage);
        }];
        
        
        self.titleLabel = [UILabel dp_labelWithText:@"---" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_top).offset(4);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
        }];
        
        self.subTitleLabel = [UILabel dp_labelWithText:@"新增粉丝：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
        }];
        
        self.rightBtn = [UIButton dp_buttonWithTitle:nil titleColor:nil image:dp_HeartLoveImage(@"HLFocus.png") font:nil];
        self.rightBtn.tag = self.indexPath.row;
        [self.rightBtn setImage:dp_HeartLoveImage(@"HLUnFocus.png") forState:UIControlStateSelected];
        self.rightBtn.userInteractionEnabled = NO;  
//        @weakify(self);
//        [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
//            @strongify(self);
//            if (self.focusBtnTapped) {
//                self.focusBtnTapped(self.rightBtn);
//            }
//        }];
        [self.contentView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-7);
            make.right.mas_equalTo(-16);
        }];
        
        self.focusLabel = [UILabel dp_labelWithText:@"已关注" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.focusLabel];
        [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightBtn.mas_bottom).offset(2);
            make.centerX.equalTo(self.rightBtn.mas_centerX);
        }];
        
        UITapGestureRecognizer *focusGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGestureTapped:)];
        [self.contentView addGestureRecognizer:focusGesture];
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLMakingMoneyRankingCell";
    DPHLMakingMoneyRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    self.indexPath = indexPath;
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    self.upLine.hidden = indexPath.row!=0;
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    NSMutableAttributedString *rateSte = [[NSMutableAttributedString alloc]initWithString:_object.isWeek?[NSString stringWithFormat:@"%@\n近7天盈利",_object.value]:[NSString stringWithFormat:@"%@\n近30天盈利",_object.value]];
    [rateSte addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0,_object.value.length)];
    self.rateLabel.attributedText = rateSte;
    self.focusLabel.text = _object.isSelect?@"已关注":@"未关注";
    self.focusLabel.textColor = _object.isSelect?UIColorFromRGB(0x999999):[UIColor dp_flatRedColor];
    self.titleLabel.text = _object.title;
    self.subTitleLabel.text = [NSString stringWithFormat:@"新增粉丝：%@",_object.subTitle];
    self.rightBtn.selected = _object.isSelect;
}
#pragma mark---------function
- (void)focusGestureTapped:(UITapGestureRecognizer *)gesture{
    CGPoint point  = [gesture locationInView:self.contentView];
    if (point.x>self.rightBtn.frame.origin.x) {
        if (self.focusBtnTapped) {
            self.focusBtnTapped(self.object);
        }
    }else{
        if (self.cellTapped) {
            self.cellTapped(self.indexPath);
        }
    }
}
@end
