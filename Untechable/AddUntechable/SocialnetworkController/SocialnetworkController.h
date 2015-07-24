//
//  SocialnetworkController.h
//  Untechable
//
//  Created by ABDUL RAUF abdul.rauf@riksof.com on 29/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "UIPlaceHolderTextView.h"
#import "BSKeyboardControls.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Reachability.h"

@interface SocialnetworkController : UIViewController < UITextViewDelegate , BSKeyboardControlsDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *finishButton;
    //UIButton *nextButton;
    //UIButton *skipButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
    Reachability *internetReachable;
}

//Properties
@property (strong, nonatomic) IBOutlet UILabel *char_Limit;

@property (strong, nonatomic) IBOutlet UITextView *inputSetSocialStatus;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;

@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;

@property (strong, nonatomic) IBOutlet UIButton *btnLinkedin;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;


@property (nonatomic,strong)  Untechable *untechable;
@property(nonatomic,strong) IBOutlet UIPlaceHolderTextView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *showMessageBeforeSending;
- (IBAction)shareOn:(id)sender;

//Check if coming from contacstListScreen screen
@property (nonatomic, assign) BOOL comingFromContactsListScreen;

//Check if the previous screen is SetupGuideFourthView
@property(nonatomic) BOOL *isSentFromSetupGuideFourthView;

@end
