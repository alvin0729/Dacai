//
//  NSObject+KTMAdditions.m
//  Kathmandu
//
//  Created by WUFAN on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "NSObject+KTMAdditions.h"
#import <objc/runtime.h>

static const void *WEAK_TABLE_KEY = &WEAK_TABLE_KEY;
static const void *STRONG_TABLE_KEY = &STRONG_TABLE_KEY;
static const void *USER_INFO_KEY = &USER_INFO_KEY;

@implementation NSObject (KTMAdditions)

- (void)dp_setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, USER_INFO_KEY, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dp_userInfo {
    return objc_getAssociatedObject(self, USER_INFO_KEY);
}

- (NSMapTable *)weakMapTable {
    return objc_getAssociatedObject(self, WEAK_TABLE_KEY);
}

- (NSMapTable *)strongMapTable {
    return objc_getAssociatedObject(self, STRONG_TABLE_KEY);
}

- (id)dp_setStrongObject:(id)anObject forKey:(id)aKey {
    NSMapTable *strongMapTable = [self strongMapTable];
    if (strongMapTable == nil) {
        strongMapTable = [NSMapTable strongToStrongObjectsMapTable];
        objc_setAssociatedObject(self, STRONG_TABLE_KEY, strongMapTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [strongMapTable setObject:anObject forKey:aKey];
    
    return anObject;
}

- (id)dp_removeStrongObjectForKey:(id)aKey {
    id  object = [[self strongMapTable] objectForKey:aKey];
    if (object) {
        [[self strongMapTable] removeObjectForKey:aKey];
    }
    return object;
}

- (id)dp_strongObjectForKey:(id)aKey {
    return [[self strongMapTable] objectForKey:aKey];
}

- (id)dp_setWeakObject:(id)anObject forKey:(id)aKey {
    NSMapTable *weakMapTable = [self weakMapTable];
    if (weakMapTable == nil) {
        weakMapTable = [NSMapTable strongToWeakObjectsMapTable];
        objc_setAssociatedObject(self, WEAK_TABLE_KEY, weakMapTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [weakMapTable setObject:anObject forKey:aKey];
    
    return anObject;
}

- (id)dp_removeWeakObjectForKey:(id)aKey {
    id  object = [[self weakMapTable] objectForKey:aKey];
    if (object) {
        [[self weakMapTable] removeObjectForKey:aKey];
    }
    return object;
}

- (id)dp_weakObjectForKey:(id)aKey {
    return [[self weakMapTable] objectForKey:aKey];
}

@end
