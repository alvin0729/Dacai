//
//  KTMUserDefaults.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/3.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMUserDefaults.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

static const int SELECTOR_MAX = 20;
static const int ATTRIBUTE_MAX = 100;

@implementation KTMUserDefaults {
@private
    NSUserDefaults *_userDefaults;
    NSMutableDictionary *_selectorTable;
}

static char charGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value charValue];
}

static int intGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value intValue];
}

static short shortGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value shortValue];
}

static long longGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value longValue];
}

static long long longLongGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value longLongValue];
}

static float floatGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value floatValue];
}

static double doubleGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value doubleValue];
}

static bool boolGetter(KTMUserDefaults *self, SEL _cmd) {
    NSNumber *value = [self objectForSelector:_cmd];
    NSParameterAssert(!value || [value isKindOfClass:[NSNumber class]]);
    return [value boolValue];
}

static id objectGetter(KTMUserDefaults *self, SEL _cmd) {
    return [self objectForSelector:_cmd];
}

static void charSetter(KTMUserDefaults *self, SEL _cmd, char value) {
    [self setObject:[NSNumber numberWithChar:value] forSelector:_cmd];
}

static void intSetter(KTMUserDefaults *self, SEL _cmd, int value) {
    [self setObject:[NSNumber numberWithInt:value] forSelector:_cmd];
}

static void shortSetter(KTMUserDefaults *self, SEL _cmd, short value) {
    [self setObject:[NSNumber numberWithShort:value] forSelector:_cmd];
}

static void longSetter(KTMUserDefaults *self, SEL _cmd, long value) {
    [self setObject:[NSNumber numberWithLong:value] forSelector:_cmd];
}

static void longLongSetter(KTMUserDefaults *self, SEL _cmd, long long value) {
    [self setObject:[NSNumber numberWithLongLong:value] forSelector:_cmd];
}

static void floatSetter(KTMUserDefaults *self, SEL _cmd, float value) {
    [self setObject:[NSNumber numberWithFloat:value] forSelector:_cmd];
}

static void doubleSetter(KTMUserDefaults *self, SEL _cmd, double value) {
    [self setObject:[NSNumber numberWithDouble:value] forSelector:_cmd];
}

static void boolSetter(KTMUserDefaults *self, SEL _cmd, bool value) {
    [self setObject:[NSNumber numberWithBool:value] forSelector:_cmd];
}

static void objectSetter(KTMUserDefaults *self, SEL _cmd, id value) {
    [self setObject:value forSelector:_cmd];
}

#pragma mark - Life cycle
+ (KTMUserDefaults *)standardUserDefaults {
    static KTMUserDefaults *userDefaults;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaults = [[KTMUserDefaults alloc] init_];
    });
    return userDefaults;
}

- (instancetype)init_ {
    _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass(self.class)];
    _selectorTable = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [self generatePropertySelector];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Interface
- (void)synchronize {
    [_userDefaults synchronize];
}

#pragma mark - Notification
- (void)applicationWillTerminate:(NSNotification *)notification {
    [_userDefaults synchronize];
}

#pragma mark - Internal Interface

- (void)generatePropertySelector {
    // iOS Developer Library: Objective-C Runtime Programming Guide
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048
    
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++) {
        
        objc_property_t propertyItem = propertyList[i];
        
        const char *name = property_getName(propertyItem);
        const char *attr = property_getAttributes(propertyItem);
        
        assert(strlen(attr) < ATTRIBUTE_MAX);
        
        const char *delim = ",";
        char encode = 0;
        char getterName[SELECTOR_MAX + 1] = { 0 };
        char setterName[SELECTOR_MAX + 1] = { 0 };
        char attrTemp[ATTRIBUTE_MAX + 1] = { 0 };
        
        strcpy(attrTemp, attr);
        char *substr = strtok(attrTemp, delim);
        while (substr) {
            assert(strlen(substr) > 0);
            
            char ch = substr[0];
            switch (ch) {
                case 'R':  case 'W':
                    NSAssert(NO, @"invaild property");
                    break;
                case 'G':
                    assert(strlen(substr) < SELECTOR_MAX);
                    strcpy(getterName, substr + 1);
                    break;
                case 'S':
                    assert(strlen(substr) < SELECTOR_MAX);
                    strcpy(setterName, substr + 1);
                    break;
                case 'T':
                    assert(strlen(substr) >= 2);
                    encode = substr[1];
                    break;
                case 'C': case '&': case 'N': case 'D':
                    break;
                default:
                    NSAssert(NO, @"unknown declared");
                    break;
            }
            
            substr = strtok(NULL, delim);
        }
        
        IMP getterIMP = nil;
        IMP setterIMP = nil;
        
        switch (encode) {
            case 'c':   // A char
            case 'C':   // An unsigned char
                getterIMP = (IMP)charGetter;
                setterIMP = (IMP)charSetter;
                break;
            case 'i':   // An int
            case 'I':   // An unsigned int
                getterIMP = (IMP)intGetter;
                setterIMP = (IMP)intSetter;
                break;
            case 's':   // A short
            case 'S':   // An unsigned short
                getterIMP = (IMP)shortGetter;
                setterIMP = (IMP)shortSetter;
                break;
            case 'l':   // A long: l is treated as a 32-bit quantity on 64-bit programs.
            case 'L':   // An unsigned long
                getterIMP = (IMP)longGetter;
                setterIMP = (IMP)longSetter;
                break;
            case 'q':   // A long long
            case 'Q':   // An unsigned long long
                getterIMP = (IMP)longLongGetter;
                setterIMP = (IMP)longLongSetter;
                break;
            case 'f':   // A float
                getterIMP = (IMP)floatGetter;
                setterIMP = (IMP)floatSetter;
                break;
            case 'd':   // A double
                getterIMP = (IMP)doubleGetter;
                setterIMP = (IMP)doubleSetter;
                break;
            case 'B':   // A C++ bool or a C99 _Bool
                getterIMP = (IMP)boolGetter;
                setterIMP = (IMP)boolSetter;
                break;
            case '@':   // An object (whether staticalyy typed or typed id)
                getterIMP = (IMP)objectGetter;
                setterIMP = (IMP)objectSetter;
                break;
            default:
                NSAssert(NO, @"unsupport encode");
                break;
        }
        
        Class cls = [self class];
        char setterTypes[SELECTOR_MAX], getterTypes[SELECTOR_MAX];
        sprintf(setterTypes, "v@:%c", encode);
        sprintf(getterTypes, "%c@:", encode);
        
        if (!strlen(setterName)) {
            assert(strlen(name) + 4 < SELECTOR_MAX);
            sprintf(setterName, "set%s:", name);
            if (isalpha(setterName[3])) {   // upper
                setterName[3] &= ~0x20;
            }
        }
        if (!strlen(getterName)) {
            assert(strlen(name) < SELECTOR_MAX);
            strcpy(getterName, name);
        }

        SEL setterSEL = sel_registerName(setterName);
        class_addMethod(cls, setterSEL, setterIMP, setterTypes);
        
        SEL getterSEL = sel_registerName(getterName);
        class_addMethod(cls, getterSEL, getterIMP, getterTypes);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        [_selectorTable setObject:propertyName forKey:[NSString stringWithUTF8String:setterName]];
        [_selectorTable setObject:propertyName forKey:[NSString stringWithUTF8String:getterName]];
    }
    free(propertyList);
}

- (void)setObject:(id)anObject forSelector:(SEL)aSelector {
    NSLog(@"setObject: %@ forSelector: %@", anObject, NSStringFromSelector(aSelector));
    NSString *propertyName = [_selectorTable objectForKey:NSStringFromSelector(aSelector)];
    if (propertyName) {
        if (anObject) {
            [_userDefaults setObject:anObject forKey:propertyName];
        } else {
            [_userDefaults removeObjectForKey:propertyName];
        }
    }
}

- (id)objectForSelector:(SEL)aSelector {
    NSLog(@"objectForSelector: %@", NSStringFromSelector(aSelector));
    NSString *propertyName = [_selectorTable objectForKey:NSStringFromSelector(aSelector)];
    if (propertyName) {
        return [_userDefaults objectForKey:propertyName];
    }
    return nil;
}

@end
