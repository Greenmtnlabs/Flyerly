//
//  SetupGuideViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/19/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideViewController.h"
#import "Common.h"
#import "SetupGuideSecondViewController.h"
#import "AddUntechableController.h"

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
    [self setNavigationBarItems];
    [self setupDefaultModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Update the view once it appears.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [untechable printNavigation:[self navigationController]];
    [self setNavigation:@"viewDidLoad"];
    
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

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    //using labels as placeholder, because textview doesn't have 'em.
    if( textView.tag == 101 ){
         _usernameHintText.hidden = YES;
    } else {
        _phoneNumberHintText.hidden =  YES;
        [self animateTextField:textView up:YES];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    
    if(textView.tag == 102 ) {
        [self animateTextField:textView up:NO];
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
    CGSize newSize = [newText sizeWithFont:aTextView.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (newSize.height > aTextView.frame.size.height || [aTextView.text isEqualToString:@"\n"])
    {
        // if next button is pressed then take user to next textfield which is in this case is userphone number field
        [_userPhoneNumber becomeFirstResponder];
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

#pragma - mark setting navigation bar related stuff
-(void) setNavigationBarItems {
    
   
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
}

-(void)setNavigation:(NSString *)callFrom {
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];

        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onNext{
    
    if ( !( userName == NULL || [userName isEqualToString:@"" ] ) && !( userphoneNumber == NULL || [userphoneNumber isEqualToString:@""]) ) {
        
        untechable.userName = userName;
        untechable.userPhoneNumber = userphoneNumber;
        
        SetupGuideSecondViewController *secondSetupScreen = [[SetupGuideSecondViewController alloc] initWithNibName:@"SetupGuideSecondViewController" bundle:nil];
        secondSetupScreen.untechable = untechable;
        [self.navigationController pushViewController:secondSetupScreen animated:YES];

        
    } else {
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Please Enter Your Name and Number"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

/**
 Initializing Untech Model
 **/
-(void)setupDefaultModel {
    
    untechable  = [[Untechable alloc] init];
    untechable.commonFunctions = [[CommonFunctions alloc] init];
    [untechable setOrSaveVars:@"RESET"];
    [untechable initUntechableDirectory];
}

/**
 Moving up view if the keyboard hides a view.
 **/
- (void) animateTextField: (UITextView *) textField up: (BOOL) up {
    
    const int movementDistance = 140;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

@end
