/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "HomeVC.h"
#import "PreviewVC.h"
#import "IAPController.h"
#import "Configs.h"


@interface HomeVC()
@end



@implementation HomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}

// Hide Status Bar
- (BOOL)prefersStatusBarHidden {
    return true;
}
// Prevent the StatusBar from showing up after picking an image
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:true];
}



#pragma mark - VIEW DID LOAD ========================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load IAP made
    iapMade = [[NSUserDefaults standardUserDefaults]boolForKey:@"iapMade"];
    NSLog(@"IAP MADE: %d", iapMade);
    
    // Get a random background image
    NSInteger randomBkg = arc4random()%5;
    _bkgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"bkg%ld", (long)randomBkg]];
    
    // Localize text
    _takeApicLabel.text = NSLocalizedString(@"Take a Picture", @"");
    _pickFromLibLabel.text = NSLocalizedString(@"Choose from Library", @"");
    
    
    // Round the buttons corners
    _libraryOutlet.layer.cornerRadius = 20;
    _cameraOutlet.layer.cornerRadius = 20;
    _logoImage.layer.cornerRadius = 30;
}


- (IBAction)cameraButt:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraViewController *camVC = (CameraViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    [self presentViewController:camVC animated: true completion:nil];
}



#pragma mark - PHOTO LIBRARY BUTTON
- (IBAction)photoLibraryButt:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:true completion:nil];
}




#pragma mark - IMAGE PICKER DELEGATE
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:false completion:nil];

    // Go to the Main Screen
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PreviewVC *prevVC = (PreviewVC *)[storyboard instantiateViewControllerWithIdentifier:@"PreviewVC"];
        
        // Passing Image to Preview VC
        passedImage = image;
        
        prevVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:prevVC animated:true completion:nil];
    });
}



#pragma mark - SETTINGS BUTTON
- (IBAction)settingsButt:(id)sender {
    
}



#pragma mark - INSTAGRAM PAGE BUTTON
- (IBAction)instagramButt:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString: [NSString stringWithFormat:@"instagram://user?username=%@", INSTAGRAM_USERNAME]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://instagram.com/%@", INSTAGRAM_USERNAME]]];
    }
}



#pragma mark - STORE BUTTON
- (IBAction)storeButt:(id)sender {
    IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
    [self presentViewController: iapVC animated:true completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
