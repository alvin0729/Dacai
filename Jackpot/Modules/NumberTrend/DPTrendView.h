//
//  DPTrendView.h
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  走势图主视图

#import <UIKit/UIKit.h>

// 等待开奖
typedef NS_ENUM(NSInteger, DPTrendWaitStyle) {
    DPTrendWaitStyleNone,   // 不显示
    DPTrendWaitStyleNumber, // 仅开奖号码
    DPTrendWaitStyleAll,    // 开奖号码和数据统计
};

@protocol DPTrendViewDelegate;

@interface DPTrendView : UIView
@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *centerImage;
@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, strong) UIColor *waitLabelColor;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) DPTrendWaitStyle waitStype;

@property (nonatomic, weak) id<DPTrendViewDelegate> delegate;

- (void)reloadData;

@end

@protocol DPTrendViewDelegate <NSObject>
@optional
- (void)trendView:(DPTrendView *)trendView offset:(CGPoint)offset;

@end

