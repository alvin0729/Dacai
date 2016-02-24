//
//  DPBasketballCenterCompetitionViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterCompetitionViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "BasketballDataCenter.pbobjc.h"

@implementation DPBasketballCenterCompetitionViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getbasketballmatchinfo";
}

- (void)parserData:(NSData *)data {
    PBMBasketballCompetition *message = [PBMBasketballCompetition parseFromData:data error:nil];
    
    self.message = message ;
    [self updateHeaderInfo:message.match];
}

@end
