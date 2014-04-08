//
//  LMXJsonToObject.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import "LMXJsonToObject.h"

#import "LMXIntrospectionUtilities.h"
#import "LMXIntrospectionType.h"

@interface NSObject (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName;

@end


@implementation NSObject (LMXJsonToObject)

- (Class)lmx_classForJson:(id)json inArrayWithKey:(NSString *)propertyKey {
    // By default, we use whatever the type is of the json object, so the array will stay the same.
    return [json class];
}

- (NSString *)lmx_propertyNameForJsonKey:(NSString *)jsonKey {
    if (!jsonKey) {
        return nil;
    }
    
    // By default, we just normalize the json keys name to be Objc format
    NSMutableArray *keyComponents = [[jsonKey componentsSeparatedByString:@"_"] mutableCopy];
    for (int i = 1; i < [keyComponents count]; i++) {
        NSString *component = keyComponents[i];
        NSString *firstLetterString = [component substringWithRange:NSMakeRange(0, 1)];
        NSString *firstLetterUppercase = [firstLetterString uppercaseString];
        NSString *upperComponent = [component stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetterUppercase];
        
        keyComponents[i] = upperComponent;
    }
    
    return [keyComponents componentsJoinedByString:@""];
}

- (void)lmx_setJsonValue:(id)jsonValue forJsonKey:(NSString *)jsonKey {
    NSString *propertyName = [self lmx_propertyNameForJsonKey:jsonKey];
    
    [jsonValue lmx_addToObject:self forPropertyNamed:propertyName];
}

- (void)lmx_populateWithJson:(NSDictionary *)json {
    [json enumerateKeysAndObjectsUsingBlock:^(NSString *jsonKey, id jsonValue, BOOL *stop) {
        [self lmx_setJsonValue:jsonValue forJsonKey:jsonKey];
    }];
}

@end

@implementation NSDictionary (LMXJsonToObject)

- (id)lmx_objectFromJsonWithClass:(Class)aClass {
    NSObject *object = [aClass new];
    [object lmx_populateWithJson:self];
    return object;
}

@end

#pragma mark - Json object methods

@implementation NSObject (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName {
    // This should never execute
    NSAssert(NO, @"[NSObject lmx_addToObject:forPropertyNamed:] should never be called.");
}

@end

@implementation NSArray (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName {
    // If the property isn't also an array, there's not much we can do.
    LMXIntrospectionType *propertyType = [[object class] lmx_propertyTypeForKey:propertyName];
    
    BOOL isArrayProperty = (propertyType.primitiveType == LMXIntrospectionPrimitiveTypeObject &&
                            [propertyType.objectClass isSubclassOfClass:[NSArray class]]);
    
    if (isArrayProperty) {
        NSMutableArray *mutableObjectArray = [NSMutableArray arrayWithCapacity:[self count]];
        
        for (id jsonObject in self) {
            Class objectClass = [object lmx_classForJson:jsonObject inArrayWithKey:propertyName];
            
            if (!objectClass) {
                continue;
            }
            
            // We need to do a bunch of type checking to make sure the conversion is kosher.
            // Example: The object says that "myProperty" is an array, but we have a json dictionary.
            // In those cases, we'll silently fail.
            if ([objectClass isSubclassOfClass:[NSString class]]) {
                if ([jsonObject isKindOfClass:[NSString class]]) {
                    [mutableObjectArray addObject:jsonObject];
                }
            } else if ([objectClass isSubclassOfClass:[NSNumber class]]) {
                if ([jsonObject isKindOfClass:[NSNumber class]]) {
                    [mutableObjectArray addObject:jsonObject];
                }
            } else if ([objectClass isSubclassOfClass:[NSArray class]]) {
                NSLog(@"LMX json parsing doesn't currently support arrays within arrays. Handle it yourself by overriding lmx_setJsonValue:forJsonKey: in your model object");
            } else if ([objectClass isSubclassOfClass:[NSDictionary class]]) {
                NSLog(@"LMX json parsing doesn't currently support dictionaries within arrays. Handle it yourself by overriding lmx_setJsonValue:forJsonKey: in your model object");
            } else {
                if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                    id arrayObject = [(NSDictionary *)jsonObject lmx_objectFromJsonWithClass:objectClass];
                    [mutableObjectArray addObject:arrayObject];
                }
            }
        }
        
        [object setValue:mutableObjectArray forKey:propertyName];
    }
}

@end

@implementation NSDictionary (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName {
    LMXIntrospectionType *propertyType = [[object class] lmx_propertyTypeForKey:propertyName];

    if (propertyType.primitiveType == LMXIntrospectionPrimitiveTypeObject) {
        // If the target property is a dictionary, we use the Json dictionary as-is.
        if ([propertyType.objectClass isSubclassOfClass:[NSDictionary class]]) {
            [object setValue:self forKey:propertyName];
        } else {
            id propertyObject = [self lmx_objectFromJsonWithClass:propertyType.objectClass];
            [object lmx_safeSetValue:propertyObject forKey:propertyName];
        }
    }
}

@end

@implementation NSString (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName {
    // Make sure the types match.
    LMXIntrospectionType *propertyType = [[object class] lmx_propertyTypeForKey:propertyName];
    if (propertyType.primitiveType == LMXIntrospectionPrimitiveTypeObject &&
        propertyType.objectClass == [NSString class]) {
        [object setValue:self forKeyPath:propertyName];
    }
}

@end

@implementation NSNumber (LMXJsonToObjectJson)

- (void)lmx_addToObject:(id)object forPropertyNamed:(NSString *)propertyName {
    // Make sure the types match.
    LMXIntrospectionType *propertyType = [[object class] lmx_propertyTypeForKey:propertyName];
    
    BOOL isNumberProperty = (propertyType.primitiveType == LMXIntrospectionPrimitiveTypeObject &&
                             propertyType.objectClass == [NSNumber class]);
    BOOL isNumericPrimitive = (propertyType.primitiveType == LMXIntrospectionPrimitiveTypeInteger ||
                               propertyType.primitiveType == LMXIntrospectionPrimitiveTypeBoolean);
    
    if (isNumberProperty || isNumericPrimitive) {
        [object setValue:self forKeyPath:propertyName];
    }
}

@end
