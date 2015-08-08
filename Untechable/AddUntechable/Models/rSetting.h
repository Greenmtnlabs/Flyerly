//
//  rSetting.h
//  Untechable
//
//  Created by Abdul Rauf on 08/08/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Realm/Realm.h>

@interface rSetting : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<rSetting>
RLM_ARRAY_TYPE(rSetting)
