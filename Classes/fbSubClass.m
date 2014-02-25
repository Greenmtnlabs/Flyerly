//
//  fbSubClass.m
//  Flyr
//
//  Created by Khurram on 25/02/2014.
//
//

#import "fbSubClass.h"


@interface fbSubClass ()

@end

@implementation fbSubClass

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
    
       SHKSharer *iosSharer = [[ SHKSharer alloc] init];
        // Create controller and set share options
        iosSharer= [[SHKFacebook alloc] init];
      BOOL STATUS =  [iosSharer authorize];
    
    
  
        
    /*
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMyFriends];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
        
        }else {
        
        
        }
    }];
*/



}

/*
- (BOOL)isAuthorized
{
    
    Facebook *facebook = [SHKFacebook facebook];
    if ([facebook isSessionValid]) return YES;
    NSArray *permissions = [[NSArray alloc]initWithObjects:
                            @"user_likes",
                            @"read_stream",
                            nil];
    [facebook authorize:permissions delegate:delegate];
    NSUserDefaults *defaults = [NSUserDefaultsstandardUserDefaults];
    facebook.accessToken = [defaultsstringForKey:kSHKFacebookAccessTokenKey];
    NSLog(@"access token is %@",facebook.accessToken);
    facebook.expirationDate = [defaultsobjectForKey:kSHKFacebookExpiryDateKey];
    NSLog(@"expiry date of access token%@",facebook.expirationDate);
    return [facebook isSessionValid];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
