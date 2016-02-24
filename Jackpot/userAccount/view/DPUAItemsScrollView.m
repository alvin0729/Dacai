//
//  DPUAItemsScrollView.m
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUAItemsScrollView.h"

@interface DPUAItemsScrollView()

@end

@implementation DPUAItemsScrollView
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items{
    self = [super initWithFrame:frame andItems:items];
    if (self) {
        self.indicatorView.backgroundColor = UIColorFromRGB(0xda5350);
        //btn
        self.btnsView.layer.borderColor = UIColorFromRGB(0xc7c7c5).CGColor;
        self.btnsView.layer.borderWidth = 0.66;
        self.btnsView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.btnViewHeight.mas_equalTo(44);
        
        for (NSInteger i = 0; i < self.btnArray.count; i++) {
            UIButton *btn = (UIButton *)self.btnArray[i];
            if (i == 0) {
                [self btnTapped:btn];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:UIColorFromRGB(0x876e5a) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xda5350) forState:UIControlStateSelected];
        }
    }
    return self;
}

@end
