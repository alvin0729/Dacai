//
//  KTMFooterView.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMFooterView.h"
#import "UIScrollView+KTMAdditions.h"
#import "KTMRefreshConstans.h"
#import "KTMRefresh+Private.h"
#import "KTMIndicatorView.h"

static NSString *const kContentSizeKeyPath = @"contentSize";
static NSString *const kContentOffsetKeyPath = @"contentOffset";

static const CGFloat kRefreshFooterHeight = 60.0f;
static const CGFloat kRefreshProgressLength = 30.0f;
static const CGFloat kRefreshContentSpace = 10.0f;
static const CGFloat kRefreshContentMargin = 30.0f;

@interface KTMFooterView ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) KTMRefreshState currentState;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *progressView;
@end

@implementation KTMFooterView
@synthesize visible = _visible;

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        _currentState = KTMRefreshStateStopped;
        _alwaysShows = NO;
        _hasMoreData = NO;
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = KTMRefreshFooterViewStoppedText;
        _textLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        _textLabel.highlightedTextColor = [UIColor colorWithWhite:0.5 alpha:1];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.highlighted = YES;
        [self addSubview:_textLabel];
        
        _progressView = ({
            KTMIndicatorView *view = [KTMIndicatorView circleView];
            [view startAnimating];
            view;
        });
        [self addSubview:_progressView];
        
        self.hidden = YES;
    }
    return self;
}

#pragma mark - Override

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.superview removeObserver:self forKeyPath:kContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:kContentSizeKeyPath];
    
    if (newSuperview) {
        NSParameterAssert([newSuperview isKindOfClass:[UIScrollView class]]);
        
        _scrollView = (UIScrollView *)newSuperview;
        [newSuperview addObserver:self forKeyPath:kContentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:kContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    } else {
        _scrollView = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - 2 * kRefreshContentMargin - (self.currentState == KTMRefreshStateLoading ? (kRefreshContentSpace - kRefreshProgressLength) : 0), FLT_MAX)];
    CGFloat labelWidth = ceil(labelSize.width);
    CGFloat labelHeight = ceil(labelSize.height);
    
    switch (self.currentState) {
        case KTMRefreshStateLoading:
            self.progressView.frame = CGRectMake((CGRectGetWidth(self.bounds) - kRefreshProgressLength - kRefreshContentSpace - labelWidth) / 2,
                                                 (CGRectGetHeight(self.bounds) - kRefreshProgressLength) / 2,
                                                 kRefreshProgressLength,
                                                 kRefreshProgressLength);
            self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame) + kRefreshContentSpace,
                                              (CGRectGetHeight(self.bounds) - labelHeight) / 2,
                                              labelWidth,
                                              labelHeight);
            break;
        case KTMRefreshStateTriggered:
        case KTMRefreshStateStopped:
            self.textLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - labelWidth) / 2,
                                              (CGRectGetHeight(self.bounds) - labelHeight) / 2,
                                              labelWidth,
                                              labelHeight);
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
}

#pragma mark - Public Method

- (void)setTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

- (void)startAnimating {
    [self startAnimatingWithTrigger:NO];
}

- (void)startAnimatingWithTrigger:(BOOL)trigger {
    self.currentState = KTMRefreshStateLoading;
    
    if (trigger) {
        [self trigger];
    }
}

- (void)stopAnimating {
    [self stopAnimatingWithHasMoreData:YES];
}

- (void)stopAnimatingWithHasMoreData:(BOOL)hasMoreData {
    self.hasMoreData = hasMoreData;
    
    if (hasMoreData) {
        self.currentState = KTMRefreshStateTriggered;
    } else {
        self.currentState = KTMRefreshStateStopped;
    }
    
    [self resetScrollViewContentInset];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kContentOffsetKeyPath]) {
        [self scrollViewDidScroll];
    } else if ([keyPath isEqualToString:kContentSizeKeyPath]) {
        [self scrollViewBoundsChange];
    }
    [self resetVisible];
}

#pragma mark - Private Method

- (void)resetVisible {
    if ((CGRectGetWidth(self.scrollView.bounds) > self.scrollView.contentSize.width) ||
        (CGRectGetHeight(self.scrollView.bounds) > self.scrollView.contentSize.height) ||
        (CGRectGetWidth(self.scrollView.bounds) == self.scrollView.contentSize.width &&
         CGRectGetHeight(self.scrollView.bounds) == self.scrollView.contentSize.height)) {
        if (!self.alwaysShows) {
            _visible = NO;
            return;
        }
    }
    _visible = YES;
}

- (void)resetScrollViewContentInset {
    if (self.isVisible) {
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.bottom = self.contentInsetBottom + kRefreshFooterHeight;
        self.scrollView.contentInset = contentInset;
        self.hidden = NO;
    } else {
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.bottom = self.contentInsetBottom;
        self.scrollView.contentInset = contentInset;
        self.hidden = YES;
    }
}

- (void)scrollViewBoundsChange {
    self.frame = CGRectMake(0, self.scrollView.contentSize.height + self.contentInsetBottom, CGRectGetWidth(self.scrollView.bounds), kRefreshFooterHeight);
    [self resetScrollViewContentInset];
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll {
    if (!self.scrollView.isTracking && !self.scrollView.isDragging && !self.scrollView.isDecelerating) {
        return;
    }
    
    if (self.currentState == KTMRefreshStateTriggered && self.isVisible && self.hasMoreData) {
        CGRect visibleBounds = self.scrollView.dp_visibleBounds;
        
        // 触发
        if (CGRectIntersectsRect(visibleBounds, self.frame)) {
            self.currentState = KTMRefreshStateLoading;
            [self trigger];
        }
    }
}

- (void)trigger {
    if (self.handler) {
        self.handler();
    }
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:nil];
#pragma clang diagnostic pop
    }
}

#pragma mark - Property (getter, setter)

- (void)setAlwaysShows:(BOOL)alwaysShows {
    if (_alwaysShows != alwaysShows) {
        _alwaysShows = alwaysShows;
        
        [self resetVisible];
    }
}

- (void)setHasMoreData:(BOOL)hasMoreData {
    if (_hasMoreData != hasMoreData) {
        _hasMoreData = hasMoreData;
        
        if (_currentState != KTMRefreshStateLoading) {
            _currentState = hasMoreData ? KTMRefreshStateTriggered : KTMRefreshStateStopped;
            _textLabel.text = hasMoreData ? KTMRefreshFooterViewTriggeredText : KTMRefreshFooterViewStoppedText;
        }
    }
}

- (BOOL)isAnimating {
    return self.isVisible && self.currentState == KTMRefreshStateLoading;
}

- (void)setCurrentState:(KTMRefreshState)currentState {
    if (_currentState != currentState) {
        _currentState = currentState;
        
        switch (currentState) {
            case KTMRefreshStateTriggered:
                _textLabel.text = KTMRefreshFooterViewTriggeredText;
                _textLabel.highlighted = NO;
                _progressView.hidden = YES;
                break;
            case KTMRefreshStateStopped:
                _textLabel.text = KTMRefreshFooterViewStoppedText;
                _textLabel.highlighted = YES;
                _progressView.hidden = YES;
                break;
            case KTMRefreshStateLoading:
                _textLabel.text = KTMRefreshFooterViewLoadingText;
                _textLabel.highlighted = NO;
                _progressView.hidden = NO;
                break;
            default:
                NSParameterAssert(NO);
                break;
        }
    }
}

@end
