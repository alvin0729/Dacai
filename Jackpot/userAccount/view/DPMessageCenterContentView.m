//
//  DPMessageCenterContentView.m
//  Jackpot
//
//  Created by mu on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPMessageCenterContentView.h"

@implementation DPMessageCenterContentView
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items{
    self = [super initWithFrame:frame andItems:items];
    if (self) {
        self.indicatorView.backgroundColor = UIColorFromRGB(0xda5350);
        //btn
        self.btnsView.layer.borderColor = UIColorFromRGB(0xda5350).CGColor;
        self.btnsView.layer.borderWidth = 1;
        self.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.btnViewHeight.mas_equalTo(39);
      
        
        UIView *verline = [[UIView alloc]init];
        verline.backgroundColor = UIColorFromRGB(0xd7d6d1);
        [self.btnsView addSubview:verline];
        [verline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.equalTo(self.btnsView.mas_centerX);
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(-5);
        }];
        
        for (NSInteger i = 0; i < self.btnArray.count; i++) {
            UIButton *btn = (UIButton *)self.btnArray[i];
            if (i == 0) {
                [self btnTapped:btn];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xda5350) forState:UIControlStateSelected];
        }
    }
    return self;
}

- (void)setCurrentBtn:(UIButton *)currentBtn{
    [super setCurrentBtn:currentBtn];
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(currentBtn.mas_bottom);
        make.left.mas_equalTo(1+kScreenWidth*(currentBtn.tag-100)*0.5);
        make.width.mas_equalTo(kScreenWidth*0.5);
        make.height.mas_equalTo(3);
    }];
}
@end
