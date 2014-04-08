//
//  LMXIntrospectionUtilities.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMXIntrospectionType;

typedef void(^LMXIntrospectionPropertyBlock)(NSString *name, LMXIntrospectionType *type);
typedef void(^LMXIntrospectionPropertyValueBlock)(NSString *name, LMXIntrospectionType *type, id value);

@interface LMXIntrospectionUtilities : NSObject

@end

@interface NSObject (LMXIntrospection)

/*!
 Get some data about the type of a named property.
 */
+ (LMXIntrospectionType *)lmx_propertyTypeForKey:(NSString *)propertyKey;

/*!
 Iterate through all the properties of the class and call the block for each one.
 */
+ (void)lmx_enumeratePropertiesWithBlock:(LMXIntrospectionPropertyBlock)propertyBlock;

- (void)lmx_safeSetValue:(id)value forKey:(NSString *)key;

/*!
 Iterate through all the properties of the class, get the value for each property, and call 
 the block for each one.
 */
- (void)lmx_enumeratePropertyValuesWithBlock:(LMXIntrospectionPropertyValueBlock)propertyBlock;

@end