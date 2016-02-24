//
//  DPHLHotMatchDetailViewModel.h
//  Jackpot
//
//  Created by mu on 15/12/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPHLObject.h"
#import "Wages.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"
@interface DPHLHotMatchDetailViewModel : NSObject
@property (nonatomic, strong) DPHLObject *headerObject;
@property (nonatomic, strong) MatchWages *matchWages;
@property (nonatomic, strong) MatchComments *matchComments;
@property (nonatomic, strong) NSMutableArray *matchWagesArray;
@property (nonatomic, strong) NSMutableArray *matchCommentsArray;

@end
