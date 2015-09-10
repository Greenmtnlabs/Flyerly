//
//  IntroScreenViewController.m
//  Flyr
//
//  Created by rufi on 09/09/2015.
//
//

#import "IntroScreenViewController.h"
#import "InAppViewController.h"
#import "FlyerlyMainScreen.h"

@interface IntroScreenViewController () <UIGestureRecognizerDelegate> {
}

@property (nonatomic, assign) BOOL showPanel;

@end

@implementation IntroScreenViewController{
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    int countSwipe;

}

@synthesize imageView;
@synthesize buttonDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    countSwipe = 1;
    imageView.image = [UIImage imageNamed:@"one.jpeg"];
    [imageView setUserInteractionEnabled:YES];
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [imageView addGestureRecognizer:swipeLeft];
    [imageView addGestureRecognizer:swipeRight];
    

    
}

-(void)performAnimation:(NSString *)direction {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    
    if([direction isEqualToString:@"LEFT"]){
         [animation setSubtype:kCATransitionFromRight];
    }
    if([direction isEqualToString:@"RIGHT"]){
         [animation setSubtype:kCATransitionFromLeft];
    }
   
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"abc"];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    
    NSString *leftImage, *rightImage;
    
    if(countSwipe == 1){
        rightImage = @"two.jpeg";
        
    } else if (countSwipe == 2) {
        leftImage = @"one.jpeg";
        rightImage = @"three.jpg";
        
    } else if (countSwipe >= 3){
        leftImage = @"two.jpeg";
        
    }
    
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        imageView.image = [UIImage imageNamed:rightImage];
        [self performAnimation:@"LEFT"];
        countSwipe++;
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight && countSwipe > 1) {
        NSLog(@"Right Swipe");
        
        imageView.image = [UIImage imageNamed:leftImage];
        [self performAnimation:@"RIGHT"];
        countSwipe--;
    }
    

    
    if(countSwipe > 3){
        
        InAppViewController *inAppViewController = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
        inAppViewController.buttondelegate = self;
        [inAppViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:inAppViewController animated:YES];
        
//        
////        [self presentViewController:inAppViewController animated:YES completion:nil];
////        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
//        
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.3];
//        [animation setType:kCATransitionPush];
//        [animation setSubtype:kCATransitionFromLeft];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        //[[inAppViewController.view layer] addAnimation:animation forKey:@"abc"];
//        [self presentModalViewController:inAppViewController animated:NO];
        
        
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.3];
//        [animation setType:kCATransitionPush];
//        [animation setSubtype:kCATransitionFromLeft];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [[inAppViewController.view.superview layer] addAnimation:animation forKey:@"abc"];
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signIn:(id)sender {
    [self.buttonDelegate inAppPurchasePanelButtonTappedWasPressed:_btnSignIn.currentTitle];
}

- (IBAction)hideTray:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
