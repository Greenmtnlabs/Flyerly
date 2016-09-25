/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <Social/Social.h>

// Photo library
ALAssetsLibrary *library;

// Document Interaction for dharing options
UIDocumentInteractionController *docInteraction;
// Social controller
SLComposeViewController *Socialcontroller;

// RestClient for Dropbox and Views for its layout
UIActivityIndicatorView *indicatorView;

// image that needs to be shared/saved
UIImage *imageToBeShared;




@interface SharingVC : UIViewController
<
UIDocumentInteractionControllerDelegate,
MFMailComposeViewControllerDelegate
>

// Labels
@property (weak, nonatomic) IBOutlet UILabel *sharingOptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoLibraryLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;


// Preview Image
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

// Container ScrollView
@property (strong, nonatomic) IBOutlet UIScrollView *containerScrollView;



@end
