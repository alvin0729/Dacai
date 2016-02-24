//
//  AFHTTPSessionManager+Jackpot.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "AFHTTPSessionManager+Jackpot.h"
#import "DPHTTPSerializer.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <objc/runtime.h>

const CGFloat kTimeoutIntervalForWiFi = 10;
const CGFloat kTimeoutIntervalForWWAN = 18;

@implementation AFHTTPSessionManager (Jackpot)

+ (instancetype)dp_sharedManager {
    
    static AFHTTPSessionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ? kTimeoutIntervalForWiFi : kTimeoutIntervalForWWAN;
        
#if defined(DEBUG)
//        configuration.connectionProxyDictionary = @{@"HTTPProxy": @"10.12.2.146",
//                                                    @"HTTPPort": @8888,
//                                                    @"HTTPEnable": @YES};
#endif
        
        sharedManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kServerBaseURL] sessionConfiguration:configuration];
        sharedManager.requestSerializer = [[DPHTTPRequestSerializer alloc] init];
        sharedManager.responseSerializer = [[DPHTTPResponseSerializer alloc] init];
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil]
            subscribeNext:^(NSNotification *notification){
                AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
                switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                        sharedManager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForWiFi;
                        break;
                    default:
                        sharedManager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForWWAN;
                        break;
                }
            }];
    });
    return sharedManager;
}

+ (instancetype)dp_sharedSSLManager {
    static AFHTTPSessionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ? kTimeoutIntervalForWiFi : kTimeoutIntervalForWWAN;
        
#ifdef DEBUG
//        NSString *key = kCFNetworkProxiesHTTPEnable;
//        configuration.connectionProxyDictionary = @{@"HTTPProxy": @"10.12.2.146",
//                                                    @"HTTPPort": @8888,
//                                                    @"HTTPEnable": @YES};
#endif
        
        sharedManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kServerSSLURL] sessionConfiguration:configuration];
        sharedManager.requestSerializer = [DPHTTPSRequestSerializer serializer];
        sharedManager.responseSerializer = [DPHTTPSResponseSerializer serializer];
        
#if defined(DEBUG)
        // 调试模式下允许不验证证书
        sharedManager.securityPolicy.allowInvalidCertificates = YES;
//        sharedManager.securityPolicy.validatesDomainName = NO;
//        sharedManager.securityPolicy.validatesCertificateChain = NO;
#else
#warning 发布的时候要进行修改
        sharedManager.securityPolicy.allowInvalidCertificates = YES;
//        sharedManager.securityPolicy.validatesDomainName = NO;
//        sharedManager.securityPolicy.validatesCertificateChain = NO;
#endif
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil]
         subscribeNext:^(NSNotification *notification){
             AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
             switch (status) {
                 case AFNetworkReachabilityStatusReachableViaWiFi:
                     sharedManager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForWiFi;
                     break;
                 default:
                     sharedManager.session.configuration.timeoutIntervalForRequest = kTimeoutIntervalForWWAN;
                     break;
             }
         }];
    });
    return sharedManager;
}

+ (instancetype)dp_sharedImageManager {
    static AFHTTPSessionManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;

        sharedManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        sharedManager.responseSerializer = [[AFImageResponseSerializer alloc] init];
    });
    return sharedManager;
}

@end

@implementation NSError (Jackpot)

- (BOOL)dp_networkError {
    if (self.dp_errorCode != 0) {
        return NO;
    }
    return YES;
}

- (NSInteger)dp_errorCode {
    return [self.userInfo[kDPHTTPErrorCodeKey] integerValue];
}

- (NSString *)dp_errorMessage {
    if (self.dp_errorCode != 0) {
        return self.userInfo[kDPHTTPErrorMessageKey];
    }
    
    if(![AFNetworkReachabilityManager sharedManager].reachable){
        return @"当前网络不可用";
    }
    switch (self.code) {
        case NSURLErrorCancelled:
            return nil;
        case NSURLErrorTimedOut:
            return @"网络请求超时";
        case NSURLErrorNotConnectedToInternet:
            return @"当前网络不可用";
        case NSURLErrorCannotConnectToHost:
            return @"网络请求失败";
        default:
            return @"网络请求失败";
    }
}

- (NSData *)dp_errorProtobuf {
    return self.userInfo[kDPHTTPErrorProtobufData];
}

@end

@implementation DPNetworkManager

+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    return [[AFHTTPSessionManager dp_sharedManager] GET:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [DPMemberManager sharedInstance].isLogin ? [AFHTTPSessionManager dp_sharedManager] : [AFHTTPSessionManager dp_sharedSSLManager];
    return [manager POST:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [DPMemberManager sharedInstance].isLogin ? [AFHTTPSessionManager dp_sharedManager] : [AFHTTPSessionManager dp_sharedSSLManager];
    return [manager POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}

@end