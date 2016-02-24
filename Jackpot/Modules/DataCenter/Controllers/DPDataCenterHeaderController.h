//
//  DPDataCenterHeaderController.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPDataCenterHeaderViewModel.h"

@interface DPDataCenterHeaderController : NSObject
/**
 *  头部View
 */
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong, readonly) DPDataCenterHeaderViewModel *viewModel;
@end

@interface DPFootballCenterHeaderController : DPDataCenterHeaderController

@end

@interface DPBasketballCenterHeaderController : DPDataCenterHeaderController

@end