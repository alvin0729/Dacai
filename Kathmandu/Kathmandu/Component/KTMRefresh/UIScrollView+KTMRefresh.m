//
//  UIScrollView+KTMRefresh.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIScrollView+KTMRefresh.h"
#import "KTMRefresh+Private.h"
#import <objc/runtime.h>

const static void *kHeaderViewKey = &kHeaderViewKey;
const static void *kFooterViewKey = &kFooterViewKey;

@interface UIScrollView ()
@property (nonatomic, strong, setter=ktm_setHeaderView:) KTMHeaderView *ktm_headerView;
@property (nonatomic, strong, setter=ktm_setFooterView:) KTMFooterView *ktm_footerView;
@end

@implementation UIScrollView (KTMRefresh)

#pragma mark - Public Interface

- (void)ktm_addPullToRefreshWithHandler:(void (^)(void))handler {
    KTMHeaderView *header = [[KTMHeaderView alloc] initWithScrollView:self];
    header.handler = handler;
    [self ktm_addPullToRefreshWithHeaderView:header];
}

- (void)ktm_addInfiniteScrollingWithHandler:(void (^)(void))handler {
    KTMFooterView *footer = [[KTMFooterView alloc] init];
    footer.handler = handler;
    
    [self ktm_addInfiniteScrollinWithFooterView:footer];
}

- (void)ktm_addPullToRefreshWithTarget:(id)target action:(SEL)action {
    KTMHeaderView *header = [[KTMHeaderView alloc] initWithScrollView:self];
    [header setTarget:target action:action];
    [self ktm_addPullToRefreshWithHeaderView:header];
}

- (void)ktm_addInfiniteScrollingWithTarget:(id)target action:(SEL)action {
//    KTMFooterView *footer = [[KTMFooterView alloc] initWith];
//    [footer setTarget:target action:action];
//    self.ktm_footerView = footer;
}

- (void)ktm_addPullToRefreshWithHeaderView:(KTMHeaderView *)headerView {
    self.ktm_headerView = headerView;
    
    
    
}

- (void)ktm_addInfiniteScrollinWithFooterView:(KTMFooterView *)footerView {
    self.ktm_footerView = footerView;
    [self addSubview:footerView];
}

- (void)ktm_triggerHeaderRefresh {
    
}

- (void)ktm_triggerFooterRefresh {
    
}

- (void)ktm_stopHeaderAnimating {
}

- (void)ktm_stopFooterAnimatingWithHasMoreData:(BOOL)hasMoreData {
    [self.ktm_footerView stopAnimatingWithHasMoreData:hasMoreData];
}

#pragma mark - Property(getter, setter)

- (KTMHeaderView *)ktm_headerView {
    return objc_getAssociatedObject(self, kHeaderViewKey);
}

- (void)ktm_setHeaderView:(KTMHeaderView *)headerView {
    return objc_setAssociatedObject(self, kHeaderViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KTMFooterView *)ktm_footerView {
    return objc_getAssociatedObject(self, kFooterViewKey);
}

- (void)ktm_setFooterView:(KTMFooterView *)footerView {
    return objc_setAssociatedObject(self, kFooterViewKey, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
