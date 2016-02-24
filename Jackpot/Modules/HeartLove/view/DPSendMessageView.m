//
//  DPSendMessageView.m
//  Jackpot
//
//  Created by mu on 16/1/7.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPSendMessageView.h"
@interface DPSendMessageView ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *sendTF;
@property (nonatomic, strong)UIButton *sendBtn;
@end
@implementation DPSendMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dp_flatWhiteColor];
        [self addSubview:self.sendBtn];
        [self addSubview:self.sendTF];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(44);
        }];
        
        [self.sendTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.equalTo(self.sendBtn.mas_left);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
//sendBtn
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor dp_flatWhiteColor];
        _sendBtn.imageView.contentMode = UIViewContentModeCenter;
        [_sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setImage:dp_FeedbackResizeImage(@"messageFly.png") forState:UIControlStateNormal];
    }
    return _sendBtn;
}
- (void)sendMessage:(UIButton *)btn{
    if (self.sendTF.text.length==0) {
        [[DPToast makeText:@"你想说点什么。。。？"]show];
        return;
    }
    
    if (self.sendMessageBlock) {
        self.sendMessageBlock(self.sendTF.text);
    }
}
//sendTF
- (UITextField *)sendTF{
    if (!_sendTF) {
        _sendTF = [[UITextField alloc]init];
        _sendTF.delegate = self;
        _sendTF.placeholder = @"我想说点什么...";
        _sendTF.backgroundColor =[UIColor dp_flatWhiteColor];
    }
    return _sendTF;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    [self sendMessage:self.sendBtn];
    return YES;
}
@end
