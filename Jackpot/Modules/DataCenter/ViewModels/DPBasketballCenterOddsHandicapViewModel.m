//
//  DPBasketballCenterOddsHandicapViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterOddsHandicapViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"

@implementation DPBasketballCenterOddsHandicapViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getbasketballmatchodds";
}

- (void)parserData:(NSData *)data {
    PBMBasketballOdds *message = [PBMBasketballOdds parseFromData:data error:nil];
    self.message = message ;
    [self updateHeaderInfo:message.match];
}

@end
