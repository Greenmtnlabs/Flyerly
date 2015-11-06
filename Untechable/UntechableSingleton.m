//
//  UntechableSingleton.m
//  Untechable
//
//  Created by rufi on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "UntechableSingleton.h"

@implementation UntechableSingleton

@synthesize accounts,inputValue,sharelink,iosVersion,NBUimage,appOpenFirstTime,gallerComesFromCamera;

static UntechableSingleton *sharedSingleton = nil;

+(UntechableSingleton *)RetrieveSingleton
{
    @synchronized(self)
    {
        if(sharedSingleton ==nil)
        {
            sharedSingleton =[[UntechableSingleton alloc]init];
        }
    }
    return sharedSingleton;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(sharedSingleton == nil)
        {
            sharedSingleton = [super allocWithZone:zone];
            return  sharedSingleton;
        }
    }
    return nil;
}

+ (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+ (void)showNotConnectedAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect & try again." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}


@end
