//
//  DPCityListConfigure.m
//  Jackpot
//
//  Created by wufan on 15/9/16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPCityListConfigure.h"

@interface DPAreaInfo () {
@private
    NSMutableArray *_children;
}
@property (nonatomic, assign) NSInteger code;       // 地区编号
@property (nonatomic, copy) NSString *province;     // 省 - e.g. @"浙江省"
@property (nonatomic, copy) NSString *city;         // 市 - e.g. @"杭州市"
@property (nonatomic, copy) NSString *canton;       // 区 - e.g. @"西湖区"
@property (nonatomic, copy) NSString *name;         // 全称 - e.g. @"浙江省杭州市西湖区"

- (void)addChildren:(DPAreaInfo *)info;
@end

@implementation DPAreaInfo
@synthesize children = _children;

- (void)addChildren:(DPAreaInfo *)info {
    if (_children == nil) {
        _children = [NSMutableArray array];
    }
    [_children addObject:info];
}

@end

@interface DPCityListConfigure ()
@property (nonatomic, strong) NSArray *areaList;
@end

@implementation DPCityListConfigure

- (instancetype)init {
    if (self = [super init]) {
        [self loadConfigureFromFile];
    }
    return self;
}

- (void)loadConfigureFromFile {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Configure/area.csv"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *lines = [text componentsSeparatedByString:@"\n"];
        NSMutableArray *infoList = [NSMutableArray arrayWithCapacity:lines.count];
        for (int i = 1; i < lines.count; i++) {
            NSString *area = [lines dp_safeObjectAtIndex:i];
            NSArray *separated = [area componentsSeparatedByString:@","];
            if (separated.count != 6) {
                continue;
            }
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            NSString *code = [[separated dp_safeObjectAtIndex:0] stringByTrimmingCharactersInSet:characterSet];
            NSString *name = [[separated dp_safeObjectAtIndex:1] stringByTrimmingCharactersInSet:characterSet];
            NSString *province = [[separated dp_safeObjectAtIndex:3] stringByTrimmingCharactersInSet:characterSet];
            NSString *city = [[separated dp_safeObjectAtIndex:4] stringByTrimmingCharactersInSet:characterSet];
            NSString *canton = [[separated dp_safeObjectAtIndex:5] stringByTrimmingCharactersInSet:characterSet];
            
            DPAreaInfo *info = [[DPAreaInfo alloc] init];
            info.code = [code integerValue];
            info.name = name;
            info.province = province;
            info.city = city;
            info.canton = canton;
            
            [infoList addObject:info];
        }
        
        [infoList sortUsingComparator:^NSComparisonResult(DPAreaInfo *obj1, DPAreaInfo *obj2) {
            return obj1.code < obj2.code ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        NSMutableArray *provinceList = [NSMutableArray array];
        for (int i = 0; i < infoList.count; i++) {
            DPAreaInfo *info = infoList[i];
            if (info.code % 10000 == 0) {       // 省
                [self addProvinceInfo:info toProvinceList:provinceList];
            } else if (info.code % 100 == 0) {  // 市
                [self addCityInfo:info toProvinceList:provinceList];
            } else {                            // 区
                [self addCantonInfo:info toProvinceList:provinceList];
            }
        }
        self.areaList = provinceList;
    }
}

- (void)addProvinceInfo:(DPAreaInfo *)info toProvinceList:(NSMutableArray *)provinceList {
    [provinceList addObject:info];
}

- (void)addCityInfo:(DPAreaInfo *)info toProvinceList:(NSMutableArray *)provinceList {
    for (DPAreaInfo *province in provinceList) {
        if (info.code / 10000 == province.code / 10000) {
            [province addChildren:info];
            break;
        }
    }
}

- (void)addCantonInfo:(DPAreaInfo *)info toProvinceList:(NSMutableArray *)provinceList {
    for (DPAreaInfo *province in provinceList) {
        if (info.code / 10000 == province.code / 10000) {
            for (DPAreaInfo *city in province.children) {
                if (info.code / 100 == city.code / 100) {
                    [city addChildren:info];
                    break;
                }
            }
            break;
        }
    }
}

@end
