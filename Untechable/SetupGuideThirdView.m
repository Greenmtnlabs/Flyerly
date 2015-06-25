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
#import "AddUntechableController.h"
#import "ContactsCustomizedModal.h"

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
    [untechable printNavigation:[self navigationController]];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNavigation:@"viewDidLoad"];
}

-(void)setupContactView {
    
     viewControllerToAdd = [[ContactsListControllerViewController alloc] initWithNibName:@"ContactsListControllerViewController" bundle:nil];
    
    viewControllerToAdd.untechable = untechable;
    
    [viewControllerToAdd willMoveToParentViewController:self];
    [self.viewForContacts addSubview:viewControllerToAdd.view];
    [self addChildViewController:viewControllerToAdd];
    //self.view.bounds = viewControllerToAdd.view.bounds;

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
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_DONE_TXT forState:normal];
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
    UIAlertView *congratesAlert = [[UIAlertView alloc]initWithTitle:@"Congrates" message:@"Thank you for setting up your Untech settings. Now you can easily become Untechable whenever you need a break from technology in order to spend more time with the people & experiencing the things that are most important." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [congratesAlert show];
    
}

-(void) goBack {
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    [self saveBeforeGoing];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    //we're assuming cancel as done because there is only one button on the alert
    if( buttonIndex == [alertView cancelButtonIndex] ) {
        AddUntechableController *untechScreen = [[AddUntechableController alloc] initWithNibName:@"AddUntechableController" bundle:nil];
        untechScreen.untechable = untechable;
        [self.navigationController pushViewController:untechScreen animated:YES];
    }
}

-(void)saveBeforeGoing {
    
    NSMutableArray *customizedContactsFromSetup = [viewControllerToAdd currentlyEditingContacts];
    untechable.customizedContactsForCurrentSession = customizedContactsFromSetup;
    NSString *customizeContactsForCurrentSession = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsFromSetup];
    
    if( customizeContactsForCurrentSession != nil ) {
        untechable.customizedContacts = customizeContactsForCurrentSession;
        [[NSUserDefaults standardUserDefaults] setObject:customizeContactsForCurrentSession forKey:@"customizedContactsFromSetup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        customizeContactsForCurrentSession = @"";
    }
}


@end
