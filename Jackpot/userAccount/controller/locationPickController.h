//
//  locationPickController.h
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  归属地信息



typedef void(^locationSelectBlock) (NSString *location,NSString *locationCode);
@interface locationPickController : UIViewController
/**
 *  locationBlock
 */
@property (nonatomic, copy) locationSelectBlock locationBlock;//归属地选择后回调

@end
