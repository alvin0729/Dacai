//
//  KTMBannerView.m
//  Kathmandu
//
//  Created by WUFAN on 15/11/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMBannerView.h"

const static NSInteger kWidthMultiple = 512;
const static NSInteger kRealOriginMultiple = 256;

@interface KTMBannerView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *identifierClassTable;
@property (nonatomic, strong) NSMutableDictionary *reusePagesCache;
@property (nonatomic, strong) NSMutableSet *visiblePagesSet;
@property (nonatomic, assign) NSRange visiblePageRange;
@property (nonatomic, assign, readonly) CGFloat pageWidth;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger realIndex;
@end


@interface KTMBannerViewPage ()
@property (nonatomic, assign) NSInteger realIndexInScrollView;
@end

#pragma mark - BannerView and Page Class implementation

@implementation KTMBannerView

#pragma mark - Lify cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty {
    _duration = 5.0f;
    _showPageControl = YES;
    _autoMoving = YES;
    _infiniteScrollingEnable = YES;
    _visiblePageRange = NSMakeRange(NSNotFound, 0);
    _bottomMargin = 0.0f;
    
    _identifierClassTable = [NSMutableDictionary dictionaryWithCapacity:10];
    _reusePagesCache = [NSMutableDictionary dictionaryWithCapacity:10];
    _visiblePagesSet = [NSMutableSet setWithCapacity:10];
    
    // 初始化控件
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
    
    // 单击事件
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerViewTapped:)]];
}

#pragma mark - User Interaction

- (void)bannerViewTapped:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(bannerView:didTappedAtIndex:)] && self.numberOfPages) {
        CGPoint point = [tapGesture locationInView:self.scrollView];
        NSInteger tappedIndex = -1;
        for (KTMBannerViewPage *page in self.visiblePagesSet) {
            if (CGRectContainsPoint(page.frame, point)) {
                tappedIndex = page.realIndexInScrollView % self.numberOfPages;
                break;
            }
        }
        if (tappedIndex >= 0) {
            [self.delegate bannerView:self didTappedAtIndex:tappedIndex];
        }
    }
}

#pragma mark - Override

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!CGSizeEqualToSize(frame.size, CGSizeZero)) {
        [self reloadData];
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if (!CGSizeEqualToSize(bounds.size, CGSizeZero)) {
        [self reloadData];
    }
}



#pragma mark - Internal Interface

- (void)autoSwitchToNext {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    
    if (self.duration > 0) {
        if (self.numberOfPages) {
            [self scrollToPageAtIndex:(self.currentIndex + 1) % self.numberOfPages forward:NO animated:YES];
        }
        [self performSelector:_cmd withObject:nil afterDelay:self.duration];
    }
}

/**
 *  调整 ScrollView 大小
 */
- (void)resizeScrollView {
    self.scrollView.frame = self.bounds;
    if (self.isMultipleWidth) {
        self.scrollView.contentSize = CGSizeMake(self.pageWidth * self.numberOfPages * kWidthMultiple, CGRectGetHeight(self.bounds));
    } else {
        self.scrollView.contentSize = CGSizeMake(self.pageWidth * self.numberOfPages, CGRectGetHeight(self.bounds));
    }
    
    self.scrollView.contentOffset = CGPointMake(self.realIndex * self.pageWidth, 0);
    [self scrollViewDidScroll:self.scrollView];
}

/**
 *  缓存使用过的Page
 *
 *  @param page [in]page 对象，用于将来重用
 */
- (void)cacheReusePage:(KTMBannerViewPage *)page {
    NSMutableSet *set = self.reusePagesCache[page.reuseIdentifier];
    if (!set) {
        set = [NSMutableSet setWithCapacity:10];
        self.reusePagesCache[page.reuseIdentifier] = set;
    }
    [set addObject:page];
}


#pragma mark - Public Interface

- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier {
    self.identifierClassTable[identifier] = NSStringFromClass(cellClass);
}

- (void)reloadData {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchToNext) object:nil];
    // 重置
    self.visiblePageRange = NSMakeRange(NSNotFound, 0);
    for (KTMBannerViewPage *page in self.visiblePagesSet) {
        page.hidden = YES;
        [self cacheReusePage:page];
    }
    [self.visiblePagesSet removeAllObjects];
    
    // 计算偏移
    self.numberOfPages = [self.dataSource numberOfPageInBannerView:self];
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.hidden = self.numberOfPages <= 1;
    self.currentIndex = 0;
    
    if (self.isMultipleWidth) {
        self.realIndex = kRealOriginMultiple * self.numberOfPages;
    } else {
        self.realIndex = 0;
    }
    
    [self resizeScrollView];
    
    if (self.autoMoving) {
        [self performSelector:@selector(autoSwitchToNext) withObject:nil afterDelay:_duration];
    }
    
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.numberOfPages];
    self.pageControl.frame = CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                        CGRectGetHeight(self.bounds) - self.bottomMargin - pageControlSize.height,
                                        pageControlSize.width,
                                        pageControlSize.height);
}

- (__kindof KTMBannerViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    KTMBannerViewPage *page;
    NSMutableSet *reusePagesSet = self.reusePagesCache[identifier];
    if (reusePagesSet.count) {
        page = [reusePagesSet anyObject];
        page.hidden = NO;
        [reusePagesSet removeObject:page];
    }
    if (!page) {
        Class KTMBannerViewPageClass = NSClassFromString(self.identifierClassTable[identifier]);
        if (!KTMBannerViewPageClass) {
            return nil;
        }
        page = [(KTMBannerViewPage *)[KTMBannerViewPageClass alloc] initWithReuseIdentifier:identifier];
    }
    [page prepareForReuse];
    return page;
}

- (__kindof KTMBannerViewPage *)pageAtIndex:(NSInteger)index {
    if (self.numberOfPages == 0) {
        return nil;
    }
    for (KTMBannerViewPage *page in self.visiblePagesSet) {
        if (page.realIndexInScrollView % self.numberOfPages == index) {
            return page;
        }
    }
    return nil;
}

- (NSInteger)indexForPage:(KTMBannerViewPage *)page {
    return self.numberOfPages == 0 ? NSNotFound : page.realIndexInScrollView % self.numberOfPages;
}

- (void)scrollToPageAtIndex:(NSInteger)index {
    [self scrollToPageAtIndex:index forward:NO animated:YES];
}

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self scrollToPageAtIndex:index forward:NO animated:animated];
}

- (void)scrollToPageAtIndex:(NSInteger)index forward:(BOOL)forward animated:(BOOL)animated {
    if (self.isMultipleWidth) {
        NSInteger realIndex = self.realIndex + index - self.currentIndex;
        if (forward && realIndex > self.realIndex) {
            realIndex -= self.numberOfPages;
        } else if (!forward && realIndex < self.realIndex) {
            realIndex += self.numberOfPages;
        }
        [self.scrollView setContentOffset:CGPointMake(realIndex * self.pageWidth, 0) animated:animated];
    } else {
        [self.scrollView setContentOffset:CGPointMake(index * self.pageWidth, 0) animated:animated];
    }
}

#pragma mark - Delegate
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoMoving) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchToNext) object:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoMoving) {
        [self performSelector:@selector(autoSwitchToNext) withObject:nil afterDelay:self.duration];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.numberOfPages == 0) {
        return;
    }
    
    // 到达边界处理
    if (self.isMultipleWidth && scrollView.contentSize.width > 0) {
        if (scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == (kWidthMultiple - 1) * self.pageWidth * self.numberOfPages) {
            scrollView.contentOffset = CGPointMake(self.pageWidth * kRealOriginMultiple * self.numberOfPages, 0);
            return;
        }
    }
    
    // 计算偏移
    NSInteger index = self.pageWidth == 0 ? 0 : round(scrollView.contentOffset.x / self.pageWidth);
    if (self.realIndex != index) {
        self.realIndex = index;
        self.currentIndex = self.realIndex % self.numberOfPages;
    }
    
    NSInteger begin = MAX(0, self.pageWidth == 0 ? 0 : floor(scrollView.contentOffset.x / self.pageWidth));
    NSInteger end = MAX(0, self.pageWidth == 0 ? 0 : floor((scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds)) / self.pageWidth));
    NSRange visiblePageRange = NSMakeRange(begin, end - begin + 1);
    if (!self.isMultipleWidth) {
        visiblePageRange = NSIntersectionRange(NSMakeRange(0, self.numberOfPages), visiblePageRange);
    }
    
    NSSet *visiblePageSet = self.visiblePagesSet.copy;
    for (KTMBannerViewPage *page in visiblePageSet) {
        if (!NSLocationInRange(page.realIndexInScrollView, visiblePageRange)) {
            page.hidden = YES;
            
            [self.visiblePagesSet removeObject:page];
            [self cacheReusePage:page];
        }
    }
    
    for (NSInteger i = (int)visiblePageRange.location; i < (int)(visiblePageRange.location + visiblePageRange.length); i++) {
        if (!NSLocationInRange(i, self.visiblePageRange)) {
            KTMBannerViewPage *page = [self.dataSource bannerView:self pageAtIndex:i % self.numberOfPages];
            NSAssert(page, @"page is nil!");
            page.realIndexInScrollView = i;
            page.frame = CGRectMake(i * self.pageWidth, 0, self.pageWidth, CGRectGetHeight(self.scrollView.bounds));
            [self.visiblePagesSet addObject:page];
            if (page.superview != self.scrollView) {
                [self.scrollView addSubview:page];
            }
        }
    }
    
    self.visiblePageRange = visiblePageRange;
}

#pragma mark - Property (getter, setter)

- (BOOL)isMultipleWidth {
    return self.infiniteScrollingEnable && self.numberOfPages > 1;
}

- (NSArray *)visiblePages {
    return self.visiblePagesSet.allObjects;
}

- (CGFloat)pageWidth {
    return CGRectGetWidth(self.scrollView.bounds);
}

- (void)setInfiniteScrollingEnable:(BOOL)infiniteScrollingEnable {
    if (_infiniteScrollingEnable != infiniteScrollingEnable) {
        _infiniteScrollingEnable = infiniteScrollingEnable;
        
        [self reloadData];
    }
}

- (void)setDuration:(CGFloat)duration {
    if (_duration != duration) {
        _duration = duration;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchToNext) object:nil];
        [self performSelector:@selector(autoSwitchToNext) withObject:nil afterDelay:_duration];
    }
}

- (void)setAutoMoving:(BOOL)autoMoving {
    if (_autoMoving != autoMoving) {
        _autoMoving = autoMoving;
        
        if (autoMoving) {
            [self performSelector:@selector(autoSwitchToNext) withObject:nil afterDelay:_duration];
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchToNext) object:nil];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        
        _pageControl.currentPage = _currentIndex;
    }
}

@end


@implementation KTMBannerViewPage
@synthesize contentView = _contentView;

#pragma mark - Lify cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier.copy;
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
    }
    return self;
}

#pragma mark - 

- (void)prepareForReuse {
    
}

#pragma mark - Override


#pragma mark - Property (getter, setter)


@end