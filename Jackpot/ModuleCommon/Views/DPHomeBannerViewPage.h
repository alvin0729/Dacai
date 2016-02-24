//
//  DPHomeBannerViewPage.h
//  Jackpot
//
//  Created by WUFAN on 15/11/20.
//  Copyright © 2015年 dacai. All rights reserved.
//  轮播图

#import <Kathmandu/Kathmandu.h>

@class RACSignal;
@interface DPHomeBannerViewPage : KTMBannerViewPage
@property (nonatomic, strong, readonly) UIImageView *imageView;//图片

/// A signal which will send a RACUnit whenever -prepareForReuse is invoked upon
/// the receiver.
///
/// Examples
///
///  [[[self.cancelButton
///     rac_signalForControlEvents:UIControlEventTouchUpInside]
///     takeUntil:self.rac_prepareForReuseSignal]
///     subscribeNext:^(UIButton *x) {
///         // do other things
///     }];
@property (nonatomic, strong, readonly) RACSignal *rac_prepareForReuseSignal;
@end
