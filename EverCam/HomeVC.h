/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
==============================*/


#import <UIKit/UIKit.h>
#import "PreviewVC.h"
#import "IAPController.h"
#import "Configs.h"
@import GoogleMobileAds;

@interface HomeVC : UIViewController <
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>


// LOGO
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;

// BUTTONS
@property (weak, nonatomic) IBOutlet UIButton *cameraOutlet;
@property (weak, nonatomic) IBOutlet UIButton *libraryOutlet;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

// LABELS
@property (weak, nonatomic) IBOutlet UILabel *takeApicLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickFromLibLabel;

@property (strong, nonatomic) IBOutlet UIImageView *bkgImage;

@end
