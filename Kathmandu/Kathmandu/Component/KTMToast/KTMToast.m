//
//  KTMToast.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/1.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMToast.h"
#import "KTMKeyboardManager.h"

static const CGFloat kToastDuration = 5.0f;
static const UIEdgeInsets kToastMargin = { 0, 25, 60, 25 };
static const UIEdgeInsets kLabelMargin = { 5, 8, 5, 8 };
static const UIEdgeInsets kBackgroundMargin = { 1.5, 1.5, 1.5, 1.5 };

@interface KTMToast ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *textLabel;

+ (KTMToast *)sharedToast;
@end

@implementation KTMToast

#pragma mark - Life cycle

- (instancetype)init_ {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.cornerRadius = 3;
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _backgroundView.layer.cornerRadius = 3;
        [self addSubview:_backgroundView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.preferredMaxLayoutWidth =
            CGRectGetWidth(UIScreen.mainScreen.bounds) - kLabelMargin.left - kLabelMargin.right - kToastMargin.left - kToastMargin.right;
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_textLabel];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    }
    return self;
}

+ (KTMToast *)sharedToast {
    static dispatch_once_t onceToken;
    static KTMToast *toast;
    dispatch_once(&onceToken, ^{
        toast = [[[self class] alloc] init_];
    });
    return toast;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(kBackgroundMargin.left, kBackgroundMargin.top, CGRectGetWidth(self.bounds) - kBackgroundMargin.left - kBackgroundMargin.right, CGRectGetHeight(self.bounds) - kBackgroundMargin.top - kBackgroundMargin.bottom);
    self.textLabel.frame = CGRectMake(kLabelMargin.left, kLabelMargin.top, self.textLabel.intrinsicContentSize.width, self.textLabel.intrinsicContentSize.height);
}

- (CGSize)intrinsicContentSize {
    CGSize labelSize = self.textLabel.intrinsicContentSize;
    return CGSizeMake(kLabelMargin.left + labelSize.width + kLabelMargin.right,
                      kLabelMargin.top + labelSize.height + kLabelMargin.bottom);
}

#pragma mark - Private Method

- (void)showText:(NSString *)text {
    self.textLabel.text = text;
    [self invalidateIntrinsicContentSize];
    [self show];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:kToastDuration inModes:@[NSRunLoopCommonModes]];
}

- (void)show {
    CGFloat screenHeight = CGRectGetHeight(UIScreen.mainScreen.bounds);
    CGFloat screenWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    
    KTMKeyboardManager *keyboardManager = [KTMKeyboardManager defaultManager];
    if (keyboardManager.isKeyboardVisible) {
        self.frame = CGRectMake((screenWidth - self.intrinsicContentSize.width) / 2,
                                CGRectGetMinY(keyboardManager.keyboardFrame) - self.intrinsicContentSize.height - kToastMargin.bottom,
                                self.intrinsicContentSize.width,
                                self.intrinsicContentSize.height);
    } else {
        self.frame = CGRectMake((screenWidth - self.intrinsicContentSize.width) / 2,
                                screenHeight - self.intrinsicContentSize.height - kToastMargin.bottom,
                                self.intrinsicContentSize.width,
                                self.intrinsicContentSize.height);
    }
    [self setNeedsLayout];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Public Method

+ (void)showText:(NSString *)text {
    [[[self class] sharedToast] showText:text];
}

+ (void)dismiss {
    [[[self class] sharedToast] dismiss];
}

@end
