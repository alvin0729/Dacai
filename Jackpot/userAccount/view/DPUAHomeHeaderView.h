//
//  DPUAHomeHeaderView.h
//  Jackpot
//
//  Created by mu on 15/8/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//   我的彩票头部
#import <UIKit/UIKit.h>
typedef void (^iconTappedBlock)();
typedef void (^fundTappedBlock)();
typedef void (^redGiftTappedBlock)();
@interface DPUAHomeHeaderView : UIView
@property (nonatomic, strong) UIImageView *iconImage;//头像
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *fundsValueLab;//资金
@property (nonatomic, strong) UILabel *redGiftValueLab;//红包
@property (nonatomic, strong) MASConstraint *fundsValueWidthConstraint;
/**
 *  头像点击事件
 */
@property (nonatomic, copy) iconTappedBlock iconTap;
/**
 *  资金明细点击事件
 */
@property (nonatomic, copy) fundTappedBlock fundTap;
/**
 *  红包明细点击事件
 */
@property (nonatomic, copy) redGiftTappedBlock redGiftTap;
@end
