//
//  HowToScreenThreeViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenThreeViewController.h"
#import "SetupGuideViewController.h"

@interface HowToScreenThreeViewController ()

@end

@implementation HowToScreenThreeViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickDone:(id)sender {
    
    // Load SetupGuideViewController
    SetupGuideViewController *setupGuideViewController = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    setupGuideViewController.untechable = untechable;
    [self.navigationController pushViewController:setupGuideViewController animated:YES];

}
@end
