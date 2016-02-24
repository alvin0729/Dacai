//
//  DPHLUserHeaderView.h
//  Jackpot
//
//  Created by mu on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHLObject.h"
@interface DPHLUserHeaderView : UIView
/**
 *  用户头像
 */
@property (nonatomic, strong) UIImageView *userIcon;
/**
 *  用户名
 */
@property (nonatomic, strong) UILabel *userNameLabel;
/**
 *  用户等级背景图片
 */
@property (nonatomic, strong) UIImageView *userLVBgImage;
/**
 *  用户等级
 */
@property (nonatomic, strong) UILabel *userLVLabel;
/**
 *  用户粉丝数
 */
@property (nonatomic, strong) UILabel *userfansLabel;
/**
 *  用户盈利率
 */
@property (nonatomic, strong) UILabel *userAwardRateLabel;
/**
 *  用户关注按钮
 */
@property (nonatomic, strong) UIButton *focusBtn;
/**
 *  近7天盈利率
 */
@property (nonatomic, strong) UILabel *lastWeekAwardRateLabel;
/**
 *  近30天盈利率
 */
@property (nonatomic, strong) UILabel *lastWeekWinRateLabel;
/**
 *  用户简介
 */
@property (nonatomic, strong) UITextField *userDescribText;
/**
 *  底部分隔线
 */
@property (nonatomic, strong) UIView *bottomLine;
/**
 *  用户简介修改图标
 */
@property (nonatomic, strong) UIImageView *penImage;
//data
/**
 *  用户标签数组（字符串）
 */
@property (nonatomic, strong) NSMutableArray *markTitleArray;
/**
 *  表头对应的模型对象
 */
@property (nonatomic, strong) DPHLObject *object;
@end
