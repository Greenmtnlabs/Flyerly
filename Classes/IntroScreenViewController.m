//
//  IntroScreenViewController.m
//  Flyr
//
//  Created by rufi on 09/09/2015.
//
//

#import "IntroScreenViewController.h"
#import "FlyerlyMainScreen.h"

@interface IntroScreenViewController () <UIGestureRecognizerDelegate> {
}

@property (nonatomic, assign) BOOL showPanel;

@end

@implementation IntroScreenViewController{
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    int countSwipe;
    NSArray *imgsArray;

}

@synthesize imageView;
@synthesize buttonDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    countSwipe = 1;
    if( IS_IPHONE_4 ){
        imgsArray = [NSArray arrayWithObjects:@"intro-1-screen-iPhone4.png",@"intro-2-screen-iPhone4.png",@"intro-3-screen-iPhone4.png",nil];
    } else if( IS_IPHONE_5 ){
        imgsArray = [NSArray arrayWithObjects:@"intro-1-screen-iPhone5.png",@"intro-2-screen-iPhone5.png",@"intro-3-screen-iPhone5.png",nil];
    } else if( IS_IPHONE_6 ){
        imgsArray = [NSArray arrayWithObjects:@"intro-1-screen-iPhone6.png",@"intro-2-screen-iPhone6.png",@"intro-3-screen-iPhone6.png",nil];
    } else {
        imgsArray = [NSArray arrayWithObjects:@"intro-1-screen-iPhone6p.png",@"intro-2-screen-iPhone6p.png",@"intro-3-screen-iPhone6p.png",nil];
    }

    
    imageView.image = [UIImage imageNamed:imgsArray[0]];
    [imageView setUserInteractionEnabled:YES];
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [imageView addGestureRecognizer:swipeLeft];
    [imageView addGestureRecognizer:swipeRight];
    
    [self.view bringSubviewToFront:_btnHideMe];
    [self.view bringSubviewToFront:_btnSignIn];
    
    //Remove signin button if user already logged in
    if ([[PFUser currentUser] sessionToken].length != 0) {
        [_btnSignIn removeFromSuperview];
    }
    
}

/**
 * Perform animmation
 */
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


/**
 * Hook swipe functions
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    NSString *leftImage, *rightImage;
    
    if(countSwipe == 1){
        rightImage = imgsArray[1];
    } else if (countSwipe == 2) {
        leftImage = imgsArray[0];
        rightImage = imgsArray[2];
    } else if (countSwipe >= 3){
        leftImage = imgsArray[1];
    }
    
    //Dont go beside first slide
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight && countSwipe > 1) {
        imageView.image = [UIImage imageNamed:leftImage];
        [self performAnimation:@"RIGHT"];
        countSwipe--;
    }
    //Max is third slid
    else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft && countSwipe < 3) {
        imageView.image = [UIImage imageNamed:rightImage];
        [self performAnimation:@"LEFT"];
        countSwipe++;
    }
    //On forth slide
    else if(countSwipe >= 3 ){
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        //[self.buttonDelegate openPanel];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signIn:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.buttonDelegate inAppPurchasePanelButtonTappedWasPressed:_btnSignIn.currentTitle];
}

/**
 * Hide tray
 */
- (IBAction)hideTray:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
