//
//  DZNEmptyDataStyle.h
//  Jackpot
//
//  Created by WUFAN on 15/7/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

// Builder Pattern
@interface DZNEmptyDataStyle : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

// DataSource
@property (nonatomic, strong) NSAttributedString *titleText;
@property (nonatomic, copy) NSAttributedString *(^titleForEmptyDataSetBlock)(UIScrollView *scrollView);

@property (nonatomic, strong) NSAttributedString *descriptionText;
@property (nonatomic, copy) NSAttributedString *(^descriptionForEmptyDataSetBlock)(UIScrollView *scrollView);

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) UIImage *(^imageForEmptyDataSetBlock)(UIScrollView *scrollView);

@property (nonatomic, strong) UIColor *imageTintColor;
@property (nonatomic, copy) UIColor *(^imageTintColorForEmptyDataSetBlock)(UIScrollView *scrollView);

@property (nonatomic, strong) NSAttributedString *buttonTitle;
@property (nonatomic, copy) NSAttributedString *(^buttonTitleForEmptyDataSetBlock)(UIScrollView *scrollView, UIControlState state);

@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, copy) UIImage *(^buttonImageForEmptyDataSetBlock)(UIScrollView *scrollView, UIControlState state);

@property (nonatomic, strong) UIImage *buttonBackgroundImage;
@property (nonatomic, copy) UIImage *(^buttonBackgroundImageForEmptyDataSetBlock)(UIScrollView *scrollView, UIControlState state);

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, copy) UIColor *(^backgroundColorForEmptyDataSetBlock)(UIScrollView *scrollView);

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) UIView *(^customViewForEmptyDataSetBlock)(UIScrollView *scrollView);

/**
 *  CGFloat
 */
@property (nonatomic, assign) CGFloat verticalOffset;   // default is 0.0f
@property (nonatomic, copy) CGFloat (^verticalOffsetForEmptyDataSetBlock)(UIScrollView *scrollView);

/**
 *  CGFloat
 */
@property (nonatomic, assign) CGFloat spaceHeight;      // default is 0.0f
@property (nonatomic, copy) CGFloat (^spaceHeightForEmptyDataSetBlock)(UIScrollView *scrollView);

// Delegate

/**
 *  BOOL
 */
@property (nonatomic, assign) BOOL shouldDisplay;       // default is NO
@property (nonatomic, copy) BOOL (^shouldDisplayBlock)(UIScrollView *scrollView);

/**
 *  BOOL
 */
@property (nonatomic, assign) BOOL allowTouch;          // default is NO
@property (nonatomic, copy) BOOL (^allowTouchBlock)(UIScrollView *scrollView);

/**
 *  BOOL
 */
@property (nonatomic, assign) BOOL allowScroll;         // default is YES
@property (nonatomic, copy) BOOL (^allowScrollBlock)(UIScrollView *scrollView);

// Event
@property (nonatomic, copy) void (^didTapViewBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didTapButtonBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^willAppearBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didAppearBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^willDisappearBlock)(UIScrollView *scrollView);
@property (nonatomic, copy) void (^didDisappearBlock)(UIScrollView *scrollView);

+ (instancetype)style;

@end
