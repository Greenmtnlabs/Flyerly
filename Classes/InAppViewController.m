
//
//  InAppViewController.m
//  Flyr
//
//  Created by Muhammad Arbab on 5/21/14.
//
//

#import "InAppViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "AssetGroupViewControllerWithSearchFeild.h"

@interface InAppViewController () {
    NSMutableArray *productArray;
    NSArray *freeFeaturesArray;
    NSString *cellDescriptionForRefrelFeature;
    NSString *productIdentifier;
    NSMutableArray *productIdentifiers;
}

@end

@implementation InAppViewController 

@synthesize freeFeaturesTview,paidFeaturesTview,loginButton,completeDesignBundleButton,loadingIndicator,isFromStockPhoto;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if([productIdentifier length] > 0){
        return;
    }
    [loginButton addTarget:self action:@selector(inAppPurchasePanelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    paidFeaturesTview.dataSource = self;
	paidFeaturesTview.delegate = self;
    freeFeaturesTview.dataSource = self;
	freeFeaturesTview.delegate = self;
    
    // Find out the path of free-features.plist
    NSString *freeFeaturesPlistPath = [[NSBundle mainBundle] pathForResource:@"free-features" ofType:@"plist"];
    freeFeaturesArray = [[NSArray alloc] initWithContentsOfFile:freeFeaturesPlistPath];
    
    userPurchases = [UserPurchases getInstance];
    
    // setting border for login/restore purchases button
    loginButton.layer.borderWidth=1.0f;
    [loginButton.layer setCornerRadius:3.0];
    loginButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([productIdentifier length] > 0){
        return;
    }
    
    [loginButton setTitle:(@"Restore Purchases")];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             if (objects.count)
             {
                 for (PFObject *object in objects)
                 {
                     NSLog(@"ParseUser unique object ID: %@", object.objectId);
                     
                     PFQuery *query = [PFUser  query];
                     [query whereKey:@"objectId" equalTo:object.objectId];
                     [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                      {
                          if (!error)
                          {
                              NSMutableDictionary *counterDictionary = [object valueForKey:@"estimatedData"];
                              int refrelCounter = [[counterDictionary objectForKey:@"inviteCounter"] intValue];
                              
                              if ( refrelCounter >= 20 )
                              {
                                  //Setting the feature name,feature description values for cell view using plist
                                  cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"You have sucessfully unlocked Design Bundle feature by refreing friends.Enjoy!"];
                                  
                              }else if ( refrelCounter <= 0 ){
                                  
                                  cellDescriptionForRefrelFeature = [NSString stringWithFormat: @"Invite 20 people to %@ and unlock Design Bundle feature for FREE!", APP_NAME ] ;
                              }
                              else if ( refrelCounter > 0 && refrelCounter < 20 )
                              {
                                 int moreToInvite = 20 - refrelCounter;
                                 cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"Invite %d more people to %@ and unlock Design Bundle feature for FREE!", moreToInvite, APP_NAME];
                              }
                              
                              [freeFeaturesTview reloadData];
                          }
                      }];
                 }
             }
         }
     }];
    }else {
       cellDescriptionForRefrelFeature = [NSString stringWithFormat:@"Invite 20 more people to %@ and unlock Design Bundle feature for FREE!", APP_NAME];
    }
}

/*
 * Reloads Array of In-App Purchase IDs
 */

-(void)reloadInAppProductIDsArray{

    productIdentifiers = [[NSMutableArray alloc] initWithObjects:BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION,BUNDLE_IDENTIFIER_ALL_DESIGN, BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_UNLOCK_VIDEO, BUNDLE_IDENTIFIER_AD_REMOVAL,PRODUCT_ICON_SELETED, nil];
}


/*
 * Here we hide the InAppViewController
 */
-(IBAction)hideMe {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.buttondelegate inAppPanelDismissed];
}

-(IBAction)goToTermsAndServiceScreen
{
    [self hideMe];
    UIViewController *cont = (UIViewController *)self.buttondelegate;
    UINavigationController *navigationController = cont.navigationController;
    [navigationController pushViewController:[[TermsOfServiceViewController alloc] initWithNibName:@"TermsOfServiceViewController" bundle:nil] animated:YES];    
}

/*
 * Here we
 */
-(IBAction)purchaseCompleteBundle
{
    [self purchaseProductAtIndex:0];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == paidFeaturesTview)
        return  (productArray == nil) ? 0 : productArray.count;
    else {
        // Find out the path of recipes.plist
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"free-features" ofType:@"plist"];
        NSArray *contentArray = [NSArray arrayWithContentsOfFile:plistPath];
        return [contentArray count];
        
    }
    
}

- (void)inAppPurchasePanelButtonTapped:(id)sender {
    
    [self.buttondelegate inAppPurchasePanelButtonTappedWasPressed:loginButton.currentTitle];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowIndex = (int) indexPath.row;
    
    //if not cancel and Restore button presses
    if(rowIndex >= 0 || rowIndex <= 5) {
        
        // Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) { // UserType = REGISTERED for logged in user
            [[NSUserDefaults standardUserDefaults]setValue: REGISTERED forKey: @"UserType"];
        } else { // UserType = ANONYMOUS for not logged in user
            [[NSUserDefaults standardUserDefaults]setValue: ANONYMOUS forKey: @"UserType"];
        }
        
        //Getting Selected Product
        NSDictionary *product = [productArray objectAtIndex:rowIndex];
        NSString* prodIdentifier = product[@"productidentifier"];
        
        if ( ! ([prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION] // Monthly Subscription
                || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION] // Yearly Subscription
                || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_AD_REMOVAL] // Ad Removal Subscription
                ) &&
            [userPurchases checkKeyExistsInPurchases:productIdentifier] )
        {
            
            // show alert that item has already been purchased
            [self showAlreadyPurchasedAlert];
            
        } else if( ([prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION] // Monthly Subscription
                    || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION] // Yearly Subscription
                    || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_AD_REMOVAL] // Ad Removal Subscription
                    ) &&
                  [userPurchases isSubscriptionValid]) {
            
            // show alert that item has already been purchased
            [self showAlreadyPurchasedAlert];
            
        }
        else if([prodIdentifier isEqualToString: PRODUCT_ICON_SELETED] && !isFromStockPhoto)
        {
            AssetGroupViewControllerWithSearchFeild *buyImagesController= [[AssetGroupViewControllerWithSearchFeild alloc]initWithNibName:@"AssetGroupViewControllerWithSearchFeild" bundle:nil];
            buyImagesController.onImageTaken = self.onImageTaken;
            buyImagesController.desiredImageSize = self.desiredImageSize;
            buyImagesController.isFromInApp = true;
            [self hideMe];
            UIViewController *cont = (UIViewController *)self.buttondelegate;
            UINavigationController *navigationController = cont.navigationController;
            [navigationController pushViewController:buyImagesController animated:YES];
        }
        else
        {
            
            [self purchaseProductAtIndex:rowIndex];
            
        }

    }
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
}

- (void) purchaseProductAtIndex:(int) index{
    
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    
    //Getting Selected Product
    NSDictionary *product = [productArray objectAtIndex:index];
    NSString* prodIdentifier= product[@"productidentifier"];
    
    //Purchasing the product on the basis of product identifier
    [self purchaseProductID:prodIdentifier];
}

-(void) purchaseProductByID:(NSString *) identifier{
    
    
    productIdentifier = identifier;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Would you like to buy Ad Removal in app for $4.99?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) { // UserType = REGISTERED for logged in user
            [[NSUserDefaults standardUserDefaults]setValue: REGISTERED forKey: @"UserType"];
        }
        else
        { // UserType = ANONYMOUS for not logged in user
            [[NSUserDefaults standardUserDefaults]setValue: ANONYMOUS forKey: @"UserType"];
        }
        
        //Getting Selected Product
        NSDictionary *product = [productArray objectAtIndex:4];
        NSString* prodIdentifier = product[@"productidentifier"];
        
        if ( ! ([prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION ] // Monthly Subscription
                || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION] // Yearly Subscription
                || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_AD_REMOVAL] // Ad Removal Subscription
                ) &&
            [userPurchases checkKeyExistsInPurchases:productIdentifier] )  {
            
            // show alert that item has already been purchased
            [self showAlreadyPurchasedAlert];
            
        } else if(! ([prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION] // Monthly Subscription
                    || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION] // Yearly Subscription
                    || [prodIdentifier isEqualToString: BUNDLE_IDENTIFIER_AD_REMOVAL] // Ad Removal Subscription
                    ) &&
                  [userPurchases isSubscriptionValid]) {
            
            // show alert that item has already been purchased
            [self showAlreadyPurchasedAlert];
            
        } else
        {
            [self purchaseProductID:productIdentifier];
        }

    }
}

/* HERE WE SHOWING DESELECT ANIMATION ON TABLEVIEW CELL
 */
- (void) deselect
{
    //Showing deselect animation on a paidFeaturesTview cell
	[self.paidFeaturesTview deselectRowAtIndexPath:[self.paidFeaturesTview indexPathForSelectedRow] animated:YES];
}


/* 
 HERE WE PURCHASE PRODUCT FROM APP STORE
 When user tap on product for purchase
 */
-(void)purchaseProductID:(NSString *)pid
{
        [[RMStore defaultStore] addPayment:pid success:^(SKPaymentTransaction *transaction) {
        
        NSLog(@"Product purchased");
        
        NSString *strWithOutDot = [pid stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"])
        {
            NSMutableDictionary *userPurchase;
//            if([[[NSUserDefaults standardUserDefaults] stringForKey:@"UserType"] isEqualToString: REGISTERED])
//            {
                userPurchase = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"InAppPurchases"]];
//            }
//            else
//            {
//                userPurchase = [[NSMutableDictionary alloc] init];
//            }
            
            [userPurchase setValue:@"1" forKey:strWithOutDot];
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
            
        }
        else
        {
            NSMutableDictionary *userPurchase =[[NSMutableDictionary alloc] init];
            [userPurchase setValue:@"1" forKey:strWithOutDot];
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
            
        }
//        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"UserType"] isEqualToString: REGISTERED])
//        { // Update parse only for logged in users
            //Saved in Parse Account
            [self updateParse];
            // Showing action sheet after succesfull sign in
            [userPurchases setUserPurcahsesFromParse];
       // }
        [self.buttondelegate productSuccesfullyPurchased:pid];
        
            
    } failure:^(SKPaymentTransaction *transaction, NSError *error)
    {
        NSLog(@"Something went wrong");
    }];
}

/*
 * Here we update info to Parse account
 */
-(void)updateParse {
    
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
    //HERE WE UPDATE PARSE ACCOUNT
    PFUser *user = [PFUser currentUser];
    
    PFObject *inApp = [[PFObject alloc] initWithClassName:@"InApp"];
    [inApp setObject:user forKey:@"user"];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"InAppPurchases"]) {
        inApp[@"json"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"InAppPurchases"];
    }
//    [inApp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//    {
//        if(succeeded)
//        {
            [userPurchases_ setUserPurcahsesFromParse];
//        }
//    }];
    
    [[RMStore defaultStore] removeStoreObserver:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.paidFeaturesTview] )
    {
        static NSString *cellId = @"InAppPurchaseCell";
        InAppPurchaseCell *inAppCell = (InAppPurchaseCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        [inAppCell setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *nib;
        if (inAppCell == nil) {
            if ( IS_IPHONE_5 || IS_IPHONE_4) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell" owner:self options:nil];
            }else if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell-iPhone6" owner:self options:nil];
            }
            inAppCell = (InAppPurchaseCell *)[nib objectAtIndex:0];
        }
        
        // Getting the product against tapped/selected cell
        NSDictionary *product = [productArray objectAtIndex:indexPath.row];
        
        if([[product objectForKey:@"productidentifier"] isEqualToString: BUNDLE_IDENTIFIER_ALL_DESIGN]) { // All Design Subscription
            [completeDesignBundleButton setTitle: [NSString stringWithFormat:@"Help us grow %@!", APP_NAME]];
            [completeDesignBundleButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        } else if([[product objectForKey:@"productidentifier"] isEqualToString: BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION]) { // Yearly Subscription
            inAppCell.backgroundColor = [UIColor grayColor];//heighlight the Yearly subscription cell
        }
        //Setting the packagename,packageprice,packagedesciption values for cell view
        [inAppCell setCellValueswithProductTitle: [product objectForKey:@"productidentifier"] Title:[product objectForKey:@"packagename"] ProductPrice:[product objectForKey:@"packageprice"] ProductDescription:[product objectForKey:@"packagedesciption"]];
        
        [loadingIndicator stopAnimating];
        return inAppCell;
    }else {
        
        static NSString *cellId = @"FreeFeatureCell";
        FreeFeatureCell *freeFeatureCell = (FreeFeatureCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        [freeFeatureCell setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *nib;
        if (freeFeatureCell == nil)
        {
            if (IS_IPHONE_5 || IS_IPHONE_4)
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell" owner:self options:nil];
            }else if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell-iPhone6" owner:self options:nil];
            }
            freeFeatureCell = (FreeFeatureCell *)[nib objectAtIndex:0];
            if ( indexPath.row == 6 )
            {
                NSDictionary *freeFeatuersDictionary = [freeFeaturesArray objectAtIndex:indexPath.row];
                NSArray* freeFeatures = [freeFeatuersDictionary allKeys];
                
                [freeFeatureCell setCellValueswithProductTitle:freeFeatures[0] ProductDescription:cellDescriptionForRefrelFeature];
            }else {
                
                NSDictionary *freeFeatuersDictionary = [freeFeaturesArray objectAtIndex:indexPath.row];
                NSArray* freeFeatures = [freeFeatuersDictionary allKeys];
                //Setting the feature name,feature description values for cell view using plist
                [freeFeatureCell setCellValueswithProductTitle:freeFeatures[0] ProductDescription:[freeFeatuersDictionary objectForKey:freeFeatures[0]]];
            }
        }
        return freeFeatureCell;
    }
}


#pragma mark  PURCHASE PRODUCT
/* Open in app panel with request product details */
-(void)requestProduct {
    
    if ([FlyerlySingleton connected])
    {
        // reloads array of in-app purchase IDs
        [self reloadInAppProductIDsArray];
        
        //Check For Crash Maintain
        cancelRequest = NO;
        
        //These are over Products on App Store
        NSSet *productIdentifiersSet = [NSSet setWithArray:productIdentifiers];
        
        [[RMStore defaultStore] requestProducts:productIdentifiersSet success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            
            if (cancelRequest) return ;
            
            NSLog(@"Products loaded");
            
            requestedProducts = products;
            
            productArray = [[NSMutableArray alloc] init];
            
            for(NSString *identifier in productIdentifiers){
                    for(SKProduct *product in products)
                    {
                        if( [identifier isEqualToString:product.productIdentifier]){
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  product.localizedTitle,@"packagename",
                                                  product.priceAsString,@"packageprice" ,
                                                  product.localizedDescription,@"packagedesciption",
                                                  product.productIdentifier,@"productidentifier" , nil];
           
                            [productArray addObject:dict];
                            break;
                        }
                    }
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
        
        // reloads array of in-app purchase IDs
        [self reloadInAppProductIDsArray];
        
        //HERE WE GET SHARED INTANCE OF _persistence WHICH WE LINKED IN FlyrAppDelegate
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        
        if (productIdentifiers.count >= 1)
        {
            [self showLoadingIndicator];
            
            NSMutableDictionary *userPurchase;
            
            if(![[NSUserDefaults standardUserDefaults] stringForKey:@"InAppPurchases"])
            {
                userPurchase =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"InAppPurchases"]];
            }
            else
            {
                userPurchase =[[NSMutableDictionary alloc] init];
            }
            
            for (int i = 0; i < productIdentifiers.count; i++)
            {
                if( [appDelegate._persistence isPurchasedProductOfIdentifier:[productIdentifiers objectAtIndex:i] ])
                {
                    NSString *strWithOutDot = [[productIdentifiers objectAtIndex:i] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    [userPurchase setValue:@"1" forKey:strWithOutDot];
                }
            }
            
            [[NSUserDefaults standardUserDefaults]setValue:userPurchase forKey:@"InAppPurchases"];
//            if([[[NSUserDefaults standardUserDefaults] stringForKey:@"UserType"] isEqualToString: REGISTERED])
//            {
                [self updateParse];
                [self dismissViewControllerAnimated:YES completion:nil];
            //}
        }
        
        NSLog(@"Transactions restored");
    } failure:^(NSError *error)
    {
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.paidFeaturesTview flashScrollIndicators];
    [self.freeFeaturesTview flashScrollIndicators];
}

-(void)showAlreadyPurchasedAlert{
    UIAlertView *alradyPurchasedAlert = [[UIAlertView alloc] initWithTitle: @"Product already purchased"
                                                                   message: @"You have already purchased this item."
                                                                  delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    
    [alradyPurchasedAlert show];

}

@end
