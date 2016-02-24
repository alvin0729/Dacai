//
//  UIScrollView+KTMRefresh.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTMHeaderView;
@class KTMFooterView;
@interface UIScrollView (KTMRefresh)
@property (nonatomic, strong, readonly) KTMHeaderView *ktm_headerView;
@property (nonatomic, strong, readonly) KTMFooterView *ktm_footerView;

- (void)ktm_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)ktm_addInfiniteScrollingWithHandler:(void (^)(void))handler;

- (void)ktm_addPullToRefreshWithTarget:(id)target action:(SEL)action;
- (void)ktm_addInfiniteScrollingWithTarget:(id)target action:(SEL)action;

- (void)ktm_addPullToRefreshWithHeaderView:(KTMHeaderView *)headerView;
- (void)ktm_addInfiniteScrollinWithFooterView:(KTMFooterView *)footerView;

- (void)ktm_triggerHeaderRefresh;
- (void)ktm_triggerFooterRefresh;

- (void)ktm_stopHeaderAnimating;
- (void)ktm_stopFooterAnimatingWithHasMoreData:(BOOL)hasMoreData;
@end
