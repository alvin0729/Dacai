//
//  UIScrollView+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (KTMAdditions)
@property (nonatomic, assign, readonly) CGRect dp_visibleBounds;

- (void)dp_scrollToTop;
- (void)dp_scrollToTopAnimated:(BOOL)animated;
@end
