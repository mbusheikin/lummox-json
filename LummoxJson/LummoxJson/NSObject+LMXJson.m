//
//  NSObject+LMXJson.m

//
//  Created by Michael Busheikin on 6/1/13.
//  Copyright (c) 2013 Button Mash Games. All rights reserved.
//

#import "NSObject+LMXJson.h"

@interface NSObject (LMXJsonInternal)
- (id)lmx_initObjectOfClass:(Class)class;
@end

@implementation NSObject (LMXJson)

- (id)lmx_jsonEncodedObject {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [self lmx_encodeInDictionary:dictionary concise:NO];
    return dictionary;
}

- (void)lmx_encodeInDictionary:(NSMutableDictionary *)dictionary concise:(BOOL)isConcise {
    // Intentionally blank.
}

- (instancetype)lmx_initWithJsonObject:(id)jsonObject {
    return [jsonObject lmx_initObjectOfClass:[self class]];
}

- (instancetype)lmx_initWithJsonString:(NSString *)jsonString {
    return [self init];
}

- (instancetype)lmx_initWithJsonArray:(NSArray *)jsonArray {
    return [self init];
}

- (instancetype)lmx_initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    return [self init];
}

- (instancetype)lmx_initWithJsonNumber:(NSNumber *)jsonNumber {
    return [self init];
}

- (id)lmx_initObjectOfClass:(Class)class {
    return [self init];
}

@end

@implementation NSDictionary (LMXJson)

- (id)lmx_initWithJsonDictionary:(NSDictionary *)jsonDictionary keyClass:(Class)keyClass valueClass:(Class)valueClass {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:[jsonDictionary count]];
    
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id decodedKey = [[keyClass alloc] lmx_initWithJsonObject:key];
        id decodedValue = [[valueClass alloc] lmx_initWithJsonObject:obj];
        
        if (decodedKey && decodedValue) {
            mutableDictionary[decodedKey] = decodedValue;
        }
    }];
    
    return [self initWithDictionary:mutableDictionary];
}

- (id)lmx_jsonEncodedObject {
    NSMutableDictionary *jsonObject = [NSMutableDictionary new];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id encodedKey = [key lmx_jsonEncodedObject];
        id encodedValue = [obj lmx_jsonEncodedObject];
        
        if (encodedKey && encodedValue) {
            jsonObject[encodedKey] = encodedValue;
        }
    }];
    
    return jsonObject;
}

- (NSString *)lmx_jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)lmx_initObjectOfClass:(Class)class {
    return [[class alloc] lmx_initWithJsonDictionary:self];
}

@end

@implementation NSArray (LMXJson)

- (id)lmx_initObjectOfClass:(Class)class {
    return [[class alloc] lmx_initWithJsonArray:self];
}

- (id)lmx_initWithJsonArray:(NSArray *)jsonArray {
    return [self initWithArray:jsonArray];
}

@end

@implementation NSString (LMXJson)

- (id)lmx_initObjectOfClass:(Class)class {
    return [[class alloc] lmx_initWithJsonString:self];
}

- (id)lmx_initWithJsonString:(NSString *)jsonString {
    return [self initWithString:jsonString];
}

@end

@implementation NSNumber (LMXJson)

- (id)lmx_initObjectOfClass:(Class)class {
    return [[class alloc] lmx_initWithJsonNumber:self];
}

- (id)lmx_initWithJsonNumber:(NSNumber *)jsonNumber {
    return [self initWithInteger:[jsonNumber integerValue]];
}

- (id)lmx_jsonEncodedObject {
    return self;
}


@end