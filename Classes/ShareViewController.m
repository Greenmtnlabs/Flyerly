//
//  DraftViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//
//

#import "ShareViewController.h"

@implementation ShareViewController


@synthesize Yvalue,rightUndoBarButton,shareButton,helpButton,selectedFlyerImage,fvController,titleView,descriptionView,selectedFlyerDescription,  imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,dicController, clipboardlabel,flyer,topTitleLabel,delegate,activityIndicator;

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
    
    // Setup title text field
    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];

    
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
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    
    NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".igo"];
    NSData *imgData = UIImagePNGRepresentation(originalImage);
    [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
    
    NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
    
    self.dicController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    self.dicController.UTI = @"com.instagram.photo";
    self.dicController.annotation = @{@"InstagramCaption": [NSString stringWithFormat:@"%@ %@ #flyerly", self.titleView.text,descriptionView.text]};
    
    
    BOOL displayed = [self.dicController presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    
    
    if(!displayed){
        [self showAlert:@"Warning!" message:@"Please install Instagram app to share."];
        [instagramButton setSelected:NO];
    }else {
        // Update Flyer Share Info in Social File
        [self.flyer setInstagaramStatus:1];
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
    
    
    
    BOOL MsgStatus = [MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)];
    
    if (MsgStatus) {
        
        // Set Sms Sharing Status From Social File
        if([MFMessageComposeViewController canSendAttachments])
        {
            [smsButton setEnabled:YES];
            
            status = [flyer getSmsStatus];
            if([status isEqualToString:@"1"]){
                [smsButton setSelected:YES];
            }else {
                [smsButton setSelected:NO];
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
    rightUndoBarButton.enabled = YES;
    shareButton.enabled = YES;
    helpButton.enabled = YES;


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
    if([descriptionView.text isEqualToString:AddCaptionText]){
        [descriptionView setText:@""];
        [descriptionView becomeFirstResponder];
    }
}


/*
 * Called when end editing on text view
 */
-(void)textViewDidEndEditing:(UITextView *)textView{
    if([descriptionView.text isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
    }else {
    
        //Here we Update Flyer Discription in .txt File
        [flyer setFlyerDescription:descriptionView.text];
    }
}

- (void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {
    if([titleView.text isEqualToString:NameYourFlyerText]){
        [titleView setText:@""];
        [titleView becomeFirstResponder];
    }
}

/*
 * Called when end editing on text field
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([titleView.text isEqualToString:@""]){
        [titleView setText:NameYourFlyerText];
    }else {
        //Here we Update Flyer Title in .txt File
        [flyer setFlyerTitle:titleView.text];
        topTitleLabel.text = titleView.text;
    }
}

#pragma mark Social Network

/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickFacebookButton{
    
    
        // Check internet connectivity
        if( [InviteFriendsController connected] ){
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ %@ #flyerly",titleView.text, selectedFlyerDescription ]];
            
           // iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKFacebook shareItem:item];
            iosSharer.shareDelegate = self;
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
        
}


/*
 * Called when twitter button is pressed
 */
-(IBAction)onClickTwitterButton{
    

        // Check internet connectivity
        if( [InviteFriendsController connected] ){

            // Current Item For Sharing
             SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ %@ #flyerly",titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTwitter shareItem:item];
            iosSharer.shareDelegate = self;
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

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
    
        // Check internet connectivity
        if( [InviteFriendsController connected] ){
            
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:@"Flyerly for you!"];
            item.text = @"Created & sent from Flyer.ly";
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKMail shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

    
}


/*
 * Called when tumblr button is pressed
 */
-(IBAction)onClickTumblrButton{
    
        // Check internet connectivity
        if( [InviteFriendsController connected] ){
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@  %@",titleView.text, selectedFlyerDescription ]];
            
            item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
            
            
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTumblr shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
    
}


/*
 * Called when flickr button is pressed
 */
-(IBAction)onClickFlickrButton{
    
        // Check internet connectivity
        if( [InviteFriendsController connected] ){

            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ %@",titleView.text , selectedFlyerDescription ]];
              item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
                    
            //Calling ShareKit for Sharing
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKFlickr shareItem:item];
            iosSharer.shareDelegate = self;
            
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

}


/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    
        if([MFMessageComposeViewController canSendAttachments])
        {
                        
            NSData *exportData = UIImageJPEGRepresentation(selectedFlyerImage ,1.0);
            
            iosSharer = [[ SHKSharer alloc] init];
            iosSharer = [SHKTextMessage shareFileData:exportData filename:imageFileName title:@"Created & sent from Flyer.ly"];
            iosSharer.shareDelegate = self;
            
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
    [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    [Flurry logEvent:@"Copy to Clipboard"];
}



#pragma Request receive code

- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{

    NSLog(@"presentOptionsMenuFromRect");
    
    return YES;
}


#pragma mark - All Shared Response

// These are used if you do not provide your own custom UI and delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
    
	if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Saving to %@", [[sharer class] sharerTitle]) forSharer:sharer];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    
    // Here we Check Sharer for
    // Update Flyer Share Info in Social File
    if ( [sharer isKindOfClass:[SHKFacebook class]] == YES ) {
        
        [self.flyer setFacebookStatus:1];
        
    } else if ( [sharer isKindOfClass:[SHKTwitter class]] == YES ) {
        
        [self.flyer setTwitterStatus:1];
        
    } else if ( [sharer isKindOfClass:[SHKTumblr class]] == YES ) {
        
        [self.flyer setThumblerStatus:1];
        
    } else if ( [sharer isKindOfClass:[SHKFlickr class]] == YES ) {
        
        [self.flyer setFlickerStatus:1];
        
    } else if ( [sharer isKindOfClass:[SHKMail class]] == YES ) {
        
        [self.flyer setEmailStatus:1];
    } else if ( [sharer isKindOfClass:[SHKTextMessage class]] == YES ) {
        
        [self.flyer setSmsStatus:1];
    }
    
    [self setSocialStatus];
    
    
    if (!sharer.quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!")];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    [[SHKActivityIndicator currentIndicator] hide];
	NSLog(@"Sharing Error");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    NSLog(@"");
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ did not accept your credentials. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    NSString *errorMessage = SHKLocalizedString(@"Sorry, %@ encountered an error. Please try again.", [[sharer class] sharerTitle]);
    
    [[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Login Error")
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:SHKLocalizedString(@"Close")
                      otherButtonTitles:nil] show];
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

    
    if (sender == star1) {
        [star1 setSelected:YES];
    }else if (sender == star2){
        [star1 setSelected:YES];
        [star2 setSelected:YES];
    }else if (sender == star3){
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
    }else if (sender == star4){
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];
    }else if (sender == star5){
        [star1 setSelected:YES];
        [star2 setSelected:YES];
        [star3 setSelected:YES];
        [star4 setSelected:YES];
        [star5 setSelected:YES];
    }
    
  UIAlertView  *appRateAlert = [[UIAlertView alloc]initWithTitle:@"Do you want to rate us on App store" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES" ,nil];
    [appRateAlert show];
    
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    if(buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id344130515"];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}

-(IBAction)clickOnFlyerType:(id)sender {
    
    if ([flyerShareType isSelected]) {
        [flyerShareType setSelected:NO];
    }else {
        [flyerShareType setSelected:YES];
    }

}


@end
