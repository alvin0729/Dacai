//
//  KTMHeaderView.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTMRefreshTypes.h"

@interface KTMHeaderView : UIView
@property (nonatomic, assign, readonly) KTMRefreshState lastState;
@property (nonatomic, assign, readonly) KTMRefreshState currentState;
@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) UIView<KTMRefreshProgressDelegate> *progressView;
@property (nonatomic, copy) void (^handler)(void);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)setTarget:(id)target action:(SEL)action;
- (void)startAnimating;
- (void)startAnimatingWithTrigger:(BOOL)trigger;
- (void)stopAnimating;
@end
