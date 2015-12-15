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
@synthesize btnBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    countSwipe = 1;
    
    imgsArray = [NSArray arrayWithObjects:@"introScreen1.jpg", @"introScreen2.jpg", @"introScreen3.jpg", @"introScreen4.jpg",nil];
    imageView.image = [UIImage imageNamed:imgsArray[0]];
    
    [self.view bringSubviewToFront:_btnHideMe];
    //[self.view bringSubviewToFront:_btnSignIn];
    
    _btnSignIn.enabled = NO;
    //Remove signin button if user already logged in
    if ([[PFUser currentUser] sessionToken].length != 0) {
        [_btnSignIn removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    btnBack.enabled = YES;
    
    NSString *imageName;
    
    if(countSwipe == 1){
        btnBack.enabled = NO;
        imageName = imgsArray[0];
    } else if (countSwipe == 2) {
        imageName = imgsArray[1];
    } else if (countSwipe == 3){
        imageName = imgsArray[2];
    } else if(countSwipe == 4){
        imageName = imgsArray[3];
    } else if(countSwipe > 4){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([direction isEqualToString:@"right"] ) {
        imageView.image = [UIImage imageNamed:imageName];
        [self performAnimation:@"LEFT"];
    }
    else if ([direction isEqualToString:@"left"] ) {
        imageView.image = [UIImage imageNamed:imageName];
        [self performAnimation:@"RIGHT"];
    }

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
