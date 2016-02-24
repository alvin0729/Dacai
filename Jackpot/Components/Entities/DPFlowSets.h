//
//  DPFlowSets.h
//  Jackpot
//
//  Created by WUFAN on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBMPlaceAnOrder;
@class PBMChaseToPlaceAnOrder;

// 付款上下文
@interface DPPaymentContext : NSObject
#ifdef DEBUG
@property (nonatomic, assign, readonly) UIViewController *viewController;
#else
@property (nonatomic, weak, readonly) UIViewController *viewController;
#endif
@property (nonatomic, assign) BOOL autoNextStep;
@end

// 付款流程
@interface DPPaymentFlow : NSObject
/**
 *  保存当前付款上下文, 必须在 init 方法中调用
 *
 *  @param viewController [in]当前付款viewController
 */
+ (void)pushContextWithViewController:(UIViewController *)viewController;
/**
 *  销毁当前付款上下文, 必须在 dealloc 方法方法中调用
 *
 *  @param viewController [in]当前付款viewController
 */
+ (void)popContextWithViewController:(UIViewController *)viewController;

/**
 *  大乐透追号付款动作, 在使用的 viewControler 的 init, dealloc 方法中需要分别调用 push 和 pop 方法
 *
 *  @param order          [in]订单详情
 *  @param gameType       [in]彩种
 *  @param viewController [in]当前viewController
 */
+ (void)paymentWithChase:(PBMChaseToPlaceAnOrder *)order gameType:(NSInteger)gameType followCount:(NSInteger)followCount inViewController:(UIViewController *)viewController;

/**
 *  大乐透付款动作, 在使用的 viewControler 的 init, dealloc 方法中需要分别调用 push 和 pop 方法
 *
 *  @param order          [in]订单详情
 *  @param gameType       [in]彩种
 *  @param gameName       [in]期号
 *  @param viewController [in]当前viewController
 */
+ (void)paymentWithOrder:(PBMPlaceAnOrder *)order gameType:(NSInteger)gameType gameName:(NSInteger)gameName inViewController:(UIViewController *)viewController;

/**
 *  竞彩付款动作, 在使用的 viewControler 的 init, dealloc 方法中需要分别调用 push 和 pop 方法
 *
 *  @param order          [in]订单详情
 *  @param gameType       [in]彩种
 *  @param viewController [in]当前viewController
 */
+ (void)paymentWithOrder:(PBMPlaceAnOrder *)order gameType:(NSInteger)gameType inViewController:(UIViewController *)viewController;

@end

@interface DPPaymentFlow (DPPaymentAddition)
+ (DPPaymentContext *)currentPaymentContext;
+ (BOOL)currentPaymentFlowContainViewController:(UIViewController *)viewController;
@end

// 登录流程
@interface DPLoginFlow : NSObject
+ (void)loginIfNeededAndPerform:(void (^)(void))block;
@end