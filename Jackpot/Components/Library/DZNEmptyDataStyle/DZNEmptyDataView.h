//
//  DZNEmptyDataView.h
//  Jackpot
//
//  Created by WUFAN on 15/10/28.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DZNEmptyDataViewType) {
    DZNEmptyDataViewTypeNoData,
    DZNEmptyDataViewTypeFailure,
    DZNEmptyDataViewTypeNoNetwork,
};

@interface DZNEmptyDataView : UIView <NSCopying>
@property (nonatomic, assign) BOOL requestSuccess;
@property (nonatomic, assign) BOOL showButtonForNoData;
@property (nonatomic, assign, readonly) DZNEmptyDataViewType viewType;

@property (nonatomic, strong) UIImage *imageForNoData;
@property (nonatomic, strong) UIImage *imageForFailure;
@property (nonatomic, strong) UIImage *imageForNoNetwork;

@property (nonatomic, copy) NSString *textForNoData;
@property (nonatomic, copy) NSString *textForFailure;
@property (nonatomic, copy) NSString *textForNoNetwork;

@property (nonatomic, copy) NSAttributedString *attrTextForNoData;
@property (nonatomic, copy) NSAttributedString *attrTextForFailure;
@property (nonatomic, copy) NSAttributedString *attrTextForNoNetwork;

@property (nonatomic, copy) NSString *buttonTitleForNoData;
@property (nonatomic, copy) NSString *buttonTitleForFailure;
@property (nonatomic, copy) NSString *buttonTitleForNoNetwork;

@property (nonatomic, strong) UIImage *buttonBgImageForNoData;
@property (nonatomic, strong) UIColor *buttonTextColorForNoData;
@property (nonatomic, assign) CGFloat textToImageMarginForNoData;
@property (nonatomic, assign) CGFloat buttonToTextMarginForNoData;
@property (nonatomic, copy) void(^buttonTappedEvent)(DZNEmptyDataViewType type);

+ (instancetype)emptyDataView;
@end

@interface UIScrollView (EmptyDataNetwork)
@property (nonatomic, strong) DZNEmptyDataView *emptyDataView;
@property (nonatomic, assign, readonly, getter=isEmptyDataViewVisible) BOOL emptyDataViewVisible;
@end
