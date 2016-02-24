//
//  DPGSItemsScrollView.h
//  Jackpot
//
//  Created by mu on 15/12/2.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPItemsScrollView.h"

@interface DPGSItemsScrollView : DPItemsScrollView
/**
 *  taskDayGet : 是否存在每日任务可领取
 */
@property (nonatomic, assign)BOOL taskDayGet;
/**
 *  taskAchieveGet : 是否存在每日任务可领取
 */
@property (nonatomic, assign)BOOL taskAchieveGet;
/**
 *  taskNewerGet : 是否存在新手任务可领取
 */
@property (nonatomic, assign)BOOL taskNewerGet;
@end
