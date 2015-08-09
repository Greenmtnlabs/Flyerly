//
//  rSetUntechable.h
//  Untechable
//
//  Created by Abdul Rauf on 08/08/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "RUntechable.h"

@interface RSetUntechable : RUntechable

@end

// This protocol enables typed collections. i.e.:
// RLMArray<rSetUntechable>
RLM_ARRAY_TYPE(rSetUntechable)
