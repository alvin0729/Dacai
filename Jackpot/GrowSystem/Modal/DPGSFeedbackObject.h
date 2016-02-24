//
//  DPGSFeedbackObject.h
//  Jackpot
//
//  Created by mu on 15/7/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPGSFeedbackObject : NSObject
/**
 *  content
 */
@property (nonatomic, copy)NSString *contentStr;
/**
 *  date
 */
@property (nonatomic, copy)NSString *dateStr;
/**
 *  time
 */
@property (nonatomic, copy)NSString *timeStr;
/**
 *  isCurstorm
 */
@property (nonatomic, assign)BOOL isCurstorm;
/**
 *  cellHeight
 */
@property (nonatomic, assign)CGFloat cellHeight;
@end
