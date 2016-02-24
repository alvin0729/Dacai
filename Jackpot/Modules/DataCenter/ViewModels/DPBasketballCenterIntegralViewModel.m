//
//  DPBasketballCenterIntegralViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterIntegralViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"

@implementation DPBasketballCenterIntegralViewModel


#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/GetBasketballTeamRanking";
}

- (void)parserData:(NSData *)data {
    PBMBasketballIntegral *message = [PBMBasketballIntegral parseFromData:data error:nil];
    
    self.message  = message ;
    [self updateHeaderInfo:message.match];
}

@end
