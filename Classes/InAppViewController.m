
//
//  InAppViewController.m
//  Flyr
//
//  Created by Muhammad Arbab on 5/21/14.
//
//

#import "InAppViewController.h"

@interface InAppViewController ()

@end

@implementation InAppViewController 

NSMutableArray *productArray;
@synthesize freeFeaturesTview,paidFeaturesTview,loginButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [loginButton addTarget:self action:@selector(inAppPurchasePanelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    paidFeaturesTview.dataSource = self;
	paidFeaturesTview.delegate = self;
    freeFeaturesTview.dataSource = self;
	freeFeaturesTview.delegate = self;
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    userPurchases = appDelegate.userPurchases;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken].length != 0) {
        [loginButton setTitle:(@"RESTORE PURCHASES")];
        loginButton.titleLabel.textAlignment = UITextAlignmentCenter;
    }else {
        [loginButton setTitle:(@"Sign In")];
    }
}


/* 
 * Here we hide the InAppViewController
 */
-(IBAction)hideMe {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == paidFeaturesTview)
        return  productArray.count;
    else
        return 0;
    
}

- (void)inAppPurchasePanelButtonTapped:(id)sender {
    
    [self.buttondelegate inAppPurchasePanelButtonTappedWasPressed:loginButton.currentTitle];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowIndex = indexPath.row;
    //if not cancel and Restore button presses
    if(rowIndex == 0 || rowIndex == 1 || rowIndex == 2) {
        
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) {
            
            [self purchaseProductAtIndex:rowIndex];
            
        }else {
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Please sign in first"
                                                                message: @"To purchase any product, you need to sign in first."
                                                               delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
            
            [someError show];
        }
    }
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
}

- (void) purchaseProductAtIndex:(int) index {
    
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    
    //Getting Selected Product
    NSDictionary *product = [productArray objectAtIndex:index];
    NSString* productIdentifier= product[@"productidentifier"];
    
    //Purchasing the product on the basis of product identifier
    [self purchaseProductID:productIdentifier];
}

/* HERE WE SHOWING DESELECT ANIMATION ON TABLEVIEW CELL
 */
- (void) deselect
{
    //Showing deselect animation on a paidFeaturesTview cell
	[self.paidFeaturesTview deselectRowAtIndexPath:[self.paidFeaturesTview indexPathForSelectedRow] animated:YES];
}


/* HERE WE PURCHASE PRODUCT FROM APP STORE
 */
-(void)purchaseProductID:(NSString *)pid{
    
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
        // Showing action sheet after succesfull sign in
        [userPurchases setUserPurcahsesFromParse];
        [self.buttondelegate productSuccesfullyPurchased:pid];
        
            
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        NSLog(@"Something went wrong");
        
    }];
}

/*
 * Here we update info to Parse account
 */
-(void)updateParse {
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    __weak UserPurchases *userPurchases_ = appDelegate.userPurchases;
    
    //HERE WE UPDATE PARSE ACCOUNT
    PFUser *user = [PFUser currentUser];
    //PFQuery *query = [PFQuery queryWithClassName:@"InApp"];
    //[query whereKey:@"user" equalTo:user];
    //[query getFirstObjectInBackgroundWithBlock:^(PFObject *InApp, NSError *error) {
    
    PFObject *inApp = [[PFObject alloc] initWithClassName:@"InApp"];
    [inApp setObject:user forKey:@"user"];
    inApp[@"json"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"InAppPurchases"];
    [inApp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if( succeeded ) {
            [userPurchases_ setUserPurcahsesFromParse];
        }
        
    }];
    
    [[RMStore defaultStore] removeStoreObserver:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == paidFeaturesTview){
        
        static NSString *cellId = @"InAppPurchaseCell";
        InAppPurchaseCell *cell = (InAppPurchaseCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell" owner:self options:nil];
            cell = (InAppPurchaseCell *)[nib objectAtIndex:0];
        }
        
        // Getting the product against tapped/selected cell
        NSDictionary *product = [productArray objectAtIndex:indexPath.row];
        
        NSString *productIdentifier = [product objectForKey:@"productidentifier"];
        
        // Checking if user is valid or anonymous
        if ([[PFUser currentUser] sessionToken].length != 0) {
            
            // Checking if user have  valid purchases
            if ( [userPurchases checkKeyExistsInPurchases:productIdentifier] ) {
                
                // Disabling the cellview user interection if user already have valid purchases
                cell.userInteractionEnabled = NO;
            }
            
        }
        
        //Setting the packagename,packageprice,packagedesciption values for cell view
        [cell setCellValueswithProductTitle:[product objectForKey:@"packagename"] ProductPrice:[product objectForKey:@"packageprice"]ProductDescription:[product objectForKey:@"packagedesciption"]];
        
        return cell;
    }else {
      return nil;
    }
   
}

#pragma mark  PURCHASE PRODUCT

-(void)requestProduct {
    
    if ([FlyerlySingleton connected]) {
        
        //Check For Crash Maintain
        cancelRequest = NO;
        
        //These are over Products on App Store
        NSSet *productIdentifiers = [NSSet setWithArray:@[@"com.flyerly.AllDesignBundle",@"com.flyerly.UnlockSavedFlyers",@"com.flyerly.UnlockCreateVideoFlyerOption"]];
        
        [[RMStore defaultStore] requestProducts:productIdentifiers success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            
            if (cancelRequest) return ;
            
            NSLog(@"Products loaded");
            
            requestedProducts = products;
            bool disablePurchase = ([[PFUser currentUser] sessionToken].length == 0);
            
            NSString *sheetTitle = @"Choose Product";
            
            if (disablePurchase) {
                sheetTitle = @"This feature requires Sign In";
            }
            
            productArray = [[NSMutableArray alloc] init];
            for(SKProduct *product in products)
            {
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      product.localizedTitle,@"packagename",
                                      product.priceAsString,@"packageprice" ,
                                      product.localizedDescription,@"packagedesciption",
                                      product.productIdentifier,@"productidentifier" , nil];
                
                
                [productArray addObject:dict];
            }
            
            [self.buttondelegate inAppPurchasePanelContent];
            
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [self hideLoadingIndicator];
        
    }
}
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

/*
 * RELODING PAIDFEATIURES TABLEVIEW AFTER GETTING PRODUCTS FROM APPSTORE
 */
- (void) inAppDataLoaded {
    
    // Reloading the paid features table view
    [paidFeaturesTview reloadData];
}


@end