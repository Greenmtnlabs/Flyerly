
//
//  InAppPurchaseViewController.m
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import "InAppPurchaseViewController.h"


@interface InAppPurchaseViewController ()


@end

@implementation InAppPurchaseViewController

NSMutableArray *productArray;
NSMutableDictionary *userPreviousPurchases;
@synthesize sliderBtn,inAppPurchasePanelButton,tView,Yvalue,contentLoaderIndicatorView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [inAppPurchasePanelButton addTarget:self action:@selector(inAppPurchasePanelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tView setSeparatorColor:[UIColor whiteColor]];
    
	tView.dataSource = self;
	tView.delegate = self;
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
 
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    userPurchases = appDelegate.userPurchases;    
    //[userPurchases setUserPurcahsesFromParse];
    
    NSLog(@"%i",[[PFUser currentUser] sessionToken].length);

    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        [inAppPurchasePanelButton setTitle:(@"RESTORE PURCHASES")];
        
    }else {
        
        [inAppPurchasePanelButton setTitle:(@"Sign In")];
        
    }
    
	
}

- (void) inAppDataLoaded {
    
    [tView reloadData];
    [contentLoaderIndicatorView stopAnimating];
    contentLoaderIndicatorView.hidden = YES;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
       
    //productArray = [self.buttondelegate inAppPurchasePanelContent];
    return  productArray.count;
   
}

- (void)inAppPurchasePanelButtonTapped:(id)sender {
    
        [self.buttondelegate inAppPurchasePanelButtonTappedWasPressed:inAppPurchasePanelButton.currentTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"Cell";
    InAppPurchaseCell *cell = (InAppPurchaseCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell" owner:self options:nil];
        cell = (InAppPurchaseCell *)[nib objectAtIndex:0];
    }
    
    NSDictionary *dict = [productArray objectAtIndex:indexPath.row];
    
    NSString *productIdentifier = [dict objectForKey:@"productidentifier"];
    
    NSString *productImage = @"clip_setting";
    
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        if ( [userPurchases checkKeyExistsInPurchases:productIdentifier] ) {
            productImage = @"clip_setting_selected";
            cell.userInteractionEnabled = NO;
        }
        
    }
    
    [cell setCellValueswithProductTitle:[dict objectForKey:@"packagename"] ProductPrice:[dict objectForKey:@"packageprice"]ProductDescription:[dict objectForKey:@"packagedesciption"] ProductImage:productImage];

    
//    UIImage *imageIcon = [UIImage imageNamed:[dict objectForKey:@"image"]];
//    [tablecell.packageImage setImage:imageIcon];
    
    return cell;
   
}

-(IBAction)hideMe {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [self.view setFrame:CGRectMake(0, [Yvalue integerValue], 320,425 )];
    [UIView commitAnimations];
    
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

- (void) deselect
{
	[self.tView deselectRowAtIndexPath:[self.tView indexPathForSelectedRow] animated:YES];
}

#pragma mark  PURCHASE PRODUCT

-(void)requestProduct {
    
    if ([FlyerlySingleton connected]) {
        
        if (sheetAlreadyOpen)return;
        
        //Check For Crash Maintain
        cancelRequest = NO;
        
        //[self showLoadingIndicator];
        sheetAlreadyOpen =YES;
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
            
            sheetAlreadyOpen = NO;
            
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [self hideLoadingIndicator];
        
    }
}



/* HERE WE PURCHASE PRODUCT FROM APP STORE
 */
-(void)purchaseProductID:(NSString *)pid{
    
    [self showLoadingIndicator];
    
    [[RMStore defaultStore] addPayment:pid success:^(SKPaymentTransaction *transaction) {
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        
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
        //[userPurchases_ setUserPurcahsesFromParse];
        //[self.buttondelegate productSuccesfullyPurchased:pid];
        
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

- (void) purchaseProductAtIndex:(int) index {
    
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    //Getting Selected Product
    NSDictionary *product = [productArray objectAtIndex:index];
    NSString* productIdentifier= product[@"productidentifier"];
    //SKProduct *product = [productArray objectAtIndex:1];
    [self purchaseProductID:productIdentifier];
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
    
    //lockFlyer = NO;
    //[self.tView reloadData];
    [self hideLoadingIndicator];
    
    [[RMStore defaultStore] removeStoreObserver:self];
    
}



@end
