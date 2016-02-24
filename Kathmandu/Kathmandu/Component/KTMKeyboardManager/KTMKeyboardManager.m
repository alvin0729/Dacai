//
//  KTMKeyboardManager.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/1.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMKeyboardManager.h"

#define GetConstNameLength(v) (sizeof(v) / sizeof(unichar) / 2)
#define PrintKeyboardTransition(t) \
    NSLog(@"frameBegin: %@, frameEnd: %@, animationDuration: %.2f, animationCurve: 0x%08x, animationOption: 0x%08x, keyboardVisible: %@",   \
          NSStringFromCGRect(t.frameBegin),    \
          NSStringFromCGRect(t.frameEnd),      \
          t.animationDuration,                 \
          (int)t.animationCurve,               \
          (int)t.animationOptions,             \
          t.keyboardVisible ? @"YES" : @"NO");


@interface KTMKeyboardManager ()
@property (nonatomic, strong, readonly) NSHashTable<id<KTMKeyboardObserver>> *observerSet;
@property (nonatomic, assign) KTMKeyboardTransition keyboardTransition;
@end

@implementation KTMKeyboardManager
@synthesize observerSet = _observerSet;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self defaultManager];
    });
}

+ (KTMKeyboardManager *)defaultManager {
    static KTMKeyboardManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[KTMKeyboardManager alloc] init_];
    });
    return mgr;
}

- (instancetype)init_ {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

#pragma mark - Notification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    KTMKeyboardTransition transition = [self parserKeyboardInfo:notification.userInfo];
//    CFAbsoluteTime absoluteTime = CFAbsoluteTimeGetCurrent(); // 获取当前精确时间
    PrintKeyboardTransition(transition);
    if (KTMTransitionEqualToTransition(self.keyboardTransition, transition)) {
        return;
    }
    self.keyboardTransition = transition;
    
    if (CGRectEqualToRect(transition.frameBegin, transition.frameEnd)) {
        return;
    }
    for (id<KTMKeyboardObserver> observer in self.observerSet) {
        if ([observer respondsToSelector:@selector(keyboardFrameChanged:)]) {
            [observer keyboardFrameChanged:transition];
        }
    }
}

#pragma mark - Public Method

- (void)addObserver:(id<KTMKeyboardObserver>)observer {
    NSParameterAssert([NSThread isMainThread]);
    if (observer) {
        [self.observerSet addObject:observer];
    }
}

- (void)removeObserver:(id<KTMKeyboardObserver>)observer {
    NSParameterAssert([NSThread isMainThread]);
    if (observer) {
        [self.observerSet removeObject:observer];
    }
}

- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view {
    if (CGRectIsNull(rect)) {
        return rect;
    }
    if (CGRectIsInfinite(rect)) {
        return rect;
    }
    if ([view isKindOfClass:[UIWindow class]]) {
        return rect;
    }
    // Windows 的 frame 基本都是屏幕的 bounds, 除非特意设置了其他值, 这种情况不考虑
    return [view.window convertRect:rect toView:view];
}

#pragma mark - Private Method

- (KTMKeyboardTransition)parserKeyboardInfo:(NSDictionary *)info {
    KTMKeyboardTransition transition;
    transition.frameBegin = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    transition.frameEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    transition.animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    transition.animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    transition.animationOptions = transition.animationCurve << 16;
    transition.keyboardVisible = CGRectIntersectsRect(transition.frameEnd, [UIScreen mainScreen].bounds);
    return transition;
}

- (BOOL)matchClassName:(NSString *)className constName:(const unichar *)constName length:(NSInteger)length {
    if (length != className.length) {
        return NO;
    }
    for (int i = 0; i < length; i++) {
        if ([className characterAtIndex:i] != constName[i * 2]) {
            return NO;
        }
    }
    return YES;
}

- (UIView *)searchKeyboardViewInWindow:(UIWindow *)window {
    /*
     iOS 6/7:
     UITextEffectsWindow
     UIPeripheralHostView << keyboard
     
     iOS 8:
     UITextEffectsWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard
     
     iOS 9:
     UIRemoteKeyboardWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard
     
     #define IOS_VERSION_5_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_4_3 )
     #define IOS_VERSION_6_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1 )
     #define IOS_VERSION_7_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
     #define IOS_VERSION_8_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 )
     #define IOS_VERSION_9_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4 )
     */
    
    if (![self isKeyboardWindow:window]) {
        return nil;
    }
    
    // 不确定键盘类名是否属于 Private API, 规避一下
    static const unichar UIPeripheralHostViewName[] = { 'U', ' ', 'I', ' ', 'P', ' ', 'e', ' ', 'r', ' ', 'i', ' ', 'p', ' ', 'h', ' ', 'e', ' ', 'r', ' ', 'a', ' ', 'l', ' ', 'H', ' ', 'o', ' ', 's', ' ', 't', ' ', 'V', ' ', 'i', ' ', 'e', ' ', 'w', ' ' };
    static const unichar UIInputSetHostViewName[] = { 'U', ' ', 'I', ' ', 'I', ' ', 'n', ' ', 'p', ' ', 'u', ' ', 't', ' ', 'S', ' ', 'e', ' ', 't', ' ', 'H', ' ', 'o', ' ', 's', ' ', 't', ' ', 'V', ' ', 'i', ' ', 'e', ' ', 'w', ' ' };
    static const unichar UIInputSetContainerView[] = { 'U', ' ', 'I', ' ', 'I', ' ', 'n', ' ', 'p', ' ', 'u', ' ', 't', ' ', 'S', ' ', 'e', ' ', 't', ' ', 'C', ' ', 'o', ' ', 'n', ' ', 't', ' ', 'a', ' ', 'i', ' ', 'n', ' ', 'e', ' ', 'r', ' ', 'V', ' ', 'i', ' ', 'e', ' ', 'w', ' ' };
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {  // iOS 8, 9
        for (UIView *containerView in window.subviews) {
            if (![self matchClassName:NSStringFromClass(containerView.class)
                            constName:UIInputSetContainerView
                               length:GetConstNameLength(UIInputSetContainerView)]) {
                continue;
            }
            for (UIView *view in containerView.subviews) {
                if ([self matchClassName:NSStringFromClass(view.class)
                               constName:UIInputSetHostViewName
                                  length:GetConstNameLength(UIInputSetHostViewName)]) {
                    return view;
                }
            }
        }
    } else if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {  // iOS 7
        for (UIView *view in window.subviews) {
            if ([self matchClassName:NSStringFromClass(view.class)
                           constName:UIPeripheralHostViewName
                              length:GetConstNameLength(UIPeripheralHostViewName)]) {
                return view;
            }
        }
    }
    
    return nil;
}

- (BOOL)isKeyboardWindow:(UIWindow *)window {
    /*
     iOS 6/7:
     UITextEffectsWindow
     UIPeripheralHostView << keyboard
     
     iOS 8:
     UITextEffectsWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard
     
     iOS 9:
     UIRemoteKeyboardWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard
     
     #define IOS_VERSION_5_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_4_3 )
     #define IOS_VERSION_6_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1 )
     #define IOS_VERSION_7_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
     #define IOS_VERSION_8_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 )
     #define IOS_VERSION_9_OR_ABOVE     ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4 )
     */
    
    // 不确定键盘类名是否属于 Private API, 规避一下
    static const unichar UITextEffectsWindowName[] = { 'U', ' ', 'I', ' ', 'T', ' ', 'e', ' ', 'x', ' ', 't', ' ', 'E', ' ', 'f', ' ', 'f', ' ', 'e', ' ', 'c', ' ', 't', ' ', 's', ' ', 'W', ' ', 'i', ' ', 'n', ' ', 'd', ' ', 'o', ' ', 'w', ' ' };
    static const unichar UIRemoteKeyboardWindowName[] = { 'U', ' ', 'I', ' ', 'R', ' ', 'e', ' ', 'm', ' ', 'o', ' ', 't', ' ', 'e', ' ', 'K', ' ', 'e', ' ', 'y', ' ', 'b', ' ', 'o', ' ', 'a', ' ', 'r', ' ', 'd', ' ', 'W', ' ', 'i', ' ', 'n', ' ', 'd', ' ', 'o', ' ', 'w', ' ' };
    NSString *windowClassName = NSStringFromClass(window.class);
    
    // 判断是否是键盘
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4) { // iOS 9
        if ([self matchClassName:windowClassName constName:UIRemoteKeyboardWindowName length:GetConstNameLength(UIRemoteKeyboardWindowName)]) {
            return YES;
        }
    } else if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {  // iOS 7, iOS 8
        if ([self matchClassName:windowClassName constName:UITextEffectsWindowName length:GetConstNameLength(UITextEffectsWindowName)]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Property (getter, setter)

- (NSHashTable<id<KTMKeyboardObserver>> *)observerSet {
    if (!_observerSet) {
        _observerSet = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality];
    }
    return _observerSet;
}

- (UIView *)keyboardView {
    return [self searchKeyboardViewInWindow:self.keyboardWindow];
}

- (UIWindow *)keyboardWindow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if ([self isKeyboardWindow:window]) {
            return window;
        }
    }
    return nil;
}

- (BOOL)isKeyboardVisible {
    return self.keyboardTransition.keyboardVisible;
}

- (CGRect)keyboardFrame {
    return self.keyboardTransition.frameEnd;
}

@end
