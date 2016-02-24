//
//  NSObject+KTMSerializer.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "NSObject+KTMSerializer.h"

@implementation NSObject (KTMSerializer)

#pragma mark - JSON Parser

+ (id)ktm_objectFromJSON:(id)json {
    if ([json isKindOfClass:[NSArray class]]) {
        return json;
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    NSData *jsonData;
    if ([json isKindOfClass:[NSString class]]) {
        jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    }
    return nil;
}

#pragma mark - Object

+ (instancetype)ktm_modelWithJSON:(id)json {
    NSDictionary *dictionary = [self ktm_objectFromJSON:json];
    return [self ktm_modelWithDictionary:dictionary];
}

+ (instancetype)ktm_modelWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    Class cls = [self class];
    return nil;
}

#pragma mark - Array

+ (NSArray *)ktm_modelArrayWithJSON:(id)json {
    NSArray *array = [self ktm_objectFromJSON:json];
    return [self ktm_modelArrayWithArray:array];
}

+ (NSArray *)ktm_modelArrayWithArray:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    Class cls = [self class];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        id obj = [cls ktm_modelWithDictionary:dict];
        if (obj) { [result addObject:obj]; }
    }
    return result;
}

#pragma mark - Dictionary

+ (NSDictionary *)ktm_modelDictionaryWithJSON:(id)json {
    NSDictionary *dictionary = [self ktm_objectFromJSON:json];
    return [self ktm_modelDictionaryWithDictionary:dictionary];
}

+ (NSDictionary *)ktm_modelDictionaryWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    Class cls = [self class];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    for (NSString *key in dictionary.allKeys) {
        if (![key isKindOfClass:[NSString class]]) { continue; }
        id obj = [cls ktm_modelWithDictionary:dictionary[key]];
        if (obj) { [result setObject:obj forKey:key]; }
    }
    return result;
}

@end
