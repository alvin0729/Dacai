//
//  UIView+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIView+KTMAdditions.h"

@implementation UIView (KTMAdditions)

- (UIViewController *)dp_viewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

+ (instancetype)dp_viewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
//    view.userInteractionEnabled = NO;
    return view;
}

#pragma mark - getter
- (CGSize)dp_size {
    return self.frame.size;
}

- (CGPoint)dp_origin {
    return self.frame.origin;
}

- (CGFloat)dp_x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)dp_y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)dp_width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)dp_height {
    return CGRectGetHeight(self.frame);
}

#pragma mark - setter
- (void)dp_setSize:(CGSize)dp_size {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), dp_size.width, dp_size.height);
}

- (void)dp_setOrigin:(CGPoint)dp_origin {
    self.frame = CGRectMake(dp_origin.x, dp_origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)dp_setX:(CGFloat)dp_x {
    self.frame = CGRectMake(dp_x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)dp_setY:(CGFloat)dp_y {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), dp_y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)dp_setWidth:(CGFloat)dp_width {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), dp_width, CGRectGetHeight(self.frame));
}

- (void)dp_setHeight:(CGFloat)dp_height {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), dp_height);
}

#pragma mark - getter
- (CGFloat)dp_intrinsicWidth {
    return self.intrinsicContentSize.width;
}

- (CGFloat)dp_intrinsicHeight {
    return self.intrinsicContentSize.height;
}

- (CGFloat)dp_minX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)dp_midX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)dp_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)dp_minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)dp_midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)dp_maxY {
    return CGRectGetMaxY(self.frame);
}

- (UIImage *)dp_screenshot {
    UIImage *image = nil;
    
//    if (IOS_VERSION_7_OR_ABOVE) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
//    } else {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
    return image;
}


@end
