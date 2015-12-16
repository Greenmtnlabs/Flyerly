//
//  HowToScreenThreeViewController.m
//  Untechable
//
//  Created by rufi on 03/12/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "HowToScreenThreeViewController.h"
#import "SetupGuideViewController.h"
#import "UntechablesList.h"
#import "SettingsViewController.h"
#import "InviteFriendsController.h"


@interface HowToScreenThreeViewController ()

@end

@implementation HowToScreenThreeViewController

@synthesize untechable;
@synthesize lblMessage, isComingFromThankYou, pageView;
@synthesize isComingFromSettings;
@synthesize btnInviteOthers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if(isComingFromThankYou){
        self.pageView.hidden = YES;
    }
    
    // to apply localization
    [self applyLocalization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * This method applies localization
 * @params:
 *      void
 * @return:
 *      void
 */
-(void) applyLocalization{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Once you've completed your Untech selection, go enjoy your time away from technology. Untech & reconnect with life. Don't forget to invite others to untech so thay can do the same. Namaste!", nil)];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254.0/255.0 green:138.0/255.0 blue:51.0/255.0 alpha:1.0] range:(NSRange){text.length - 9,9}];
    self.lblMessage.attributedText=text;
    
    [btnInviteOthers setTitle: NSLocalizedString(@"Invite Others", nil) forState: UIControlStateNormal];
    
}

- (IBAction)onClickDone:(id)sender {
    
    if(isComingFromThankYou){ // If coming from ThankYou Screen, load UntechablesList
        UntechablesList *mainViewController = [[UntechablesList alloc] initWithNibName:@"UntechablesList" bundle:nil];
        [self.navigationController pushViewController:mainViewController animated:YES];
    }else if(isComingFromSettings){
        
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        untechable.rUId = @"1";
        untechable.dic[@"rUId"] = @"1";
        settingsViewController.untechable = untechable;
        [self.navigationController pushViewController:settingsViewController animated:YES];
        
    } else{ // otherwise, load SetupGuideViewController
        SetupGuideViewController *setupGuideViewController = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
        setupGuideViewController.untechable = untechable;
        [self.navigationController pushViewController:setupGuideViewController animated:YES];
    }
}
- (IBAction)onClickInviteOthers:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO];
    //Load Invite Screen
    InviteFriendsController *inviteFriendsController = [[InviteFriendsController alloc] initWithNibName:@"InviteFriendsController" bundle:nil];
    [self.navigationController pushViewController:inviteFriendsController animated:YES];
}
@end
