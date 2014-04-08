//
//  LMXIntrospectionUtilities.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import "LMXIntrospectionUtilities.h"
#import <objc/runtime.h>

#import "LMXIntrospectionType.h"

@implementation LMXIntrospectionUtilities

@end

@implementation NSObject (LMXIntrospection)

+ (void)lmx_enumeratePropertiesWithBlock:(LMXIntrospectionPropertyBlock)propertyBlock {
    if (!propertyBlock) {
        NSLog(@"Warning: Passing nil block into lmx_enumeratePropertiesWithBlock:");
        return;
    }
    uint outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    
    if (propertyList == NULL) {
        return;
    }
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t propertyInfo = propertyList[i];
        const char *propertyNameCString = property_getName(propertyInfo);
        NSString *propertyName = [NSString stringWithCString:propertyNameCString encoding:NSUTF8StringEncoding];
        
        LMXIntrospectionType *type = [self lmx_typeForPropertyInfo:propertyInfo];
        
        propertyBlock(propertyName, type);
    }
    
    free(propertyList);
}

- (void)lmx_enumeratePropertyValuesWithBlock:(LMXIntrospectionPropertyValueBlock)propertyBlock {
    if (!propertyBlock) {
        return;
    }
    
    [[self class] lmx_enumeratePropertiesWithBlock:^(NSString *name, LMXIntrospectionType *type) {
        id value = [self valueForKey:name];
        propertyBlock(name, type, value);
    }];
}

+ (LMXIntrospectionType *)lmx_propertyTypeForKey:(NSString *)propertyKey {
    LMXIntrospectionType *type = [LMXIntrospectionType new];
    
    if (!propertyKey) {
        type.primitiveType = LMXIntrospectionPrimitiveTypeNone;
        return type;
    }
    
    const char *propertyCString = [propertyKey cStringUsingEncoding:NSUTF8StringEncoding];
    objc_property_t propertyInfo = class_getProperty([self class], propertyCString);
    
    if (propertyInfo == NULL) {
        type.primitiveType = LMXIntrospectionPrimitiveTypeNone;
        return type;
    }
    
    return [self lmx_typeForPropertyInfo:propertyInfo];
}

- (void)lmx_safeSetValue:(id)value forKey:(NSString *)key {
    // For now, just try/catch.
    @try {
        [self setValue:value forKey:key];
    }
    @catch (NSException *exception) {
        // Silently fail, or else there's too much noise. In the future maybe make it configurable?
    }
}

#pragma mark - Helpers

+ (LMXIntrospectionType *)lmx_typeForPropertyInfo:(objc_property_t)propertyInfo {
    LMXIntrospectionType *type = [LMXIntrospectionType new];

    const char *propertyTypeCString = property_copyAttributeValue(propertyInfo, "T");
    
    // Avoid crashes if there's a problem with the type string.
    if (strlen(propertyTypeCString) < 1) {
        type.primitiveType = LMXIntrospectionPrimitiveTypeNone;
        return type;
    }
    
    // Is it an object?
    if (propertyTypeCString[0] == '@') {
        // TODO: Get the class name.
        NSString *propertyTypeString = [NSString stringWithCString:propertyTypeCString encoding:NSUTF8StringEncoding];
        
        // The type string looks like @"NSString", so get rid of the @ and ".
        NSRange normalizedRange = NSMakeRange(2, [propertyTypeString length] - 3);
        NSString *objectClassname = [propertyTypeString substringWithRange:normalizedRange];
        Class objectClass = NSClassFromString(objectClassname);
        
        type.objectClass = objectClass;
        type.primitiveType = LMXIntrospectionPrimitiveTypeObject;
        return type;
    }
    
    // Otherwise it's a real primitive. For reals.
    if (propertyTypeCString[0] == 'c') {
        // Sigh. Who would use a char property? Treat it as a bool.
        type.primitiveType = LMXIntrospectionPrimitiveTypeBoolean;
    } else {
        type.primitiveType = LMXIntrospectionPrimitiveTypeInteger;
    }
    
    return type;
}

@end