//
//  FlyrViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyrViewController.h"
#import "UserPurchases.h"


@implementation FlyrViewController

NSMutableArray *productArray;
@synthesize tView,searchTextField,flyerPaths;

#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    searching = NO;
    
    FlyerlySingleton *globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
    
    
    self.navigationItem.hidesBackButton = YES;
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.textAlignment = UITextAlignmentLeft;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.tView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:241/255.0 blue:222/255.0 alpha:1.0]];
	tView.dataSource = self;
	tView.delegate = self;
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [searchTextField addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.borderStyle = nil;
    
    lockFlyer = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    searching = NO;
    searchTextField.text = @"";
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Set left bar items
    [self.navigationItem setLeftBarButtonItems: [self leftBarItems]];
    
    // Set right bar items
    [self.navigationItem setRightBarButtonItems: [self rightBarItems]];
    
    //HERE WE GET FLYERS
    flyerPaths = [self getFlyersPaths];
    
    //HERE WE SET SCROLL VIEW POSITION

    if ( flyerPaths.count >= 1 ) {

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [tView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        
        [tView reloadData];
    }
    
    //HERE WE GET USER PURCHASES INFO FROM PARSE
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        UserPurchases *userPurchases_ = appDelegate.userPurchases;
        
        //Checking if user valid purchases
        if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]   ||
             [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"]    ) {
            
            //Unloking features
            lockFlyer = NO;
            [self.tView reloadData];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark  Text Field Delegete

- (void)textFieldTapped:(id)sender {
    
    if (searchTextField.text == nil || [searchTextField.text isEqualToString:@""])
    {
        searching = NO;
        [self.tView reloadData];
        [searchTextField resignFirstResponder];
    }else{
        searching = YES;
        [self searchTableView:[NSString stringWithFormat:@"%@", ((UITextField *)sender).text]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(searching){
        if([string isEqualToString:@"\n"]){
            
            if([searchTextField canResignFirstResponder])
            {
                [searchTextField resignFirstResponder];
            }
        }
    }
    return YES;
}


#pragma mark  custom Methods

- (void) searchTableView:(NSString *)schTxt {
	NSString *sTemp;
    NSString *sTemp1;
	NSString *sTemp2;

	NSString *searchText = searchTextField.text;
   
	searchFlyerPaths = [[NSMutableArray alloc] init];
	
	for (int i =0 ; i < [flyerPaths count] ; i++)
	{
		
        Flyer *fly = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:i]];
        
 		sTemp = [fly getFlyerTitle];
        sTemp1 = [fly getFlyerDescription];
        sTemp2 = [fly getFlyerDate];

        
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange1 = [sTemp1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRange2 = [sTemp2 rangeOfString:searchText options:NSCaseInsensitiveSearch];

        if (titleResultsRange.length > 0 || titleResultsRange1.length > 0 || titleResultsRange2.length > 0){

            [searchFlyerPaths addObject:[flyerPaths objectAtIndex:i]];
        }
        

	}
    [self.tView reloadData];
}


-(IBAction)createFlyer:(id)sender {
    
    cancelRequest = YES;
    NSString *flyPath = [Flyer newFlyerPath];
    
    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;
    
    __weak FlyrViewController *weakSelf = self;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        
        //HERE WE GET FLYERS
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        [weakSelf.tView reloadData];
        
    }];

	[self.navigationController pushViewController:createFlyer animated:YES];
    
}



-(void)goBack{
  	[self.navigationController popViewControllerAnimated:YES];
    cancelRequest = YES;
}


-(NSArray *)leftBarItems{
    
    // Create left bar help button
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [helpButton addTarget:self action:@selector(loadHelpController) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"help_icon"] forState:UIControlStateNormal];
    helpButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
   
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [backButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    return [NSMutableArray arrayWithObjects:backBarButton,leftBarButton,nil];
}

-(void)loadHelpController{
    cancelRequest = YES;
    HelpController *helpController = [[HelpController alloc]initWithNibName:@"HelpController" bundle:nil];
    [self.navigationController pushViewController:helpController animated:NO];
}

- (void) deselect
{
	[self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:YES];
}

-(NSArray *)rightBarItems{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"SAVED";
    self.navigationItem.titleView = label;

    // Create Button
    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    [createButton addTarget:self action:@selector(createFlyer:) forControlEvents:UIControlEventTouchUpInside];
    [createButton setBackgroundImage:[UIImage imageNamed:@"createButton"] forState:UIControlStateNormal];
    createButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *createBarButton = [[UIBarButtonItem alloc] initWithCustomView:createButton];
    
    return [NSMutableArray arrayWithObjects:createBarButton,nil];
}



/*
 * Here we get All Flyers Directories
 * return
 *      Nsarray of Flyers Path
 */
-(NSMutableArray *)getFlyersPaths{
    
    PFUser *user = [PFUser currentUser];
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
    
    NSMutableArray *sortedList = [ Flyer recentFlyerPreview:files.count];
    
    for(int i = 0 ; i < [sortedList count];i++)
    {
        
        //Here we remove File Name from Path
        NSString *pathWithoutFileName = [[sortedList objectAtIndex:i]
                                         stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE] withString:@""];
        [sortedList replaceObjectAtIndex:i withObject:pathWithoutFileName];
    }
    
    
    return sortedList;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searching){
        return  [searchFlyerPaths count];
    }else{
        return  [flyerPaths count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"Cell";
    SaveFlyerCell *cell = (SaveFlyerCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SaveFlyerCell" owner:self options:nil];
        cell = (SaveFlyerCell *)[nib objectAtIndex:0];
    }
    
    if( searching ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[searchFlyerPaths objectAtIndex:indexPath.row]];
            [cell renderCell:flyer LockStatus:lockFlyer];
            [cell.flyerLock addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];

            
        });


        return cell;
        

    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
            [cell renderCell:flyer LockStatus:lockFlyer];
            [cell.flyerLock addTarget:self action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside];
            
        });


         return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
    
    createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    
    // Set CreateFlyer Screen
    createFlyer.flyer = flyer;
    
    __weak FlyrViewController *weakSelf = self;
    __weak CreateFlyerController *weakCreate = createFlyer;
    
    //Here we Manage Block for Update
    [createFlyer setOnFlyerBack:^(NSString *nothing) {
        
        //HERE WE GET FLYERS
        [weakCreate.flyer setRecentFlyer];
        [weakSelf.flyerPaths removeAllObjects];
        weakSelf.flyerPaths = [weakSelf getFlyersPaths];
        [weakSelf.tView reloadData];
        
    }];
    
	[self.navigationController pushViewController:createFlyer animated:YES];

	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView beginUpdates];
	[tableView setEditing:YES animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:
        @[[NSIndexPath indexPathForRow:indexPath.row  inSection:indexPath.section]]
                         withRowAnimation:UITableViewRowAnimationLeft];
        
        // HERE WE REMOVE FLYER FROM DIRECTORY
        if ( searching ) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[searchFlyerPaths objectAtIndex:indexPath.row] error:nil];
            [searchFlyerPaths removeObjectAtIndex:indexPath.row];

        } else {
            
            [[NSFileManager defaultManager] removeItemAtPath:[flyerPaths objectAtIndex:indexPath.row] error:nil];
            [flyerPaths removeObjectAtIndex:indexPath.row];
        }

	}
    
    [tableView setEditing:NO animated:YES];
	[tableView endUpdates];
	[tableView reloadData];
}


- ( void )productSuccesfullyPurchased: (NSString *)productId {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"] ||
        [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {
        
        lockFlyer = NO;
        [self.tView reloadData];
        [inappviewcontroller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- ( void )inAppPurchasePanelContent {
    [inappviewcontroller inAppDataLoaded];
}

/*
 * Here we Open InAppPurchase Panel
 */
-(void)openPanel {
    
    inappviewcontroller = [[[InAppViewController alloc] init] autorelease];
    [self presentModalViewController:inappviewcontroller animated:YES];
    if ( productArray.count == 0 ){
        [inappviewcontroller requestProduct];
    }
    if( productArray.count != 0 ) {
        
        //[inappviewcontroller.contentLoaderIndicatorView stopAnimating];
        //inappviewcontroller.contentLoaderIndicatorView.hidden = YES;
    }
    
    inappviewcontroller.buttondelegate = self;

}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle {
    
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")]) {
        
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak FlyrViewController *flyrViewController = self;
        __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = flyrViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
        
    }else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"RESTORE PURCHASES")]){
        
        
        [inappviewcontroller_ restorePurchase];
    }
}

- (void) userPurchasesLoaded {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    if ( [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyAllDesignBundle"]  ||
         [userPurchases_ checkKeyExistsInPurchases:@"comflyerlyUnlockSavedFlyers"] ) {

        lockFlyer = NO;
        [self.tView reloadData];
        [inappviewcontroller.paidFeaturesTview reloadData];
    }else {
            
            [self presentModalViewController:inappviewcontroller animated:YES];
    }

}

@end



