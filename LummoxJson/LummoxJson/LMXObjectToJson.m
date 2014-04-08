//
//  LMXObjectToJson.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import "LMXObjectToJson.h"

#import "LMXIntrospectionUtilities.h"

@implementation LMXObjectToJson

@end

@implementation NSObject (LMXObjectToJson)

- (id)lmx_jsonObject {
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    [self lmx_enumeratePropertyValuesWithBlock:^(NSString *name, LMXIntrospectionType *type, id value) {
        if (value) {
            jsonObject[name] = [value lmx_jsonObject];
        }
    }];
    
    return [jsonObject copy];
}

- (NSString *)lmx_jsonString {
    id jsonObject = [self lmx_jsonObject];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
    
    if (!data) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

/*
 Each type of object will return Json in their own way.
 */

@implementation NSString (LMXObjectToJson)

- (id)lmx_jsonObject {
    return [self copy];
}

@end

@implementation NSNumber (LMXObjectToJson)

- (id)lmx_jsonObject {
    return [self copy];
}

@end

@implementation NSArray (LMXObjectToJson)

- (id)lmx_jsonObject {
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id jsonObject = [obj lmx_jsonObject];
        if (jsonObject) {
            [jsonArray addObject:jsonObject];
        }
    }];
    
    return [jsonArray copy];
}

@end

@implementation NSDictionary (LMXObjectToJson)

- (id)lmx_jsonObject {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id keyJsonObject = [key lmx_jsonObject];
        id valueJsonObject = [obj lmx_jsonObject];
        
        if (keyJsonObject && valueJsonObject) {
            jsonDictionary[keyJsonObject] = valueJsonObject;
        }
    }];
    
    return jsonDictionary;
}

@end