//
//  DPGameLiveBasketballCell.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveBasketballCell.h"
#import <OAStackView/OAStackView.h>

static const NSInteger kBasketballHomeTag = 1100;
static const NSInteger kBasketballAwayTag = 1200;
static const NSInteger kUnfoldLineHeight = 25;

@interface DPGameLiveBasketballUnfoldView ()
@property (nonatomic, strong) UILabel *homeNameLabel;
@property (nonatomic, strong) UILabel *awayNameLabel;
@property (nonatomic, strong) UILabel *totalScoreLabel;
@property (nonatomic, strong) UILabel *pointDiffLabel;

@property (nonatomic, strong) CALayer *horizontalLayer1;
@property (nonatomic, strong) CALayer *horizontalLayer2;
@property (nonatomic, strong) CALayer *horizontalLayer3;
@property (nonatomic, strong) CALayer *verticalLayer1;
@property (nonatomic, strong) CALayer *verticalLayer2;
@property (nonatomic, strong) CALayer *verticalLayer3;
@property (nonatomic, strong) CALayer *verticalLayer4;
@property (nonatomic, strong) CALayer *verticalLayer5;

@property (nonatomic, strong) OAStackView *lineStackView;
@property (nonatomic, strong) OAStackView *titleStackView;
@property (nonatomic, strong) OAStackView *homeStackView;
@property (nonatomic, strong) OAStackView *awayStackView;

@property (nonatomic, strong) NSArray *equalConstraints;
@property (nonatomic, strong) NSArray *widthConstraints;

@end

@implementation DPGameLiveBasketballUnfoldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.18 green:0.25 blue:0.29 alpha:1];
        
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    CGColorRef lineColor = [UIColor colorWithRed:0.14 green:0.2 blue:0.24 alpha:1].CGColor;
    
    _horizontalLayer1 = [CALayer layer];
    _horizontalLayer2 = [CALayer layer];
    _horizontalLayer3 = [CALayer layer];
    _verticalLayer1 = [CALayer layer];
    _verticalLayer2 = [CALayer layer];
    _verticalLayer3 = [CALayer layer];
    _verticalLayer4 = [CALayer layer];
    _verticalLayer5 = [CALayer layer];
    _horizontalLayer1.backgroundColor = _horizontalLayer2.backgroundColor = _horizontalLayer3.backgroundColor = lineColor;
    _verticalLayer1.backgroundColor = _verticalLayer2.backgroundColor = _verticalLayer3.backgroundColor = _verticalLayer4.backgroundColor = _verticalLayer5.backgroundColor = lineColor;
    
    _homeNameLabel = [self generateLabel];
    _awayNameLabel = [self generateLabel];
    _pointDiffLabel = [self generateLabel];
    _totalScoreLabel = [self generateLabel];
    _homeNameLabel.textColor = _awayNameLabel.textColor = [UIColor colorWithRed:0.71 green:0.73 blue:0.51 alpha:1];
    
    [self setupTitleStackView];
    [self setupScoreStackView];
    
    _lineStackView = [[OAStackView alloc] initWithArrangedSubviews:@[_titleStackView, _homeStackView, _awayStackView]];
    _lineStackView.distribution = OAStackViewDistributionFillEqually;
    _lineStackView.axis = UILayoutConstraintAxisVertical;
    _lineStackView.alignment = OAStackViewAlignmentFill;
}

- (UILabel *)generateLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor dp_flatWhiteColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setupTitleStackView {
    UILabel *(^titleLabel)(NSString *) = ^UILabel *(NSString *title) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.5 green:0.57 blue:0.63 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text = title;
        return label;
    };
    
    UIView *spaceView = [[UIView alloc] init];
    UILabel *label1 = titleLabel(@"第1节");
    UILabel *label2 = titleLabel(@"第2节");
    UILabel *label3 = titleLabel(@"第3节");
    UILabel *label4 = titleLabel(@"第4节");
    UILabel *label5 = titleLabel(@"加时");
    
    _titleStackView = [[OAStackView alloc] initWithArrangedSubviews:@[spaceView, label1, label2, label3, label4, label5]];
    _titleStackView.distribution = OAStackViewDistributionFill;
    _titleStackView.axis = UILayoutConstraintAxisHorizontal;
    _titleStackView.alignment = OAStackViewAlignmentCenter;
}

- (void)setupScoreStackView {
    UILabel *(^scoreLabel)() = ^UILabel *() {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont dp_systemFontOfSize:12];
        return label;
    };
    
    UILabel *homeScoreLabel1 = scoreLabel(); homeScoreLabel1.tag = kBasketballHomeTag + 1;
    UILabel *homeScoreLabel2 = scoreLabel(); homeScoreLabel2.tag = kBasketballHomeTag + 2;
    UILabel *homeScoreLabel3 = scoreLabel(); homeScoreLabel3.tag = kBasketballHomeTag + 3;
    UILabel *homeScoreLabel4 = scoreLabel(); homeScoreLabel4.tag = kBasketballHomeTag + 4;
    UILabel *homeScoreLabel5 = scoreLabel(); homeScoreLabel5.tag = kBasketballHomeTag + 5;
    
    UILabel *awayScoreLabel1 = scoreLabel(); awayScoreLabel1.tag = kBasketballAwayTag + 1;
    UILabel *awayScoreLabel2 = scoreLabel(); awayScoreLabel2.tag = kBasketballAwayTag + 2;
    UILabel *awayScoreLabel3 = scoreLabel(); awayScoreLabel3.tag = kBasketballAwayTag + 3;
    UILabel *awayScoreLabel4 = scoreLabel(); awayScoreLabel4.tag = kBasketballAwayTag + 4;
    UILabel *awayScoreLabel5 = scoreLabel(); awayScoreLabel5.tag = kBasketballAwayTag + 5;
    
    _homeStackView = [[OAStackView alloc] initWithArrangedSubviews:@[_homeNameLabel, homeScoreLabel1, homeScoreLabel2, homeScoreLabel3, homeScoreLabel4, homeScoreLabel5]];
    _homeStackView.distribution = OAStackViewDistributionFill;
    _homeStackView.axis = UILayoutConstraintAxisHorizontal;
    _homeStackView.alignment = OAStackViewAlignmentFill;
    
    _awayStackView = [[OAStackView alloc] initWithArrangedSubviews:@[_awayNameLabel, awayScoreLabel1, awayScoreLabel2, awayScoreLabel3, awayScoreLabel4, awayScoreLabel5]];
    _awayStackView.distribution = OAStackViewDistributionFill;
    _awayStackView.axis = UILayoutConstraintAxisHorizontal;
    _awayStackView.alignment = OAStackViewAlignmentFill;
}

- (void)setupConstraints {
    UILabel *pointDiffHolder = [self generateLabel];
    pointDiffHolder.text = @"分差:";
    
    UILabel *totalScoreHolder = [self generateLabel];
    totalScoreHolder.text = @"总分:";
    
    [self addSubview:pointDiffHolder];
    [self addSubview:self.pointDiffLabel];
    [self addSubview:totalScoreHolder];
    [self addSubview:self.totalScoreLabel];
    
    [self.pointDiffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kUnfoldLineHeight));
        make.right.equalTo(self.mas_centerX).offset(-10);
    }];
    [pointDiffHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kUnfoldLineHeight));
        make.right.equalTo(self.pointDiffLabel.mas_left).offset(-3);
    }];
    [totalScoreHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kUnfoldLineHeight));
        make.left.equalTo(self.mas_centerX).offset(10);
    }];
    [self.totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kUnfoldLineHeight));
        make.left.equalTo(totalScoreHolder.mas_right).offset(3);
    }];
    
    
    [self addSubview:self.lineStackView];
    [self.lineStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kUnfoldLineHeight);
        make.left.and.right.and.bottom.equalTo(self);
    }];
    
    [self.layer addSublayer:self.horizontalLayer1];
    [self.layer addSublayer:self.horizontalLayer2];
    [self.layer addSublayer:self.horizontalLayer3];
    [self.layer addSublayer:self.verticalLayer1];
    [self.layer addSublayer:self.verticalLayer2];
    [self.layer addSublayer:self.verticalLayer3];
    [self.layer addSublayer:self.verticalLayer4];
    [self.layer addSublayer:self.verticalLayer5];
    
    
    RACSignal *vSignal = [self.lineStackView rac_signalForSelector:@selector(layoutSubviews)];
    RACSignal *hSignal1 = [self.titleStackView rac_signalForSelector:@selector(layoutSubviews)];
    RACSignal *hSignal2 = [self.homeStackView rac_signalForSelector:@selector(layoutSubviews)];
    RACSignal *hSignal3 = [self.awayStackView rac_signalForSelector:@selector(layoutSubviews)];
    
    @weakify(self);
    [[RACSignal combineLatest:@[vSignal, hSignal1, hSignal2, hSignal3]] subscribeNext:^(id x) {
        @strongify(self);
        [self layoutLineViews];
    }];
    
    const static NSInteger kTitleWidth = 80;
    [[self.titleStackView.subviews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kTitleWidth));
    }];
    [[self.homeStackView.subviews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kTitleWidth));
    }];
    [[self.awayStackView.subviews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kTitleWidth));
    }];
    
    UIView *titleBaseView = [self.titleStackView.subviews objectAtIndex:1];
    UIView *homeBaseView = [self.homeStackView.subviews objectAtIndex:1];
    UIView *awayBaseView = [self.awayStackView.subviews objectAtIndex:1];
    for (int i = 2; i < 5; i++) {
        [[self.titleStackView.subviews objectAtIndex:i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(titleBaseView);
        }];
        [[self.homeStackView.subviews objectAtIndex:i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(homeBaseView);
        }];
        [[self.awayStackView.subviews objectAtIndex:i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(awayBaseView);
        }];
    }
    
    NSMutableArray *equalConstraints = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *widthConstraints = [NSMutableArray arrayWithCapacity:3];
    [[self.titleStackView.subviews lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *equal = make.width.equalTo(titleBaseView).priorityMedium();
        MASConstraint *width = make.width.equalTo(@0).priorityHigh();
        
        [equalConstraints addObject:equal];
        [widthConstraints addObject:width];
    }];
    [[self.homeStackView.subviews lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *equal = make.width.equalTo(homeBaseView).priorityMedium();
        MASConstraint *width = make.width.equalTo(@0).priorityHigh();
        
        [equalConstraints addObject:equal];
        [widthConstraints addObject:width];
    }];
    [[self.awayStackView.subviews lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *equal = make.width.equalTo(awayBaseView).priorityMedium();
        MASConstraint *width = make.width.equalTo(@0).priorityHigh();
        
        [equalConstraints addObject:equal];
        [widthConstraints addObject:width];
    }];
    self.equalConstraints = equalConstraints;
    self.widthConstraints = widthConstraints;
}

- (void)layoutLineViews {
    CGRect titleFrame = [self.titleStackView convertRect:self.titleStackView.bounds toView:self];
    CGRect homeFrame = [self.homeStackView convertRect:self.homeStackView.bounds toView:self];
    CGRect awayFrame = [self.awayStackView convertRect:self.awayStackView.bounds toView:self];
    
    self.horizontalLayer1.frame = CGRectMake(CGRectGetMinX(titleFrame),
                                             CGRectGetMinY(titleFrame),
                                             CGRectGetWidth(titleFrame), 1);
    self.horizontalLayer2.frame = CGRectMake(CGRectGetMinX(homeFrame),
                                             CGRectGetMinY(homeFrame),
                                             CGRectGetWidth(homeFrame), 1);
    self.horizontalLayer3.frame = CGRectMake(CGRectGetMinX(awayFrame),
                                             CGRectGetMinY(awayFrame),
                                             CGRectGetWidth(awayFrame), 1);
    
    CGFloat itemHeight = CGRectGetMaxY(awayFrame) - CGRectGetMinY(titleFrame);
    self.verticalLayer1.frame = CGRectMake(CGRectGetMaxX([self.titleStackView.subviews[0] frame]), CGRectGetMinY(titleFrame), 1, itemHeight);
    self.verticalLayer2.frame = CGRectMake(CGRectGetMaxX([self.titleStackView.subviews[1] frame]), CGRectGetMinY(titleFrame), 1, itemHeight);
    self.verticalLayer3.frame = CGRectMake(CGRectGetMaxX([self.titleStackView.subviews[2] frame]), CGRectGetMinY(titleFrame), 1, itemHeight);
    self.verticalLayer4.frame = CGRectMake(CGRectGetMaxX([self.titleStackView.subviews[3] frame]), CGRectGetMinY(titleFrame), 1, itemHeight);
    self.verticalLayer5.frame = CGRectMake(CGRectGetMaxX([self.titleStackView.subviews[4] frame]), CGRectGetMinY(titleFrame), 1, itemHeight);
    // 当没有加时时隐藏最后一根分割线
    self.verticalLayer5.hidden = CGRectGetWidth([self.titleStackView.subviews.lastObject frame]) == 0;
}

#pragma mark - Property (getter, setter)

- (void)setTotalScore:(NSInteger)totalScore {
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d", (int)totalScore];
}

- (void)setPointDiff:(NSInteger)pointDiff {
    self.pointDiffLabel.text = [NSString stringWithFormat:@"%d", (int)pointDiff];
}

- (void)setHomeName:(NSString *)homeName {
    self.homeNameLabel.text = [homeName stringByAppendingString:@"(主)"];
}

- (void)setAwayName:(NSString *)awayName {
    self.awayNameLabel.text = [awayName stringByAppendingString:@"(客)"];
}

- (void)setHomeScore:(NSArray *)homeScore {
    for (int i = 0; i < 5; i++) {
        UILabel *label = (UILabel *)[self.homeStackView viewWithTag:kBasketballHomeTag + i + 1];
        label.text = i >= homeScore.count ? @"-" : homeScore[i];
    }
}

- (void)setAwayScore:(NSArray *)awayScore {
    for (int i = 0; i < 5; i++) {
        UILabel *label = (UILabel *)[self.awayStackView viewWithTag:kBasketballAwayTag + i + 1];
        label.text = i >= awayScore.count ? @"-" : awayScore[i];
    }
}

- (void)setExtra:(BOOL)extra {
    for (MASConstraint *constraint in self.widthConstraints) {
        if (extra) {
            [constraint uninstall];
        } else {
            [constraint install];
        }
    }
    for (MASConstraint *constraint in self.equalConstraints) {
        if (extra) {
            [constraint install];
        } else {
            [constraint uninstall];
        }
    }
    [self.titleStackView.subviews.lastObject setHidden:!extra];
    [self.homeStackView.subviews.lastObject setHidden:!extra];
    [self.awayStackView.subviews.lastObject setHidden:!extra];
    
    // 重新布局
    [self.titleStackView setNeedsLayout];
    [self.homeStackView setNeedsLayout];
    [self.awayNameLabel setNeedsLayout];
    [self.lineStackView setNeedsLayout];
}

@end

@interface DPGameLiveBasketballCell ()
@end

@implementation DPGameLiveBasketballCell
@synthesize unfoldView = _unfoldView;

- (DPGameLiveBasketballUnfoldView *)unfoldView {
    if (_unfoldView == nil) {
        _unfoldView = [[DPGameLiveBasketballUnfoldView alloc] init];
    }
    return _unfoldView;
}

+ (CGFloat)infoViewHeight {
    return kDPGameLiveBasketballUnfoldViewHeight;
}

@end
