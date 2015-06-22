//
//  SetupGuideSecondViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideSecondViewController.h"
#import "Common.h"

@interface SetupGuideSecondViewController () {
    NSMutableArray *customSpendingText;
}


@end

@implementation SetupGuideSecondViewController

@synthesize untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializePickerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializePickerData {
    
    NSArray *arrayToBeAdded =  @[@"Spending time with family.", @"Driving.", @"Spending time outdoors.", @"At the beach.", @"Enjoying the holidays.", @"Just needed a break.", @"Running.", @"On vacation.", @"Finding my inner peace.", @"Removing myself from technology.", @"Custom"];
    
    customSpendingText = [[NSMutableArray alloc]initWithArray:arrayToBeAdded];
    
    self.setupSpendingTimeText.dataSource = self;
    self.setupSpendingTimeText.delegate = self;
    [self setupPickerForDifferentPhones];
    
}

-(void) setupPickerForDifferentPhones {
    
    if ( IS_IPHONE_4 ){
        [_setupSpendingTimeText setFrame:CGRectMake(0, 50, 0, 140)];
    }else if( IS_IPHONE_5 ){
        [_setupSpendingTimeText setFrame:CGRectMake(0, 100, 0, 240)];
    }else if ( IS_IPHONE_6 ){
        [_setupSpendingTimeText setFrame:CGRectMake(0, 150, 0, 260)];
    }else if (IS_IPHONE_6_PLUS){
        [_setupSpendingTimeText setFrame:CGRectMake(0, 200, 0, 500)];
    }
}

#pragma - Mark UI PICKER VIEW Delegate Methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return customSpendingText.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return customSpendingText[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if( [[customSpendingText objectAtIndex:row] isEqualToString:@"Custom"] ) {
        [self showAddFieldPopUp];
    }

}

/**
 Showing a prompt where user can add their custom messages.
 **/
-(void) showAddFieldPopUp {
    
    UIAlertView *customMsg = [ [UIAlertView alloc] initWithTitle:@"Change Name"
                                                    message:@"What is your teacher's name?"
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Add", nil];
    
    customMsg.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [customMsg show];
}

#pragma - mark UIAlert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // we will add new message at the second last index
    int position = ( int )[customSpendingText count] - 1;
    
    //if cancel was not pressed
    if( buttonIndex != 0 ){
        
        // getting the newly added text from the field
        NSString *newMsg = [[alertView textFieldAtIndex:0] text];
        
        // adding the new msg at the second last index of the picker
        [customSpendingText insertObject:newMsg atIndex:position];
        
        // reloading the new picker view with custom messages
        [_setupSpendingTimeText reloadAllComponents];
        
    }
    
}

@end
