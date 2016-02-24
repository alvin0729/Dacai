//
//  UIButton+Statistics.h
//  Jackpot
//
//  Created by wufan on 15/10/12.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DPAnalyticsKit)
@property (nonatomic, assign, setter=dp_setEventId:) NSInteger dp_eventId;
@end
