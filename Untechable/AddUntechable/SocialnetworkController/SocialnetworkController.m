//
//  SocialnetworkController.m
//  Untechable
//
//  Created by Muhammad Raheel on 29/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "SocialnetworkController.h"
#import "Common.h"

@interface SocialnetworkController ()

@property (strong, nonatomic) IBOutlet UILabel *lblSetYourStatus;
@property (strong, nonatomic) IBOutlet UITextField *inputFacebook;
@property (strong, nonatomic) IBOutlet UITextField *inputTweet;
@property (strong, nonatomic) IBOutlet UITextField *inputLinkedIn;

@end

@implementation SocialnetworkController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    //[self setDefaultModel];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ________________________     Custom functions    ___________________________
#pragma mark -  UI functions
-(void)updateUI
{
    _lblSetYourStatus.font = [UIFont fontWithName:APP_FONT size:15];
    
    self.inputFacebook.font = [UIFont fontWithName:APP_FONT size:20];
    self.inputTweet.font    = [UIFont fontWithName:APP_FONT size:20];
    self.inputLinkedIn.font = [UIFont fontWithName:APP_FONT size:20];
}
#pragma mark -  Navigation functions

- (void)setNavigationDefaults{
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        
        
        // Left Navigation ________________________________________________________________________________________________________
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_LEFT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(btnBackTouchStart) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(btnBackTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        backButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        NSMutableArray  *leftNavItems  = [NSMutableArray arrayWithObjects:leftBarButton,nil];
        
        [self.navigationItem setLeftBarButtonItems:leftNavItems]; //Left button ___________
        
        
        // Center title ________________________________________
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_FONT_SIZE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = defGreen;
        titleLabel.text = APP_NAME;
        
        
        self.navigationItem.titleView = titleLabel; //Center title ___________
        
        
        // Right Navigation ________________________________________
        finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [finishButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
        finishButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [finishButton setTitle:@"Finish" forState:normal];
        [finishButton setTitleColor:defGray forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [finishButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        finishButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right buttons ___________
        
        
    }
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [finishButton setBackgroundColor:defGreen] : [finishButton setBackgroundColor:[UIColor clearColor]];
}

-(void)btnBackTouchStart{
    [self setBackHighlighted:YES];
}
-(void)btnBackTouchEnd{
    [self setBackHighlighted:NO];
    [self onBack];
}
- (void)setBackHighlighted:(BOOL)highlighted {
    (highlighted) ? [backButton setBackgroundColor:defGreen] : [backButton setBackgroundColor:[UIColor clearColor]];
}

-(void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onFinish{
    
    [self setNextHighlighted:NO];
    
}


@end
