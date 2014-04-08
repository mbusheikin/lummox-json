//
//  LMXTestPerson.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-07.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMXTestType : NSObject

@property (nonatomic) int intProperty;
@property (nonatomic) NSInteger integerProperty;
@property (nonatomic) BOOL boolProperty;
@property (nonatomic, strong) NSNumber *numberProperty;

@property (nonatomic, strong) NSString *misspelledProperty; //@"mmisspelledProperty" also maps here.

@property (nonatomic, strong) LMXTestType *recursiveProperty;

@property (nonatomic, strong) NSArray *primitiveArrayProperty;
@property (nonatomic, strong) NSArray *recursiveArrayProperty;

@property (nonatomic, strong) NSDictionary *primitiveDictionaryProperty;

@end
