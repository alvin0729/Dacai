//
//  DPBankListConfigure.h
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPBankInfo : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, assign, readonly) NSInteger order;
@property (nonatomic, assign, readonly) NSInteger type;
@end

@interface DPBankListConfigure : NSObject
@property (nonatomic, strong, readonly) NSArray *bankList;
@end
