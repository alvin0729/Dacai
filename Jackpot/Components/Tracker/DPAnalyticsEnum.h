// 
//  DPAnalyticsEnum.h
//  Jackpot
// 
//  Created by wufan on 15/10/12.
//  Copyright © 2015年 dacai. All rights reserved.
// 

#ifndef DPAnalyticsEnum_h
#define DPAnalyticsEnum_h

typedef NS_ENUM(NSInteger, DPAnalyticsType) {
    DPAnalyticsTypeNone = 0,

    // 首页滚动的前五个视图
    DPAnalyticsTypeHomeFirstAdv = 1,     // 第一个视图
    DPAnalyticsTypeHomeSecondAdv = 2,    // 第二个视图
    DPAnalyticsTypeHomeThirdAdv = 3,     // 第三个视图
    DPAnalyticsTypeHomeFourAdv = 4,      // 第四个视图
    DPAnalyticsTypeHomeFifAdv = 5,       // 第五个视图

    // 首页轮播图下的资讯
    DPAnalyticsTypeHomeLottery = 6,            // 资讯
    DPAnalyticsTypeHomeCommunityFirst = 7,     // 社区一
    DPAnalyticsTypeHomeCommunitySecond = 8,    // 社区二
    DPAnalyticsTypeHomeCommunityThird = 9,     // 社区三

    // 首页导航栏5个按钮的点击总数
    DPAnalyticsTypeHomeFirst = 10,     // 第一个Tab
    DPAnalyticsTypeHomeSecond = 11,    // 第二个Tab
    DPAnalyticsTypeHomeThird = 12,     // 第三个Tab
    DPAnalyticsTypeHomeFour = 13,      // 第四个Tab
    DPAnalyticsTypeHomeFif = 14,       // 第五个Tab

    // 首页快速下单入口
    DPAnalyticsTypeHomeQuickDlt = 15,     // 大乐透快速下单
    DPAnalyticsTypeHomeQuickJczq = 16,    // 竞彩足球快速下单
    DPAnalyticsTypeHomeQuickJclq = 17,    // 竞彩篮球快速下单

    // 首页快速投注入口
    DPAnalyticsTypeHomeDlt = 18,     // 大乐透快速投注
    DPAnalyticsTypeHomeJczq = 19,    // 竞彩足球快速投注
    DPAnalyticsTypeHomeJclq = 20,    // 竞彩篮球快速投注

    // 发现页面
    DPAnalyticsTypeFindCommunity = 21,    // 发现页面微社区
    DPAnalyticsTypeFindLottery = 22,      // 发现页面彩票资讯
    DPAnalyticsTypeFindGrow = 23,         // 发现页面成长体系

    // 彩票资讯
    // 推荐页面的前六条的点击数
    DPAnalyticsTypeLotteryRowOne = 24,    // 资讯第一条
    DPAnalyticsTypeLotteryRowTwo = 25,
    DPAnalyticsTypeLotteryRowThree = 26,
    DPAnalyticsTypeLotteryRowFour = 27,
    DPAnalyticsTypeLotteryRowFive = 28,
    DPAnalyticsTypeLotteryRowSix = 29,

    // 推荐翻页到2页、3页和6页的数量
    DPAnalyticsTypeLotteryPage2 = 30,    // 资讯第二页
    DPAnalyticsTypeLotteryPage3 = 31,
    DPAnalyticsTypeLotteryPage6 = 32,

    // 资讯分类下的六个按钮
    DPAnalyticsTypeLotteryDlt = 33,
    DPAnalyticsTypeLotteryJczq = 34,
    DPAnalyticsTypeLotteryJclq = 35,
    DPAnalyticsTypeLotterySsq = 36,
    DPAnalyticsTypeLotteryZc = 37,
    DPAnalyticsTypeLotteryFc3D = 38,

    // 资讯详情页下的投注入口
    DPAnalyticsTypeLotteryDetailDlt = 39,
    DPAnalyticsTypeLotteryDetailJczq = 40,
    DPAnalyticsTypeLotteryDetailJclq = 41,

    //     开奖公告
    DPAnalyticsTypeResultDlt = 42,
    DPAnalyticsTypeResultJczq = 43,
    DPAnalyticsTypeResultJclq = 44,
    DPAnalyticsTypeResultSsq = 45,
    DPAnalyticsTypeResultSfc = 46,
    DPAnalyticsTypeResultFc3D = 47,
    DPAnalyticsTypeResultPls = 48,
    DPAnalyticsTypeResultPlw = 49,
    DPAnalyticsTypeResultQlc = 50,
    DPAnalyticsTypeResultQxc = 51,

    // 竞彩足球、篮球开奖公告详情页面下得投注页面入口
    DPAnalyticsTypeResultDetailDlt = 52,
    DPAnalyticsTypeResultDetailJczq = 53,
    DPAnalyticsTypeResultDetailJclq = 54,

    // 竞彩足球、篮球开奖公告详情页面的右上角往期
    DPAnalyticsTypeResultDetailPreviousJczq = 55,
    DPAnalyticsTypeResultDetailPreviousJclq = 56,

    // 注册页
    DPAnalyticsTypeRegistBack = 57,      // 左上角返回
    DPAnalyticsTypeRegistButton = 58,    // 注册按钮

    DPAnalyticsTypeRegistQQ = 59,
    DPAnalyticsTypeRegistWeiXin = 60,
    DPAnalyticsTypeRegistDzh = 61,
    DPAnalyticsTypeRegistZfb = 62,
    DPAnalyticsTypeRegistXinlang = 63,

    // 登录页
    DPAnalyticsTypeLoginBack = 64,       // 左上角返回
    DPAnalyticsTypeLoginSetting = 65,    // 设置按钮
    DPAnalyticsTypeLoginForget = 66,
    DPAnalyticsTypeLoginButton = 67,

    DPAnalyticsTypeLoginQQ = 68,
    DPAnalyticsTypeLoginWeiXin = 69,
    DPAnalyticsTypeLoginDzh = 70,
    DPAnalyticsTypeLoginZfb = 71,
    DPAnalyticsTypeLoginXinlang = 72,

    // 大智慧账户登录
    DPAnalyticsTypeLoginDzhBack = 73,
    DPAnalyticsTypeLoginDzhButton = 74,

    // 第三方登录
    DPAnalyticsTypeThirdLoginBack = 75,    // 第三方登录返回按钮
    DPAnalyticsTypeThirdLoginNext = 76,    // 第三方登录下一步

    // 开通投注服务
    DPAnalyticsTypeServiceNo = 77,      // 暂不开通
    DPAnalyticsTypeServiceHelp = 78,    // 帮助
    DPAnalyticsTypeServiceYes = 79,     // 立即开通

    // 大彩账户创建成功弹窗
    DPAnalyticsTypeAccountClose = 80,    // 我知道了
    DPAnalyticsTypeAccountNext = 81,     // 立即完善

    // 开通投注服务成功弹窗
    DPAnalyticsTypeServiceClose = 82,    // 我知道了

    // 充值
    DPAnalyticsTypeRechargeBack = 83,    // 返回

    // 充值金额选项
    DPAnalyticsTypeRecharge50 = 84,     // 50
    DPAnalyticsTypeRecharge100 = 85,    // 100
    DPAnalyticsTypeRecharge150 = 86,    // 150
    DPAnalyticsTypeRecharge200 = 87,    // 200

    // 自定义充值金额
    DPAnalyticsTypeRechargeCount = 88,    // 手动输入

    // 充值方式
    DPAnalyticsTypeRechargeZfb = 89,           // 支付宝
    DPAnalyticsTypeRechargeBank = 90,          // 银行卡快捷
    DPAnalyticsTypeRechargeBankOnline = 91,    // 银联在线

    DPAnalyticsTypeRechargeSure = 92,       // 确认支付
    DPAnalyticsTypeRechargeSuccess = 93,    // 支付成功返回首页

    // 提现
    DPAnalyticsTypeDrawSure = 94,       // 确认提现
    DPAnalyticsTypeDrawSuccess = 95,    // 提现成功

};

#endif /* DPAnalyticsEnum_h */
