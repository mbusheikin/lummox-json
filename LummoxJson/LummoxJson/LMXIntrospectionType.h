//
//  LMXIntrospectionPropertyType.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LMXIntrospectionPrimitiveType) {
    LMXIntrospectionPrimitiveTypeNone,
    LMXIntrospectionPrimitiveTypeObject,
    LMXIntrospectionPrimitiveTypeInteger,
    LMXIntrospectionPrimitiveTypeBoolean,
};

@interface LMXIntrospectionType : NSObject

@property (nonatomic) LMXIntrospectionPrimitiveType primitiveType;

// If the primitiveType is not LMXIntrospectionPrimitiveTypeObject, this will be nil.
@property (nonatomic) Class objectClass;

@end
