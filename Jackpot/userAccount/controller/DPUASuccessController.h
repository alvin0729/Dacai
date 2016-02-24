//
//  DPReChangeSuccessController.h
//  Jackpot
//
//  Created by mu on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DPUASuccessController : UIViewController
/**
 *  成功图标
 */
@property (nonatomic, strong) UIImageView *successIcon;
/**
 *  成功文案
 */
@property (nonatomic, strong) UILabel *successLabel;
/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

- (void)btnTapped;
@end
