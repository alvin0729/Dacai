//
//  KTMUserDefaults+Jackpot.h
//  Jackpot
//
//  Created by WUFAN on 15/12/4.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Kathmandu/Kathmandu.h>

// 配置存储信息
@interface KTMUserDefaults (DPAppConfigurator)
@property (nonatomic, strong) NSString *buildDate;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *sslURL;
@end

// 登录, 记住密码
@interface KTMUserDefaults (DPLogOnViewController)
@property (nonatomic, strong) NSString *userName;
@end

// 注册设备
@interface KTMUserDefaults (DPAppLoader)
@property (nonatomic, strong) NSString *guidVersion;
@property (nonatomic, strong) NSString *lastPushToken;  // 最后一次的推送设备号`
@end

// 竞彩出票夜间提示
@interface KTMUserDefaults (DPSportLottery)
@property (nonatomic, strong) NSDate *jczqAlertDate;    // 竞彩足球夜间提示最后一次弹出时间
@property (nonatomic, strong) NSDate *jclqAlertDate;    // 竞彩篮球夜间提示最后一次弹出时间
@end

@implementation KTMUserDefaults (DPAppConfigurator)
@dynamic buildDate, baseURL, sslURL;
@end

@implementation KTMUserDefaults (DPLogOnViewController)
@dynamic userName;
@end

@implementation KTMUserDefaults (DPAppLoader)
@dynamic guidVersion, lastPushToken;
@end

@implementation KTMUserDefaults (DPSportLottery)
@dynamic jczqAlertDate, jclqAlertDate;
@end