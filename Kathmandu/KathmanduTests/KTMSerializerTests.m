//
//  KTMSerializerTests.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/21.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTMSerializer.h"
#import "KTMClassInfo.h"

@interface KTMSerializerTests : XCTestCase

@end

@implementation KTMSerializerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClassInfo {
    BOOL a = ((void)0, 0, 0 , 0, YES);
    
    int b = (1, 2, 3, 4);
    
    KTMClassInfo *classInfo = [KTMClassInfo infoWithClass:[KTMClassPropertyInfo class]];
    
    XCTAssertTrue(YES);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
