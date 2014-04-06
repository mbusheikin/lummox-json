//
//  LMXJsonToObject.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMXJsonToObject : NSObject

@end

@interface NSDictionary (LMXJsonToObject)

- (id)lmx_objectFromJsonWithClass:(Class)aClass;

@end