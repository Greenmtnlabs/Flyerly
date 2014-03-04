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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


/*
 * HERE WE GET FREIND LIST USING SHAREKIT FOR INVITE FREINDS
 */
-(void)freindList{
    
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMyFriends];
    
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {

            //HERE WE GET FREINDS LIST
            NSLog(@"%@",result);
        
        }else {
            NSLog(@"ERROR :%@",error);
        
        }
    }];



}

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
		[self hideActivityIndicator];
		[self sendDidFailWithError:error];
	}else{
		[result convertNSNullsToEmptyStrings];
        self.friendsList = result;
		[self sendDidFinishWithResponse:result];
	}
	[FBSession.activeSession close];	// unhook us
}

- (void)doSend {

    [self setQuiet:YES];
    
    FBRequest *request = [[[FBRequest alloc] initWithSession:[FBSession activeSessionIfOpen]
                                                   graphPath:@"me/friends"
                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"id,name,username,first_name,last_name", @"fields",
                                                              nil]
                                                  HTTPMethod:nil];
                          
FBRequestConnection* con = [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self FBUserInfoRequestHandlerCallback:connection result:result error:error];
    }]
   
    [self.pendingConnections addObject:con];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
