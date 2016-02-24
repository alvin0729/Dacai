//
//  DPGSHomeHeaderObject.h
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Growthsystem.pbobjc.h"
@interface DPGSHomeHeaderObject : NSObject

/**
 *  icon
 */
@property (nonatomic, copy)NSString *iconImageName;
/**
 *  name
 */
@property (nonatomic, copy)NSString *nameLabelName;
/**
 *  level
 */
@property (nonatomic, copy)NSString *levelLabelName;
/**
 *  jifen
 */
@property (nonatomic, copy)NSString *jifenLabelName;
/**
 *  growValue
 */
@property (nonatomic, copy)NSString *growValueLabelName;
/**
 *  shopBtn
 */
@property (nonatomic, copy)NSString *shopBtnName;
/**
 *  ranking
 */
@property (nonatomic, copy)NSString *rankingBtnName;
@end
