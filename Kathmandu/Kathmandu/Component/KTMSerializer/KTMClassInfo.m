//
//  KTMClassInfo.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMClassInfo.h"
#import "NSObject+KTMSerializer.h"

@implementation KTMClassInfo

+ (instancetype)infoWithClass:(Class)cls {
    return [[KTMClassInfo alloc] initWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls {
    if (self = [super init]) {
        _cls = cls;
        _superCls = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        if (!_isMeta) {
            _metaCls = objc_getMetaClass(object_getClassName(cls));
        }
        _name = NSStringFromClass(cls);
        _superClassInfo = [self.class infoWithClass:_superCls];
        
        [self introspector];
    }
    return self;
}

- (void)introspector {
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(_cls, &propertyCount);
    if (propertys) {
        NSMutableDictionary *propertyDict = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
        for (int i = 0; i < propertyCount; i++) {
            KTMClassPropertyInfo *propertyInfo = [[KTMClassPropertyInfo alloc] initWithProperty:propertys[i]];
            [propertyDict setObject:propertyInfo forKey:propertyInfo.name];
        }
        free(propertys);
        _propertyDict = propertyDict;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"cls: %@, superCls: %@, metaCls: %@, isMeta: %@, name:%@", _cls ? NSStringFromClass(_cls) : @"", _superCls ? NSStringFromClass(_superCls) : @"", _metaCls ? NSStringFromClass(_metaCls) : @"", _isMeta ? @"YES" : @"NO", _name];
}

@end

@interface KTMClassPropertyInfo ()
@property (nonatomic, strong, readonly) NSMutableArray *keyNameList;
@end

@implementation KTMClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        _property = property;
        _keyNameList = [NSMutableArray array];
        
        const char *name = property_getName(property);
        _name = [NSString stringWithUTF8String:name];
        
        static const int TMEP_LENGTH = 80;
        char temp[TMEP_LENGTH + 4];
        KTMEncodingType type = 0;
        
        unsigned int attributeCount = 0;
        objc_property_attribute_t * attributes = property_copyAttributeList(property, &attributeCount);
        for (int i = 0; i < attributeCount; i++) {
            switch (*attributes[i].name) {
                case 'R':
                    type |= KTMEncodingTypePropertyReadonly;
                    break;
                case 'C':
                    type |= KTMEncodingTypePropertyCopy;
                    break;
                case '&':
                    type |= KTMEncodingTypePropertyRetain;
                    break;
                case 'N':
                    type |= KTMEncodingTypePropertyNonatomic;
                    break;
                case 'G':
                    KTMAssert(attributes[i].value);
                    type |= KTMEncodingTypePropertyCustomGetter;
                    _getter = [NSString stringWithUTF8String:attributes[i].value];
                    break;
                case 'S':
                    KTMAssert(attributes[i].value);
                    type |= KTMEncodingTypePropertyCustomSetter;
                    _setter = [NSString stringWithUTF8String:attributes[i].value];
                    break;
                case 'D':
                    type |= KTMEncodingTypePropertyDynamic;
                    break;
                case 'W':
                    type |= KTMEncodingTypePropertyWeak;
                    break;
                case 'V':
                    KTMAssert(attributes[i].value);
                    _ivarName = [NSString stringWithUTF8String:attributes[i].value];
                    break;
                case 'T':
                    KTMAssert(attributes[i].value);
                    type |= [self typeForAttribute:attributes[i]];
                    if (type & KTMEncodingTypeObject) {
                        size_t len = strlen(attributes[i].value);
                        KTMAssert(TMEP_LENGTH > len && len > 3);
                        
                        memcpy(temp, attributes[i].value + 2, len - 3);
                        temp[len - 3] = '\0';
                        _cls = objc_getClass(temp);
                    }
                    _typeEncoding = [NSString stringWithUTF8String:attributes[i].value];
                    break;
                case 'P': case 't': default:
                    KTMAssert(NO);
                    break;
            }
        }
        free(attributes);
        
        if (!_setter) {
            KTMAssert(TMEP_LENGTH > strlen(name) + 4);
            sprintf(temp, "set%s:", name);
            if (islower(temp[3])) {   // upper
                temp[3] &= ~0x20;
            }
            _setter = [NSString stringWithUTF8String:temp];
        }
        if (!_getter) {
            _getter = _name;
        }
        
        _type = type;
    }
    return self;
}

#pragma mark - Private Method

- (KTMEncodingType)typeForAttribute:(objc_property_attribute_t)attribute {
    switch (*attribute.value) {
        case 'c':
            return KTMEncodingTypeInt8;
        case 's':
            return KTMEncodingTypeInt16;
        case 'i':
        case 'l':
            return KTMEncodingTypeInt32;
        case 'q':
            return KTMEncodingTypeInt64;
        case 'C':
            return KTMEncodingTypeUInt8;
        case 'S':
            return KTMEncodingTypeUInt16;
        case 'I':
        case 'L':
            return KTMEncodingTypeUInt32;
        case 'Q':
            return KTMEncodingTypeUInt64;
        case 'f':
            return KTMEncodingTypeFloat;
        case 'd':
            return KTMEncodingTypeDouble;
        case 'D':
            return KTMEncodingTypeLongDouble;
        case 'B':
            return KTMEncodingTypeBool;
        case 'v':
            return KTMEncodingTypeVoid;
        case '*':
            return KTMEncodingTypeCString;
        case '@':
            return KTMEncodingTypeObject;
        case '#':
            return KTMEncodingTypeClass;
        case ':':
            return KTMEncodingTypeSEL;
        case '[':
            return KTMEncodingTypeCArray;
        case '{':
            return KTMEncodingTypeStruct;
        case '(':
            return KTMEncodingTypeUnion;
        case 'b':
            return KTMEncodingTypeBitField;
        case '^':
            return KTMEncodingTypePointer;
        case '?':
            return KTMEncodingTypeUnknown;
        default:
            return KTMEncodingTypeNone;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@, getter: %@, setter: %@, ivarName: %@, type: 0x%08X, typeEncoding: %@, cls: %@", _name, _getter, _setter, _ivarName, (int)_type, _typeEncoding, _cls ? NSStringFromClass(_cls) : @""];
}

@end

@implementation KTMSerializer

- (instancetype)initWithClass:(Class)cls {
    if (self = [super init]) {
        _classInfo = [KTMClassInfo infoWithClass:cls];
        
        _hasDelegate.modelPropertyBlacklist = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelPropertyBlacklist)];
        _hasDelegate.modelPropertyWhitelist = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelPropertyWhitelist)];;
        _hasDelegate.modelMappingForPropertyAndKey = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelMappingForPropertyAndKey)];
        _hasDelegate.modelMappingForContainerProperty = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelMappingForContainerProperty)];
        _hasDelegate.modelClassForDictionary = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelClassForDictionary:)];
        _hasDelegate.modelTransformFromDictionary = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelTransformFromDictionary:)];
        _hasDelegate.modelTransformToDictionary = [(id<KTMSerializer>)cls respondsToSelector:@selector(modelTransformToDictionary:)];
        
        NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
        
        KTMClassInfo *currentClassInfo = _classInfo;
        while (currentClassInfo && currentClassInfo.superCls) {
            for (NSString *name in currentClassInfo.propertyDict) {
                KTMAssert([name isKindOfClass:[NSString class]]);
                if (propertyDict[name]) {
                    continue;
                }
                
                KTMClassPropertyInfo *property = currentClassInfo.propertyDict[name];
                
                if (![property.name isEqualToString:property.getter]) {
                    [property.keyNameList addObject:property.getter];
                    if (islower(*property.getter.UTF8String)) {
                        [property.keyNameList addObject:property.getter];
                    }
                }
            }
        }
        
        
        
    }
    return self;
}



@end

@implementation KTMClassPropertyInfo (KTMSerializer)
@end
