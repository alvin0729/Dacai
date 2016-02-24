//
//  DPFootballCenterAnalysisViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterAnalysisViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"

@implementation DPFootballCenterAnalysisViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/getfootballmatchanalysis";
}

- (void)parserData:(NSData *)data {
    PBMFootAnalysis *message = [PBMFootAnalysis parseFromData:data error:nil];
    self.message = message;
    [self updateHeaderInfo:message.matchInfo];
}

@end



//@implementation DPFootballCenterAnalysisDetailModel
//
//- (NSString *)fetchURL {
//    return @"/datacenter/GetFootBallMatchAnalysisDetail";
//}
//
//- (void)parserData:(NSData *)data {
//    PBMFootAnalysisDetail *message = [PBMFootAnalysisDetail parseFromData:data error:nil];
//    self.message = message;
// }
//
//
//@end