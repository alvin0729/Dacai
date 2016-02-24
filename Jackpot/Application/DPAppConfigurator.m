//
//  DPAppConfigurator.m
//  DacaiProject
//
//  Created by wufan on 15/2/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAppConfigurator.h"
#import "KTMUserDefaults+Jackpot.h"

// 不要改下面的地址!!! 要修改链接的服务器, 通过修改 DNS 或者 hosts 实现.
static NSString *const DEFAULT_BASE_URL = @"http://api.dacai.com/";   // 生产环境
static NSString *const DEFAULT_SSL_URL = @"https://api.dacai.com/";   // 生产环境

// 渠道名称, 渠道id
static NSString *const DEFAULT_CHANNEL_ID = @"1";      // 大彩


@interface DPAppConfigurator ()
+ (DPAppConfigurator *)defaultMgr;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *SSLURL;
@property (nonatomic, strong) NSString *environment;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *buildDate;
@end

@implementation DPAppConfigurator

+ (DPAppConfigurator *)defaultMgr {
    static dispatch_once_t onceToken;
    static DPAppConfigurator *mgr;
    dispatch_once(&onceToken, ^{
        mgr = [[DPAppConfigurator alloc] init];
    });
    
    return mgr;
}

+ (void)load {
    [self defaultMgr];
}

- (instancetype)init {
    if (self = [super init]) {
#if defined(CONFIGURABLE)
        KTMUserDefaults *userDefaults = [KTMUserDefaults standardUserDefaults];
        NSString *urlString;
        NSString *sslString;
        NSString *buildDate = userDefaults.buildDate;
        if ([buildDate isEqualToString:self.buildDate]) {
            urlString = userDefaults.baseURL;
            sslString = userDefaults.sslURL;
        } else {
            userDefaults.baseURL = nil;
            userDefaults.sslURL = nil;
            userDefaults.buildDate = nil;
        }
        
        // HTTP 服务器
        if ([urlString isKindOfClass:[NSString class]]) {
            if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) {
                urlString = [@"http://" stringByAppendingString:urlString];
            }
        }
        
        // HTTPS 服务器
        if ([sslString isKindOfClass:[NSString class]]) {
            if (![sslString hasPrefix:@"http://"] && ![sslString hasPrefix:@"https://"]) {
                sslString = [@"https://" stringByAppendingString:sslString];
            }
        }
        // 服务器地址
        self.baseURL = urlString ?: DEFAULT_BASE_URL;
        self.SSLURL = sslString ?: DEFAULT_SSL_URL;
#else
        self.baseURL = DEFAULT_BASE_URL;
        self.SSLURL = DEFAULT_SSL_URL;
#endif
        
        // 渠道id
        self.channelId = DEFAULT_CHANNEL_ID;
        
#if defined(DEBUG)
        self.environment = @"DEBUG";
#else
        self.environment = @"RELEASE";
#endif
    }
    return self;
}

#pragma mark - Property (getter, setter)

/**
 *  获取当前文件的编译时间
 *
 *  由于Xcode只会重新编译修改过的文件, 所以在Run Script中执行了更新文件
 *  修改时间的脚本, 保证 __DATA__, __TIME__ 总是正确的
 *
 *  @return NSString
 */
- (NSString *)buildDate {
    if (!_buildDate) {
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        
//        // Get build date and time, format to 'yyyy-MM-dd HH:mm'
//        NSString *dateStr = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:__DATE__], [NSString stringWithUTF8String:__TIME__]];
//        
//        // Convert to date
//        [dateFormat setDateFormat:@"LLL d yyyy HH:mm:ss"];
//        NSDate *date = [dateFormat dateFromString:dateStr];
//        
//        // Set output format and convert to string
//        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *buildDateStr = [dateFormat stringFromDate:date];
//        
//        _buildDate = buildDateStr;
        
        _buildDate = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:__DATE__], [NSString stringWithUTF8String:__TIME__]];
    }
    return _buildDate;
}

#pragma mark - Class Function

+ (void)switchToAddr:(NSString *)addr {
#if defined(CONFIGURABLE)
    KTMUserDefaults *userDefaluts = [KTMUserDefaults standardUserDefaults];
    userDefaluts.baseURL = addr;
    userDefaluts.buildDate = self.defaultMgr.buildDate;
#endif
}

+ (void)switchToSSLAddr:(NSString *)addr {
#if defined(CONFIGURABLE)
    KTMUserDefaults *userDefaluts = [KTMUserDefaults standardUserDefaults];
    userDefaluts.sslURL = addr;
    userDefaluts.buildDate = self.defaultMgr.buildDate;
#endif
}

+ (NSString *)baseURL {
    return [[self defaultMgr] baseURL];
}

+ (NSString *)SSLURL {
    return [[self defaultMgr] SSLURL];
}

+ (NSString *)environment {
    return [[self defaultMgr] environment];
}

+ (NSString *)channelId {
    return [[self defaultMgr] channelId];
}

+ (NSString *)buildDate {
    return [[self defaultMgr] buildDate];
}

@end
