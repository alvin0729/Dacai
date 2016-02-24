//
//  DPTrendView.m
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTrendView.h"

#define kTopTag     1000
#define kLeftTag    1001
#define kCenterTag  1002

@interface DPTrendView () <UIScrollViewDelegate> {
    
}
@property (nonatomic, strong, readonly) UIScrollView *leftScroll;
@property (nonatomic, strong, readonly) UIScrollView *topScroll;
@property (nonatomic, strong, readonly) UIScrollView *centerScroll;

@property (nonatomic, strong, readonly) UIImageView *leftView;
@property (nonatomic, strong, readonly) UIImageView *topView;
@property (nonatomic, strong, readonly) UIImageView *centerView;

@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat leftWidth;
@property (nonatomic, assign) CGFloat centerWidth;
@property (nonatomic, assign) CGFloat centerHeight;

@property (nonatomic, strong, readonly) UILabel *waitDrawLabel; // 开奖号码 - 等待开奖
@property (nonatomic, strong, readonly) UILabel *waitStatLabel; // 数据统计 - 等待开奖
@end

@implementation DPTrendView
@synthesize waitStype = _waitStype;
@synthesize waitLabelColor = _waitLabelColor;
@dynamic offset;

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
        [self setRowHeight:25];
        [self setWaitStype:DPTrendWaitStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = MAX(0, CGRectGetWidth(self.frame) - _leftWidth);
    CGFloat height = MAX(0, CGRectGetHeight(self.frame) - _topHeight);
    
    _topScroll.frame = CGRectMake(_leftWidth, 0, width, _topHeight);
    _leftScroll.frame = CGRectMake(0, _topHeight, _leftWidth, height);
    _centerScroll.frame = CGRectMake(_leftWidth, _topHeight, width, height);
    
    // 图片大小匹配时自动滚屏到指定位置
    if (_centerImage.dp_height == _leftImage.dp_height &&
        _centerImage.dp_width == _topImage.dp_width) {
        _centerScroll.contentOffset = CGPointMake(0, _centerScroll.contentSize.height - CGRectGetHeight(_centerScroll.bounds));
        _leftScroll.contentOffset = CGPointMake(0, _centerScroll.contentSize.height - CGRectGetHeight(_centerScroll.bounds));
    }

}

- (void)reloadData {
//    DPAssert(self.centerImage.dp_height == self.leftImage.dp_height);
//    DPAssert(self.centerImage.dp_width == self.topImage.dp_width);
//    DPAssert([[UIScreen mainScreen] scale] == self.topImage.scale);
    
    CGFloat scale = self.centerImage ? self.centerImage.scale : 2.0;
    
    _topHeight = self.topImage.dp_height / scale;
    _leftWidth = self.leftImage.dp_width / scale;
    _centerWidth = MAX(self.centerImage.dp_width, self.topImage.dp_width) / scale;
    _centerHeight = MAX(self.centerImage.dp_height, self.leftImage.dp_height) / scale;
    
    _topView.frame = CGRectMake(0, 0, _centerWidth, _topHeight);
    _leftView.frame = CGRectMake(0, 0, _leftWidth, _centerHeight);
    _centerView.frame = CGRectMake(0, 0, _centerWidth, _centerHeight);
    
    _topView.image = self.topImage;
    _leftView.image = self.leftImage;
    _centerView.image = self.centerImage;
    
    [_topScroll setContentSize:_topView.bounds.size];
    [_leftScroll setContentSize:_leftView.bounds.size];
    [_centerScroll setContentSize:_centerView.bounds.size];
    [_topScroll setContentOffset:CGPointZero];
    [_leftScroll setContentOffset:CGPointZero];
    [_centerScroll setContentOffset:CGPointZero];
    [self setNeedsLayout];
}

- (void)setOffset:(CGPoint)offset {
    _centerScroll.contentOffset = offset;
    _topScroll.contentOffset = CGPointMake(offset.x, 0);
    _leftScroll.contentOffset = CGPointMake(0, offset.y);
    
    [self relocationWaitViews];
}

- (CGPoint)offset {
    return _centerScroll.contentOffset;
}

#pragma mark - setter

- (void)setWaitLabelColor:(UIColor *)waitLabelColor {
    _waitLabelColor = waitLabelColor;
    
    self.waitDrawLabel.textColor = waitLabelColor;
    self.waitStatLabel.textColor = waitLabelColor;
}

- (void)setWaitStype:(DPTrendWaitStyle)waitStype {
    _waitStype = waitStype;
    
    [_waitStatLabel removeFromSuperview];
    [_waitDrawLabel removeFromSuperview];
    
    switch (self.waitStype) {
        case DPTrendWaitStyleAll:
            [_centerScroll addSubview:_waitStatLabel];
        case DPTrendWaitStyleNumber:
            [_centerScroll addSubview:_waitDrawLabel];
            break;
        default:
            break;
    }
    [self relocationWaitViews];
}

- (void)relocationWaitViews {
    switch (self.waitStype) {
        case DPTrendWaitStyleAll:
            [_waitStatLabel setFrame:CGRectMake(_centerScroll.contentOffset.x,
                                                _centerScroll.contentSize.height - self.rowHeight * 4,
                                                CGRectGetWidth(_centerScroll.frame),
                                                self.rowHeight * 4)];
        case DPTrendWaitStyleNumber:
            [_waitDrawLabel setFrame:CGRectMake(_centerScroll.contentOffset.x,
                                                _centerScroll.contentSize.height - self.rowHeight * 5,
                                                CGRectGetWidth(_centerScroll.frame),
                                                self.rowHeight)];
            break;
        default:
            break;
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == kCenterTag) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(trendView:offset:)]) {
            [self.delegate trendView:self offset:scrollView.contentOffset];
        }
    }
    
    if (!scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating) {
        return;
    }
    
    [self relocationWaitViews];
    
    switch (scrollView.tag) {
        case kTopTag:
            _centerScroll.contentOffset = CGPointMake(scrollView.contentOffset.x, _centerScroll.contentOffset.y);
            break;
        case kLeftTag:
            _centerScroll.contentOffset = CGPointMake(_centerScroll.contentOffset.x, scrollView.contentOffset.y);
            break;
        case kCenterTag:
            _topScroll.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            _leftScroll.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (void)setup {
    _topHeight = 0;
    _leftWidth = 0;
    _centerWidth = 0;
    _centerHeight = 0;
    
    _topScroll = [[UIScrollView alloc] init];
    _topScroll.showsVerticalScrollIndicator = NO;
    _topScroll.showsHorizontalScrollIndicator = NO;
    _topScroll.delegate = self;
    _topScroll.bounces = NO;
    _topScroll.tag = kTopTag;
    
    _leftScroll = [[UIScrollView alloc] init];
    _leftScroll.showsVerticalScrollIndicator = NO;
    _leftScroll.showsHorizontalScrollIndicator = NO;
    _leftScroll.delegate = self;
    _leftScroll.bounces = NO;
    _leftScroll.tag = kLeftTag;
    
    _centerScroll = [[UIScrollView alloc] init];
    _centerScroll.showsVerticalScrollIndicator = NO;
    _centerScroll.showsHorizontalScrollIndicator = NO;
    _centerScroll.delegate = self;
    _centerScroll.bounces = NO;
    _centerScroll.tag = kCenterTag;
    
    _waitDrawLabel = [[UILabel alloc] init];
    _waitDrawLabel.text = @"等待开奖...";
    _waitDrawLabel.textAlignment = NSTextAlignmentCenter;
    _waitDrawLabel.backgroundColor = [UIColor clearColor];
    _waitDrawLabel.textColor = [UIColor dp_flatBlackColor];
    _waitDrawLabel.font = [UIFont dp_systemFontOfSize:12];
    
    _waitStatLabel = [[UILabel alloc] init];
    _waitStatLabel.text = @"等待开奖后更新";
    _waitStatLabel.textAlignment = NSTextAlignmentCenter;
    _waitStatLabel.backgroundColor = [UIColor clearColor];
    _waitStatLabel.textColor = [UIColor dp_flatBlackColor];
    _waitStatLabel.font = [UIFont dp_systemFontOfSize:12];
    
    _topView = [[UIImageView alloc] init];
    _leftView = [[UIImageView alloc] init];
    _centerView = [[UIImageView alloc] init];
    
    [self addSubview:_topScroll];
    [self addSubview:_leftScroll];
    [self addSubview:_centerScroll];
    [_topScroll addSubview:_topView];
    [_leftScroll addSubview:_leftView];
    [_centerScroll addSubview:_centerView];
}

@end
