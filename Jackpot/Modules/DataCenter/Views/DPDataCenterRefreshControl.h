//
//  DPDataCenterRefreshControl.h
//  Jackpot
//
//  Created by wufan on 15/9/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPDataCenterRefreshState) {
    DPDataCenterRefreshStateStopped,
    DPDataCenterRefreshStateTriggered,
    DPDataCenterRefreshStateLoading,
};

@interface DPDataCenterRefreshControl : UIControl
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, assign) DPDataCenterRefreshState refreshState;
@end
