//
//  DPHTTPErrorCode.h
//  Jackpot
//
//  Created by wufan on 15/10/14.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifndef DPHTTPErrorCode_h
#define DPHTTPErrorCode_h

typedef NS_ENUM(NSInteger, DPErrorCode) {
    DPErrorCodeNone = 0,
    DPErrorCodeUserUnlogin = -1000,     // 未登录或者登录超时
    DPErrorCodeBetAccount = -1001,      // 投注账户未开通
};

#endif /* DPHTTPErrorCode_h */
