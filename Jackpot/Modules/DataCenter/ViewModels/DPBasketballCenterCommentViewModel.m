//
//  DPBasketballCenterCommentViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBasketballCenterCommentViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "BasketballDataCenter.pbobjc.h"

@implementation DPBasketballCenterCommentViewModel

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/GetMatchComments";
}
-(NSDictionary*)fetchParameters{
    
    NSDictionary *dic = @{ @"matchid": @(self.matchId) ,@"type":@(1),@"commendId":self.commendId?self.commendId:@""};
    return dic ;
}

- (void)parserData:(NSData *)data {
    PBMBasketballComment *message = [PBMBasketballComment parseFromData:data error:nil];
    self.message = message;
    
    [self updateHeaderInfo:message.match];
}

@end
