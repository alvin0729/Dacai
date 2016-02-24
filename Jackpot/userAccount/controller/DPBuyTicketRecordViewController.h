//
//  DPBuyTicketRecordViewController.h
//  Jackpot
//
//  Created by mu on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  购彩记录

#import <UIKit/UIKit.h>
/**
 *  @[@"全部",@"待支付",@"未完结",@"中奖"]
 */
typedef enum{
    indexTypeTotal = 0,
    indexTypeUnPay = 1,
    indexTypeUnfinished = 2,
    indexTypeAwarder = 3,
}indexType;

@interface DPBuyTicketRecordViewController : UIViewController
@property (nonatomic, assign)indexType index;
@end
