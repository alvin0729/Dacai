//
//  DPBasketballCenterAnalysisViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterAnalysisViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"

@implementation DPBasketballCenterAnalysisViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getbasketballmatchanalysis";
}

- (void)parserData:(NSData *)data {
    PBMBasketballAnalysis *message = [PBMBasketballAnalysis parseFromData:data error:nil];
    self.message = message ;
    [self updateHeaderInfo:message.matchInfo];
}

@end
