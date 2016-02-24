//
//  DPPayPasswordView.h
//  Jackpot
//
//  Created by mu on 15/10/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^forgetPasswordBlock)();
typedef void (^surePasswordBlock)(NSString *passWord);
@interface DPPayPasswordView : UIView
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  密码输入框
 */
@property (nonatomic, strong) UITextField *passwordText;
/**
 *  忘记密码点击
 */
@property (nonatomic, copy) forgetPasswordBlock forgetPasswordTapped;
/**
 *  确认密码点击
 */
@property (nonatomic, copy) surePasswordBlock surePasswordTapped;

@end
