//
//  NSObject+KTMSerializer.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/17.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KTMSerializer)
+ (instancetype)ktm_modelWithJSON:(id)json;
+ (instancetype)ktm_modelWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)ktm_modelArrayWithJSON:(id)json;
+ (NSArray *)ktm_modelArrayWithArray:(NSArray *)array;

+ (NSDictionary *)ktm_modelDictionaryWithJSON:(id)json;
+ (NSDictionary *)ktm_modelDictionaryWithDictionary:(NSDictionary *)dictionary;
@end

@protocol KTMSerializer <NSObject>
@optional
+ (NSSet *)modelPropertyBlacklist;
+ (NSSet *)modelPropertyWhitelist;
+ (NSDictionary *)modelMappingForPropertyAndKey;
+ (NSDictionary *)modelMappingForContainerProperty;

+ (Class)modelClassForDictionary:(NSDictionary *)dictionary;
- (BOOL)modelTransformFromDictionary:(NSDictionary *)dictionary;
- (BOOL)modelTransformToDictionary:(NSMutableDictionary *)dictionary;
@end