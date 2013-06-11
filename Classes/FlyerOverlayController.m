//
//  FlyerOverlayController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/10/13.
//
//

#import "FlyerOverlayController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlyerOverlayController
@synthesize flyerOverlayImage,editButton,crossButton,overlayRoundedView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)image modalView:(UIView *)modalView{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tempImage = image;
        tempModalView = modalView;
    }
    return self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set flyer image
    self.flyerOverlayImage.image = tempImage;

    // Add rounded border to flyer view
    CALayer * l = [overlayRoundedView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:7];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
}

-(IBAction)goBack{
    // Remove views from superview
    [self.view removeFromSuperview];
    [tempModalView removeFromSuperview];
    
    // Set alpha back to 1
    parentViewController.navigationController.navigationBar.alpha = 1;
}

-(void)setViews:(FlyrViewController *)controller{
    parentViewController = controller;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [flyerOverlayImage release];
    [crossButton release];
    [editButton release];
    [overlayRoundedView release];
    
    [super dealloc];
}
@end
