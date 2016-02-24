//
//  NSObject+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KTMAdditions)

@property (nonatomic, strong, setter=dp_setUserInfo:) id dp_userInfo;

- (id)dp_setStrongObject:(id)anObject forKey:(id)aKey;
- (id)dp_removeStrongObjectForKey:(id)aKey;
- (id)dp_strongObjectForKey:(id)aKey;

- (id)dp_setWeakObject:(id)anObject forKey:(id)aKey;
- (id)dp_removeWeakObjectForKey:(id)aKey;
- (id)dp_weakObjectForKey:(id)aKey;

@end
