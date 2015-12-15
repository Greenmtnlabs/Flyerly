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
@synthesize btnNext, lblMessage1, lblMessage2;
@synthesize isComingFromSettings;

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
    
    [btnNext setTitle: NSLocalizedString(@"next ", nil) forState: UIControlStateNormal];
    self.lblMessage1.text = NSLocalizedString(@"Select 'Untech Now' using your pre-selected settings (what you'll be doing, who to inform & for how long).", nil);
    self.lblMessage2.text = NSLocalizedString(@"Select 'Untech Custom' to manually choose what you'll be doing during your untechable peroid of time & who you'd like to inform.", nil);
    
}

- (IBAction)onClickNext:(id)sender {
    
    HowToScreenThreeViewController *howToScreenThreeViewController = [[HowToScreenThreeViewController alloc] initWithNibName:@"HowToScreenThreeViewController" bundle:nil];
    howToScreenThreeViewController.untechable = untechable;
    howToScreenThreeViewController.isComingFromSettings = isComingFromSettings;
    [self.navigationController pushViewController:howToScreenThreeViewController animated:YES];
    
}
@end
