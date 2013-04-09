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
#import "LoadingView.h"
#import "FlyrAppDelegate.h"


@implementation LauchViewController

@synthesize ptController,spController,tpController;
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


#pragma mark View Appear 

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	loadingViewFlag = NO;
}

- (void)viewDidLoad {
         [super viewDidLoad];
	self.navigationItem.title = @"Menu";
	loadingViewFlag = NO;
	loadingView = nil;
	loadingView = [[LoadingView alloc]init];
	self.navigationController.navigationBarHidden = YES;
	spController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
	//[spController initSession];
}


#pragma mark View Disappear
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	self.navigationItem.title = @"Menu";
	self.navigationController.navigationBarHidden = YES;
	if(loadingViewFlag)
	{
		[loadingView removeFromSuperview];
		loadingViewFlag=NO;
	}
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
