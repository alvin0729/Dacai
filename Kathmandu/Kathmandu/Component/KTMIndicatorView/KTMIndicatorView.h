//
//  KTMIndicatorView.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTMIndicatorView : UIView
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

- (void)startAnimating NS_REQUIRES_SUPER;
- (void)stopAnimating NS_REQUIRES_SUPER;
@end

@interface KTMIndicatorView (KTMIndicatorViewCreation)
+ (instancetype)circleView;
@end
