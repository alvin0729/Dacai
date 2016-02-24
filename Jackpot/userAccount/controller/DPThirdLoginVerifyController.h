//
//  DPThirdLoginVerifyController.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  第三方登录绑定手机页面

#import <UIKit/UIKit.h>
#import "DPUARequestData.h"
@interface DPThirdLoginVerifyController : UIViewController
/**
 *  入参：第三方登录/注册接口
 */
@property (nonatomic, strong) PBMThirdLogOnItem *thirdLogonItem;
@end
