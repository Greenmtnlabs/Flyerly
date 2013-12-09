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
    UIViewController *parentViewController;
    int flyerNumber;
}

@property(nonatomic,strong) IBOutlet UIImageView *flyerOverlayImage;
@property(nonatomic,strong) IBOutlet UIButton *editButton;
@property(nonatomic,strong) IBOutlet UIButton *crossButton;
@property(nonatomic,strong) IBOutlet UIView *overlayRoundedView;
@property int flyerNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)image modalView:(UIView *)modalView;
-(void)setViews:(UIViewController *)controller;
-(IBAction)goBack;
-(IBAction)onEdit:(id)sender;
+(void)openFlyerInEditableMode:(int)flyerNumber parentViewController:(UIViewController *)parentViewController;

@end
