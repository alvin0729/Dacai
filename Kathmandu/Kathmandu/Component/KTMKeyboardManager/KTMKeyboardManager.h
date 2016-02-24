//
//  KTMKeyboardManager.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/1.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    BOOL keyboardVisible;
    CGRect frameBegin;
    CGRect frameEnd;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    UIViewAnimationOptions animationOptions;
} KTMKeyboardTransition;

CG_INLINE BOOL KTMTransitionEqualToTransition(KTMKeyboardTransition transition1, KTMKeyboardTransition transition2) {
    return memcmp(&transition1, &transition2, sizeof(KTMKeyboardTransition)) == 0;
}

@protocol KTMKeyboardObserver <NSObject>
@required
- (void)keyboardFrameChanged:(KTMKeyboardTransition)transition;
@end

@interface KTMKeyboardManager : NSObject
@property (nonatomic, strong, readonly) UIView *keyboardView DEPRECATED_MSG_ATTRIBUTE("Do not use unless some powerful reasons");
@property (nonatomic, strong, readonly) UIWindow *keyboardWindow DEPRECATED_MSG_ATTRIBUTE("Do not use unless some powerful reasons");
@property (nonatomic, assign, readonly) CGRect keyboardFrame;
@property (nonatomic, assign, readonly, getter=isKeyboardVisible) BOOL keyboardVisible;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (KTMKeyboardManager *)defaultManager;
- (void)addObserver:(id<KTMKeyboardObserver>)observer;
- (void)removeObserver:(id<KTMKeyboardObserver>)observer;

- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
@end
