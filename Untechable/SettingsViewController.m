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

@interface SettingsViewController () {
    
    NSMutableArray *socialIcons;
    NSMutableArray *socialNetworksName;
}

@end

@implementation SettingsViewController

@synthesize untechable,socialNetworksTable;

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
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [socialNetworksTable reloadData];
}

-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SettingsCellView";
    SettingsCellView *cell = (SettingsCellView *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        if( IS_IPHONE_5 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6 ){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView-iPhone6" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else if ( IS_IPHONE_6_PLUS ) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView-iPhone6-Plus" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        } else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCellView" owner:self options:nil];
            cell = (SettingsCellView *)[nib objectAtIndex:0];
        }
    }
    
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allValues]);
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    
    if ( indexPath.row == 0 ){
    
        NSString *savedFbAuth = [[SocialNetworksStatusModal sharedInstance] getFbAuth];
        NSString *savedFbAuthExpiryTs = [[SocialNetworksStatusModal sharedInstance] getFbAuthExpiryTs];
        
        if ( [savedFbAuth isEqualToString:@""] || [savedFbAuthExpiryTs isEqualToString:@""] )
        {
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0 NetworkImage:@"facebook@2x.png"];
        }else
        {
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1 NetworkImage:@"facebook@2x.png"];
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginFacebook:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ( indexPath.row == 1 ){
        
        NSString *savedTwitterAuth = [[SocialNetworksStatusModal sharedInstance] getTwitterAuth];
        NSString *savedTwitterAuthTokkenSecerate = [[SocialNetworksStatusModal sharedInstance] getTwitterAuthTokkenSecerate];
        
        if ( [savedTwitterAuth isEqualToString:@""] || [savedTwitterAuthTokkenSecerate isEqualToString:@""]  )
        {
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0 NetworkImage:@"twitter@2x.png"];
        }else
        {
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1 NetworkImage:@"twitter@2x.png"];
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginTwitter:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ( indexPath.row == 2 ){
        
        if ( ![keys containsObject:@"linkedinAuth"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinAuth"] isEqualToString:@""] )
        {
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0 NetworkImage:@"linkedin@2x.png"];
            
        }else if ( [keys containsObject:@"linkedinAuth"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinAuth"] isEqualToString:@""] )
        {
            
             [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1 NetworkImage:@"linkedin@2x.png"];
            
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(loginLinkedIn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ( indexPath.row == 3 ){
        
        if (  ![keys containsObject:@"email_address"]   ||
              ![keys containsObject:@"email_password"]  ||
              [[[NSUserDefaults standardUserDefaults] objectForKey:@"email_address"] isEqualToString:@""] ||
              [[[NSUserDefaults standardUserDefaults] objectForKey:@"email_password"] isEqualToString:@""] ){
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:0 NetworkImage:@"emailic@2x.png"];
            
        }else {
            
            [cell setCellValueswithSocialNetworkName :[socialNetworksName objectAtIndex:indexPath.row] LoginStatus:1 NetworkImage:@"emailic@2x.png"];
            
        }
        
        [cell.socialNetworkButton addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(IBAction)emailLogin:(id)sender {
    
    UIButton *emailButton = (UIButton *) sender;
    
    if ( [emailButton.titleLabel.text isEqualToString:@"Log Out"] ){
        
        if ( ![[[NSUserDefaults standardUserDefaults] objectForKey:@"email_address"] isEqualToString:@""] ||
            ![[[NSUserDefaults standardUserDefaults] objectForKey:@"email_password"] isEqualToString:@""] ){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"email_address"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"email_password"];
            
            untechable.email = @"";
            untechable.password = @"";
        }
        
        [emailButton setTitle:@"Log In" forState:UIControlStateNormal];
    }
    
    if ( [emailButton.titleLabel.text isEqualToString:@"Log In"]  ){
        
        if ( [untechable.email isEqualToString:@""] || [untechable.password isEqualToString:@""] ){
            
            EmailSettingController *emailSettingController;
            emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
            emailSettingController.untechable = untechable;
            emailSettingController.comingFromSettingsScreen = YES;
            emailSettingController.comingFromChangeEmailScreen = NO;
            [self.navigationController pushViewController:emailSettingController animated:YES];
        }
    }
}



-(IBAction)loginTwitter:(id) sender {

    [[SocialNetworksStatusModal sharedInstance] loginTwitter:sender Controller:self];
}

-(IBAction)loginFacebook:(id) sender {
    
    [[SocialNetworksStatusModal sharedInstance] loginFacebook:sender Controller:self];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return number of rows;
    return  4;
}

@end
