//
//  NSDictionary+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSDictionary+KTMAdditions.h"

@implementation NSDictionary (KTMAdditions)

- (id)dp_safeObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    return obj == [NSNull null] ? nil : obj;
}

- (id)dp_objectForCaseInsensitiveKey:(NSString *)key {
    NSParameterAssert([key isKindOfClass:[NSString class]]);
    NSArray *allKeys = [self allKeys];
    for (NSString *enumKey in allKeys) {
        if ([enumKey isKindOfClass:[NSString class]] && [key caseInsensitiveCompare:enumKey] == NSOrderedSame) {
            return [self objectForKey:enumKey];
        }
    }
    return nil;
}

@end
