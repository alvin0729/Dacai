//
//  KTMIndicatorView.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMIndicatorView.h"
#import "KTMCircleIndicatorView.h"
#import "KTMIndicatorView+Private.h"

@implementation KTMIndicatorView

- (instancetype)init_ {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor redColor];
    }
    return self;
}

- (void)startAnimating {
    _animating = YES;
    if (self.hidden) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    _animating = NO;
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    if (_hidesWhenStopped != hidesWhenStopped) {
        _hidesWhenStopped = hidesWhenStopped;
        
        if (_hidesWhenStopped && !_animating) {
            self.hidden = YES;
        } else {
            self.hidden = NO;
        }
    }
}

@end

@implementation KTMIndicatorView (KTMIndicatorViewCreation)

+ (instancetype)circleView {
    return [[KTMCircleIndicatorView alloc] init_];
}

@end
