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
        
        }else {
        
        
        }
    }];



}



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


- (void)doSend {

    [self setQuiet:YES];
    

    
    FBRequestConnection* con = [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [self freindList];
        NSLog(@"Freind List Found");

    }];
    [self.pendingConnections addObject:con];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
