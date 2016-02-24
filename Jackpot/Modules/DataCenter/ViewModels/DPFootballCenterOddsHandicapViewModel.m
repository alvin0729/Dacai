//
//  DPFootballCenterOddsHandicapViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterOddsHandicapViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"

@implementation DPFootballCenterOddsHandicapViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getfootballodds";
}

- (void)parserData:(NSData *)data {
    
    PBMFootOddsHandicap *message = [PBMFootOddsHandicap parseFromData:data error:nil];
    self.message = message;
    [self updateHeaderInfo:message.matchInfo];
}

@end
