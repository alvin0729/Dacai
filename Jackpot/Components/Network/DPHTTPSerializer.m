//
//  DPHTTPSerializer.m
//  Jackpot
//
//  Created by wufan on 15/9/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPHTTPSerializer.h"
#import "DPMemberManager.h"
#import "DPMemberManager+Private.h"
#import "GPBMessage.h"

NSInteger const kDPHTTPRequestSerializeError = -99901;
NSInteger const kDPHTTPResponseSerializerError = -99902;

NSString *const kDPHTTPErrorMessageKey = @"ErrorMessage";
NSString *const kDPHTTPErrorCodeKey = @"ErrorCode";
NSString *const kDPHTTPErrorProtobufData = @"ErrorPBData";

typedef NS_ENUM(NSInteger, DPHTTPErrorCode) {
    DPHTTPErrorCodeSessionTimeOut,
    DPHTTPErrorCodeDecryptFailure,
};

static NSString *const kChannelIdHeaderFieldKey = @"ChannelId";       // 渠道号
static NSString *const kPlatformVersionHeaderFiledKey = @"Platform";  // 平台号, iOS为16写死
static NSString *const kAppVersionHeaderFiledKey = @"AppVersion";     // 版本号
static NSString *const kDeviceTokenHeaderFieldKey = @"DeviceToken";   // 设备号
static NSString *const kSessionTokenHeaderFieldKey = @"SessionToken"; // 用户token

static NSString *const kPlatformForiOS = @"16";     // iOS平台号

@implementation DPHTTPRequestSerializer

- (instancetype)init {
    if (self = [super init]) {
        [self setValue:[DPAppConfigurator channelId] forHTTPHeaderField:kChannelIdHeaderFieldKey];
        [self setValue:kPlatformForiOS forHTTPHeaderField:kPlatformVersionHeaderFiledKey];
        [self setValue:[KTMUtilities applicationVersion] forHTTPHeaderField:kAppVersionHeaderFiledKey];
        [self setValue:[KTMUtilities deviceUUID] forHTTPHeaderField:kDeviceTokenHeaderFieldKey];

        // GET方法直接在URI中拼接参数, POST则需要构造Body
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", nil];
    }
    return self;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    // 如果是登录状态, 则在 HTTP Header 中添加 SessionToken
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    if ([DPMemberManager sharedInstance].sessionToken.length) {
        [mutableRequest setValue:[DPMemberManager sharedInstance].sessionToken forHTTPHeaderField:kSessionTokenHeaderFieldKey];
    }
    
    // 将参数直接拼接到URI中
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[mutableRequest HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:mutableRequest withParameters:parameters error:error];
    }
    
    // Header 键值对
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    // 判断是否登录超时
    NSData *key = [DPMemberManager sharedInstance].secureKey;
    if (key.length == 0) {
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Session timeout.", @"AFNetworking", nil),
                                       kDPHTTPErrorMessageKey: @"登录超时, 请重新登录.",
                                       kDPHTTPErrorCodeKey: @(DPHTTPErrorCodeSessionTimeOut)};
            *error = [NSError errorWithDomain:AFURLRequestSerializationErrorDomain code:kDPHTTPRequestSerializeError userInfo:userInfo];
        }
        return nil;
    }

    // Body 组织
    if (parameters) {
        NSData *rawData = nil;
        
        if ([parameters isKindOfClass:[GPBMessage class]]) {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                [mutableRequest setValue:@"secure/protobuf" forHTTPHeaderField:@"Content-Type"];
            }
            // protobuf
            rawData = [(GPBMessage *)parameters data];
        } else {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                [mutableRequest setValue:@"secure/json" forHTTPHeaderField:@"Content-Type"];
            }
            // json
            if (![NSJSONSerialization isValidJSONObject:parameters]) {
                if (error) {
                    *error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Not a json object.", @"AFNetworking", nil)}];
                }
                return nil;
            }
            rawData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:error];
        }
        
        // 加密处理
        NSData *data = [DPTransmitCrypto sessionEncrypt:rawData key:key];
        
        [mutableRequest setHTTPBody:data];
    }

    return mutableRequest;
}

@end

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }
    
    return NO;
}

@implementation DPHTTPResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/protobuf", @"secure/protobuf", nil];
    
    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        // 无法解析当前 Content-Type 类型的数据
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
        // HTTP 响应错误, State Code
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorBadServerResponse, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
        NSParameterAssert(error);
    }
    
    if ([response.MIMEType isEqualToString:@"secure/protobuf"]) {
        NSData *key = [DPMemberManager sharedInstance].secureKey;
        if (key.length == 0) {
            if (error) {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Session timeout.", @"AFNetworking", nil),
                                           kDPHTTPErrorMessageKey: @"登录超时, 请重新登录.",
                                           kDPHTTPErrorCodeKey: @(DPHTTPErrorCodeSessionTimeOut)};
                *error = [NSError errorWithDomain:AFURLRequestSerializationErrorDomain code:kDPHTTPRequestSerializeError userInfo:userInfo];
            }
            return nil;
        }
        // 加密模式
        data = [DPTransmitCrypto sessionDecrypt:data key:key];
        if (data == nil) {
            if (error) {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Decrypt failure.", @"AFNetworking", nil),
                                           kDPHTTPErrorMessageKey: @"解码失败.",
                                           kDPHTTPErrorCodeKey: @(DPHTTPErrorCodeDecryptFailure)};
                *error = [NSError errorWithDomain:AFURLRequestSerializationErrorDomain code:kDPHTTPRequestSerializeError userInfo:userInfo];
            }
            return nil;
        }
    } else {
        // 正常模式
//        NSAssert([response.MIMEType isEqualToString:@"application/protobuf"], @"failure...");
    }
    
    NSAssert(data.length >= 8, @"failure...");
    
    int16_t size = *(int16_t *)(data.bytes);
    int16_t code = *(int16_t *)(data.bytes + 2);
    int16_t reserve1 = *(int16_t *)(data.bytes + 4);
    int16_t reserve2 = *(int16_t *)(data.bytes + 6);
    
    // 从网络序转化为主机序
    size = ntohs(size);         // 头部大小
    code = ntohs(code);         // 错误码
    reserve1 = ntohs(reserve1); // 预留字段1
    reserve2 = ntohs(reserve2); // 预留字段2
    
    NSAssert(size <= data.length, @"failure...");
   
    if (code < 0) {
        if (error) {
            NSString *message = [[NSString alloc] initWithBytes:data.bytes + 8 length:size - 8 encoding:NSUTF8StringEncoding];
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: message,
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      AFNetworkingOperationFailingURLResponseErrorKey: response,
                                                      kDPHTTPErrorCodeKey: @(code),
                                                      kDPHTTPErrorMessageKey: message ?: @""
                                                      } mutableCopy];
            
            if (data) {
                mutableUserInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = data;
            }
            if (data.length - size > 0) {
                mutableUserInfo[kDPHTTPErrorProtobufData] = [NSData dataWithBytes:(void *)data.bytes + size length:data.length - size];
            }
            *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:kDPHTTPResponseSerializerError userInfo:mutableUserInfo];
        }
        if (code == DPErrorCodeUserUnlogin) {
            [[DPMemberManager sharedInstance] logout];
        }
        return nil;
    }
    
    // 返回真实的数据, copy
    return [NSData dataWithBytes:(void *)data.bytes + size length:data.length - size];
}

@end


@implementation DPHTTPSRequestSerializer

- (instancetype)init {
    if (self = [super init]) {
        [self setValue:[DPAppConfigurator channelId] forHTTPHeaderField:kChannelIdHeaderFieldKey];
        [self setValue:kPlatformForiOS forHTTPHeaderField:kPlatformVersionHeaderFiledKey];
        [self setValue:[KTMUtilities applicationVersion] forHTTPHeaderField:kAppVersionHeaderFiledKey];
        [self setValue:[KTMUtilities deviceUUID] forHTTPHeaderField:kDeviceTokenHeaderFieldKey];

        // GET方法直接在URI中拼接参数, POST则需要构造Body
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", nil];
    }
    return self;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    // 如果是登录状态, 则在 HTTP Header 中添加 SessionToken
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    if ([DPMemberManager sharedInstance].sessionToken.length) {
        [mutableRequest setValue:[DPMemberManager sharedInstance].sessionToken forHTTPHeaderField:kSessionTokenHeaderFieldKey];
    }
    // 将参数直接拼接到URI中
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[mutableRequest HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:mutableRequest withParameters:parameters error:error];
    }
    
    // Header 键值对
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];

    // Body 组织
    NSData *data = nil;
    if (parameters) {
        if ([parameters isKindOfClass:[GPBMessage class]]) {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                [mutableRequest setValue:@"application/protobuf" forHTTPHeaderField:@"Content-Type"];
            }
            // protobuf
            data = [(GPBMessage *)parameters data];
        } else {
            if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
                [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            }
            // json
            if (![NSJSONSerialization isValidJSONObject:parameters]) {
                if (error) {
                    *error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"Not a json object.", @"AFNetworking", nil)}];
                }
                return nil;
            }
            data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:error];
        }
        
        [mutableRequest setHTTPBody:data];
    }

    return mutableRequest;
}

@end

@implementation DPHTTPSResponseSerializer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/protobuf", nil];
    
    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        // 无法解析当前 Content-Type 类型的数据
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
        // HTTP 响应错误, State Code
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorBadServerResponse, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
        NSParameterAssert(error);
    }
    
    NSAssert(data.length >= 8, @"failure...");
    
    int16_t size = *(int16_t *)(data.bytes);
    int16_t code = *(int16_t *)(data.bytes + 2);
    int16_t reserve1 = *(int16_t *)(data.bytes + 4);
    int16_t reserve2 = *(int16_t *)(data.bytes + 6);
    
    // 从网络序转化为主机序
    size = ntohs(size);         // 头部大小
    code = ntohs(code);         // 错误码
    reserve1 = ntohs(reserve1); // 预留字段1
    reserve2 = ntohs(reserve2); // 预留字段2
    
    NSAssert(size <= data.length, @"failure...");
   
    if (code < 0) {
        if (error) {
            NSString *message = [[NSString alloc] initWithBytes:data.bytes + 8 length:size - 8 encoding:NSUTF8StringEncoding];
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: message,
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      AFNetworkingOperationFailingURLResponseErrorKey: response,
                                                      kDPHTTPErrorCodeKey: @(code),
                                                      kDPHTTPErrorMessageKey: message ?: @""
                                                      } mutableCopy];
            
            if (data) {
                mutableUserInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = data;
            }
            *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:kDPHTTPResponseSerializerError userInfo:mutableUserInfo];
        }
        return nil;
    }
    
    // 返回真实的数据, copy
    return [NSData dataWithBytes:(void *)data.bytes + size length:data.length - size];
}

@end
