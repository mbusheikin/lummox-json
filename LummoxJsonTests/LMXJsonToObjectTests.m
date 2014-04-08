//
//  LMXJsonToObjectTests.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-07.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMXJsonToObject.h"

#import "LMXTestType.h"

@interface LMXJsonToObjectTests : XCTestCase

@end

@implementation LMXJsonToObjectTests

- (void)testEmptyParsing {
    NSDictionary *json = @{};
    
    LMXTestType *test = [json lmx_objectFromJsonWithClass:[LMXTestType class]];
    XCTAssertTrue(test != nil, @"shouldn't be nil.");
    
    test = [LMXTestType new];
    
    test.primitiveArrayProperty = @[ @1 ];
    [test lmx_populateWithJson:json];
    
    XCTAssertTrue([test.primitiveArrayProperty count] == 1, @"Shouldn't be empty.");
}

- (void)testSimpleParsing {
    NSDictionary *recursiveDictionary = @{
                           @"intProperty": @11,
                           @"integerProperty": @12,
                           @"boolProperty": @YES,
                           @"numberProperty": @13,
                           @"mmisspelledProperty": @"value1",
                           @"primitiveArrayProperty": @[ @1, @2, @3],
                           @"primitiveDictionaryProperty": @{ @"key11": @"value11" },
                           };

    NSDictionary *json = @{
                           @"intProperty": @1,
                           @"integerProperty": @2,
                           @"boolProperty": @YES,
                           @"numberProperty": @3,
                           @"mmisspelledProperty": @"value",
                           @"recursiveProperty": recursiveDictionary,
                           @"primitiveArrayProperty": @[ @1, @2, @3],
                           @"recursiveArrayProperty": @[ recursiveDictionary ],
                           @"primitiveDictionaryProperty": @{ @"key1": @"value1" },
                           };
    
    LMXTestType *test = [json lmx_objectFromJsonWithClass:[LMXTestType class]];
    
    XCTAssertTrue(test.intProperty == 1, @"Wrong value.");
    XCTAssertTrue(test.integerProperty == 2, @"Wrong value.");
    XCTAssertTrue([test.numberProperty isEqualToNumber:@3], @"Wrong value.");
    XCTAssertTrue(test.boolProperty == YES, @"Wrong value.");
    XCTAssertTrue([test.misspelledProperty isEqualToString:@"value"], @"Wrong value.");
    XCTAssertTrue(test.recursiveProperty.integerProperty == 12, @"Wrong value.");
    XCTAssertTrue(([test.primitiveArrayProperty isEqualToArray:@[ @1, @2, @3]]), @"Wrong value.");
    XCTAssertTrue([test.recursiveArrayProperty count] == 1, @"Wrong value.");
    XCTAssertTrue(([test.primitiveDictionaryProperty isEqual:@{@"key1": @"value1" }]), @"Wrong value.");
    
}

@end
