//
//  watchShareDataDefine.h
//  Jackpot
//
//  Created by sxf on 15/7/27.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#ifndef Jackpot_watchShareDataDefine_h
#define Jackpot_watchShareDataDefine_h



#define  KWatchGroupIdentifier      "group.com.watch.sharedata"
#define  KWatchOptionalDirectory     "watchShareData"

#define  KWatchResult                "result"       //开奖公告请求
#define  KWatchJczqResult            "jczqResult"   //竞彩足球开奖公告请求
#define  KWatchJclqResult            "jclqResult"   //竞彩蓝球开奖公告请求
#define  KWatchJczqLiving            "WatchJczqLiving"//足彩比分直播请求
#define  KWatchJclqLiving            "WatchJclqLiving"//篮彩比分直播请求


#define  KWatchGlance                "watchGlace"   //平衡页面请求
#define  KWatchGlaceBonus            "watchGlaceBonus" //大乐透奖池

//大乐透开奖
#define KWatchResultDlt              "watchResultDlt"
#define KWatchResultDltIssue         "watchResultDltIssue"
#define KWatchResultDltDrawing       "watchResultDltDrawing"
#define KWatchResultDltDrawTime      "watchResultDltDrawTime"

//双色球开奖
#define KWatchResultSsq              "watchResultSSq"
#define KWatchResultSsqIssue         "watchResultSSqIssue"
#define KWatchResultSsqDrawing       "watchResultSSqDrawing"
#define KWatchResultSsqDrawTime      "watchResultSsqDrawTime"

//福彩3d开奖
#define KWatchResultFc3d             "watchResultFc3d"
#define KWatchResultFc3dIssue         "watchResultFc3dIssue"
#define KWatchResultFc3dDrawing       "watchResultFc3dDrawing"
#define KWatchResultFc3dDrawTime      "watchResultFc3dDrawTime"

//排列三开奖
#define KWatchResultPl3              "watchResultPl3"
#define KWatchResultPl3Issue         "watchResultPl3Issue"
#define KWatchResultPl3Drawing       "watchResultPl3Drawing"
#define KWatchResultPl3DrawTime      "watchResultPl3DrawTime"

//排列五开奖
#define KWatchResultPl5              "watchResultPl5"
#define KWatchResultPl5Issue         "watchResultPl5Issue"
#define KWatchResultPl5Drawing       "watchResultPl5Drawing"
#define KWatchResultPl5DrawTime      "watchResultPl5dDrawTime"

//七星彩开奖
#define KWatchResultQxc              "watchResultQxc"
#define KWatchResultQxcIssue         "watchResultQxcIssue"
#define KWatchResultQxcDrawing       "watchResultQxcDrawing"
#define KWatchResultQxcDrawTime      "watchResultQxcDrawTime"

//七乐彩开奖
#define KWatchResultQlc              "watchResultQlc"
#define KWatchResultQlcIssue         "watchResultQlcIssue"
#define KWatchResultQlcDrawing       "watchResultQlcDrawing"
#define KWatchResultQlcDrawTime      "watchResultQlcDrawTime"

//胜负彩开奖
#define KWatchResultSfc              "watchResultSfc"
#define KWatchResultSfcIssue         "watchResultSfcIssue"
#define KWatchResultSfcDrawing       "watchResultSfcDrawing"
#define KWatchResultSfcDrawTime      "watchResultSfcDrawTime"

//竞彩足球
#define KWatchResultJczqArray          "watchResultJczqArray"//竞彩足球开奖
#define KWatchResultJczqIsRequest      "watchResultJczqIsRequest"//竞彩足球开奖是否请求过
#define KWatchResultJclqIsRequest      "watchResultJclqIsRequest"//竞彩蓝球开奖是否请求过
#define KWatchResultJczqGameName       "watchResultJczqGameName"
#define KWatchResultJclqGameName       "watchResultJclqGameName"
#define KWatchJczqResultIndex          "watchJczqResultIndex"
#define KWatchJclqResultIndex          "watchJclqResultIndex"
//竞彩篮球
#define KWatchResultJclqArray         "watchResultJclqArray"//竞彩数组

#define KWatchResultJcHomeName      "watchJcHomeName"
#define KWatchResultJcAwayName      "watchJcAwayName"
#define KWatchResultJcScore         "watchJcScore"





//竞彩足球比分直播列表  /篮彩
#define KWatchJCzqGameLivingArray  "watchJCzqGameLivingArray"//竞彩足球
#define KWatchJClqGameLivingArray  "watchJClqGameLivingArray"//竞彩篮球
#define KWatchJczqLivingIndex      "watchJCzqGameLivingHomeIndex"
#define KWatchJclqLivingIndex      "watchJClqGameLivingHomeIndex"
#define KWatchJcTimer              20
#define KWatchGameLivingHomeIcon   "watchGameLivingHomeIcon"//竞彩足球，篮球开奖公告，比分直播共用
#define KWatchGameLivingAwayIcon   "watchGameLivingAwayIcon"
#define KWatchGameLivingHomeName   "watchGameLivingHomeName"
#define KWatchGameLivingAwayName   "watchGameLivingAwayName"
#define KWatchGameLivingScore      "watchGameLivingScore"
#define KWatchGameLivingTime       "watchGameLivingTime"
#define KWatchGameLivingStartTime  "watchGameLivingStartTime"

#define KWatchGameLiveHomeUrl     "watchGameLiveHomeUrl"//竞彩足球，篮球开奖公告比分直播共用
#define KWatchGameLiveAwayUrl     "watchGameLiveAwayUrl"

#define KWatchIconCache           "KWatchIconCache"
#define KWatchIconIndex            "watchIconIndex" //>0 代表主队  从1开始      <0 代表客队，从-1开始     0:默认
#define KWatchJclqIconIndex        "watchJclqIconIndex"
#define KWatchZqRequestIconIndex   "watchZqRequestIconIndex"
#define KWatchLqRequestIconIndex   "watchlqRequestIconIndex"
#endif
