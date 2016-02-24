//
//  DPImageTitleView.m
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPImageTitleBtnView.h"
@interface DPImageTitleBtnView()

@end
@implementation DPImageTitleBtnView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = [[UIImageView alloc]init];
        [self addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btn];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            self.iconToTopMagin = make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).offset(14);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(14);
        }];
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(24);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(40);
        }];
        
    }
    return self;
}


@end
