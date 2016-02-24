//
//  KTMUtilities.m
//  Kathmandu
//
//  Created by wufan on 15/9/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "KTMUtilities.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

static NSString *const kUtilitiesService = @"UtilitiesService";
static NSString *const kAccountDeviceUUID = @"DeviceUUID";
static NSString *const kAccountInstallVersion = @"AccountInstallVersion";

static NSString *const kStartupVersionKey = @"StartupVersion";

@interface KTMUtilities ()
@property (nonatomic, copy, readonly) NSString *deviceUUID;
@property (nonatomic, copy, readonly) NSString *buildNumber;
@property (nonatomic, copy, readonly) NSString *applicationVersion;
@property (nonatomic, copy) NSString *pushDeviceToken;

@property (nonatomic, assign, readonly) BOOL firstInstall;
@property (nonatomic, assign, readonly) BOOL firstStartup;
@property (nonatomic, assign, readonly) BOOL upgrade;
@end

@implementation KTMUtilities
@synthesize deviceUUID = _deviceUUID;
@synthesize buildNumber = _buildNumber;
@synthesize applicationVersion = _applicationVersion;

#pragma mark - Life cycle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sharedInstance];
    });
}

- (instancetype)init {
    if (self = [super init]) {
        // TODO: first bootup and active logic.
        
        NSString *(*getPassword)(id, SEL, NSString *, NSString *) = (void *)objc_msgSend;
        BOOL (*setPassword)(id, SEL, NSString *, NSString *, NSString *) = (void *)objc_msgSend;
        
        // TODO:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Class cls = NSClassFromString(@"SSKeychain");
        SEL getPasswordSEL = @selector(passwordForService:account:);
        SEL setPasswordSEL = @selector(setPassword:forService:account:);
#pragma clang diagnostic pop
        
        NSParameterAssert(cls);
        NSParameterAssert([cls respondsToSelector:getPasswordSEL]);
        NSParameterAssert([cls respondsToSelector:setPasswordSEL]);
        
        NSString *installVersion = getPassword(cls, getPasswordSEL, kUtilitiesService, kAccountInstallVersion);
        if (installVersion == nil) {
            installVersion = self.applicationVersion;
            setPassword(cls, setPasswordSEL, installVersion, kUtilitiesService, kAccountInstallVersion);
            
            _firstInstall = YES;
        } else {
            _firstInstall = NO;
        }
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass([self class])];
        
        NSString *startupVersion = [userDefaults stringForKey:kStartupVersionKey];
        NSString *currentVersion = self.applicationVersion;
        if (startupVersion == nil || [currentVersion compare:startupVersion] != NSOrderedSame) {
            if (startupVersion) {
                _upgrade = YES;
            }
            _firstStartup = YES;
        } else {
            _firstStartup = NO;
        }
        if (_firstStartup) {
            [userDefaults setObject:currentVersion forKey:kStartupVersionKey];
            [userDefaults synchronize];
        }
    }
    return self;
}



#pragma mark - Internal Interface

- (NSString *)applicationVersion {
    if (_applicationVersion == nil) {
        _applicationVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _applicationVersion;
}

- (NSString *)buildNumber {
    if (_buildNumber == nil) {
        _buildNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _buildNumber;
}

- (NSString *)deviceUUID {
    if (_deviceUUID == nil) {
        NSString *(*getPassword)(id, SEL, NSString *, NSString *) = (void *)objc_msgSend;
        BOOL (*setPassword)(id, SEL, NSString *, NSString *, NSString *) = (void *)objc_msgSend;
        
        // TODO:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Class cls = NSClassFromString(@"SSKeychain");
        SEL getPasswordSEL = @selector(passwordForService:account:);
        SEL setPasswordSEL = @selector(setPassword:forService:account:);
#pragma clang diagnostic pop
        
        NSParameterAssert(cls);
        NSParameterAssert([cls respondsToSelector:getPasswordSEL]);
        NSParameterAssert([cls respondsToSelector:setPasswordSEL]);
        
        NSString *password = getPassword(cls, getPasswordSEL, kUtilitiesService, kAccountDeviceUUID);
        if (password == nil) {
            password = [[NSUUID UUID] UUIDString];
            setPassword(cls, setPasswordSEL, password, kUtilitiesService, kAccountDeviceUUID);
        }
        _deviceUUID = password;
    }
    
    return _deviceUUID;
}


#pragma mark - Public Interface

+ (KTMUtilities *)sharedInstance {
    static KTMUtilities *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSString *)applicationVersion {
    return [KTMUtilities sharedInstance].applicationVersion;
}

+ (NSString *)buildNumber {
    return [KTMUtilities sharedInstance].buildNumber;
}

+ (NSString *)deviceUUID {
    return [KTMUtilities sharedInstance].deviceUUID;
}

+ (NSString *)pushDeviceToken {
    return [KTMUtilities sharedInstance].pushDeviceToken;
}

+ (BOOL)isFirstInstall {
    return [KTMUtilities sharedInstance].firstInstall;
}

+ (BOOL)isFirstStartup {
    return [KTMUtilities sharedInstance].firstStartup;
}

+ (BOOL)isUpgrade {
    return [KTMUtilities sharedInstance].upgrade;
}

+ (void)setPushDeviceToken:(NSString *)deviceToken {
    [KTMUtilities sharedInstance].pushDeviceToken = deviceToken;
}

@end
