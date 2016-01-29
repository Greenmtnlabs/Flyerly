//
//  FlurryLogging.h
//  Untechable
//
//  Created by RIKSOF on 29/01/2016.
//  Copyright (c) 2016 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Untechable.h"
#import "Flurry.h"


@interface FlurryLogging : NSObject{
    Untechable *untechable;
}

-(void)untechCreationFlurryLog: (NSString *) untechType untechableModel:(Untechable *)untechableModel;

@end
