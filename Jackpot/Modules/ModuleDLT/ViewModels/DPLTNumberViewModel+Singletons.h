//
//  DPLTNumberViewModel_Singletons.h
//  DacaiProject
//
//  Created by WUFAN on 15/2/3.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  单例模式生成数据模型

#import "DPLTNumberViewModel.h"

@interface DPLTNumberViewModel (Singletons)
+ (instancetype)sharedInstance;
+ (instancetype)sharedModel:(NSInteger)gameType;
@end