//
//  DPHLRankingViewModel.h
//  Jackpot
//
//  Created by mu on 15/12/31.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPHLObject.h"
#import "Wages.pbobjc.h"
@interface DPHLRankingViewModel : NSObject
@property (nonatomic, strong) FansRanking *weekFansRanking;
@property (nonatomic, strong) FansRanking *monthFansRanking;
@property (nonatomic, strong) FansRanking *totalFansRanking;
@property (nonatomic, strong, readonly) NSMutableArray *weekRankingArray;
@property (nonatomic, strong, readonly) NSMutableArray *monthRankingArray;
@property (nonatomic, strong, readonly) NSMutableArray *totalRankingArray;
@end
