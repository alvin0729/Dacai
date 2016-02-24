//
//  DPPrepogativeHeaderView.m
//  Jackpot
//
//  Created by mu on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPrepogativeHeaderView.h"
@interface DPPrepogativeHeaderView()
/**
 *  upBgImage
 */
@property (nonatomic, strong) UIImageView *upBgImage;
/**
 *  downBgView
 */
@property (nonatomic, strong) UIView *downBgView;
/**
 *  upBtn
 */
@property (nonatomic, strong) UIButton *upBtn;
@end

@implementation DPPrepogativeHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.upBgImage = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"upBg.png")];
        [self addSubview:self.upBgImage];
        [self.upBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(79);
        }];
        
        self.downBgView = [[UIView alloc]init];
        self.downBgView.backgroundColor = [UIColor dp_flatWhiteColor];
        [self addSubview:self.downBgView];
        [self.downBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self.upBgImage.mas_bottom);
        }];
        
        self.iconImage = [[UIImageView alloc]init];
        self.iconImage.layer.cornerRadius = 43;
        self.iconImage.layer.masksToBounds = YES;
        self.iconImage.layer.borderColor = UIColorFromRGB(0xe6dfd7).CGColor;
        self.iconImage.layer.borderWidth = 5;
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.width.mas_equalTo(86);
            make.height.mas_equalTo(86);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.levelIcon = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"level.png")];
        [self addSubview:self.levelIcon];
        [self.levelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).offset(-24);
            make.top.equalTo(self.iconImage.mas_top);
        }];
        
        self.levelLabel = [[UILabel alloc]init];
        self.levelLabel.textColor = [UIColor dp_flatRedColor];
        self.levelLabel.font = [UIFont systemFontOfSize:12];
        self.levelLabel.text = @"LV2";
        self.levelLabel.backgroundColor = [UIColor clearColor];
        self.levelLabel.userInteractionEnabled = YES;
        [self addSubview:self.levelLabel];
        [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.levelIcon.mas_centerX).offset(12);
            make.centerY.equalTo(self.levelIcon.mas_centerY);
            make.height.mas_equalTo(24);
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor whiteColor];
//        self.nameLabel.text = @"name";
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        [self.upBgImage addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.left.equalTo(self.mas_centerX).offset(-35);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
        self.growNumLabel = [[UILabel alloc]init];
        self.growNumLabel.textColor = UIColorFromRGB(0x909090);
        self.growNumLabel.text = @"10000\n成长值";
        self.growNumLabel.numberOfLines = 0;
        self.growNumLabel.backgroundColor = [UIColor clearColor];
        self.growNumLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.downBgView addSubview:self.growNumLabel];
        [self.growNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.mas_centerX).offset(-35);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        self.upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.upBtn.layer.cornerRadius = 3;
        self.upBtn.backgroundColor = [UIColor dp_flatRedColor];
        self.upBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.upBtn setTitle:@"特权说明" forState:UIControlStateNormal];
        [self.upBtn addTarget:self action:@selector(goToUp) forControlEvents:UIControlEventTouchUpInside];
        [self.downBgView addSubview:self.upBtn];
        [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.downBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 25));
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

#pragma mark---------function
- (void)goToUp{
    self.upBlock(nil);
}
@end
