//
//  YWAlertViewDemoTests.m
//  YWAlertViewDemoTests
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+YW.h"

@interface YWAlertViewDemoTests : XCTestCase

@end

@implementation YWAlertViewDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
   
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        long long temp = 1537499110;
        for (int  i = 0; i < 20; i ++) {
            [NSDate dateYYYYMMDDByTimeStamp:temp];
        }
    }];
}

@end
