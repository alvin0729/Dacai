//
//  AFHTTPSessionManager+Jackpot.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "DPAppConfigurator.h"
#import "DPHTTPErrorCode.h"

@interface AFHTTPSessionManager (Jackpot)
+ (AFHTTPSessionManager *)dp_sharedManager;
+ (AFHTTPSessionManager *)dp_sharedSSLManager;
+ (AFHTTPSessionManager *)dp_sharedImageManager;

@end

@interface NSError (Jackpot)
@property (nonatomic, copy, readonly) NSString *dp_errorMessage;
@property (nonatomic, strong, readonly) NSData *dp_errorProtobuf;
@property (nonatomic, assign, readonly) NSInteger dp_errorCode;
@property (nonatomic, assign, readonly) BOOL dp_networkError;
@end

@interface DPNetworkManager : NSObject
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end