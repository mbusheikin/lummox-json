//
//  LMXJsonUtilities.m

//
//  Created by Michael Busheikin on 8/24/13.
//  Copyright (c) 2013 Button Mash Games. All rights reserved.
//

#import "LMXJsonUtilities.h"

@implementation LMXJsonUtilities

+ (NSString *)lmx_jsonStringFromObject:(id)jsonObject prettyPrint:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"LMXJsonUtilities jsonStringFromObject, got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
