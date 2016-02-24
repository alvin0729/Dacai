//
//  DPDataCenterBaseViewModel+Private.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel+Private.h"
#import "BasketballDataCenter.pbobjc.h"
#import "FootballDataCenter.pbobjc.h"

static NSString *kDataCenterMatchInfoNotification = @"DataCenterMatchInfoNotification";
static NSString *kMessageKey = @"Message";
static NSString *kMatchIdKey = @"MatchId";


@implementation DPDataCenterBaseViewModel (Private)

- (void)updateHeaderInfo:(id)message {
    NSParameterAssert(message);

    if ([message isKindOfClass:[PBMFootballHeader class]]) {
        PBMFootballHeader *footballHeader= message;
        self.homeName = footballHeader.homeTeamName ?footballHeader.homeTeamName: self.homeName;
        self.awayName = footballHeader.awayTeamName ?footballHeader.awayTeamName: self.awayName;
     } else {
        PBMBasketballHeader *basketballHeader= message;
        self.homeName = basketballHeader.homeName ?basketballHeader.homeName: self.homeName;
        self.awayName = basketballHeader.awayName ?basketballHeader.awayName: self.awayName;
     }
    
    NSDictionary *userInfo = @{ kMessageKey : message,
                                kMatchIdKey : @(self.matchId) };
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataCenterMatchInfoNotification object:self userInfo:userInfo];
}

@end
