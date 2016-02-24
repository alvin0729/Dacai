//
//  DPPayRedPacketViewController.h
//  Jackpot
//
//  Created by sxf on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.pbobjc.h"
typedef enum{
    HeartLoveOrderType = 1, //心水订单
}OrderType;

typedef void(^passWordBlock) ();
@interface DPPayRedPacketViewController : UIViewController

@property(nonatomic,assign)GameTypeId gameType;//彩种类型
@property(nonatomic,strong)PBMCreateOrderResult *dataBase;//生成订单接口返回
@property(nonatomic,assign)int projectMoney;//方案金额
@property(nonatomic,copy)NSString *gameName;//期号
@property(nonatomic,assign)long long gameId;//彩种当前期的id，支付的时候用
@property(nonatomic,assign)NSInteger totalIssue;//追号总期数
@property(nonatomic,assign)BOOL isCreateOrder;//是否需要创建订单
@property(nonatomic,assign)BOOL isFromProject;//是否从详情进入 （解决方案详情连返回两级的问题）
@property(nonatomic,assign)BOOL isChase;//是否追号
@property (nonatomic, assign) OrderType orderType;//订单时从哪个页面进来的
@property (nonatomic, copy) NSString *wagesUserName;
@property (nonatomic, copy) void (^buyWagesSuccess)();
@end
