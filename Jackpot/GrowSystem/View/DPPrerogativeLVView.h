//
//  DPPrerogativeLVView.h
//  Jackpot
//
//  Created by mu on 15/8/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPPrepogativeObject.h"
@interface DPPrerogativeLVView : UIView
/**
 *  特权总共分几级
 */
@property (nonatomic, assign) NSInteger LVCount;
/**
 *  当前等级
 */
@property (nonatomic, assign) NSInteger currentLV;
/**
 *  当前积分
 */
@property (nonatomic, assign) CGFloat currentJifen;
/**
 *  特权对象
 */
@property (nonatomic, strong) NSMutableArray *LVHeightArray;
@end
