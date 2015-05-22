//
//  DraftViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//
//

#import "ShareViewController.h"
#import "UserVoice.h"

@implementation ShareViewController

@synthesize Yvalue,rightUndoBarButton,shareButton,backButton,helpButton,selectedFlyerImage,fvController,cfController,selectedFlyerDescription,  imageFileName,flickrButton,printFlyerButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,dicController, clipboardlabel,flyer,topTitleLabel,delegate,activityIndicator,youTubeButton,lblFirstShareOnYoutube,tempTxtArea;

@synthesize flyerShareType,star1,star2,star3,star4,star5;

@synthesize descriptionView, titlePlaceHolderImg, titleView, descTextAreaImg;

#pragma mark  View Appear Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    titleView.placeholder = @"Flyerly Title (e.g. \"Parker's Party\")";
    
    //Default iPhon4
    CGRect sizeForDesc = CGRectMake((titleView.frame.origin.x-6), (titleView.frame.origin.y+titleView.frame.size.height+4), (titleView.frame.size.width+6), 67);

    if ( [[self.cfController.flyer getFlyerTypeVideo] isEqualToString:@"video"] ){
        if ( IS_IPHONE_4 ) {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        } else if ( IS_IPHONE_5 ) {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        } else if ( IS_IPHONE_6 ) {
            sizeForDesc = CGRectMake(10, 79, 353, 67);
        } else if( IS_IPHONE_6_PLUS ) {
            sizeForDesc = CGRectMake(10, 79, 420, 85);
        } else {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        }
    } else { //Photo
        if ( IS_IPHONE_4 ) {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        } else if ( IS_IPHONE_5 ) {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        } else if ( IS_IPHONE_6 ) {
            sizeForDesc = CGRectMake(10, 79, 354, 67);
        } else if( IS_IPHONE_6_PLUS ) {
            sizeForDesc = descTextAreaImg.frame;//CGRectMake(10, 79, 393, 67);
        } else {
            sizeForDesc = CGRectMake(10, 96, 298, 67);
        }
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
    
    [self testPrintFrameSize];
    
    descTextAreaImg.frame = descriptionView.frame;
    
}

-(void)printFrame:(NSString *)frameName frame:(CGRect)frame{
    NSLog(@"%@:(%f,%f,%f,%f)",frameName, frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}
-(void)testPrintFrameSize {
    [self printFrame:@"titlePlaceHolderImg.frame" frame:titlePlaceHolderImg.frame];
    [self printFrame:@"titleView.frame" frame:titleView.frame];
    [self printFrame:@"descTextAreaImg.frame" frame:descTextAreaImg.frame];
    [self printFrame:@"descriptionView.frame" frame:descriptionView.frame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSocialStatus];

    titleView.text = [flyer getFlyerTitle];

    descriptionView.text = [flyer getFlyerDescription];
    
    [self updateDescription];
}

//Set user input value in class level variable.
-(void)updateDescription
{
    selectedFlyerDescription = descriptionView.text;
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


#pragma mark  Custom Methods

/*
 *Here we Load Help Screen
 */
-(void)loadHelpController{
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self];
    
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
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    
    NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",IMAGETYPE ] withString:@".igo"];
    NSData *imgData = UIImagePNGRepresentation(originalImage);
    [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
    
    NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
    
    self.dicController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    self.dicController.UTI = @"com.instagram.photo";
    self.dicController.annotation = @{@"InstagramCaption": [NSString stringWithFormat:@"%@ #flyerly", descriptionView.text]};
    
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
            //if (![self.flyer isVideoFlyer]) {
               
                status = [flyer getSmsStatus];
                if([status isEqualToString:@"1"]){
                    [smsButton setSelected:YES];
                }else {
                    [smsButton setSelected:NO];
                }
            //}
        }
    }
    
    
    // Set Clipboard Sharing Status From Social File
    status = [flyer getClipboardStatus];
    if([status isEqualToString:@"1"]){
        [clipboardButton setSelected:YES];
    }else{
        [clipboardButton setSelected:NO];
    }
    
    // Set Thumbler Sharing Status From Social File
    status = [flyer getThumblerStatus];
    if([status isEqualToString:@"1"]){
        [tumblrButton setSelected:YES];
    }else{
        [tumblrButton setSelected:NO];
    }
    
    // Set Flicker Sharing Status From Social File
    status = [flyer getFlickerStatus];
    if([status isEqualToString:@"1"]){
        [flickrButton setSelected:YES];
    }else{
        [flickrButton setSelected:NO];
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


-(IBAction)hideMe {
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [self.view setFrame:CGRectMake(0, [Yvalue integerValue], 320,425 )];
    [UIView commitAnimations];
    [self.titleView resignFirstResponder];
    [self.descriptionView resignFirstResponder];

    rightUndoBarButton.enabled = YES;
    shareButton.enabled = YES;
    backButton.enabled = YES;
    helpButton.enabled = YES;
}

-(void)enableAllShareOptions {
    [twitterButton setEnabled:YES];
    [emailButton setEnabled:YES];
    [smsButton setEnabled:YES];
    [instagramButton setEnabled:YES];
    [clipboardButton setEnabled:YES];
    [facebookButton setEnabled:YES];
    [lblFirstShareOnYoutube setHidden:YES];
}

#pragma mark  Text Field Delegate

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
    if([titleView.text isEqualToString:@""]) {
        // There's no text in the box.
        [flyer setFlyerTitle:@"Flyer"];
        topTitleLabel.text = @"Flyer";
    }
    
    
}

#pragma mark Social Network

/*
 * Called when Youtube button is pressed
 */
-(IBAction)uploadOnYoutube:(id)sender {
    
    [self updateDescription];
    
    if ([FlyerlySingleton connected]) {
        SHKItem *item = [SHKItem filePath:[self.flyer getSharingVideoPath] title:titleView.text];
        
        item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
        item.text = selectedFlyerDescription;
        
        iosSharer = [YouTubeSubClass shareItem:item];
        
        iosSharer.shareDelegate = self;
    } else {
        [FlyerlySingleton showNotConnectedAlert];
    }
    
    
}

/*
 * Called when twitter button is pressed
 */
-(IBAction)onClickTwitterButton{

    [self updateDescription];
    
    SHKItem *item;
    if ([self.flyer isVideoFlyer]) {
        
        // Current Video Link For Sharing
        item = [SHKItem text: [NSString stringWithFormat:@"%@ %@ #flyerly",[self.flyer getYoutubeLink], selectedFlyerDescription ]];
        
    }else {
        
        // Current Image For Sharing
         item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ #flyerly", selectedFlyerDescription ]];
    }
    
    //Calling ShareKit for Sharing
    iosSharer = [[ SHKSharer alloc] init];
    iosSharer = [SHKiOSTwitter shareItem:item];
    iosSharer.shareDelegate = self;
    iosSharer = nil;

}


/*
 * Called when instagram button is pressed
 */
-(IBAction)onClickInstagramButton{
    
    [self shareOnInstagram];
}

/*
 * Called when tumblr button is pressed
 */
-(IBAction)onClickTumblrButton{
    
    [self updateDescription];
    
    // Current Item For Sharing
    SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@", selectedFlyerDescription ]];
    
    item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
    
    //Calling ShareKit for Sharing
    iosSharer = [[ SHKSharer alloc] init];
    iosSharer = [SHKTumblr shareItem:item];
    iosSharer.shareDelegate = self;
    iosSharer = nil;
    
}

/*
 * Called when print flyer button pressed
 */

-(IBAction)onPrintFlyerButton{

    [self.cfController printFlyer];
    [self hideMe];
}

/*
 * Called when flickr button is pressed
 */
-(IBAction)onClickFlickrButton{
    
    [self updateDescription];
    
    //UIViewController* parent = (UIViewController*)[self presentedViewController];
    //[parent someMethod:YES];
    
    /*
    
    [self dismissModalViewControllerAnimated: NO];*/
    
    //[self.view.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    //[inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    //[self.view.window.rootViewController presentViewController:printViewController animated:YES completion:nil];
    //
    
    SHKItem *item;
    if ([self.flyer isVideoFlyer]) {
        
        // Current Video Link For Sharing
        item = [SHKItem filePath:[self.flyer getSharingVideoPath] title:titleView.text];
        //item = [SHKItem text: [NSString stringWithFormat:@"%@",[self.flyer getYoutubeLink] ]];
    }else {
        // Current Item For Sharing
        item = [SHKItem image:selectedFlyerImage title:titleView.text];
    }
    
    item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
    item.text = selectedFlyerDescription;
    
    //Calling ShareKit for Sharing
    iosSharer = [[ SHKSharer alloc] init];
    iosSharer = [SHKFlickr shareItem:item];
    iosSharer.shareDelegate = self;
    
    iosSharer = nil;
    
}

/*
 * Called when email button is pressed
 */
-(IBAction)onClickEmailButton{
    
    // Current Item For Sharing
    SHKItem *item;
    if ([self.flyer isVideoFlyer]) {
        
        // Current Video Link For Sharing
        //        item = [SHKItem text: [NSString stringWithFormat:@"%@ Created & sent from Flyer.ly",[self.flyer getYoutubeLink]]];
        
        item = [SHKItem URL:[NSURL URLWithString:[self.flyer getYoutubeLink]] title:@"Flyerly for you!" contentType:SHKURLContentTypeVideo];
    }else {
        
        item = [SHKItem image:selectedFlyerImage title:@"Flyerly for you!"];
        item.text = @"Created & sent from Flyer.ly";
    }
    
    //Calling ShareKit for Sharing
    iosSharer = [[ SHKSharer alloc] init];
    iosSharer = [SHKMail shareItem:item];
    iosSharer.shareDelegate = self;
    
    iosSharer = nil;
    
}

/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    
    if([MFMessageComposeViewController canSendAttachments])
    {
        
        if ([self.flyer isVideoFlyer]) {
            
            // Current Video Link For Sharing
            SHKItem *item = [SHKItem text: [NSString stringWithFormat:@"%@ Created & sent from Flyer.ly",[self.flyer getYoutubeLink] ]];
            
            iosSharer = [SHKTextMessage shareItem:item];
            iosSharer.shareDelegate = self;
        }else {

            NSData *exportData = UIImageJPEGRepresentation(selectedFlyerImage ,1.0);
            
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareFileData:exportData filename:imageFileName title:@"Created & sent from Flyer.ly"];
            iosSharer.shareDelegate = self;
            
        }
    }
}


/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickFacebookButton{
    
    [self updateDescription];
    
    // Current Item For Sharing
    SHKItem *item;
    
    if ([flyer isVideoFlyer]) {
        // getting youtube link from flyer and sharing on facebook via url
        NSString *getYouTubeLink = [self.flyer getYoutubeLink];
        NSURL *videoURL = [NSURL URLWithString:getYouTubeLink];
        
        item = [SHKItem URL:videoURL title:@"Share On Youtube" contentType:SHKURLContentTypeVideo];
        //item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
        iosSharer = [[SHKiOSFacebook alloc] init];
        [iosSharer loadItem:item];
        iosSharer.shareDelegate = self;
        [iosSharer share];
        
    }
    else {
        
        item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ #flyerly ", selectedFlyerDescription ]];
        item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
        iosSharer = [[SHKiOSFacebook alloc] init];
        [iosSharer loadItem:item];
        iosSharer.shareDelegate = self;
        [iosSharer share];
        
          }
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
    if ( [sharer isKindOfClass:[SHKiOSFacebook class]] == YES ) {
        
        facebookButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ) {
        
        twitterButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKTumblr class]] == YES ) {
        
        tumblrButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKFlickr class]] == YES ) {
        
        flickrButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKMail class]] == YES ) {
        
        emailButton.enabled = NO;
        
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        smsButton.enabled = NO;
    } else if ( [sharer isKindOfClass:[YouTubeSubClass class]] == YES ) {
    
        youTubeButton.enabled = NO;
    }
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Sharing to %@", [[sharer class] sharerTitle]) forSharer:sharer];
    
}







- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    // Here we Check Sharer for
    // Update Flyer Share Info in Social File
    if ( [sharer isKindOfClass:[SHKiOSFacebook class]] == YES ) {
        
        facebookButton.enabled = YES;
        [self.flyer setFacebookStatus:1];
        [Flurry logEvent:@"Shared Facebook"];

        
    } else if ( [sharer isKindOfClass:[SHKiOSTwitter class]] == YES ) {
        
        twitterButton.enabled = YES;
        [self.flyer setTwitterStatus:1];
        [Flurry logEvent:@"Shared Twitter"];

        
    } else if ( [sharer isKindOfClass:[SHKTumblr class]] == YES ) {
        
        tumblrButton.enabled = YES;
        [self.flyer setThumblerStatus:1];
        [Flurry logEvent:@"Shared Tumblr"];
       
    } else if ( [sharer isKindOfClass:[SHKFlickr class]] == YES ) {
        
        flickrButton.enabled = YES;
        [self.flyer setFlickerStatus:1];
        [Flurry logEvent:@"Shared Flickr"];

        
    } else if ( [sharer isKindOfClass:[SHKMail class]] == YES ) {
        
        emailButton.enabled = YES;
        [self.flyer setEmailStatus:1];
        [Flurry logEvent:@"Shared Email"];

    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        smsButton.enabled = YES;
        [self.flyer setSmsStatus:1];
        [Flurry logEvent:@"Shared SMS"];

    } else if ( [sharer isKindOfClass:[YouTubeSubClass class]] == YES ) {
        
        youTubeButton.enabled = YES;
        YouTubeSubClass *youtube = (YouTubeSubClass *) sharer;
        
        // Save Link In .Text File of Flyer
        [self.flyer setYoutubeLink:youtube.youTubeVideoURL];
        
        // Mark Social Status In .soc File of Flyer
        [self.flyer setYouTubeStatus:1];
        [Flurry logEvent:@"Shared Youtube"];
        [self enableAllShareOptions];
        
    }
    
    //Here we set the set selected state of buttons.
    [self setSocialStatus];
    
    
//    if(  ){
//        NSLog(@" Send Button");
//    } else {
//        NSLog(@" Cancel Button");
//    }
    
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Flyer Posted!") forSharer:sharer];
    
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
    [self.cfController enableHome:YES];
    
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
    [self.cfController enableHome:YES];
}



- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
    NSLog(@"Sending cancelled");
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
            NSString *url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344130515"];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    break;
    
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
        [picker setSubject:@"Flyerly Email Feedback"];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"info@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
      
    }
      [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
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


@end
