//
//  IntroScreenViewController.m
//  Untechable
//
//  Created by rufi on 29/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "IntroScreenViewController.h"
#import "SetupGuideViewController.h"

@interface IntroScreenViewController ()

@end

@implementation IntroScreenViewController

@synthesize untechable;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickNext:(id)sender {
    
    SetupGuideViewController *setupGuideViewController = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    setupGuideViewController.untechable = untechable;
    [self.navigationController pushViewController:setupGuideViewController animated:YES];
    

}
@end
