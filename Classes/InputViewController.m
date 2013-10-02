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
       // NSLog(@"%@",globle.inputValue);
        if([globle.inputValue isEqualToString:@"twitter"]) {
            if([TWTweetComposeViewController canSendTweet]){
                [self sendTwitterMessage:txtfield.text screenName:@"flyerlyapp"];
            }  else {
                [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter from device settings."];
            }
        }

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

- (void)makeTwitterPost:(ACAccount *)acct {
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:[NSString stringWithFormat:@"@%@ %@", sName, sMessage] forKey:@"status"];
    
    // Build a twitter request
    TWRequest *postRequest = [[[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:params requestMethod:TWRequestMethodPOST] autorelease];
    
    // Post the request
    [postRequest setAccount:acct];
    
    // Block handler to manage the response
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
    }];
    
    [self showAlert:@"Thank you. Your feedback has been sent to @flyerlyapp on Twitter." message:@""];
    // Release stuff.
    [sName release];
    [sMessage release];
    [arrayOfAccounts release];
    sName = nil;
    sMessage = nil;
    arrayOfAccounts = nil;
    [self dismissModalViewControllerAnimated:YES];
}



- (void)sendTwitterMessage:(NSString *)message screenName:(NSString *)screenName{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    sName = [screenName retain];
    sMessage = [message retain];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
        if (granted == YES) {
            
            // Populate array with all available Twitter accounts
            arrayOfAccounts = [[account accountsWithAccountType:accountType] retain];
            
            // Sanity check
            if ([arrayOfAccounts count] > 1 ) {
                
                // Show list of acccounts from which to select
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                    
                    for (int i = 0; i < arrayOfAccounts.count; i++) {
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:i];
                        [actionSheet addButtonWithTitle:acct.username];
                    }
                    
                    [actionSheet addButtonWithTitle:@"Cancel"];
                    [actionSheet showInView:self.view];
                });
            } else if ( arrayOfAccounts.count > 0 ) {
                ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                [self makeTwitterPost:acct];
            }
        }
    }];
}

/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if not cancel button presses
    if(buttonIndex != arrayOfAccounts.count) {
        
        //save to NSUserDefault
        ACAccount *account = [arrayOfAccounts objectAtIndex:buttonIndex];
        
        //Convert twitter username to email
        [self makeTwitterPost:account];
    }
}

@end
