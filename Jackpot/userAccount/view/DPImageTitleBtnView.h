//
//  DPImageTitleView.h
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DPImageTitleBtnView : UIView
/**
 *  icon
 */
@property (nonatomic, strong) UIImageView *iconImage;
/**
 *  title
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  btn
 */
@property (nonatomic, strong) UIButton *btn;
/**
 *  图片到顶部的距离
 */
@property (nonatomic, strong) MASConstraint *iconToTopMagin;
/**
 *  文案到图片的距离
 */
@property (nonatomic, strong) MASConstraint *labelToImageMagin;
/**
 *  按钮到文案的距离
 */
@property (nonatomic, strong) MASConstraint *btnToLabelMagin;
@end
