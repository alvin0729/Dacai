//
//  DZNEmptyDataStyle+CustomStyle.h
//  Jackpot
//
//  Created by wufan on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DZNEmptyDataStyle.h"

typedef NS_ENUM(NSInteger, DZNEmptyListType) {
    DZNEmptyListTypeNoData,
    DZNEmptyListTypeFailure,
    DZNEmptyListTypeNoNetwork,
};

// 自定义无数据样式
@interface DZNEmptyDataStyle (Custom)
/**
 *  NoData: 无数据, 有网络并且网络请求成功,
 *  Failure: 网络请求失败, 有网络
 *  NoNetwork: 无网络
 */

/**
 *  无数据样式
 */
@property (nonatomic, assign, readonly) DZNEmptyListType ctm_emptyListType;

/**
 *  是否请求成功
 */
@property (nonatomic, assign, setter=ctm_setRequestSuccess:) BOOL ctm_requestSuccess;

/**
 *  各种状况下的样式
 */
@property (nonatomic, strong, setter=ctm_setNoDataImage:) UIImage *ctm_noDataImage;
@property (nonatomic, strong, setter=ctm_setFailureImage:) UIImage *ctm_failureImage;
@property (nonatomic, strong, setter=ctm_setNoNetworkImage:) UIImage *ctm_noNetworkImage;
@property (nonatomic, copy, setter=ctm_setNoDataTitle:) NSAttributedString *ctm_noDataTitle;
@property (nonatomic, copy, setter=ctm_setFailureTitle:) NSAttributedString *ctm_failureTitle;
@property (nonatomic, copy, setter=ctm_setNoNetworkTitle:) NSAttributedString *ctm_noNetworkTitle;
@property (nonatomic, copy, setter=ctm_setNoDataButtonTitle:) NSAttributedString *ctm_noDataButtonTitle;
@property (nonatomic, copy, setter=ctm_setFailureButtonTitle:) NSAttributedString *ctm_failureButtonTitle;
@property (nonatomic, copy, setter=ctm_setNoNetworkButtonTitle:) NSAttributedString *ctm_noNetworkButtonTitle;

// 列表构造器
+ (instancetype)ctm_style;
@end

// 具体页面
@interface DZNEmptyDataStyle (CustomAddition)
+ (instancetype)ctm_listStyle;
@end
