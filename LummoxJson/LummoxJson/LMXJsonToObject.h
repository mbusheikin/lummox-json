//
//  LMXJsonToObject.h
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-05.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Here lies code to go from an NSDictionary from json, to a full ObjC model object.
 
 Simple usage: Either
 MyModel *object = [jsonDictionary lmx_objectFromJsonWithClass:[MyModel class]];  -OR-
 
 MyModel *object = [[MyModel alloc] initWithSomething:@"Hello"]; // If you want a custom init.
 [object lmx_populateWithJson:jsonDictionary];
 
 A few gotchas:
 - Doesn't support nested arrays. You have to implement lmx_setJsonValue:forJsonKey: to do it.
 - Supports NSDictionary properties in the model, but those must contain only foundation objects. 
    (this could be improved with more coding).
 - You MUST implement lmx_classForJson:inArrayWithKey: if you have an array property with custom objects.
 
 Future improvements.
 1) The parser could delegate to the model object to create new objects for properties instead of calling new.
    Really, we'd just have to add an - (id)lmx_createObjectForPropertyNamed:
 2) We could cache a bunch of values, like the mapping of keys. To do this we'd probably want to internally pass around a parser object that holds some useful state, like the cache. 
 3) We should support NSDictionaries having custom objects as values, similar to how we do for arrays.
 4) Simplify how models specify the class for their objects. There was a nice hack by a json library
    that used fake protocols to have something like NSArray<MyClass> *myArray; 
 */

@interface NSDictionary (LMXJsonToObject)

/*!
 Creates and returns a new object of type aClass, with the data from this dictionary populated.
 This is one of the two main methods
 to start the json parsing. The other is [NSObject lmx_populateWithJson:].
 */
- (id)lmx_objectFromJsonWithClass:(Class)aClass;

@end

@interface NSObject (LMXJsonToObject)

/*!
 Fill the model with the data from the json dictionary. This is one of the two main methods
 to start the json parsing. The other is [NSDictionary objectFromJsonWithClass:].
 */
- (void)lmx_populateWithJson:(NSDictionary *)json;

/*!
 Ask the model object what class of object to create for a json object in an array.
 \param json The json object from which we'll create a model object in the array.
 \param propertyKey The name of the array property on the model. Use this to differentiate between
    array properties.
 \returns The class of object that the parser should create to put in the array. For example, if you have 
    a @code @property (nonatomic, strong) NSArray *bar; @endcode and you want the NSDictionary objects from JSON
    to convert into MyClass objects, return [MyClass class].
 \discussion
    You must implement this in a model object if your array contains custom objects 
    (ie, non-foundation objects).
    If it is meant to be an array of strings, and the json array contains string, you don't need to implement this.
 
    Important note: If you do not want an object in the json array to be added to the model array,
    return nil for that object. The default implementation just returns the class of the json object, 
    meaning that the model array will contain exactly the json object.
 */
- (Class)lmx_classForJson:(id)json inArrayWithKey:(NSString *)propertyKey;

/*!
 Asks the model object for the property name that matches the given json key.
 \param jsonKey The key from the json object
 \returns The property name for the model object.
 \discussion The default behavior converts the json key (ie. the_key_name) 
    into ObjC format (theKeyName). So if they match exactly, or match with the conversion, you 
    do not need to implement this method in your model. If you want a custom mapping, this is where you do it.
 For example, if the model has a \c personId property but the json has \c id, you have this code:
 @code 
 ...
 if ([jsonKey isEqualToString:@"id"]) {
    return @"personId";
 }
 else
 ...
 @endcode
 */
- (NSString *)lmx_propertyNameForJsonKey:(NSString *)jsonKey;

/*!
 For any type of json and any type of property, set the data into the model object.
 \param jsonValue The json object, an NSArray, NSDictionary, NSNumber or NSString.
 \param jsonKey The key from the json object. 
 \discussion You should override this in your model object if you want to handle a particular
    property in a totally custom way. For example, you need to convert a json dictionary into 
    a string property. 
 
    You must use this if you want to do something unsupported, like nested arrays.
 
    Make sure to call [super lmx_setJsonValue:forJsonKey:] for any properties
    for which you don't need the custom behavior.
 */
- (void)lmx_setJsonValue:(id)jsonValue forJsonKey:(NSString *)jsonKey;

@end
