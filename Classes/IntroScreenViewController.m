//
//  IntroScreenViewController.m
//  Flyr
//
//  Created by rufi on 09/09/2015.
//
//

#import "IntroScreenViewController.h"
#import "InAppViewController.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    countSwipe = 1;
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"one.jpeg"]];
    imageView.frame = CGRectMake(0, 0, 320, 548);
    [imageView setUserInteractionEnabled:YES];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [imageView addGestureRecognizer:swipeLeft];
    [imageView addGestureRecognizer:swipeRight];
    
    [self.view addSubview:imageView];
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    NSString *leftImage, *rightImage;
    CATransition *animation;
    
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
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rightImage]];
        imageView.frame = CGRectMake(0, 0, 320, 548);
        [imageView setUserInteractionEnabled:YES];
        animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        countSwipe++;
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImage]];
        imageView.frame = CGRectMake(0, 0, 320, 548);
        [imageView setUserInteractionEnabled:YES];
        animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        countSwipe--;
    }
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [imageView addGestureRecognizer:swipeLeft];
    [imageView addGestureRecognizer:swipeRight];
    
    if(countSwipe > 3){
        InAppViewController *inAppViewController = [[InAppViewController alloc]initWithNibName:@"InAppViewController" bundle:nil];
        [self.view addSubview:inAppViewController.view];
        
//        [self presentViewController:inAppViewController animated:YES completion:nil];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
//        
//        [inAppViewController requestProduct];
//        inAppViewController.buttondelegate = self;

    } else {
        [self.view addSubview:imageView];
    }
    
    
    [[self.view layer] addAnimation:animation forKey:@"abc"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
