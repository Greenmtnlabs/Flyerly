//
//  SendingPrintViewController.m
//  Flyr
//
//  Created by Khurram on 23/07/2014.
//
//

#import "SendingPrintViewController.h"
#import "InviteForPrint.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"
#import "UIImagePDF.h"
#import "UserVoice.h"
#import "SendingPrintViewController.h"
#import "LobPostcardModel.h"
#import "LobAddressModel.h"
#import "LobRequest.h"
#import "LobObjectModel.h"
#import "LobSettingModel.h"
#import "PayPalPaymentViewController.h"
#import "LobProjectConstants.h"
#import "AbstractBlockRequest.h"

@interface SendingPrintViewController ()

@end

UIButton *backButton;

@implementation SendingPrintViewController

@synthesize messageFeild,streetAddress,state,city,zip,country,name,flyerImage,flyer,contactsArray,scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    messageFeild.delegate = self;
    
    //Setting up the Scroll size
    [scrollView setContentSize:CGSizeMake(320, 660)];
    //Setting the initial position for scroll view
    scrollView.contentOffset = CGPointMake(0,0);
    
    self.streetAddress.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.state.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.city.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.country.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-28, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SEND FLYERS";
    self.navigationItem.titleView = label;
    
    // Navigation buttons
    // BackButton
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Send Flyer Right BAR BUTTON
    UIButton *sendFlyerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
	[sendFlyerButton addTarget:self action:@selector(sendFlyer) forControlEvents:UIControlEventTouchUpInside];
    [sendFlyerButton setBackgroundImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    sendFlyerButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:sendFlyerButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    if ( [flyer.getFlyerDescription isEqualToString:@""] ){
        self.messageFeild.textColor = [UIColor lightGrayColor];
        self.messageFeild.text = @"Enter message here...";
        
    }else {
        messageFeild.text = flyer.getFlyerDescription;
    }
    
    flyerImage.image = [UIImage imageWithContentsOfFile:flyer.getFlyerImage];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    if ( [textView.text isEqualToString:@"Enter message here..."]) {
    
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    // Reseting the scrollview position
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

-(NSArray *) getArrayOfSelectedTab{
    
    return contactsArray;
}

- (void) showAlert:(NSString *) error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address." message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [self hideLoadingIndicator];
}

- (void)sendFlyer{
    
    
    
    [self showLoadingIndicator];
    
    if ( [messageFeild.text isEqualToString:@""] ) {
    
        [self showAlert:@"Please enter message."];
        
    } else if ( [name.text isEqualToString:@""] ){
    
        [self showAlert:@"Please enter sender name."];
        
    } else if ( [streetAddress.text isEqualToString:@""] ){
    
        [self showAlert:@"Please enter street address."];
        
    }else if ( [zip.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter zip code."];
        
    }else if ( [city.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter city."];
    
    }else if ( [state.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter state."];
        
    }else {
        
        [self sendrequestOnLob];
        
        backButton.enabled = NO;
    }
    
    
}


#pragma mark - Message UI Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self.navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
    NSString* message = nil;
    switch(result)
    {
        case MFMailComposeResultCancelled:
            message = @"Not sent at user request.";
            break;
        case MFMailComposeResultSaved:
            message = @"Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Error";
    }
    NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
}



/**
 * Merge flyer image in flyer bg background
 */
- (NSString *) adjustFlyerImg {
    
    // Create the PDF context using the required size of 6" x 4" at 300 dpi.
    CGSize pageSize = CGSizeMake( 1800, 1200);
    //NSMutableData *pdfData = [NSMutableData data];
    
    // Make the context.
    //UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    UIGraphicsBeginImageContext(CGSizeMake(1800,1200));
    
    // Get reference to context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Prepare the page.
    UIView *page = [self newPageInPDFWithTitle:@"Flyer" pageSize:pageSize];
    
    NSString *imageToPrintPath = [flyer getFlyerImage];
    UIImage *imageToPrint =  [UIImage imageWithContentsOfFile:imageToPrintPath];
    
    //You need to specify the frame of the view
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(200,0,1200,1200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageToPrint];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    [page addSubview:catView];
    
    // Render the last page.
    [page.layer renderInContext:context];
    
    UIImage *postcard = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Close the PDF context and write the contents out.
    //UIGraphicsEndPDFContext();
    
    NSData* postCardPng = UIImagePNGRepresentation(postcard);
    
    // Get path of current flyer background and remove it
    NSString *currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *destination = [NSString stringWithFormat:@"%@/pdf_Bg.png",currentpath];
    [postCardPng writeToFile:destination atomically:YES];
    
    //NSURL* URL = [NSURL fileURLWithPath:destination];
    return destination;
}




/**
 * Prepare the flyer in PDF format.
 */
- (NSString *) exportFlyerToPDF {
    NSString *destinationOfFlyerImg =   [self adjustFlyerImg];
    
    NSString *currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *destination = [NSString stringWithFormat:@"%@/flyer.pdf",currentpath];
    
    //destination = @"https://www.lob.com/postcardfront.pdf";
    
    return destination;
}


/**
 * Prepare a new page.
 */
- (UIView *)newPageInPDFWithTitle:(NSString *)titleStr pageSize:(CGSize)pageSize {
    
    // First Page
    CGRect pageFrame = CGRectMake(0, 0, pageSize.width, pageSize.height);
    UIGraphicsBeginPDFPageWithInfo( pageFrame, nil);
    
    // Fill with background color.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageSize.width,
                                                            pageSize.height)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pdf_Bg.png"]];
    
    //You need to specify the frame of the view
    UIView *catView = [[UIView alloc] initWithFrame:CGRectMake(1620,1130,150,60)];
    
    UIImage *image = [UIImage imageNamed:@"flyerlylogo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    //specify the frame of the imageView in the superview , here it will fill the superview
    imageView.frame = catView.bounds;
    
    // add the imageview to the superview
    [catView addSubview:imageView];
    
    [view addSubview:catView];
    
    return view;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handlers

/**
 * Cancel and go back.
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Sending the request on Lob,with total coantacts details and flyer as PDF file that needs to printed
 */
-(void)sendrequestOnLob {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    FlyerlyConfigurator *flyerConfigurator = appDelegate.flyerConfigurator;
    
    
    NSString *apiKey = [flyerConfigurator lobAppId];
    
    BOOL testing = YES;
    
    if(testing) {
        [self sendPostCard:apiKey
                  frontUrl:@"https://www.lob.com/postcardfront.pdf"
                   backUrl: @"https://www.lob.com/postcardback.pdf"
         ];
    }
    else{
        [self uploadPdfAndSendCard:apiKey];
    }
}

-(void)uploadPdfAndSendCard:(NSString *)apiKey
{
    LobRequest *request = [LobRequest initWithAPIKey:apiKey];
    
    /*
    NSDictionary *objectDict = @{
                                   @"name" : @"Flyer Postcard",
                                   @"setting" : @{@"id" : @"200"},
                                   @"file" : [self exportFlyerToPDF]
                                 };
*/
    /*
            NSString *path = [bundle pathForResource:@"zalogo" ofType:@"pdf"];
            if (path)
            {
                zaPDFPath = path;
            }
        }
     */




    
    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : @"https://www.lob.com/goblue.pdf"};
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
    [request createObjectWithModel:objectModel
                      withResponse:^(LobObjectModel *object, NSError *error)
     {
    
    
    
    
    
         NSLog(@"*** Object Create Local Response ***");
         NSLog(@"%ld", (long)request.statusCode);
         
         if ( error == nil && request.statusCode == 200){
             
             NSString *frontUrl = [NSString stringWithFormat:@"http://assets.lob.com/%@",object.objectId];
             /*
             [self sendPostCard:apiKey
                                frontUrl:frontUrl
                                backUrl: @"https://www.lob.com/postcardback.pdf"
              ];
             */
             [self sendPostCard:apiKey
                       frontUrl:@"https://www.lob.com/postcardfront.pdf"
                        backUrl: @"https://www.lob.com/postcardback.pdf"
              ];
             

         }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to upload postcard" message:@"Your postcard could not be uploaded for print"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
             
             [self showLoadingIndicator:NO];
         }
     }];
        //----//

}

-(void)sendPostCard:(NSString *)apiKey frontUrl:(NSString *)frontUrl backUrl:(NSString *)backUrl
{
    LobRequest *postcardRequest = [LobRequest initWithAPIKey:apiKey];
    /*
    NSMutableDictionary *fromAddress = [[NSMutableDictionary alloc] init];
    [fromAddress setObject:name.text forKey:@"name"];
    [fromAddress setObject:[NSNull null] forKey:@"email"];
    [fromAddress setObject:[NSNull null] forKey:@"phone"];
    [fromAddress setObject:streetAddress.text forKey:@"address_line1"];
    [fromAddress setObject:[NSNull null] forKey:@"address_line2"];
    [fromAddress setObject:city.text forKey:@"address_city"];
    [fromAddress setObject:state.text forKey:@"address_state"];
    [fromAddress setObject:zip.text forKey:@"address_zip"];
    [fromAddress setObject:@"US" forKey:@"address_country"]; */
    
    NSDictionary *fromAddress = @{@"name" : @"rufi to addrs -HARRY ZHANG", \
                  @"email" : [NSNull null], \
                  @"phone" : [NSNull null], \
                  @"address_line1" : @"1600 AMPHITHEATRE PKWY", \
                  @"address_line2" : @"UNIT 199", \
                  @"address_city" : @"MOUNTAIN VIEW", \
                  @"address_state" : @"CA", \
                  @"address_zip" : @"94085", \
                  @"address_country" : @"US"};
    
    

    for ( int i = 0;i<contactsArray.count;i++) {
        //Contact Details
        ContactsModel *model = [self getArrayOfSelectedTab][i];
        NSDictionary *toAddress = @{
                                    @"name" : model.name, \
                                    @"email" : [NSNull null], \
                                    @"phone" : [NSNull null], \
                                    @"address_line1" : model.streetAddress, \
                                    @"address_line2" : [NSNull null], \
                                    @"address_city" : model.city, \
                                    @"address_state" : model.state, \
                                    @"address_zip" : model.zip, \
                                    @"address_country" : @"US"
                                    };
        
        
        NSDictionary *postcardDict = @{@"name" : @"Flyer Postcard",
                                       @"front" : frontUrl,
                                       @"back" : backUrl,
                                       @"to" : toAddress,
                                       @"from" : fromAddress};
        
        
        
        LobPostcardModel *flyerPostCardModel = [[LobPostcardModel alloc] initWithDictionary:postcardDict];
        
        [postcardRequest createPostcardWithModel:flyerPostCardModel withResponse:^(LobPostcardModel *postcard, NSError *error)
         {
             
             if (error == nil && postcardRequest.statusCode == 200) {
                 
                 UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"PostCard Send" message:@"Your postcard hase been send to print"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alertSuccess show];
                 
             } else {
                 
                 NSString *failedError = [NSString stringWithFormat:@"PostCard could not be sent. Failed with error %@", error];
                 
                 if( error == nil ) {
                     failedError = [NSString stringWithFormat:@"PostCard could not be sent. Failed with status code %ld", (long)postcardRequest.statusCode ];
                 }
                 
                 UIAlertView *alertFailure = [[UIAlertView alloc] initWithTitle:@"" message:failedError  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alertFailure show];
             }
             
             [self showLoadingIndicator:NO];
             NSLog(@"%@",postcard);
             NSLog(@"%@",error);
             
         }];
    }
}

-(void)showLoadingIndicator:(BOOL)show
{
    if( show ){
    
    }else{
        [self hideLoadingIndicator];
        backButton.enabled = YES;
    }
}

@end
