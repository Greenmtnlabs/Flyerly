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
#import "PayPalPaymentViewController.h"


@interface SendingPrintViewController (){
    LobRequest *request;
    LobRequest *postcardRequest;
    dispatch_semaphore_t sem;
    
    BOOL testing;
    NSString *urlFrontStr;
    NSDictionary *toAddressTest;
    NSDictionary *fromAddressTest;
    
    NSMutableArray *sendCardTo,*cardHasBeenSentTo;
    int postReqTry;
    BOOL hasPaidForPostCard;
}

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

UIButton *backButton;

@implementation SendingPrintViewController



@synthesize messageFeild,streetAddress,state,city,zip,country,name,flyerImage,flyer,contactsArray,scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    FlyerlyConfigurator *flyerConfigurator = appDelegate.flyerConfigurator;
    
    
    NSString *apiKey = [flyerConfigurator lobAppId];
    
    request = [LobRequest initWithAPIKey:apiKey];
    postcardRequest = [LobRequest initWithAPIKey:apiKey];
    
    sem = dispatch_semaphore_create(0);
    
    testing = NO;
    urlFrontStr = @"";
    
    hasPaidForPostCard = NO;
    
    sendCardTo = [[NSMutableArray alloc] init];
    cardHasBeenSentTo = [[NSMutableArray alloc] init];
    postReqTry = 0;
    
    fromAddressTest = @{    @"name" : @"rufi name in from", \
                            @"email" : [NSNull null], \
                            @"phone" : [NSNull null], \
                            @"address_line1" : @"1600 AMPHITHEATRE PKWY UNIT 199 ", \
                            @"address_line2" : [NSNull null], \
                            @"address_city" : @"MOUNTAIN VIEW", \
                            @"address_state" : @"CA", \
                            @"address_zip" : @"94085", \
                            @"address_country" : @"US"};
    
    toAddressTest =  @{ @"name" : @"rufi name in to", \
                        @"email" : [NSNull null], \
                        @"phone" : [NSNull null], \
                        @"address_line1" : @"522 Hudson Street 3", \
                        @"address_line2" : [NSNull null], \
                        @"address_city" : @"Hoboken", \
                        @"address_state" : @"NJ", \
                        @"address_zip" : @"07030", \
                        @"address_country" : @"US"};
    
    
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
 * Prepare the flyer.
https://lob.com/docs#postcards
   
1- @Return local image path ( Lob Supported file types are PDF, PNG, and JPEG)
2 - Enter a curl command in terminal,
 curl https://api.lob.com/v1/settings  -u test_13fb536c2d9e23b0e25657d9f923261b03b:
 We are using 200 setting of lob
 {
     "id": "200",
     "type": "cards",
     "description": "4x6 color card",
     "paper": "120lb gloss cover",
     "width": "6.000",
     "length": "4.000",
     "color": "color",
     "notes": "includes envelope",
     "object": "setting"
 }
 A/c to this image size must be 4x6
 */
- (NSString *) exportFlyer {
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

- (void) goHomeScreen
{
    int viewsToPop = 2;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-viewsToPop-1] animated:YES];
}

/**
 * Sending the request on Lob,with total coantacts details and flyer as PDF file that needs to printed
 */
-(void)sendrequestOnLob {
    
    if( hasPaidForPostCard == NO ) {
        [self openBuyPanel:1];
    }
    else {
        [self showLoading:YES];
        
        if( testing ) {
            [self sendPostCard: @"https://www.lob.com/postcardfront.pdf"];
        }
        else{
            if( [urlFrontStr isEqualToString:@""]){
                [self uploadPdfAndSendCard];
            } else{
                [self sendPostCard : urlFrontStr];
            }
        }
    }
}

-(void)uploadPdfAndSendCard
{
    NSDictionary *objectDict;
    NSString *filePath = @"";
    
    if( testing ){
        objectDict = @{
                       @"name" : @"Go Blue",
                       @"setting" : @{@"id" : @"200"},
                       @"file" : @"https://www.lob.com/goblue.pdf"};
    }
    else{
        filePath  =   [self exportFlyer];
        objectDict = @{
                       @"name" : @"Flyer Postcard",
                       @"setting" : @{@"id" : @"200"},
                       @"file" : filePath
                     };
    }
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
    
    if( !([filePath isEqualToString:@""]) ) {
        objectModel.localFilePath = YES;
    }
    
    [request createObjectWithModel:objectModel
                      withResponse:^(LobObjectModel *object, NSError *error)
     {
         NSLog(@"*** Object Create Local Response *** %ld", (long)request.statusCode);
         
         if ( error == nil && request.statusCode == 200){
             
             
             if( testing ){
                 [self sendPostCard: @"https://www.lob.com/postcardfront.pdf"];
             }
             else {
                 urlFrontStr = [NSString stringWithFormat:@"http://assets.lob.com/%@.pdf",object.objectId];
                 [self sendPostCard : urlFrontStr];
             }

         }
         else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to upload postcard" message:@"Your postcard could not be uploaded for print"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
             
             [self showLoading:NO];
         }
         
         dispatch_semaphore_signal(sem);
     }];
        //----//

}

-(void)sendPostCard:(NSString *)frontUrl
{
    
    NSDictionary *fromAddress = @{
                                  @"name" : name.text, \
                                  @"email" : [NSNull null], \
                                  @"phone" : [NSNull null], \
                                  @"address_line1" : [self setAddressStr:streetAddress.text] , \
                                  @"address_line2" : [NSNull null], \
                                  @"address_city" : city.text, \
                                  @"address_state" : state.text, \
                                  @"address_zip" : zip.text, \
                                  @"address_country" : @"US"};
    
    ++postReqTry;
    for ( int i = 0;i<contactsArray.count;i++) {
        
        //Contact Details
        ContactsModel *model = [self getArrayOfSelectedTab][i];

        NSDictionary *toAddress = @{
                                    @"name" : model.name, \
                                    @"email" : [NSNull null], \
                                    @"phone" : [NSNull null], \
                                    @"address_line1" : [self setAddressStr:model.streetAddress], \
                                    @"address_line2" : [NSNull null], \
                                    @"address_city" : model.city, \
                                    @"address_state" : model.state, \
                                    @"address_zip" : model.zip, \
                                    @"address_country" : @"US"
                                    };

        
        if( testing ){
            toAddress = toAddressTest;
            fromAddress = fromAddressTest;
        }
        
        
        NSDictionary *postcardDict = @{@"name" : @"Flyer Postcard",
                                       @"front" : frontUrl,
                                       @"message" : messageFeild.text,
                                       @"to" : toAddress,
                                       @"from" : fromAddress};
        

        if( postReqTry == 1 ){
            [sendCardTo addObject:[self getSendCardToName1:postcardDict]];
        }
        
        [self sendPostCardToLob:postcardDict];
    }
}

//Send After Address Verification
-(void)sendPostCardToLob: (NSDictionary *)postcardDict
{
    
    NSString *sendCardToName = [self getSendCardToName1:postcardDict];
    NSUInteger index = [cardHasBeenSentTo indexOfObject:sendCardToName];
    
    NSLog(@"getSendCardToName1: %@",sendCardToName);
    
    
    if (index == NSNotFound ) {
    
        LobPostcardModel *pCardModel = [[LobPostcardModel alloc] initWithDictionary:postcardDict];
        
        [postcardRequest createPostcardWithModel:pCardModel withResponse:^(LobPostcardModel *postcard, NSError *error) {
            
            NSLog(@"postcard: %@",postcard);
            NSLog(@"error %@",error);
            
            NSLog(@"getSendCardToName2 %@",[self getSendCardToName2:pCardModel]);

            

            NSString *message = @"";

             if (error == nil && postcardRequest.statusCode == 200) {

                  NSString *tempNameTo   =   [self getSendCardToName2:postcard];
                 [cardHasBeenSentTo addObject:tempNameTo];
                 
                 
                 message = [NSString stringWithFormat:@"Your postcard [for: %@ ] has been send to print.", tempNameTo];
                 
                 UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"PostCard Send" message:message  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alertSuccess show];
                 
                 if( [cardHasBeenSentTo count] == [sendCardTo count] ){
                     NSLog(@"Back to create flyer screen.");
                     [self goHomeScreen];
                 }
                 
             } else {
                message = [NSString stringWithFormat:@"One of the Postcard not sent. Error message: %@", error];
                 
                 if( error == nil ) {
                     message = [NSString stringWithFormat:@"One of the Postcard not sent.. Error status code: %ld", (long)postcardRequest.statusCode];
                     
                     if( postcardRequest.statusCode == 422 ){
                         message = [NSString stringWithFormat:@"One of the Postcard not sent. Due to invalid address."];
                     }
                 }
                 
                 UIAlertView *alertFailure = [[UIAlertView alloc] initWithTitle:@"" message:message  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 [alertFailure show];
             }
             
             [self showLoading:NO];
             dispatch_semaphore_signal(sem);
         }];
    }
}

//Show hide loading indicator
-(void)showLoading:(BOOL)show
{
    if( show ){
        [self showLoadingIndicator];
        backButton.enabled = NO;
    }else{
        [self hideLoadingIndicator];
        backButton.enabled = YES;
    }
}

-(NSString *)setAddressStr:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@" "];
    return str;
}

-(NSString *)getSendCardToName1:(NSDictionary *)postcardDict
{
    
    NSDictionary *toDic = [postcardDict valueForKey:@"to"];
    NSString *toAddressName = [toDic valueForKey:@"name"];
    NSString *addressLine1 = [toDic valueForKey:@"address_line1"];
    
    NSString *sendCardToName = [ NSString stringWithFormat:@"%@-%@",toAddressName,addressLine1];
    
    return sendCardToName;
    
}
-(NSString *)getSendCardToName2:(LobPostcardModel *)pCardModel
{
    NSString *toAddressName = pCardModel.toAddress.name;
    NSString *addressLine1 = pCardModel.toAddress.addressLine1;
    
    NSString *sendCardToName = [ NSString stringWithFormat:@"%@-%@",toAddressName,addressLine1];
    
    return sendCardToName;
}


#pragma mark - Paypal delegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Successfully payed.");
        hasPaidForPostCard = YES;
        [self sendrequestOnLob];
    }];
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Here we Open Buy Panel
 */
-(void)openBuyPanel : (int) totalContactsToSendPrint {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    NSDecimalNumber *totalAmount = [[NSDecimalNumber alloc] initWithInt:(2 * totalContactsToSendPrint)];
    payment.amount = totalAmount;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Printing Flyer PostCard";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture. To perform Authorization only,
    // and defer Capture to your server, use PayPalPaymentIntentAuthorize.
    payment.intent = PayPalPaymentIntentSale;
    
    // Check whether payment is processable.
    if ( payment.processable ) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}

@end