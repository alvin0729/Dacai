//
//  DPLTNumberViewModel_Singletons.m
//  DacaiProject
//
//  Created by WUFAN on 15/2/3.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLTNumberViewModel+Singletons.h"

@implementation DPLTNumberViewModel (Singletons)

+ (instancetype)sharedInstance {
    DPException(@"subclass to implement");
}

+ (instancetype)sharedModel:(NSInteger)gameType {
    switch (gameType) {
        
        case GameTypeDlt:
            return [DPLTDltModel sharedInstance];
                default:
            DPAssert(NO);
            return nil;
    }
}

@end


@implementation DPLTDltModel (Singletons)

+ (instancetype)sharedInstance {
    static DPLTDltModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DPLTDltModel alloc] init];
    });
    return sharedInstance;
}

@end


 
