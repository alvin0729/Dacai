//
//  DPProjectDltWinView.h
//  Jackpot
//
//  Created by sxf on 15/9/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  中奖实例

#import <UIKit/UIKit.h>

@class DPProjectDltWinView;
typedef void (^clickProjectDltBlock)(DPProjectDltWinView *cancelView);
@interface DPProjectDltWinView : UIView
@property (nonatomic, copy) clickProjectDltBlock clickBlock;//中奖介绍点击事件
@end

