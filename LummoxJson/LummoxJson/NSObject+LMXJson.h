//
//  NSObject+LMXJson.h

//
//  Created by Michael Busheikin on 6/1/13.
//  Copyright (c) 2013 Button Mash Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LMXJson)

/*!
 Get one of the json types (array, string, dictionary, number) for this object.
 */
- (id)lmx_jsonEncodedObject;
- (void)lmx_encodeInDictionary:(NSMutableDictionary *)dictionary concise:(BOOL)isConcise;

- (instancetype)lmx_initWithJsonObject:(id)jsonObject;

- (instancetype)lmx_initWithJsonString:(NSString *)jsonString;
- (instancetype)lmx_initWithJsonArray:(NSArray *)jsonArray;
- (instancetype)lmx_initWithJsonDictionary:(NSDictionary *)jsonDictionary;
- (instancetype)lmx_initWithJsonNumber:(NSNumber *)jsonNumber;

@end

@interface NSDictionary (LMXJson)

- (NSString *)lmx_jsonString;

- (id)lmx_initWithJsonDictionary:(NSDictionary *)jsonDictionary keyClass:(Class)keyClass valueClass:(Class)valueClass;

@end

@protocol LMXJsonObject <NSObject>

@end