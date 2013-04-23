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

@implementation LauchViewController

@synthesize ptController,spController,tpController,createFlyrLabel,savedFlyrLabel,inviteFriendLabel,addFriendsController;
@synthesize firstFlyer, secondFlyer, thirdFlyer, fourthFlyer;
@synthesize loadingView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
    }
    return self;
}

// Load Create Flyr Method With Thread
 -(void)loadPhotoView{
	loadingViewFlag = YES;
	ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil];
	[self.navigationController pushViewController:ptController animated:YES];
	[ptController release];
}

-(IBAction)doNew:(id)sender{
	loadingView =[LoadingView loadingViewInView:self.view];
	[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(loadPhotoView) userInfo:nil repeats:NO];
}
//End


// Load View Flyr Method With Thread
-(void)loadFlyerView{
	loadingViewFlag = YES;
	tpController = [[FlyrViewController alloc]initWithNibName:@"FlyrViewController" bundle:nil];
	[self.navigationController pushViewController:tpController animated:YES];
	[tpController release];
}

-(IBAction)doOpen:(id)sender{
	loadingView =[LoadingView loadingViewInView:self.view];
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

    // Set the background image on navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_with_logo"] forBarMetrics:UIBarMetricsDefault];
    
    // Create right bar button
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
    [menuButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];

    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    
    
    loadingViewFlag = NO;
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
    [helpButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    
    NSMutableArray *leftItems = [NSMutableArray arrayWithObjects:spaceBarButton,leftBarButton,nil];
    
    return leftItems;
}

- (void)viewDidLoad {
         [super viewDidLoad];
	//self.navigationItem.title = @"Menu";
	loadingViewFlag = NO;
	loadingView = nil;
	loadingView = [[LoadingView alloc]init];
    
    [createFlyrLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [createFlyrLabel setText:NSLocalizedString(@"create_flyer", nil)];
    
    [savedFlyrLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [savedFlyrLabel setText:NSLocalizedString(@"saved_flyers", nil)];

    [inviteFriendLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    [inviteFriendLabel setText:NSLocalizedString(@"invite_friends", nil)];

    spController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
	//[spController initSession];
    
    //get facebook app id
    /*NSString *path = [[NSBundle mainBundle] pathForResource: @"Flyr-Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    id obj = [dict objectForKey: @"FacebookAppID"];

    //initialize facebook
	FlyrAppDelegate *appDele = (FlyrAppDelegate*)[[UIApplication sharedApplication]delegate];
    appDele.facebook = [[Facebook alloc] initWithAppId:obj andDelegate:self];
     */
	[self filesByModDate];
}

-(void)filesByModDate
{
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *unexpandedPath = [homeDirectoryPath stringByAppendingString:@"/Documents/Flyr/"];
	NSString *folderPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSString stringWithString:[unexpandedPath stringByExpandingTildeInPath]], nil]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
	NSString *finalImagePath;
	//NSArray* sortedFiles;
    
	for(int i =0;i< [files count];i++)
	{
		NSString *img = [files objectAtIndex:i];
		img = [@"/" stringByAppendingString:img];
		finalImagePath= [folderPath stringByAppendingString:img];
        
        //NSString *imageName = [photoArray objectAtIndex:0];
        NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:finalImagePath];
        UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
        
        CGSize size = CGSizeMake(108, 99);

        if(i == 0){
            firstFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
        } else if(i  == 1){
            //secondFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
        } else if(i  == 2){
            thirdFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
        } else if(i  == 3){
            fourthFlyer.image = [LauchViewController imageWithImage:currentFlyerImage scaledToSize:size];
        }
	}

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
	if(loadingViewFlag)
	{
		[loadingView removeFromSuperview];
		loadingViewFlag=NO;
	}
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

#pragma mark Dealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[spController release];

    [super dealloc];
}


@end
