//
//  LMXJsonUtilities.h

//
//  Created by Michael Busheikin on 8/24/13.
//  Copyright (c) 2013 Button Mash Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMXJsonUtilities : NSObject

+ (NSString *)lmx_jsonStringFromObject:(id)jsonObject prettyPrint:(BOOL)prettyPrint;

@end
