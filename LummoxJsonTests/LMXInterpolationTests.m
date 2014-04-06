//
//  LMXInterpolationTests.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMXIntrospectionUtilities.h"
#import "LMXIntrospectionType.h"

@interface LMXTestClass : NSObject

@property (nonatomic) int intProperty;
@property (nonatomic) int integerProperty;
@property (nonatomic) BOOL boolProperty;
@property (nonatomic, strong) NSNumber *numberProperty;
@property (nonatomic, strong) NSString *stringProperty;
@property (nonatomic, strong) LMXTestClass *recursiveProperty;

@end

@implementation LMXTestClass

@end

@interface LMXInterpolationTests : XCTestCase

@end

@implementation LMXInterpolationTests

- (void)testClassMethods {
    LMXIntrospectionType *type;
    
    type = [LMXTestClass lmx_propertyTypeForKey:@"intProperty"];
    XCTAssertTrue(type.primitiveType == LMXIntrospectionPrimitiveTypeInteger, @"Wrong type.");
    
    type = [LMXTestClass lmx_propertyTypeForKey:@"integerProperty"];
    XCTAssertTrue(type.primitiveType == LMXIntrospectionPrimitiveTypeInteger, @"Wrong type.");
    
    type = [LMXTestClass lmx_propertyTypeForKey:@"boolProperty"];
    XCTAssertTrue(type.primitiveType == LMXIntrospectionPrimitiveTypeBoolean, @"Wrong type.");
    
    type = [LMXTestClass lmx_propertyTypeForKey:@"stringProperty"];
    XCTAssertTrue(type.primitiveType == LMXIntrospectionPrimitiveTypeObject, @"Wrong type.");
    XCTAssertTrue(type.objectClass == [NSString class], @"Wrong type.");
    
    type = [LMXTestClass lmx_propertyTypeForKey:@"recursiveProperty"];
    XCTAssertTrue(type.primitiveType == LMXIntrospectionPrimitiveTypeObject, @"Wrong type.");
    XCTAssertTrue(type.objectClass == [LMXTestClass class], @"Wrong type.");
    
    __block NSInteger propertyCount = 0;
    NSArray *propertyArray = @[@"intProperty", @"integerProperty", @"boolProperty", @"numberProperty", @"stringProperty", @"recursiveProperty"];
    NSMutableArray *seenProperties = [NSMutableArray array];
    
    // Now the enumerating method
    [LMXTestClass lmx_enumeratePropertiesWithBlock:^(NSString *name, LMXIntrospectionType *type) {
        propertyCount++;
        [seenProperties addObject:name];
    }];
    
    XCTAssertTrue(propertyCount == [propertyArray count], @"Wrong number of properties");
    XCTAssertTrue([seenProperties count] == [propertyArray count], @"Wrong number of properties");
    
    for (NSString *propertyName in propertyArray) {
        XCTAssertTrue([seenProperties containsObject:propertyName], @"Missing property: %@", propertyName);
    }
}

- (void)testObjectMethods {
    LMXTestClass *object = [LMXTestClass new];
    LMXTestClass *subObject = [LMXTestClass new];
    
    object.intProperty = 1;
    object.integerProperty = 2;
    object.numberProperty = @3;
    object.stringProperty = @"4";
    object.boolProperty = YES;
    object.recursiveProperty = subObject;
    
    __block NSInteger propertyCount = 0;
    NSArray *propertyArray = @[@"intProperty", @"integerProperty", @"numberProperty", @"boolProperty", @"stringProperty", @"recursiveProperty"];
    NSMutableDictionary *seenProperties = [NSMutableDictionary dictionary];

    [object lmx_enumeratePropertyValuesWithBlock:^(NSString *name, LMXIntrospectionType *type, id value) {
        propertyCount++;
        seenProperties[name] = value;
    }];
    
    XCTAssertTrue(propertyCount == [propertyArray count], @"Wrong number of properties");
    XCTAssertTrue([seenProperties count] == [propertyArray count], @"Wrong number of properties");
    
    XCTAssertTrue([seenProperties[@"intProperty"] intValue] == 1, @"Wrong property value");
    XCTAssertTrue([seenProperties[@"integerProperty"] intValue] == 2, @"Wrong property value");
    XCTAssertTrue([seenProperties[@"numberProperty"] isEqual:@3], @"Wrong property value");
    XCTAssertTrue([seenProperties[@"boolProperty"] boolValue] == YES, @"Wrong property value");
    XCTAssertTrue([seenProperties[@"stringProperty"] isEqualToString:@"4"], @"Wrong property value");
    XCTAssertTrue(seenProperties[@"recursiveProperty"] == subObject, @"Wrong property value");
}

@end
