//
//  DPMemberManager+Private.h
//  Jackpot
//
//  Created by wufan on 15/9/11.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPMemberManager.h"

@interface DPMemberManager ()
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSData *secureKey;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@end

@interface DPMemberManager (Private)

@end
