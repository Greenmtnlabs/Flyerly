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

@interface SocialnetworkController : UIViewController < UITextViewDelegate , BSKeyboardControlsDelegate >
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIButton *skipButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}
//Properties
@property (nonatomic,strong)  Untechable *untechable;
@property(nonatomic,strong) IBOutlet UIPlaceHolderTextView *descriptionView;

- (IBAction)shareOn:(id)sender;


@end
