/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "CameraViewController.h"
#import "HomeVC.h"
#import "SharingVC.h"
#import "IAPController.h"


UIImage *passedImage;

UIDocumentInteractionController *docInteraction;
SLComposeViewController *Socialcontroller;
UILocalNotification *localNotification;

UIImage *croppedImageWithoutOrientation;



@interface PreviewVC : UIViewController
<
UIPopoverControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITabBarDelegate,
UIActionSheetDelegate,
UIScrollViewDelegate,
UIDocumentInteractionControllerDelegate
>

// Views ==============
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *_imageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
