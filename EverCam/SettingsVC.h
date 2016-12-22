//
//  SettingsVC.h
// EverCam
//
//  Created by MacBook FV iMAGINATION on 08/05/15.
//  Copyright (c) 2015 FV iMAGINATION. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Configs.h"
#import "HomeVC.h"


NSInteger rowsNumber;
BOOL saveOriginalPhoto;
BOOL saveToCustomAlbum;
BOOL feedback;

@interface SettingsVC : UITableViewController
<
MFMailComposeViewControllerDelegate
>

// Switches
@property (strong, nonatomic) IBOutlet UISwitch *originalPhotoSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *customAlbumSwitch;


// Labels
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *saveOriginalLabel;
@property (strong, nonatomic) IBOutlet UILabel *saveToCustomAlbumLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateUsLabel;
@property (strong, nonatomic) IBOutlet UILabel *tellAfriendLabel;
@property (strong, nonatomic) IBOutlet UILabel *sendFeedbackLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeUsonFBLabel;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;





@end
