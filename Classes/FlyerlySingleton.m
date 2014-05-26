//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//

#import "FlyerlySingleton.h"

@implementation FlyerlySingleton

@synthesize accounts,inputValue,sharelink,iosVersion,NBUimage,appOpenFirstTime,gallerComesFromCamera;

static FlyerlySingleton *sharedSingleton = nil;

+(FlyerlySingleton *)RetrieveSingleton
{
    @synchronized(self)
	{
		if(sharedSingleton ==nil)
		{
			sharedSingleton =[[FlyerlySingleton alloc]init];
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

@end
