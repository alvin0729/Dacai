//
//  DPMemberManager.m
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPMemberManager.h"
#import "DPMemberManager+Private.h"
#import "SSKeychain.h"
#import "DPLogOnViewController.h"

static NSString *const SessionAccountName = @"SessionAccountName";
//static NSString *const SecureKeyAccountName = @"SecureKeyAccountName";
static NSString *const MemberManagerService = @"MemberManagerService";


static NSString *const kUserToken = @"UserToken";
static NSString *const kUserName = @"UserName";
static NSString *const kUserId = @"UserId";
static NSString *const kSecureKey = @"SecureKey";
static NSString *const kNickName = @"NickName";
static NSString *const kBangdingPhoneNum = @"BangdingPhoneNum";
static NSString *const kBetOpen = @"BetOpen";

@interface DPMemberManager ()
@property (nonatomic, strong) NSDictionary *session;
@property (nonatomic, strong) UIImage *iconImage;
@end

@implementation DPMemberManager
@dynamic session;

+ (DPMemberManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static DPMemberManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[DPMemberManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self restoreSession];
    }
    return self;
}

/**
 *  登录返回数据
 *
 *  @param userName         用户名
 *  @param nickName         昵称
 *  @param userId           用户id
 *  @param token            用户token
 *  @param secureKey        通信密钥
 *  @param bangdingPhoneNum 是否绑定手机
 *  @param betOpen          是否开通服务
 */
- (void)loginWithName:(NSString *)userName
             nickName:(NSString *)nickName
               userId:(NSString *)userId
         sessionToken:(NSString *)token
            secureKey:(NSString *)secureKey
     bangdingPhoneNum:(BOOL)bangdingPhoneNum
              betOpen:(BOOL)betOpen{
    NSParameterAssert(userId);
    NSParameterAssert(userName);
    NSParameterAssert(token);
    NSParameterAssert(secureKey);
    NSParameterAssert(nickName);

    NSParameterAssert(bangdingPhoneNum);
//    NSParameterAssert(betOpen);
    NSAssert(!self.isLogin, @"用户未登录时才能调用该方法");
    
    [self willChangeValueForKey:@"isLogin"];
    self.sessionToken = token;
    self.secureKey = [KTMCrypto base64Decoding:secureKey];
    self.userName = userName;
    self.userId = userId;
    self.nickName = nickName;
    self.bangdingPhoneNum =bangdingPhoneNum;
    self.betOpen = betOpen;
    [self didChangeValueForKey:@"isLogin"];
    
    [self storeSession];
    
    
    if ([self.loginTime integerValue]>=0) {
        NSInteger  loginTimes = [self.loginTime integerValue];
        loginTimes++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd", loginTimes] forKey:self.userId];
    }else{
        if (self.userId) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:self.userId];
        }
    }
    
}

- (void)resetNickName:(NSString *)nickName {
    if (![nickName isEqualToString:self.nickName]) {
        self.nickName = nickName;
    }
}

/**
 *  退出登录
 */
- (void)logout {
    if (!self.isLogin) {
        return;
    }
    [self willChangeValueForKey:@"isLogin"];
    self.sessionToken = nil;
    self.secureKey = nil;
    self.userId = nil;
    self.userName = nil;
    self.nickName = nil;
    self.iconImage = nil;
    self.bangdingPhoneNum = NO;
    self.betOpen = NO;
    [self didChangeValueForKey:@"isLogin"];
    
    [self deleteSession];
}

//获取登录次数
- (NSString *)loginTime{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.userId];
}

#pragma mark - Session

- (void)storeSession {
    if (!self.isLogin) {
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.session options:0 error:nil] encoding:NSUTF8StringEncoding];
    [SSKeychain setPassword:jsonString forService:MemberManagerService account:SessionAccountName];
}

- (void)deleteSession {
    [SSKeychain deletePasswordForService:MemberManagerService account:SessionAccountName];
}

- (void)restoreSession {
    NSString *jsonString = [SSKeychain passwordForService:MemberManagerService account:SessionAccountName];
    if (jsonString.length == 0) {
        return;
    }
    // 如果应用是卸载后重装, 则清空以前的信息
    if ([KTMUtilities isFirstStartup] && ![KTMUtilities isUpgrade]) {
        [SSKeychain deletePasswordForService:MemberManagerService account:SessionAccountName];
        return;
    }
    self.session = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (NSDictionary *)session {
    if (!self.isLogin) {
        return nil;
    }
    NSString *secureKey = [KTMCrypto base64Encoding:self.secureKey];
    return @{kUserId: self.userId,
             kUserName: self.userName,
             kUserToken: self.sessionToken,
             kSecureKey: secureKey,
             kNickName: self.nickName,
             kBetOpen: [NSNumber numberWithBool:self.betOpen],
             kBangdingPhoneNum:[NSNumber numberWithBool:self.bangdingPhoneNum]};
}

- (void)setSession:(NSDictionary *)session {
    if (session.count == 0) {
        return;
    }
    
    [self willChangeValueForKey:@"isLogin"];
    NSData *secureKey = [KTMCrypto base64Decoding:session[kSecureKey]];
    self.userId = session[kUserId];
    self.userName = session[kUserName];
    self.secureKey = secureKey;
    self.sessionToken = session[kUserToken];
    self.nickName = session[kNickName];
    self.bangdingPhoneNum = [session[kBangdingPhoneNum] boolValue];
    self.betOpen = [session[kBetOpen] boolValue];
    [self didChangeValueForKey:@"isLogin"];
}

#pragma mark - Property (getter, setter)

//判断当前是否登录
- (BOOL)isLogin {
    return self.sessionToken.length;
}

//请求图片
- (void)setIconImageURL:(NSString *)iconImageURL {
    if (![_iconImageURL isEqualToString:iconImageURL]) {
        _iconImageURL = iconImageURL;
        
        // 请求网络
        [[AFHTTPSessionManager dp_sharedImageManager] GET:iconImageURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            self.iconImage = responseObject;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }

}
//是否开通投注
- (void)setBetOpen:(BOOL)betOpen{
    _betOpen = betOpen;
     [self storeSession];
}
@end
