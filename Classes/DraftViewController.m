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

@implementation DraftViewController

@synthesize selectedFlyerImage,imgView,navBar,fvController,svController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView,dic;

-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
	[fvController release];
}

-(void)loadDistributeView
{
	svController.isDraftView = YES;
	[self.navigationController pushViewController:svController animated:YES];
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

	svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = selectedFlyerImage;
	svController.isDraftView = YES;
	svController.dvController =self;
	//svController.ptController = self;
	
	//self.navigationItem.title = @"Social Flyer";
	self.navigationController.navigationBarHidden = NO;
    
    UILabel *addBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [addBackgroundLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:8.5]];
    [addBackgroundLabel setTextColor:[MyCustomCell colorWithHexString:@"008ec0"]];
    [addBackgroundLabel setBackgroundColor:[UIColor clearColor]];
    [addBackgroundLabel setText:@"Share flyer"];
    UIBarButtonItem *barLabel = [[UIBarButtonItem alloc] initWithCustomView:addBackgroundLabel];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,barLabel,nil]];

	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[UIView commitAnimations];
	//imgView = [[UIImageView alloc]initWithImage:selectedFlyerImage];
	//[self.view addSubview:imgView];
	[imgView setImage:selectedFlyerImage];

    [titleView setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
	[titleView setText:selectedFlyerTitle];
    
    [descriptionView setFont:[UIFont fontWithName:@"Signika-Regular" size:10]];
    [descriptionView setTextColor:[UIColor grayColor]];
	[descriptionView setText:selectedFlyerDescription];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	navBar= [[MyNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.view addSubview:navBar];
	[navBar show:@"SocialFlyr" left:@"Browser" right:@"Share"];
	[self.view bringSubviewToFront:navBar];
	
	[navBar.leftButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	
	[navBar.leftButton addTarget:self action:@selector(callFlyrView) forControlEvents:UIControlEventTouchUpInside];
	[navBar.rightButton addTarget:self action:@selector(loadDistributeView) forControlEvents:UIControlEventTouchUpInside];
	navBar.alpha = ALPHA1;
	
}

-(void)share{
    
    if([self isAnyNetworkSelected]){
        loadingView =[LoadingView loadingViewInView:self.view  text:@"Sharing..."];
        
        if([facebookButton isSelected]){
            [self shareOnFacebook];
        }
        
        if([twitterButton isSelected]){
            [self shareOnTwitter];
        }
        
        if([instagramButton isSelected]){
            [self shareOnInstagram];
        }
        
        [self showAlert];
    
    } else {
    
        [self showAlert:@"Nothing Selected !" message:@"Please select any network to share"];
        
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
    if([clipboardButton isSelected])
        return true;
    
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
        
        [TMAPIClient sharedInstance].OAuthConsumerKey = @"7g8ugn9opLIb2oKLQBlnbDjBoYKQHbVd9TgtVZRMz5NK1GXgXS";
        [TMAPIClient sharedInstance].OAuthConsumerSecret = @"4uAmyM6YOL0UyGykUPaRpkCVVELLze9Nu1I2bNWXRWYOuDQA6u";
        
        [[TMAPIClient sharedInstance] authenticate:@"Flyerly" callback:^(NSError *error) {
            if (error){
                NSLog(@"Authentication failed: %@ %@", error, [error description]);
            }else{
                NSLog(@"Authentication successful!");
                [tumblrButton setSelected:YES];
            }
        }];
    }
}

-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
    } else {
        [flickrButton setSelected:YES];
    }
}

-(IBAction)onClickSMSButton{
    if([smsButton isSelected]){
        [smsButton setSelected:NO];
    } else {
        [smsButton setSelected:YES];
    }
}

-(IBAction)onClickClipboardButton{
    if([clipboardButton isSelected]){
        [clipboardButton setSelected:NO];
    } else {
        [clipboardButton setSelected:YES];
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

- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [facebookButton setSelected:YES];
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
    
    [socialArray addObject:@"0"]; //Email
    [socialArray addObject:@"0"]; //Tumblr
    [socialArray addObject:@"0"]; //Flickr
    
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
   if(![selectedFlyerTitle isEqualToString:titleView.text]){
        [self updateFlyerDetail];
    }
}

-(void)updateFlyerDetail {
	
    // delete already existing file and
    // Add file with same name
    [[NSFileManager defaultManager] removeItemAtPath:detailFileName error:nil];
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    [array addObject:titleView.text];
    [array addObject:descriptionView.text];
    [array writeToFile:detailFileName atomically:YES];
	
    // delete already exsiting file and
    // add same image with same name
    //  This is done to match the update time when sorting the files
    [[NSFileManager defaultManager] removeItemAtPath:imageFileName error:nil];
	NSData *imgData = UIImagePNGRepresentation(selectedFlyerImage);
	[[NSFileManager defaultManager] createFileAtPath:imageFileName contents:imgData attributes:nil];

}

-(void)shareOnInstagram{

     CGRect rect = CGRectMake(0 ,0 , 0, 0);
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIGraphicsEndImageContext();
     
     UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];     
     UIImage *instagramImage = [PhotoController imageWithImage:originalImage scaledToSize:CGSizeMake(612, 612)];
     
     NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".igo"];
     NSData *imgData = UIImagePNGRepresentation(instagramImage);
     [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
     
     NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
     
     self.dic.UTI = @"com.instagram.photo";
     self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
     self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
     [self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
}

-(void)shareOnTumblr{
    [self uploadFiles:[TMAPIClient sharedInstance].OAuthToken oauthSecretKey:[TMAPIClient sharedInstance].OAuthTokenSecret];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

-(void)shareOnFacebook{

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"", @"message",  //whatever message goes here
                                   selectedFlyerImage, @"picture",   //img is your UIImage
                                   nil];
    [[appDelegate facebook] requestWithGraphPath:@"me/photos"
                                       andParams:params
                                   andHttpMethod:@"POST"
                                     andDelegate:self];

}

- (void)shareOnTwitter {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        // Did user allow us access?
        if (granted == YES) {
            
            TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
            
            //add text
            [postRequest addMultiPartData:[@"My new Flyer !" dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
            //add image
            [postRequest addMultiPartData:UIImagePNGRepresentation(selectedFlyerImage) withName:@"media" type:@"multipart/form-data"];
            
            // Set the account used to post the tweet.
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            [postRequest setAccount:[arrayOfAccounts objectAtIndex:0]];
            
            // Perform the request created above and create a handler block to handle the response.
            [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                //NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                //[self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
            }];

        }
    }];
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

- (void) uploadFiles:(NSString *)oauthToken oauthSecretKey:(NSString *)oauthSecretKey {
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(originalImage)];
    
    NSArray *array = [NSArray arrayWithObjects:data1, nil];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc] initWithNSDataForPhotos:array andBlogName:@"rizzz86gmail.tumblr.com" andDelegate:self andCaption:@"Great Photos!"];
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [tu signAndSendWithTokenKey:oauthToken andSecret:oauthSecretKey];
        });
    });
}

- (void) tumblrUploadr:(TumblrUploadr *)tu didFailWithError:(NSError *)error {
    NSLog(@"connection failed with error %@",[error localizedDescription]);
    [tu release];
}
- (void) tumblrUploadrDidSucceed:(TumblrUploadr *)tu withResponse:(NSString *)response {
    NSLog(@"connection succeeded with response: %@", response);
    [tu release];
}

@end
