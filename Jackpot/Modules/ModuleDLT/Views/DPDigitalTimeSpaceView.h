//
//  DPDigitalTimeSpaceView.h
//  DacaiProject
//
//  Created by sxf on 15/1/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  中转页面倒计时

#import <UIKit/UIKit.h>
#import "DPImageLabel.h"
@interface DPDigitalTimeSpaceView : UIView


@property(nonatomic,strong,readonly)DPImageLabel *highInfoLabel;//（目前只有大乐透，因此用不到）
- (instancetype)initWithFrame:(CGRect)frame  lotteryType:(NSInteger)lotteryType;
-(void)timeInfoString:(NSMutableAttributedString *)infoString;//设置倒计时
-(void)bonusString:(NSMutableAttributedString *)totalMoney;//设置奖池
@end

