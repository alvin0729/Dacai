//
//  DPHomeBannerViewPage.m
//  Jackpot
//
//  Created by WUFAN on 15/11/20.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPHomeBannerViewPage.h"
#import <ReactiveCocoa/NSObject+RACDescription.h>

@implementation DPHomeBannerViewPage
@synthesize rac_prepareForReuseSignal = _rac_prepareForReuseSignal;
@synthesize imageView = _imageView;

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (RACSignal *)rac_prepareForReuseSignal {
    if (!_rac_prepareForReuseSignal) {
        _rac_prepareForReuseSignal = [[[self
            rac_signalForSelector:@selector(prepareForReuse)]
            mapReplace:RACUnit.defaultUnit]
            setNameWithFormat:@"%@ -rac_prepareForReuseSignal", self.rac_description];
    }
	return _rac_prepareForReuseSignal;
}
@end
