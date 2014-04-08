//
//  LMXObjectToJsonTests.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-08.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMXObjectToJson.h"

#import "LMXTestType.h"

@interface LMXObjectToJsonTests : XCTestCase

@end

@implementation LMXObjectToJsonTests

- (void)testSimple {
    LMXTestType *test = [LMXTestType new];
    
    test.intProperty = 1;
    test.integerProperty = 2;
    test.numberProperty = @3;
    test.boolProperty = YES;
    test.misspelledProperty = @"value";
    test.primitiveArrayProperty = @[ @1, @2, @3 ];
    test.primitiveDictionaryProperty = @{@"key1": @"value1"};
 
    NSDictionary *correctJson = @{
                           @"intProperty": @1,
                           @"integerProperty": @2,
                           @"boolProperty": @YES,
                           @"numberProperty": @3,
                           @"misspelledProperty": @"value",
                           @"primitiveArrayProperty": @[ @1, @2, @3],
                           @"primitiveDictionaryProperty": @{ @"key1": @"value1" },
                           };

    id jsonObject = [test lmx_jsonObject];
    
    XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]], @"Wrong type");
    
    NSLog(@"Json: %@", jsonObject);
    
    NSDictionary *jsonDictionary = jsonObject;
    
    XCTAssertTrue([jsonDictionary isEqualToDictionary:correctJson], @"Doesn't match.");
}

@end
