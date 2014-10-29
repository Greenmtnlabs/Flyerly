//
//  PhoneSetupController.h
//  Untechable
//
//  Created by ABDUL RAUF on 24/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "BSKeyboardControls.h"
#import <AVFoundation/AVFoundation.h>
#import "RMStore.h"

@interface PhoneSetupController : UIViewController < UITableViewDataSource, UITextFieldDelegate , BSKeyboardControlsDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *nextButton;
    UIButton *skipButton;
    
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
    //In app vars
    NSArray *requestedProducts;
    BOOL cancelRequest;
    
    NSMutableArray *productArray;
    NSArray *freeFeaturesArray;

}

@property (strong, nonatomic) IBOutlet UIButton *btnRec;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;


//Properties
@property (nonatomic,strong)  Untechable *untechable;

@end
