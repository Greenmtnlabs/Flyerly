//
//  HowToScreenOneViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenOneViewController.h"
#import "HowToScreenTwoViewController.h"

@interface HowToScreenOneViewController ()<UIGestureRecognizerDelegate> {
}

@end

@implementation HowToScreenOneViewController{

UISwipeGestureRecognizer *swipeLeft;
UISwipeGestureRecognizer *swipeRight;

}

@synthesize untechable;
@synthesize btnNext, lblMessage1, lblMessage2;
@synthesize isComingFromSettings;
@synthesize imgHowTo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // to apply localization
    [self applyLocalization];
    
    [imgHowTo setUserInteractionEnabled:YES];
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [imgHowTo addGestureRecognizer:swipeLeft];
    [imgHowTo addGestureRecognizer:swipeRight];
}

-(void)viewWillAppear:(BOOL)animated{
    //hide navigation bar
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * Hook swipe functions
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    //Dont go beside first slide
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [self goToNextScreen];
    }
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

/*
 * Navigates to next screen
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) goToNextScreen{
    HowToScreenTwoViewController *howToScreenTwoViewController = [[HowToScreenTwoViewController alloc] initWithNibName:@"HowToScreenTwoViewController" bundle:nil];
    howToScreenTwoViewController.untechable = untechable;
    howToScreenTwoViewController.isComingFromSettings = isComingFromSettings;
    [self.navigationController pushViewController:howToScreenTwoViewController animated:YES];
}

- (IBAction)onClickNext:(id)sender {
    [self goToNextScreen];
}
@end
