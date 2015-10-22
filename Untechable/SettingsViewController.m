//
//  SettingsViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 28/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCellView.h"
#import "Common.h"
#import "CommonFunctions.h"
#import "SocialnetworkController.h"
#import "EmailSettingController.h"
#import "SocialNetworksStatusModal.h"
#import "SetupGuideViewController.h"
#import "EditButtonCell.h"

@interface SettingsViewController () {
    
    NSMutableArray *socialIcons;
    NSMutableArray *socialNetworksName;
}

@end

@implementation SettingsViewController

@synthesize untechable, socialNetworksTable, editNameAlert;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];

    socialNetworksName = [[NSMutableArray alloc] initWithObjects: @"Facebook",@"Twitter",@"LinkedIn",@"Email", nil];
    
    socialIcons = [[NSMutableArray alloc] init];
    
    if ( IS_IPHONE_4 || IS_IPHONE_5 || IS_IPHONE_6 ){
        NSLog(@"iPhone 6");
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"facebook@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"twitter@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"linkedIn@2x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"email@2x.png", @"text":@""}];
    }
    
    if ( IS_IPHONE_6_PLUS ){
        NSLog(@"iPhone 6");
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"facebook@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"twitter@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"linkedIn@3x.png", @"text":@""}];
        [socialIcons addObject:@{@"type":@"image", @"imgPath":@"email@3x.png", @"text":@""}];
    }
}

- (void) updateUI {
    
    [socialNetworksTable  reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation:(NSString *)callFrom{
    
    if([callFrom isEqualToString:@"viewDidLoad"]) {
        
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:NSLocalizedString(TITLE_BACK_TXT,  nil) forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [backButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];//Left button ___________
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
       
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:NSLocalizedString(TITLE_HELP_TXT, nil) forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(emailComposer) forControlEvents:UIControlEventTouchUpInside];
        [nextButton addTarget:self action:@selector(btnTouchStart:) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [socialNetworksTable reloadData];
}

-(void) goBack {
    
    untechable.fbAuth = untechable.socialNetworksStatusModal.mFbAuth;
    untechable.fbAuthExpiryTs = untechable.socialNetworksStatusModal.mFbAuthExpiryTs;
    untechable.twitterAuth = untechable.socialNetworksStatusModal.mTwitterAuth;
    untechable.twOAuthTokenSecret = untechable.socialNetworksStatusModal.mTwOAuthTokenSecret;
    untechable.linkedinAuth = untechable.socialNetworksStatusModal.mLinkedinAuth;
    [untechable addOrUpdateInDatabase];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  Highlighting Functions

-(void)btnTouchStart :(id)button{
    [self setHighlighted:YES sender:button];
}
-(void)btnTouchEnd :(id)button{
    [self setHighlighted:NO sender:button];
}
- (void)setHighlighted:(BOOL)highlighted sender:(id)button {
    (highlighted) ? [button setBackgroundColor:DEF_GREEN] : [button setBackgroundColor:[UIColor clearColor]];
}

-(void)changeSettings{
    
    SetupGuideViewController *secondSetupScreen = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    secondSetupScreen.untechable = untechable;
    [self.navigationController pushViewController:secondSetupScreen animated:YES];
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return number of rows;
    return  6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SettingsCellView";
    SettingsCellView *cell = (SettingsCellView *)[tableView dequeueReusableCellWithIdentifier:cellId];

    EditButtonCell *cellEditButton = (EditButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"EditButtonCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
        cell = (SettingsCellView *)[nib objectAtIndex:0];
    }
    

    if( indexPath.row == 0 ){
        
        // set first cell to show user name
        cell.socialNetworkName.text = NSLocalizedString(@"Name", nil);
        cell.socialNetworkImage.image = [UIImage imageNamed:@"user_img"];
        cell.loginStatus.text = untechable.userName;
        [cell.socialNetworkButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        [cell.socialNetworkButton addTarget:self action:@selector(onEditName) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else {

        NSString *sNetworksName = [socialNetworksName objectAtIndex:(indexPath.row)];
        if ( indexPath.row == 1 ){
            
            if ( [untechable.socialNetworksStatusModal.mFbAuth isEqualToString:@""] ||
                 [untechable.socialNetworksStatusModal.mFbAuthExpiryTs isEqualToString:@""] ) {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"facebook@2x.png"];
            } else {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"facebook@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginFacebook:) forControlEvents:UIControlEventTouchUpInside];
        
        }else if ( indexPath.row == 2 ){
            
           if ( [untechable.socialNetworksStatusModal.mTwitterAuth isEqualToString:@""] ||
                [untechable.socialNetworksStatusModal.mTwOAuthTokenSecret isEqualToString:@""]  ){
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"twitter@2x.png"];
            } else {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"twitter@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginTwitter:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ( indexPath.row == 3 ){
            
            if ( [untechable.socialNetworksStatusModal.mLinkedinAuth isEqualToString:@""] ) {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"linkedin@2x.png"];
            } else {
                 [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"linkedin@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ( indexPath.row == 4){
            
            if (  [untechable.email isEqualToString:@""]  || [untechable.password isEqualToString:@""] ){
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"emailic@2x.png"];
            }else {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"emailic@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
            
      }
        else if(indexPath.row == 5){
            
            if (cellEditButton == nil) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditButtonCell" owner:self options:nil];
                cellEditButton = (EditButtonCell *)[nib objectAtIndex:0];
            }
            
            [cellEditButton.btnChangeUntechNowSettings addTarget:self action:@selector(changeSettings) forControlEvents:UIControlEventTouchUpInside];
            return cellEditButton;
        }
    }
    return cell;
    
    
}

-(IBAction)emailLogin:(id)sender {
    
    UIButton *emailButton = (UIButton *) sender;
    
    if ( [emailButton.titleLabel.text isEqualToString:NSLocalizedString(@"Log Out", nil)] ){
        untechable.email = @"";
        untechable.password = @"";
        
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [emailButton convertPoint:CGPointZero toView:self.socialNetworksTable];
        NSIndexPath *indexPath = [self.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil) {
            settingCell = (SettingsCellView*)[self.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }
        
        [emailButton setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
        
        [settingCell.loginStatus setText:NSLocalizedString(@"Logged Out", nil)];
    }
    
    if ( [emailButton.titleLabel.text isEqualToString:NSLocalizedString(@"Log In", nil)] ){
        EmailSettingController *emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
        emailSettingController.untechable = untechable;
        emailSettingController.comingFrom = @"SettingsScreen";
        [self.navigationController pushViewController:emailSettingController animated:YES];
    }
}

-(IBAction)loginLinkedIn:(id) sender {
    [untechable.socialNetworksStatusModal loginLinkedIn:sender Controller:self];
}

-(IBAction)loginTwitter:(id) sender {
    [untechable.socialNetworksStatusModal loginTwitter:sender Controller:self];
}

-(IBAction)loginFacebook:(id) sender {    
    [untechable.socialNetworksStatusModal loginFacebook:sender Controller:self];
}


-(void)onEditName{
    editNameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Put in your name below. This will be used to identify yourself to friends.", nil)
                                                 message:@""
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(TITLE_DONE_TXT, nil)
                                       otherButtonTitles:nil, nil];

    editNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //Name field
    UITextField * nameField = [editNameAlert textFieldAtIndex:0];
    nameField.text = untechable.userName;
    nameField.keyboardType = UIKeyboardTypeTwitter;
    nameField.placeholder = NSLocalizedString(@"Enter Name", nil);

    [editNameAlert show];
}

/**
 Action catch for the uiAlertview buttons
 we have to save name and phone number on button press
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( alertView == editNameAlert ){
        //getting text from the text fields
        untechable.userName = [alertView textFieldAtIndex:0].text;
        [socialNetworksTable reloadData];
    }
}

/*
 * This method sends email
 * to support team
 */
- (IBAction)emailComposer {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    if([MFMailComposeViewController canSendMail]){
        
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Untech Email Feedback..."];
        
        // Set up recipients
        NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
        [toRecipients addObject:@"support@greenmtnlabs.com"];
        [picker setToRecipients:toRecipients];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

@end
