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
    
    imgsArray = [NSArray arrayWithObjects:@"introScreen1.jpg", @"introScreen2.jpg", @"introScreen3.jpg", @"introScreen4.jpg",nil];
    
    imageView.image = [UIImage imageNamed:imgsArray[0]];
    
    return;
   
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

-(void)changeViews: (NSString *) direction{
    
    NSString *leftImage, *rightImage;
    
    if(countSwipe == 1){
        rightImage = imgsArray[0];
    } else if (countSwipe == 2) {
        leftImage = imgsArray[0];
        rightImage = imgsArray[1];
    } else if (countSwipe == 3){
        leftImage = imgsArray[1];
        rightImage = imgsArray[2];
    } else if(countSwipe == 4){
        leftImage = imgsArray[3];
    }
    
    if ([direction isEqualToString:@"right"] ) {
        
        if(countSwipe == 2){
            imageView.image = [UIImage imageNamed:rightImage];
        } else if(countSwipe == 3){
            imageView.image = [UIImage imageNamed:rightImage];
        }
        
        [self performAnimation:@"RIGHT"];
    }
//    else if ([direction isEqualToString:@"right"] && countSwipe == 3) {
//        
//        [self performAnimation:@"RIGHT"];
//    }
//    //On forth slide
//    else if(countSwipe >= 3 ){
//        //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        //[self.buttonDelegate openPanel];
//    }

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
    } else if (countSwipe == 3){
        leftImage = imgsArray[1];
        rightImage = imgsArray[3];
    } else if(countSwipe >= 4){
        leftImage = imgsArray[2];
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

- (IBAction)onClickBack:(id)sender {
    countSwipe--;
    [self changeViews:@"left"];
}

- (IBAction)onClickNext:(id)sender {
    countSwipe++;
    [self changeViews:@"right"];
}
@end
