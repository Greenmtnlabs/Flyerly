//
//  InputViewController.m
//  Flyr
//
//  Created by Riksof on 09/09/2013.
//
//

#import "InputViewController.h"

@interface InputViewController (){
    
    NSString *userName;


}

@end

@implementation InputViewController

@synthesize txtfield, lblTweetMsg;

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
    
    #if defined(FLYERLY)
        userName = @"@flyerlyapp";
    #else
        userName = @"@flyerlybiz";
    #endif
    
    
    globle = [FlyerlySingleton RetrieveSingleton];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.titleLabel.text = @"Cancel";
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItem:backBarButton];
   
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [editButton setBackgroundImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    editButton.showsTouchWhenHighlighted = YES;
     editButton.titleLabel.text = @"Post";
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:editBarButton,nil ]];
    
       
    
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:backBarButton,nil ]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = APP_NAME;
   
    lblTweetMsg.text = [NSString stringWithFormat:@"Tweet comments to %@", userName];
    
    self.navigationItem.titleView = label;
}

-(IBAction)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)post{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [self showAlert:@"No internet available,please connect to the internet first" message:@""];
    } else {
        NSLog(@"There IS internet connection");
        
        if ([txtfield.text isEqualToString:@""]) {
            [self showAlert:@"Please Enter Comments" message:@""];
        }else{
        
            // Current Item For Sharing
            SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ %@",txtfield.text, userName]];
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTwitter shareItem:item];
            iosSharer.shareDelegate = self;
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
}

#pragma mark - All Shared Response

// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    
    NSString *msg;
   
    
    // Here we show Messege after Sending
    [self showAlert:[NSString stringWithFormat:@"Thank you. Your feedback has been sent to %@ on Twitter.", userName] message:@""];

    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!") forSharer:sharer];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    NSLog(@"Sending cancelled.");
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)hideActivityIndicatorForSharer:(SHKSharer *)sharer {
    
    [[SHKActivityIndicator currentIndicator]  hideForSharer:sharer];
}

- (void)displayActivity:(NSString *)activityDescription forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    
    [[SHKActivityIndicator currentIndicator]  displayActivity:activityDescription forSharer:sharer];
}

- (void)displayCompleted:(NSString *)completionText forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  displayCompleted:completionText forSharer:sharer];
}

- (void)showProgress:(CGFloat)progress forSharer:(SHKSharer *)sharer {
    
    if (sharer.quiet) return;
    [[SHKActivityIndicator currentIndicator]  showProgress:progress forSharer:sharer];
}


@end
