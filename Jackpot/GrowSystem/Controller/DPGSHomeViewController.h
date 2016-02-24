//
//  DPGSHomeViewController.h
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUARequestData.h"
@interface DPGSHomeViewController : UIViewController
/**
 *  签到按钮
 */
@property (nonatomic, strong)UIButton *checkInBtn;
/**
 *  请求返回的数据(protocalBuff)
 */
@property (nonatomic, strong)PBMGrowthHome *growHomeData;

- (void)requestDataFrowServer;
@end
