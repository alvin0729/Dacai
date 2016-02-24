//
//  NSDictionary+KTMAdditions.h
//  Kathmandu
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KTMAdditions)

- (id)dp_safeObjectForKey:(id)key;
- (id)dp_objectForCaseInsensitiveKey:(NSString *)key;

@end
