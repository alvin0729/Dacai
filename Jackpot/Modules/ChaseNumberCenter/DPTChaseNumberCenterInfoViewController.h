//
// DPTChaseNumberCenterInfoViewController.h
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//  追号详情

#import <UIKit/UIKit.h>

#import "DPUARequestData.h"
#import "ChaseCenter.pbobjc.h"
@interface DPTChaseNumberCenterInfoViewController : UIViewController

@property (nonatomic, assign) GameTypeId gameType;//彩种类型
@property(nonatomic,assign) long long projectId;//追号id
@property (nonatomic, strong)PBMChaseCenterItem *ChaseCenterListItem;//追号中心item
@end
