//
//  DPFootballCenterCommentViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterCommentViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"

@implementation DPFootballCenterCommentViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/GetMatchComments";
}

-(NSDictionary*)fetchParameters{

    NSDictionary *dic = @{ @"matchid": @(self.matchId) ,@"type":@(0),@"commendId":self.commendId?self.commendId:@""};
    return dic ;
}
- (void)parserData:(NSData *)data {
    
    PBMFootComment *message = [PBMFootComment parseFromData:data error:nil];
    self.message = message;
    
    [self updateHeaderInfo:message.matchInfo];

}

@end


