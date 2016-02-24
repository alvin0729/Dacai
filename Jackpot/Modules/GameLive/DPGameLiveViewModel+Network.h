//
//  DPGameLiveViewModel+Network.h
//  Jackpot
//
//  Created by wufan on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveViewModel.h"
#import <MSWeakTimer/MSWeakTimer.h>

//@interface DPGameLiveViewModel (Network)
//
//@end
@interface DPGameLiveViewModel ()
@property (nonatomic, strong) AFHTTPSessionManager *imageSessionMgr;    // 图片请求回话
@property (nonatomic, strong) NSMutableDictionary *imageRequestTable;   // 图片请求映射表

@property (nonatomic, strong) NSURLSessionDataTask *homeTask;           // 列表请求
@property (nonatomic, strong) NSURLSessionDataTask *updateTask;         // 轮训请求

@property (nonatomic, strong) MSWeakTimer *updateTimer;

@end
