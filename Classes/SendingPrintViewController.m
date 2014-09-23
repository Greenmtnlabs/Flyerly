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
#import "Lob/LobRequest.h"
#import "LobObjectModel.h"
#import "LobSettingModel.h"
#import "PayPalPaymentViewController.h"
#import "LobProjectConstants.h"
#import "AbstractBlockRequest.h"


#import "LobRequest.h"
#import "AFNetworking.h"
#import "LobAddressModel.h"
#import "LobBankAccountModel.h"
#import "LobCheckModel.h"
#import "LobCountryModel.h"
#import "LobJobModel.h"
#import "LobObjectModel.h"
#import "LobPackagingModel.h"
#import "LobPostcardModel.h"
#import "LobServiceModel.h"
#import "LobSettingModel.h"
#import "LobStateModel.h"
#import "LobVerifyModel.h"


@interface SendingPrintViewController ()

@end

LobRequest *request;
static NSString *testApiKey = @"test_13fb536c2d9e23b0e25657d9f923261b03b";
@implementation SendingPrintViewController

@synthesize messageFeild,streetAddress,state,city,country,flyerImage,flyer,contactsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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

-(NSArray *) getArrayOfSelectedTab{
    
    return contactsArray;
}

- (void)sendFlyer{
    
    [self sendrequestOnLob];
    //[self exportFlyerToPDF];
    
    /*if ( [MFMailComposeViewController canSendMail] ) {
        
        // Prepare the email in a background thread.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            
            // Prepare email.
            MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            
            // The subject.
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMMM d, YYY"];
            
            [mailer setSubject:@"Flyer"];
            
            [mailer addAttachmentData:[self exportFlyerToPDF] mimeType:@"application/pdf" fileName:@"Flyer.pdf"];
            
            // We are done. Now bring up the email in main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController.visibleViewController presentViewController:mailer animated:YES completion:nil];
            });
        });
    }*/
    
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
 * Prepare the flyer in PDF format.
 */
- (NSString *) exportFlyerToPDF {
    
    // Create the PDF context using the default page size of 612 x 792.
    CGSize pageSize = CGSizeMake( 1800, 1200);
    NSMutableData *pdfData = [NSMutableData data];
    
    // Make the context.
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
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
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    
    // Get path of current flyer background and remove it
    NSString *currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *destination = [NSString stringWithFormat:@"%@/PDF/Flyer.pdf",currentpath];
    [pdfData writeToFile:destination atomically:YES];
    
    NSURL* URL = [NSURL fileURLWithPath:destination];
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


- (void)createObjectWithModel:(LobObjectModel* )object withResponse:(void(^) (LobObjectModel *object, NSError *error))response
{
    NSString *urlStr = [@"https://api.lob.com/v1" stringByAppendingString:@"/objects"];
    //NSURL *url = [NSURL URLWithString:urlStr];
    if(object.localFilePath)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        NSString *user = [testApiKey substringToIndex:testApiKey.length-1];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:@""];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        if(object.name) paramDict[@"name"] = object.name;
        paramDict[@"setting_id"] = object.setting.settingId;
        if(object.quantity) paramDict[@"quantity"] = object.quantity;
        paramDict[@"double_sided"] = object.doubleSided ? @"1" : @"0";
        
        [manager POST:urlStr parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
            [formData throttleBandwidthWithPacketSize:kAFUploadStream3GSuggestedPacketSize delay:kAFUploadStream3GSuggestedDelay];
            NSData *data = [NSData dataWithContentsOfFile:object.file];
            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/pdf"];;
            [formData appendPartWithFormData:[object.name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
            [formData appendPartWithFormData:[object.setting.settingId dataUsingEncoding:NSUTF8StringEncoding] name:@"setting_id"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            requestClass.statusCode = operation.response.statusCode;
            response([LobObjectModel initWithDictionary:responseDict],NULL);
        } failure:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            requestClass.statusCode = operation.response.statusCode;
            response([LobObjectModel initWithDictionary:responseDict],NULL);
        }];
        
        
    }
    else
    {
        [self createModelWithURLStr:urlStr params:[object urlParamsForCreateRequest]
                  withResponseClass:NSStringFromClass([LobObjectModel class])
                        andResponse:^(LobAbstractModel *model, NSError *error)
         {
             response((LobObjectModel* )model,error);
         }];
    }
}

- (void)createModelWithURLStr:(NSString* )urlStr
                       params:(NSString* )params
            withResponseClass:(NSString* )classStr
                  andResponse:(void(^) (LobAbstractModel *model, NSError *error))response
{
    [requestClass getUrlStr:urlStr withMethod:HTTP_Post withEdit:^(NSMutableURLRequest *request)
    {
        [self addAuthorizationToRequest:request];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    andResponse:^(NSData *data, NSError *error)
    {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        response([NSClassFromString(@"LobErrorModel") initWithDictionary:responseDict],error);
    }];
}

-(void)addAuthorizationToRequest:(NSMutableURLRequest * )request
{
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData *authData = [testApiKey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@",[AbstractBlockRequest base64forData:authData]];
    [request addValue:authValue forHTTPHeaderField:@"Authorization"];
}


/**
 * Sending the request on Lob,with total coantacts details and flyer as PDF file that needs to printed
 */
-(void)sendrequestOnLob {
    
    NSMutableDictionary *toAddress;

    for ( int i = 0;i<contactsArray.count;i++) {
        
        ContactsModel *model = [self getArrayOfSelectedTab][i];
        
        toAddress = [[NSMutableDictionary alloc] init];
        [toAddress setObject:model.name forKey:@"name"];
        [toAddress setObject:@"" forKey:@"email"];
        [toAddress setObject:@"" forKey:@"phone"];
        [toAddress setObject:model.streetAddress forKey:@"address_line1"];
        [toAddress setObject:@"" forKey:@"address_line2"];
        [toAddress setObject:model.city forKey:@"address_city"];
        [toAddress setObject:@"FL" forKey:@"address_state"];
        [toAddress setObject:model.zip forKey:@"address_zip"];
        [toAddress setObject:model.country forKey:@"address_country"];
        
        
    }
    
    NSMutableDictionary *fromAddress = [[NSMutableDictionary alloc] init];
    [fromAddress setObject:@"HARRY ZHANG" forKey:@"name"];
    [fromAddress setObject:@"" forKey:@"email"];
    [fromAddress setObject:@"" forKey:@"phone"];
    [fromAddress setObject:@"1600 AMPHITHEATRE PKWY" forKey:@"address_line1"];
    [fromAddress setObject:@"UNIT 199" forKey:@"address_line2"];
    [fromAddress setObject:@"MOUNTAIN VIEW" forKey:@"address_city"];
    [fromAddress setObject:@"CA" forKey:@"address_state"];
    [fromAddress setObject:@"94085" forKey:@"address_zip"];
    [fromAddress setObject:@"US" forKey:@"address_country"];
    
    NSDictionary *postcardDict = @{@"name" : @"Demo Postcard",
                                   @"front" : [self exportFlyerToPDF],
                                   @"back" : @"https://www.lob.com/postcardback.pdf",
                                   @"to" : toAddress,
                                   @"from" : fromAddress};
    
    LobPostcardModel *postcardModel = [LobPostcardModel initWithDictionary:postcardDict];
    
    request = [[LobRequest alloc] initWithAPIKey:testApiKey];
    
    /*[request createPostcardWithModel:postcardModel
                        withResponse:^(LobPostcardModel *postcard, NSError *error)
     {
         NSLog(@"*** Postcard Create Response ***");
         
         NSLog(@"%u", request.statusCode);
         
     }];*/
    
    LobSettingModel *lobSettingObj = [[LobSettingModel alloc] initSettingWithId:@"200"];
                            
    LobObjectModel *objModal = [[LobObjectModel alloc] initObjectName:@"Flyer" quantity:@"1" doubleSided:NO fullBleed:NO setting:lobSettingObj file:[self exportFlyerToPDF] localFilePath:YES];
    
    NSDictionary *objectDict = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"200"},
                                 @"file" : [self exportFlyerToPDF]};
    
    LobObjectModel *objectModel = [LobObjectModel initWithDictionary:objectDict];
    objectModel.localFilePath = YES;
    
    [request createObjectWithModel:objectModel
                      withResponse:^(LobObjectModel *object, NSError *error)
     {
         NSLog(@"*** Object Create Local Response ***");
         NSLog(@"%u", request.statusCode);

         //XCTAssertEqual(request.statusCode, 200, @"");
         //[self verifyObject:object testOrigin:@"Object create local"];
         
        // dispatch_semaphore_signal(sem);
     }];
    
    
    
    return;
    
    NSString *urlString = @"https://api.lob.com/v1/postcards";
    
    NSData *pdfData = [NSData dataWithData:[self exportFlyerToPDF]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:@"test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:pdfData name:@"FlyerPDF" fileName:@"flyer.pdf" mimeType:@"application/pdf"];
        //[formData appendPartWithFormData:[object.name dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        //[formData appendPartWithFormData:[[NSString stringWithUTF8String:"Preston Junger"] dataUsingEncoding:NSUTF8StringEncoding] name:@"sample_name"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return;
    
    //NSDictionary *pdfDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[self exportFlyerToPDF]];
    
    NSDictionary *objectDict_ = @{@"name" : @"Go Blue",
                                 @"setting" : @{@"id" : @"100"},
                                 @"file" : [self exportFlyerToPDF]};
    
    LobObjectModel *objectModel_ = [LobObjectModel initWithDictionary:objectDict_];
    objectModel_.localFilePath = YES;
    
    
    NSMutableDictionary *sendingToAddress = [[NSMutableDictionary alloc] init];
    [sendingToAddress setObject:@"Zhang" forKey:@"name"];
    [sendingToAddress setObject:@"123 Test Street" forKey:@"address_line1"];
    [sendingToAddress setObject:@"Mountain View" forKey:@"address_city"];
    [sendingToAddress setObject:@"CA" forKey:@"address_state"];
    [sendingToAddress setObject:@"94041" forKey:@"address_zip"];
    [sendingToAddress setObject:@"US" forKey:@"address_country"];
    
    NSMutableDictionary *sendingFromAddress = [[NSMutableDictionary alloc] init];
    [sendingFromAddress setObject:@"Jenn" forKey:@"name"];
    [sendingFromAddress setObject:@"123 Test Avenue" forKey:@"address_line1"];
    [sendingFromAddress setObject:@"Seattle" forKey:@"address_city"];
    [sendingFromAddress setObject:@"WA" forKey:@"address_state"];
    [sendingFromAddress setObject:@"94041" forKey:@"address_zip"];
    [sendingFromAddress setObject:@"US" forKey:@"address_country"];
    
    
    NSMutableDictionary *lodDictionary = [[NSMutableDictionary alloc] init];
    
    [lodDictionary setObject:@"Post card ID" forKey:@"id"];
    [lodDictionary setObject:@"Custom Name" forKey:@"name"];
    [lodDictionary setObject:@"Custom Message" forKey:@"message"];
    [lodDictionary setObject:sendingToAddress forKey:@"to"];
    [lodDictionary setObject:sendingFromAddress forKey:@"from"];
    [lodDictionary setObject:@"https://www.lob.com/postcardfront.pdf" forKey:@"front"];
    [lodDictionary setObject:@"https://www.lob.com/postcardback.pdf" forKey:@"back"];
    
    /*LobPostcardModel *flyerPostCard = [[LobPostcardModel alloc] initWithDictionary:lodDictionary];
     
     [request createPostcardWithModel:flyerPostCard withResponse:^(LobPostcardModel *postcard, NSError *error){
     NSLog(@"%@",postcard);
     NSLog(@"%@",error);
     }];*/
    
    /*
     LobAddressModel *sendingFromAddress_ = [[LobAddressModel alloc] initAddressWithName:@"Jenn" email:@"sample@gmail.com" phone:@"123456789" addressLine1:@"123 Test Avenue" addressLine2:@"123 Test Avenue" addressCity:@"Seattle" addressState:@"WA" addressZip:@"94041" addressCountry:@"US"];
     
     
     //for (int i=0;i<contactsArray.count;i++){
     
     //ContactsModel *model__ = [[ContactsModel alloc] init];
     //model__ = [contactsArray objectAtIndex:i];
     
     LobAddressModel *sendingToAddress_ = [[LobAddressModel alloc] initAddressWithName:@"Zhang" email:@"sample@gmail.com" phone:@"123456789" addressLine1:@"123 Test Street" addressLine2:@"123 Test Street"  addressCity:@"Mountain View" addressState:@"CA" addressZip:@"94041" addressCountry:@"US"];
     
     LobPostcardModel *flyerPostCard_ = [[LobPostcardModel alloc] initPostcardWithName:@"My Flyer" message:@"Please Checkout my new flyer" toAddress:sendingToAddress_ fromAddress:sendingFromAddress_ status:@"2" price:@"$2" frontUrl:@"https://www.lob.com/postcardfront.pdf" backUrl:@"https://www.lob.com/postcardback.pdf" fullBleed:YES];
     
     //}
     
     //LobPostcardModel *flyerPostCard = [[LobPostcardModel alloc] init];
     
     request = [[LobRequest alloc] initWithAPIKey:testApiKey];
     
     [request createPostcardWithModel:flyerPostCard_ withResponse:^(LobPostcardModel *postcard, NSError *error){
     
     NSLog(@"%@", postcard.status);
     NSLog(@"%@", error.debugDescription);
     
     }];
     
     
     /*
     self.status = dict[@"status"];
     self.price = dict[@"price"];
     self.frontUrl = dict[@"front"];
     self.backUrl = dict[@"back"];
     
     if(dict[@"full_bleed"]) self.fullBleed = [dict[@"full_bleed"] boolValue];
     else self.fullBleed = false;*/
    
    /*NSString *urlString = @"https://api.lob.com/v1/postcards";
     
     NSData *pdfData = [NSData dataWithData:[self exportFlyerToPDF]];
     
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     [manager POST:urlString parameters:@"test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
     [formData appendPartWithFileData:pdfData name:@"FlyerPDF" fileName:@"flyer.pdf" mimeType:@"application/pdf"];
     [formData appendPartWithFormData:[[NSString stringWithUTF8String:"Preston Junger"] dataUsingEncoding:NSUTF8StringEncoding]
     name:@"name"];
     
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"Response: %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];*/
    
    /*NSString *urlString = @"https://api.lob.com/v1/postcards";
    
    NSData *pdfData = [NSData dataWithData:[self exportFlyerToPDF]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:@"test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:pdfData name:@"FlyerPDF" fileName:@"flyer.pdf" mimeType:@"application/pdf"];
        [formData appendPartWithFormData:[[NSString stringWithUTF8String:"Preston Junger"] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"name"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];*/
    
}




@end
