//
//  DraftViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//
//

#import "ShareViewController.h"

@implementation ShareViewController

@synthesize Yvalue,rightUndoBarButton,shareButton,helpButton,selectedFlyerImage,fvController,titleView,descriptionView,selectedFlyerDescription,  imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,dicController, clipboardlabel,flyer,topTitleLabel,delegate,activityIndicator,youTubeButton,titleViewBorder;

@synthesize flyerShareType,star1,star2,star3,star4,star5;


#pragma mark  View Appear Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globle = [FlyerlySingleton RetrieveSingleton];
    globle.NBUimage = nil;
    
    CALayer * l = self.view.layer;
    [l setMasksToBounds:YES];
    [l setBorderWidth:0.5];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    titleViewBorder.layer.borderColor = [UIColor colorWithRed:0/255.0 green:155/255.0 blue:224/255.0 alpha:1].CGColor;
    titleViewBorder.layer.borderWidth = 1.0f;
    titleViewBorder.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         self.titleViewBorder.alpha = 0.0;
                     }
                     completion:nil];
    
    // Setup title text field
    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];

    titleView.placeholder = @"Flyerly Title (e.g. \"Parker's Party\")";
    
    
//    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldTapped:)];
//    tapped.numberOfTapsRequired = 1;
//    [self.titleView addGestureRecognizer:tapped];
//    [titleView setUserInteractionEnabled:YES];

    descriptionView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(12, 79, 296, 83)];
 
    descriptionView.placeholder = @"Add a comment (example: \"Show this flyer for a free drink at the bar from 4pm-7pm\")";
    /*
    descriptionView.placeholderColor = [UIColor colorWithWhite: 0.80 alpha:1];
    descriptionView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    descriptionView.textColor = [UIColor darkGrayColor];
     */
       [descriptionView awakeFromNib];
    descriptionView.delegate = self;
    
    [self.view addSubview:descriptionView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Checking if titleView text feild is empty
    if( [titleView hasText] ) {
        
        //removing animation on titleVIew text feild
        [titleViewBorder.layer removeAllAnimations];
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSocialStatus];

    titleView.text = [flyer getFlyerTitle];
    descriptionView.text = [flyer getFlyerDescription];
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
    
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
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
            if (![self.flyer isVideoFlyer]) {
                [smsButton setEnabled:YES];

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
    helpButton.enabled = YES;
}

-(void)enableAllShareOptions {
    [twitterButton setEnabled:YES];
    [emailButton setEnabled:YES];
    [smsButton setEnabled:YES];
    [instagramButton setEnabled:YES];
    [clipboardButton setEnabled:YES];
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
    selectedFlyerDescription = descriptionView.text;
 }

- (void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
    
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {

    [titleViewBorder.layer removeAllAnimations];
    [titleView setReturnKeyType:UIReturnKeyDone];
}

/*
 * Called when end editing on text field
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //Here we Update Flyer Title in .txt File
    [flyer setFlyerTitle:titleView.text];
    topTitleLabel.text = titleView.text;
}

#pragma mark Social Network

/*
 * Called when Youtube button is pressed
 */
-(IBAction)uploadOnYoutube:(id)sender {
    
    SHKItem *item = [SHKItem filePath:[self.flyer getSharingVideoPath] title:titleView.text];
    
    item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
    item.text = selectedFlyerDescription;
    
    iosSharer = [YouTubeSubClass shareItem:item];
    
    iosSharer.shareDelegate = self;
    
    
}

/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickFacebookButton{
    
    // Current Item For Sharing

    SHKItem *item;

    if ([flyer isVideoFlyer]) {
        item = [SHKItem filePath:[self.flyer getSharingVideoPath] title:titleView.text];
    }else {
        item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ #flyerly", selectedFlyerDescription ]];
    }
    
    item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
    iosSharer = [SHKFacebook shareItem:item];
    iosSharer.shareDelegate = self;
    
    
}


/*
 * Called when twitter button is pressed
 */
-(IBAction)onClickTwitterButton{
    
    
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
 * Called when tumblr button is pressed
 */
-(IBAction)onClickTumblrButton{
    
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
 * Called when flickr button is pressed
 */
-(IBAction)onClickFlickrButton{
    
    
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
    // Update Flyer Share Info in Social File
    if ( [sharer isKindOfClass:[SHKFacebook class]] == YES ) {
        
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
    if ( [sharer isKindOfClass:[SHKFacebook class]] == YES ) {
        
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
        
        smsButton.enabled = NO;
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
    
    [self setSocialStatus];
    
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Flyer Posted!") forSharer:sharer];
    
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hideForSharer:sharer];
    iosSharer.shareDelegate = nil;
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    iosSharer.shareDelegate = nil;
    iosSharer = nil;
    NSLog(@"Sending cancelled");
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
