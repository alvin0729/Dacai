//
//  DPPayPasswordView.m
//  Jackpot
//
//  Created by mu on 15/10/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPPayPasswordView.h"
@interface DPPayPasswordView()

@end

@implementation DPPayPasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    CGRect passwordViewFrame = CGRectMake(0, 0, kScreenWidth, 190);
    self = [super initWithFrame:passwordViewFrame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        
        
        self.titleLabel = [UILabel dp_labelWithText: @"请输入大彩支付密码" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:17]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(17);
        }];
        

        
        self.passwordText = [[UITextField alloc]init];
        self.passwordText.borderStyle = UITextBorderStyleNone;
        self.passwordText.layer.borderColor = UIColorFromRGB(0xccccce).CGColor;
        self.passwordText.layer.borderWidth = 0.5;
        self.passwordText.layer.cornerRadius = 5;
        self.passwordText.placeholder = @"请输入大彩支付密码";
        self.passwordText.backgroundColor = [UIColor dp_flatWhiteColor];
        self.passwordText.textAlignment = NSTextAlignmentCenter;
        self.passwordText.secureTextEntry=YES;
        [self addSubview:self.passwordText];
        [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(44);
        }];
        
       
        UIButton *forgetBtn = [UIButton dp_buttonWithTitle:@"忘记密码" titleColor:UIColorFromRGB(0x0279fd) backgroundColor:nil font:[UIFont systemFontOfSize:14]];
        [forgetBtn addTarget:self action:@selector(forgetBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetBtn];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordText.mas_bottom).offset(10);
            make.right.equalTo(self.passwordText.mas_right);
            make.height.mas_equalTo(14);
        }];
        
        UIButton *sureBtn =[UIButton dp_buttonWithTitle:@"确认" titleColor:[UIColor  dp_flatWhiteColor] backgroundColor:UIColorFromRGB(0xdd524f) font:[UIFont systemFontOfSize:14]];
        sureBtn.backgroundColor=UIColorFromRGB(0xdd524f);
        sureBtn.layer.cornerRadius = 5;
        [sureBtn addTarget:self action:@selector(sureBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(forgetBtn.mas_bottom).offset(15);
            make.left.equalTo(self.passwordText);
            make.right.equalTo(self.passwordText);
            make.height.mas_equalTo(44);
        }];
        
        
    }
    return self;
}
- (void)forgetBtnTapped{
    if (self.forgetPasswordTapped) {
        self.forgetPasswordTapped();
    }
}
- (void)sureBtnTapped{
    if (self.surePasswordTapped) {
        self.surePasswordTapped(self.passwordText.text);
    }

}
@end
