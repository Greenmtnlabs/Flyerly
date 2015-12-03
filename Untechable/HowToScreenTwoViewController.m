//
//  HowToScreenTwoViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenTwoViewController.h"
#import "HowToScreenThreeViewController.h"


@interface HowToScreenTwoViewController ()

@end

@implementation HowToScreenTwoViewController

@synthesize  untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickNext:(id)sender {
    
    HowToScreenThreeViewController *howToScreenThreeViewController = [[HowToScreenThreeViewController alloc] initWithNibName:@"HowToScreenThreeViewController" bundle:nil];
    howToScreenThreeViewController.untechable = untechable;
    [self.navigationController pushViewController:howToScreenThreeViewController animated:YES];
    
}
@end
