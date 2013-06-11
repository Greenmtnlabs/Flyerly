//
//  FlyerOverlayController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/10/13.
//
//

#import <UIKit/UIKit.h>
#import "FlyrViewController.h"

@interface FlyerOverlayController : UIViewController{

    IBOutlet UIImageView *flyerOverlayImage;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *crossButton;
    IBOutlet UIView *overlayRoundedView;
    
    UIImage *tempImage;
    UIView *tempModalView;
    FlyrViewController *parentViewController;
}

@property(nonatomic,retain) IBOutlet UIImageView *flyerOverlayImage;
@property(nonatomic,retain) IBOutlet UIButton *editButton;
@property(nonatomic,retain) IBOutlet UIButton *crossButton;
@property(nonatomic,retain) IBOutlet UIView *overlayRoundedView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)image modalView:(UIView *)modalView;
-(IBAction)goBack;
-(void)setViews:(FlyrViewController *)controller;

@end
