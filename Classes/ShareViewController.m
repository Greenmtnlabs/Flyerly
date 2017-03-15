//
//  DraftViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//
//

#import "ShareViewController.h"
#import "UserVoice.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "VideoData.h"
#import "Utils.h"
#import "FlyerlyConfigurator.h"
#import <Social/Social.h>

@implementation ShareViewController{
    NSString *fbShareType; // 4 possible values to assign: fb-photo-wall | fb-photo-messenger | fb-video-wall | fb-video-messenger
    FlyerlyConfigurator *flyerConfigurator;
    NSString *hashTag;
    BOOL shareOnEmail;
}
//@synthesize youtubeService;
@synthesize Yvalue,rightUndoBarButton,shareButton,backButton,helpButton,selectedFlyerImage,fvController,cfController,selectedFlyerDescription,  imageFileName,saveButton,printFlyerButton,facebookButton,twitterButton,instagramButton,messengerButton,clipboardButton,emailButton,smsButton,dicController, clipboardlabel,flyer,topTitleLabel,activityIndicator,youTubeButton,tempTxtArea,saveToGallaryReqBeforeSharing, fmController, delegate;

@synthesize flyerShareType,star1,star2,star3,star4,star5;
@synthesize descriptionView, titlePlaceHolderImg, titleView, descTextAreaImg, indexRow;

UIAlertView *saveCurrentFlyerAlert;

#pragma mark  View Appear Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    #if defined(FLYERLY)
        hashTag = @"#flyerly";
    #else
        hashTag = @"#FlyerlyBiz";
    #endif
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    hasSavedInGallary = NO;
    
    UVConfig *config = [UVConfig configWithSite:@"http://flyerly.uservoice.com/"];
    [UserVoice initialize:config];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    globle.NBUimage = nil;
    
    CALayer * l = self.view.layer;
    [l setMasksToBounds:YES];
    [l setBorderWidth:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    // Setup title text field
    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    
    titleView.placeholder = [NSString stringWithFormat:@"%@ Title (e.g. \"Parker's Party\")", flyerConfigurator.appName];
    
    //Default iPhon4
    CGRect sizeForDesc = CGRectMake((titleView.frame.origin.x-6), (titleView.frame.origin.y+titleView.frame.size.height+4), (titleView.frame.size.width+6), 67);

    
    if ( IS_IPHONE_4 || IS_IPHONE_5) {
        sizeForDesc = CGRectMake(10, 96, 298, 67);
    } else if ( IS_IPHONE_6 ) {
        sizeForDesc = CGRectMake(10, 79, 354, 67);
    } else if( IS_IPHONE_6_PLUS ) {
        sizeForDesc = CGRectMake(10, 79, 393, 67);
    } else {
        sizeForDesc = CGRectMake(10, 96, 298, 67);
    }
    
    descriptionView = [[UIPlaceHolderTextView alloc] initWithFrame:sizeForDesc];
    
    descriptionView.placeholder = @"Add a comment (example: \"Show this flyer for a free drink at the bar from 4pm-7pm\")";
    
    
    descriptionView.placeholderColor = [UIColor colorWithWhite: 0.80 alpha:1];
    descriptionView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    descriptionView.textColor = [UIColor darkGrayColor];
    
    //BG color for easy testing
    //descriptionView.backgroundColor= [UIColor redColor];
    
    [descriptionView awakeFromNib];
    descriptionView.delegate = self;
    
    [self.view addSubview:descriptionView];
    
    descTextAreaImg.frame = descriptionView.frame;
    
    [titleView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self initYoutubeService];
    
    titleView.placeholder = [NSString stringWithFormat:@"%@ Title (e.g. \"Parker's Party\")", flyerConfigurator.appName];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSocialStatus];

    titleView.text = [flyer getFlyerTitle];

    descriptionView.text = [flyer getFlyerDescription];
    
    [self updateDescription];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if([titleView.text isEqualToString:@""]){
        [titleView becomeFirstResponder];
    } else if( [descriptionView.text isEqualToString:@""] ){
        [descriptionView becomeFirstResponder];
    }
    
}

//Set user input value in class level variable.
-(void)updateDescription
{
    selectedFlyerDescription = descriptionView.text;
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    saveToGallaryReqBeforeSharing = NO;
}


#pragma mark  Custom Methods

/*
 *Here we Load Help Screen
 */
-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
    
}

// this function will change white/blac select/unselected buttons
-(void) setAllButtonSelected:(BOOL)selected{
    
    [messengerButton setSelected:selected];
    [facebookButton setSelected:selected];
    [youTubeButton setSelected:selected];
    [emailButton setSelected:selected];
    [smsButton setSelected:selected];
    [twitterButton setSelected:selected];
    [clipboardButton setSelected:selected];

}


/*
 * Share on Instagram
 */
-(void)shareOnInstagram{
    
    if ([self.flyer isVideoFlyer]) {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
        return;
    }
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = selectedFlyerImage;//[UIImage imageWithContentsOfFile:imageFileName];
    
    NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",IMAGETYPE ] withString:@".igo"];
    NSData *imgData = UIImagePNGRepresentation(originalImage);
    [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
    
    NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
    
    self.dicController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    self.dicController.UTI = @"com.instagram.photo";
    
    BOOL displayed = [self.dicController presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    
    if(!displayed){
        [self showAlert:@"Warning!" message:@"Please install Instagram app to share."];
        [instagramButton setSelected:NO];
    }else {
        // Update Flyer Share Info in Social File
        [self.flyer setInstagaramStatus:1];
        [Flurry logEvent:@"Shared Instagram"];
    }
}


/*
 * Check whether instagram app is installed or not
 */
-(BOOL)canOpenDocumentWithURL:(NSURL*)url inView:(UIView*)view {
    BOOL canOpen = NO;
    UIDocumentInteractionController* docController = [UIDocumentInteractionController
                                                      interactionControllerWithURL:url];
    if (docController)
    {
        docController.delegate = self;
        canOpen = [docController presentOpenInMenuFromRect:CGRectZero
                                                    inView:self.view animated:NO];
        [docController dismissMenuAnimated:NO];
    }
    return canOpen;
}



- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
}



/*
 * Here we set all Social Button Select or Un-Select
 */
-(void)setSocialStatus {
    
    // Set facebook Sharing Status From Social File
    NSString *status = [flyer getFacebookStatus];
    if([status isEqualToString:@"1"]){
        [facebookButton setSelected:YES];
    }else{
        [facebookButton setSelected:NO];
    }
    
    // Set Twitter Sharing Status From Social File
    status = [flyer getTwitterStatus];
    if([status isEqualToString:@"1"]){
        [twitterButton setSelected:YES];
    }else{
        [twitterButton setSelected:NO];
    }
    
    // Set Instagram Sharing Status From Social File
    status = [flyer getInstagaramStatus];
    if([status isEqualToString:@"1"]){
        [instagramButton setSelected:YES];
    }else{
        [instagramButton setSelected:NO];
    }
    
    // Set Email Sharing Status From Social File
    status = [flyer getEmailStatus];
    if([status isEqualToString:@"1"]){
        [emailButton setSelected:YES];
    }else{
        [emailButton setSelected:NO];
    }
    
    status = [flyer getYouTubeStatus];
    if([status isEqualToString:@"1"]){
        [youTubeButton setSelected:YES];
        
    }else{
        [youTubeButton setSelected:NO];
    }
    
    BOOL MsgStatus = [MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)];
    
    if (MsgStatus) {
        
        // Set Sms Sharing Status From Social File
        if([MFMessageComposeViewController canSendAttachments])
        {
            if (![self.flyer isVideoFlyer]) {
               
                status = [flyer getSmsStatus];
                if([status isEqualToString:@"1"]){
                    [smsButton setSelected:YES];
                }else {
                    [smsButton setSelected:NO];
                }
            }
        }
    }
    
    
    // Set Clipboard Sharing Status From Social File
    status = [flyer getClipboardStatus];
    if([status isEqualToString:@"1"]){
        [clipboardButton setSelected:YES];
    }else{
        [clipboardButton setSelected:NO];
    }
    
    // Set Messenger Sharing Status From Social File
    status = [flyer getMessengerStatus];
    if([status isEqualToString:@"1"]){
        [messengerButton setSelected:YES];
    }else{
        [messengerButton setSelected:NO];
    }
    
    // Set saveButton status
    status = [flyer getSaveButtonStatus];
    if([status isEqualToString:@"1"]){
        [saveButton setSelected:YES];
    }else{
        [saveButton setSelected:NO];
    }
    
    //Enable buttons if save to gallary not required
    if ( [flyer isVideoFlyer] ){
        
        if([[self.flyer getYouTubeStatus] isEqualToString: @"1"]){
            [self haveVideoLinkEnableAllShareOptions: YES];
        } else {
            [self haveVideoLinkEnableAllShareOptions:NO];
        }

        // If video flyer has been saved,
        // enable share options (independent of Youtube Link)
        [self enableShareOptions:( [[flyer getSaveButtonStatus] isEqualToString:@"1"] )];
    }
}


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/**
 * 1- check we have call saved in gallary or not
 * 2- check we have need of saving in gallary
 */
-(void)saveInGallaryIfNeeded {
    if( hasSavedInGallary != YES ){
        if( self.flyer.saveInGallaryRequired == 1){
            hasSavedInGallary = YES;
            
            // Set SaveButton status to 1, i.e. this flyer's been saved
            [flyer setSaveButtonStatus:1];
            
            // Set SaveButton visual state selected
            [saveButton setSelected:YES];
            
            [self.flyer saveIntoGallery];
            self.flyer.saveInGallaryRequired = 0;
        }
    }
}
-(IBAction)hideMe {
    [self saveInGallaryIfNeeded];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [self.view setFrame:CGRectMake(0, [Yvalue integerValue], 320,425 )];
    [UIView commitAnimations];
    [self.titleView resignFirstResponder];
    [self.descriptionView resignFirstResponder];
    
    [self.cfController enableHome:YES];
}

//This will disable the touch of buttons
-(void)haveVideoLinkEnableAllShareOptions:(BOOL) enable {
    [twitterButton setEnabled:enable];
    [emailButton setEnabled:enable];
    [smsButton setEnabled:enable];
    [clipboardButton setEnabled:enable];
}

/*
 * Method to set status of saveButton
 * @params:
 *      enable: BOOL
 * @return:
 *      void
 */
-(void)saveButtonSelected:(BOOL)enable{
    [saveButton setSelected:enable];
}

/*
 * Enables all share options, specified below
 * @params:
 *      enable: BOOL
 * @return:
 *      void
 */

-(void)enableShareOptions:(BOOL) enable {

    [instagramButton setEnabled:enable];
    [messengerButton setEnabled:enable];
    [facebookButton setEnabled:enable];
    //[youTubeButton setEnabled:enable];
    [emailButton setEnabled:enable];
    [smsButton setEnabled:enable];

}
#pragma mark  Text Field Delegate

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    [self.fmController updateCellTitle:indexRow text:theTextField.text];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

/*
 * Called when clicked on description text view
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    [self textViewTapped:nil];

    return YES;
}

/*
 * Called when clicked on description text view
 */
- (void)textViewTapped:(id)sender {
    
    
    [descriptionView becomeFirstResponder];
}


/*
 * Called when end editing on text view
 */
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    //Here we Update Flyer Discription in .txt File
    [flyer setFlyerDescription:descriptionView.text];
    [self updateDescription];
 }

- (void)textFieldFinished:(id)sender {
    
    [sender resignFirstResponder];
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {

    
    //[titleView setReturnKeyType:UIReturnKeyDone];
}

/*
 * Called when end editing on text field
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //Here we Update Flyer Title in .txt File
    
    [flyer setFlyerTitle:titleView.text];
    topTitleLabel.text = titleView.text;
    // Check to see if it's blank
    if([[titleView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        // There's no text in the box.
   
    titleView.placeholder = [NSString stringWithFormat:@"%@ Title (e.g. \"Parker's Party\")", flyerConfigurator.appName];
    }
}


#pragma mark Social Network
-(void)initYoutubeService {
    // Initialize the youtube service & load existing credentials from the keychain if available
//    self.youtubeService = [[GTLServiceYouTube alloc] init];
//    self.youtubeService.authorizer =
//    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:flyerConfigurator.appName
//                                                          clientID:flyerConfigurator.youTubeSecret
//                                                      clientSecret:flyerConfigurator.youTubeConsumerKey];
    
    
    _uploadVideo = [[YouTubeUploadVideo alloc] init];
    _uploadVideo.delegate = self;
}
/*
 * Called when Youtube button is pressed\
 */
-(IBAction)uploadOnYoutube:(id)sender {
    [self updateDescription];
    
//    if ([FlyerlySingleton connected]) {
//        if (![self isAuthorized]) { //always ask for auth
            // Not yet authorized, request authorization and push the login UI onto the navigation stack.
//            [self.cfController.navigationController pushViewController:[self createAuthController] animated:YES];
//        } else {
//            [self uploadYTDL];
//        }
//    } else {
//        [FlyerlySingleton showNotConnectedAlert];
//    }
}

-(void)openActivitySheetForShareVideo{
    NSArray *activityItems = [NSArray arrayWithObjects:[NSURL fileURLWithPath:[self.flyer getSharingVideoPath]], nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)sendVideoInMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        NSString *getSharingVideoPath = [NSString stringWithFormat:@"file://%@",[self.flyer getSharingVideoPath]];
        NSURL *videoUrl =  [NSURL URLWithString:getSharingVideoPath];
        NSData *fileData = [NSData dataWithContentsOfURL:videoUrl];
        
        [mail addAttachmentData:fileData mimeType:@"video/MOV" fileName:@"Flyer.mov"];
        //[mail setSubject:@""];
//        [mail setMessageBody:@"" isHTML:YES];
        //[mail setToRecipients:[NSArray arrayWithObject:@"abdul.rauf@riksof.com"]];
        [self.view.window.rootViewController presentViewController:mail animated:YES completion:nil];
    }else {
        NSLog(@"Device is unable to send the request in its current state.");
    }
}

-(void)sendVideoInMsg
{
    if ([MFMessageComposeViewController canSendText])
    {
        NSString *getSharingVideoPath = [NSString stringWithFormat:@"file://%@",[self.flyer getSharingVideoPath]];
        NSURL *videoUrl =  [NSURL URLWithString:getSharingVideoPath];
        NSData *fileData = [NSData dataWithContentsOfURL:videoUrl];
        
        MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
        messageComposer.messageComposeDelegate = self;
        //[messageComposer setBody:message];
        //[messageComposer setRecipients:recipients];colorForUsage:SC_THEME_MAIN];
        [messageComposer addAttachmentData:fileData typeIdentifier:@"video/MOV" filename:@"Flyer.mov"];
        [self.view.window.rootViewController presentViewController:messageComposer animated:YES completion:nil];
    }else {
        NSLog(@"Device is unable to send the request in its current state.");
    }
}

- (void)uploadYTDL {
    NSString *getSharingVideoPath = [NSString stringWithFormat:@"file://%@",[self.flyer getSharingVideoPath]];
    NSURL *videoUrl =  [NSURL URLWithString:getSharingVideoPath];
    NSData *fileData = [NSData dataWithContentsOfURL:videoUrl];
    NSString *title = titleView.text;
    NSString *description = selectedFlyerDescription;
    
    
    if ([title isEqualToString:@""]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"'Direct Lite Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
        title = [dateFormat stringFromDate:[NSDate date]];
    }
    if ([description isEqualToString:@""]) {
        description = [NSString stringWithFormat:@"Uploaded from %@", flyerConfigurator.appName ];
    }
    
//    [self.uploadVideo uploadYouTubeVideoWithService:self.youtubeService
//                                           fileData:fileData
//                                              title:title
//                                        description:description
//                                      privacyStatus: ( ([[flyer getShareType]  isEqual: @"Private"]) ? @"private" : @"public")
//                                        tags:[NSArray arrayWithObjects:hashTag, nil]];
}

// Helper to check if user is authorized
- (BOOL)isAuthorized {
    return YES; //[((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

// Creates the auth controller for authorizing access to YouTube.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    
//    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
//                                                                clientID:flyerConfigurator.youTubeConsumerKey
//                                                            clientSecret:flyerConfigurator.youTubeSecret
//                                                        keychainItemName:flyerConfigurator.appName
//                                                                delegate:self
//                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the YouTube service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
        //self.youtubeService.authorizer = nil;
    } else {
        //self.youtubeService.authorizer = authResult;
        //after successfull login on google reStart uploading process
        [self uploadYTDL];
    }
}

- (IBAction)startOAuthFlow:(id)sender {
    GTMOAuth2ViewControllerTouch *viewController;
    
//    viewController = [[GTMOAuth2ViewControllerTouch alloc]
//                      initWithScope:kGTLAuthScopeYouTube
//                      clientID:flyerConfigurator.youTubeConsumerKey
//                      clientSecret:flyerConfigurator.youTubeSecret
//                      keychainItemName:flyerConfigurator.appName
//                      delegate:self
//                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [self.cfController.navigationController pushViewController:viewController animated:YES];
}

//- (void)uploadYouTubeVideo:(YouTubeUploadVideo *)uploadVideo
//      didFinishWithResults:(GTLYouTubeVideo *)video {
//    
//    NSString *videoUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",video.identifier];
//    [self onYoutubeSFShare:videoUrl];
//    [self setSocialStatus];
//    
//    [Utils showAlert:@"Alert" message:@"Video uploaded successfully."];
//}

/*
 * Called when Youtube button is pressed\
 */
-(IBAction)uploadOnYoutubeOld:(id)sender {

    [self updateDescription];

    if ([FlyerlySingleton connected]) {
//        SHKItem *item = [SHKItem filePath:[self.flyer getSharingVideoPath] title:titleView.text];
//        
//        item.tags =[NSArray arrayWithObjects: hashTag, nil];
//        item.text = selectedFlyerDescription;
//        
//        iosSharer = [YouTubeSubClass shareItem:item];
//        
//        iosSharer.shareDelegate = self;
    } else {
        [FlyerlySingleton showNotConnectedAlert];
    }
}


/*
 * Called when twitter button is pressed
 */
-(IBAction)onClickTwitterButton{
    
    // update description on onClick Twitter Sharing Button
    [self updateDescription];
    NSString *sharingText = @"";
    //check whether item is video or just an image
    if ([self.flyer isVideoFlyer]) {

        // Current Video Link For Sharing
        sharingText = [NSString stringWithFormat:@"%@ %@ %@",[self.flyer getYoutubeLink], selectedFlyerDescription, hashTag];

    }else {
        // Current Image For Sharing
        sharingText = [NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, hashTag];
    }

    // get the twitter accounts from the phone
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType
                                       options:nil
                                       completion:^(BOOL granted, NSError *error) {
           if ( granted ) {
                NSArray *availableAccounts = [accountStore accountsWithAccountType:twitterAccountType];
               
               //if we have any account of twitter on phone then we'll call SHKiOSTwitter for sharing
               // else there will be a simple dialog to share on Twitter
               if ([availableAccounts count] > 0) {
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self shareOnTwitter:sharingText shareType:SLServiceTypeTwitter];
                   });
                   
               } else {
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self shareOnTwitter:sharingText shareType:SLServiceTypeTwitter];
                   });
               }
               
           } else {
               [self shareOnTwitter:sharingText shareType:SLServiceTypeTwitter];
           }
    }];

}

// share on twitter
-(void)shareOnTwitter:(NSString *)sharingText shareType:(NSString *)shareType{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:shareType];
    [controller setInitialText:sharingText];
    if ([self.flyer isVideoFlyer] == NO) {
        [controller addImage:selectedFlyerImage];
    }
    [controller setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         if (result == SLComposeViewControllerResultCancelled) {
             NSLog(@"Cancelled");
         } else if (result == SLComposeViewControllerResultDone) {
             [self.flyer setTwitterStatus:1];
             [Flurry logEvent:@"Shared Twitter"];
             [self actionAfterSharing];
         }
     }];
    [self presentViewController:controller animated:YES completion:Nil];
    
}


/*
 * Called when instagram button is pressed
 */
-(IBAction)onClickInstagramButton{
    
    [self shareOnInstagram];
}

/*
 * Called when print flyer button pressed
 */

-(IBAction)onPrintFlyerButton{

    [self.cfController printFlyer];
    [self hideMe];
}

/*
 * Called when saved button is pressed
 */
-(IBAction)onClickSaveButton{
    
    //self.cfController.saveToGallaryReqBeforeSharing = NO;
    
    if( [self.flyer canSaveInGallary] == NO){
      [self.flyer showAllowSaveInGallerySettingAlert];
    }
    //video merging is in process please wait
    else if( self.flyer.saveInGallaryRequired == 1 ) {
       
        [self updateDescription];
        saveCurrentFlyerAlert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:[NSString stringWithFormat:@"Saved to %@ gallery & iOS gallery.  Share to YouTube, Messenger, Facebook in-app or create a new email or text message & attach flyer from iOS gallery.", flyerConfigurator.appName]
                                                     delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
       
        [saveCurrentFlyerAlert show];

        [self.flyer resetAllButtonStatus]; //reset all database
        [self setAllButtonSelected:NO]; //view reset
        [self haveVideoLinkEnableAllShareOptions:NO];
        
        // Set SaveButton visual state selected
        [saveButton setSelected:YES];
        
        // Set SaveButton status to 1, i.e. this flyer's been saved
        [flyer setSaveButtonStatus:1];
        
        //enable those button, those not required youtube link
        [self enableShareOptions:YES];

        
    }
}

/*
 * Called when email button is pressed
 */
-(IBAction)onClickEmailButton{
    if ([self.flyer isVideoFlyer]) {
        [self sendVideoInMail];
    }
    else if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        NSString *bodyText = @"";
        NSString *title = [NSString stringWithFormat:@"%@ for you!", flyerConfigurator.appName];
        // Current Item For Sharing
        SHKItem *item;
        if ([self.flyer isVideoFlyer]) {
            // Current Video Link For Sharing
            item = [SHKItem text: [NSString stringWithFormat:@"%@ Created & sent from Flyer.ly",[self.flyer getYoutubeLink]]];
            item = [SHKItem URL:[NSURL URLWithString:[self.flyer getYoutubeLink]] title:[NSString stringWithFormat:@"%@ for you!", flyerConfigurator.appName ] contentType:SHKURLContentTypeVideo];

            bodyText = [NSString stringWithFormat:@"%@ Created & sent from Flyer.ly",[self.flyer getYoutubeLink]];

        }else {
            item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ for you!", flyerConfigurator.appName ]];
            item.text = @"Created & sent from Flyer.ly";
            bodyText = @"Created & sent from Flyer.ly";
        }

        picker.mailComposeDelegate = self;
        [picker setSubject:title];

        NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyImageName"];
        [picker setSubject:title];
        [picker setMessageBody:bodyText isHTML:NO];

        shareOnEmail = YES;
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }
    
}

/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    if ([self.flyer isVideoFlyer]) {
        [self sendVideoInMsg];
    }
    else if([MFMessageComposeViewController canSendAttachments])
    {
        MFMessageComposeViewController* messageComposer = [MFMessageComposeViewController new];
        messageComposer.messageComposeDelegate = self;
        if ([self.flyer isVideoFlyer]) {
            [messageComposer setBody:[NSString stringWithFormat:@"%@ Created & sent from Flyer.ly",[self.flyer getYoutubeLink] ]];
        } else {
            [messageComposer setBody:@"Created & sent from Flyer.ly"];
            NSData *exportData = UIImageJPEGRepresentation(selectedFlyerImage ,1.0);
            [messageComposer addAttachmentData:exportData typeIdentifier:@"image/png" filename:imageFileName];
        }
        [self.view.window.rootViewController presentViewController:messageComposer animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    if(result == MessageComposeResultSent){
        smsButton.enabled = YES;
        [self.flyer setSmsStatus:1];
        [Flurry logEvent:@"Shared SMS"];
        [self actionAfterSharing];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


/*
 * Called when Messenger button is pressed
 */
- (IBAction)onClickMessengerButton:(id)sender {
    
    [self updateDescription];
    
    
    if([self.flyer isVideoFlyer]){
        fbShareType = @"fb-video-messenger";
        /*
        //Dont remove this bellow code
        NSString *vUrl = [self.flyer getVideoAssetURL];
        if ( ![vUrl  isEqual: @""] ){
            NSURL *videoURL = [NSURL URLWithString: vUrl];
            FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
            video.videoURL = videoURL;
            
            FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
            content.video = video;
            
            //share on wall
            //[FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
         
            //share in messanger, facing issue thats why things are commented
            //http://stackoverflow.com/questions/32720016/fbsdkmessagedialog-does-not-send-video-in-message-in-ios
            //http://stackoverflow.com/questions/32712098/send-video-in-message-to-facebook-friend-using-fbsdkmessagedialog
            //http://stackoverflow.com/questions/31968929/sharing-video-into-facebook-messenger
            [FBSDKMessageDialog showWithContent:content delegate:self];
        }
         */
        if( ![[self.flyer getSharingVideoPath]  isEqual: @""] ){
            NSData *videoData = [NSData dataWithContentsOfFile:[self.flyer getSharingVideoPath]];
            [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
            [self sharer:nil didCompleteWithResults:nil];
        }
    } else {
        
        fbShareType = @"fb-photo-messenger";
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = selectedFlyerImage;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        [FBSDKMessageDialog showWithContent:content delegate:self];
  
    }
 }


/*
 * Called when facebook button is pressed
 */

-(IBAction)onClickFacebookButton{
   
    [self updateDescription];
    
    if([self.flyer isVideoFlyer]){
        fbShareType = @"fb-video-wall";
        NSURL *videoURL = [NSURL URLWithString:[self.flyer getVideoAssetURL]];
        FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
        video.videoURL = videoURL;
    
        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
        content.video = video;
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
    } else {
    
        fbShareType = @"fb-photo-wall";
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = selectedFlyerImage;
    
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    }
}

#pragma mark === delegate method
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"fb-completed share:%@", results);
    
    if([fbShareType isEqualToString:@"fb-photo-wall"] || [fbShareType isEqualToString:@"fb-video-wall"]){
        [self.flyer setFacebookStatus:1];
    } else if([fbShareType isEqualToString:@"fb-photo-messenger"] || [fbShareType isEqualToString:@"fb-video-messenger"]) {
        [self.flyer setMessengerStatus:1];
    }
    [self setSocialStatus];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"fb-sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"fb-There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"fb-share cancelled");
}


/*
 * Called when clipboard button is pressed
 */
-(IBAction)onClickClipboardButton{
    
    [clipboardButton setSelected:YES];
    [self onclipcordClick];
    
    // Update Flyer Share Info in Social File
    [self.flyer setClipboardStatus:1];
    

}


-(void) onclipcordClick{
    
    //Checking Flyer Type
    if ([self.flyer isVideoFlyer]) {
        
        //Coping Video Link
        [[UIPasteboard generalPasteboard] setString:[self.flyer getYoutubeLink]];

    }else {
        
        //Coping Image
        [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    }
    
    [Flurry logEvent:@"Copy to Clipboard"];
    [self showAlert:@"Flyer copied to clipboard!" message:@""];

}



#pragma Request receive code

- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{
    
    return YES;
}


#pragma mark - All Shared Response

// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    [self.cfController enableHome:NO];
    
    // Update Flyer Share Info in Social File
//    if ( [sharer isKindOfClass:[SHKiOSFacebook class]] == YES  ||
//        [sharer isKindOfClass:[SHKFacebook class]] == YES ) {
//        
//        facebookButton.enabled = NO;
//        
//    } else
    if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ||
               [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        
        twitterButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKMail class]] == YES ) {
        
        emailButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        smsButton.enabled = NO;
    }
//    else if ( [sharer isKindOfClass:[YouTubeSubClass class]] == YES ) {
//    
//        youTubeButton.enabled = NO;
//    }
    
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Sharing to %@", [[sharer class] sharerTitle]) forSharer:sharer];
    
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{

    // Here we Check Sharer for
    // Update Flyer Share Info in Social File
//    if ( [sharer isKindOfClass:[SHKiOSFacebook class]] == YES ||
//        [sharer isKindOfClass:[SHKFacebook class]] == YES) {
//        
//        facebookButton.enabled = YES;
//        [self.flyer setFacebookStatus:1];
//        [Flurry logEvent:@"Shared Facebook"];
//
//        
//    } else
    if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ||
               [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        
        twitterButton.enabled = YES;
        [self.flyer setTwitterStatus:1];
        [Flurry logEvent:@"Shared Twitter"];
     
    } else if ( [sharer isKindOfClass:[SHKMail class]] == YES ) {
        
        emailButton.enabled = YES;
        [self.flyer setEmailStatus:1];
        [Flurry logEvent:@"Shared Email"];

    } else if ([sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        smsButton.enabled = YES;
        [self.flyer setSmsStatus:1];
        [Flurry logEvent:@"Shared SMS"];

    }
//    else if ( [sharer isKindOfClass:[YouTubeSubClass class]] == YES ) {
//        YouTubeSubClass *youtube = (YouTubeSubClass *) sharer;
//        [self onYoutubeSFShare:youtube.youTubeVideoURL];
//    }
    
    [self actionAfterSharing];
    
    if (!sharer.quiet)
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Flyer Posted!") forSharer:sharer];
    
}

-(void)actionAfterSharing{
    //Here we set the set selected state of buttons.
    [self setSocialStatus];
    
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
    
    [self saveInGallaryIfNeeded];
    [self.cfController enableHome:YES];
}

-(void)onYoutubeSFShare:(NSString *)youTubeVideoURL{
    youTubeButton.enabled = YES;
    
    
    // Save Link In .Text File of Flyer
    [self.flyer setYoutubeLink:youTubeVideoURL];
    
    // Mark Social Status In .soc File of Flyer
    [self.flyer setYouTubeStatus:1];
    [self haveVideoLinkEnableAllShareOptions: [[self.flyer getYouTubeStatus] isEqualToString: @"1"]];
    
    [Flurry logEvent:@"Shared Youtube"];

}



- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
    UIAlertView *sharingFailedAlert = [[UIAlertView alloc] initWithTitle:@"Sharing Failed"
                                             message:@"Failed to share Flyer. Please check internet connection and try again."
                                            delegate:self
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
    
    [sharingFailedAlert show];
    
    iosSharer.shareDelegate = nil;
	NSLog(@"Sharing Error");
    
    [self saveInGallaryIfNeeded];
    [self.cfController enableHome:YES];
}



- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
    NSLog(@"Sending cancelled");
    
    [self saveInGallaryIfNeeded];
    [self.cfController enableHome:YES];
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
     iosSharer.shareDelegate = nil;
    iosSharer = nil;
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



#pragma mark  Rating Flyer

-(IBAction)clickOnStarRate:(id)sender {
    
    [star1 setSelected:NO];
    [star2 setSelected:NO];
    [star3 setSelected:NO];
    [star4 setSelected:NO];
    [star5 setSelected:NO];

    NSString *starValue = @"";
    
    if (sender == star1) {
        starValue = @"1";
        [star1 setSelected:YES];
    
    }else if (sender == star2){
        starValue = @"2";
        [star1 setSelected:YES];
        [star2 setSelected:YES];

    }else if (sender == star3){
        starValue = @"3";
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];

    }else if (sender == star4){
        starValue = @"4";
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];

    }else if (sender == star5){
        starValue = @"5";
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];
        [star5 setSelected:YES];
    }
    
    PFUser *user = [PFUser currentUser];
    user[@"appStarRate"] = starValue;
    [user saveInBackground];

    // check if the user rated from 1 star to 3 star
    if( sender == star1 || sender == star2 || sender == star3)
    {
        UIAlertView  *appRateAlertEmail = [[UIAlertView alloc]initWithTitle:@"Thank you! Please share your feedback." message:@"" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes" ,nil];
        
        appRateAlertEmail.tag = 0;
        
        [appRateAlertEmail show];
        
        //check if the user rated from 4 star to 5 star
    } else if( sender == star4 || sender == star5) {
        UIAlertView *appRateAlertStore = [[UIAlertView alloc]initWithTitle:@"Thank you! Please share your kind words on the App Store." message:@"" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Yes" ,nil];
        
        appRateAlertStore.tag = 1;
        
        [appRateAlertStore show];
    }
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   if( alertView == saveCurrentFlyerAlert ) {
       [self saveInGallaryIfNeeded];
   }
   else{
       switch (alertView.tag)
      {
        // if 1 alert view selected having tag 0
          case 0:
              if (buttonIndex == 1 ){
              [self sendAlertEmail];
          }
        break;
              
        //if 2 alert view selected having tag 1
          case 1:
              if(buttonIndex == 1) {
                  NSString *url;
                  #if defined(FLYERLY)
                    url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344130515"];
                  #else
                    url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344139192"];
                  #endif
                  [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
              }
        break;
        
      }
    }
}


-(IBAction)clickOnFlyerType:(id)sender {
    
    if ([flyerShareType isSelected]) {
        [flyerShareType setSelected:NO];
        [flyer setShareType:@"Public"];

    }else {
        [flyerShareType setSelected:YES];
        [flyer setShareType:@"Private"];
    }

}

-(void)sendAlertEmail{
  
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
  
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:[NSString stringWithFormat:@"%@ Email Feedback", flyerConfigurator.appName ]];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        #if defined(FLYERLY)
            [toRecipients addObject:@"hello@flyerly.com"];
        #else
            [toRecipients addObject:@"biz@flyerly.com"];
        #endif

        [picker setToRecipients:toRecipients];
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(shareOnEmail && result == MessageComposeResultSent){
        smsButton.enabled = YES;
        [self.flyer setEmailStatus:1];
        [Flurry logEvent:@"Shared Email"];
        [self actionAfterSharing];
    }
    shareOnEmail = NO;
    [controller dismissViewControllerAnimated:YES completion:nil];
}
/*
 *Here we Set Stars
 */
-(void)setStarsofShareScreen :(NSString *)rate {
    
    if ([rate isEqualToString:@"1"]) {
        [star1 setSelected:YES];
        
    }else if ([rate isEqualToString:@"2"]) {
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        
    }else if ([rate isEqualToString:@"3"]) {
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        
    }else if ([rate isEqualToString:@"4"]) {
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];
        
    }else if ([rate isEqualToString:@"5"]) {
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];
        [star5 setSelected:YES];
    }
}

@end
