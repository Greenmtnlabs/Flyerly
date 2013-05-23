//
//  DraftViewController.m
//  Flyr
//
//  Created by Krunal on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "DraftViewController.h"
#import "MyNavigationBar.h"
#import "FlyrViewController.h"
#import "SaveFlyerController.h"
#import "Common.h"
#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TMAPIClient.h"
#import "JSON.h"
#import "ShareProgressView.h"

@implementation DraftViewController

@synthesize selectedFlyerImage,imgView,navBar,fvController,svController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView,dic,fromPhotoController,progressView,scrollView,facebookPogressView,twitterPogressView, tumblrPogressView, flickrPogressView, saveToCameraRollLabel, saveToRollSwitch;

-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
	[fvController release];
}

-(void)loadDistributeView
{
	svController.isDraftView = YES;
	[self.navigationController pushViewController:svController animated:YES];
}

-(void) callMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
    
    loadingView = nil;
	loadingView = [[LoadingView alloc]init];

    [facebookButton setSelected:NO];
    [twitterButton setSelected:NO];
    [instagramButton setSelected:NO];
    [emailButton setSelected:NO];
    [tumblrButton setSelected:NO];
    [flickrButton setSelected:NO];
    [smsButton setSelected:NO];
    [clipboardButton setSelected:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flickrSharingSuccess) name:FlickrSharingSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flickrSharingFailure) name:FlickrSharingFailureNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSharingProgressSuccess) name:CloseShareProgressNotification object:nil];

	svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = selectedFlyerImage;
	svController.isDraftView = YES;
	svController.dvController =self;
	//svController.ptController = self;
	
	//self.navigationItem.title = @"Social Flyer";
	self.navigationController.navigationBarHidden = NO;
    
    if(fromPhotoController){
        self.navigationItem.hidesBackButton = YES;
        
        // Create right bar button
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:rightBarButton];
    }
    
    //UILabel *addBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[addBackgroundLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    //[addBackgroundLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    //[addBackgroundLabel setBackgroundColor:[UIColor clearColor]];
    //[addBackgroundLabel setText:@"Share flyer"];
    //UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:addBackgroundLabel];
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Share flyer"];

    [saveToCameraRollLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];

    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];

	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[UIView commitAnimations];
	//imgView = [[UIImageView alloc]initWithImage:selectedFlyerImage];
	//[self.view addSubview:imgView];
	[imgView setImage:selectedFlyerImage];

    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
	[titleView setText:selectedFlyerTitle];
    
    [descriptionView setFont:[UIFont fontWithName:@"Signika-Regular" size:10]];
    [descriptionView setTextColor:[UIColor grayColor]];
    [descriptionView setReturnKeyType:UIReturnKeyDone];
    if([selectedFlyerDescription isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
        [descriptionView addGestureRecognizer:gestureRecognizer];
    }else{
        [descriptionView setText:selectedFlyerDescription];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	navBar= [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:navBar];
	[navBar show:@"SocialFlyr" left:@"Browser" right:@"Share"];
	[self.view bringSubviewToFront:navBar];
	
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];

	[navBar.leftButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callFlyrView) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(loadDistributeView) forControlEvents:UIControlEventTouchUpInside];
	navBar.alpha = ALPHA1;
	
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

- (void)textViewTapped:(id)sender {
    if([descriptionView.text isEqualToString:AddCaptionText]){
        [descriptionView setText:@""];
        [descriptionView becomeFirstResponder];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([descriptionView.text isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
    }
}

- (void)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

#pragma on click buttons

-(void)share{
    
    [self remoAllSharingViews];
    [self setDefaultProgressViewHeight];
    countOfSharingNetworks = 0;
    [progressView setHidden:NO];
    
    if([self isAnyNetworkSelected]){
        loadingView =[LoadingView loadingViewInView:self.view  text:@"Sharing..."];
        
        if([twitterButton isSelected]){
            [self showTwitterProgressRow];
            [self shareOnTwitter];
            //[self fillSuccessStatus:twitterPogressView];
        }
        
        if([facebookButton isSelected]){
            [self showFacebookProgressRow];
            [self shareOnFacebook];
            //[self fillSuccessStatus:facebookPogressView];
        }
        
        if([flickrButton isSelected]){
            [self showFlickrProgressRow];
            [self shareOnFlickr];
            //[self fillSuccessStatus:flickrPogressView];
        }
        
        if([tumblrButton isSelected]){
            [self showTumblrProgressRow];
            [self shareOnTumblr];
            //[self fillSuccessStatus:tumblrPogressView];
        }
        
        if([emailButton isSelected]){
            [self shareOnEmail];
        }
        
        if([smsButton isSelected] && ![emailButton isSelected]){
            [self shareOnMMS];
        }
        
        if([instagramButton isSelected] && ( ![tumblrButton isSelected] && ![flickrButton isSelected] && ![smsButton isSelected])  && ![emailButton isSelected]){
            [self shareOnInstagram];
        }
        
        if([saveToRollSwitch isOn]){
            UIImageWriteToSavedPhotosAlbum(selectedFlyerImage, nil, nil, nil);
        }
        
        [self showAlert];
        
    } else {
        
        [self showAlert:@"Warning!" message:@"Please select at least one sharing option."];
        
    }
}

-(BOOL)isAnyNetworkSelected{
    
    if([facebookButton isSelected])
        return true;
    if([twitterButton isSelected])
        return true;
    if([emailButton isSelected])
        return true;
    if([tumblrButton isSelected])
        return true;
    if([flickrButton isSelected])
        return true;
    if([instagramButton isSelected])
        return true;
    if([smsButton isSelected])
        return true;
    //if([clipboardButton isSelected])
    //    return true;
    
    return false;
}

-(IBAction)onClickFacebookButton{
    
    if([facebookButton isSelected]){
        [facebookButton setSelected:NO];        
    } else {

        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        appDelegate.facebook.sessionDelegate = self;
        
        if([appDelegate.facebook isSessionValid]) {            
            [facebookButton setSelected:YES];            
        } else {
            [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                             @"publish_stream", nil]];            
        }
    }
}

-(IBAction)onClickTwitterButton{
    
    if([twitterButton isSelected]){
        [twitterButton setSelected:NO];
    
    } else {

        if([TWTweetComposeViewController canSendTweet]){
            [twitterButton setSelected:YES];
        }  else {
            [self showAlert:@"No Twitter connection" message:@"You must be connected to Twitter from device settings."];
        }
    }
}

-(IBAction)onClickInstagramButton{
    if([instagramButton isSelected]){
        [instagramButton setSelected:NO];
    } else {
        [instagramButton setSelected:YES];
    }
}

-(IBAction)onClickEmailButton{
    if([emailButton isSelected]){
        [emailButton setSelected:NO];
    } else {
        [emailButton setSelected:YES];
    }
}

-(IBAction)onClickTumblrButton{
    if([tumblrButton isSelected]){
        [tumblrButton setSelected:NO];
    } else {
        
        [tumblrButton setSelected:YES];
        
        if([[TMAPIClient sharedInstance].OAuthToken length] > 0  && [[TMAPIClient sharedInstance].OAuthTokenSecret length] > 0){

        } else {
        
            [TMAPIClient sharedInstance].OAuthConsumerKey = TumblrAPIKey;
            [TMAPIClient sharedInstance].OAuthConsumerSecret = TumblrSecretKey;
            
            if((![[[TMAPIClient sharedInstance] OAuthToken] length] > 0) ||
               (![[[TMAPIClient sharedInstance] OAuthTokenSecret] length] > 0)){
                
                [[TMAPIClient sharedInstance] authenticate:@"Flyerly" callback:^(NSError *error) {
                    if (error){
                        NSLog(@"Authentication failed: %@ %@", error, [error description]);
                    }else{
                        NSLog(@"Authentication successful!");
                        
                    }
                }];
            }
        }
    }
}

-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
    } else {
        
        [flickrButton setSelected:YES];
        [flickrRequest setDelegate:self];
        
        //NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        //NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];

        //if((![authToken length] > 0) || (![authTokenSecret length] > 0)){
            [self authorizeAction];
        //}
    }
}

-(IBAction)onClickSMSButton{
    if([smsButton isSelected]){
        [smsButton setSelected:NO];
    } else {
        [smsButton setSelected:YES];
        
        [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    }
}

-(IBAction)onClickClipboardButton{
    if([clipboardButton isSelected]){
        [clipboardButton setSelected:NO];
    } else {
        [clipboardButton setSelected:YES];

        [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    }
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)searchFlickrPhotos:(NSString *)text
{
    
    // Build the string to call the Flickr API
	NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=15&format=json&nojsoncallback=1", FlickrAPIKey, text];
    
    // Create NSURL string from formatted string
	NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
    [request release];
    
}

-(void)showAlert{
    
    [self updateSocialStates];
    
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared"
     message:@"Your Flyer is Shared."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
}

-(void)updateSocialStates{
    
    // Save states of all supported social media
	NSMutableArray *socialArray = [[[NSMutableArray alloc] init] autorelease];
    
    if([facebookButton isSelected]){
        [socialArray addObject:@"1"]; //Facebook
    } else  {
        [socialArray addObject:@"0"]; //Facebook
    }
    
    if([twitterButton isSelected]){
        [socialArray addObject:@"1"]; //Twitter
    } else  {
        [socialArray addObject:@"0"]; //Twitter
    }
    
    if([emailButton isSelected]){
        [socialArray addObject:@"1"]; //Email
    } else  {
        [socialArray addObject:@"0"]; //Email
    }

    if([tumblrButton isSelected]){
        [socialArray addObject:@"1"]; //Tumblr
    } else  {
        [socialArray addObject:@"0"]; //Tumblr
    }

    if([flickrButton isSelected]){
        [socialArray addObject:@"1"]; //Flickr
    } else  {
        [socialArray addObject:@"0"]; //Flickr
    }
    
    if([instagramButton isSelected]){
        [socialArray addObject:@"1"]; //Instagram
    } else  {
        [socialArray addObject:@"0"]; //Instagram
    }
    
    [socialArray addObject:@"0"]; //SMS
    [socialArray addObject:@"0"]; //Clipboard
    
    NSString *socialFlyerPath = [imageFileName stringByReplacingOccurrencesOfString:@"/Flyr/" withString:@"/Flyr/Social/"];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
    
    [[NSFileManager defaultManager] removeItemAtPath:finalImgWritePath error:nil];
    [socialArray writeToFile:finalImgWritePath atomically:YES];
}

-(void)updateFlyerDetail {
	
    // delete already existing file and
    // Add file with same name
    [[NSFileManager defaultManager] removeItemAtPath:detailFileName error:nil];
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:titleView.text];
    if([descriptionView.text isEqualToString:AddCaptionText]){
        [array addObject:@""];
    }else{
        [array addObject:descriptionView.text];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:FlyerDateFormat];
    NSString *dateString = [dateFormat stringFromDate:date];
    [array addObject:dateString];

    [array writeToFile:detailFileName atomically:YES];
	
    // delete already exsiting file and
    // add same image with same name
    //  This is done to match the update time when sorting the files
    [[NSFileManager defaultManager] removeItemAtPath:imageFileName error:nil];
	NSData *imgData = UIImagePNGRepresentation(selectedFlyerImage);
	[[NSFileManager defaultManager] createFileAtPath:imageFileName contents:imgData attributes:nil];

}

#pragma Sharing code

-(void)shareOnMMS{
    
    /*
    NSString *phoneToCall = @"sms:123-456-7890";
    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];
    
    [[UIApplication sharedApplication] openURL:url];
     */

    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"];
        //controller.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

-(void)shareOnEmail{

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Check out my Flyr..."];
        
        // Set up recipients
        NSArray *toRecipients = [[[NSArray alloc]init]autorelease];
        NSArray *ccRecipients =   [[[NSArray alloc]init]autorelease];
        NSArray *bccRecipients =   [[[NSArray alloc]init]autorelease];
        [picker setToRecipients:toRecipients];
        [picker setCcRecipients:ccRecipients];
        [picker setBccRecipients:bccRecipients];

        // Fill out the email body text
        NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"flyr.png"];
        
        NSString *emailBody = [NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"];
        [picker setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
}

-(void)shareOnInstagram{

     CGRect rect = CGRectMake(0 ,0 , 0, 0);
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIGraphicsEndImageContext();
     
     UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    
     //UIImage *instagramImage = [PhotoController imageWithImage:originalImage scaledToSize:CGSizeMake(612, 612)];
     
     NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".igo"];
     NSData *imgData = UIImagePNGRepresentation(originalImage);
     [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
     
     NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
     
     self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
     self.dic.UTI = @"com.instagram.photo";
     //self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
     self.dic.annotation = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"] forKey:@"InstagramCaption"];     [self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
}

-(void)shareOnTumblr{

    [tumblrPogressView.statusText setText:@"Sharing..."];
    [tumblrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];

    [[TMAPIClient sharedInstance] userInfo:^(id data, NSError *error) {
        if (error){
            NSLog(@"User Data failed: %@ %@", error, [error description]);
            [self fillErrorStatus:tumblrPogressView];
        }else{
            NSLog(@"User data fetched successful! %@", data);
            
            NSDictionary *userData = [data objectForKey:@"user"];
            NSString *name = [userData objectForKey:@"name"];
            NSLog(@"%@", name);
            
            [self uploadFiles:[TMAPIClient sharedInstance].OAuthToken oauthSecretKey:[TMAPIClient sharedInstance].OAuthTokenSecret blogName:name];
        }
    }];
}

-(void)shareOnFlickr{
    
    [flickrPogressView.statusText setText:@"Sharing..."];
    [flickrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSData *imageData = UIImageJPEGRepresentation(selectedFlyerImage, 0.9);
    
    [appDelegate.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:imageData] suggestedFilename:selectedFlyerTitle MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public",@"Title", @"title", [NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"], @"description", nil]];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

-(void)shareOnFacebook{

    [facebookPogressView.statusText setText:@"Sharing..."];
    [facebookPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"], @"message",  //whatever message goes here
                                   selectedFlyerImage, @"picture",   //img is your UIImage
                                   nil];
    [[appDelegate facebook] requestWithGraphPath:@"me/photos"
                                       andParams:params
                                   andHttpMethod:@"POST"
                                     andDelegate:self];
}

- (void)shareOnTwitter {
    
    [twitterPogressView.statusText setText:@"Sharing..."];
    [twitterPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];

    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
        if (granted == YES) {
            
            TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
            
            //add text
            [postRequest addMultiPartData:[[NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"] dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
            //add image
            [postRequest addMultiPartData:UIImagePNGRepresentation(selectedFlyerImage) withName:@"media" type:@"multipart/form-data"];
            
            // Set the account used to post the tweet.
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            [postRequest setAccount:[arrayOfAccounts objectAtIndex:0]];
            
            // Perform the request created above and create a handler block to handle the response.
            [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                if(responseData){
                    NSMutableDictionary *responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",responseDictionary);
                    NSString *errors = [responseDictionary objectForKey:@"errors"];
                    
                    if(errors){
                        [self fillErrorStatus:twitterPogressView];
                    }else{
                        [self fillSuccessStatus:twitterPogressView];
                    }
                } else {
                    [self shareOnTwitter];
                    //[self fillErrorStatus:twitterPogressView];
                }
            }];

        }
    }];
}

#pragma show sharing progress row

-(void)showFacebookProgressRow{
    
    facebookPogressView = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0];
    [facebookPogressView setFrame:CGRectMake(facebookPogressView.frame.origin.x, 36 * countOfSharingNetworks++, facebookPogressView.frame.size.width, facebookPogressView.frame.size.height)];
    
    [facebookPogressView.statusText setText:@""];
    [facebookPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_fb"] forState:UIControlStateNormal];
    [facebookPogressView.cancelIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [facebookPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [facebookPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [facebookPogressView.refreshIcon setHidden:YES];
    [facebookPogressView.refreshIcon addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:facebookPogressView];
    [self increaseProgressViewHeightBy:36];
    
}
-(void)showTwitterProgressRow{
    
    NSArray *arr = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0];
    NSLog(@"%@", arr);
    
    twitterPogressView = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:[[ShareProgressView alloc] init] options:nil] objectAtIndex:0];
    [twitterPogressView setFrame:CGRectMake(twitterPogressView.frame.origin.x, 36 * countOfSharingNetworks++, twitterPogressView.frame.size.width, twitterPogressView.frame.size.height)];

    [twitterPogressView.statusText setText:@""];
    [twitterPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_twitter"] forState:UIControlStateNormal];
    [twitterPogressView.cancelIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [twitterPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [twitterPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [twitterPogressView.refreshIcon setHidden:YES];
    [twitterPogressView.refreshIcon addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [progressView addSubview:twitterPogressView];
    [self increaseProgressViewHeightBy:36];
    
}

-(void)showTumblrProgressRow{
    
    tumblrPogressView = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0];
    [tumblrPogressView setFrame:CGRectMake(tumblrPogressView.frame.origin.x, 36 * countOfSharingNetworks++, tumblrPogressView.frame.size.width, tumblrPogressView.frame.size.height)];

    [tumblrPogressView.statusText setText:@""];
    [tumblrPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_tumblr"] forState:UIControlStateNormal];
    [tumblrPogressView.cancelIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [tumblrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [tumblrPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [tumblrPogressView.refreshIcon setHidden:YES];
    [tumblrPogressView.refreshIcon addTarget:self action:@selector(shareOnTumblr) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:tumblrPogressView];
    [self increaseProgressViewHeightBy:36];
}

-(void)showFlickrProgressRow{

    flickrPogressView = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0];
    [flickrPogressView setFrame:CGRectMake(flickrPogressView.frame.origin.x, 36 * countOfSharingNetworks++, flickrPogressView.frame.size.width, flickrPogressView.frame.size.height)];

    [flickrPogressView.statusText setText:@""];
    [flickrPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_flickr"] forState:UIControlStateNormal];
    [flickrPogressView.cancelIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [flickrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [flickrPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [flickrPogressView.refreshIcon setHidden:YES];
    [flickrPogressView.refreshIcon addTarget:self action:@selector(shareOnFlickr) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:flickrPogressView];
    [self increaseProgressViewHeightBy:36];
}

#pragma update state text and icons
-(void)fillErrorStatus:(ShareProgressView *)view{
    [view.statusText setText:@"Sharing Failed!"];
    [view.statusText setTextColor:[UIColor yellowColor]];
    [view.statusIcon setBackgroundImage:[UIImage imageNamed:@"status_failed"] forState:UIControlStateNormal];
    [view.refreshIcon setHidden:NO];
    [view.cancelIcon setBackgroundImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
}

-(void)fillSuccessStatus:(ShareProgressView *)view{
    [view.statusText setTextColor:[UIColor greenColor]];
    [view.statusText setText:@"Successfully Shared!"];
    [view.cancelIcon setBackgroundImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
    [view.statusIcon setBackgroundImage:[UIImage imageNamed:@"status_success"] forState:UIControlStateNormal];
    [view.refreshIcon setHidden:YES];
}

-(void)closeSharingProgressSuccess{
    countOfSharingNetworks--;
    [self increaseProgressViewHeightBy:-36];
    
    // Take backup of progress views
    NSArray *subViews = [progressView subviews];
    // Remove all progress views
    [[progressView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Re insert all progress view with new y axis
    int yAxis = 0;
    for(UIView *subview in subViews){
        [subview setFrame:CGRectMake(subview.frame.origin.x, yAxis, subview.frame.size.width, subview.frame.size.height)];
        [progressView addSubview:subview];
        yAxis = yAxis + 36;
    }
    
    if(countOfSharingNetworks <= 0){
        [self setDefaultProgressViewHeight];
        [progressView setHidden:YES];
    }
}

-(void)increaseProgressViewHeightBy:(int)height{
    [progressView setFrame:CGRectMake(progressView.frame.origin.x, progressView.frame.origin.y, progressView.frame.size.width, progressView.frame.size.height + height)];
    [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height + height)];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + height)];
}

-(void)setDefaultProgressViewHeight{
    [progressView setFrame:CGRectMake(0, 2, 310, 3)];
    [scrollView setFrame:CGRectMake(5, 50, 310, 401)];
    [scrollView setContentSize:CGSizeMake(310, 401)];
}

-(void)remoAllSharingViews{
    for(UIView *view in progressView.subviews){
        [view removeFromSuperview];
    }
}

#pragma Request receive code

- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [facebookButton setSelected:YES];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response: %@", response);
    [self fillSuccessStatus:facebookPogressView];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    [self fillErrorStatus:facebookPogressView];
}

- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{

    NSLog(@"presentOptionsMenuFromRect");
    
    return YES;
}

-(void)flickrSharingSuccess{
    
    [self fillSuccessStatus:flickrPogressView];
    
    if([instagramButton isSelected] && ![tumblrButton isSelected]){
        [self shareOnInstagram];
    }
}

-(void)flickrSharingFailure{
    
    [self fillErrorStatus:flickrPogressView];
    
    if([instagramButton isSelected] && ![tumblrButton isSelected]){
        [self shareOnInstagram];
    }
}

- (void)authorizeAction {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    // if there's already OAuthToken, we want to reauthorize
    if ([appDelegate.flickrContext.OAuthToken length]) {
        [appDelegate.flickrContext  setAuthToken:nil];
    }
    
    self.flickrRequest.sessionInfo = kTryObtainAuthToken;
    [self.flickrRequest  fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:kCallbackURLBaseString]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;
{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    // these two lines are important
    appDelegate.flickrContext.OAuthToken = inRequestToken;
    appDelegate.flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [appDelegate.flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}

- (OFFlickrAPIRequest *)flickrRequest
{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:appDelegate.flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes {
    NSLog(@"Success");
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError {
    
    /*
     NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[inError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     */
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    [appDelegate setAndStoreFlickrAuthToken:nil secret:nil];
    [self authorizeAction];
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
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
    
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                       
                                       // Open email composer if selected
                                       if([smsButton isSelected]){
                                           [self shareOnMMS];
                                       } else {
                                           
                                           if([instagramButton isSelected] && (![tumblrButton isSelected] && ![flickrButton isSelected])){

                                               [self shareOnInstagram];
                                           }
                                       }
                                       
                                   }];
	//[controller dismissModalViewControllerAnimated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			break;
		case MessageComposeResultFailed:
			break;
	}
    
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                       
                                       if([instagramButton isSelected] && (![tumblrButton isSelected] && ![flickrButton isSelected] && ![emailButton isSelected])){
                                           
                                           [self shareOnInstagram];
                                       }
                                   }];
}

- (void) uploadFiles:(NSString *)oauthToken oauthSecretKey:(NSString *)oauthSecretKey blogName:(NSString *)blogName{
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(originalImage)];
    
    NSArray *array = [NSArray arrayWithObjects:data1, nil];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc] initWithNSDataForPhotos:array andBlogName:[NSString stringWithFormat:@"%@.tumblr.com", blogName] andDelegate:self andCaption:[NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"]];
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [tu signAndSendWithTokenKey:oauthToken andSecret:oauthSecretKey];
        });
    });
}

- (void) tumblrUploadr:(TumblrUploadr *)tu didFailWithError:(NSError *)error {
    NSLog(@"connection failed with error %@",[error localizedDescription]);
    [tu release];
    
    [self fillErrorStatus:tumblrPogressView];
    
    if([instagramButton isSelected]){
        [self shareOnInstagram];
    }
    
}
- (void) tumblrUploadrDidSucceed:(TumblrUploadr *)tu withResponse:(NSString *)response {
    NSLog(@"connection succeeded with response: %@", response);
    [tu release];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [response dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    NSDictionary *meta = [dict objectForKey:@"meta"];
    NSString *status = [[meta objectForKey:@"status"] stringValue];
    
    if([status isEqualToString:@"201"]){
        [self fillSuccessStatus:tumblrPogressView];
    }else{
        [self fillErrorStatus:tumblrPogressView];
    }
    
    if([instagramButton isSelected]){
        [self shareOnInstagram];
    }
    
}

- (void)postDismissCleanup {
	[navBar removeFromSuperview];
	[navBar release];
    
    
}

- (void)dismissNavBar:(BOOL)animated {
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		navBar.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self dismissNavBar:YES];
    
    // If text changed then save it again
    if(![selectedFlyerTitle isEqualToString:titleView.text] || ![selectedFlyerDescription isEqualToString:descriptionView.text]){
        [self updateFlyerDetail];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[svController release];
    [super dealloc];
}

@end
