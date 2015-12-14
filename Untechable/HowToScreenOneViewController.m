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
@synthesize btnNext, lblMessage1, lblMessage2;
@synthesize isComingFromSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
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
    
    [btnNext setTitle: NSLocalizedString(@"next ", nil) forState: UIControlStateNormal];
    self.lblMessage1.text = NSLocalizedString(@"Setup your Untech account & settings to make taking a break from technology as easy as 1, 2, 3.", nil);
    self.lblMessage2.text = NSLocalizedString(@"Note: You can always adjust these in the settings screen.", nil);
    
}

- (IBAction)onClickNext:(id)sender {
    
    HowToScreenTwoViewController *howToScreenTwoViewController = [[HowToScreenTwoViewController alloc] initWithNibName:@"HowToScreenTwoViewController" bundle:nil];
    howToScreenTwoViewController.untechable = untechable;
    howToScreenTwoViewController.isComingFromSettings = isComingFromSettings;
    [self.navigationController pushViewController:howToScreenTwoViewController animated:YES];
    
}
@end
