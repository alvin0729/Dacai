//
//  DPUADWSuccessController.m
//  Jackpot
//
//  Created by mu on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPUADWSuccessController.h"

@interface DPUADWSuccessController()
@property (nonatomic, strong) UILabel *getMoneyLabel;//到账金额
@property (nonatomic, strong) UILabel *myMoneyLabel;//账户金额
@property (nonatomic, strong) UILabel *drawTitleLabel;//到账时间
@end

@implementation DPUADWSuccessController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"提现成功";

    self.successLabel.text = @"恭喜您，提现申请成功";
    
    //到账金额
    self.getMoneyLabel = [self createLabel];
    self.getMoneyLabel.attributedText = [self setLabelAttributeWithForwardSting:@"到账金额：" andBackString:self.reChangeResult.getCount.length>0?self.reChangeResult.getCount:@"00"];
    [self.view addSubview:self.getMoneyLabel];
    [self.getMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successLabel.mas_bottom).offset(17);
        make.left.equalTo(self.view.mas_centerX).offset(-75);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    //账户金额
    self.myMoneyLabel = [self createLabel];
    self.myMoneyLabel.attributedText = [self setLabelAttributeWithForwardSting:@"账户余额：" andBackString:self.reChangeResult.myMoney.length>0?self.reChangeResult.myMoney:@"00"];
    [self.view addSubview:self.myMoneyLabel];
    [self.myMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getMoneyLabel.mas_bottom).offset(13);
        make.left.equalTo(self.view.mas_centerX).offset(-75);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    //到账时间
    self.drawTitleLabel = [self createLabel];
    self.drawTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.drawTitleLabel.text = [NSString stringWithFormat:@"预计到账时间：%@",self.reChangeResult.getTime] ;//@"预计到账时间：猴年马月";
    self.drawTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.drawTitleLabel];
    [self.drawTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myMoneyLabel.mas_bottom).offset(13);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    //返回首页
    self.backBtn.dp_eventId = DPAnalyticsTypeDrawSuccess ;
    self.backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drawTitleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(44);
    }];
    
}
//返回首页
- (void)btnTapped{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabbar setSelectedViewController:tabbar.viewControllers.firstObject];
}

#pragma mark---------create label
- (NSMutableAttributedString *)setLabelAttributeWithForwardSting:(NSString *)forwardStr andBackString:(NSString *)backStr{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@元",forwardStr,backStr]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(forwardStr.length, backStr.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatBlackColor] range:NSMakeRange(text.length-1, 1)];
    return text;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = UIColorFromRGB(0xbaa588);
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}
@end
