//
//  DPLTNumberCell.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLTNumberCell.h"

//#define kContainerPadding       UIEdgeInsetsMake(2, 5, 2, 5)
//#define kDeleteButtonWidth      30
//#define kArrowViewWidth         10
#define kCellLineTagBase        300
#define kNumberContentWidth     240
#define kNumberContentFont      [UIFont dp_systemFontOfSize:14]

@interface DPLTNumberCell () {
    
}
@property (nonatomic, strong, readonly) UIView      *containerView;//白色背景
@property (nonatomic, strong, readonly) UILabel     *numberLabel;//投注内容
@property (nonatomic, strong, readonly) UILabel     *descLabel;//投注描述 （单式1注2元）
@property (nonatomic, strong, readonly) UIButton    *deleteBtn;//删除按钮
@property (nonatomic, strong, readonly) UIImageView *rightArrow;//跳转标示符

- (void)buildLayout;
@end

@implementation DPLTNumberCell
@synthesize containerView = _containerView;
@synthesize numberLabel = _numberLabel;
@synthesize descLabel = _descLabel;
@synthesize deleteBtn = _deleteBtn;
@synthesize rightArrow = _rightArrow;

//获取当前投注内容的高度
+ (NSInteger)heightForNumberContent:(NSString *)string {
    CGSize size = [NSString dpsizeWithSting:string andFont:kNumberContentFont andMaxSize:CGSizeMake(kNumberContentWidth, FLT_MAX)];
    return ceil(size.height + 48);
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildLayout];
    }
    return self;
}
//点击时的背景变化
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if( highlighted == YES ){
        self.containerView.backgroundColor = UIColorFromRGB(0xefefe2);
    }else{
        self.containerView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
}
//- (void)dp_resetHighlighted:(BOOL)highlighted
//{
//    if( highlighted == YES ){
//        self.containerView.backgroundColor = UIColorFromRGB(0xefefe2);
//    }else{
//        self.containerView.backgroundColor = [UIColor dp_flatWhiteColor];
//    }
//}
- (void)buildLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.descLabel];
    [self.containerView addSubview:self.numberLabel];
    [self.containerView addSubview:self.deleteBtn];
    [self.containerView addSubview:self.rightArrow];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        make.left.equalTo(self.containerView);
        make.width.equalTo(@49.5);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(10);
//        make.bottom.equalTo(self.descLabel.mas_top);
        make.left.equalTo(self.deleteBtn.mas_right);
        make.width.equalTo(@(kNumberContentWidth));
//        make.right.equalTo(self.containerView).offset(-12);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.height.equalTo(@13.5);
        make.right.equalTo(self.containerView).offset(-16);
        make.width.equalTo(@9);

    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView).offset(-10);
//        make.height.equalTo(@20);
        make.left.equalTo(self.numberLabel);
        make.right.equalTo(self.numberLabel);
    }];
    UILabel *bottomTopLine=[[UILabel alloc]init];
    UILabel *bottomLine=[[UILabel alloc]init];

    
    bottomTopLine.tag = kCellLineTagBase + 0;
    bottomLine.tag = kCellLineTagBase + 1;
    
    bottomTopLine.backgroundColor=UIColorFromRGB(0xb4b5b6);
    bottomLine.backgroundColor=UIColorFromRGB(0xb4b5b6);

    [self.containerView addSubview:bottomTopLine];
    [self.containerView addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
    }];
    [bottomTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
    }];
   

}
//数据源刷新
- (void)styleForModel:(id<DPLTNumberCellDataSource>)model {
    self.numberLabel.attributedText = model.numberString;
    self.descLabel.text = model.descString;
}
#pragma mark - pvt_singleClick
//删除当前视图
- (void)pvt_deleteBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onBtnDeleteSingleCell:)]) {
        [self.delegate onBtnDeleteSingleCell:self];
    }
}

#pragma mark - getter
//白色背景
- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.userInteractionEnabled = YES;
        _containerView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _containerView;
}
//投注内容
- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.numberOfLines = 0;
        _numberLabel.preferredMaxLayoutWidth = kNumberContentWidth;
        _numberLabel.font = kNumberContentFont;
        _numberLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_numberLabel setTextAlignment:NSTextAlignmentLeft];

    }
    return _numberLabel;
}
//删除按钮
- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:dp_DigitLotteryImage(@"deleteTransfer001_03.png") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(pvt_deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 17.5, 0, 0)];
    
    }
    return _deleteBtn;
}
//投注描述 （单式1注2元)
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kNumberContentFont;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.textColor=[UIColor colorWithRed:134.0/255 green:125.0/255 blue:110.0/255 alpha:1];
        _descLabel.backgroundColor = [UIColor clearColor];
    }
    return _descLabel;
}
//跳转标示符
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc]initWithImage:dp_DigitLotteryImage(@"right_arrow_transfer.png")];
        _rightArrow.backgroundColor=[UIColor clearColor];
    }
    return _rightArrow;
}
@end

 