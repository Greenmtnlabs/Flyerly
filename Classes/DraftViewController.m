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

@implementation DraftViewController

@synthesize selectedFlyerImage,imgView,navBar,fvController,svController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView;

-(void)share{
    
    loadingView =[LoadingView loadingViewInView:self.view  text:@"Sharing..."];

    if([facebookButton isSelected]){
        [self shareOnFacebook];
    }

    if([twitterButton isSelected]){
        [self shareOnTwitter];
    }
}

-(void)request:(FBRequest *)request didLoad:(id)result{

}

-(void)showAlert{

    NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *MyFlyerPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Flyr/"];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[MyFlyerPath stringByStandardizingPath]],nil]];

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
    [socialArray addObject:@"0"]; //Instagram
    [socialArray addObject:@"0"]; //SMS
    [socialArray addObject:@"0"]; //Clipboard
    [self updateSocialStates:folderPath imageName:imageFileName stateArray:socialArray];

    
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared"
                                                    message:@"Your Flyer is Shared."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)updateSocialStates:(NSString *)directory imageName:(NSString *)imageName stateArray:(NSArray *)stateArray{
    
    NSString *socialFlyerPath = [imageName stringByReplacingOccurrencesOfString:@"/Flyr/" withString:@"/Flyr/Social/"];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
    
    [[NSFileManager defaultManager] removeItemAtPath:finalImgWritePath error:nil];
    [stateArray writeToFile:finalImgWritePath atomically:YES];
}

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

    // Set facebook button state
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    if([appDelegate.facebook isSessionValid]){
        [facebookButton setSelected:YES];
    }
    
    // Set twitter button state
    if([TWTweetComposeViewController canSendTweet]){
        [twitterButton setSelected:YES];
    }
    
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
                [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
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


@end
