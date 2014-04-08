//
//  LMXTestPerson.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-07.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import "LMXTestType.h"

#import "LMXJsonToObject.h"

@implementation LMXTestType

- (Class)lmx_classForJson:(id)json inArrayWithKey:(NSString *)propertyKey {
    if ([propertyKey isEqualToString:@"recursiveArrayProperty"]) {
        return [LMXTestType class];
    }
    
    return [super lmx_classForJson:json inArrayWithKey:propertyKey];
}

- (NSString *)lmx_propertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"mmisspelledProperty"]) {
        return @"misspelledProperty";
    }
    
    return [super lmx_propertyNameForJsonKey:jsonKey];
}

@end
