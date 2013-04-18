//
//  AfterUpdateController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/18/13.
//
//

#import "AfterUpdateController.h"
#import "LauchViewController.h"

@implementation AfterUpdateController
@synthesize launchController;

-(void)viewDidLoad{
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)ok{
	launchController = [[LauchViewController alloc]initWithNibName:@"LauchViewController" bundle:nil];
	[self.navigationController pushViewController:launchController animated:YES];
	[launchController release];
}

@end
