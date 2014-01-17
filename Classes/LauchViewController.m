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
#import "FlyrAppDelegate.h"
#import "ShareViewController.h"
#import "Common.h"
#import "HelpController.h"
#import "Flurry.h"
#import "SHKConfiguration.h"
#import "MySHKConfigurator.h"

@interface LauchViewController () 

@end

@implementation LauchViewController

@synthesize ptController,spController,tpController,createFlyrLabel,savedFlyrLabel,inviteFriendLabel,addFriendsController;
@synthesize firstFlyer, secondFlyer, thirdFlyer, fourthFlyer, photoArray, photoDetailArray, createFlyrButton, savedFlyrButton, inviteFriendButton;
@synthesize facebookLikeView;
@synthesize likeButton,followButton,webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
    }
    return self;
}

// Load Create Flyr Method With Thread
 -(void)loadPhotoView{
	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
     ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
}

-(IBAction)doNew:(id)sender{
    [Flurry logEvent:@"Create Flyer"];

	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
    ptController.flyerNumber = -1;
	[self.navigationController pushViewController:ptController animated:YES];
}
//End

// Load View Flyr Method With Thread
-(void)loadFlyerView{
	tpController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
	[self.navigationController pushViewController:tpController animated:YES];
}

-(IBAction)doOpen:(id)sender{
	[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(loadFlyerView) userInfo:nil repeats:NO];
}
//End


// Load Preferences Method 
-(IBAction)doAbout:(id)sender{
    MainSettingViewController *mainsettingviewcontroller = [[MainSettingViewController alloc]initWithNibName:@"MainSettingViewController" bundle:nil] ;
    [self.navigationController pushViewController:mainsettingviewcontroller animated:YES];
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
    
    globle.NBUimage = nil;
    
    self.navigationController.navigationBarHidden = NO;
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FACEBOOK_LIKED"]){
        [likeButton setSelected:YES];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"TWITTER_FOLLOWING"]){
        [followButton setSelected:YES];
    }
    
    // Set the background image on navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
  
    // for Navigation Bar logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 87, 38)];
    [logo setImage:[UIImage imageNamed:@"flyerlylogo"]];
    self.navigationItem.titleView = logo;
    
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
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
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
	globle = [Singleton RetrieveSingleton];
    createFlyrButton.showsTouchWhenHighlighted = YES;
    savedFlyrButton.showsTouchWhenHighlighted = YES;
    inviteFriendButton.showsTouchWhenHighlighted = YES;
    likeButton.showsTouchWhenHighlighted = YES;
    followButton.showsTouchWhenHighlighted = YES;
    setBotton.showsTouchWhenHighlighted = YES;

    
    if(IS_IPHONE_5){
        numberOfFlyers = 6;
    }else{
        numberOfFlyers = 4;
    }
    
   // [createFlyrLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [createFlyrLabel setText:NSLocalizedString(@"create_flyer", nil)];
    
    //[savedFlyrLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [savedFlyrLabel setText:NSLocalizedString(@"saved_flyers", nil)];

    //[inviteFriendLabel setFont:[UIFont fontWithName:BUTTON_FONT size:13]];
    [inviteFriendLabel setText:NSLocalizedString(@"invite_friends", nil)];
    spController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    //GET FACEBOOK APP LIKE STATUS
    [self setFacebookLikeStatus];
    
    
    
	//[spController initSession];

    //initialize facebook

/*
	FlyrAppDelegate *appDelegate = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];

    
    if(!appDelegate.facebook) {
        
        //get facebook app id
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        appDelegate.facebook = [[Facebook alloc] initWithAppId:dict[@"FacebookAppID"] andDelegate:self];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    */

    
}

-(void)filesByModDate
{
	photoArray =[[NSMutableArray alloc]initWithCapacity:numberOfFlyers];
	photoDetailArray =[[NSMutableArray alloc]initWithCapacity:numberOfFlyers];
	NSString *homeDirectoryPath = NSHomeDirectory();
    
    PFUser *user = [PFUser currentUser];

	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr/",user.username]];
    
	NSString *folderPath = [NSString pathWithComponents:@[[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]]]];
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
		NSString *img = files[i];
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
        
        finalImagePath = sortedFiles[i];
        NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:finalImagePath];
        UIImage *currentFlyerImage = [UIImage imageWithData:imageData];

        [photoArray addObject:finalImagePath];

        if(i == 0){
            firstFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size ];
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
        detailFinalImagePath = detailSortedFiles[j];
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
        return [attrs2[NSFileModificationDate]
                compare:attrs1[NSFileModificationDate]];
    }
	
    return [attrs1[NSFileModificationDate]
            compare:attrs2[NSFileModificationDate]];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(IBAction)showFlyerDetail:(UIImageView *)sender{

    if(photoArray.count > sender.tag){

        ShareViewController *draftViewController = [[ShareViewController alloc] initWithNibName:@"DraftViewController" bundle:nil];
        
        NSString *imageName = photoArray[sender.tag];
        NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:imageName];
        UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
        //draftViewController.fvController = self;
        draftViewController.selectedFlyerImage = currentFlyerImage;
        
        if(photoDetailArray.count > sender.tag){
            NSArray *detailArray = photoDetailArray[sender.tag];
            NSString *title = detailArray[0];
            NSString *description = detailArray[1];
            draftViewController.selectedFlyerTitle = title;
            draftViewController.selectedFlyerDescription = description;
            draftViewController.imageFileName = imageName;

            NSString *newText = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@".txt"];
            draftViewController.detailFileName = newText;
        }
        
        [self.navigationController pushViewController:draftViewController animated:YES];
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
    if([AddFriendsController connected]){
        if([button isSelected]){
            [self unFollowOnTwitter:sender];
        } else {
            [self followOnTwitter:sender];
        }
    } else {
        [self showAlert:@"You're not connected to the internet. Please connect and retry." message:@""];
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

- (void)makeTwitterPost:(ACAccount *)acct follow:(int)follow {
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"flyerlyapp" forKey:@"screen_name"];
    [tempDict setValue:@"true" forKey:@"follow"];
    
    
    TWRequest *postRequest;
    if ( follow == 1 ) {
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]
                                                 parameters:tempDict
                                              requestMethod:TWRequestMethodPOST];
    } else {
        postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/destroy.json"]
                                                     parameters:tempDict
                                                  requestMethod:TWRequestMethodPOST];
    }
    
    [postRequest setAccount:acct];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
        NSLog(@"%@", output);
        
        [self hideLoadingIndicator];
        
        if([[output lowercaseString] rangeOfString:[@"200" lowercaseString]].location == NSNotFound){
            
            if ( follow == 1 ) {
                [followButton setSelected:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
            } else {
                [followButton setSelected:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
            }
        } else {
            
            if ( follow == 1 ) {
                [followButton setSelected:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TWITTER_FOLLOWING"];
            } else {
                [followButton setSelected:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TWITTER_FOLLOWING"];
            }
        }
    }];
    
}

- (IBAction)followOnTwitter:(id)sender {
    [self showLoadingIndicator];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        if(granted) {
            // Get the list of Twitter accounts.
          NSArray  *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            twtAcconts = [[NSArray alloc] initWithArray:arrayOfAccounts];
            // If there are more than 1 account, ask user which they want to use.
            if ( [arrayOfAccounts count] > 1 ) {
                // Show list of acccounts from which to select
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                    actionSheet.tag = 1;
                    
                    for (int i = 0; i < arrayOfAccounts.count; i++) {
                        ACAccount *acct = arrayOfAccounts[i];
                        [actionSheet addButtonWithTitle:acct.username];
                    }
                    
                    [actionSheet addButtonWithTitle:@"Cancel"];
                    [actionSheet showInView:self.view];
                });
                
            } else if ( [arrayOfAccounts count] > 0 ) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = arrayOfAccounts[0];
                [self makeTwitterPost:twitterAccount follow:1];
            } else {
                [self hideLoadingIndicator];
            }
        } else {
            [self hideLoadingIndicator];
        }
    }];
}

- (IBAction)unFollowOnTwitter:(id)sender {
    [self showLoadingIndicator];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            
            // Get the list of Twitter accounts.
           NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            twtAcconts = [[NSArray alloc] initWithArray:arrayOfAccounts];
            // If there are more than 1 account, ask user which they want to use.
            if ( [arrayOfAccounts count] > 1 ) {
                // Show list of acccounts from which to select
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
                    actionSheet.tag = 0;
                    
                    for (int i = 0; i < arrayOfAccounts.count; i++) {
                        ACAccount *acct = arrayOfAccounts[i];
                        [actionSheet addButtonWithTitle:acct.username];
                    }
                    
                    [actionSheet addButtonWithTitle:@"Cancel"];
                    [actionSheet showInView:self.view];
                });
                
            } else if ( [arrayOfAccounts count] > 0 ) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = arrayOfAccounts[0];
                [self makeTwitterPost:twitterAccount follow:0];
            } else {
                [self hideLoadingIndicator];
            }
        } else {
            [self hideLoadingIndicator];
        }
    }];
}

/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if not cancel button presses
 
    if(buttonIndex != twtAcconts.count) {
        
        //save to NSUserDefault
        ACAccount *account = twtAcconts[buttonIndex];
        
        //Convert twitter username to email
        [self makeTwitterPost:account follow:actionSheet.tag];
    }
    [self hideLoadingIndicator];
}


- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    
    self.likeView.hidden = NO;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button un selected
    [likeButton setSelected:NO];

    // Remove views
    [self goBack];
    
    // Remove liked status
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FACEBOOK_LIKED"];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    
    // Set like button selected
    [likeButton setSelected:YES];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // Remove views
    [self goBack];
    
    // Set like status
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_LIKED"];
}

- (IBAction)showLikeButton {
    
    if([AddFriendsController connected]){
        
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        //get facebook app id
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
        NSDictionary *options = @{ACFacebookAppIdKey : dict[@"FacebookAppID"],
                                  ACFacebookPermissionsKey : @[@"email", @"publish_stream"],
                                  ACFacebookAudienceKey:ACFacebookAudienceFriends};
        
        [accountStore requestAccessToAccountsWithType:FBaccountType options:options completion:^(BOOL granted, NSError *error) {
            
            // if User Login in device
            if ( granted ) {
                
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:FBaccountType];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    
                    // Calling The Facebook Like Button
                    self.facebookLikeView.delegate = self;
                    self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/flyerlyapp"];
                    self.facebookLikeView.layout = @"button_count";
                    self.facebookLikeView.showFaces = NO;
                    [self.facebookLikeView load];
                    
                 }
                
            } else {
                
                //Fail gracefully...
                NSLog(@"error getting permission %@",error);
                [self showAlert:@"There is no Facebook account configured. You can add or create a Facebook account in Settings" message:@""];
            }
        }];
    
    }
        
}


- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {

}


/*
 * Getting
 */
- (void)setFacebookLikeStatus{

    if([AddFriendsController connected]){
        
        
        // getting Facebook account Info From Device
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        // Get facebook account
        DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
        
        NSDictionary *options = @{ACFacebookAppIdKey : [configurator facebookAppId],
                                  ACFacebookPermissionsKey : @[@"email", @"publish_stream"],
                                  ACFacebookAudienceKey:ACFacebookAudienceFriends};
        
        
        [accountStore requestAccessToAccountsWithType:FBaccountType options:options completion:^(BOOL granted, NSError *error) {
            
            // if User Login in device
            if ( granted ) {
                
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:FBaccountType];
                ACAccount *account = [arrayOfAccounts lastObject];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    
                    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me/likes"];
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                            requestMethod:SLRequestMethodGET
                                                                      URL:requestURL
                                                               parameters:nil];
                    request.account = account;
                    
                    [request performRequestWithHandler:^(NSData *data,
                                                         NSHTTPURLResponse *response,
                                                         NSError *error) {
                        
                        if(!error){
                            NSDictionary *likeslist =[NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions error:&error];
                            
                            //NSLog(@"Request received %@", likeslist);
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FACEBOOK_LIKED"];
                            for (NSDictionary *likesData in likeslist[@"data"]) {
                                
                                // Here we will get the facebook contacts
                                
                                NSString *likeName = likesData[@"name"];
                                if([likeName isEqualToString:@"Flyerly"]){
                                    [self.likeButton setSelected:YES];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FACEBOOK_LIKED"];
                                    return;
                                } else {
                                    [likeButton setSelected:NO];
                                    
                                }
                            }
                            
                        }
                        
                    }];
                }
                
            }
        }];
        
    }


}

-(IBAction)goBack{
    [opaqueView removeFromSuperview];
    [webview removeFromSuperview];
    [crossButton removeFromSuperview];
    
    [self.likeView setHidden:YES];
}

@end
