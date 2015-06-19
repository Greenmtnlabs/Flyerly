//
//  SetupGuideViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideViewController.h"

@interface SetupGuideViewController () {
    NSString *userName;
    NSString *userphoneNumber;
}

@end

@implementation SetupGuideViewController

@synthesize untechable;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTextViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark Initializing Views
-(void) initializeTextViews{
    
    // getting the values of name and number
    userName = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userName"];
    
    userphoneNumber = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userphoneNumber"];
    
    // if these are not null values then set what we've
    if( userName == NULL || [userName isEqualToString:@""] ){
        _userNameTextView.text = @"";
        _usernameHintText.hidden = NO;
    } else {
        _usernameHintText.hidden = YES;
        _userNameTextView.text = userName;
    }
    
    if ( userphoneNumber == NULL || [userphoneNumber isEqualToString:@""] ) {
        _userPhoneNumber.text = @"";
        _phoneNumberHintText.hidden = NO;
    } else  {
        _phoneNumberHintText.hidden = YES;
        _userPhoneNumber.text = userphoneNumber;
    }
    
    _userNameTextView.delegate = self;
    _userNameTextView.tag = 101;
    
    _userPhoneNumber.delegate = self;
    _userPhoneNumber.tag = 102;
    [_userPhoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    [_userPhoneNumber reloadInputViews];
    
}

#pragma - mark TextView Delegate Methods
-(void)textViewDidEndEditing:(UITextView *)textView{
    
   }

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    //using labels as placeholder, because textview doesn't have 'em.
    if( textView.tag == 101 ){
         _usernameHintText.hidden = YES;
    } else {
        _phoneNumberHintText.hidden =  YES;
    }
}

-(void) textViewDidChange:(UITextView *)textView {
    
    // we've set username text view tag to 101.
    // so if the current text view is related to username's
    // get the text and save it into the username field
    if( textView.tag == 101 ){
        
        
        
        userName = textView.text;
        self.usernameHintText.hidden = ([userName length] > 0);
        
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];

    } else {
        // else  we've phone number field
        userphoneNumber = textView.text;
        self.phoneNumberHintText.hidden = ([userphoneNumber length] > 0);
        [[NSUserDefaults standardUserDefaults] setObject:userphoneNumber forKey:@"userphoneNumber"];
    }
    
    // sync the current fields
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString*)aText
{
    NSString* newText = [aTextView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    // TODO - find out why the size of the string is smaller than the actual width, so that you get extra, wrapped characters unless you take something off
    CGSize tallerSize = CGSizeMake(aTextView.frame.size.width-15,aTextView.frame.size.height*2); // pretend there's more vertical space to get that extra line to check on
    CGSize newSize = [newText sizeWithFont:aTextView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
    
    if (newSize.height > aTextView.frame.size.height || [aTextView.text isEqualToString:@"\n"])
    {
        return NO;
    }
    else
        return YES;
}

#pragma - mark Touching outside a view hides keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
