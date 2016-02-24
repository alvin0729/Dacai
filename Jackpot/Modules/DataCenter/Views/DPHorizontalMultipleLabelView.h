//
//  DPHorizontalMultipleLabelView.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPBorderDirection) {
    DPBorderDirectionNone       = 0,
    DPBorderDirectionTop        = 1 << 0,
    DPBorderDirectionBottom     = 1 << 1,
    DPBorderDirectionLeft       = 1 << 2,
    DPBorderDirectionRight      = 1 << 3,
};

@interface DPHorizontalMultipleLabelView : UIView
@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, assign) BOOL showSeparator;

@property (nonatomic, copy) NSArray *widths;
@property (nonatomic, copy) NSArray *texts;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSTextAlignment alignment;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) DPBorderDirection direction;
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  改变单个文字颜色
 *
 *  @param index 数组中的位置
 *  @param color 颜色
 */
-(void)changeTexColorWithIndex:(NSInteger)index color:(UIColor*)color ;
@end
