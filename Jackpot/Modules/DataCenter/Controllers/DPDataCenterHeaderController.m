//
//  DPDataCenterHeaderController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterHeaderController.h"
#import <WebKit/WebKit.h>

@protocol IDPDataCenterHeaderController <NSObject>
@optional
- (BOOL)reverseHomeAndAway;    // 是否主客相反
@end

@interface DPDataCenterHeaderController () {
@protected
    UIView *_view;
    DPDataCenterHeaderViewModel *_viewModel;
}
@property (nonatomic, weak) id<IDPDataCenterHeaderController> interface;
/**
 *  主队图标
 */
@property (nonatomic, strong, readonly) UIImageView *homeLogoView;
/**
 *  客队图标
 */
@property (nonatomic, strong, readonly) UIImageView *awayLogoView;
/**
 *  主队名
 */
@property (nonatomic, strong, readonly) UILabel *homeTitleLabel;
/**
 *  客队名
 */
@property (nonatomic, strong, readonly) UILabel *awayTitleLabel;
/**
 *  时间
 */
@property (nonatomic, strong, readonly) UILabel *timeLabel;
/**
 *  比分
 */
@property (nonatomic, strong, readonly) UILabel *scoreLabel;
/**
 *  比赛状态
 */
@property (nonatomic, strong, readonly) UILabel *statusLabel;

@property (nonatomic, strong, readonly) UIView *webView;

- (void)setupProperty;
- (void)setupConstraints;
- (void)setupDataSource;
@end

@implementation DPDataCenterHeaderController
@synthesize view = _view;
@synthesize viewModel = _viewModel;

- (instancetype)init {
    if (self = [super init]) {
        NSAssert([self conformsToProtocol:@protocol(IDPDataCenterHeaderController)], @"failure...");

        _interface = (id<IDPDataCenterHeaderController>)self;

        // 初始化变量
        [self setupProperty];
        [self setupConstraints];
        [self setupDataSource];
    }
    return self;
}

- (void)setupProperty {
    // contentView
    _view = [[UIView alloc] init];
    _view.userInteractionEnabled = NO;
    _view.backgroundColor = [UIColor dp_flatWhiteColor];

    _homeLogoView = [[UIImageView alloc] init];
    _homeLogoView.contentMode = UIViewContentModeCenter;

    _awayLogoView = [[UIImageView alloc] init];
    _awayLogoView.contentMode = UIViewContentModeCenter;

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    _timeLabel.font = [UIFont dp_systemFontOfSize:11];
    _timeLabel.textAlignment = NSTextAlignmentCenter;

    _homeTitleLabel = [[UILabel alloc] init];
    _homeTitleLabel.backgroundColor = [UIColor clearColor];
    _homeTitleLabel.numberOfLines = 0;
    _homeTitleLabel.textAlignment = NSTextAlignmentCenter;

    _awayTitleLabel = [[UILabel alloc] init];
    _awayTitleLabel.backgroundColor = [UIColor clearColor];
    _awayTitleLabel.numberOfLines = 0;
    _awayTitleLabel.textAlignment = NSTextAlignmentCenter;

    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.backgroundColor = [UIColor clearColor];

    _statusLabel = [[UILabel alloc] init];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.numberOfLines = 0;

    if (IOS_VERSION_8_OR_ABOVE && /* DISABLES CODE */ (NO)) {
        WKWebView *webView = [[WKWebView alloc] init];
        webView.backgroundColor = [UIColor blueColor];
        _webView = webView;
    } else {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.backgroundColor = [UIColor blueColor];
        _webView = webView;
    }
    //    [self reloadWebView];
}

- (void)reloadWebView {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cs.betradar.com/ls/widgets/?/leida310/zh/Asia:Shanghai/page/widgets_lmts#matchId=6609685"]];

    if (IOS_VERSION_8_OR_ABOVE && /* DISABLES CODE */ (NO)) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView loadRequest:request];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView loadRequest:request];
    }
}

- (void)setupConstraints {
    UIImageView *homeLogoHoverView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"logo_hover.png")];
    UIImageView *awayLogoHoverView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"logo_hover.png")];
    [self.view addSubview:homeLogoHoverView];
    [self.view addSubview:awayLogoHoverView];
    [self.view addSubview:self.homeLogoView];
    [self.view addSubview:self.awayLogoView];
    [self.view addSubview:self.homeTitleLabel];
    [self.view addSubview:self.awayTitleLabel];
    [self.view addSubview:self.scoreLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.statusLabel];
    //    [self.view addSubview:self.webView];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.scoreLabel.mas_top);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-5);
        make.height.equalTo(@40);
        make.width.equalTo(@130);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scoreLabel.mas_bottom);
    }];

    // 布局主队, 客队相关控件

    if ([self.interface respondsToSelector:@selector(reverseHomeAndAway)] && [self.interface reverseHomeAndAway]) {
        // 主客相反, 篮球
        [self.homeLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-10);
            make.left.equalTo(self.scoreLabel.mas_right).offset(15);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        [self.awayLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-10);
            make.right.equalTo(self.scoreLabel.mas_left).offset(-15);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
    } else {
        // 足球布局
        [self.homeLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-10);
            make.right.equalTo(self.scoreLabel.mas_left).offset(-25);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        [self.awayLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-10);
            make.left.equalTo(self.scoreLabel.mas_right).offset(25);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
    }

    [self.homeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(homeLogoHoverView.mas_bottom);
        make.centerX.equalTo(self.homeLogoView);
    }];
    [self.awayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awayLogoHoverView.mas_bottom);
        make.centerX.equalTo(self.awayLogoView);
    }];

    // logo image
    [homeLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.homeLogoView);
    }];
    [awayLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.awayLogoView);
    }];

    // TODO:
    //    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.and.right.and.top.equalTo(self.view);
    //        make.height.equalTo(@100);
    //    }];
}

- (void)setupDataSource {
    UIImage *defaultImage = dp_SportLotteryImage(@"default.png");

    RAC(self.timeLabel, text) = RACObserve(self.viewModel, timeText);
    RAC(self.homeLogoView, image, defaultImage) = RACObserve(self.viewModel, homeIconImage);
    RAC(self.awayLogoView, image, defaultImage) = RACObserve(self.viewModel, awayIconImage);
    RAC(self.homeTitleLabel, attributedText) = RACObserve(self.viewModel, homeText);
    RAC(self.awayTitleLabel, attributedText) = RACObserve(self.viewModel, awayText);
    RAC(self.scoreLabel, attributedText) = RACObserve(self.viewModel, scoreText);
    RAC(self.statusLabel, attributedText) = RACObserve(self.viewModel, statusText);
}

@end

@interface DPFootballCenterHeaderController () <IDPDataCenterHeaderController>
@end

@implementation DPFootballCenterHeaderController
#pragma mark - Property (getter, setter)

- (DPDataCenterHeaderViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DPFootballCenterHeaderViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - IDPDataCenterHeaderController

@end

@interface DPBasketballCenterHeaderController () <IDPDataCenterHeaderController>
@end

@implementation DPBasketballCenterHeaderController

#pragma mark - Property (getter, setter)

- (DPDataCenterHeaderViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DPBasketballCenterHeaderViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - IDPDataCenterHeaderController

- (BOOL)reverseHomeAndAway {
    return YES;
}

@end
