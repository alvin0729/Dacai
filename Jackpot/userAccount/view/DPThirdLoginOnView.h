//
//  DPThirdLoginOnView.h
//  Jackpot
//
//  Created by mu on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  第三方登录 sxf

#import <UIKit/UIKit.h>
typedef void (^loginBtnTappedBlock)(UIButton *btn);
@interface DPThirdLoginOnView : UIView
/**
 *  items
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  btnBlock
 */
@property (nonatomic, copy) loginBtnTappedBlock btnBlock;

/**
 *  来自登录页面
 */
@property (nonatomic, assign) BOOL fromLogInVC;
@end
