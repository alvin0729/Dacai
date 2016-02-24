//
//  KTMClassInfo.h
//  Kathmandu
//
//  Created by WUFAN on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define KTMProperty(ClassName, PropertyName)  @((NO && (((ClassName *)nil).PropertyName, NO), #PropertyName))

typedef NS_OPTIONS(NSInteger, KTMEncodingType) {
    KTMEncodingTypeNone                 = 0,    // no mean
    
    KTMEncodingTypeMask                 = 0xFF,
    KTMEncodingTypeInt8                 = 1,    // char
    KTMEncodingTypeInt16                = 2,    // short
    KTMEncodingTypeInt32                = 3,    // int; long on 32-bit programs
    KTMEncodingTypeInt64                = 4,    // long long; long on 64-bit programs
    KTMEncodingTypeUInt8                = 5,    // unsigned char
    KTMEncodingTypeUInt16               = 6,    // unsigned short
    KTMEncodingTypeUInt32               = 7,    // unsigned int; unsigned long on 32-bit programs
    KTMEncodingTypeUInt64               = 8,    // unsigned long long; unsigned long on 64-bit programs
    KTMEncodingTypeFloat                = 9,    // float
    KTMEncodingTypeDouble               = 10,   // double
    KTMEncodingTypeLongDouble           = 11,   // long doubel
    KTMEncodingTypeBool                 = 12,   // BOOL, bool
    KTMEncodingTypeVoid                 = 13,   // void
    KTMEncodingTypeCString              = 14,   // char *
    KTMEncodingTypeObject               = 15,   // id
    KTMEncodingTypeClass                = 16,   // Class
    KTMEncodingTypeSEL                  = 17,   // SEL
    KTMEncodingTypeCArray               = 18,   // int [5]
    KTMEncodingTypeStruct               = 19,   // struct
    KTMEncodingTypeUnion                = 20,   // union
    KTMEncodingTypeBitField             = 21,   // bit-field in struct
    KTMEncodingTypePointer              = 22,   // int *
    KTMEncodingTypeUnknown              = 23,   // unknown
//    KTMEncodingTypeBlock                = 24,   // block
    
    KTMEncodingTypePropertyMask         = 0xFF00,
    KTMEncodingTypePropertyReadonly     = 1 << 8,
    KTMEncodingTypePropertyCopy         = 1 << 9,
    KTMEncodingTypePropertyRetain       = 1 << 10,
    KTMEncodingTypePropertyNonatomic    = 1 << 11,
    KTMEncodingTypePropertyCustomGetter = 1 << 12,
    KTMEncodingTypePropertyCustomSetter = 1 << 13,
    KTMEncodingTypePropertyDynamic      = 1 << 14,
    KTMEncodingTypePropertyWeak         = 1 << 15,
    
    KTMEncodingTypeQualifierMask        = 0xFF0000,
    KTMEncodingTypeQualifierConst       = 1 << 16,
    KTMEncodingTypeQualifierIn          = 1 << 17,
    KTMEncodingTypeQualifierInout       = 1 << 18,
    KTMEncodingTypeQualifierOut         = 1 << 19,
    KTMEncodingTypeQualifierBycopy      = 1 << 20,
    KTMEncodingTypeQualifierByref       = 1 << 21,
    KTMEncodingTypeQualifierOneway      = 1 << 22,
};

@interface KTMClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *getter;
@property (nonatomic, strong, readonly) NSString *setter;
@property (nonatomic, strong, readonly) NSString *ivarName;
@property (nonatomic, assign, readonly) KTMEncodingType type;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, assign, readonly) Class cls;
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface KTMClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) Class superCls;
@property (nonatomic, assign, readonly) Class metaCls;
@property (nonatomic, assign, readonly) BOOL isMeta;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) KTMClassInfo *superClassInfo;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, KTMClassPropertyInfo *> *propertyDict;
+ (instancetype)infoWithClass:(Class)cls;
@end

@interface KTMSerializer : NSObject {
@package
    struct {
        unsigned modelPropertyBlacklist : 1;
        unsigned modelPropertyWhitelist : 1;
        unsigned modelMappingForPropertyAndKey : 1;
        unsigned modelMappingForContainerProperty : 1;
        
        unsigned modelClassForDictionary : 1;
        unsigned modelTransformFromDictionary : 1;
        unsigned modelTransformToDictionary : 1;
    } _hasDelegate;
    
    NSSet *_propertyBlacklist;
    NSSet *_propertyWhitelist;
    NSDictionary *_mappingForPropertyAndKey;
    NSDictionary *_mappingForContainerProperty;
    KTMClassInfo *_classInfo;
}
@end

@interface KTMClassPropertyInfo (KTMSerializer)
@property (nonatomic, strong, readonly) NSMutableArray *keyNameList;
@end

