/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "SharingVC.h"
#import <Social/Social.h>
#import "SettingsVC.h"
#import "Configs.h"


@interface SharingVC ()

@end



@implementation SharingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)prefersStatusBarHidden {
    return true;
}
// Prevent the StatusBar from showing up after picking an image
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:true];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Gets the image from previous MainScreen =======
    _previewImage.image = imageToBeShared;

    // Init the device Assets Library
    library = [[ALAssetsLibrary alloc] init];

    
    // Setup Localized text
    _photoLibraryLabel.text = NSLocalizedString(@"Photo Library", @"");
    _sharingOptionsLabel.text = NSLocalizedString(@"Share Your Picture", @"");
    _mailLabel.text = NSLocalizedString(@"Mail", @"");
    
    // Resize container scrollView
    _containerScrollView.contentSize = CGSizeMake(_containerScrollView.frame.size.width, 578);
}

-(void)viewDidDisappear:(BOOL)animated {
    library = nil;
}




#pragma mark - CANCEL BUTTON ============================
- (IBAction)cancelButt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}




#pragma mark - SAVE IMAGE TO PHOTO LIBRARY ========================
- (IBAction)photoLibButt:(id)sender {
    
    // Save to Photo Library
    if (!saveToCustomAlbum) {
    UIImageWriteToSavedPhotosAlbum(imageToBeShared, nil, nil, nil);
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle: APP_NAME
    message: NSLocalizedString(@"Your Picture has been saved into Photo Library!", @"")
    delegate: nil
    cancelButtonTitle: NSLocalizedString(@"OK", @"")
    otherButtonTitles:nil];
    [myAlert show];
    
    
    // Save Photo to Custom album
    } else {
        [library saveImage:imageToBeShared toAlbum: APP_NAME withCompletionBlock:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", [error description]);
        } else {
            NSString *string1  = NSLocalizedString(@"You picture has been saved into ", @"");
            NSString *string2 = NSLocalizedString(@" Album", @"");
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle: APP_NAME
            message: [NSString stringWithFormat:@"%@ %@ %@", string1, APP_NAME, string2]
            delegate: nil
            cancelButtonTitle: NSLocalizedString(@"OK", @"")
            otherButtonTitles:nil];
            [myAlert show];
        }
    }];
    }
    
}





#pragma mark - FACEBOOK SHARING ========================
- (IBAction)facebookButt:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        Socialcontroller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [Socialcontroller setInitialText: NSLocalizedString(SHARING_MESSAGE, @"")];
        [Socialcontroller addImage: imageToBeShared];
        [self presentViewController:Socialcontroller animated:true completion:nil];
        
    } else {
        
        NSString *message = NSLocalizedString(FACEBOOK_LOGIN_ALERT, @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: APP_NAME
        message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = NSLocalizedString(@"Sharing Cancelled!", @"");
                break;
            case SLComposeViewControllerResultDone:
                output = NSLocalizedString(@"Your picture is on Facebook!", @"");
                break;
                
            default: break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
        message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
}





#pragma mark - TWITTER SHARING ========================
- (IBAction)twitterButt:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        Socialcontroller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [Socialcontroller setInitialText: NSLocalizedString(SHARING_MESSAGE, @"")];
        [Socialcontroller addImage: imageToBeShared];
        [self presentViewController:Socialcontroller animated:true completion:nil];
        
    } else {
        NSString *message = NSLocalizedString(TWITTER_LOGIN_ALERT, @"");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: APP_NAME
        message:message delegate:nil
        cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = NSLocalizedString(@"Sharing Cancelled!", @"");
                break;
            case SLComposeViewControllerResultDone:
                output = NSLocalizedString(@"Your picture is on Twitter!", @"");
                break;
                
            default: break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
        message:output delegate:nil
        cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];
}



#pragma mark - EMAIL SHARING ==============================
- (IBAction)mailButt:(id)sender {
    NSString *emailTitle = NSLocalizedString(SHARING_TITLE, @"");
    NSString *messageBody = NSLocalizedString(SHARING_MESSAGE, @"");
    
    // Allocs the Mail composer controller
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML: true];
    
    // Prepares the image to be shared by Email
    NSData *imageData = UIImagePNGRepresentation(imageToBeShared);
    [mc addAttachmentData:imageData  mimeType:@"image/png" fileName:@"myImage.png"];
    
    // Presents Email View Controller
    [self presentViewController:mc animated:true completion: nil];
}

// Email delegates ================
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)results error:(NSError *)error  {
    switch (results) {
        case MFMailComposeResultCancelled: {
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"Email Cancelled!", @"")
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSaved:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Email Saved!", @"")
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSent:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"Email Sent!", @"")
            message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultFailed:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"Email error, try again!", @"")
                message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
            
        default: break;
    }
    // Dismiss the Email View Controller
    [self dismissViewControllerAnimated:true completion: nil];
}




#pragma mark - INSTAGRAM SHARING =====================
- (IBAction)instagramButt:(id)sender {
    /* =================
     NOTE: The following methods work only on real device, not iOS Simulator, and you should have Instagram already installed into your device!
     ================= */
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        docInteraction.delegate = self;
        
        //Save the edited Image to directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
        UIImage *image = imageToBeShared;
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:false];
        
        //Load the edited Image
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
        UIImage *tempImage = [UIImage imageWithContentsOfFile:getImagePath];
        
        //Hook the edited Image with Instagram
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.igo"];
        [UIImageJPEGRepresentation(tempImage, 1.0) writeToFile:jpgPath atomically:true];
        
        // Prepare the DocumentInteraction with the .igo image for Instagram
        NSURL *instagramImageURL = [[NSURL alloc] initFileURLWithPath:jpgPath];
        docInteraction = [UIDocumentInteractionController interactionControllerWithURL:instagramImageURL];
        [docInteraction setUTI:@"com.instagram.exclusivegram"];
      
        // Open the DocumentInteraction Menu
        [docInteraction presentOpenInMenuFromRect:CGRectZero inView: self.view animated:true];
        
    } else {
    // Open an AlertView as sharing result when the Document Interaction Controller gets dismissed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Instagram not found", @"")
    message: NSLocalizedString(@"Please install Instagram on your device!", @"") delegate:nil
    cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    }
}




#pragma mark - PIQUK SHARING =====================
- (IBAction)piqukButt:(id)sender {
        
    NSURL *piqukURL = [NSURL URLWithString:@"piquk://app"];
    if ([[UIApplication sharedApplication] canOpenURL: piqukURL]) {
        
        docInteraction.delegate = self;
        
        //Save the edited Image to directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
        UIImage *image = imageToBeShared;
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:false];
        
        //Load the edited Image
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.jpg"];
        UIImage *tempImage = [UIImage imageWithContentsOfFile:getImagePath];
        
        //Hook the edited Image with Instagram
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.pqi"];
        [UIImageJPEGRepresentation(tempImage, 1.0) writeToFile:jpgPath atomically:true];
        
        // Prepare the DocumentInteraction with the .igo image for Instagram
        NSURL *instagramImageURL = [[NSURL alloc] initFileURLWithPath:jpgPath];
        docInteraction = [UIDocumentInteractionController interactionControllerWithURL:instagramImageURL];
        [docInteraction setUTI:@"com.piquk.image.pqi"];
        
        // Open the DocumentInteraction Menu
        [docInteraction presentOpenInMenuFromRect:CGRectZero inView: self.view animated:true];
        
    } else {
        // Open an AlertView as sharing result when the Document Interaction Controller gets dismissed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"PIQUK not found", @"")
        message: NSLocalizedString(@"Please install PIQUK on your device!", @"") delegate:nil
        cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}




#pragma mark - SEND IMAGE VIA WHATSAPP =====================
- (IBAction)whatsappButt:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]) {
        
    NSString *savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.wai"];
            
    [UIImageJPEGRepresentation(imageToBeShared, 1.0) writeToFile:savePath atomically:true];
            
    docInteraction = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
    docInteraction.UTI = @"net.whatsapp.image";
    docInteraction.delegate = self;
            
    [docInteraction presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: true];
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"WhatsApp not found", @"")
        message: NSLocalizedString(@"Please install WhatsApp on your device!", @"") delegate:self
        cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
