//
//  Singleton.m
//  SecondProject
//
//  Created by Basit on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

@synthesize accounts;

static Singleton *sharedSingleton = nil;

+(Singleton *)RetrieveSingleton
{
    @synchronized(self)
	{
		if(sharedSingleton ==nil)
		{
			sharedSingleton =[[Singleton alloc]init];
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

@end
