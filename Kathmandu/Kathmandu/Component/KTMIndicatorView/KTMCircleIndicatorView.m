//
//  KTMCircleIndicatorView.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMCircleIndicatorView.h"
#import "KTMIndicatorView+Private.h"

static NSString *const kAnimationKey = @"Rotation";
static const CGFloat kRadius = 10.0f;
static const CGFloat kLength = kRadius * 2 + 10.0f;

@implementation KTMCircleIndicatorView {
@private
    CGFloat _rgbStrokeColor[4];
}

- (instancetype)init_ {
    if (self = [super init_]) {
        self.frame = CGRectMake(0, 0, kLength, kLength);
    }
    return self;
}

- (void)startAnimating {
    [super startAnimating];
    [self.layer removeAnimationForKey:kAnimationKey];
    
    CABasicAnimation *animiation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animiation.fromValue = @0;
    animiation.toValue = @(M_PI * 2);
    animiation.repeatCount = HUGE_VAL;
    animiation.duration = 1;
    [self.layer addAnimation:animiation forKey:kAnimationKey];
}

- (void)stopAnimating {
    [super stopAnimating];
    [self.layer removeAnimationForKey:kAnimationKey];
}

- (void)setColor:(UIColor *)color {
    memcpy(_rgbStrokeColor, CGColorGetComponents(color.CGColor), sizeof(_rgbStrokeColor));
    
    [super setColor:color];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, _rgbStrokeColor[0], _rgbStrokeColor[1], _rgbStrokeColor[2], _rgbStrokeColor[3]);
    CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), kRadius, 0, 5.3, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kLength, kLength);
}

@end
