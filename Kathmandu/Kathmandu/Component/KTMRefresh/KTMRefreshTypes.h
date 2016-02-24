//
//  KTMRefreshTypes.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/7.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifndef KTMRefreshTypes_h
#define KTMRefreshTypes_h

typedef NS_ENUM(NSInteger, KTMRefreshState) {
    KTMRefreshStateStopped,     // 静止, 未触发状态
    KTMRefreshStateProgress,    // 介于静止与触发之间
    KTMRefreshStateTriggered,   // 触发状态, 释放即可以触发
    KTMRefreshStateLoading,     // 加载状态
};

typedef NS_ENUM(NSInteger, KTMRefreshType) {
    KTMRefreshTypeHeader,
    KTMRefreshTypeFooter,
};

@class KTMHeaderView;
@protocol KTMRefreshProgressDelegate <NSObject>
@end

//@class KTMRefreshView;
//@protocol KTMRefreshProgressDelegate <NSObject>
//@required
//- (void)refreshView:(__kindof KTMRefreshView *)refreshView state:(KTMRefreshState)state;
//@optional
//- (void)refreshView:(__kindof KTMRefreshView *)refreshView progress:(CGFloat)progress;
//@end

#endif /* KTMRefreshTypes_h */
