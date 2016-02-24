//
//  KTMHeaderView.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMHeaderView.h"

static NSString *const kContentSizeKeyPath = @"contentSize";
static NSString *const kContentOffsetKeyPath = @"contentOffset";
static const CGFloat kRefreshHeaderHeight = 60.0f;
static const CGFloat kRefreshProgressLength = 60.0f;
static const CGFloat kRefreshLabelWidth = 200.0f;

@interface KTMHeaderView ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) KTMRefreshState currentState;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation KTMHeaderView

#pragma mark - Life cycle

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.frame = CGRectMake(0, -kRefreshHeaderHeight, CGRectGetWidth(scrollView.bounds), kRefreshHeaderHeight);
        
        _lastState = KTMRefreshStateStopped;
        _currentState = KTMRefreshStateStopped;
        _scrollView = scrollView;
        
        [_scrollView addObserver:self forKeyPath:kContentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addSubview:self];
    }
    return self;
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:kContentOffsetKeyPath];
}

#pragma mark - Override

- (void)layoutSubviews {
    if (!self.progressView.superview) {
        [self addSubview:self.progressView];
    }
    if (!self.textLabel.superview) {
        [self addSubview:self.textLabel];
    }
    
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake((CGRectGetWidth(self.bounds) - kRefreshProgressLength - kRefreshLabelWidth) / 2,
                                         (kRefreshHeaderHeight - kRefreshProgressLength) / 2,
                                         kRefreshProgressLength,
                                         kRefreshProgressLength);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame), 0, kRefreshLabelWidth, kRefreshHeaderHeight);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kContentOffsetKeyPath]) {
        [self scrollViewDidScroll];
    }
}

- (void)scrollViewDidScroll {
    CGFloat offset = self.scrollView.contentOffset.y;
    if (self.currentState == KTMRefreshStateLoading) {
        // tableView section header 悬浮问题
        self.scrollView.contentInset = UIEdgeInsetsMake(MAX(0, MIN(-offset, kRefreshHeaderHeight)), 0, 0, 0);
    } else {
        if (offset >= 0) {
            self.currentState = KTMRefreshStateStopped;
        } else if (offset >= -kRefreshHeaderHeight) {
            self.currentState = KTMRefreshStateProgress;
        } else {
            if (!self.scrollView.isTracking && !self.scrollView.isDragging) {
                if (self.currentState == KTMRefreshStateTriggered) {
                    // 触发动作
                    self.currentState = KTMRefreshStateLoading;
                    [self trigger];
                }
            } else {
                self.currentState = KTMRefreshStateTriggered;
            }
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

#pragma mark - Public Interface

- (void)setTarget:(id)target action:(SEL)action {
    NSParameterAssert([target respondsToSelector:action]);
    
    self.target = target;
    self.action = action;
}

- (void)startAnimatingWithTrigger:(BOOL)trigger {
    if (self.currentState == KTMRefreshStateLoading) {
        return;
    }
    self.currentState = KTMRefreshStateLoading;
    
    if (trigger) {
        [self trigger];
    }
}

- (void)startAnimating {
    [self startAnimatingWithTrigger:NO];
}

- (void)stopAnimating {
    if (self.currentState != KTMRefreshStateStopped) {
        self.currentState = KTMRefreshStateStopped;
    }
}

- (void)resetScrollViewContentInset {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(MAX(0, MIN(-self.scrollView.contentOffset.y, kRefreshHeaderHeight)), 0, 0, 0);
    } completion:nil];
}

#pragma mark - Property (getter, setter)

- (void)setCurrentState:(KTMRefreshState)currentState {
    if (_currentState != currentState) {
        _lastState = _currentState;
        _currentState = currentState;
        
        NSLog(@"currentState: %d", (int)currentState);
        
        switch (currentState) {
            case KTMRefreshStateStopped:
            case KTMRefreshStateProgress:
                self.textLabel.text = @"下拉刷新";
                break;
            case KTMRefreshStateTriggered:
                self.textLabel.text = @"释放刷新";
                break;
            case KTMRefreshStateLoading:
                self.textLabel.text = @"正在加载";
                
                [self resetScrollViewContentInset];
                break;
            default:
                break;
        }
        
    } else if (_currentState == KTMRefreshStateProgress) {
        
        
        
        
        
//        _lastState = _currentState;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"字符串.....";
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor purpleColor];
    }
    return _textLabel;
}

- (UIView<KTMRefreshProgressDelegate> *)progressView {
    if (!_progressView) {
        _progressView = (id)[[UIView alloc] init];
        _progressView.backgroundColor = [UIColor brownColor];
    }
    return _progressView;
}

@end
