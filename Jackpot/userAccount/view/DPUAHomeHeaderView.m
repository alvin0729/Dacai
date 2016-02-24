//
//  DPUAHomeHeaderView.m
//  Jackpot
//
//  Created by mu on 15/8/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  注释由sxf提供

#import "DPUAHomeHeaderView.h"
@interface DPUAHomeHeaderView()
/**
 *  transparencyView：透明遮罩
 */
@property (nonatomic, strong) UIView *transparencyView;
/**
 *  lineView：分割线
 */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *fundsTitleLab;
@property (nonatomic, strong) UILabel *redGiftTitleLab;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *fundsIcon;
@property (nonatomic, strong) UIImageView *redGiftIcon;
@end

@implementation DPUAHomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"headerBg.jpg")];
        [self addSubview:self.bgImage];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        //头像
        self.iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAIconDefalt.png")];
        self.iconImage.layer.cornerRadius = 30;
        self.iconImage.layer.masksToBounds = YES;
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            make.centerX.equalTo(self.mas_centerX);
        }];
        //昵称
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"请登录";
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(12);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        
        self.transparencyView = [[UIView alloc]init];
        self.transparencyView.backgroundColor = [UIColor colorWithPatternImage:dp_GropSystemResizeImage(@"headerBottom.png")];
        [self addSubview:self.transparencyView];
        [self.transparencyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(56);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top).offset(8);
            make.width.mas_equalTo(1);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-8);
        }];
        
        //资金
        self.fundsValueLab = [self createLabelWithTitle:@"--"];
        [self addSubview:self.fundsValueLab];
        [self.fundsValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top).offset(10);
            make.left.mas_equalTo(60);
            self.fundsValueWidthConstraint = make.width.mas_equalTo(20);
            make.height.mas_equalTo(17);
        }];
        
        UILabel * fundsValueItem = [self createLabelWithTitle:@"元"];
        [self addSubview:fundsValueItem];
        [fundsValueItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top).offset(10);
            make.left.equalTo(self.fundsValueLab.mas_right);
            make.height.mas_equalTo(17);
        }];
        
        self.fundsTitleLab = [self createLabelWithTitle:@"资金"];
        self.fundsTitleLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.fundsTitleLab];
        [self.fundsTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fundsValueLab.mas_bottom).offset(4);
            make.left.mas_equalTo(60);
            make.right.equalTo(self.lineView.mas_left);
            make.height.mas_equalTo(12);
        }];

        //红包
        self.redGiftValueLab = [self createLabelWithTitle:@"--个"];
        [self addSubview:self.redGiftValueLab];
        [self.redGiftValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.transparencyView.mas_top).offset(10);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.lineView.mas_right).offset(60);
            make.height.mas_equalTo(17);
        }];
        
        self.redGiftTitleLab = [self createLabelWithTitle:@"红包"];
        self.redGiftTitleLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.redGiftTitleLab];
        [self.redGiftTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.redGiftValueLab.mas_bottom).offset(4);
            make.right.mas_equalTo(0);
            make.left.equalTo(self.lineView.mas_right).offset(60);
            make.height.mas_equalTo(12);;
        }];
      
        self.fundsIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UARedGiftIcon.png")];
        [self addSubview:self.fundsIcon];
        [self.fundsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.transparencyView.mas_centerY);
            make.left.equalTo(self.lineView.mas_left).offset(25);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.redGiftIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UAFunds.png")];
        [self addSubview:self.redGiftIcon];
        [self.redGiftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.transparencyView.mas_centerY);
            make.left.mas_equalTo(25);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UITapGestureRecognizer *iconTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTapped)];
        self.iconImage.userInteractionEnabled = YES;
        [self.iconImage addGestureRecognizer:iconTapGesture];
        
        UITapGestureRecognizer *transparencyViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transparencyViewTapped:)];
        self.transparencyView.userInteractionEnabled =YES;
        [self.transparencyView addGestureRecognizer:transparencyViewTapGesture];
    }
    return self;
}
- (UILabel *)createLabelWithTitle:(NSString *)title{
    UILabel *lab = [[UILabel alloc]init];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor dp_flatWhiteColor];
    lab.font = [UIFont boldSystemFontOfSize:17];
    return lab;
}
#pragma mark---------方法
//头像点击
- (void)iconTapped{
    if (self.iconTap) {
        self.iconTap();
    }
}
//资金明细
- (void)transparencyViewTapped:(UITapGestureRecognizer *)gesture{
    CGPoint touchPoint = [gesture locationInView:self.transparencyView];
    if (CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth*0.5, self.transparencyView.frame.size.height), touchPoint)) {
         self.fundTap();
    }else{
        self.redGiftTap();
    }
}
@end
