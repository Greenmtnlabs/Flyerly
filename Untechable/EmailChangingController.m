//
//  EmailChangingController.m
//  Untechable
//
//  Created by RIKSOF Developer on 30/01/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "EmailChangingController.h"
#import "SocialnetworkController.h"
#import "Common.h"
#import "EmailSettingController.h"
#import "SocialNetworksStatusModal.h"
#import "SetupGuideFourthView.h"

@interface EmailChangingController ()

@property (strong, nonatomic) IBOutlet UIButton *changeEmailAddress;

@end

@implementation EmailChangingController

@synthesize untechable,emailAddress,emailAddressText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ( [untechable.email isEqualToString:@""] ){
        
        if ( ![untechable.email isEqualToString:@""] && ![untechable.password isEqualToString:@""] ) {
            
            [emailAddress setText:untechable.email];
            
            [emailAddress setText:emailAddressText];
        }
    }else {
        [emailAddress setText:untechable.email];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    // shows navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // adds left button to navigation
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];
        
        // Right Navigation
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 42)];
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        nextButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        // adds right button to navigation
        [self.navigationItem setRightBarButtonItems:rightNavItems];
    }
}

-(IBAction)changeEmail:(id)sender{
    
    EmailSettingController *emailSettingController;
    emailSettingController = [[EmailSettingController alloc]initWithNibName:@"EmailSettingController" bundle:nil];
    emailSettingController.untechable = untechable;
    
    if( [untechable.rUId isEqualToString:@"1"] )
    emailSettingController.comingFrom = @"SetupScreen";
    else
    emailSettingController.comingFrom = @"ContactsListScreen";
    
    [self.navigationController pushViewController:emailSettingController animated:YES];
}

-(void)onNext{
    
    untechable.email = emailAddress.text;
    untechable.password = untechable.password;
    
    if( [untechable.rUId isEqualToString:@"1"] ) {
        
        SetupGuideFourthView *fourthView = [[SetupGuideFourthView alloc] initWithNibName:@"SetupGuideFourthView" bundle:nil];
        fourthView.untechable = untechable;
        [self.navigationController pushViewController:fourthView animated:YES];
        
    } else {
        
        SocialnetworkController *socialnetwork;
        socialnetwork = [[SocialnetworkController alloc]initWithNibName:@"SocialnetworkController" bundle:nil];
        socialnetwork.untechable = untechable;
        [self.navigationController pushViewController:socialnetwork animated:YES];
    }
}

-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
