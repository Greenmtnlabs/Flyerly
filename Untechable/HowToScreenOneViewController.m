//
//  HowToScreenOneViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenOneViewController.h"
#import "HowToScreenTwoViewController.h"

@interface HowToScreenOneViewController ()

@end

@implementation HowToScreenOneViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickNext:(id)sender {
    
    HowToScreenTwoViewController *howToScreenTwoViewController = [[HowToScreenTwoViewController alloc] initWithNibName:@"HowToScreenTwoViewController" bundle:nil];
    howToScreenTwoViewController.untechable = untechable;
    [self.navigationController pushViewController:howToScreenTwoViewController animated:YES];
    
}
@end
