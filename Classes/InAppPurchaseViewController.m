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

int indexing;

NSMutableArray *titles,*descriptions,*prices,*holder;
@synthesize button,tView,Yvalue;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	tView.dataSource = self;
	tView.delegate = self;
    [self.view addSubview:tView];
    [self.tView setBackgroundView:nil];
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
	
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSLog(@"numberOfRowsInSection returning %d", [self requestProduct]);
    return  holder.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    InAppPurchaseCell *cell = (InAppPurchaseCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InAppPurchaseCell" owner:self options:nil];
        cell = (InAppPurchaseCell *)[nib objectAtIndex:0];
    }
    
    NSLog(@"%@",holder);
    NSDictionary * dict = [holder objectAtIndex:indexPath.row];
    
    
    [cell setCellValueswithProductTitle:[dict objectForKey:@"packagename"] ProductPrice:[dict objectForKey:@"packageprice"] ProductDescription:[dict objectForKey:@"packagedesciption"] ProductImage:@"right_arrow"];

    
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
    if(rowIndex == 0 || rowIndex == 1) {
        
        //Checking if the user is valid or anonymus
        if ([[PFUser currentUser] sessionToken].length != 0) {
            
            //This line pop up login screen if user not exist
            [[RMStore defaultStore] addStoreObserver:self];
            
            //Getting Selected Product
           SKProduct *product = [requestedProducts objectAtIndex:rowIndex];
           [self purchaseProductID:product.productIdentifier];
        }
    }
    
//    // checking user is anonymous or not
//    if ([[PFUser currentUser] sessionToken].length != 0) {
//        //For Restore Purchase
//        if( buttonIndex == 2 ) {
//            [self restorePurchase];
//        }
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



#pragma mark  PURCHASE PRODUCT

-(int)requestProduct {
    
    if ([FlyerlySingleton connected]) {
        
//        if (sheetAlreadyOpen)return;
//        
//        //Check For Crash Maintain
//        cancelRequest = NO;
//        
//        [self showLoadingIndicator];
//        sheetAlreadyOpen =YES;
        //These are over Products on App Store
        NSSet *products = [NSSet setWithArray:@[@"com.flyerly.AllDesignBundle",@"com.flyerly.UnlockSavedFlyers"]];
        
        [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            
            //if (cancelRequest) return ;
            
            NSLog(@"Products loaded");
            
            requestedProducts = products;
            bool disablePurchase = ([[PFUser currentUser] sessionToken].length == 0);
            
            NSString *sheetTitle = @"Choose Product";
            
            if (disablePurchase) {
                sheetTitle = @"This feature requires Sign In";
            }

            holder = [[NSMutableArray alloc] init];
            for(SKProduct *product in products)
            {
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       product.localizedTitle,@"packagename",
                                       product.priceAsString,@"packageprice" ,
                                       product.description,@"packagedesciption",nil];
                
                [holder addObject:dict];
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [self hideLoadingIndicator];
        
    }
    
    return indexing;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 * Called when facebook button is pressed
 */
-(IBAction)onClickButton{
    NSLog(@"Somthing happened");
}

@end
