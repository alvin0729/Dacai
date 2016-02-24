//
//  UIView+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KTMAdditions)
@property (nonatomic, assign, setter=dp_setSize:) CGSize dp_size;
@property (nonatomic, assign, setter=dp_setOrigin:) CGPoint dp_origin;
@property (nonatomic, assign, setter=dp_setX:) CGFloat dp_x;
@property (nonatomic, assign, setter=dp_setY:) CGFloat dp_y;
@property (nonatomic, assign, setter=dp_setWidth:) CGFloat dp_width;
@property (nonatomic, assign, setter=dp_setHeight:) CGFloat dp_height;

@property (nonatomic, assign, readonly) CGFloat dp_intrinsicWidth;
@property (nonatomic, assign, readonly) CGFloat dp_intrinsicHeight;
@property (nonatomic, assign, readonly) CGFloat dp_minX;
@property (nonatomic, assign, readonly) CGFloat dp_midX;
@property (nonatomic, assign, readonly) CGFloat dp_maxX;
@property (nonatomic, assign, readonly) CGFloat dp_minY;
@property (nonatomic, assign, readonly) CGFloat dp_midY;
@property (nonatomic, assign, readonly) CGFloat dp_maxY;
@property (nonatomic, strong, readonly) UIViewController *dp_viewController;

+ (instancetype)dp_viewWithColor:(UIColor *)color;
- (UIImage *)dp_screenshot;
@end
