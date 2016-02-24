//
//  DPNoDataView.m
//  Jackpot
//
//  Created by mu on 15/10/27.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPAcountNoDataView.h"


@implementation DPAcountNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UANoTicket.png")];
        [self addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.mas_equalTo(10);
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.iconImage.mas_bottom).offset(18);
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.layer.cornerRadius = 8;
        self.btn.backgroundColor = UIColorFromRGB(0xec5856);
        [self.btn setTitle:@"去投注" forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(41);
            make.top.equalTo(self.iconImage.mas_bottom).offset(73);
            make.left.mas_equalTo(32);
            make.right.mas_equalTo(-32);
        }];
        
        
        
    }
    return self;
}
- (void)btnTapped{
    if (self.btnTappedBlock) {
        self.btnTappedBlock();
    }
}
@end
