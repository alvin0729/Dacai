//
//  KTMRuntimeTests.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KTMClassInfo.h"

#define DbgPrint(format, ...)   printf(format "\n", ##__VA_ARGS__)

@interface KTMTestRuntimeObject : NSObject
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong, readonly, setter=setSSS:) NSString *school;
@property (nonatomic, assign) BOOL age;
@property (nonatomic, assign, getter=getRow) BOOL row;
@property (nonatomic, assign, setter=setSec:) BOOL section;
@property (nonatomic, strong) NSString *TestValue;
@property (nonatomic, assign) BOOL dynamicBOOL;
@end

@implementation KTMTestRuntimeObject
@dynamic dynamicBOOL;
@synthesize addr = _addraaa;
- (NSString *)phone {
    if (!_phone) {
        _phone = @"1234";
        
    }
    return _phone;
}


@end

@interface KTMRuntimeTests : XCTestCase

@end

@implementation KTMRuntimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClassProperty {
    unsigned int propertyCount = 0;
    DbgPrint("\n\n\n\n");
    objc_property_t *propertys = class_copyPropertyList([KTMRuntimeTests class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        unsigned int attributesCount = 0;
        objc_property_attribute_t *attributes = property_copyAttributeList(propertys[i], &attributesCount);
        const char *name = property_getName(propertys[i]);
        
        DbgPrint("=============================================");
        DbgPrint("propertyName: %s", name);
        
        for (int j = 0; j < attributesCount; j++) {
            if (attributes[j].name) DbgPrint("name: %s", attributes[j].name);
            if (attributes[j].value) DbgPrint("value: %s", attributes[j].value);
        }
    }
    DbgPrint("=============================================\n\n\n\n");
}

- (void)testEncoding {
    char *charPointer; int *intPointer;
    char charArray[5]; int intArray[6];
    char charString[] = "1234";
    
    struct ABC {
        unsigned a : 1;
        unsigned b : 2;
        unsigned c : 3;
    };
    
    struct ABC abc;
    
#define PrintEncoding(t)   printf("%-20s   %s \n", #t, @encode(t));
    
    printf("\n\n\n========================================\n\n");
    
    PrintEncoding(struct ABC);
    PrintEncoding(__typeof(abc.c));
    
    PrintEncoding(char);
    PrintEncoding(int);
    PrintEncoding(short);
    PrintEncoding(long);
    PrintEncoding(long long);
    PrintEncoding(unsigned char);
    PrintEncoding(unsigned int);
    PrintEncoding(unsigned short);
    PrintEncoding(unsigned long);
    PrintEncoding(unsigned long long);
    PrintEncoding(float);
    PrintEncoding(double);
    PrintEncoding(bool);
    PrintEncoding(void);
    
    PrintEncoding(char *);
    
    PrintEncoding(NSObject);
    PrintEncoding(NSObject *);
    PrintEncoding(BOOL);
    PrintEncoding(long double);
    
    PrintEncoding(uint8_t);
    PrintEncoding(uint16_t);
    PrintEncoding(uint32_t);
    PrintEncoding(uint64_t);
    PrintEncoding(signed long);
    
    PrintEncoding(char []);
    PrintEncoding(int []);
    
    PrintEncoding(__typeof(charString));
    
    PrintEncoding(__typeof(charPointer));
    PrintEncoding(__typeof(intPointer));
    PrintEncoding(__typeof(charArray));
    PrintEncoding(__typeof(intArray));
    
    printf("\n========================================\n\n\n\n");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
