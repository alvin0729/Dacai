//
//  KTMFooterView.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTMRefreshTypes.h"

@interface KTMFooterView : UIView
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;
@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, copy) void (^handler)(void);

/**
 *  当该值为 NO 时, 只会在内容多于一页的情况下显示, 默认为 NO
 */
@property (nonatomic, assign) BOOL alwaysShows;

/**
 *  是否还有更多数据需要加载
 */
@property (nonatomic, assign) BOOL hasMoreData;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;
- (void)startAnimating;
- (void)startAnimatingWithTrigger:(BOOL)trigger;
- (void)stopAnimating;
- (void)stopAnimatingWithHasMoreData:(BOOL)hasMoreData;
@end
