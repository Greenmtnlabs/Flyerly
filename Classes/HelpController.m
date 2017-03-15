

//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//

#import "HelpController.h"

@interface HelpController ()

@end

@implementation HelpController
@synthesize scrollView, doneButton, linkButton, emailButton,linkFaceBook,twitLink;

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
    [scrollView setContentSize:CGSizeMake(320, 1600)];

    // Create Close bar button
     UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
      closeButton.showsTouchWhenHighlighted = YES;
     [closeButton setBackgroundImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [closeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
     [closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
     [self.navigationItem setLeftBarButtonItem:leftBarButton];

    // Bar Title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"HELP CENTER";
    self.navigationItem.titleView = label;

    
    if(IS_IPHONE_5){
        
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1340, doneButton.frame.size.width, doneButton.frame.size.height)];
        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 1369, 130, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 1400, 172, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(16, 1429, 212, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(16, 1445, 190, 10)];


    } else {
        
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1390, doneButton.frame.size.width, doneButton.frame.size.height)];

        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 1289, 130, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 1315, 172, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(16, 1343, 212, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(16, 1358, 190, 10)];


    }
    
    /* Position Testing
    [emailButton setBackgroundColor:[UIColor blackColor] ];
    [linkButton setBackgroundColor:[UIColor redColor] ];
    [twitLink setBackgroundColor:[UIColor yellowColor] ];
    [linkFaceBook setBackgroundColor:[UIColor greenColor] ];
    */

    
    emailButton.showsTouchWhenHighlighted = YES;
    linkButton.showsTouchWhenHighlighted = YES;
    linkFaceBook.showsTouchWhenHighlighted = YES;
    twitLink.showsTouchWhenHighlighted = YES;


    [emailButton addTarget:self action:@selector(openEmail:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:emailButton];

    [linkButton addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:linkButton];
    
    [linkFaceBook addTarget:self action:@selector(openFbLink) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:linkFaceBook];

    [twitLink addTarget:self action:@selector(openTwLink) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:twitLink];

    
    
}

-(void) openFbLink{
    NSURL *url = [NSURL URLWithString:@"fb://profile/500819963306066"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
    else {

        NSString *url_string;
        
        #if defined(FLYERLY)
            url_string = @"https://www.facebook.com/flyerlyapp";
        #else
            url_string = @"https://www.facebook.com/flyerlybiz";
        #endif

        //Open the url as usual
        url = [NSURL URLWithString:url_string ];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)openTwLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/GreenMtnLabs"]];
}


-(void) openLink:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.GreenMtnLabs.com"]];
}

-(void) openEmail:(UIButton *)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Inquiry..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        
        #if defined(FLYERLY)
            [toRecipients addObject:@"hello@flyerly.com"];
        #else
            [toRecipients addObject:@"biz@flyerly.com"];
        #endif
        
        [picker setToRecipients:toRecipients];

        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
	}
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goBack{
    
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
