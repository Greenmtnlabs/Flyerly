//
//  Person.h
//  Untechable
//
//  Created by rufi on 27/07/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject
@property NSString *name;
@property NSString *birthdate;
@property NSString *emails;

@end
RLM_ARRAY_TYPE(Person)


// This protocol enables typed collections. i.e.:
// RLMArray<Person>

