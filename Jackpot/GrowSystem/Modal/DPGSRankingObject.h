//
//  DPGSRankingObject.h
//  Jackpot
//
//  Created by mu on 15/7/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    DPGSTrendTypeRise = 1,
    DPGSTrendTypeFair = 0,
    DPGSTrendTypeDrop = -1,
} DPGSTrendType;
@interface DPGSRankingObject : NSObject
@property (nonatomic, copy) NSString *numberLabelStr;
@property (nonatomic, copy) NSString *nameLabelStr;
@property (nonatomic, copy) NSString *intergralLabelStr;
@property (nonatomic, copy) NSString *rankingLabelStr;
@property (nonatomic, assign) DPGSTrendType trend;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL isDayRanking;
@property (nonatomic, assign) NSInteger indexPath;
@end
