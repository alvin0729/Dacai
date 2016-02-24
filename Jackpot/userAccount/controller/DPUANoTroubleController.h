//
//  DPUANoTroubleController.h
//  Jackpot
//
//  Created by mu on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  比赛推送

#import <UIKit/UIKit.h>
typedef void (^DPUANoTroubleControllerBlock)(BOOL noTouble);
@interface DPUANoTroubleController : UIViewController
/**
 *  是否免打扰
 */
@property (nonatomic, assign) BOOL noTrouble;
/**
 *  免打扰BLOCK
 */
@property (nonatomic, copy) DPUANoTroubleControllerBlock notroubleBlock;
/**
 *  是否是比分直播
 */
@property (nonatomic, assign) BOOL isLive;
@end
