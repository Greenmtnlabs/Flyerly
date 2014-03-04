	//
//  fbSubClass.m
//  Flyr
//
//  Created by Khurram on 25/02/2014.
//
//

#import "FlyerlyFacebookFriends.h"


@interface FlyerlyFacebookFriends ()

@end

@implementation FlyerlyFacebookFriends

@synthesize friendsList;



#pragma mark  SHAREKIT OVERRIDE METHODS

+ (BOOL)canShareItem:(SHKItem *)item
{
    return YES ;
}


- (BOOL)shouldShareSilently {
    
    return YES;
}

- (BOOL)validateItem
{
    return YES;
}


-(void)FBUserInfoRequestHandlerCallback:(FBRequestConnection *)connection
                                 result:(id) result
                                  error:(NSError *)error
{
	if(![self.pendingConnections containsObject:connection]){
		NSLog(@"SHKFacebook - received a callback for a connection not in the pending requests.");
	}
    
	[self.pendingConnections removeObject:connection];
    
	if (error) {
        
        if ([self.shareDelegate respondsToSelector:@selector(sharer:failedWithError:shouldRelogin:)])
            [self.shareDelegate sharer:self failedWithError:error shouldRelogin:NO];

	}else{
        
		//[result  convertNSNullsToEmptyStrings];
        self.friendsList = result;
		[self sendDidFinishWithResponse:result];
	}
    
	[FBSession.activeSession close];	// unhook us
    
}

- (void)sendDidFinishWithResponse:(NSDictionary *)response {
    
    
    if ([self.shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
		[self.shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
}

- (void)doSend {

    [self setQuiet:YES];
    
    
    FBRequest *request = [[FBRequest alloc] initWithSession:[FBSession activeSession]
                                                   graphPath:@"me/friends"
                            parameters:@{@"fields":@"name,gender,picture.height(72).width(72).type(small)"}
                                                  HTTPMethod:nil];
                          
    FBRequestConnection* con = [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [self FBUserInfoRequestHandlerCallback:connection result:result error:error];
        
    }];
   
    [self.pendingConnections addObject:con];
    
}


@end
