//
//  DPFootballCenterCompetitionViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterCompetitionViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"

@implementation DPFootballCenterCompetitionViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getfootballmatchinfo";
}

- (void)parserData:(NSData *)data {
    PBMFootEventData *message = [PBMFootEventData parseFromData:data error:nil];
    self.message = message;
    
    [self updateHeaderInfo:message.matchInfo];
}

@end
