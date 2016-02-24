//
//  DPHTTPSerializer.h
//  Jackpot
//
//  Created by wufan on 15/9/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>

extern NSInteger const kDPHTTPResponseSerializerError;
extern NSString *const kDPHTTPErrorMessageKey;
extern NSString *const kDPHTTPErrorCodeKey;
extern NSString *const kDPHTTPErrorProtobufData;

@interface DPHTTPRequestSerializer : AFHTTPRequestSerializer
@property (nonatomic, strong) NSData *secureKey;
@end

@interface DPHTTPResponseSerializer : AFHTTPResponseSerializer
@property (nonatomic, strong) NSData *secureKey;
@end

@interface DPHTTPSRequestSerializer : AFHTTPRequestSerializer
@end

@interface DPHTTPSResponseSerializer : AFHTTPResponseSerializer
@end
