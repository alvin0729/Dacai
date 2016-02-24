//
//  DPBankListConfigure.m
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBankListConfigure.h"

@interface DPBankInfo ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger type;
@end

@implementation DPBankInfo
@end

@interface DPBankListConfigure ()
@property (nonatomic, strong) NSArray *bankList;
@end

@implementation DPBankListConfigure

- (instancetype)init {
    if (self = [super init]) {
        [self loadConfigureFromFile];
    }
    return self;
}

- (void)loadConfigureFromFile {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Configure/bank.csv"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *lines = [text componentsSeparatedByString:@"\n"];
        NSMutableArray *infoList = [NSMutableArray arrayWithCapacity:lines.count];
        for (int i = 1; i < lines.count; i++) {
            NSString *bank = [lines dp_safeObjectAtIndex:i];
            NSArray *separated = [bank componentsSeparatedByString:@","];
            if (separated.count != 4) {
                continue;
            }
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            NSString *code = [[separated dp_safeObjectAtIndex:0] stringByTrimmingCharactersInSet:characterSet];
            NSString *name = [[separated dp_safeObjectAtIndex:1] stringByTrimmingCharactersInSet:characterSet];
            NSString *type = [[separated dp_safeObjectAtIndex:2] stringByTrimmingCharactersInSet:characterSet];
            NSString *order = [[separated dp_safeObjectAtIndex:3] stringByTrimmingCharactersInSet:characterSet];
            
            DPBankInfo *info = [[DPBankInfo alloc] init];
            info.code = code;
            info.name = name;
            info.type = type.integerValue;
            info.order = order.integerValue;
            
            [infoList addObject:info];
        }
        self.bankList = infoList;
    }
}

@end
