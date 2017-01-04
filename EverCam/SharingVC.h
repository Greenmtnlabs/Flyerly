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
@import GoogleMobileAds;
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
MFMailComposeViewControllerDelegate,
UIAlertViewDelegate,
GADInterstitialDelegate
>

// Labels
@property (weak, nonatomic) IBOutlet UILabel *sharingOptionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoLibraryLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
// Preview Image
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

// Container ScrollView
@property (strong, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (nonatomic) BOOL isForInstagram;
@property (nonatomic) BOOL isForWhatsApp;
@end
