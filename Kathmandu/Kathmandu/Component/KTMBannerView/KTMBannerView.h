//
//  KTMBannerView.h
//  Kathmandu
//
//  Created by WUFAN on 15/11/16.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTMBannerViewDelegte;
@protocol KTMBannerViewDataSource;

@interface KTMBannerViewPage : UIView
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)init __attribute__((unavailable("Use initWithReuseIdentifier: instead.")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("Use initWithReuseIdentifier: instead.")));
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;
@end

@interface KTMBannerView : UIView
@property (nonatomic, assign) BOOL infiniteScrollingEnable;     // default is YES
@property (nonatomic, assign) BOOL showPageControl;             // default is YES
@property (nonatomic, assign) BOOL autoMoving;                  // default is YES
@property (nonatomic, assign) CGFloat duration;                 // default is 5.0f
@property (nonatomic, assign) CGFloat bottomMargin;             // default is 0.0f

@property (nonatomic, weak) id<KTMBannerViewDelegte> delegate;
@property (nonatomic, weak) id<KTMBannerViewDataSource> dataSource;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) NSInteger numberOfPages;
@property (nonatomic, strong, readonly) NSArray *visiblePages;

- (void)registerClass:(Class)cellClass forPageReuseIdentifier:(NSString *)identifier;
- (__kindof KTMBannerViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier;
- (__kindof KTMBannerViewPage *)pageAtIndex:(NSInteger)index;
- (NSInteger)indexForPage:(KTMBannerViewPage *)page;

- (void)scrollToPageAtIndex:(NSInteger)index;
- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToPageAtIndex:(NSInteger)index forward:(BOOL)forward animated:(BOOL)animated;

- (void)reloadData;
@end

@protocol KTMBannerViewDelegte <NSObject>
@optional
- (void)bannerView:(KTMBannerView *)bannerView didTappedAtIndex:(NSInteger)index;
@end

@protocol KTMBannerViewDataSource <NSObject>
@required
- (NSInteger)numberOfPageInBannerView:(KTMBannerView *)bannerView;
- (KTMBannerViewPage *)bannerView:(KTMBannerView *)bannerView pageAtIndex:(NSInteger)index;
@end