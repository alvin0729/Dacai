//
//  DPSecurityCenterInfoViewController.h
//  Jackpot
//
//  Created by sxf on 15/8/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VerPhoneTypeVC) {
    verPhoneTypeVCPhone,//手机认证页面
    verPhoneTypeVCForChangeBank,//修改提款银行卡页面
    verPhoneTypeVCForLogin,//找回登录密码
};

typedef NS_ENUM(NSInteger, newPhoneTypeVC) {
    newPhoneTypeFromOldPhone,//旧手机验证页面进入
    newPhoneTypeFromVerPhone,//手机设置页面进入
    newPhoneTypeFromLosePhone,//验证身份信息进入
};
//验证旧手机(手机认证/找回登录密码/修改提款信息)
@interface DPTestOldPhoneViewController : UIViewController

@property(nonatomic,assign)VerPhoneTypeVC vcType;
@end

//绑定新手机
@interface DPBindingPhoneViewController : UIViewController

@property(nonatomic,copy)NSString *token;
@property(nonatomic,assign)newPhoneTypeVC vcType;
@end

//手机号码已丢失的情况下
@interface DPLosePhoneViewController : UIViewController

@end


//修改登录密码/修改支付密码
@interface DPChangeLoginPassWordViewController : UIViewController

@property(nonatomic,assign)NSInteger pageType; //0:登录  1:支付
@end

//设置登录密码/修改密码
@interface DPSetLoginPassWordViewController : UIViewController

@property(nonatomic,assign)NSInteger pageType; //0:登录  1:支付  2:直接设置登录密码
@property(nonatomic,copy)NSString *token;
@property(nonatomic,assign)BOOL isForPay;//从付款确认页面进来的
@property(nonatomic,copy)NSString *phoneNumber;//手机号码
@end

