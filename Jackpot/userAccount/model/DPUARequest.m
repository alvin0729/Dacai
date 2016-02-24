//
//  DPUARequest.m
//  Jackpot
//
//  Created by mu on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUARequest.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager+Jackpot.h"
@implementation DPUARequest
/**
 *  发送一个get请求
 *
 *  @param url       接口
 *  @param params    入参
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSString *error))failError{

    [[AFHTTPSessionManager dp_sharedManager]GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([error dp_errorMessage]) {
            failError([error dp_errorMessage]);
        }
    }];
    
}
/**
 *  发送一个post请求
 *
 *  @param url       接口
 *  @param params    入参
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSString *error))failError{
    
    if ([DPMemberManager sharedInstance].isLogin) {
        [[AFHTTPSessionManager dp_sharedManager]POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([error dp_errorMessage]) {
                failError([error dp_errorMessage]);
            }
        }];
    }else{
        [[AFHTTPSessionManager dp_sharedSSLManager]POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([error dp_errorMessage]) {
                failError([error dp_errorMessage]);
            }
        }];
    }
   
    
}
/**
 *  发送一个post请求（上传文件）
 *
 *  @param url       接口
 *  @param params    入参
 *  @param data      文件
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params fromData:(NSArray *)data success:(void (^)(id))success failure:(void (^)(NSString *))failError{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success((NSData *)responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failError) {
//            failError([error localizedDescription]);
//        }
//    }];
}
@end
