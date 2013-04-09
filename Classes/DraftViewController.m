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
@implementation DraftViewController

@synthesize selectedFlyerImage,imgView,navBar,fvController,svController;

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
	svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = selectedFlyerImage;
	svController.isDraftView = YES;
	svController.dvController =self;
	//svController.ptController = self;
	
	//self.navigationItem.title = @"Social Flyer";
	self.navigationController.navigationBarHidden = YES;
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[UIView commitAnimations];
	imgView = [[UIImageView alloc]initWithImage:selectedFlyerImage];
	[self.view addSubview:imgView];
	

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
