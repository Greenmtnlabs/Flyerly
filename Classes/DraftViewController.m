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
        
        if([flickrButton isSelected]){
            [self shareOnFlickr];
        }
        
        if([tumblrButton isSelected]){
            [self shareOnTumblr];
        }
        
        if([instagramButton isSelected] && ![tumblrButton isSelected]){
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
        
        [tumblrButton setSelected:YES];

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

- (void)authorizeAction {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    // if there's already OAuthToken, we want to reauthorize
    if ([appDelegate.flickrContext.OAuthToken length]) {
        [appDelegate.flickrContext  setAuthToken:nil];
    }
    
    self.flickrRequest.sessionInfo = kTryObtainAuthToken;
    [self.flickrRequest  fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:kCallbackURLBaseString]];
}

-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
    } else {
        
        [flickrButton setSelected:YES];
        [flickrRequest setDelegate:self];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];

        if((![authToken length] > 0) || (![authTokenSecret length] > 0)){
            [self authorizeAction];
        }
    }
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
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[inError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
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

/*- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
	NSDictionary *results = [jsonString JSONValue];
	
    // Build an array from the dictionary for easy access to each entry
	NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    // Loop through each entry in the dictionary...
	for (NSDictionary *photo in photos)
    {
        // Get title of the image
		NSString *title = [photo objectForKey:@"title"];
        
        // Save the title to the photo titles array
		[photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
		
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id/secret
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
		NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        NSLog(@"photoURLString: %@", photoURLString);
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
		[photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
		photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
		[photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];
        NSLog(@"photoURLsLareImage: %@", photoURLString);
	}
    
}*/

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
    
    [[TMAPIClient sharedInstance] userInfo:^(id data, NSError *error) {
        if (error){
            NSLog(@"User Data failed: %@ %@", error, [error description]);
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
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSData *imageData = UIImageJPEGRepresentation(selectedFlyerImage, 0.9);
    
    [appDelegate.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:imageData] suggestedFilename:@"Test" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
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

- (void) uploadFiles:(NSString *)oauthToken oauthSecretKey:(NSString *)oauthSecretKey blogName:(NSString *)blogName{
    
    UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(originalImage)];
    
    NSArray *array = [NSArray arrayWithObjects:data1, nil];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc] initWithNSDataForPhotos:array andBlogName:[NSString stringWithFormat:@"%@.tumblr.com", blogName] andDelegate:self andCaption:@"Great Photos!"];
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [tu signAndSendWithTokenKey:oauthToken andSecret:oauthSecretKey];
        });
    });
}

- (void) tumblrUploadr:(TumblrUploadr *)tu didFailWithError:(NSError *)error {
    NSLog(@"connection failed with error %@",[error localizedDescription]);
    [tu release];
    
    if([instagramButton isSelected]){
        [self shareOnInstagram];
    }

}
- (void) tumblrUploadrDidSucceed:(TumblrUploadr *)tu withResponse:(NSString *)response {
    NSLog(@"connection succeeded with response: %@", response);
    [tu release];
    
    if([instagramButton isSelected]){
        [self shareOnInstagram];
    }

}

@end
