//
//  DraftViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 10/24/09.
//
//

#import "ShareViewController.h"

@implementation ShareViewController


@synthesize selectedFlyerImage,imgView,fvController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView,dic,scrollView,  networkParentView,listOfPlaces,clipboardlabel,sharelink,bitly,flyer,topTitleLabel,delegate;


#pragma mark - Sharer Response

- (void)sharerStartedSending:(SHKSharer *)aSharer
{
}
- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    
    // Update Flyer Share Info in Social File
    [self.flyer setSocialStatusAtIndex:0 StatusValue:1];
	//if (!sharer.quiet)
		//[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Saved!")];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    
    //[[SHKActivityIndicator currentIndicator] hide];
    /*
    //if user sent the item already but needs to relogin we do not show alert
    if (!sharer.quiet && sharer.pendingAction != SHKPendingShare && sharer.pendingAction != SHKPendingSend)
	{
		[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error")
                                    message:sharer.lastError!=nil?[sharer.lastError localizedDescription]:SHKLocalizedString(@"There was an error while sharing")
                                   delegate:nil
                          cancelButtonTitle:SHKLocalizedString(@"Close")
                          otherButtonTitles:nil] show];
    }		
    if (shouldRelogin) {        
        [sharer promptAuthorization];
	}*/
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    globle = [FlyerlySingleton RetrieveSingleton];
    globle.NBUimage = nil;
    
    [self.view setBackgroundColor:[globle colorWithHexString:@"cdcdce"]];
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


-(void)loadHelpController{
    
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}



#pragma text field and text view delegates

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


/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickFacebookButton{
    
    [facebookButton setSelected:YES];
    
    
        // Check internet connectivity
        if( [InviteFriendsController connected] ){
            
            [facebookButton setSelected:YES];
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ %@ #flyerly",titleView.text, selectedFlyerDescription ]];
                        
            iosSharer = [SHKFacebook shareItem:item];
            //iosSharer.shareDelegate = self;

            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:0 StatusValue:1];
            
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
             [twitterButton setSelected:YES];

            // Current Item For Sharing
             SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@ %@ #flyerly",titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            iosSharer = [SHKTwitter shareItem:item];
            //iosSharer.shareDelegate = self;
            
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:1 StatusValue:1];

            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

}


/*
 * Called when instagram button is pressed
 */
-(IBAction)onClickInstagramButton{
    

        
        [instagramButton setSelected:YES];
        [self shareOnInstagram];
}


/*
 * Called when email button is pressed
 */
-(IBAction)onClickEmailButton{
    

        
        // Check internet connectivity
        if( [InviteFriendsController connected] ){
            
            [emailButton setSelected:YES];
            
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@",titleView.text]];
            
            
            //Calling ShareKit for Sharing
            iosSharer = [SHKMail shareItem:item];
           // iosSharer.shareDelegate = self;

            
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:2 StatusValue:1];

            //[self shareOnEmail];
            
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
            
           [tumblrButton setSelected:YES];

            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@  %@",titleView.text, selectedFlyerDescription ]];
            
            item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
            
            
            //Calling ShareKit for Sharing
            iosSharer = [SHKTumblr shareItem:item];
           // iosSharer.shareDelegate = self;
//            [SHKTumblr shareItem:item];
            
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:3 StatusValue:1];

            
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
            [flickrButton setSelected:YES];

            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"%@",titleView.text  ]];
              item.tags =[NSArray arrayWithObjects: @"#flyerly", nil];
            
            
            //Calling ShareKit for Sharing
            iosSharer = [SHKFlickr shareItem:item];
            //iosSharer.shareDelegate = self;
            
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:4 StatusValue:1];

            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

}


/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    

        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendAttachments])
        {
                        
            NSData *exportData = UIImageJPEGRepresentation(selectedFlyerImage ,1.0);
            
            [controller addAttachmentData:exportData typeIdentifier:@"public.data" filename:@"flyer.jpg"];
            controller.messageComposeDelegate = self;
            
            [self  presentModalViewController:controller animated:YES];
            
        }
    

}


/*
 * Called when clipboard button is pressed
 */
-(IBAction)onClickClipboardButton{
    
        [clipboardButton setSelected:YES];
        [self onclipcordClick];
        
        // Update Flyer Share Info in Social File
        [self.flyer setSocialStatusAtIndex:7 StatusValue:1];


}


-(void) onclipcordClick{
    [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    [Flurry logEvent:@"Copy to Clipboard"];
}


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma Sharing code

/*
 * Share on MMS
 */
-(void)singleshareOnMMS{

    NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
    [self uploadImage:imageData isEmail:NO];
    
}



-(void)shareOnMMS:(NSString *)link{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        //controller.body = [NSString stringWithFormat:@"%@ - %@ %@", selectedFlyerDescription,link, @"#flyerly"];
        controller.body = [NSString stringWithFormat:@"%@ - %@ %@", self.titleView.text ,link, @"flyer.ly/SMS"];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)uploadImage:(NSData *)imageData isEmail:(BOOL)isEmail
{
    PFFile *imageFile = [PFFile fileWithName:[FlyrViewController getFlyerNumberFromPath:imageFileName] data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *flyerObject = [PFObject objectWithClassName:@"Flyer"];
            flyerObject[@"image"] = imageFile;
            
            // Set the access control list to current user for security purposes
            flyerObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            flyerObject[@"user"] = user;
            
            [flyerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {

                    PFFile *theImage = flyerObject[@"image"];
                    
                    if(isEmail){
                        [self shareOnEmail:[theImage url]];
                    }else{
                        [self shortenURL:[theImage url]];
                    }
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
    }];
}


/*
 * Share on Email
 */
-(void)shareOnEmail{
    
    NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
    [self uploadImage:imageData isEmail:YES];
    
}

-(void)shareOnEmail:(NSString *)link{
    
    
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"You just received a NEW flyer!"];        
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly/email'>A flyerly creation...</a></font></p>"];
        
        [emailBody appendString:[NSString stringWithFormat:@"<p><img src='%@'></p>",link]];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly'>Download flyerly & share a flyer</a></font></p>"];
        [emailBody appendString:@"</body></html>"];
        NSLog(@"%@",emailBody);
        
        //mail composer window
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
    }
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
    
     self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
     self.dic.UTI = @"com.instagram.photo";
     self.dic.annotation = @{@"InstagramCaption": [NSString stringWithFormat:@"%@ %@", self.titleView.text,descriptionView.text]};
    
    

    BOOL displayed = [self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    


    
    if(!displayed){
        [self showAlert:@"Warning!" message:@"Please install Instagram app to share."];
    }else {
        // Update Flyer Share Info in Social File
        [self.flyer setSocialStatusAtIndex:5 StatusValue:1];
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



#pragma Request receive code

- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{

    NSLog(@"presentOptionsMenuFromRect");
    
    return YES;
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:2 StatusValue:1];
            
            NSLog(@"Sent");
			break;
		case MFMailComposeResultFailed:
			break;
	}

    [controller dismissViewControllerAnimated:YES completion:nil];

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            
            // Update Flyer Share Info in Social File
            [self.flyer setSocialStatusAtIndex:6 StatusValue:1];
            
            NSLog(@"Sent");
			break;
		case MessageComposeResultFailed:
			break;
	}
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    }


#pragma Bitly code for URL shortening

-(void)shortenURL:(NSString *)url{
  
    bitly = [[BitlyURLShortener alloc] init];
    bitly.delegate = self;
    [bitly shortenLinksInText:url];
}

- (void)bitlyURLShortenerDidShortenText:(BitlyURLShortener *)shortener oldText:(NSString *)oldText text:(NSString *)text linkDictionary:(NSDictionary *)dictionary {
    
    NSLog(@"Old Text: %@", oldText);
    NSLog(@"New Text: %@", text);
    
    [self shareOnMMS:text];
}

- (void)bitlyURLShortener:(BitlyURLShortener *)shortener
        didFailForLongURL:(NSURL *)longURL
               statusCode:(NSInteger)statusCode
               statusText:(NSString *)statusText {
    NSLog(@"Shortening failed for link %@: status code: %d, status text: %@",
          [longURL absoluteString], statusCode, statusText);
}


-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
}


/*
 * pop to root view
 */
-(IBAction)goback{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [self.view setFrame:CGRectMake(320, 64, 310,400 )];
    [UIView commitAnimations];
    
    [self removeFromParentViewController];
}


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
        
            status = [flyer getTwitterStatus];
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

@end
