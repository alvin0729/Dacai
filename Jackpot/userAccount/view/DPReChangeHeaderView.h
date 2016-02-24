//
//  DPReChangeHeaderView.h
//  Jackpot
//
//  Created by mu on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DPButtonClick)(NSInteger index);

@interface DPReChangeHeaderView : UIView
/**
 *  标题文案
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  金额输入框
 */
@property (nonatomic, strong) UITextField *reChangeText;

@property (nonatomic, copy) DPButtonClick buttonClick;

@end
