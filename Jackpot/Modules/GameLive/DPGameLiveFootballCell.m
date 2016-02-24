//
//  DPGameLiveFootballCell.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveFootballCell.h"
#import <OAStackView/OAStackView.h>
#import "DPImageLabel.h"
#import "DPGameLiveModels.h"

const static NSInteger kEventRowHeight = 30;

@interface DPGameLiveFootballEventView : UIView
@property (nonatomic, strong) UIImageView *timeBackgroundView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *homeBackgroundView;
@property (nonatomic, strong) UIImageView *awayBackgroundView;
@property (nonatomic, strong) DPImageLabel *homeLabel;
@property (nonatomic, strong) DPImageLabel *awayLabel;
@end

@implementation DPGameLiveFootballEventView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _timeBackgroundView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"足球时间.png")];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
    _timeLabel.font = [UIFont dp_systemFontOfSize:10];
    
    _homeBackgroundView = [[UIImageView alloc] init];
    _homeBackgroundView.image = dp_GameLiveResizeImage(@"足球主队.png");
    
    _awayBackgroundView = [[UIImageView alloc] init];
    _awayBackgroundView.image = dp_GameLiveResizeImage(@"足球客队.png");
    
    _homeLabel = [[DPImageLabel alloc] init];
    _homeLabel.imagePosition = DPImagePositionLeft;
    _homeLabel.spacing = 5;
    _homeLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.5 alpha:1];
    _homeLabel.font = [UIFont dp_systemFontOfSize:12];
    
    _awayLabel = [[DPImageLabel alloc] init];
    _awayLabel.imagePosition = DPImagePositionLeft;
    _awayLabel.spacing = 5;
    _awayLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.5 alpha:1];
    _awayLabel.font = [UIFont dp_systemFontOfSize:12];
}

- (void)setupConstraints {
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.textColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1];
    pointLabel.font = [UIFont dp_systemFontOfSize:10];
    pointLabel.text = @"'";
    
    [self addSubview:self.timeBackgroundView];
    [self addSubview:self.timeLabel];
    [self addSubview:pointLabel];
    [self addSubview:self.homeBackgroundView];
    [self addSubview:self.awayBackgroundView];
    [self addSubview:self.homeLabel];
    [self addSubview:self.awayLabel];
    
    [self.timeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(-1);
        make.top.equalTo(self.timeLabel);
    }];
    [self.homeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
        make.width.equalTo(@120);
    }];
    [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.homeBackgroundView).offset(10);
    }];
    [self.awayBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.width.equalTo(@120);
    }];
    [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.awayBackgroundView).offset(15);
    }];
}

- (void)setEvent:(BOOL)homeOrAway player:(NSString *)player time:(NSInteger)time type:(DPGameLiveFootballEventType)type {
    // 截取前六位
    const static NSInteger maxLength = 6;
    player = player.length > maxLength ? [player substringToIndex:maxLength] : player;
    
    UIImage *image = nil;
    switch (type) {
        case DPGameLiveFootballEventType_Own:
            image = dp_GameLiveImage(@"wulong.png");
            break;
        case DPGameLiveFootballEventType_Red:
            image = dp_GameLiveImage(@"hongpai.png");
            break;
        case DPGameLiveFootballEventType_Goals:
            image = dp_GameLiveImage(@"jinqu.png");
            break;
        case DPGameLiveFootballEventType_Y2Red:
            image = dp_GameLiveImage(@"honghuangpai.png");
            break;
        case DPGameLiveFootballEventType_Penalties:
            image = dp_GameLiveImage(@"dianqiu.png");
            break;
        case DPGameLiveFootballEventType_Yellow:
            image = dp_GameLiveImage(@"huangpai.png");
            break;
        default:
            break;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%d", (int)time];
    if (homeOrAway) {
        self.homeLabel.hidden = self.homeBackgroundView.hidden = NO;
        self.awayLabel.hidden = self.awayBackgroundView.hidden = YES;
        self.homeLabel.text = player;
        self.homeLabel.image = image;
    } else {
        self.homeLabel.hidden = self.homeBackgroundView.hidden = YES;
        self.awayLabel.hidden = self.awayBackgroundView.hidden = NO;
        self.awayLabel.text = player;
        self.awayLabel.image = image;
    }
}

@end

@interface DPGameLiveFootballUnfoldView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *middleViews;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CALayer *bottomLayer;
@property (nonatomic, strong) UIImageView *noEventView;
@property (nonatomic, strong) UILabel *noEventLabel;
@end

@implementation DPGameLiveFootballUnfoldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    DPImageLabel *(^generateImageLabel)(UIImage *, NSString *) = ^DPImageLabel *(UIImage *image, NSString *title) {
        DPImageLabel *label = [[DPImageLabel alloc] init];
        label.text = title;
        label.image = image;
        label.imagePosition = DPImagePositionLeft;
        label.font = [UIFont dp_systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.49 alpha:1];
        label.spacing = 2;
        return label;
    };
    DPImageLabel *imageLabel1 = generateImageLabel(dp_GameLiveImage(@"jinqu.png"), @"进球");
    DPImageLabel *imageLabel2 = generateImageLabel(dp_GameLiveImage(@"dianqiu.png"), @"点球");
    DPImageLabel *imageLabel3 = generateImageLabel(dp_GameLiveImage(@"wulong.png"), @"乌龙");
    DPImageLabel *imageLabel4 = generateImageLabel(dp_GameLiveImage(@"huangpai.png"), @"黄牌");
    DPImageLabel *imageLabel5 = generateImageLabel(dp_GameLiveImage(@"hongpai.png"), @"红牌");
    DPImageLabel *imageLabel6 = generateImageLabel(dp_GameLiveImage(@"honghuangpai.png"), @"两黄变红");
    
    _topView = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"主队               时间               客队";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = .5;
        label.layer.borderColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.76 alpha:1].CGColor;
        label.textColor = [UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label;
    });
    
    _middleViews = [NSMutableArray arrayWithCapacity:10];
    
    _bottomView = ({
        UIView *view = [[UIView alloc] init];
        [view addSubview:imageLabel1];
        [view addSubview:imageLabel2];
        [view addSubview:imageLabel3];
        [view addSubview:imageLabel4];
        [view addSubview:imageLabel5];
        [view addSubview:imageLabel6];
        [view.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
        }];
        [view.subviews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
        }];
        [view.subviews dp_enumeratePairsUsingBlock:^(UIView *view1, NSUInteger idx1, UIView *view2, NSUInteger idx2, BOOL *stop) {
            [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view1.mas_right).offset(5);
            }];
        }];
        [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
            }];
        }];
        view;
    });
    
    _bottomLayer = [CALayer layer];
    _bottomLayer.backgroundColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.76 alpha:1].CGColor;
    
    _noEventView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"noinfo.png")];
    _noEventView.contentMode = UIViewContentModeCenter;
    
    _noEventLabel = [[UILabel alloc] init];
    _noEventLabel.text = @"暂无比赛事件";
    _noEventLabel.textAlignment = NSTextAlignmentCenter;
    _noEventLabel.font = [UIFont dp_systemFontOfSize:10];
    _noEventLabel.textColor = [UIColor colorWithRed:0.73 green:0.69 blue:0.64 alpha:1];
}

- (void)setupConstraints {
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.noEventView];
    [self addSubview:self.noEventLabel];
    [self.layer addSublayer:self.bottomLayer];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@30);
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color = [UIColor colorWithRed:0.81 green:0.82 blue:0.8 alpha:1].CGColor;
    
    // 画出一根顶部的分割线
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), 0.5));
}

#pragma mark - Property (getter, setter)

- (void)setEvents:(NSArray *)events {
    if (_events == events) {
        return;
    }
    
    _events = events;
    
    for (int i = (int)self.middleViews.count; i < events.count; i++) {
        DPGameLiveFootballEventView *eventView = [[DPGameLiveFootballEventView alloc] init];
        [self.middleViews addObject:eventView];
        [self addSubview:eventView];
    }
    
    for (int i = 0; i < events.count; i++) {
        DPGameLiveFootballEventView *eventView = [self.middleViews objectAtIndex:i];
        DPGameLiveFootballEvent *event = [events objectAtIndex:i];
        [eventView setEvent:event.homeOrAway player:event.player time:event.time type:event.type];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.events.count == 0) {
        self.noEventView.hidden = NO;
        self.noEventLabel.hidden = NO;
        for (UIView *view in self.middleViews) {
            view.hidden = YES;
        }
        self.noEventView.frame = self.bounds;
        self.noEventLabel.frame = self.bounds;
        self.noEventLabel.frame = CGRectMake(0, 10, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 10);
        
        CGFloat offsetY = 10;
        CGFloat margin = 5;
        CGFloat topHeight = 25;
        self.topView.frame = CGRectMake(margin, offsetY, CGRectGetWidth(self.bounds) - 2 * margin, topHeight);
        offsetY = CGRectGetHeight(self.bounds) - 30;
        self.bottomView.frame = CGRectMake(CGRectGetMinX(self.bottomView.frame), offsetY, CGRectGetWidth(self.bottomView.frame), 30);
        self.bottomLayer.frame = CGRectMake(0, offsetY, CGRectGetWidth(self.bounds), 0.5);
    } else {
        self.topView.hidden = self.bottomView.hidden = self.bottomLayer.hidden = NO;
        self.noEventView.hidden = YES;
        self.noEventLabel.hidden = YES;
        [self.middleViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            obj.hidden = idx >= self.events.count;
        }];
        
        NSAssert(self.middleViews.count >= self.events.count, @"failure...");
        
        CGFloat offsetY = 10;
        CGFloat margin = 5;
        CGFloat topHeight = 25;
        self.topView.frame = CGRectMake(margin, offsetY, CGRectGetWidth(self.bounds) - 2 * margin, topHeight);
        offsetY += topHeight;
        for (int i = 0; i < self.events.count; i++) {
            UIView *view = self.middleViews[i];
            view.frame = CGRectMake(0, offsetY, CGRectGetWidth(self.bounds), kEventRowHeight);
            offsetY += kEventRowHeight;
        }
        self.bottomView.frame = CGRectMake(CGRectGetMinX(self.bottomView.frame), offsetY, CGRectGetWidth(self.bottomView.frame), 30);
        self.bottomLayer.frame = CGRectMake(0, offsetY, CGRectGetWidth(self.bounds), 0.5);
    }
}

@end

@implementation DPGameLiveFootballCell
@synthesize unfoldView = _unfoldView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
    }
    return self;
}

- (DPGameLiveFootballUnfoldView *)unfoldView {
    if (_unfoldView == nil) {
        _unfoldView = [[DPGameLiveFootballUnfoldView alloc] init];
        _unfoldView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.95 alpha:1];
    }
    return _unfoldView;
}

+ (CGFloat)unfoldHeightForRowCount:(NSInteger)rowCount {
    if (rowCount == 0) {
        return 160;
    } else {
        return 35 + kEventRowHeight * rowCount + 30;
    }
}

@end
