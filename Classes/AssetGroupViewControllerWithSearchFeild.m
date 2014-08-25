//
//  AssetGroupViewControllerWithSearchFeild.m
//  Flyr
//
//  Created by RIKSOF Developer on 8/5/14.
//
//

#import "AssetGroupViewControllerWithSearchFeild.h"
#import "Common.h"
#import "ImageLoader.h"
#import "InAppViewController.h"

@interface AssetGroupViewControllerWithSearchFeild ()

@end

NSString *account_id;
id jsonObject;
NSDictionary *tableData;
NSMutableArray *imagesPreview;

@implementation AssetGroupViewControllerWithSearchFeild


@synthesize searchTextField,scrollGridView;

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
    
    // Configure grid view
    //self.objectTableView.nibNameForViews = @"CustomAssetsGroupView";
    // Customization
    self.thumbnailsGridView = scrollGridView;

    //change to your account id at bigstock.com/partners
    account_id = @"862265";
    // Do any additional setup after loading the view from its nib.
    // Configure the grid view
    self.gridView.margin = CGSizeMake(5.0, 5.0);
    self.gridView.nibNameForViews = @"CustomAssetThumbnailView";
    
    // Configure the selection behaviour
    self.selectionCountLimit = 1;
    
    // Navigation buttons
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    
    // Set the title view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, -6, 50, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
    label.text = @"Stock Photos";
    
    [searchTextField setReturnKeyType:UIReturnKeyDone];
    [searchTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    
    self.navigationItem.titleView = label;
    
    [self apiRequestWithSearchingKeyWord:@"dog"];
}

- (void)textFieldFinished:(id)sender {
    
    UITextField *searchFeild = (UITextField*)sender;
    [self apiRequestWithSearchingKeyWord:searchFeild.text];
    [sender resignFirstResponder];
}

// Send api request with lat long
- (void) apiRequestWithSearchingKeyWord: (NSString *)keyword {
    
    NSLog(@"in apiRequestWithSearchingKeyWord, sending api call with %@",account_id);
    
    //string for the URL request
    //[NSString stringWithFormat:@"api.bigstockphoto.com/2/%@/search/?q=%@/&response_detail=all", account_id, keyword];
    NSString *myUrlString = [NSString stringWithFormat:@"http://api.bigstockphoto.com/2/%@/search/?q=%@/&response_detail=all", account_id, keyword];
    
    //create a NSURL object from the string data
    NSURL *myUrl = [NSURL URLWithString:myUrlString];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    //sets the receiver’s timeout interval, in seconds
    [urlRequest setTimeoutInterval:30.0f];
    //sets the receiver’s HTTP request method
    [urlRequest setHTTPMethod:@"GET"];
    
    //create string for parameters that we need to send in the HTTP POST body
    //NSString *body =  [NSString stringWithFormat:@"countryCode=%@", @"PKR"];
    //sets the request body of the receiver to the specified data.
    //[urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //allocate a new operation queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //Loads the data for a URL request and executes a handler block on an
    //operation queue when the request completes or fails.
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         if ([data length] >0 && error == nil){
             //process the JSON response
             //use the main queue so that we can interact with the screen
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 //lbl_status.text = @"Got api data, parsing data";
                 NSLog(@"Got api data, parsing data");
                 
                 [self parseResponse:data];
             });
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"Api data was empty");
             //lbl_status.text = @"Api data was empty";
         }
         else if (error != nil){
             NSLog(@"Error occured, error = %@", error);
             //lbl_status.text = @"Error occured";
         }
     }];
}

// Here we got response from api, parsing json response
- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"in parseResponse, JSON data = %@", myData);
    NSError *error = nil;
    
    //parsing the JSON response
    jsonObject = [NSJSONSerialization
                  JSONObjectWithData:data
                  options:NSJSONReadingAllowFragments
                  error:&error];
    
    if (jsonObject != nil && error == nil){
        
        // Test/Access any key of json object( KEY , VALUE )
        int status = [[jsonObject objectForKey:@"response_code"] intValue];
        NSLog(@"Api status = %i",status);
        //lbl_status.text = [@"Api status = " stringByAppendingFormat:@"%i",status];
        NSLog(@"msg = %@",[jsonObject objectForKey:@"message"]);
        
        imagesPreview = [[NSMutableArray alloc]init];
        
        if( status == 200 ){
            NSLog(@"Creating list from parsed data");
            //lbl_status.text = @"Creating list";
            tableData = [jsonObject objectForKey:@"data"];
            
            NSArray *images = [tableData objectForKey:@"images"];
            
            for (int i=0;i < images.count; i++){
                
                NSDictionary *imageObject = [images objectAtIndex:i];
                NSDictionary *thumbDetails = [imageObject objectForKey:@"small_thumb"];
                [imagesPreview addObject :[thumbDetails objectForKey:@"url"]];
                
                
            }
            
            ImageLoader *obj = [[ImageLoader alloc]init];
            self.imageLoader = obj;
            self.objectArray = imagesPreview;
            
            //self.thumbnailsGridView = scrollGridView;
            [self setShowThumbnailsView:YES];
  
        }
        
    } else{
        NSLog(@"Json parsin may error aya hy, error=%@", error);
        //lbl_status.text = @"Json parsin may error aya hy";
    }
    
}




- (void) purchaseProduct {
    
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    
    NSString* productIdentifier= @"com.flyerly.SelectedSymbol";
    
    //Purchasing the product on the basis of product identifier
    [self purchaseProductID:productIdentifier];
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
        
        [self productSuccesfullyPurchased];
        
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        NSLog(@"Something went wrong");
        
    }];
}

- ( void )productSuccesfullyPurchased{
    
    NSLog(@"succesfully purchased image");
    
}


-(void)thumbnailWasTapped :(id)objectId {

    //Checking if the user is valid or anonymus
    if ([[PFUser currentUser] sessionToken].length != 0) {
        
        [self purchaseProduct];
        
        
    }else {
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Please sign in first"
                                                            message: @"To purchase any product, you need to sign in first."
                                                           delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        
        [someError show];
    }
    
}

/**
 * An asset was selected. Process it.
 */
- (void)thumbnailViewSelectionStateChanged:(NSNotification *)notification {
    
    // Refresh selected assets
    NBUAssetThumbnailView *assetView = (NBUAssetThumbnailView *)notification.object;
    NBUAsset *asset = assetView.asset;
    NSLog(@"image selected");
}

#pragma mark - Button Handlers

/**
 * Cancel and go back.
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*** HERE WE SAVE IMAGE INTO GALLERY
 * AND LINK WITH FLYERLY ALBUM
 *
 */
-(void)saveInGallery :(NSData *)imgData {
    
    
    // CREATE LIBRARY OBJECT FIRST
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    //Checking Group Path should be not null for Flyer Saving In Gallery
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlPurchasedyAlbum"] == nil) {
        return;
    }
    
    //HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
    //if not allow so ignore Flyer saving in Gallery
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        return;
    }
    
    
    // HERE WE GET FLYERLY ALBUM URL
    NSURL *groupUrl  = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlPurchasedyAlbum"]];
    
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupUrl resultBlock:^(ALAssetsGroup *group) {
        
        //CHECKING ALBUM EXIST IN DEVICE
        if ( group == nil ) {
            
            //ALBUM NOT FOUND
            [self createFlyerlyAlbum:imgData];
            
        } else {
            
            //ALBUM FOUND
            //GETTING IMAGE OR VIDEO URL IF EXIST IN FLYER INFO FILE .TXT
            NSString *currentUrl;
            
            currentUrl = [self getFlyerURL];
            
            
            // CHECKING CRITERIA CREATE OR MODIFY
            if ( [currentUrl isEqualToString:@""]) {
                
                if ( [self isVideoFlyer] ){
                    [self createVideoToFlyerlyAlbum:groupUrl VideoData:[NSURL fileURLWithPath:[self getSharingVideoPath]]];
                }else {
                    [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                }
                
            } else { // URL FOUND WE USE EXISTING URL FOR REPLACE IMAGE
                
                // CONVERT STRING TO URL
                NSURL *imageUrl = [[NSURL alloc] initWithString:currentUrl];
                
                // GETTING GENERATED IMAGE WITH URL
                [library assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
                    
                    if (asset == nil) {
                        
                        // URL Exist and Image Not Found
                        // we Create New Content In Gallery
                        if ( [self isVideoFlyer] ){
                            
                            //For Video
                            [self createVideoToFlyerlyAlbum:groupUrl VideoData:[NSURL fileURLWithPath:[self getSharingVideoPath]]];
                        }else {
                            
                            //For Image
                            [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                        }
                    } else {
                        
                        // URL Exist and Image Found
                        //HERE WE UPDATE Content WITH LATEST UPDATE
                        
                        if ( [self isVideoFlyer] ){
                            
                            //Update Video
                            [asset setVideoAtPath:[NSURL fileURLWithPath:[self getSharingVideoPath]] completionBlock:^(NSURL *assetURL, NSError *error) {
                            }];
                        }else {
                            
                            //Update Image
                            [asset setImageData:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                            }];
                        }
                    }
                    
                } failureBlock:^(NSError *error) {
                }];
                
                
            }
        }
        
    }
             failureBlock:^(NSError *error) {
             }];
}


/* APPLY OVER LOADING HERE
 * THIS METHOD CREATE ALBUM ON DEVICE AFTER IT SAVING IMAGE IN LIBRARY
 */
-(void)createFlyerlyAlbum :(NSData *)imgdata {
    
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    __weak Flyer *weakSelf = self;
    
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [_library addAssetsGroupAlbumWithName:FLYER_ALBUM_NAME
                              resultBlock:^(ALAssetsGroup *group) {
                                  
                                  // GETTING CREATED URL OF ALBUM
                                  NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                  
                                  //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                  [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyPurchasedAlbum"];
                                  
                                  //Checking Content Type
                                  if ([weakSelf isVideoFlyer]) {
                                      
                                      //Create Video
                                      [weakSelf createVideoToFlyerlyAlbum:groupURL VideoData:[NSURL fileURLWithPath:[weakSelf getSharingVideoPath]]];
                                  }else {
                                      
                                      //Create Image
                                      [weakSelf createImageToFlyerlyAlbum:groupURL ImageData:imgdata];
                                  }
                              }
     
                             failureBlock:^(NSError *error) {
                                 NSLog( @"Error adding album: %@", error.localizedDescription );
                             }];
    
    
}

@end
