

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
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"HELP CENTER";
    self.navigationItem.titleView = label;


    if(IS_IPHONE_5){
        
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1340, doneButton.frame.size.width, doneButton.frame.size.height)];
        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 1357, 130, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 1386, 172, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(16, 1417, 212, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(16, 1431, 190, 10)];


    } else {
        
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1390, doneButton.frame.size.width, doneButton.frame.size.height)];

        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 1266, 130, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 1295, 172, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(16, 1323, 212, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(16, 1336, 190, 10)];


    }
    
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/flyerlyapp"]];
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
        [toRecipients addObject:@"info@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];

        [self presentModalViewController:picker animated:YES];
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
    
    [controller dismissModalViewControllerAnimated:YES];
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
