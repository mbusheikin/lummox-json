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
 Iterate through all the properties of the class and call the block for each one.
 */
+ (void)lmx_enumeratePropertiesWithBlock:(LMXIntrospectionPropertyBlock)propertyBlock;

/*!
 Iterate through all the properties of the class, get the value for each property, and call 
 the block for each one.
 */
- (void)lmx_enumeratePropertyValuesWithBlock:(LMXIntrospectionPropertyValueBlock)propertyBlock;

+ (LMXIntrospectionType *)lmx_propertyTypeForKey:(NSString *)propertyKey;

@end