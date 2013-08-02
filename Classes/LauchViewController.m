//
//  LauchViewController.m
//  Flyer
//
//  Created by Krunal on 13/10/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "LauchViewController.h"
#import "PhotoController.h"
#import "FlyrViewController.h"
#import "SettingViewController.h"
#import "AddFriendsController.h"
#import "LoadingView.h"
#import "FlyrAppDelegate.h"
#import "DraftViewController.h"
#import "Common.h"
#import "HelpController.h"
#import "FacebookLikeView.h"
#import "Flurry.h"

@interface LauchViewController () <FacebookLikeViewDelegate, FBSessionDelegate>

@end

@implementation LauchViewController

@synthesize ptController,spController,tpController,createFlyrLabel,savedFlyrLabel,inviteFriendLabel,addFriendsController;
@synthesize firstFlyer, secondFlyer, thirdFlyer, fourthFlyer, photoArray, photoDetailArray, createFlyrButton, savedFlyrButton, inviteFriendButton;
@synthesize loadingView;
@synthesize facebookLikeView=_facebookLikeView;
@synthesize likeButton,followButton,webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
    }
    return self;
}

// Load Create Flyr Method With Thread
 -(void)loadPhotoView{
	//loadingViewFlag = YES;
	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
     ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
	[ptController release];
}

-(IBAction)doNew:(id)sender{
	//loadingView =[LoadingView loadingViewInView:self.view];
    //[self loadPhotoView];
	//[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(loadPhotoView) userInfo:nil repeats:NO];

    [Flurry logEvent:@"Create Flyer"];

	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
    ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
	[ptController release];
}
//End

// Load View Flyr Method With Thread
-(void)loadFlyerView{
	//loadingViewFlag = YES;
	tpController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
	[self.navigationController pushViewController:tpController animated:YES];
	[tpController release];
}

-(IBAction)doOpen:(id)sender{
	//loadingView =[LoadingView loadingViewInView:self.view];
	[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(loadFlyerView) userInfo:nil repeats:NO];
}
//End


// Load Preferences Method 
-(IBAction)doAbout:(id)sender{
	[self.navigationController pushViewController:spController animated:YES];
}
//End

// Load invite friends
-(IBAction)doInvite:(id)sender{
    
	addFriendsController = [[AddFriendsController alloc]initWithNibName:@"AddFriendScreen" bundle:nil];

	[self.navigationController pushViewController:addFriendsController animated:YES];
}
//End

#pragma mark View Appear 

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;

    // Set the background image on navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_with_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setHidesBackButton:YES];
    // Create right bar button
    //UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    //[menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    //[menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    //UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    //[self.navigationItem setRightBarButtonItem:rightBarButton];

    // Set left bar items
    //[self.navigationItem setLeftBarButtonItems: [self leftBarItems]];       
    
    firstFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    secondFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    thirdFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    fourthFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    //fifthFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];
    //sixthFlyer.image = [UIImage imageNamed:@"pinned_flyer2.png"];

	[self filesByModDate];
}

/*
 * Returns the left items on navigation bar
 * Add space item with help icon
 */
-(NSArray *)leftBarItems{
    // Space item
    UIBarButtonItem *spaceBarButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)]];
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 16)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    NSMutableArray *leftItems = [NSMutableArray arrayWithObjects:spaceBarButton,leftBarButton,nil];
    
    return leftItems;
}

-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	//self.navigationItem.title = @"Menu";
	//loadingViewFlag = NO;
	//loadingView = nil;
	//loadingView = [[LoadingView alloc]init];
    
    if(IS_IPHONE_5){
        numberOfFlyers = 6;
    }else{
        numberOfFlyers = 4;
    }
    
    [createFlyrLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [createFlyrLabel setText:NSLocalizedString(@"create_flyer", nil)];
    
    [savedFlyrLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [savedFlyrLabel setText:NSLocalizedString(@"saved_flyers", nil)];

    [inviteFriendLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [inviteFriendLabel setText:NSLocalizedString(@"invite_friends", nil)];

    spController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
	//[spController initSession];

    //initialize facebook
	FlyrAppDelegate *appDelegate = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if(!appDelegate.facebook) {
        
        //get facebook app id
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        appDelegate.facebook = [[Facebook alloc] initWithAppId:[dict objectForKey: @"FacebookAppID"] andDelegate:self];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FACEBOOK_LIKED"]){
        [likeButton setSelected:YES];
    }

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"TWITTER_FOLLOWING"]){
        [followButton setSelected:YES];
    }
    
}

-(void)filesByModDate
{
	photoArray =[[NSMutableArray alloc]initWithCapacity:numberOfFlyers];
	photoDetailArray =[[NSMutableArray alloc]initWithCapacity:numberOfFlyers];
	NSString *homeDirectoryPath = NSHomeDirectory();
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr/",appDelegate.loginId]];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]], nil]];
	//NSString *unexpandedDetailPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Detail/"];
	//NSString *detailFolderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[unexpandedDetailPath stringByExpandingTildeInPath]], nil]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	NSString *finalImagePath;
	//NSArray *detailFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:detailFolderPath error:nil];
	NSString *detailFinalImagePath;

	NSArray* sortedFiles;
	NSArray* detailSortedFiles;
    int fileCount = [files count];
    //int detailFileCount = [detailFiles count];
    
	for(int i = 0; i < fileCount; i++)
	{
		NSString *img = [files objectAtIndex:i];
		img = [@"/" stringByAppendingString:img];
		finalImagePath= [folderPath stringByAppendingString:img];
        
        if([finalImagePath hasSuffix:@".jpg"]){
            [photoArray addObject:finalImagePath];
        } else if([finalImagePath hasSuffix:@".txt"]){
            [photoDetailArray addObject:finalImagePath];
        }
	}
	//for(int j = 0; j < detailFileCount; j++)
	//{
	//	NSString *fileName = [detailFiles objectAtIndex:j];
	//	fileName = [@"/" stringByAppendingString:fileName];
	//	detailFinalImagePath= [detailFolderPath stringByAppendingString:fileName];
    //
    //    [photoDetailArray addObject:detailFinalImagePath];
	//}

    sortedFiles = [photoArray sortedArrayUsingFunction:dateModifiedSortMain context:nil];
    detailSortedFiles = [photoDetailArray sortedArrayUsingFunction:dateModifiedSortMain context:nil];

	[photoArray removeAllObjects];
	[photoDetailArray removeAllObjects];
	for(int i =0;i< [sortedFiles count];i++)
	{
        CGSize size = CGSizeMake(firstFlyer.frame.size.width, firstFlyer.frame.size.height);
        
        finalImagePath = [sortedFiles objectAtIndex:i];
        NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:finalImagePath];
        UIImage *currentFlyerImage = [UIImage imageWithData:imageData];

        [photoArray addObject:finalImagePath];

        if(i == 0){
            firstFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            firstFlyer.tag = i;
        } else if(i  == 1){
            secondFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            secondFlyer.tag = i;
        } else if(i  == 2){
            thirdFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            thirdFlyer.tag = i;
        } else if(i  == 3){
            fourthFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            fourthFlyer.tag = i;
            
            if(!IS_IPHONE_5){
                break;
            }
            
        }
        
        /*else if(i  == 4){
            fifthFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            fifthFlyer.tag = i;
        } else if(i  == 5){
            sixthFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
            sixthFlyer.tag = i;
            break;
        }*/
	}

	for(int j =0;j< [detailSortedFiles count];j++)
	{
        detailFinalImagePath = [detailSortedFiles objectAtIndex:j];
        //NSLog(@"detailFinalImagePath: %@", detailFinalImagePath);
        NSArray *myArray = [NSArray arrayWithContentsOfFile:detailFinalImagePath];

        if(j < numberOfFlyers){
            [photoDetailArray addObject:myArray];
        }
	}
}

NSInteger dateModifiedSortMain(id file1, id file2, void *reverse) {
    NSDictionary *attrs1 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file1
                            error:nil];
    NSDictionary *attrs2 = [[NSFileManager defaultManager]
                            attributesOfItemAtPath:file2
                            error:nil];
	
    if ((NSInteger *)reverse == 0) {
        return [[attrs2 objectForKey:NSFileModificationDate]
                compare:[attrs1 objectForKey:NSFileModificationDate]];
    }
	
    return [[attrs1 objectForKey:NSFileModificationDate]
            compare:[attrs2 objectForKey:NSFileModificationDate]];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark View Disappear
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	//self.navigationItem.title = @"Menu";
	//self.navigationController.navigationBarHidden = YES;
	//if(loadingViewFlag)
	//{
	//	[loadingView removeFromSuperview];
	//	loadingViewFlag=NO;
	//}
}

-(IBAction)createTwitLogin:(id)sender{
	TwitLogin *twitDialog = [[TwitLogin alloc]init];
	//twitDialog.flyerImage = flyrImg;
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
	twitDialog.svController = appDele.svController;
	appDele._tSession = twitDialog;
	[twitDialog show];
	[self.view addSubview:twitDialog];
}

-(IBAction)showFlyerDetail:(UIImageView *)sender{

    if(photoArray.count > sender.tag){

        DraftViewController *draftViewController = [[DraftViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
        
        NSString *imageName = [photoArray objectAtIndex:sender.tag];
        NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:imageName];
        UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
        //draftViewController.fvController = self;
        draftViewController.selectedFlyerImage = currentFlyerImage;
        
        if(photoDetailArray.count > sender.tag){
            NSArray *detailArray = [photoDetailArray objectAtIndex:sender.tag];
            NSString *title = [detailArray objectAtIndex:0];
            NSString *description = [detailArray objectAtIndex:1];
            draftViewController.selectedFlyerTitle = title;
            draftViewController.selectedFlyerDescription = description;
            draftViewController.imageFileName = imageName;

            NSString *newText = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
            draftViewController.detailFileName = newText;
        }
        
        [self.navigationController pushViewController:draftViewController animated:YES];
        [draftViewController release];
        //[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    
    } else {
    
        // Open create flyer screen
        //[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(loadPhotoView) userInfo:nil repeats:NO];
        [self loadPhotoView];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == firstFlyer) {
        [self showFlyerDetail:firstFlyer];
    } else if ([touch view] == secondFlyer) {
        [self showFlyerDetail:secondFlyer];
    } else if ([touch view] == thirdFlyer) {
        [self showFlyerDetail:thirdFlyer];
    } else if ([touch view] == fourthFlyer) {
        [self showFlyerDetail:fourthFlyer];
    }
    /*else if ([touch view] == fifthFlyer) {
        [self showFlyerDetail:fifthFlyer];
    } else if ([touch view] == sixthFlyer) {
        [self showFlyerDetail:sixthFlyer];
    }*/
    
}

#pragma Like code

- (IBAction)onTwitter:(id)sender {
    UIButton *button = (UIButton *) sender;
    
    if([button isSelected]){
        [self unFollowOnTwitter:sender];
    } else {
        [self followOnTwitter:sender];
    }
}

- (IBAction)followOnTwitter:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"flyerlyapp" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]
                                                             parameters:tempDict
                                                          requestMethod:TWRequestMethodPOST];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
                    
                    if([[output lowercaseString] rangeOfString:[@"200" lowercaseString]].location == NSNotFound){
                        [followButton setSelected:NO];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
                    } else {
                        [followButton setSelected:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
                    }
                }];
            }
        }
    }];
}

- (IBAction)unFollowOnTwitter:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"flyerlyapp" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/destroy.json"]
                                                             parameters:tempDict
                                                          requestMethod:TWRequestMethodPOST];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
                    
                    if([[output lowercaseString] rangeOfString:[@"200" lowercaseString]].location == NSNotFound){
                        [followButton setSelected:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
                    } else {
                        [followButton setSelected:NO];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
                    }
                }];
            }
        }
    }];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    
    [loadingView removeView];
    self.likeView.hidden = NO;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    //self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

/*-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [loadingView removeView];
    self.likeView.hidden = NO;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    //self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSLog(@"HOST: %@", request.URL.host);
    
    // Allow loading Like button XFBML from file
    if ([request.URL.host isEqual:[[NSURL URLWithString:@"http://www.facebook.com/flyerlyapp"] absoluteString]])
        return YES;
    
    // Allow loading about:blank, etc.
    if ([request.URL.scheme isEqualToString:@"about"])
        return YES;
    
    // Block loading of 'event:*', our scheme for forwarding Facebook JS SDK events to native code
    else if ([request.URL.scheme isEqualToString:@"event"]) {
        //[self didObserveFacebookEvent:request.URL.resourceSpecifier];
        return NO;
    }

    return YES;
}*/

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button un selected
    [likeButton setSelected:NO];

    // Remove views
    [self goBack];
    
    // Remove liked status
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FACEBOOK_LIKED"];

    // show alert message
    //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
    //                                                 message:@"You unliked Flyerly. Where's the love?"
    //                                                delegate:self
    //                                       cancelButtonTitle:@"OK"
    //                                       otherButtonTitles:nil] autorelease];
    //[alert show];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button selected
    [likeButton setSelected:YES];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // Remove views
    [self goBack];
    
    // Set like status
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_LIKED"];
    
    //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
    //                                                 message:@"You liked Flyerly. Thanks!"
    //                                                delegate:self
    //                                       cancelButtonTitle:@"OK"
    //                                       otherButtonTitles:nil] autorelease];
    //[alert show];
}

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream", @"publish_stream", @"email", nil]];
}

- (IBAction)showLikeButton {
    
     /*FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
     appDelegate.facebook.sessionDelegate = self;
     
     if([appDelegate.facebook isSessionValid]) {

         loadingView =[LoadingView loadingViewInView:self.view  text:@"Wait..."];
         [self.view addSubview:opaqueView];
         [self.view  addSubview:crossButton];
         
         self.facebookLikeView.delegate = self;
         self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/flyerlyapp"];
         self.facebookLikeView.layout = @"button_count";
         self.facebookLikeView.showFaces = NO;
         [self.facebookLikeView load];

     } else {
     
         [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream", @"publish_stream", @"email", nil]];
     }*/

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    appDelegate.facebook.sessionDelegate = self;
    
    if([appDelegate.facebook isSessionValid]) {

        crossButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 64, 25, 25)];
        [crossButton setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        [crossButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        opaqueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [opaqueView setBackgroundColor:[UIColor darkGrayColor]];
        opaqueView.alpha = 0.5;
        
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 74, 300, 315)];
        NSString *urlAddress = @"http://www.facebook.com/flyerlyapp";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webview loadRequest:requestObj];
        
        [self.view addSubview:opaqueView];
        [self.view  addSubview:webview];
        [self.view  addSubview:crossButton];
        
    } else {
        
        [appDelegate.facebook authorize:[NSArray arrayWithObjects: @"read_stream",
                                         @"publish_stream", @"user_likes", nil]];
    }
}

-(IBAction)goBack{
    [opaqueView removeFromSuperview];
    [webview removeFromSuperview];
    [crossButton removeFromSuperview];
    
    [self.likeView setHidden:YES];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    [appDelegate.facebook requestWithGraphPath:@"me/likes" andDelegate:self];
}

-(void)request:(FBRequest *)request didLoad:(id)result{
 
 	NSLog(@"Request received %@", result);    
    for (NSDictionary *likesData in [result objectForKey:@"data"]) {
        
        // Here we will get the facebook contacts
        NSString *likeName = [likesData objectForKey:@"name"];
        if([likeName isEqualToString:@"Flyerly"]){
            [likeButton setSelected:YES];
            return;
        } else {
            [likeButton setSelected:NO];
        }
    }
}

- (void)fbDidLogin {
	NSLog(@"logged in");
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    //save to session
    NSLog(@"%@",appDelegate.facebook.accessToken);
    NSLog(@"%@",appDelegate.facebook.expirationDate);
    
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showLikeButton];
}

#pragma mark Dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[spController release];
    [photoArray release];

    [super dealloc];
}


@end
