//
//  DPReChangeSuccessController.m
//  Jackpot
//
//  Created by mu on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUASuccessController.h"

@implementation DPUASuccessController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.title = @"充值成功";
    

    UIBarButtonItem *backButtonItem =  [UIBarButtonItem dp_itemWithImage:[UIImage dp_imageWithColor:[UIColor clearColor]] target:self action:nil];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [self.navigationItem setHidesBackButton:YES];

    
    UIImageView *successIcon = [[UIImageView alloc]initWithImage:dp_AccountImage(@"UASuccessIcon.png")];
    [self.view addSubview:successIcon];
    self.successIcon = successIcon;
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"恭喜您，充值成功";
    titleLabel.textColor = [UIColor dp_flatGreenColor];
    [self.view addSubview:titleLabel];
    self.successLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successIcon.mas_bottom).offset(16);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColorFromRGB(0xdd5150);
    btn.layer.cornerRadius = 8;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"返回首页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.backBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(35);
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

@end
