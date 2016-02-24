//
//  DPMemberManager.h
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DPSharedMemberManager   [DPMemberManager sharedInstance]

@interface DPMemberManager : NSObject
@property (nonatomic, assign, readonly) BOOL isLogin;//是否登录
@property (nonatomic, copy, readonly) NSString *nickName;//用户昵称
@property (nonatomic, copy, readonly) NSString *userName;//用户名
@property (nonatomic, copy, readonly) NSString *userId;//用户id

@property (nonatomic, strong, readonly) UIImage *iconImage;//图标
@property (nonatomic, strong) NSString *iconImageURL;//图标地址

@property (nonatomic, copy) NSString *loginTime;//登录次数
@property (nonatomic, assign, getter=isBangdingPhoneNum) BOOL bangdingPhoneNum; // 是否绑定手机
@property (nonatomic, assign, getter=isBetOpen) BOOL betOpen; // 是否开通服务

+ (DPMemberManager *)sharedInstance;

/**
 *  保存登录信息  sxf
 *
 *  @param userName  用户名字
 *  @param nickName  用户昵称
 *  @param userId    用户id
 *  @param token     token
 *  @param secureKey 通信密钥
 */
- (void)loginWithName:(NSString *)userName
             nickName:(NSString *)nickName
               userId:(NSString *)userId
         sessionToken:(NSString *)token
            secureKey:(NSString *)secureKey
     bangdingPhoneNum:(BOOL)bangdingPhoneNum
              betOpen:(BOOL)betOpen;

//退出登录
- (void)logout;

/**
 *  修改昵称
 *
 *  @param nickName [in]昵称
 */
- (void)resetNickName:(NSString *)nickName;

@end
