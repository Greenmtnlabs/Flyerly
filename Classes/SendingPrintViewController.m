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
#import "CreateFlyerController.h"
#import "HelpController.h"
#import "Flurry.h"
#import "UIImagePDF.h"
#import "UserVoice.h"
#import "SendingPrintViewController.h"
#import "PayPalPaymentViewController.h"
#import "PayPalPaymentViewController.h"



@interface SendingPrintViewController (){
    LobRequest *request;
    LobRequest *postcardRequest;

    dispatch_semaphore_t sem;
    
    BOOL testingNotUploadFile;
    BOOL testingAddressUse;
    BOOL testingSkipPaypal;
    BOOL testingSkipAddressValidations;
    NSString *urlFrontStr;
    NSDictionary *toAddressTest;
    NSDictionary *fromAddressTest;
    
    NSMutableArray *sendCardTo,*cardHasBeenSentTo;
    int postReqTry;
    BOOL hasPaidForPostCard;
    BOOL toContactVal;
    
    UITextView *tempTextView;
    UITextField *tempTextField;
}

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

UIButton *backButton;

@implementation SendingPrintViewController



@synthesize messageFeild,streetAddress,state,city,zip,country,name,flyerImage,flyer,contactsArray,scrollView, toName,toCity,toCountry,toState,toStreetAddress,toZip, toimageText,toLabel,toimageText1,toimageText2,toimageText3,toimageText4,toimageText5, contactlistTextView, characterCountLabel;

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
    
    testingNotUploadFile = NO;
    testingSkipAddressValidations = NO;
    testingAddressUse = NO;
    testingSkipPaypal = NO;
    
    toContactVal = NO;

    
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
    if(IS_IPHONE_6_PLUS){
        [scrollView setContentSize:CGSizeMake(320, 720)];
    }else{
        [scrollView setContentSize:CGSizeMake(320, 660)];
    }
    
    //Setting the initial position for scroll view
    scrollView.contentOffset = CGPointMake(0,0);
    
    self.streetAddress.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.state.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.city.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.country.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.toState.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.toCountry.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.toCity.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.toName.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.toStreetAddress.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
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
    [sendFlyerButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
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
    
    
    //Hide the To text field if contact is selected
    if(contactsArray.count > 0 ){
        [toName setHidden: YES];
        [toState setHidden: YES];
        [toStreetAddress setHidden: YES];
        [toZip setHidden: YES];
        [toCity setHidden: YES];
        [toCountry setHidden: YES];
        [toimageText setHidden:YES];
        [toimageText1 setHidden:YES];
        [toimageText2 setHidden:YES];
        [toimageText3 setHidden:YES];
        [toimageText4 setHidden:YES];
        [toimageText5 setHidden:YES];
        NSMutableString* nameList = [NSMutableString string];
        for(int i = 0;i<contactsArray.count;i++){
            //Selected contac name
            ContactsModel *model = [self getArrayOfSelectedTab][i];
                [nameList appendString:[NSString stringWithFormat:@"%@\n",model.name]];
            
        }
        
        toLabel.text = [NSString stringWithFormat:@"%@ printed flyer sent to:", APP_NAME];
        
        contactlistTextView.text = nameList;
        [contactlistTextView setFont:[UIFont systemFontOfSize:15]];
        [contactlistTextView setHidden:NO];
        
    }else{
        [contactlistTextView setHidden:YES];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    tempTextField = sender;
    if ([sender isEqual:toName])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    } else if ([sender isEqual:toStreetAddress])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    }else if ([sender isEqual:toState])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    }else if ([sender isEqual:toZip])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:toCity])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:state])
    {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        }
    }else if ([sender isEqual:zip])
    {
        if(IS_IPHONE_4 || IS_IPHONE_5){
            
            if (self.view.frame.origin.y >= 0){
                [self setViewMovedUp:YES];
            }
        }
    }else if ([sender isEqual:city])
    {
        if(IS_IPHONE_4 || IS_IPHONE_5){
            
            if (self.view.frame.origin.y >= 0){
                [self setViewMovedUp:YES];
            }
        }
    }


    

}

-(void)textFieldDidEndEditing:(UITextField *)sender{
    if ([sender isEqual:toName])
    {
        
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    } else if ([sender isEqual:toStreetAddress])
    {
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    }else if ([sender isEqual:toState])
    {
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    }else if ([sender isEqual:toZip])
    {
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    }
    else if ([sender isEqual:toCity])
    {
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    }
    else if ([sender isEqual:state])
    {
        if (self.view.frame.origin.y < 0){
            [self setViewMovedUp:NO];
        }
    }
    else if ([sender isEqual:zip])
    {
        if(IS_IPHONE_4 || IS_IPHONE_5){
            
            if (self.view.frame.origin.y < 0){
                [self setViewMovedUp:NO];
            }
        }
    }
    else if ([sender isEqual:city])
    {
        if(IS_IPHONE_4 || IS_IPHONE_5){
            
            if (self.view.frame.origin.y < 0){
                [self setViewMovedUp:NO];
            }
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        if(IS_IPHONE_5 || IS_IPHONE_4){
            rect.origin.y -= 200;
        }else{
            rect.origin.y -= 280;
        }
        
          }
    else
    {
        // revert back to the normal state.
        if(IS_IPHONE_5 || IS_IPHONE_4){
            
            rect.origin.y += 200;

        }else{
            rect.origin.y += 280;
        }
        
       
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    tempTextView = textView;
    NSLog(@"textViewShouldBeginEditing:");
    if ( [textView.text isEqualToString:@"Enter message here..."]) {
    
        [textView setText:@""];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    tempTextView = textView;
    NSLog(@"textViewDidBeginEditing:");
}

// function to handle character count for message text view
-(void)textViewDidChange:(UITextView *)textView
{
    int len = (int)textView.text.length;
    characterCountLabel.text=[NSString stringWithFormat:@"Remaining characters: %i",350-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    tempTextView = textView;
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 349)
    {
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // Reseting the scrollview position
    //[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    return YES;
}

-(NSArray *) getArrayOfSelectedTab{
    
    return contactsArray;
}

- (void) showAlert:(NSString *) error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address." message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    //[self hideLoadingIndicator];
}

- (void)sendFlyer{
    
    if( testingSkipAddressValidations ){
        [self sendrequestOnLob];
    }
    else if ( [messageFeild.text isEqualToString:@""] ) {
    
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
        [self checkTocount];
    }
    
}
- (void)checkTocount{
    toContactVal =  NO;
    
    if(contactsArray.count < 1 ){
        
        if ( [toName.text isEqualToString:@""] && [toStreetAddress.text isEqualToString:@""] && [toZip.text isEqualToString:@""] && [toCity.text isEqualToString:@""] && [toState.text isEqualToString:@""]){
            
            [self showAlert:@"Please enter reciever credentials."];
            
        } else {
            
            [self validateMandatoryToFlyerField];
        }
    } else {
        
        [self validateMandatoryToFlyerField];
    }

}
//Validating the madatory of optional To Filyer fields
- (void)validateMandatoryToFlyerField{

    if ( [toName.text isEqualToString:@""] && [toStreetAddress.text isEqualToString:@""] && [toZip.text isEqualToString:@""] && [toCity.text isEqualToString:@""] && [toState.text isEqualToString:@""]){
        
        [self sendrequestOnLob];
        
    } else if ( [toName.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter reciever name."];
        
    } else if ( [toStreetAddress.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter reciever street address."];
        
    }else if ( [toZip.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter reciever zip code."];
        
    }else if ( [toCity.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter reciever city."];
        
    }else if ( [toState.text isEqualToString:@""] ){
        
        [self showAlert:@"Please enter  reciever state."];
        
    }else {
        toContactVal = YES;
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
    
    UIImage *image;
    
    #if defined(FLYERLY)
        image = [UIImage imageNamed:@"flyerlyLogo.png"];
    #else
        image = [UIImage imageNamed:@"flyerlyBizLogo.png"];
    #endif
    
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
-(int)getCountOfContacts{
    int numberOfSelectContacts  = (int)contactsArray.count;
    int toContactsCount = 0;
    if( toContactVal == YES ){
        toContactsCount = 1;
    }
    
    return numberOfSelectContacts + toContactsCount;
}

/**
 * Sending the request on Lob,with total coantacts details and flyer as PDF file that needs to printed
 */
-(void)sendrequestOnLob {
    
    if( testingSkipPaypal == NO && hasPaidForPostCard == NO ) {
        [tempTextView resignFirstResponder];
        [tempTextField resignFirstResponder];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self openBuyPanel:[self getCountOfContacts]];
        });
    }
    else {
        [self showLoading:YES];
        
        if( testingNotUploadFile ) {
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
    
    if( testingNotUploadFile ){
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
    
//    [request createObjectWithModel:objectModel
//                      withResponse:^(LobObjectModel *object, NSError *error)
//     {
//         NSLog(@"*** Object Create Local Response *** %ld", (long)request.statusCode);
//         
//         if ( error == nil && request.statusCode == 200){
//             
//             
//             if( testingNotUploadFile ){
//                 [self sendPostCard: @"https://www.lob.com/postcardfront.pdf"];
//             }
//             else {
//                 urlFrontStr = [NSString stringWithFormat:@"http://assets.lob.com/%@.pdf",object.objectId];
//                 [self sendPostCard : urlFrontStr];
//             }
//
//         }
//         else {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to upload postcard" message:@"Your postcard could not be uploaded for print"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             
//             [alert show];
//             
//             [self showLoading:NO];
//         }
//         
//         dispatch_semaphore_signal(sem);
//     }];
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
                                    @"address_country" : @"US"};

        
        if( testingAddressUse ){
            toAddress = toAddressTest;
            fromAddress = fromAddressTest;
        }
        
        [self sendPostcardTo:frontUrl toAddress:toAddress fromAddress:fromAddress];
    }
    
    //When to is exist
    if ( !([toName.text isEqualToString:@""]) && !([toStreetAddress.text isEqualToString:@""]) && !([toZip.text isEqualToString:@""]) && !([toCity.text isEqualToString:@""]) && !([toState.text isEqualToString:@""])){
        NSDictionary *toAddress = @{
                                    @"name" : toName.text, \
                                    @"email" : [NSNull null], \
                                    @"phone" : [NSNull null], \
                                    @"address_line1" : [self setAddressStr:toStreetAddress.text], \
                                    @"address_line2" : [NSNull null], \
                                    @"address_city" : toCity.text, \
                                    @"address_state" : toState.text, \
                                    @"address_zip" : toZip.text, \
                                    @"address_country" : @"US"
                                    };
        [self sendPostcardTo:frontUrl toAddress:toAddress fromAddress:fromAddress];

    }
    

    
    
}

-(void)sendPostcardTo:(NSString *)frontUrl toAddress:(NSDictionary *)toAddress fromAddress:(NSDictionary *)fromAddress
{

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



//Send After Address Verification
-(void)sendPostCardToLob: (NSDictionary *)postcardDict
{
    if( [cardHasBeenSentTo count] >= [sendCardTo count] ) {
        NSLog(@"Back to create flyer screen.");
        [self goHomeScreen];
    }
    else {
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
                     
                     UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Postcard Sent." message:message  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     
                     [alertSuccess show];
                     
                     if( [cardHasBeenSentTo count] >= [sendCardTo count] ){
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
    
    payment.shortDescription = [NSString stringWithFormat:@"Print & Mail %@ Postcard.", APP_NAME];
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture. To perform Authorization only,
    // and defer Capture to your server, use PayPalPaymentIntentAuthorize.
    payment.intent = PayPalPaymentIntentSale;
    
    // Check whether payment is processable.
    if ( payment.processable ) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        
        
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}


@end
