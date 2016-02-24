//
//  UIScrollView+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIScrollView+KTMAdditions.h"

@implementation UIScrollView (KTMAdditions)

- (void)dp_scrollToTop {
    [self dp_scrollToTopAnimated:NO];
}

- (void)dp_scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:CGPointZero animated:animated];
}

- (CGRect)dp_visibleBounds {
    return CGRectMake(self.contentOffset.x, self.contentOffset.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
