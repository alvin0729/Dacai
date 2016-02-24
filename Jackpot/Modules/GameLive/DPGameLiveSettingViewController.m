//
//  DPGameLiveSettingViewController.m
//  Jackpot
//
//  Created by wufan on 15/8/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveSettingViewController.h"

@interface DPGameLiveSettingViewController ()
@end

@implementation DPGameLiveSettingViewController

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"比赛推送";
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];

    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1];

    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = [UIColor colorWithRed:0.73 green:0.69 blue:0.62 alpha:1];
    descLabel.font = [UIFont dp_systemFontOfSize:11];
    descLabel.text = @"关闭夜间防打扰, 关注比赛的信息将会全天进行推送。";

    [self.view addSubview:contentView];
    [self.view addSubview:topLineView];
    [self.view addSubview:bottomLineView];
    [self.view addSubview:descLabel];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@55);
        make.top.equalTo(self.view).offset(15);
    }];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
    imageView.image = dp_AccountImage(@"notrouble.png");

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"夜间防打扰";
    titleLabel.font = [UIFont dp_systemFontOfSize:13];
    titleLabel.textColor = [UIColor dp_flatBlackColor];

    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"22:00~7:00开始的比赛不推送消息";
    subtitleLabel.font = [UIFont dp_systemFontOfSize:10];
    subtitleLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];

    UISwitch *liveSwitch = [[UISwitch alloc] init];
    liveSwitch.onTintColor = [UIColor dp_flatRedColor];

    [contentView addSubview:imageView];
    [contentView addSubview:titleLabel];
    [contentView addSubview:subtitleLabel];
    [contentView addSubview:liveSwitch];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.centerY.equalTo(contentView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.bottom.equalTo(imageView.mas_centerY).offset(-1);
    }];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.top.equalTo(imageView.mas_centerY).offset(1);
    }];
    [liveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-15);
    }];
    
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cs.betradar.com/ls/widgets/?/leida310/zh/Asia:Shanghai/page/widgets_lmts#matchId=6609685"]];
//    UIWebView *webView = [[UIWebView alloc] init];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
//    
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Layout

- (void)setupProperty {
}

- (void)setupViewConstraints {
}

#pragma mark - Public Interface

#pragma mark - Internal Interface

#pragma mark - Override

#pragma mark - User Interaction


#pragma mark - Delegate

#pragma mark - Properties (getter, setter)

@end
