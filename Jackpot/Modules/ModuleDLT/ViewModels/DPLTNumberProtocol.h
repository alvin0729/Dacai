//
//  DPLotteryNumberProtocol.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#ifndef DacaiProject_DPLotteryNumberProtocol_h
#define DacaiProject_DPLotteryNumberProtocol_h
#import "Numberbet.pbobjc.h"
@protocol DPLTNumberBaseProtocol <NSObject>
@required
 - (void)setupWithControllerName:(NSString*)controlName;

- (void)uninstall;
@end

#pragma mark - 数据源

/**
 *
 * DPLTNumber - Dacai Project Transfer Number
 *
 * 数字彩中转界面
 *  
 */

// 单元格(tableViewCell)
@protocol DPLTNumberCellDataSource <NSObject>
@property (nonatomic, strong, readonly) NSAttributedString *numberString;     // 投注内容
@property (nonatomic, strong, readonly) NSString *descString;     // 描述(单式, 1注, 2元)

@optional
@property (nonatomic, strong, readonly) NSString *typeString;     // 高频玩法(任选三, 对子...)
@end

// 计时器
@protocol DPLTNumberTimerDataSource <NSObject>
@optional
@property (nonatomic, assign, readonly) BOOL hasGameInfo;   // 是否获取到了期号信息数据
@property (nonatomic, assign, readonly) NSInteger gameName; // 期号
@property (nonatomic, assign, readonly)NSInteger gameId;//玩法id
@property (nonatomic, strong, readonly) NSDate *endTime;    // 截止时间
@property (nonatomic, strong, readonly) NSString *countDownString;      // 倒计时显示的文字  05:12
 
@property(nonatomic,strong,readonly)NSMutableAttributedString *countDownAttString;//倒计时显示文字（针对多颜色的，一般投注页面专用）
@property(nonatomic,strong,readonly)NSString *highListGame;//高概率排行截止期号
@property(nonatomic,strong,readonly)NSMutableAttributedString *highListAttString;//高概率排行倒计时
@property (nonatomic, strong,readonly)NSMutableAttributedString *bonusMoney; // 奖池
@property(nonatomic,strong,readonly)NSMutableAttributedString *globalSurplusText;//底部奖池
@property(nonatomic,assign)NSInteger globalMultiple;//多少倍可以掏空奖池
@property (nonatomic, assign)NSInteger gameIndex; // 保存第几个彩种类型

@property (nonatomic, strong, readonly) NSString *switchGameString;     // 切换期号文字
@property(nonatomic,strong)PBMNumberBuy *dataBase;
@property(nonatomic,strong)NSMutableArray *infoArray;
- (void)switchHandled;  // 处理掉了期号切换
- (BOOL)isSwitchGame;//期号切换
-(NSMutableArray *)createHighListArrray:(int)index;//得到高概率攻略
//组装投注信息
-(NSString *)goBodyStrinfForPay:(NSInteger)followCount;//followCount:追号期数


@end

// 主界面(viewController's view)
@protocol DPLTNumberMainDataSource <NSObject>
@property (nonatomic, assign, readonly) NSInteger   gameType;           // 彩种类型
@property (nonatomic, strong, readonly) NSString   *gameTypeName;      // 彩种名
@property (nonatomic, strong, readonly) Class       cellClass;          // 类
@property (nonatomic, strong, readonly) Class       lotteryClass;       // 投注类
@property (nonatomic, assign, readonly) NSInteger   cellCount;
@property (nonatomic, assign, readonly) BOOL        enable;             // 是否停售

- (id<DPLTNumberCellDataSource>)modelForCellAtIndex:(NSInteger)index;
- (void)generateNumber:(NSInteger)gameIndex;        // 机选一注
//- (void)generateNumber:(NSInteger)gameIndex redArr:(int [50])red blueArr:(int [50])blue;        // 机选一注

- (void)deleteSingleCellAtIndex:(NSInteger)index;   // 删除一注
@end

// 用户交互界面(输入框, 提交)
@protocol DPLTNumberMutualDataSource <NSObject>
@property (nonatomic, assign, readonly) NSInteger note;     // 注数
@property (nonatomic, assign, readonly) NSInteger amount;   // 金额
@property (nonatomic, assign) NSInteger multiple;           // 下单倍数
@property (nonatomic, assign) NSInteger followCount;        // 追号期数
@property (nonatomic, assign) BOOL stopAfterWin;            // 中奖后停止
@property (nonatomic, strong) NSMutableAttributedString *attStr; // 同意协议属性字符串
@property (nonatomic, copy) void(^goPayFinish)(int); // 完成付款
@property (nonatomic, copy) void(^reloginBlock)();

- (void)cleanAllModelData; // 清除缓存数据
- (void)dp_setTogetherAndPayType:(BOOL)isTogether; // 合买或者付款的底层设置
//获取过关类型
-(int)projectBetType;
// 支付->方案内容
- (NSString *)dp_orderInfoUrl;
@optional
@property (nonatomic, assign, getter = isAddition) BOOL addition; // 是否追加(大乐透)
@end


#pragma mark - 动作
// 用户交互界面
@protocol DPLTNumberMutualDelegate <NSObject>
@required
- (void)onBtnGoPay;     // 下单
- (void)onBtnDeleteSingleCell:(UITableViewCell *)cell;
- (void)onBTnDeleteAllData;
@optional
- (void)onBtnaddition:(BOOL)isAddition;  // 大乐透加倍投注
- (void)onBtnIntroduce;  // 大乐透加倍投注介绍
@end


#endif
