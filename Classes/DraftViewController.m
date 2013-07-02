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
#import "AddFriendsController.h"
#import "FlyerOverlayController.h"
#import "HelpController.h"
#import <Parse/PFFile.h>
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>
#import "LocationController.h"

static UIView *progressView;
static ShareProgressView *flickrPogressView;
static ShareProgressView *facebookPogressView;
static ShareProgressView *twitterPogressView;
static ShareProgressView *tumblrPogressView;

@implementation DraftViewController

@synthesize selectedFlyerImage,imgView,navBar,fvController,svController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView,dic,fromPhotoController,scrollView,instagramPogressView, saveToCameraRollLabel, saveToRollSwitch,twit,locationBackground,locationLabel,networkParentView,locationButton;
//@synthesize twitterPogressView,facebookPogressView,tumblrPogressView,flickrPogressView,progressView;

-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
	[fvController release];
}

-(void)loadDistributeView
{
	svController.isDraftView = YES;
	[self.navigationController pushViewController:svController animated:YES];
}

/*
 * pop to root view / main screen
 */
-(void) callMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
    
    // Init loading view
    loadingView = nil;
	loadingView = [[LoadingView alloc]init];

    // Set sharing network to zero
    countOfSharingNetworks = 0;

    // init progress view
    if(!progressView){
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 310, 3)];
        [self.view addSubview:progressView];
    } else {
        // Remove all progress views
        [[progressView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [progressView setFrame:CGRectMake(0, 46, 310, 3)];
        [self.view addSubview:progressView];
    }
    
    // Set click event on switch
    [saveToRollSwitch addTarget:self action:@selector(setSwitchState:) forControlEvents:UIControlEventValueChanged];
    
    // Set facebook as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"facebookSetting"]){
        [facebookButton setSelected:YES];
    }else{
        [facebookButton setSelected:NO];
    }
    
    // Set twitter as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"twitterSetting"]){
        [twitterButton setSelected:YES];
    }else{
        [twitterButton setSelected:NO];
    }
    
    // Set instagram as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"instagramSetting"]){
        [instagramButton setSelected:YES];
    }else{
        [instagramButton setSelected:NO];
    }

    // Set email as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"emailSetting"]){
        [emailButton setSelected:YES];
    }else{
        [emailButton setSelected:NO];
    }

    // Set sms as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"smsSetting"]){
        [smsButton setSelected:YES];
    }else{
        [smsButton setSelected:NO];
    }
    
    // Set clip as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"clipSetting"]){
        [clipboardButton setSelected:YES];
    }else{
        [clipboardButton setSelected:NO];
    }

    // Set tumblr as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"tumblrSetting"]){
        [tumblrButton setSelected:YES];
    }else{
        [tumblrButton setSelected:NO];
    }

    // Set flickr as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"flickrSetting"]){
        [flickrButton setSelected:YES];
    }else{
        [flickrButton setSelected:NO];
    }

    // Add observers for 1) Flickr sharing success. 2) Flickr sharing failure. 3) Closing shring view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flickrSharingSuccess) name:FlickrSharingSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flickrSharingFailure) name:FlickrSharingFailureNotification object:nil];    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CloseShareProgressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSharingProgressSuccess:) name:CloseShareProgressNotification object:nil];

	svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = selectedFlyerImage;
	svController.isDraftView = YES;
	svController.dvController =self;
	//svController.ptController = self;
	
	//self.navigationItem.title = @"Social Flyer";
	self.navigationController.navigationBarHidden = NO;
    
    // If navigating from Create flyer then show menu button on left 
    if(fromPhotoController){
        self.navigationItem.hidesBackButton = YES;
        
        // Create right bar button
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

        // Create left bar help button
        UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
        [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
        [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
        UIBarButtonItem *leftHelpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
        [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,leftHelpBarButton,nil]];
        
        [self.navigationItem setLeftBarButtonItem:leftBarButton];

    } else {
        self.navigationItem.leftItemsSupplementBackButton = YES;

        // Create left bar help button
        UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 16)];
        [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
        [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
        UIBarButtonItem *leftHelpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
        [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftHelpBarButton,nil]];
}

    // Set title on bar
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Share flyer" rect:CGRectMake(-60, -6, 50, 50)];

    // Set font and size on camera roll text
    [saveToCameraRollLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    // Set font and size on camera roll text
    [locationLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];

    // Setup flyer edit button
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    [editButton addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:[UIImage imageNamed:@"pencil_blue"] forState:UIControlStateNormal];

    // Get index from flyer image path
    NSString *index = [FlyrViewController getFlyerNumberFromPath:imageFileName];
    editButton.tag = [index intValue];
    UIBarButtonItem *rightEditBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    // Setup flyer share button
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 33)];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,rightEditBarButton,nil]];

	[UIView commitAnimations];
    [imgView addTarget:self action:@selector(showFlyerOverlay:) forControlEvents:UIControlEventTouchUpInside];
	[imgView setImage:selectedFlyerImage forState:UIControlStateNormal];

    NSString *flyerNumber = [FlyrViewController getFlyerNumberFromPath:imageFileName];
    self.imgView.tag = [flyerNumber intValue];
    
    // Setup title text field
    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    [titleView setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    if([selectedFlyerTitle isEqualToString:@""]){
        [titleView setText:NameYourFlyerText];
    }else{
        [titleView setText:selectedFlyerTitle];
    }
    
    // Setup description text view
    [descriptionView setFont:[UIFont fontWithName:@"Signika-Regular" size:10]];
    [descriptionView setTextColor:[UIColor grayColor]];
    [descriptionView setReturnKeyType:UIReturnKeyDone];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [descriptionView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    if([selectedFlyerDescription isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
    }else{
        [descriptionView setText:selectedFlyerDescription];
    }
    
    // Show progress views if they are not cancelled manually
    if(twitterPogressView){
        [progressView setHidden:NO];
        [progressView addSubview:twitterPogressView];
        countOfSharingNetworks++;
        [self increaseProgressViewHeightBy:36];
    }
    if(facebookPogressView){
        [progressView setHidden:NO];
        [progressView addSubview:facebookPogressView];
        countOfSharingNetworks++;
        [self increaseProgressViewHeightBy:36];
    }
    if(flickrPogressView){
        [progressView setHidden:NO];
        [progressView addSubview:flickrPogressView];
        countOfSharingNetworks++;
        [self increaseProgressViewHeightBy:36];
    }
    if(tumblrPogressView){
        [progressView setHidden:NO];
        [progressView addSubview:tumblrPogressView];
        countOfSharingNetworks++;
        [self increaseProgressViewHeightBy:36];
    }
}

/*
 * get switch on off event
 */
-(void)setSwitchState:(id)sender {
    if([sender isOn]){
        [locationLabel setHidden:NO];
        [locationBackground setHidden:NO];
        [locationButton setHidden:NO];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height + 30)];
        // move view down
        [networkParentView setFrame:CGRectMake(networkParentView.frame.origin.x, networkParentView.frame.origin.y + 30, networkParentView.frame.size.width, networkParentView.frame.size.height)];
        [UIView commitAnimations];

    }else{
        [locationLabel setHidden:YES];
        [locationBackground setHidden:YES];
        [locationButton setHidden:YES];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height - 30)];        
        // move view up
        [networkParentView setFrame:CGRectMake(networkParentView.frame.origin.x, networkParentView.frame.origin.y - 30, networkParentView.frame.size.width, networkParentView.frame.size.height)];
        [UIView commitAnimations];
}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
}

-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

-(void)showFlyerOverlay:(id)sender{
    
    // cast to button
    UIButton *cellImageButton = (UIButton *) sender;
    // Get image on button
    UIImage *flyerImage = [cellImageButton imageForState:UIControlStateNormal];
    // Create Modal trnasparent view
    UIView *modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [modalView setBackgroundColor:[MyCustomCell colorWithHexString:@"161616"]];
    modalView.alpha = 0.75;
    self.navigationController.navigationBar.alpha = 0.35;
    
    // Create overlay controller
    FlyerOverlayController *overlayController = [[FlyerOverlayController alloc]initWithNibName:@"FlyerOverlayController" bundle:nil image:flyerImage modalView:modalView];
    // set its parent
    [overlayController setViews:self];
    //NSLog(@"showFlyerOverlay Tag: %d", cellImageButton.tag);
    overlayController.flyerNumber = cellImageButton.tag;
    
    // Add modal view and overlay view
    [self.view addSubview:modalView];
    [self.view addSubview:overlayController.view];
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
    }
}

#pragma on click buttons

/*
 * Pass flyer number and controller to open flyer in editable mode
 */
-(void)onEdit:(UIButton *)button{

    // Pass flyer number and controller to open flyer in editable mode
    [FlyerOverlayController openFlyerInEditableMode:button.tag parentViewController:self];
}

/*
 * Share flyer on selected networks
 */
-(void)share{
    
    // Check if any network in selected
    if([self isAnyNetworkSelected]){
    
        // Check if only those buttons are selected that did'nt required connectivity
        if([self onlyNonConnectivityNetworkSelected]){
            
            if([smsButton isSelected]){
                [self shareOnMMS];
            }
            
        }else{
            
            // Check internet connectivity
            if([AddFriendsController connected]){
                
                // Remove sharing view if on the screen
                //[self remoAllSharingViews];
                
                // Set default height for progress parent view
                //[self setDefaultProgressViewHeight];
                
                // Set 0 sharing netwroks
                //countOfSharingNetworks = 0;
                
                //loadingView =[LoadingView loadingViewInView:self.view  text:@"Sharing..."];
                
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
                
                // Set progress view hidden
                [progressView setHidden:NO];
                
                [self showAlert];
                
                
            } else {
                
                [self showAlert:@"Warning!" message:@"You must be connected to the Internet."];
            }
        }

    } else {
        
        [self showAlert:@"Warning!" message:@"Please select at least one sharing option."];
        
    }
    
}

/*
 * Check for network selection
 */
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

/*
 * Check for network selection for only non connectivity types
 */
-(BOOL)onlyNonConnectivityNetworkSelected{
    
    if(([smsButton isSelected] || [clipboardButton isSelected])
       &&
       (![facebookButton isSelected] && ![twitterButton isSelected] && ![emailButton isSelected] && ![tumblrButton isSelected] && ![flickrButton isSelected] && ![instagramButton isSelected])){
    
        return true;
    
    } else{
        return false;
    }
}

/*
 * Called when facebook button is pressed
 */
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

/*
 * Called when twitter button is pressed
 */
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

/*
 * Called when instagram button is pressed
 */
-(IBAction)onClickInstagramButton{
    if([instagramButton isSelected]){
        [instagramButton setSelected:NO];
    } else {
        [instagramButton setSelected:YES];
    }
}

/*
 * Called when email button is pressed
 */
-(IBAction)onClickEmailButton{
    if([emailButton isSelected]){
        [emailButton setSelected:NO];
    } else {
        [emailButton setSelected:YES];
    }
}

/*
 * Called when tumblr button is pressed
 */
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
                
                loadingView =[LoadingView loadingViewInView:self.view  text:@"Wait..."];

                [[TMAPIClient sharedInstance] authenticate:@"Flyerly" callback:^(NSError *error) {
                    
                    // Remove loading view
                    for (UIView *subview in self.view.subviews) {
                        if([subview isKindOfClass:[LoadingView class]]){
                            [subview removeFromSuperview];
                        }
                    }
                    
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

/*
 * Called when flickr button is pressed
 */
-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
    } else {
        
        [flickrButton setSelected:YES];
        [flickrRequest setDelegate:self];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        if (![appDelegate.flickrContext.OAuthToken length]) {

            loadingView =[LoadingView loadingViewInView:self.view  text:@"Wait..."];
            
            [self authorizeAction];
        }
    }
}

/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    if([smsButton isSelected]){
        [smsButton setSelected:NO];
    } else {
        [smsButton setSelected:YES];
        
        [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    }
}

/*
 * Called when clipboard button is pressed
 */
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

-(void)showAlert{
    
    [self updateSocialStates];
    
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }
}

-(void)updateSocialStates{    
    
    NSString *socialFlyerPath = [imageFileName stringByReplacingOccurrencesOfString:@"/Flyr/" withString:@"/Flyr/Social/"];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
    
    NSMutableArray *socialArray = [[NSMutableArray alloc] initWithContentsOfFile:finalImgWritePath];
    if(!socialArray){
        socialArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if([socialArray count] > 0){
    
        // Save states of all supported social media
        if([facebookButton isSelected]){
            [socialArray removeObjectAtIndex:0]; //Facebook
            [socialArray insertObject:@"1" atIndex:0]; //Facebook
        }
        
        if([twitterButton isSelected]){
            [socialArray removeObjectAtIndex:1]; //Twitter
            [socialArray insertObject:@"1" atIndex:1]; //Twitter
        }
        
        if([emailButton isSelected]){
            [socialArray removeObjectAtIndex:2]; //Email
            [socialArray insertObject:@"1" atIndex:2]; //Email
        }
        
        if([tumblrButton isSelected]){
            [socialArray removeObjectAtIndex:3]; //Tumblr
            [socialArray insertObject:@"1" atIndex:3]; //Tumblr
        }
        
        if([flickrButton isSelected]){
            [socialArray removeObjectAtIndex:4]; //Flickr
            [socialArray insertObject:@"1" atIndex:4]; //Flickr
        }
        
        if([instagramButton isSelected]){
            [socialArray removeObjectAtIndex:5]; //Instagram
            [socialArray insertObject:@"1" atIndex:5]; //Instagram
        }

    } else {
            
        // Save states of all supported social media
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
    }
    
    [socialArray addObject:@"0"]; //SMS
    [socialArray addObject:@"0"]; //Clipboard

    [[NSFileManager defaultManager] removeItemAtPath:finalImgWritePath error:nil];
    [socialArray writeToFile:finalImgWritePath atomically:YES];
}

-(void)updateFlyerDetail {
	
    // delete already existing file and
    // Add file with same name
    [[NSFileManager defaultManager] removeItemAtPath:detailFileName error:nil];
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];

    if(!titleView.text || [titleView.text isEqualToString:NameYourFlyerText]){
        [array addObject:@""];
    }else{
        [array addObject:self.titleView.text];
    }

    if(!descriptionView.text || [descriptionView.text isEqualToString:AddCaptionText]){
        [array addObject:@""];
    }else{
        [array addObject:self.descriptionView.text];
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

/*
 * Share on MMS
 */
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

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:[FlyrViewController getFlyerNumberFromPath:imageFileName] data:imageData];    
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *flyerObject = [PFObject objectWithClassName:@"Flyer"];
            [flyerObject setObject:imageFile forKey:@"image"];
            
            // Set the access control list to current user for security purposes
            flyerObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [flyerObject setObject:user forKey:@"user"];
            
            [flyerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    // Remove loading view
                    for (UIView *subview in self.view.subviews) {
                        if([subview isKindOfClass:[LoadingView class]]){
                            [subview removeFromSuperview];
                        }
                    }

                    PFFile *theImage = [flyerObject objectForKey:@"image"];
                    [self shareOnEmail:[theImage url]];
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
    [self uploadImage:imageData];
}

-(void)shareOnEmail:(NSString *)link{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"You just received a NEW flyer!"];        
        NSMutableString *emailBody = [[[NSMutableString alloc] initWithString:@"<html><body>"] retain];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly/email'>A flyerly creation...</a></font></p>"];
        
        [emailBody appendString:[NSString stringWithFormat:@"<p><img src='%@'></p>",link]];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly'>Download flyerly & share a flyer</a></font></p>"];
        [emailBody appendString:@"</body></html>"];
        NSLog(@"%@",emailBody);
        
        //mail composer window
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
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
    
     //UIImage *instagramImage = [PhotoController imageWithImage:originalImage scaledToSize:CGSizeMake(612, 612)];
     
     NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".igo"];
     NSData *imgData = UIImagePNGRepresentation(originalImage);
     [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
     
     NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
    
     self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
     self.dic.UTI = @"com.instagram.photo";
     //self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
     self.dic.annotation = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@", selectedFlyerDescription, @"#flyerly"] forKey:@"InstagramCaption"];
    BOOL displayed = [self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    
    if(!displayed){
        [self showAlert:@"Warning!" message:@"Please install Instagram app to share."];
    }
    /*
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    */
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

/*
 * Share on Tumblr
 */
-(void)shareOnTumblr{

    [tumblrPogressView.statusText setText:@"Sharing..."];
    [tumblrPogressView.statusText setTextColor:[UIColor yellowColor]];
    [tumblrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];

    if([[TMAPIClient sharedInstance].OAuthToken length] > 0  && [[TMAPIClient sharedInstance].OAuthTokenSecret length] > 0){

        [self shareOnTumblr:YES];
        
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
                    [self shareOnTumblr:YES];
                }
            }];
        }
    }
}

-(void)shareOnTumblr:(BOOL)overloaded{

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

/*
 * Share on Flickr
 */
-(void)shareOnFlickr{
    
    [flickrPogressView.statusText setText:@"Sharing..."];
    [flickrPogressView.statusText setTextColor:[UIColor yellowColor]];
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

/*
 * Share on Facebook
 */
-(void)shareOnFacebook{

    [facebookPogressView.statusText setText:@"Sharing..."];
    [facebookPogressView.statusText setTextColor:[UIColor yellowColor]];
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

/*
 * Share on Twitter
 */
- (void)shareOnTwitter {
    
    [twitterPogressView.statusText setText:@"Sharing..."];
    [twitterPogressView.statusText setTextColor:[UIColor yellowColor]];
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
                    //[self shareOnTwitter];
                    [self fillErrorStatus:twitterPogressView];
                }
            }];

        }
    }];
}

#pragma show sharing progress row

-(void)showFacebookProgressRow{
    
    // Remove and Add if view already visible
    if(facebookPogressView){
        NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", facebookPogressView.tag], @"tag", nil];
        [facebookPogressView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil userInfo:itemDetails];
    }

    facebookPogressView = nil;
    facebookPogressView = [[[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0] retain];
    [facebookPogressView setFrame:CGRectMake(facebookPogressView.frame.origin.x, 36 * countOfSharingNetworks++, facebookPogressView.frame.size.width, facebookPogressView.frame.size.height)];
    facebookPogressView.tag = 1;
    
    [facebookPogressView.statusText setText:@""];
    [facebookPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_fb"] forState:UIControlStateNormal];
    [facebookPogressView.cancelIcon setHidden:YES];
    [facebookPogressView.cancelIcon setImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
    [facebookPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [facebookPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [facebookPogressView.refreshIcon setHidden:YES];
    [facebookPogressView.refreshIcon addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:facebookPogressView];
    [self increaseProgressViewHeightBy:36];
    
}
-(void)showTwitterProgressRow{
    
    //NSArray *arr = [[[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0] retain];
    //NSLog(@"%@", arr);
    
    // Remove and Add if view already visible
    if(twitterPogressView){
        NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", twitterPogressView.tag], @"tag", nil];
        [twitterPogressView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil userInfo:itemDetails];
    }
    
    twitterPogressView = nil;
    twitterPogressView = [[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:[[ShareProgressView alloc] init] options:nil] objectAtIndex:0];
    [twitterPogressView setFrame:CGRectMake(twitterPogressView.frame.origin.x, 36 * countOfSharingNetworks++, twitterPogressView.frame.size.width, twitterPogressView.frame.size.height)];
    twitterPogressView.tag = 2;

    [twitterPogressView.statusText setText:@""];
    [twitterPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_twitter"] forState:UIControlStateNormal];
    [twitterPogressView.cancelIcon setHidden:YES];
    [twitterPogressView.cancelIcon setImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
    [twitterPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [twitterPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [twitterPogressView.refreshIcon setHidden:YES];
    [twitterPogressView.refreshIcon addTarget:self action:@selector(shareOnTwitter) forControlEvents:UIControlEventTouchUpInside];
    [progressView addSubview:twitterPogressView];
    [self increaseProgressViewHeightBy:36];
    
}

-(void)showTumblrProgressRow{
    
    // Remove and Add if view already visible
    if(tumblrPogressView){
        NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", tumblrPogressView.tag], @"tag", nil];
        [tumblrPogressView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil userInfo:itemDetails];
    }
    
    tumblrPogressView = nil;
    tumblrPogressView = [[[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0] retain];
    [tumblrPogressView setFrame:CGRectMake(tumblrPogressView.frame.origin.x, 36 * countOfSharingNetworks++, tumblrPogressView.frame.size.width, tumblrPogressView.frame.size.height)];
    tumblrPogressView.tag = 3;

    [tumblrPogressView.statusText setText:@""];
    [tumblrPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_tumblr"] forState:UIControlStateNormal];
    [tumblrPogressView.cancelIcon setHidden:YES];
    [tumblrPogressView.cancelIcon setImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
    [tumblrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [tumblrPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [tumblrPogressView.refreshIcon setHidden:YES];
    [tumblrPogressView.refreshIcon addTarget:self action:@selector(shareOnTumblr) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:tumblrPogressView];
    [self increaseProgressViewHeightBy:36];
}

-(void)showFlickrProgressRow{

    // Remove and Add if view already visible
    if(flickrPogressView){
        NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", flickrPogressView.tag], @"tag", nil];
        [flickrPogressView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:CloseShareProgressNotification object:nil userInfo:itemDetails];
    }

    flickrPogressView = nil;
    flickrPogressView = [[[[NSBundle mainBundle] loadNibNamed:@"ShareProgressView" owner:self options:nil] objectAtIndex:0] retain];
    [flickrPogressView setFrame:CGRectMake(flickrPogressView.frame.origin.x, 36 * countOfSharingNetworks++, flickrPogressView.frame.size.width, flickrPogressView.frame.size.height)];
    flickrPogressView.tag = 4;

    [flickrPogressView.statusText setText:@""];
    [flickrPogressView.networkIcon setBackgroundImage:[UIImage imageNamed:@"status_icon_flickr"] forState:UIControlStateNormal];
    [flickrPogressView.cancelIcon setHidden:YES];
    [flickrPogressView.cancelIcon setImage:[UIImage imageNamed:@"share_status_close"] forState:UIControlStateNormal];
    [flickrPogressView.statusIcon setBackgroundImage:nil forState:UIControlStateNormal];
    [flickrPogressView.refreshIcon setBackgroundImage:[UIImage imageNamed:@"retry_share"] forState:UIControlStateNormal];
    [flickrPogressView.refreshIcon setHidden:YES];
    [flickrPogressView.refreshIcon addTarget:self action:@selector(shareOnFlickr) forControlEvents:UIControlEventTouchUpInside];
    
    [progressView addSubview:flickrPogressView];
    [self increaseProgressViewHeightBy:36];
}

#pragma update state text and icons
-(void)fillErrorStatus:(ShareProgressView *)shareView{
    [shareView.statusText setText:@"Sharing Failed!"];
    [shareView.statusText setTextColor:[UIColor redColor]];
    [shareView.statusIcon setBackgroundImage:[UIImage imageNamed:@"status_failed"] forState:UIControlStateNormal];
    [shareView.refreshIcon setHidden:NO];
    [shareView.cancelIcon setHidden:NO];
}

-(void)fillSuccessStatus:(ShareProgressView *)shareView{
    [shareView.statusText setTextColor:[UIColor greenColor]];
    [shareView.statusText setText:@"Successfully Shared!"];
    [shareView.statusIcon setBackgroundImage:[UIImage imageNamed:@"status_success"] forState:UIControlStateNormal];
    [shareView.refreshIcon setHidden:YES];
    [shareView.cancelIcon setHidden:NO];
}

-(void)closeSharingProgressSuccess:(NSNotification *)notification{
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
    
    NSLog(@"TAG: %@", [notification.userInfo objectForKey:@"tag"]);
    // Set variables to null so that they will not come again
    if([[notification.userInfo objectForKey:@"tag"] isEqualToString:@"1"]){
        facebookPogressView = nil;
    } else if([[notification.userInfo objectForKey:@"tag"] isEqualToString:@"2"]){
        twitterPogressView = nil;
    } else if([[notification.userInfo objectForKey:@"tag"] isEqualToString:@"3"]){
        tumblrPogressView = nil;
    } else if([[notification.userInfo objectForKey:@"tag"] isEqualToString:@"4"]){
        flickrPogressView = nil;
    }
    
    if(countOfSharingNetworks <= 0){
        [self setDefaultProgressViewHeight];
        [progressView setHidden:YES];
    }
}

-(void)increaseProgressViewHeightBy:(int)height{
    [progressView setFrame:CGRectMake(progressView.frame.origin.x, progressView.frame.origin.y, progressView.frame.size.width, progressView.frame.size.height + height)];
    [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y + height, scrollView.frame.size.width, scrollView.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+ height)];
}

-(void)setDefaultProgressViewHeight{
    [progressView setFrame:CGRectMake(0, 46, 310, 3)];
    
    if(IS_IPHONE_5){
        [scrollView setFrame:CGRectMake(5, 50, 310, 548)];
        [scrollView setContentSize:CGSizeMake(310, 548)];
    }else{
        [scrollView setFrame:CGRectMake(5, 50, 310, 401)];
        [scrollView setContentSize:CGSizeMake(310, 401)];
    }
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
        [appDelegate setAndStoreFlickrAuthToken:nil secret:nil];
    }

    // if there's already OAuthToken, we want to reauthorize
    //if ([appDelegate.flickrContext.OAuthToken length]) {
    //    [appDelegate.flickrContext  setAuthToken:nil];
    //}
    
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
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
    
    // Remove loading view
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }

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

-(IBAction)searchNearByLocations{

    NSLog(@"Search Near By Locations");
    
    LocationController *locationController = [[LocationController alloc]initWithNibName:@"LocationController" bundle:nil];
    
	[self.navigationController pushViewController:locationController animated:YES];

}

- (void)postDismissCleanup {
	//[navBar removeFromSuperview];
	//[navBar release];
    
    
}

- (void)dismissNavBar:(BOOL)animated {
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		//navBar.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self dismissNavBar:YES];
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    // If text changed then save it again

    if(
       (![selectedFlyerTitle isEqualToString:titleView.text] && ![titleView.text isEqualToString:NameYourFlyerText])
       
       ||
       
       (![selectedFlyerDescription isEqualToString:descriptionView.text]  && ![descriptionView.text isEqualToString:AddCaptionText])){
        
        [self updateFlyerDetail];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [flickrPogressView release], flickrPogressView = nil;
    [facebookPogressView release], facebookPogressView = nil;
    [twitterPogressView release], twitterPogressView = nil;
    [tumblrPogressView release], tumblrPogressView = nil;
    [progressView release]; progressView = nil;
	[svController release];
    [super dealloc];
}

@end
