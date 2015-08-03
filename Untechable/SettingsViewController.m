//
//  SettingsViewController.m
//  Untechable
//
//  Created by Abdul Rauf on 28/01/2015.
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

@interface SettingsViewController () {
    
    NSMutableArray *socialIcons;
    NSMutableArray *socialNetworksName;
}

@end

@implementation SettingsViewController

@synthesize untechable,socialNetworksTable;
@synthesize emailSettingController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigation:@"viewDidLoad"];
    [self updateUI];

    socialNetworksName = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter",@"LinkedIn",@"Email", nil];
    
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

-(void)setNavigation:(NSString *)callFrom
{
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Right Navigation ______________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[newUntechableButton setBackgroundColor:[UIColor redColor]];//for testing
        
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        //newUntechableButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        //[newUntechableButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        
       // [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
        
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_EDIT_TEXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
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
  
    [self.navigationController popViewControllerAnimated:YES];
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
    
    SetupGuideViewController *secondSetupScreen = [[SetupGuideViewController alloc] initWithNibName:@"SetupGuideViewController" bundle:nil];
    secondSetupScreen.untechable = untechable;
    [self.navigationController pushViewController:secondSetupScreen animated:YES];
    
}




// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return number of rows;
    return  5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SettingsCellView";
    SettingsCellView *cell = (SettingsCellView *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
    }
    
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues]);
    
    
    //NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    if( indexPath.row == 0 ){
        
        cellId = @"NameAndPhoneCellView";
        cell = (SettingsCellView *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil)
        {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NameAndPhoneCellView" owner:self options:nil];
            
            cell = (SettingsCellView *)[nib objectAtIndex:0];
            
        }
        return cell;
        
    } else {

        NSString *sNetworksName = [socialNetworksName objectAtIndex:(indexPath.row-1)];
        
        if ( indexPath.row == 1 ){
            
            if ( [[[SocialNetworksStatusModal sharedInstance] getFbAuth] isEqualToString:@""] ||
                 [[[SocialNetworksStatusModal sharedInstance] getFbAuthExpiryTs] isEqualToString:@""] )
            {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"facebook@2x.png"];
            }else
            {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"facebook@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginFacebook:) forControlEvents:UIControlEventTouchUpInside];
        
        }else if ( indexPath.row == 2 ){
            
           if ( [[[SocialNetworksStatusModal sharedInstance] getTwitterAuth] isEqualToString:@""] ||
                [[[SocialNetworksStatusModal sharedInstance] getTwitterAuthTokkenSecerate] isEqualToString:@""]  )
            {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"twitter@2x.png"];
            }else
            {
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"twitter@2x.png"];
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginTwitter:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ( indexPath.row == 3 ){
            
            if ( [[[SocialNetworksStatusModal sharedInstance] getLinkedInAuth] isEqualToString:@""] )
            {
                
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"linkedin@2x.png"];
                
            }else
            {
                
                 [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"linkedin@2x.png"];
                
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(loginLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ( indexPath.row == 4){
            
            if (  [[[SocialNetworksStatusModal sharedInstance] getEmailAddress] isEqualToString:@""]  || [[[SocialNetworksStatusModal sharedInstance] getEmailPassword] isEqualToString:@""] ){
                
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:0 NetworkImage:@"emailic@2x.png"];
                
            }else {
                
                [cell setCellValueswithSocialNetworkName :sNetworksName LoginStatus:1 NetworkImage:@"emailic@2x.png"];
                
            }
            
            [cell.socialNetworkButton addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    return cell;
}

-(IBAction)emailLogin:(id)sender {
    
    UIButton *emailButton = (UIButton *) sender;
    
    if ( [emailButton.titleLabel.text isEqualToString:@"Log Out"] ){
        
        [[SocialNetworksStatusModal sharedInstance] setEmailAddress:@""];
        
        [[SocialNetworksStatusModal sharedInstance] setEmailPassword:@""];
        
        SettingsCellView *settingCell;
        CGPoint buttonPosition = [emailButton convertPoint:CGPointZero toView:self.socialNetworksTable];
        NSIndexPath *indexPath = [self.socialNetworksTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            settingCell = (SettingsCellView*)[self.socialNetworksTable cellForRowAtIndexPath:indexPath];
        }
        
        [emailButton setTitle:@"Log In" forState:UIControlStateNormal];
        
        [settingCell.loginStatus setText:@"Logged Out"];
    }
    
    if ( [emailButton.titleLabel.text isEqualToString:@"Log In"]  ){
        
        if ( [[[SocialNetworksStatusModal sharedInstance] getEmailAddress] isEqualToString:@""] ||
             [[[SocialNetworksStatusModal sharedInstance] getEmailPassword] isEqualToString:@""] ){
            
            EmailSettingController *emailSettingController;
            emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
            emailSettingController.untechable = nil;
            emailSettingController.comingFromSettingsScreen = YES;
            emailSettingController.comingFromChangeEmailScreen = NO;
            [self.navigationController pushViewController:emailSettingController animated:YES];
        }
    }
}

-(IBAction)loginLinkedIn:(id) sender {
    
    [[SocialNetworksStatusModal sharedInstance] loginLinkedIn:sender Controller:self Untechable:untechable];
}

-(IBAction)loginTwitter:(id) sender {

    [[SocialNetworksStatusModal sharedInstance] loginTwitter:sender Controller:self Untechable:untechable];
}

-(IBAction)loginFacebook:(id) sender {
    
    [[SocialNetworksStatusModal sharedInstance] loginFacebook:sender Controller:self Untechable:untechable];
}

@end
