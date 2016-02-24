//
//  KTMCountLabel.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMCountLabel.h"

@interface _KTMCountLabelCurve : NSObject
@property (nonatomic, assign) UIViewAnimationCurve animationCurve;

+ (instancetype)curveWithAnimationCurve:(UIViewAnimationCurve)animationCurve;
- (CGFloat)calcYWithX:(CGFloat)x;
@end

@implementation _KTMCountLabelCurve

+ (instancetype)curveWithAnimationCurve:(UIViewAnimationCurve)animationCurve {
    return [[[self class] alloc] initWithAnimationCurve:animationCurve];
}

- (instancetype)initWithAnimationCurve:(UIViewAnimationCurve)animationCurve {
    if (self = [super init]) {
        self.animationCurve = animationCurve;
    }
    return self;
}

- (CGFloat)linear:(CGFloat)x {
    return x;
}

- (CGFloat)easeIn:(CGFloat)x {
    return x * x;
}

- (CGFloat)easeOut:(CGFloat)x {
    return sqrt(x);
}

- (CGFloat)calcYWithX:(CGFloat)x {
    switch (self.animationCurve) {
        case UIViewAnimationCurveLinear:
            return [self linear:x];
        case UIViewAnimationCurveEaseIn:
            return [self easeIn:x];
        case UIViewAnimationCurveEaseOut:
            return [self easeOut:x];
        case UIViewAnimationCurveEaseInOut:
            return x > 0.5 ? [self easeOut:x] : [self easeIn:x];
        default:
            return 0;
    }
}

@end

@interface KTMCountLabel ()
@property (nonatomic, strong, readonly) CADisplayLink *displayLink;
@property (nonatomic, strong) _KTMCountLabelCurve *curve;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) CFTimeInterval endTime;
@property (nonatomic, assign) NSInteger fromNumber;
@property (nonatomic, assign) NSInteger toNumber;
@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, copy) NSString *(^textHandler)(NSInteger number);
@end

@implementation KTMCountLabel
@synthesize displayLink = _displayLink;

- (void)countWithDuration:(NSTimeInterval)duration
           animationCurve:(UIViewAnimationCurve)animiatonCurve
               fromNumber:(NSInteger)fromNumber
                 toNumber:(NSInteger)toNumber
              textHandler:(NSString *(^)(NSInteger number))textHandler {
    self.displayLink.paused = YES;
    
    self.curve = [_KTMCountLabelCurve curveWithAnimationCurve:animiatonCurve];
    self.duration = duration;
    self.beginTime = CACurrentMediaTime();
    self.endTime = self.beginTime + duration;
    self.textHandler = textHandler;
    self.fromNumber = fromNumber;
    self.toNumber = toNumber;
    
    self.currentNumber = fromNumber - 1;
    
    self.displayLink.paused = NO;
}

- (void)updateText {
    CFTimeInterval currentTime = CACurrentMediaTime();
    CGFloat x = (currentTime - self.beginTime) / self.duration;
    CGFloat y = [self.curve calcYWithX:x];
    NSInteger currentNumber = MIN(y * (self.toNumber - self.fromNumber) + self.fromNumber, self.toNumber);
    if (self.currentNumber != currentNumber) {
        if (self.textHandler) {
            self.text = self.textHandler(currentNumber);
        } else {
            self.text = [NSString stringWithFormat:@"%d", (int)currentNumber];
        }
        self.currentNumber = currentNumber;
    }
    
    if (currentTime >= self.endTime || currentNumber >= self.toNumber) {
        self.displayLink.paused = YES;
    }
}

#pragma mark - Property (getter, setter)

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateText)];
        _displayLink.frameInterval = 2;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

@end
