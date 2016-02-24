//
//  DZNEmptyDataStyle+CustomStyle.m
//  Jackpot
//
//  Created by wufan on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DZNEmptyDataStyle+CustomStyle.h"
#import <objc/runtime.h>

const static void *kEmptyListTypeKey = &kEmptyListTypeKey;
const static void *kRequestSuccessKey = &kRequestSuccessKey;
const static void *kNoDataImageKey = &kNoDataImageKey;
const static void *kFailureImageKey = &kFailureImageKey;
const static void *kNoNetworkImageKey = &kNoNetworkImageKey;
const static void *kNoDataTitleKey = &kNoDataTitleKey;
const static void *kFailureTitleKey = &kFailureTitleKey;
const static void *kNoNetworkTitleKey = &kNoNetworkTitleKey;
const static void *kNoDataButtonTitleKey = &kNoDataButtonTitleKey;
const static void *kFailureButtonTitleKey = &kFailureButtonTitleKey;
const static void *kNoNetworkButtonTitleKey = &kNoNetworkButtonTitleKey;

@interface DZNEmptyDataStyle ()
@property (nonatomic, assign, setter=ctm_setEmptyListType:) DZNEmptyListType ctm_emptyListType;
@end

@implementation DZNEmptyDataStyle (Custom)

+ (instancetype)ctm_style {
    DZNEmptyDataStyle *style = [[DZNEmptyDataStyle alloc] init];
    style.allowScroll = YES;
    style.allowTouch = YES;
    @weakify(style);
    style.imageForEmptyDataSetBlock = ^UIImage *(UIScrollView *scrollView) {
        @strongify(style);
        switch (style.ctm_emptyListType) {
            case DZNEmptyListTypeNoNetwork:
                return style.ctm_noNetworkImage;
            case DZNEmptyListTypeNoData:
                return style.ctm_noDataImage;
            case DZNEmptyListTypeFailure:
                return style.ctm_failureImage;
            default:
                return nil;
        }
    };
    style.titleForEmptyDataSetBlock = ^NSAttributedString *(UIScrollView *scrollView) {
        @strongify(style);
        switch (style.ctm_emptyListType) {
            case DZNEmptyListTypeNoData:
                return style.ctm_noDataTitle;
            case DZNEmptyListTypeFailure:
                return style.ctm_failureTitle;
            case DZNEmptyListTypeNoNetwork:
                return style.ctm_noNetworkTitle;
            default:
                return nil;
        }
    };
    style.buttonTitleForEmptyDataSetBlock = ^NSAttributedString *(UIScrollView *scrollView, UIControlState state) {
        @strongify(style);
        switch (style.ctm_emptyListType) {
            case DZNEmptyListTypeNoData:
                return style.ctm_noDataButtonTitle;
            case DZNEmptyListTypeFailure:
                return style.ctm_failureButtonTitle;
            case DZNEmptyListTypeNoNetwork:
                return style.ctm_noNetworkButtonTitle;
            default:
                return nil;
        }
    };
    style.buttonBackgroundImageForEmptyDataSetBlock = ^UIImage *(UIScrollView *scrollView, UIControlState state) {
        @strongify(style);
        // 绘制图片
        
        CGRect rect = CGRectMake(0, 0, 300, 40);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor dp_flatRedColor] CGColor]);
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:5] addClip];
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        switch (style.ctm_emptyListType) {
            case DZNEmptyListTypeNoData:
                return style.ctm_noDataButtonTitle ? image : nil;
            case DZNEmptyListTypeFailure:
                return style.ctm_failureButtonTitle ? image : nil;
            case DZNEmptyListTypeNoNetwork:
                return style.ctm_noNetworkButtonTitle ? image : nil;
            default:
                return nil;
        }
        return nil;
    };
    return style;
}

#pragma mark - getter, setter


- (UIImage *)ctm_noDataImage {
    return objc_getAssociatedObject(self, kNoDataImageKey);
}

- (void)ctm_setNoDataImage:(UIImage *)noDataImage {
    objc_setAssociatedObject(self, kNoDataImageKey, noDataImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)ctm_failureImage {
    return objc_getAssociatedObject(self, kFailureImageKey);
}

- (void)ctm_setFailureImage:(UIImage *)failureImage {
    objc_setAssociatedObject(self, kFailureImageKey, failureImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)ctm_noNetworkImage {
    return objc_getAssociatedObject(self, kNoNetworkImageKey);
}

- (void)ctm_setNoNetworkImage:(UIImage *)noNetworkImage {
    objc_setAssociatedObject(self, kNoNetworkImageKey, noNetworkImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_noDataTitle {
    return objc_getAssociatedObject(self, kNoDataTitleKey);
}

- (void)ctm_setNoDataTitle:(NSAttributedString *)noDataTitle {
    objc_setAssociatedObject(self, kNoDataTitleKey, noDataTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_failureTitle {
    return objc_getAssociatedObject(self, kFailureTitleKey);
}

- (void)ctm_setFailureTitle:(NSAttributedString *)failureTitle {
    objc_setAssociatedObject(self, kFailureTitleKey, failureTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_noNetworkTitle {
    return objc_getAssociatedObject(self, kNoNetworkTitleKey);
}

- (void)ctm_setNoNetworkTitle:(NSAttributedString *)noNetworkTitle {
    objc_setAssociatedObject(self, kNoNetworkTitleKey, noNetworkTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_noDataButtonTitle {
    return objc_getAssociatedObject(self, kNoDataButtonTitleKey);
}

- (void)ctm_setNoDataButtonTitle:(NSAttributedString *)noDataButtonTitle {
    objc_setAssociatedObject(self, kNoDataButtonTitleKey, noDataButtonTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_failureButtonTitle {
    return objc_getAssociatedObject(self, kFailureButtonTitleKey);
}

- (void)ctm_setFailureButtonTitle:(NSAttributedString *)failureButtonTitle {
    objc_setAssociatedObject(self, kFailureButtonTitleKey, failureButtonTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)ctm_noNetworkButtonTitle {
    return objc_getAssociatedObject(self, kNoNetworkButtonTitleKey);
}

- (void)ctm_setNoNetworkButtonTitle:(NSAttributedString *)noNetworkButtonTitle {
    objc_setAssociatedObject(self, kNoNetworkButtonTitleKey, noNetworkButtonTitle.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DZNEmptyListType)ctm_emptyListType {
    return [objc_getAssociatedObject(self, kEmptyListTypeKey) integerValue];
}

- (void)ctm_setEmptyListType:(DZNEmptyListType)emptyListType {
    objc_setAssociatedObject(self, kEmptyListTypeKey, @(emptyListType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ctm_requestSuccess {
    return [objc_getAssociatedObject(self, kRequestSuccessKey) integerValue];
}

- (void)ctm_setRequestSuccess:(BOOL)requestSuccess {
    if (requestSuccess) {
        self.ctm_emptyListType = DZNEmptyListTypeNoData;
    } else {
        AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            self.ctm_emptyListType = DZNEmptyListTypeFailure;
        } else {
            self.ctm_emptyListType = DZNEmptyListTypeNoNetwork;
        }
    }
    objc_setAssociatedObject(self, kRequestSuccessKey, @(requestSuccess), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation DZNEmptyDataStyle (CustomAddition)

+ (instancetype)ctm_listStyle {
    DZNEmptyDataStyle *style = [self ctm_style];
    style.ctm_noNetworkImage = dp_CommonImage(@"noNetWorkImg.png") ;
    style.ctm_noDataImage = style.ctm_failureImage = dp_CommonImage(@"noDataFace.png");
    style.ctm_noDataTitle = [[NSAttributedString alloc] initWithString:@"暂无数据"];
    style.ctm_noNetworkTitle = [[NSAttributedString alloc] initWithString:@"无网络"];
    style.ctm_failureButtonTitle = [[NSAttributedString alloc] initWithString:@"重试"];
    style.ctm_noNetworkButtonTitle = [[NSAttributedString alloc] initWithString:@"设置"];
    return style;
}

@end