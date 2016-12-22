//
//  SettingsVC.m
// EverCam
//
//  Created by MacBook FV iMAGINATION on 08/05/15.
//  Copyright (c) 2015 FV iMAGINATION. All rights reserved.
//

#import "SettingsVC.h"
#import "AboutVC.h"


@interface SettingsVC ()
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set Localized text
    _titleLabel.text = NSLocalizedString(@"Settings", @"");
    _saveOriginalLabel.text = NSLocalizedString(@"Save Original Photo", @"");
    _saveToCustomAlbumLabel.text = NSLocalizedString(@"Save to EverCam Album", @"");
    _rateUsLabel.text = NSLocalizedString(@"Rate Us", @"");
    _tellAfriendLabel.text = NSLocalizedString(@"Tell A Friend", @"");
    _sendFeedbackLabel.text = NSLocalizedString(@"Send feedback", @"");
    _aboutLabel.text = NSLocalizedString(@"About", @"");
    _likeUsonFBLabel.text = NSLocalizedString(@"Like Us on Facebook", @"");
    self.bannerView.adUnitID = ADMOB_BANNER_ID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[self request]];
    
    // Set the swtches accordingly to saved choices
    saveOriginalPhoto = [[NSUserDefaults standardUserDefaults] boolForKey:@"saveOriginalPhoto"];
    saveToCustomAlbum = [[NSUserDefaults standardUserDefaults] boolForKey:@"saveToCustomAlbum"];
    if (saveOriginalPhoto) { [_originalPhotoSwitch setOn:true];
    } else {  [_originalPhotoSwitch setOn:false];  }
    
    if (saveToCustomAlbum) {  [_customAlbumSwitch setOn:true];
    } else {  [_customAlbumSwitch setOn:false];  }
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            //NSString *udid = [UIDevice currentDevice].uniqueIdentifier;
                            @"Simulator",
                            @"da40d7ada5c1c5994184c744d0a21b81"
                            ];
    return request;
}
- (IBAction)saveOriginalChanged:(UISwitch *)sender {
    if (sender.isOn) {
        saveOriginalPhoto = true;
    } else {
        saveOriginalPhoto = false;
    }
    // Save choice
    [[NSUserDefaults standardUserDefaults] setBool:saveOriginalPhoto forKey:@"saveOriginalPhoto"];
    //[[NSUserDefaults standardUserDefaults]synchronize];

}


- (IBAction)saveToCustomAlbum:(UISwitch *)sender {
    if (sender.isOn) {
        saveToCustomAlbum = true;
    } else {
        saveToCustomAlbum = false;
    }
    // Save choice
    [[NSUserDefaults standardUserDefaults] setBool:saveToCustomAlbum forKey:@"saveToCustomAlbum"];
   // [[NSUserDefaults standardUserDefaults]synchronize];

}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 2:  // RATE US
            feedback = false;
            [[UIApplication sharedApplication] openURL:[NSURL
            URLWithString: RATE_US_LINK]];
            break;
        
        case 3:{ // TELL A FRIEND
            feedback = false;
            NSString *title = APP_NAME;
            NSString *string1 = NSLocalizedString(@"I really enjoy this app. It makes me feel like a professional photographer, I think you may love it! Check it out: ", @"");
            NSString *message = [NSString stringWithFormat:@"%@ %@", string1, ITUNES_STORE_LINK];
            [self sendMailWithTitle:title andMessage: message];
            break; }
            
        case 4:{ // SEND FEEDBACK
            feedback = true;
            NSString *title = NSLocalizedString(@"Send feedback", @"");
            NSString *message = NSLocalizedString(@"Please describe  your issues/suggestions below:", @"");
            [self sendMailWithTitle:title andMessage: message];
            break; }
         
        case 6:{ // LIKE ON FACEBOOK
            feedback = false;
            [[UIApplication sharedApplication] openURL:[NSURL
            URLWithString: FACEBOOK_PAGE_LINK]];
            break; }
            
            
        default: break;
    }
}



-(void)sendMailWithTitle:(NSString *)title andMessage: (NSString *)message  {

    // Allocs the Mail composer controller
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:title];
    [mc setMessageBody:message isHTML:true];
    if (feedback) {
    NSArray *feedbackEmail = @[FEEDBACK_EMAIL_ADDRESS];
    [mc setToRecipients:feedbackEmail];
    }
    
    // Prepare the app Logo to be shared by Email
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo"]);
    [mc addAttachmentData:imageData  mimeType:@"image/png" fileName:@"logo.png"];
    
    [self presentViewController:mc animated:true completion:nil];
}


// Email delegates ================
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)results error:(NSError *)error {
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




#pragma mark - DISMISS BUTTON =====================
- (IBAction)dismissButt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
