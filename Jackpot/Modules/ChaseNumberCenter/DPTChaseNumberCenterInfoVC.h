//
//  DPTChaseNumberCenterInfoVC.h
//  Jackpot
//
//  Created by sxf on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DPUARequestData.h"
#import "ChaseCenter.pbobjc.h"
@interface DPTChaseNumberCenterInfoVC : UIViewController

@property (nonatomic, assign) GameTypeId gameType;
@property(nonatomic,assign) long long projectId;
@property (nonatomic, strong)PBMChaseCenterItem *ChaseCenterListItem;
@end
