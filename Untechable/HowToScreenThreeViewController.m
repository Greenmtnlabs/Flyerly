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
@synthesize lblMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // to apply localization
    [self applyLocalization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * This method applies localization
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) applyLocalization{
    self.lblMessage.text = NSLocalizedString(@"Once you've completed your Untech selection, go enjoy your time away from technology. Untech & reconnect with life. Don't forget to invite others to untech so thay can do the same. Namaste!", nil);
}

- (IBAction)onClickDone:(id)sender {
    
    // Load SetupGuideViewController
    SetupGuideViewController *setupGuideViewController = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    setupGuideViewController.untechable = untechable;
    [self.navigationController pushViewController:setupGuideViewController animated:YES];

}
@end
