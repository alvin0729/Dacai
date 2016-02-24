//
//  DPDataCenterRefreshControl.m
//  Jackpot
//
//  Created by wufan on 15/9/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterRefreshControl.h"
#import "SVActivityIndicatorView.h"


#pragma mark - DPPullToRefreshArrow

@interface DPPullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end


@implementation DPPullToRefreshArrow
@synthesize arrowColor;

- (UIColor *)arrowColor {
    if (arrowColor) return arrowColor;
    return [UIColor colorWithRed:0.91 green:0.14 blue:0.15 alpha:1]; // default Color
}

- (void)drawRect:(CGRect)rect {
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    const CGFloat height = 22;
    const CGFloat width = 6;
    
    CGFloat const *components = CGColorGetComponents(self.arrowColor.CGColor);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, components[0], components[1], components[2], components[3]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, centerX, centerY - height / 2);
    CGContextAddLineToPoint(context, centerX, centerY + height / 2);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, centerX - width, centerY + height / 2 - width);
    CGContextAddLineToPoint(context, centerX, centerY + height / 2);
    CGContextAddLineToPoint(context, centerX + width, centerY + height / 2 - width);
    CGContextStrokePath(context);
}
@end


@interface DPDataCenterRefreshControl ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SVActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) DPPullToRefreshArrow *arrow;


@end

@implementation DPDataCenterRefreshControl
@synthesize activityIndicatorView = _activityIndicatorView  ;

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.titleLabel.frame = self.bounds;
    
    
    switch (self.refreshState) {
        case DPDataCenterRefreshStateStopped:
            self.arrow.alpha = 1 ;
            [self.activityIndicatorView stopAnimating];
            [self rotateArrow:0 hide:YES];
            
            break;
             case DPDataCenterRefreshStateTriggered:
              [self rotateArrow:(float)M_PI hide:NO];

            break ;
            case DPDataCenterRefreshStateLoading:
 
            [self.activityIndicatorView startAnimating];
             [self rotateArrow:0 hide:YES];
            break ;
        default:
            break;
    }
    
     CGFloat leftViewWidth = MAX(self.arrow.bounds.size.width,self.activityIndicatorView.bounds.size.width);
    
    CGFloat margin = 10;
     CGFloat labelMaxWidth = self.bounds.size.width - margin - leftViewWidth;
    
    
    
     CGSize titleSize = [NSString dpsizeWithSting:self.titleLabel.text andFont:self.titleLabel.font
                                      andMaxSize:CGSizeMake(labelMaxWidth,self.titleLabel.font.lineHeight)];
    
    
    
     CGFloat maxLabelWidth = titleSize.width ;
    
    CGFloat totalMaxWidth;
    if (maxLabelWidth) {
        totalMaxWidth = leftViewWidth + margin + maxLabelWidth;
    } else {
        totalMaxWidth = leftViewWidth + maxLabelWidth;
    }
    
    CGFloat labelX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + leftViewWidth + margin;
    
    
        CGFloat totalHeight = titleSize.height;
        CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
        
        CGFloat titleY = minY;
        self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, titleSize.width, titleSize.height));
    
    CGFloat arrowX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + (leftViewWidth - self.arrow.bounds.size.width) / 2;
    self.arrow.frame = CGRectMake(arrowX,
                                  (self.bounds.size.height / 2) - (self.arrow.bounds.size.height / 2),
                                  self.arrow.bounds.size.width,
                                  self.arrow.bounds.size.height);
    self.activityIndicatorView.center = self.arrow.center;
 }

#pragma mark - Property (getter, setter)

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor dp_flatBlackColor];
        _titleLabel.text = @"下拉刷新...";
    }
    return _titleLabel;
}

- (BOOL)isRefreshing {
    return self.refreshState == DPDataCenterRefreshStateLoading;
}

- (void)setRefreshState:(DPDataCenterRefreshState)refreshState {
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        switch (refreshState) {
            case DPDataCenterRefreshStateStopped:
                _titleLabel.text = @"下拉刷新...";
                self.arrow.hidden = NO ;
                break;
            case DPDataCenterRefreshStateTriggered:
                _titleLabel.text = @"释放刷新...";
                self.arrow.hidden = NO ;
                break;
            case DPDataCenterRefreshStateLoading:
                _titleLabel.text = @"正在刷新...";
                self.arrow.hidden = YES ;
                break;
        }
        NSLog(@"状态发生改变, %d", (int)refreshState);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
- (SVActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[SVActivityIndicatorView alloc] initWithActivityIndicatorStyle:SVActivityIndicatorViewStyleRed];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (DPPullToRefreshArrow *)arrow {
    if(!_arrow) {
        _arrow = [[DPPullToRefreshArrow alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrow];
    }
    return _arrow;
}


- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:^(BOOL finished) {
        // fix: 响应太快造成已经完成刷新之后才执行hide从而显示状态不正确
//                self.arrow.layer.opacity = !hide;
        self.arrow.layer.opacity = self.refreshState != DPDataCenterRefreshStateLoading;
    }];
}


@end
