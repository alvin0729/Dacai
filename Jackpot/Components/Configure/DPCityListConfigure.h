//
//  DPCityListConfigure.h
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPAreaInfo : NSObject
@property (nonatomic, assign, readonly) NSInteger code;       // 地区编号
@property (nonatomic, copy, readonly) NSString *province;     // 省 - e.g. @"浙江省"
@property (nonatomic, copy, readonly) NSString *city;         // 市 - e.g. @"杭州市"
@property (nonatomic, copy, readonly) NSString *canton;       // 区 - e.g. @"西湖区"
@property (nonatomic, copy, readonly) NSString *name;         // 全称 - e.g. @"浙江省杭州市西湖区"
@property (nonatomic, strong, readonly) NSArray *children;    // 子节点
@end

@interface DPCityListConfigure : NSObject
@property (nonatomic, strong, readonly) NSArray *areaList;
@end
