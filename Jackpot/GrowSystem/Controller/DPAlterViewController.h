//
//  DPAlterViewController.h
//  Jackpot
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Growthsystem.pbobjc.h"
#import "DPBankCell.h"
#import "DPPayPasswordView.h"
typedef NS_ENUM(NSUInteger, AlterType) {
    AlterTypeSuccess,   //领取成功
    AlterTypePromote,   //升级
    AlterTypePoint,     //签到
    AlterTypeService,   //客服弹筐
    AlterTypeSet,       //设置
    AlterTypeLoginSucce,//注册成功
    AlterTypeBankChose, //银行选择
    AlterTypeOpenBetSuccess,//开通投注服务成功
    AlterTypeCancelledBetSuccess,//注销账户
    AlterTypeBackForNoPay,//订单确认返回
    AlterTypePayPassowrd,//支付密码
    AlterTypeDLTNumChange,  //大乐透期号切换
    AlterTypeDLTNumStop,    //大乐透订单遇到当前期截止
    AlterTypeDLTNumOver,    //进入大乐透中转页面停售弹窗
    AlterTypeJcUnGetNoBuy,  //竞彩所有玩法投注/中转页面夜间不出票弹窗
    AlterTypeJcUnGetBuy,    //竞彩订单确认页面夜间不出票弹窗
    AlterTypeJcStop,        //竞彩停售玩法投注页面停售弹窗
    AlterTypeStopChase,     //停止追号
};

typedef void(^iconSetBtnTapped) (UIButton *btn);

typedef void(^fullBtnTappedBlock) (UIButton *btn);

typedef void(^bankChoseBlock) (DPUAObject *bank);

typedef void(^seviceBlock) ();
//输入密码
typedef void(^passwordEnterBlock) (NSString *password);
//忘记密码
typedef void(^forgetPasswordBlock) ();

@interface DPAlterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)NSInteger registerTime ;//签到次数
/**
 *  密码输入框
 */
@property (nonatomic, strong)DPPayPasswordView *passwordView;
/**
 *  award
 */
@property (nonatomic, strong)PBMGrowthDrawTask *award;
/**
 *  checkIn
 */
@property (nonatomic, strong)PBMGrowthCheckIn *checkIn;
/**
 *  头像设置内部button点击
 */
@property (nonatomic, copy)iconSetBtnTapped setBtnTappedBlock;
/**
 *  完善资料
 */
@property (nonatomic, copy)fullBtnTappedBlock fullBtnTapped;
/**
 *  选择银行
 */
@property (nonatomic, copy)bankChoseBlock bankBlock;
/**
 *
 */
@property (nonatomic, copy)seviceBlock sevice;
/**
 *  输入支付密码block
 */
@property (nonatomic, copy)passwordEnterBlock passwordBlock;
/**
 *  忘记密码
 */
@property (nonatomic, copy)forgetPasswordBlock forgetPassword;
@property (nonatomic, copy) void (^confirmBlock)();
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *  银行数组
 */
@property (nonatomic, strong)NSMutableArray *bankArray;

- (instancetype)initWithAlterType:(AlterType)type ;
+(UILabel *)createLabelWithText:(NSString*)text color:(UIColor*)color font:(UIFont*)font ;


@end


