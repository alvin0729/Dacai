//
//  DPReChangeHeaderView.m
//  Jackpot
//
//  Created by mu on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPReChangeHeaderView.h"
@interface DPReChangeHeaderView()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *moneyArray;
@end

@implementation DPReChangeHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        self.moneyArray = @[@"50",@"100",@"200",@"500"];
         
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x676767);
        self.titleLabel.text = @"请输入充值金额:";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        
        self.reChangeText = [[UITextField alloc]init];
        self.reChangeText.borderStyle = UITextBorderStyleNone;
        self.reChangeText.layer.borderColor = colorWithRGB(192, 192, 192).CGColor;
        self.reChangeText.layer.borderWidth = 0.66;
        self.reChangeText.layer.cornerRadius = 5;
        self.reChangeText.font = [UIFont systemFontOfSize:18];
        self.reChangeText.textColor = UIColorFromRGB(0x333333);
        self.reChangeText.placeholder = @"请输入充值金额";
        self.reChangeText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 34)];
        self.reChangeText.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.reChangeText];
        [self.reChangeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(34);
        }];
        
        UILabel *item = [[UILabel alloc]init];
        item.text = @"元";
        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reChangeText.mas_top);
            make.bottom.equalTo(self.reChangeText.mas_bottom);
            make.right.equalTo(self.reChangeText.mas_right).offset(-5);
        }];

        
        CGFloat kBtnW = (kScreenWidth-65)/4;
        for (NSInteger i = 0; i<4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderColor = colorWithRGB(192, 192, 192).CGColor;
            btn.layer.borderWidth = 0.66;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = 100+i;
            NSString *title = self.moneyArray[i];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xd9524f)] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_flatWhiteColor]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(reChangeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reChangeText.mas_bottom).offset(14);
                make.left.mas_equalTo(16+i*(kBtnW+11));
                make.width.mas_equalTo(kBtnW);
                make.height.mas_equalTo(29);
            }];
            
            if (i==1) {
                [self reChangeBtnTapped:btn];
            }
        }
        
    }
    return self;
}
- (void)reChangeBtnTapped:(UIButton *)btn{
    for (NSInteger i = 0; i<4; i++) {
        if (btn.tag == 100+i) {
            if (btn.selected == NO) {
                btn.selected = !btn.selected;
                self.reChangeText.text = self.moneyArray[i];
                if (self.buttonClick) {
                    self.buttonClick(DPAnalyticsTypeRecharge50+i);
                }
             }
        }else{
            UIButton *btn = (UIButton *)[self viewWithTag:100+i];
            btn.selected = NO;
        }
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        btn.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    
}
@end
