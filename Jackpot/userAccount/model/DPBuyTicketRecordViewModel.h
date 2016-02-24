//
//  DPBuyTicketRecordViewModel.h
//  Jackpot
//
//  Created by mu on 16/1/25.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.pbobjc.h"
#import "DPUAObject.h"
#import "LotteryHistory.pbobjc.h"
@interface DPBuyTicketRecordViewModel : NSObject
@property (nonatomic, strong) LotteryHistoryResult *totalResult;
@property (nonatomic, strong) LotteryHistoryResult *noPayResult;
@property (nonatomic, strong) LotteryHistoryResult *noFinishResult;
@property (nonatomic, strong) LotteryHistoryResult *rewardResult;
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *noPayArray;
@property (nonatomic, strong) NSMutableArray *noFinishArray;
@property (nonatomic, strong) NSMutableArray *rewardArray;
@end
