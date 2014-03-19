//
//  FlyrViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlyrViewController.h"


@implementation FlyrViewController
@synthesize tView,searchTextField;


#pragma mark  View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    searching = NO;
    
    FlyerlySingleton *globle = [FlyerlySingleton RetrieveSingleton];
    [self.view setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
    
    self.navigationItem.hidesBackButton = YES;
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.textAlignment = UITextAlignmentLeft;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    
	[self.tView setBackgroundColor:[globle colorWithHexString:@"f5f1de"]];
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
    if (flyerPaths.count != 0) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [tView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        
        [tView reloadData];
    }
    
    //HERE WE GET USER PURCHASES INFO FROM PARSE
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
        
        NSMutableDictionary *oldPurchases = [[NSUserDefaults standardUserDefaults] valueForKey:@"InAppPurchases"];
        
        if ([oldPurchases objectForKey:@"comflyerlyAllDesignBundle"] ||  [oldPurchases objectForKey:@"comflyerlyUnlockSavedFlyers"]) {
        
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
    NSLog(@"%@",searchTextField.text);
    
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
     NSLog(@"%@", searchTextField.text);
   

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
    
    NSString *flyPath = [Flyer newFlyerPath];
    
    //Here We set Source for Flyer screen
    flyer = [[Flyer alloc]initWithPath:flyPath];
    
	createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    createFlyer.flyerPath = flyPath;
    createFlyer.flyer = flyer;
	[self.navigationController pushViewController:createFlyer animated:YES];
    
}



-(void)goBack{
  	[self.navigationController popViewControllerAnimated:YES];
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
 * Here we update info to Parse account
 */
-(void)updateParse {
    
    //HERE WE UPDATE PARSE ACCOUNT
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"InApp"];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *InApp, NSError *error) {
        
        InApp[@"json"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"InAppPurchases"];
        [InApp saveInBackground];
        lockFlyer = NO;
        [self.tView reloadData];
        [self hideLoadingIndicator];
        
    }];
    
    [[RMStore defaultStore] removeStoreObserver:self];

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
            [cell.flyerLock addTarget:self action:@selector(requestProduct) forControlEvents:UIControlEventTouchUpInside];

            
        });


        return cell;
        

    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            
            flyer = [[Flyer alloc] initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
            [cell renderCell:flyer LockStatus:lockFlyer];
            [cell.flyerLock addTarget:self action:@selector(requestProduct) forControlEvents:UIControlEventTouchUpInside];
            
        });


         return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    flyer = [[Flyer alloc]initWithPath:[flyerPaths objectAtIndex:indexPath.row]];
    
    createFlyer = [[CreateFlyerController alloc]initWithNibName:@"CreateFlyerController" bundle:nil];
    
    // Set CreateFlyer Screen
    createFlyer.flyer = flyer;
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


#pragma mark  PURCHASE PRODUCT

-(void)requestProduct {
    

    if (sheetAlreadyOpen)return;
        
        
    [self showLoadingIndicator];
    sheetAlreadyOpen =YES;
    //These are over Products on App Store
    NSSet *products = [NSSet setWithArray:@[@"com.flyerly.AllDesignBundle",@"com.flyerly.UnlockSavedFlyers"]];
    
    
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        NSLog(@"Products loaded");
        
        requestedProducts = products;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Product" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
        for(SKProduct *product in products)
        {
            
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@",product.localizedTitle,product.price]];
        }
        
        [actionSheet addButtonWithTitle:@"Restore Purchase"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        
        [actionSheet showInView:self.view];
        [self hideLoadingIndicator];
        sheetAlreadyOpen = NO;
        
        
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
    }];

}




/* HERE WE PURCHASE PRODUCT FROM APP STORE
 */
-(void)purchaseProductID:(NSString *)pid{

    [self showLoadingIndicator];
    
    [[RMStore defaultStore] addPayment:pid success:^(SKPaymentTransaction *transaction) {
        
        
        NSLog(@"Product purchased");
        
        NSString *strWithOutDot = [pid stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
            
            NSMutableDictionary *userPurchase =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"InAppPurchases"]];
            
            [userPurchase setValue:@"1" forKey:strWithOutDot];
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
            
        
        }else {
            NSMutableDictionary *userPurchase =[[NSMutableDictionary alloc] init];
            [userPurchase setValue:@"1" forKey:strWithOutDot];
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
        
        }

        //Saved in Parse Account
        [self updateParse];
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        NSLog(@"Something went wrong");
        
    }];
}

- (void)storeProductsRequestFailed:(NSNotification*)notification {
    NSError *error = notification.storeError;
    NSLog(@"%@", error);
}

- (void)storeProductsRequestFinished:(NSNotification*)notification {
    //NSArray *products = notification.products;
}


/**
 * clickedButtonAtIndex (UIActionSheet)
 *
 * Handle the button clicks from mode of getting out selection.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    //if not cancel and Restore button presses
    if(buttonIndex != 2 && buttonIndex != 3) {
        
        //This line pop up login screen if user not exist
        [[RMStore defaultStore] addStoreObserver:self];
        
        //Getting Selected Product
        SKProduct *product = [requestedProducts objectAtIndex:buttonIndex];
        
        [self purchaseProductID:product.productIdentifier];
        
    }
    
    //For Restore Purchase
    if(buttonIndex == 2 ) {
        [self restorePurchase];
    }
    
    
}

#pragma mark  RESTORE PURCHASE

/* HERE WE RESTORE PURCHASE PRODUCT FROM APP STORE
 */
-(void)restorePurchase {
    
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^{
        
        //HERE WE GET SHARED INTANCE OF _persistence WHICH WE LINKED IN FlyrAppDelegate
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        NSArray *productIdentifiers = [[appDelegate._persistence purchasedProductIdentifiers] allObjects];

        if (productIdentifiers.count >= 1) {
            
            [self showLoadingIndicator];
            
            NSMutableDictionary *userPurchase;
            if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"]){
                userPurchase =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"InAppPurchases"]];
            }else {
                userPurchase =[[NSMutableDictionary alloc] init];
            }
            
            for (int i = 0; i < productIdentifiers.count; i++) {
                
                NSString *strWithOutDot = [[productIdentifiers objectAtIndex:i] stringByReplacingOccurrencesOfString:@"." withString:@""];
                 [userPurchase setValue:@"1" forKey:strWithOutDot];
            }
            
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
            [self updateParse];
        }
        
        NSLog(@"Transactions restored");
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

- (void)storeRestoreTransactionsFailed:(NSNotification*)notification;
{
 //   NSError *error = notification.storeError;
}

- (void)storeRestoreTransactionsFinished:(NSNotification*)notification {}


#pragma mark RMStoreObserver


- (void)storePaymentTransactionFinished:(NSNotification*)notification
{


}


@end



