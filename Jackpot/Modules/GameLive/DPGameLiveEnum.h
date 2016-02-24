//
//  DPGameLiveEnum.h
//  Jackpot
//
//  Created by wufan on 15/9/7.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#ifndef Jackpot_DPGameLiveEnum_h
#define Jackpot_DPGameLiveEnum_h

typedef NS_ENUM(NSInteger, DPGameLiveFootballMatchStatus) {
    DPGameLiveFootballMatchStatus_NotStart = 0,       // 未开始
    DPGameLiveFootballMatchStatus_FirstHalf = 11,     // 上半场
    DPGameLiveFootballMatchStatus_Halftime = 21,      // 中场休息
    DPGameLiveFootballMatchStatus_SecondHalf = 31,    // 下半场
    DPGameLiveFootballMatchStatus_Ended = 41,         // 已结束
    DPGameLiveFootballMatchStatus_Interrupt = 95,     // 中断
    DPGameLiveFootballMatchStatus_Pending = 96,       // 待定
    DPGameLiveFootballMatchStatus_Cut = 97,           // 腰斩
    DPGameLiveFootballMatchStatus_PutOff = 98,        // 推迟
    DPGameLiveFootballMatchStatus_Cancel = 99,        // 已取消
};

typedef NS_ENUM(NSInteger, DPGameLiveBasketballMatchStatus) {
    DPGameLiveBasketballMatchStatus_NotStart        = 0,    // 未开始
    DPGameLiveBasketballMatchStatus_FirstSection    = 1,    // 第一节
    DPGameLiveBasketballMatchStatus_FirstBreak      = -1,   // 第一节休息
    DPGameLiveBasketballMatchStatus_SecondSection   = 2,    // 第二节
    DPGameLiveBasketballMatchStatus_SecondBreak     = -2,   // 第二节休息
    DPGameLiveBasketballMatchStatus_ThirdSection    = 3,    // 第三节
    DPGameLiveBasketballMatchStatus_ThirdBreak      = -3,   // 第三节休息
    DPGameLiveBasketballMatchStatus_FourthSection   = 4,    // 第四节
    DPGameLiveBasketballMatchStatus_FourthBreak     = -4,   // 第四节休息
    DPGameLiveBasketballMatchStatus_ExtraSection    = 5,    // 加时赛
    DPGameLiveBasketballMatchStatus_ExtraBreak      = -5,   // 加时赛休息
    
    DPGameLiveBasketballMatchStatus_NormalEnded     = 9,    // 已结束, 无加时
    DPGameLiveBasketballMatchStatus_ExtraEnded      = 11,   // 已结束, 包含加时
};

typedef NS_ENUM(NSInteger, DPGameLiveFootballEventType) {
    DPGameLiveFootballEventType_Goals = 1,        // 进球
    DPGameLiveFootballEventType_Red = 2,          // 红牌
    DPGameLiveFootballEventType_Yellow = 3,       // 黄牌
    DPGameLiveFootballEventType_Invaild = 6,      // 进球不算
    DPGameLiveFootballEventType_Penalties = 7,    // 点球
    DPGameLiveFootballEventType_Own = 8,          // 乌龙球
    DPGameLiveFootballEventType_Y2Red = 9,        // 两黄变一红
};

#endif
