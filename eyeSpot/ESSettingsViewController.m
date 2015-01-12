//
//  ESSettingsViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "ESSettingsViewController.h"
#import "ESSettings.h"
#import "ESStore.h"
#import "UIAlertView+ESShorthand.h"

@interface ESSettingsViewController () <UIAlertViewDelegate>

@end

@implementation ESSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self syncSoundButton];
    if (IS_IPHONE) {
        [self.view removeConstraints:@[self.unnecessaryLayoutConstraint1, self.unnecessaryLayoutConstraint1]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Helpers
- (void)syncSoundButton
{
    if ([[ESSettings sharedInstance] isSoundEnabled]) {
        self.soundOnButton.selected = YES;
        self.soundOffButton.selected = NO;
    } else {
        self.soundOnButton.selected = NO;
        self.soundOffButton.selected = YES;
    }
}

- (void)transactionRestoreHandler:(NSNotification *)notification
{
    NSNumber *successObj = notification.userInfo[ESStoreTransactionsRestoredNotificationSuccessKey];
    NSString *title, *body;
    if ([successObj boolValue]) {
        title = nil; body = @"Your purchases have been restored.";
    } else {
        title = @"Sorry!"; body = @"Unable to restore your purchases.";
        [Flurry logError:kESEventTagForApplicationError message:body error:nil];
    }
    [UIAlertView es_showStandardAlertDialogWithTitle:title andMessage:body];
}

#pragma mark - Actions
- (IBAction)clearTrophyRoom:(id)sender
{
    NSString *title = nil, *body = @"Are you sure you want to clear your trophy room?";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:body
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (IBAction)toggleSound:(id)sender
{
    BOOL isSoundEnabled = (sender == self.soundOnButton);
    [ESSettings sharedInstance].isSoundEnabled = isSoundEnabled;
    [self syncSoundButton];
}

- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)restorePurchases:(id)sender
{
    if ([[ESStore sharedStore] canPurchaseProducts]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(transactionRestoreHandler:)
                                                     name:ESStoreTransactionsRestoredNotification object:nil];
        [[ESStore sharedStore] restoreCompletedTransactions];
    } else {
        NSString *title = @"Sorry!", *body = @"Unable to restore your purchases.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:body
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];        
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[ESSettings sharedInstance] clearTrophyRoom];
        NSString *title = @"Cleared!", *body = @"The trophy room is clear now!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

    }
}
@end
