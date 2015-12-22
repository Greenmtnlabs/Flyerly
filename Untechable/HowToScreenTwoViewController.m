//
//  HowToScreenTwoViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenTwoViewController.h"
#import "HowToScreenThreeViewController.h"


@interface HowToScreenTwoViewController ()<UIGestureRecognizerDelegate> {
}

@end

@implementation HowToScreenTwoViewController{
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    
}

@synthesize  untechable;
@synthesize btnNext, lblMessage1, lblMessage2;
@synthesize isComingFromSettings;
@synthesize imgHowTo;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [self.navigationController popViewControllerAnimated:YES];
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
    self.lblMessage1.text = NSLocalizedString(@"Select 'Untech Now' using your pre-selected settings (what you'll be doing, who to inform & for how long).", nil);
    self.lblMessage2.text = NSLocalizedString(@"Select 'Untech Custom' to manually choose what you'll be doing during your untechable period of time & who you'd like to inform.", nil);
    
}

/*
 * Navigates to next screen
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) goToNextScreen{
    HowToScreenThreeViewController *howToScreenThreeViewController = [[HowToScreenThreeViewController alloc] initWithNibName:@"HowToScreenThreeViewController" bundle:nil];
    howToScreenThreeViewController.untechable = untechable;
    howToScreenThreeViewController.isComingFromSettings = isComingFromSettings;
    [self.navigationController pushViewController:howToScreenThreeViewController animated:YES];
}

- (IBAction)onClickNext:(id)sender {
    [self goToNextScreen];
}
@end
