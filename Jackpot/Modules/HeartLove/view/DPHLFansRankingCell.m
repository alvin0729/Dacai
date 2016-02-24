//
//  DPHLFansRankingCell.m
//  Jackpot
//
//  Created by mu on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLFansRankingCell.h"
#import "UIImageView+DPExtension.h"
@interface DPHLFansRankingCell()
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@end

@implementation DPHLFansRankingCell

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
            make.top.mas_equalTo(0);
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
        self.iconImage = [[UIImageView alloc]init];
        self.iconImage.backgroundColor = randomColor;
        self.iconImage.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        self.iconImage.layer.cornerRadius = 23;
        self.iconImage.layer.borderWidth = 0.5;
        self.iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(40);
            make.size.mas_equalTo(CGSizeMake(46, 46));
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
            make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
        }];

        self.rightBtn = [UIButton dp_buttonWithTitle:nil titleColor:nil image:dp_HeartLoveImage(@"HLFocus.png") font:nil];
        self.rightBtn.tag = self.indexPath.row;
        [self.rightBtn setImage:dp_HeartLoveImage(@"HLUnFocus.png") forState:UIControlStateSelected];
        self.rightBtn.userInteractionEnabled = NO;  
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
    self.indexPath = indexPath;
    static NSString *reuseId = @"DPHLFansRankingCell";
    DPHLFansRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
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
    [self.iconImage setImageWithURL:[NSURL URLWithString:_object.iconName] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    self.titleLabel.text = _object.title;
    self.subTitleLabel.text = _object.subTitle;
    self.rightBtn.selected = _object.isSelect;
    self.focusLabel.text = _object.isSelect?@"已关注":@"加关注";
    self.focusLabel.textColor = _object.isSelect?UIColorFromRGB(0x999999):[UIColor dp_flatRedColor];
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
