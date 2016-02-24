//
//  DPOpenBetServiceController.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DPOpenBetServiceControllerBlock)();
@interface DPOpenBetServiceController : UIViewController
/**
 *  开通服务后的回掉
 */
@property (nonatomic, copy) DPOpenBetServiceControllerBlock openBetBlock;
@property (nonatomic, assign) DPPathSource pathSource;//跳转到开通服务的路径
@end
