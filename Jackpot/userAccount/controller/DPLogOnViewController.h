//
//  DPLogOnViewController.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  登录  sxf

#import <UIKit/UIKit.h>
#import "UMComLoginManager.h"

@interface DPLogOnViewController : UIViewController <UMComLoginDelegate>
@property (nonatomic, copy) void (^finishBlock)(void);
@property (nonatomic, assign) DPPathSource pathSource;//登录来源
@end
