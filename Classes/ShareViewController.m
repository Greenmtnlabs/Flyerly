//
//  DraftViewController.m
//  Flyr
//
//  Created by Krunal on 10/24/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "ShareViewController.h"
#import "FlyrViewController.h"
#import "SaveFlyerController.h"
#import "Common.h"
#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "InviteFriendsController.h"
#import "Flurry.h"
#import "HelpController.h"
#import <Parse/PFFile.h>
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>


@implementation ShareViewController


@synthesize selectedFlyerImage,imgView,fvController,svController,titleView,descriptionView,selectedFlyerDescription,selectedFlyerTitle, detailFileName, imageFileName,flickrButton,facebookButton,twitterButton,instagramButton,tumblrButton,clipboardButton,emailButton,smsButton,loadingView,dic,scrollView, saveToCameraRollLabel, saveToRollSwitch,locationBackground,locationLabel,networkParentView,locationButton,listOfPlaces,clipboardlabel,sharelink,bitly;

-(void)callFlyrView{
	[self.navigationController popToViewController:fvController animated:YES];
}

-(void)loadDistributeView {
	svController.isDraftView = YES;
	[self.navigationController pushViewController:svController animated:YES];
}

/*
 * pop to root view
 */
-(IBAction)goback{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
    globle = [FlyerlySingleton RetrieveSingleton];
    globle.NBUimage = nil;
    showbars = YES;
    
    // Set click event on switch
    [saveToRollSwitch addTarget:self action:@selector(setSwitchState:) forControlEvents:UIControlEventValueChanged];
    
    // Set facebook as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"facebookSetting"]){
        [facebookButton setSelected:YES];
    }else{
        [facebookButton setSelected:NO];
    }
    
    // Set twitter as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"twitterSetting"]){
        [twitterButton setSelected:YES];
    }else{
        [twitterButton setSelected:NO];
    }
    
    // Set instagram as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"instagramSetting"]){
        [instagramButton setSelected:YES];
    }else{
        [instagramButton setSelected:NO];
    }

    // Set email as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"emailSetting"]){
        [emailButton setSelected:YES];
    }else{
        [emailButton setSelected:NO];
    }

    // Set sms as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"smsSetting"]){
        [smsButton setSelected:YES];
    }else{
        [smsButton setSelected:NO];
    }

    // Set clip as per settings
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"clipSetting"]){
        [clipboardButton setSelected:YES];
        [clipboardlabel setTextColor:[globle colorWithHexString:@"3caaff"]];
    }else{
        [clipboardButton setSelected:NO];
        [clipboardlabel setTextColor:[UIColor whiteColor] ];
    }

    // Set tumblr as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"tumblrSetting"]){
        [tumblrButton setSelected:YES];
    }else{
        [tumblrButton setSelected:NO];
    }

    // Set flickr as per settings
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"flickrSetting"]){
        [flickrButton setSelected:YES];
    }else{
        [flickrButton setSelected:NO];
    }

	svController = [[SaveFlyerController alloc]initWithNibName:@"SaveFlyerController" bundle:nil];
	svController.flyrImg = selectedFlyerImage;
	svController.isDraftView = YES;
	svController.dvController =self;
	self.navigationController.navigationBarHidden = NO;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    helpButton.showsTouchWhenHighlighted = YES;
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *leftHelpBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,leftHelpBarButton,nil]];


    // Set title on bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHARE";
    self.navigationItem.titleView = label;
    
    // Set font and size on camera roll text
    [locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];


	[UIView commitAnimations];
	[imgView setImage:selectedFlyerImage forState:UIControlStateNormal];

    NSString *flyerNumber = [FlyrViewController getFlyerNumberFromPath:imageFileName];
    self.imgView.tag = [flyerNumber intValue];
    
    // Setup title text field
    [titleView setReturnKeyType:UIReturnKeyDone];
    [titleView addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    [titleView addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    //[titleView setFont:[UIFont fontWithName:@"Signika-Semibold" size:13]];
    if([selectedFlyerTitle isEqualToString:@""]){
        [titleView setText:NameYourFlyerText];
    }else{
        [titleView setText:selectedFlyerTitle];}
    
    // Setup description text view
    [descriptionView setFont:[UIFont fontWithName:OTHER_FONT size:10]];
    [descriptionView setTextColor:[UIColor grayColor]];
    [descriptionView setReturnKeyType:UIReturnKeyDone];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [descriptionView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    if([selectedFlyerDescription isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
    }else{
        [descriptionView setText:selectedFlyerDescription];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    // Set sharing network to zero
    countOfSharingNetworks = 0;
    
    // Set default progress view
    [self setDefaultProgressViewHeight];
    
}


-(void)loadHelpController{
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}



#pragma text field and text view delegates

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

/*
 * Called when clicked on description text view
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    [self textViewTapped:nil];

    return YES;
}

/*
 * Called when clicked on description text view
 */
- (void)textViewTapped:(id)sender {
    if([descriptionView.text isEqualToString:AddCaptionText]){
        [descriptionView setText:@""];
        [descriptionView becomeFirstResponder];
    }
}


/*
 * Called when end editing on text view
 */
-(void)textViewDidEndEditing:(UITextView *)textView{
    if([descriptionView.text isEqualToString:@""]){
        [descriptionView setText:AddCaptionText];
    }
}

- (void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {
    if([titleView.text isEqualToString:NameYourFlyerText]){
        [titleView setText:@""];
        [titleView becomeFirstResponder];
    }
}

/*
 * Called when end editing on text field
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([titleView.text isEqualToString:@""]){
        [titleView setText:NameYourFlyerText];
    }
}

#pragma on click buttons

/*
 * Check for network selection
 */
-(BOOL)isAnyNetworkSelected{
    
    if([facebookButton isSelected])
        return true;
    if([twitterButton isSelected])
        return true;
    if([emailButton isSelected])
        return true;
    if([tumblrButton isSelected])
        return true;
    if([flickrButton isSelected])
        return true;
    if([instagramButton isSelected])
        return true;
    if([smsButton isSelected])
        return true;
    if([clipboardButton isSelected])
        return true;
    if([instagramButton isSelected])
        return true;
    
    return false;
}



/*
 * Check for network selection for only non connectivity types
 */
-(BOOL)onlyNonConnectivityNetworkSelected{
    
    if(([smsButton isSelected] || [clipboardButton isSelected])
       &&
       (![facebookButton isSelected] && ![twitterButton isSelected] && ![emailButton isSelected] && ![tumblrButton isSelected] && ![flickrButton isSelected] && ![instagramButton isSelected])){
    
        return true;
    
    } else{
        return false;
    }
}


/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickFacebookButton{
    
    if([facebookButton isSelected]){
        [facebookButton setSelected:NO];        
    } else {
        
        // Check internet connectivity
        if([InviteFriendsController connected]){
            [facebookButton setSelected:YES];
            ;
            
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"#flyerly - %@  %@",titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            [SHKFacebook shareItem:item];
            [self updateSocialStates];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
        
    }
}

/*
 * Called when twitter button is pressed
 */
-(IBAction)onClickTwitterButton{
    
    if([twitterButton isSelected]){
        [twitterButton setSelected:NO];
    
    } else {

        // Check internet connectivity
        if([InviteFriendsController connected]){
             [twitterButton setSelected:YES];
            ;
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"#flyerly - %@ %@",
                                                                     titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            [SHKTwitter shareItem:item];
             [self updateSocialStates];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
    }
}

/*
 * Called when instagram button is pressed
 */
-(IBAction)onClickInstagramButton{
    if([instagramButton isSelected]){
        [instagramButton setSelected:NO];
    } else {
        [instagramButton setSelected:YES];
        [self shareOnInstagram];
    }
}

/*
 * Called when email button is pressed
 */
-(IBAction)onClickEmailButton{
    if([emailButton isSelected]){
        [emailButton setSelected:NO];
    } else {
        
        // Check internet connectivity
        if([InviteFriendsController connected]){
            [emailButton setSelected:YES];
            [self shareOnEmail];
            [self showAlert:@"Uploading flyer for sharing. Please wait..." message:@""];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
        
        
    }
}

/*
 * Called when tumblr button is pressed
 */
-(IBAction)onClickTumblrButton{
    if([tumblrButton isSelected]){
        [tumblrButton setSelected:NO];
    } else {
        
        // Check internet connectivity
        if([InviteFriendsController connected]){
           [tumblrButton setSelected:YES];
            ;
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"#flyerly - %@  %@",titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            [SHKTumblr shareItem:item];
            [self updateSocialStates ];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
        
    }
}

/*
 * Called when flickr button is pressed
 */
-(IBAction)onClickFlickrButton{
    if([flickrButton isSelected]){
        [flickrButton setSelected:NO];
    } else {
        
       
        // Check internet connectivity
        if([InviteFriendsController connected]){
            [flickrButton setSelected:YES];
            ;
            
            // Current Item For Sharing
            SHKItem *item = [SHKItem image:selectedFlyerImage title:[NSString stringWithFormat:@"#flyerly - %@  %@",titleView.text, selectedFlyerDescription ]];
            
            //Calling ShareKit for Sharing
            [SHKFlickr shareItem:item];
            [self updateSocialStates ];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }
        
    }
}

/*
 * Called when sms button is pressed
 */
-(IBAction)onClickSMSButton{
    if([smsButton isSelected]){
        [smsButton setSelected:NO];
    } else {
        
        // Check internet connectivity
        if([InviteFriendsController connected]){
            [smsButton setSelected:YES];
            [UIPasteboard generalPasteboard].image = selectedFlyerImage;
            [self SingleshareOnMMS];
            [self updateSocialStates ];
            [self showAlert:@"Uploading flyer for sharing. Please wait..." message:@""];
            
        } else {
            
            [self showAlert:@"You're not connected to the internet. Please connect and retry" message:@""];
            
        }

    }
    
}

/*
 * Called when clipboard button is pressed
 */
-(IBAction)onClickClipboardButton{
    if([clipboardButton isSelected]){
        [clipboardButton setSelected:NO];
        [clipboardlabel setTextColor:[UIColor whiteColor] ];
    } else {
        [clipboardButton setSelected:YES];
        [clipboardlabel setTextColor:[globle colorWithHexString:@"3caaff"]];
        [self onclipcordClick];
    }

}
-(void) onclipcordClick{
    [UIPasteboard generalPasteboard].image = selectedFlyerImage;
    [Flurry logEvent:@"Copy to Clipboard"];
}
-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)showAlert{
    
    [self updateSocialStates];
    
}

-(void)updateSocialStates{    
    
    PFUser *user = [PFUser currentUser];

    NSString *socialFlyerPath = [imageFileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/Flyr/", user.username] withString:[NSString stringWithFormat:@"%@/Flyr/Social/", user.username]];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
    
    NSMutableArray *socialArray = [[NSMutableArray alloc] initWithContentsOfFile:finalImgWritePath];
    if(!socialArray){
        socialArray = [[NSMutableArray alloc] init];
    }

    if([socialArray count] > 0){
    
        // Save states of all supported social media
        if([facebookButton isSelected]){
            [socialArray removeObjectAtIndex:0]; //Facebook
            [socialArray insertObject:@"1" atIndex:0]; //Facebook
        }
        
        if([twitterButton isSelected]){
            [socialArray removeObjectAtIndex:1]; //Twitter
            [socialArray insertObject:@"1" atIndex:1]; //Twitter
        }
        
        if([emailButton isSelected]){
            [socialArray removeObjectAtIndex:2]; //Email
            [socialArray insertObject:@"1" atIndex:2]; //Email
        }
        
        if([tumblrButton isSelected]){
            [socialArray removeObjectAtIndex:3]; //Tumblr
            [socialArray insertObject:@"1" atIndex:3]; //Tumblr
        }
        
        if([flickrButton isSelected]){
            [socialArray removeObjectAtIndex:4]; //Flickr
            [socialArray insertObject:@"1" atIndex:4]; //Flickr
        }
        
        if([instagramButton isSelected]){
            [socialArray removeObjectAtIndex:5]; //Instagram
            [socialArray insertObject:@"1" atIndex:5]; //Instagram
        }
        
        if([smsButton isSelected]){
            [socialArray removeObjectAtIndex:6]; //SMS
            [socialArray insertObject:@"1" atIndex:6]; //SMS
        }
        if([clipboardButton isSelected]){
            [socialArray removeObjectAtIndex:7]; //CLIPBOARD
            [socialArray insertObject:@"1" atIndex:7]; //CLIPBOARD
        }


    } else {
            
        // Save states of all supported social media
        if([facebookButton isSelected]){
            [socialArray addObject:@"1"]; //Facebook
        } else  {
            [socialArray addObject:@"0"]; //Facebook
        }
        
        if([twitterButton isSelected]){
            [socialArray addObject:@"1"]; //Twitter
        } else  {
            [socialArray addObject:@"0"]; //Twitter
        }
        
        if([emailButton isSelected]){
            [socialArray addObject:@"1"]; //Email
        } else  {
            [socialArray addObject:@"0"]; //Email
        }
        
        if([tumblrButton isSelected]){
            [socialArray addObject:@"1"]; //Tumblr
        } else  {
            [socialArray addObject:@"0"]; //Tumblr
        }
        
        if([flickrButton isSelected]){
            [socialArray addObject:@"1"]; //Flickr
        } else  {
            [socialArray addObject:@"0"]; //Flickr
        }
        
        if([instagramButton isSelected]){
            [socialArray addObject:@"1"]; //Instagram
        } else  {
            [socialArray addObject:@"0"]; //Instagram
        }
        
        if([smsButton isSelected]){
            [socialArray addObject:@"1"]; //SMS
        } else  {
            [socialArray addObject:@"0"]; //SMS
        }
        
        if([clipboardButton isSelected]){
            [socialArray addObject:@"1"]; //CLIPBOARD
        } else  {
            [socialArray addObject:@"0"]; //CLIPBOARD
        }
        
    }

    [[NSFileManager defaultManager] removeItemAtPath:finalImgWritePath error:nil];
    [socialArray writeToFile:finalImgWritePath atomically:YES];
}

-(void)updateFlyerDetail {
	
    // delete already existing file and
    // Add file with same name
    [[NSFileManager defaultManager] removeItemAtPath:detailFileName error:nil];
	NSMutableArray *array = [[NSMutableArray alloc] init];

    if(!titleView.text || [titleView.text isEqualToString:NameYourFlyerText]){
        [array addObject:NameYourFlyerText];
    }else{
        [array addObject:self.titleView.text];
    }

    if(!descriptionView.text || [descriptionView.text isEqualToString:AddCaptionText]){
        [array addObject:@""];
    }else{
        [array addObject:self.descriptionView.text];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:FlyerDateFormat];
    NSString *dateString = [dateFormat stringFromDate:date];
    [array addObject:dateString];

    [array writeToFile:detailFileName atomically:YES];
	
    [[NSFileManager defaultManager] removeItemAtPath:imageFileName error:nil];
	NSData *imgData = UIImagePNGRepresentation(selectedFlyerImage);
	[[NSFileManager defaultManager] createFileAtPath:imageFileName contents:imgData attributes:nil];

}


#pragma Sharing code

/*
 * Share on MMS
 */
-(void)SingleshareOnMMS{

    NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
    [self uploadImage:imageData isEmail:NO];
    
}


-(void)shareOnMMS{

    NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
    [self uploadImageByboth:imageData];
    
 }


-(void)shareOnMMS:(NSString *)link{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        //controller.body = [NSString stringWithFormat:@"%@ - %@ %@", selectedFlyerDescription,link, @"#flyerly"];
        controller.body = [NSString stringWithFormat:@"%@ - %@ %@", self.titleView.text ,link, @"flyer.ly/SMS"];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)uploadImage:(NSData *)imageData isEmail:(BOOL)isEmail
{
    PFFile *imageFile = [PFFile fileWithName:[FlyrViewController getFlyerNumberFromPath:imageFileName] data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *flyerObject = [PFObject objectWithClassName:@"Flyer"];
            flyerObject[@"image"] = imageFile;
            
            // Set the access control list to current user for security purposes
            flyerObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            flyerObject[@"user"] = user;
            
            [flyerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {

                    PFFile *theImage = flyerObject[@"image"];
                    
                    if(isEmail){
                        [self shareOnEmail:[theImage url]];
                    }else{
                        [self shortenURL:[theImage url]];
                    }
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
    }];
}


- (void)uploadImageByboth:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:[FlyrViewController getFlyerNumberFromPath:imageFileName] data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *flyerObject = [PFObject objectWithClassName:@"Flyer"];
            flyerObject[@"image"] = imageFile;
            
            // Set the access control list to current user for security purposes
            flyerObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            flyerObject[@"user"] = user;
            
            [flyerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    PFFile *theImage = flyerObject[@"image"];
                    [self shareOnEmail:[theImage url]];
                    globle.sharelink = [theImage url];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
    }];
}


/*
 * Share on Email
 */
-(void)shareOnEmail{
    NSData *imageData = UIImagePNGRepresentation(selectedFlyerImage);
    [self uploadImage:imageData isEmail:YES];
}

-(void)shareOnEmail:(NSString *)link{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"You just received a NEW flyer!"];        
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly/email'>A flyerly creation...</a></font></p>"];
        
        [emailBody appendString:[NSString stringWithFormat:@"<p><img src='%@'></p>",link]];
        [emailBody appendString:@"<p><font size='4'><a href = 'http://www.flyer.ly'>Download flyerly & share a flyer</a></font></p>"];
        [emailBody appendString:@"</body></html>"];
        NSLog(@"%@",emailBody);
        
        //mail composer window
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
    }
}


/*
 * Share on Instagram
 */
-(void)shareOnInstagram{

     CGRect rect = CGRectMake(0 ,0 , 0, 0);
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIGraphicsEndImageContext();
     
     UIImage *originalImage = [UIImage imageWithContentsOfFile:imageFileName];
    
     NSString  *updatedImagePath = [imageFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@".igo"];
     NSData *imgData = UIImagePNGRepresentation(originalImage);
     [[NSFileManager defaultManager] createFileAtPath:updatedImagePath contents:imgData attributes:nil];
     
     NSURL *igImageHookFile = [NSURL fileURLWithPath:updatedImagePath];
    
     self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
     self.dic.UTI = @"com.instagram.photo";
     //self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
     self.dic.annotation = @{@"InstagramCaption": [NSString stringWithFormat:@"%@ %@", self.titleView.text,descriptionView.text]};
    BOOL displayed = [self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    
    if(!displayed){
        [self showAlert:@"Warning!" message:@"Please install Instagram app to share."];
    }
}

/*
 * Check whether instagram app is installed or not
 */
-(BOOL)canOpenDocumentWithURL:(NSURL*)url inView:(UIView*)view {
    BOOL canOpen = NO;
    UIDocumentInteractionController* docController = [UIDocumentInteractionController
                                                      interactionControllerWithURL:url];
    if (docController)
    {
        docController.delegate = self;
        canOpen = [docController presentOpenInMenuFromRect:CGRectZero
                                                    inView:self.view animated:NO];
        [docController dismissMenuAnimated:NO];
    }
    return canOpen;
}



- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}


-(void)setDefaultProgressViewHeight{
    
    if(IS_IPHONE_5){
        [scrollView setFrame:CGRectMake(5, 0, 310, 600)];
        [scrollView setContentSize:CGSizeMake(310, 600)];
    }else{
        [scrollView setFrame:CGRectMake(5, 0, 310, 401)];
        [scrollView setContentSize:CGSizeMake(310, 401)];
    }
}


#pragma Request receive code

- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{

    NSLog(@"presentOptionsMenuFromRect");
    
    return YES;
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
            NSLog(@"Sent");
			break;
		case MFMailComposeResultFailed:
			break;
	}

    [controller dismissViewControllerAnimated:YES completion:nil];

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
            NSLog(@"Sent");
			break;
		case MessageComposeResultFailed:
			break;
	}
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    }


#pragma Location near by code

/*
 * get switch on off event
 */
-(void)setSwitchState:(id)sender {
    if([sender isOn]){
        [locationLabel setHidden:NO];
        [locationBackground setHidden:NO];
        [locationButton setHidden:NO];
        locationLabel.text = @"Name This Location ";
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height + 36)];
        // move view down
        [networkParentView setFrame:CGRectMake(networkParentView.frame.origin.x, networkParentView.frame.origin.y + 36, networkParentView.frame.size.width, networkParentView.frame.size.height)];
        [UIView commitAnimations];
        
    }else{
        [locationLabel setHidden:YES];
        [locationBackground setHidden:YES];
        [locationButton setHidden:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height - 36)];
        // move view up
        [networkParentView setFrame:CGRectMake(networkParentView.frame.origin.x, networkParentView.frame.origin.y - 36, networkParentView.frame.size.width, networkParentView.frame.size.height)];
        [UIView commitAnimations];
    }
}

#pragma Bitly code for URL shortening

-(void)shortenURL:(NSString *)url{
  
    bitly = [[BitlyURLShortener alloc] init];
    bitly.delegate = self;
    [bitly shortenLinksInText:url];
}

- (void)bitlyURLShortenerDidShortenText:(BitlyURLShortener *)shortener oldText:(NSString *)oldText text:(NSString *)text linkDictionary:(NSDictionary *)dictionary {
    
    NSLog(@"Old Text: %@", oldText);
    NSLog(@"New Text: %@", text);
    
    [self shareOnMMS:text];
}

- (void)bitlyURLShortener:(BitlyURLShortener *)shortener
        didFailForLongURL:(NSURL *)longURL
               statusCode:(NSInteger)statusCode
               statusText:(NSString *)statusText {
    NSLog(@"Shortening failed for link %@: status code: %d, status text: %@",
          [longURL absoluteString], statusCode, statusText);
}

#pragma leaving code

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self updateFlyerDetail];
}


#pragma ShareKit

- (void)myButtonHandlerAction
{
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
    SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!" contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}


@end
