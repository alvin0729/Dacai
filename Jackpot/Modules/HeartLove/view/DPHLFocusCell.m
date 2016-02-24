//
//  DPHLFocusCell.m
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLFocusCell.h"
#import "DPHLHeartLoveMark.h"
#import "UIImageView+DPExtension.h"

@interface DPHLFocusCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *markTitlesArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation DPHLFocusCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAIconDefalt.png")];
        self.iconImage.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
        self.iconImage.layer.cornerRadius = 23;
        self.iconImage.layer.borderWidth = 0.5;
        self.iconImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(16);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(46, 46));
        }];
        
        self.titleLabel = [UILabel dp_labelWithText:@"---" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
        }];
        
        self.subTitleLabel = [UILabel dp_labelWithText:@"粉丝：--" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.left.equalTo(self.iconImage.mas_right).offset(12);
        }];
        
        for (NSInteger i = 0; i < self.markTitlesArray.count; i++) {
            DPHLHeartLoveMark *markView = [[DPHLHeartLoveMark alloc]init];
            markView.markImage.image = dp_HeartLoveImage(@"HLSuperBg.png");
            markView.markTitleLable.text = self.markTitlesArray[i];
            markView.markTitleLable.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:markView];
            [markView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.subTitleLabel.mas_bottom).offset(2);
                make.left.equalTo(self.subTitleLabel.mas_left).offset(36*i);
                make.size.mas_equalTo(CGSizeMake(32, 15));
            }];
        }
        
        self.rightBtn = [UIButton dp_buttonWithTitle:nil titleColor:nil image:dp_HeartLoveImage(@"HLFocus.png") font:nil];
        [self.rightBtn setImage:dp_HeartLoveImage(@"HLUnFocus.png") forState:UIControlStateSelected];
        self.rightBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-6.5);
            make.right.mas_equalTo(-16);
        }];
        
        self.focusLabel = [UILabel dp_labelWithText:@"已关注" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:11]];
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
- (instancetype)initWithTableView:(UITableView *)tableView andMarkTitles:(NSMutableArray *)markTitlesArray atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLFocusCell";
    DPHLFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        self.markTitlesArray = markTitlesArray;
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    self.indexPath = indexPath;
    return cell;
}
#pragma mark---------data
- (void)setObject:(DPHLObject *)object{
    _object = object;
    [self.iconImage dp_setImageWithURL:_object.iconName andPlaceholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    self.titleLabel.text =_object.title;
    self.subTitleLabel.text = [NSString stringWithFormat:@"粉丝：%@",_object.subTitle];
    self.rightBtn.selected = _object.isSelect;
    self.focusLabel.text = self.rightBtn.selected?@"已关注":@"加关注";
    self.focusLabel.textColor = self.rightBtn.selected?UIColorFromRGB(0x999999):[UIColor dp_flatRedColor];
}

#pragma mark---------function
- (void)focusGestureTapped:(UITapGestureRecognizer *)gesture{
    CGPoint point  = [gesture locationInView:self.contentView];
    if (point.x>self.rightBtn.frame.origin.x) {
        self.object.isSelect = !self.object.isSelect;
        self.rightBtn.selected = !self.rightBtn.selected;
        self.focusLabel.text = self.rightBtn.selected?@"已关注":@"加关注";
        self.focusLabel.textColor = self.rightBtn.selected?UIColorFromRGB(0x999999):[UIColor dp_flatRedColor];
        NSInteger fansNum = self.rightBtn.selected?[self.object.subTitle integerValue]+1:[self.object.subTitle integerValue]-1;
        self.object.subTitle = [NSString stringWithFormat:@"%zd",fansNum];
        self.subTitleLabel.text = [NSString stringWithFormat:@"粉丝：%zd",fansNum];
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
