//
//  DPBetToggleControl.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  竞技彩投注按钮
//

#import <UIKit/UIKit.h>

@interface DPBetToggleControl : UIControl

@property (nonatomic, strong) NSString *titleText;//玩法类型
@property (nonatomic, strong) NSString *oddsText;//玩法赔率

@property (nonatomic, strong) UIColor *titleColor;//字体颜色
@property (nonatomic, strong) UIColor *oddsColor;

@property (nonatomic, strong) UIColor *normalBgColor;//背景普通颜色
@property (nonatomic, strong) UIColor *selectedBgColor;//背景选中颜色

@property (nonatomic, strong) UIFont *titleFont;//字体大小
@property (nonatomic, strong) UIFont *oddsFont;

@property (nonatomic, strong) UIImage *normalImage;//普通图片
@property (nonatomic, strong) UIImage *selectedImage;//选中图片

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) BOOL showBorderWhenSelected;//展示边框

@property(nonatomic,strong) UIColor *selectedColor;

+ (instancetype)horizontalControl;//左右文字
+ (instancetype)horizontalControl2; // 上下单双
+ (instancetype)verticalControl;//上下文字
+ (instancetype)horizontalControlForBasket;//篮球投注页面


@end
