//
//  SetupGuideThirdView.m
//  Untechable
//
//  Created by RIKSOF Developer on 6/22/15.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "SetupGuideThirdView.h"
#import "SetupGuideSecondViewController.h"
#import "ContactsListControllerViewController.h"
#import "UntechablesList.h"
#import "SetupGuideFourthView.h"

@interface SetupGuideThirdView () {
    
    ContactsListControllerViewController *viewControllerToAdd;
}
@end

@implementation SetupGuideThirdView

@synthesize untechable;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //navigation related Stuff
    [self setNavigationBarItems];
    
    //setting up a view and showing contact list in it
    [self setupContactView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

-(void)setupContactView {
    
     viewControllerToAdd = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
    
    
    
    viewControllerToAdd.untechable = untechable;
    //viewControllerToAdd.untechable.untechableModel = untechable.untechableModel;
    
    [viewControllerToAdd willMoveToParentViewController:self];
    [self.viewForContacts addSubview:viewControllerToAdd.view];
    [self addChildViewController:viewControllerToAdd];

    [viewControllerToAdd didMoveToParentViewController:self];
    
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
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        // }
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

    [self saveBeforeGoing];
    
    if( viewControllerToAdd.selectedAnyEmail ) {
        [viewControllerToAdd showEmailSetupScreen:YES];
    } else {
    
        SetupGuideFourthView *fourthScreen = [[SetupGuideFourthView alloc] initWithNibName:@"SetupGuideFourthView" bundle:nil];
        fourthScreen.untechable = untechable;
        [self.navigationController pushViewController:fourthScreen animated:YES];
    }
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    [self saveBeforeGoing];
    
}

-(void)saveBeforeGoing {
    
   NSMutableArray *customizedContactsFromSetup = [viewControllerToAdd currentlyEditingContacts];
    
    untechable.customizedContactsForCurrentSession = customizedContactsFromSetup;
    
    NSString *customizeContactsForCurrentSession = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsFromSetup];

    
    
    
    untechable.untechableModel.selectedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString2:untechable.selectedContacts];
    
    //untechable.untechableModel.selectedContacts = customizeContactsForCurrentSession;
    
    [[NSUserDefaults standardUserDefaults] setObject:untechable.untechableModel.selectedContacts forKey:@"customizedContactsFromSetup"];
    [[NSUserDefaults standardUserDefaults] setObject:untechable.untechableModel.selectedContacts forKey:@"customizedContactsFromSetup2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

@end
