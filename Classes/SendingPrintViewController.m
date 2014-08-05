//
//  SendingPrintViewController.m
//  Flyr
//
//  Created by Khurram on 23/07/2014.
//
//

#import "SendingPrintViewController.h"

@interface SendingPrintViewController ()

@end

@implementation SendingPrintViewController

@synthesize messageFeild,streetAddress,state,city,country,flyerImage,flyer;

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
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-28, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"Send Fylers";
    self.navigationItem.titleView = label;
    
    // Send Flyer Right BAR BUTTON
    UIButton *sendFlyerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[sendFlyerButton addTarget:self action:@selector(sendFlyer) forControlEvents:UIControlEventTouchUpInside];
    [sendFlyerButton setBackgroundImage:[UIImage imageNamed:@"invite_friend"] forState:UIControlStateNormal];
    sendFlyerButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:sendFlyerButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    messageFeild.text = flyer.getFlyerDescription;
    
    flyerImage.image = [UIImage imageWithContentsOfFile:flyer.getFlyerImage];
    [messageFeild sizeToFit];
}

-(IBAction)sendFlyer{
    
    NSLog(@"Sending Flye");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(UIButton *)sender {
}
- (IBAction)send:(UIButton *)sender {
}

/**
 * Sending PDF to Lob to post on physical address.
 */
-(void)ebayUploadPicture{
    
    /*if ( ![self.streetAddress.text isEqualToString:@""] && ![self.city.text isEqualToString:@""] && ![self.state.text isEqualToString:@""]
         && ![self.zip.text isEqualToString:@""] && ![self.country.text isEqualToString:@""] ) {*/
        
            //LobAddressModel *sendingFromAddress = [[LobAddressModel alloc] initAddressWithName:model__.name email:@"" phone:@"" addressLine1:self.streetAddress.text  addressLine2:self.streetAddress.text addressCity:self.city.text addressState:self.state.text addressZip:self.zip.text addressCountry:self.country.text];
    
    //}
    
    
    /*for (int i=0;i<contactsArray.count;i++){
        
        ContactsModel *model__ = [[ContactsModel alloc] init];
        model__ = [contactsArray objectAtIndex:i];*/
        
        //LobAddressModel *sendingToAddress = [[LobAddressModel alloc] initAddressWithName:model__.name email:@"" phone:@"" addressLine1:model__.streetAddress addressLine2:model__.streetAddress addressCity:model__.city addressState:@"" addressZip:@"" addressCountry:model__.country];
        
        //LobPostcardModel *flyerPostCard = [LobPostcardModel alloc] initPostcardWithName:@"My Flyer" message:@"Please Checkout my new flyer" toAddress:sendingToAddress fromAddress:<#(LobAddressModel *)#> status:<#(NSString *)#> price:<#(NSString *)#> frontUrl:<#(NSString *)#> backUrl:<#(NSString *)#> fullBleed:<#(BOOL)#>];
    //
}
@end
