//
//  LMXObjectToJson.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMXObjectToJson : NSObject

@end

@interface NSObject (LMXObjectToJson)

/*!
 Create a Json object made out of nested foundation objects: NSDictionary, NSArray, NSString, NSNumber
 that is a representation of this object.
 */
- (id)lmx_jsonObject;

/*!
 Simple utility for getting a Json string.
 */
- (NSString *)lmx_jsonString;

@end