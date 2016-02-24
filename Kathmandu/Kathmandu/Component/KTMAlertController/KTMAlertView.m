//
//  KTMAlertView.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/23.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMAlertView.h"

@interface _KTMAlertViewAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(void);
@property (nonatomic, strong) UIButton *button;
@end
@implementation _KTMAlertViewAction
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.layer.cornerRadius = 5;
        _button.backgroundColor = [UIColor colorWithRed:0.87 green:0.31 blue:0.29 alpha:1];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button setTitle:self.title forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonTapped {
    if (self.handler) {
        self.handler();
    }
}

@end

@interface KTMAlertView()
@property (nonatomic, assign) BOOL needSetupConstrains;

@property (nonatomic, strong, readonly) NSMutableArray<_KTMAlertViewAction *> *actions;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIView *buttonContainerView;

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIWindow *window;       // 强引用 UIWindow, 以免被释放而无法显示
@property (nonatomic, assign, getter=isAppear) BOOL appear;
@end

@implementation KTMAlertView
@synthesize actions = _actions;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize buttonContainerView = _buttonContainerView;
@synthesize window = _window;
@synthesize backgroundView = _backgroundView;

#pragma mark - Life cycle

+ (KTMAlertView *)alertViewWithTitle:(id)title message:(id)message {
    KTMAssert([title isKindOfClass:[NSString class]] || [title isKindOfClass:[NSAttributedString class]]);
    KTMAssert([message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]]);
    
    KTMAlertView *alertView = [[[self class] alloc] init];
    if ([title isKindOfClass:[NSString class]]) {
        alertView.title = title;
    } else {
        alertView.attrTitle = title;
    }
    if ([message isKindOfClass:[NSString class]]) {
        alertView.message = message;
    } else {
        alertView.attrMessage = message;
    }
    return alertView;
}

+ (KTMAlertView *)alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                 cancelButtonhandler:(void (^)(void))cancelButtonhandler {
    KTMAlertView *alertView = [[self class] alertViewWithTitle:title message:message];
    [alertView addButtonWithTitle:cancelButtonTitle handler:cancelButtonhandler];
    return alertView;
}

+ (KTMAlertView *)alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                 cancelButtonhandler:(void (^)(void))cancelButtonhandler
                  confirmButtonTitle:(NSString *)confirmButtonTitle
                confirmButtonHandler:(void (^)(void))confirmButtonHandler {
    KTMAlertView *alertView = [[self class] alertViewWithTitle:title message:message];
    [alertView addButtonWithTitle:cancelButtonTitle handler:cancelButtonhandler];
    [alertView addButtonWithTitle:confirmButtonTitle handler:confirmButtonHandler];
    return alertView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dismissWhenTouches = NO;
        self.needSetupConstrains = YES;
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.95 alpha:1];
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"KTMAlertView dealloc");
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Public method
- (void)addButtonWithTitle:(NSString *)title handler:(void (^)(void))handler {
    if (!title && !handler) {
        return;
    }
    _KTMAlertViewAction *action = [[_KTMAlertViewAction alloc] init];
    action.title = title;
    action.handler = handler;
    [self.actions addObject:action];
}

- (void)show {
    if (self.isAppear) {
        return;
    }
    self.appear = YES;
    
    if (self.needSetupConstrains) {
        self.needSetupConstrains = NO;
        
        [self setupViewConstraints];
    }
    
    [self.backgroundView addSubview:self];
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.window addSubview:self.backgroundView];
    [self.window makeKeyAndVisible];
    
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 1;
    }];
    
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    if (!self.appear) {
        return;
    }
    
    self.appear = NO;
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        // 破除循环引用
        [self removeFromSuperview];
    }];
}

#pragma mark - User Interaction

- (void)backgroundViewTapped:(UITapGestureRecognizer *)tapGesture {
    if (!self.dismissWhenTouches) {
        return;
    }
    CGPoint point = [tapGesture locationInView:self];
    // 点击弹框外部
    if (!CGRectContainsPoint(self.bounds, point)) {
        [self dismiss];
    }
}

#pragma mark - Private method

- (void)setupViewConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.buttonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.buttonContainerView];
    
    KTMAssert(self.actions.count <= 2);
    
    // 按钮容器布局
    for (_KTMAlertViewAction *action in self.actions) {
        [action.button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainerView addSubview:action.button];
    }
    if (self.actions.count) {
        [self.buttonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:36]];
    }
    // 按钮布局
    switch (self.actions.count) {
        case 1: {
            UIButton *button = self.actions.firstObject.button;
            NSDictionary *views = @{ @"button": button };
            [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:NSLayoutFormatDirectionLeftToRight | NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
            [self.buttonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:NSLayoutFormatDirectionLeftToRight | NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
            break;
        }
        case 2: {
            UIButton *button1 = self.actions.firstObject.button;
            UIButton *button2 = self.actions.lastObject.button;
            NSString *vfl = @"H:|[button1(==button2)]-16-[button2]|";
            NSDictionary *views = @{ @"button1": button1, @"button2": button2};
            NSArray *contraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionLeftToRight | NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views];
            [self.buttonContainerView addConstraints:contraints];
            [self.buttonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [self.buttonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            break;
        }
        default:
            break;
    }
    
    // alertView 宽度限制, 高度限制
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:270]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200]];
    
    NSString *vfl;
    NSDictionary *metrics;
    NSDictionary *views;
    NSArray *constraints;
    
    // alertView 纵向布局
    vfl = @"V:|-20-[title]-[message]-(>=30)-[buttons]-15-|";
    views = @{ @"title" : self.titleLabel,
               @"message" : self.messageLabel,
               @"buttons" : self.buttonContainerView };
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionLeftToRight | NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:metrics views:views];
    [self addConstraints:constraints];
    
    // alertView 横向布局
    vfl = @"H:|-20-[title]-20-|";
    views = @{ @"title" : self.titleLabel};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views];
    [self addConstraints:constraints];
}


#pragma mark - Property(getter, setter)

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor clearColor];
        _window.windowLevel = UIWindowLevelAlert;
    }
    return _window;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)]];
    }
    return _backgroundView;
}

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray arrayWithCapacity:5];
    }
    return _actions;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSAttributedString *)attrTitle {
    return self.titleLabel.attributedText;
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle {
    self.titleLabel.attributedText = attrTitle;
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

- (NSAttributedString *)attrMessage {
    return self.messageLabel.attributedText;
}

- (void)setAttrMessage:(NSAttributedString *)attributeMessage {
    self.messageLabel.attributedText = attributeMessage;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor colorWithWhite:0.22 alpha:1];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0.87 green:0.31 blue:0.29 alpha:1];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] init];
        _buttonContainerView.backgroundColor = [UIColor clearColor];
    }
    return _buttonContainerView;
}

@end
