//
//  DPUARequest.h
//  Jackpot
//
//  Created by mu on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPUARequest : NSObject
/**
 *
 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**
 *  发送一个get请求
 *
 *  @param url       接口
 *  @param params    入参
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)getWithUrl:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSString *error))failError;
/**
 *  发送一个post请求
 *
 *  @param url       接口
 *  @param params    入参
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)postWithUrl:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSString *error))failError;
/**
 *  发送一个post请求（上传文件）
 *
 *  @param url       接口
 *  @param params    入参
 *  @param data      文件
 *  @param success   成功返回结果
 *  @param failError 失败返回结果
 */
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params fromData:(NSArray *)data success:(void (^)(id))success failure:(void (^)(NSString *))failError;

@end
