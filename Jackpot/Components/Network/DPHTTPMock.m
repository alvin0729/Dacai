//
//  DPHTTPMock.m
//  Jackpot
//
//  Created by wufan on 15/9/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPHTTPMock.h"

#ifdef DEBUG
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "Gamelive.pbobjc.h"

@implementation DPHTTPMock

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self setupMock];
    });
}

+ (void)setupMock {
    NSLog(@"setup Mock...");
    
    // 篮球比分直播列表接口
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.URL.path.lowercaseString isEqualToString:@"/live/getjclqlivematch"]) {
            return NO;
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:500 headers:@{ @"Content-Type" : @"application/octet-stream" }];
    }];
    
    // 足球比分直播列表接口
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.URL.path.lowercaseString isEqualToString:@"/live/getjczqlivematch"]) {
            return NO;
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:500 headers:@{ @"Content-Type" : @"application/octet-stream" }];
    }];
    // 足球比分直播轮询接口
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.URL.path.lowercaseString isEqualToString:@"/live/zqliveinfo"]) {
            return NO;
            return YES;
        }
        return NO;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        PBMFootballLive_Match *match = [PBMFootballLive_Match message];
        match.matchId = 1904182;
        match.homeScore = 3;
        match.status = PBMFootballMatchStatus_FootballFirstHalf;
        
        PBMFootballLiveUpdate *update = [PBMFootballLiveUpdate message];
        update.currentTicks = @"1";
        update.matchesArray = @[ match ].mutableCopy;
        
        return [self succResponse:update.data];
    }];
}

+ (OHHTTPStubsResponse *)succResponse:(NSData *)data {
    int16_t h[4] = { htons(8), 0, 0, 0 };
    NSMutableData *pbm = [NSMutableData dataWithBytes:h length:8];
    [pbm appendData:data];
    return [OHHTTPStubsResponse responseWithData:pbm statusCode:200 headers:@{ @"Content-Type" : @"application/protobuf" }];
}

@end

#endif
