//
//  HelpController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 5/23/13.
//
//

#import "HelpController.h"
#import "Common.h"
#import "PhotoController.h"

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

    
    // Create right bar button
    /*UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:crossButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];*/

    // Create left bar button
     UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(-60, -6, 50, 30)];
     closeButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:13];
      closeButton.showsTouchWhenHighlighted = YES;
    
     [closeButton setBackgroundImage:[UIImage imageNamed:@"signin_button"] forState:UIControlStateNormal];
     [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
     [closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
     [self.navigationItem setLeftBarButtonItem:leftBarButton];

    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-60, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"HELP CENTER";
    self.navigationItem.titleView = label;

    //self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Help Center" rect:CGRectMake(-60, -6, 50, 50)];

    if(IS_IPHONE_5){
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1340, doneButton.frame.size.width, doneButton.frame.size.height)];
        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 1335, 120, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 1348, 150, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(14, 1386, 157, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(14, 1375, 185, 10)];

    } else {
        [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 1390, doneButton.frame.size.width, doneButton.frame.size.height)];

        emailButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 1246, 120, 10)];
        linkButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 1257, 150, 10)];
        linkFaceBook = [[UIButton alloc] initWithFrame:CGRectMake(14, 1386, 120, 10)];
        twitLink = [[UIButton alloc] initWithFrame:CGRectMake(14, 1283, 185, 10)];

    }
    emailButton.showsTouchWhenHighlighted = YES;
    linkButton.showsTouchWhenHighlighted = YES;
    linkFaceBook.showsTouchWhenHighlighted = YES;
    twitLink.showsTouchWhenHighlighted = YES;

  //  linkFaceBook.backgroundColor = [UIColor blackColor];
   // twitLink.backgroundColor = [UIColor blackColor];

    [emailButton addTarget:self action:@selector(openEmail:) forControlEvents:UIControlEventTouchUpInside];
    //emailButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:10];
    //[emailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[emailButton setTitle:@"info@greenmtnlabs.com," forState:UIControlStateNormal];
    [scrollView addSubview:emailButton];

    [linkButton addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
    //linkButton.titleLabel.font = [UIFont fontWithName:@"Signika-Semibold" size:10];
    //[linkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[linkButton setTitle:@"http://www.GreenMtnLabs.com" forState:UIControlStateNormal];
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
        NSMutableArray *toRecipients = [[[NSMutableArray alloc]init]autorelease];
        [toRecipients addObject:@"info@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
        
        //NSString *emailBody = [NSString stringWithFormat:@"<font size='4'><a href = '%@'>Share a flyer</a></font>", @"http://www.flyer.us"];
        //[picker setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
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
