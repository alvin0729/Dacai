//
//  DPGameLiveViews.m
//  Jackpot
//
//  Created by wufan on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveViews.h"
#import <OAStackView/OAStackView.h>

@interface DPGameLiveTabBarItemView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, weak) DPGameLiveTabBarItem *item;
@end


@implementation DPGameLiveTabBarItemView

- (instancetype)initWithItem:(DPGameLiveTabBarItem *)item {
    if (self = [super init]) {
        _item = item;
        
        [self setupProperty];
        [self setupConstraints];
        
        RAC(self.titleLabel, text) = RACObserve(self.item, title);
        @weakify(self);
        [RACObserve(self.item, badgeValue) subscribeNext:^(NSString *title) {
            @strongify(self);
            self.badgeLabel.text = title;
            self.badgeLabel.hidden = title.length == 0 || title.integerValue == 0;
        }];
    }
    return self;
}

- (void)setupProperty {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.44 blue:0.4 alpha:1];
    _titleLabel.highlightedTextColor = [UIColor colorWithRed:0.9 green:0.24 blue:0.22 alpha:1];
    
    _badgeLabel = [[UILabel alloc] init];
    _badgeLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.24 blue:0.22 alpha:1];
    _badgeLabel.font = [UIFont systemFontOfSize:8];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.layer.cornerRadius = 6;
    _badgeLabel.layer.masksToBounds = YES;
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupConstraints {
    [self addSubview:self.titleLabel];
    [self addSubview:self.badgeLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel.mas_top);
        make.height.equalTo(@12);
        make.width.equalTo(@16);
    }];
}

@end

@interface DPGameLiveTabBarItem ()
@property (nonatomic, weak) DPGameLiveTabBarItemView *itemView;
@end

@implementation DPGameLiveTabBarItem

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title badgeValue:nil];
}

- (instancetype)initWithTitle:(NSString *)title badgeValue:(NSString *)badgeValue {
    if (self = [super init]) {
        _title = title;
        _badgeValue = badgeValue;
    }
    return self;
}

@end

@interface DPGameLiveTabBar () {
@private
    RACSubject *_rac_signalForSelectedItem;
}
@property (nonatomic, strong) OAStackView *stackView;
@property (nonatomic, strong) NSArray *tabBarItemViews;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DPGameLiveTabBar
@synthesize selectedItem = _selectedItem;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped:)]];
    }
    return self;
}

- (void)viewDidTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.stackView];
    for (int i = 0; i < self.tabBarItemViews.count; i++) {
        DPGameLiveTabBarItemView *view = self.tabBarItemViews[i];
        if (CGRectContainsPoint(view.frame, point)) {
            [self setSelectedItem:view.item animation:YES execute:YES];
            break;
        }
    }
}

- (void)makeLineContraintWithView:(UIView *)view {
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.right.equalTo(view).offset(-20);
        make.height.equalTo(@3);
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

#pragma mark - getter, setter

- (RACSignal *)rac_signalForSelectedItem {
    if (!_rac_signalForSelectedItem) {
        _rac_signalForSelectedItem = [RACSubject subject];
    }
    return _rac_signalForSelectedItem;
}

- (void)setSelectedItem:(DPGameLiveTabBarItem * _Nullable)selectedItem animation:(BOOL)animation execute:(BOOL)execute {
    if ([self.items containsObject:selectedItem]) {
        NSInteger selectedIndex = [self.items indexOfObject:selectedItem];
        [self willChangeValueForKey:@"selectedIndex"];
        _selectedIndex = selectedIndex;
        [self didChangeValueForKey:@"selectedIndex"];
        _selectedItem = selectedItem;
        
        [_tabBarItemViews enumerateObjectsUsingBlock:^(DPGameLiveTabBarItemView *itemView, NSUInteger idx, BOOL *stop) {
            itemView.titleLabel.highlighted = idx == selectedIndex;
        }];
        
        // 调整指示条
        [self makeLineContraintWithView:self.tabBarItemViews[selectedIndex]];
        [self setNeedsLayout];
        
        if (animation) {
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self layoutIfNeeded];
                             }
                             completion:nil];
        }
        
        // 执行命令
        if (execute && _rac_signalForSelectedItem) {
            [_rac_signalForSelectedItem sendNext:selectedItem];
        }
    }
}

- (void)setSelectedItem:(DPGameLiveTabBarItem *)selectedItem {
    [self setSelectedItem:selectedItem animation:YES execute:NO];
}

- (DPGameLiveTabBarItem *)selectedItem {
    if (_selectedIndex < _items.count) {
        return _items[_selectedIndex];
    }
    return nil;
}

- (void)setItems:(NSArray *)items {
    NSAssert(items.count > 0, @"Can not be empty.");
    
    if ([_items isEqualToArray:items]) {
        return;
    }
    
    _items = items.copy;
    
    [self.stackView removeFromSuperview];
    if (self.lineView.superview == nil) {
        [self addSubview:self.lineView];
    }
    
    // 重新生成item, 并布局
    NSMutableArray *tabBarItemViews = [NSMutableArray arrayWithCapacity:items.count];
    for (DPGameLiveTabBarItem *item in items) {
        DPGameLiveTabBarItemView *itemView = [[DPGameLiveTabBarItemView alloc] initWithItem:item];
        itemView.backgroundColor = [UIColor clearColor];
        [tabBarItemViews addObject:itemView];
    }
    OAStackView *stackView = [[OAStackView alloc] initWithArrangedSubviews:tabBarItemViews];
    stackView.alignment = OAStackViewAlignmentFill;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 0;
    stackView.distribution = OAStackViewDistributionFillEqually;
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //
    _stackView = stackView;
    _tabBarItemViews = tabBarItemViews;
    
    // 选中第一个
    _selectedItem = [items firstObject];
    [self willChangeValueForKey:@"selectedIndex"];
    _selectedIndex = 0;
    [self didChangeValueForKey:@"selectedIndex"];
    
    [self makeLineContraintWithView:[tabBarItemViews firstObject]];
    [self setNeedsLayout];
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.24 blue:0.22 alpha:1];
    }
    return _lineView;
}

#pragma mark - draw function

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color = [UIColor colorWithRed:0.83 green:0.84 blue:0.79 alpha:1].CGColor;
    
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(rect) - 0.5, CGRectGetWidth(rect), 0.5));
}

@end


@interface DPGameLiveHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation DPGameLiveHeaderView

- (instancetype)init {
    if (self = [super init]) {
//        _unfold = YES;
        
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.96 alpha:1];
        
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithRed:0.47 green:0.46 blue:0.45 alpha:1];
    _titleLabel.font = [UIFont dp_systemFontOfSize:13];
    
    _arrowView = [[UIImageView alloc] initWithImage:dp_CommonImage(@"比分直播向下.png")
                                   highlightedImage:dp_CommonImage(@"比分直播向上.png")];
}

- (void)setupConstraints {
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef color = [UIColor colorWithRed:0.81 green:0.82 blue:0.8 alpha:1].CGColor;
    
    CGContextSetFillColorWithColor(context, color);
    
    CGContextFillRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), 0.5));
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(rect) - 0.5, CGRectGetWidth(rect), 0.5));
}

#pragma mark - getter, setter
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setUnfold:(BOOL)unfold {
    self.arrowView.highlighted = unfold;
}

- (BOOL)unfold {
    return self.arrowView.highlighted;
}

@end

@interface DPGameLiveGoalView ()
@property (nonatomic, strong) UILabel *homeNameLabel;
@property (nonatomic, strong) UILabel *awayNameLabel;
@property (nonatomic, strong) UIImageView *homeIconView;
@property (nonatomic, strong) UIImageView *awayIconView;
@property (nonatomic, strong) UILabel *scoreLabel;
@end

@implementation DPGameLiveGoalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self setupConstraints];
    }
    return self;
}

- (void)setupProperty {
    _homeNameLabel = [[UILabel alloc] init];
    _homeNameLabel.backgroundColor = [UIColor clearColor];
    _homeNameLabel.textColor = [UIColor dp_flatBlackColor];
    _homeNameLabel.font = [UIFont dp_boldSystemFontOfSize:15];
    _homeNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _awayNameLabel = [[UILabel alloc] init];
    _awayNameLabel.backgroundColor = [UIColor clearColor];
    _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
    _awayNameLabel.font = [UIFont dp_boldSystemFontOfSize:15];
    _awayNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _homeIconView = [[UIImageView alloc] init];
    _homeIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _awayIconView = [[UIImageView alloc] init];
    _awayIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textColor = [UIColor colorWithRed:0.28 green:0.42 blue:0 alpha:1];
    _scoreLabel.font = [UIFont dp_boldArialOfSize:15];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setupConstraints {
    UIImageView *leftNameView = [[UIImageView alloc] initWithImage:dp_GameLiveResizeImage(@"goal_leftbg.png")];
    UIImageView *rightNameView = [[UIImageView alloc] initWithImage:dp_GameLiveResizeImage(@"goal_rightbg.png")];
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"goal_team.png")];
    UIImageView *rightIconView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"goal_team.png")];
    UIImageView *centerView = [[UIImageView alloc] initWithImage:dp_GameLiveImage(@"goal_center.png")];
    
    [self addSubview:leftNameView];
    [self addSubview:rightNameView];
    [self addSubview:leftIconView];
    [self addSubview:rightIconView];
    [self addSubview:centerView];
    
    // 防止球队图标背景被拉伸
    [leftIconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [rightIconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [leftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
    [rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
    [leftNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(3);
        make.right.equalTo(self.mas_centerX).offset(-20);
        make.left.equalTo(leftIconView.mas_centerX);
    }];
    [rightNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(3);
        make.left.equalTo(self.mas_centerX).offset(20);
        make.right.equalTo(rightIconView.mas_centerX);
    }];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.homeNameLabel];
    [self addSubview:self.awayNameLabel];
    [self addSubview:self.homeIconView];
    [self addSubview:self.awayIconView];
    [self addSubview:self.scoreLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.homeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(leftIconView);
    }];
    [self.awayIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(rightIconView);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIconView.mas_right);
        make.right.equalTo(centerView.mas_left);
        make.centerY.equalTo(self);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightIconView.mas_left);
        make.left.equalTo(centerView.mas_right);
        make.centerY.equalTo(self);
    }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(310, 75);
}

#pragma mark - Property (getter, setter)

- (NSString *)homeName {
    return self.homeNameLabel.text;
}

- (NSString *)awayName {
    return self.awayNameLabel.text;
}

- (UIImage *)homeIcon {
    return self.homeIconView.image;
}

- (UIImage *)awayIcon {
    return self.awayIconView.image;
}

- (NSAttributedString *)attributedString {
    return self.scoreLabel.attributedText;
}

- (void)setHomeName:(NSString *)homeName {
    self.homeNameLabel.text = homeName;
}

- (void)setAwayName:(NSString *)awayName {
    self.awayNameLabel.text = awayName;
}

- (void)setHomeIcon:(UIImage *)homeIcon {
    self.homeIconView.image = homeIcon ?: dp_SportLotteryImage(@"default.png");
}

- (void)setAwayIcon:(UIImage *)awayIcon {
    self.awayIconView.image = awayIcon ?: dp_SportLotteryImage(@"default.png");
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    self.scoreLabel.attributedText = attributedString;
}

@end

