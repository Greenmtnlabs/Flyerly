//
//  InputViewController.m
//  Flyr
//
//  Created by Khurram on 09/09/2013.
//
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

@synthesize txtfield;
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
    globle = [Singleton RetrieveSingleton];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)] autorelease];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.titleLabel.text = @"Cancel";
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    [self.navigationItem setLeftBarButtonItem:backBarButton];
   
    UIButton *editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)] autorelease];
    [editButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    editButton.showsTouchWhenHighlighted = YES;
     editButton.titleLabel.text = @"Post";
    UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:editBarButton,nil ]];
    
       
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,nil ]];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Flyerly";
    
    self.navigationItem.titleView = label;

}

-(IBAction)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)post{
    if ([txtfield.text isEqualToString:@""]) {
        [self showAlert:@"Please Enter Comments" message:@""];
    }else{
        NSLog(@"%@",globle.inputValue);
        if ([globle.inputValue isEqualToString:@"facebook"]) {
            NSMutableArray *ASD = [[NSMutableArray alloc] init];
            [ASD addObject:@"500819963306066"];
            [self tagFacebookUsersWithFeed:ASD];

        }else if([globle.inputValue isEqualToString:@"twitter"]) {
            if([TWTweetComposeViewController canSendTweet]){
                [self sendTwitterMessage:txtfield.text screenName:@"flyerlyapp"];
            }  else {
                [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter from device settings."];
            }
        }
    [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)tagFacebookUsersWithFeed:(NSArray *)identifiers {
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    [self performPublishAction:^{
        
        [FBRequestConnection startForPostStatusUpdate:txtfield.text place:@"144479625584966" tags:identifiers completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            NSLog(@"New Result: %@", result);
            NSLog(@"Error: %@", error);
            
            //[self showAlert:@"Invited !" message:@"You have successfully invited your friends to join flyerly."];
        }];
    }];
}

- (void) performPublishAction:(void (^)(void)) action {
    
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            
            [[FBSession activeSession] reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe completionHandler:^(FBSession *session, NSError *error) {
                
                [self publish_action:action];
            }];
            
        }else{
            
            [self publish_action:action];
            
        }
    }else{
        /*
         * open a new session with publish permission
         */
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error && status == FBSessionStateOpen) {
                [self publish_action:action];
            }else{
                NSLog(@"error");
            }
        }];
    }
}

-(void)publish_action:(void (^)(void)) action{
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)sendTwitterMessage:(NSString *)message screenName:(NSString *)screenName{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
        if (granted == YES) {
            
            // Populate array with all available Twitter accounts
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            
            // Sanity check
            if ([arrayOfAccounts count] > 0) {
                
                // Keep it simple, use the first account available
                ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[NSString stringWithFormat:@"@%@ %@", screenName, message] forKey:@"status"];
                
                // Build a twitter request
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:params requestMethod:TWRequestMethodPOST];
                
                // Build a twitter request
                //TWRequest *postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:@"http://api.twitter.com/1/direct_messages/new.json"] parameters:params requestMethod:TWRequestMethodPOST];
                //[params setObject:screenName forKey:@"screen_name"];
                
                // Post the request
                [postRequest setAccount:acct];
                
                // Block handler to manage the response
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                    //[self.uiTableView reloadData];
                }];
            }
        }
    }];
}

@end
