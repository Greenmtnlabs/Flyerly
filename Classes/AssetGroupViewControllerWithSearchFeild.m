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
#import "AFHTTPRequestOperation.h"
#import "CropViewController.h"
#include <CommonCrypto/CommonDigest.h>
#import "AFNetworking/AFNetworking.h"
#import "NBUGalleryThumbnailView.h"
#import "NBUAssets.h"

@interface AssetGroupViewControllerWithSearchFeild () {
    NSMutableArray *imagesIDs;
    NSString *imageID_;
    FlyerlyConfigurator *flyerConfigurator;
}

@end

@implementation AssetGroupViewControllerWithSearchFeild

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoadingIndicator];
    
    [self requestProduct];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    flyerConfigurator = appDelegate.flyerConfigurator;
    
    // HERE WE CREATE FLYERLY ALBUM ON DEVICE
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyPurchasedAlbum"]){
        [self createFlyerlyPurchasedAlbum];
    }
    
    self.nibNameForThumbnails = @"CustomThumbnailView";
    CGSize thumbSize = CGSizeMake(100.0,120.0);
    
    // Configure the grid view
    if ( IS_IPHONE_6 || IS_IPHONE_X)
    {
        thumbSize = CGSizeMake(119.0,120.0);
    }
    else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        thumbSize = CGSizeMake(132,120.0);
    }
    
    self.thumbnailSize = thumbSize;
    
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
    
    //[searchTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents: UIControlEventEditingDidEndOnExit];
    // Bring the search field to front
    [self.view bringSubviewToFront:_searchTextField];
    
    self.navigationItem.titleView = label;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //showing the laoding indicator on the top right corner
    [self showLoadingIndicator];
    //requesting the bigstock api with the entered keyword
    [self apiRequestWithSearchingKeyWord:searchBar.text];
    // hiding the keyboard
    [searchBar resignFirstResponder];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

/**
 * Override parent method.
 */
- (void)adjustThumbnailsView
{
    // Calculate bar height
    CGFloat topInset = 0.0;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//#if XCODE_VERSION_MAJOR >= 0500
//        topInset = self.topLayoutGuide.length;
//#endif
//    }
//    else
//    {
//        topInset = self.navigationController.navigationBar.translucent ? self.navigationController.navigationBar.frame.size.height : 0.0;
//    }
    
    if(IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XS)
    {
        topInset += CGRectGetMaxY(self.searchTextField.frame) + self.searchTextField.size.height + 50;
    }
    else
    {
        topInset += CGRectGetMaxY(self.searchTextField.frame) + self.searchTextField.size.height + 20;
    }

	self.thumbnailsGridView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.thumbnailsGridView.contentInset = UIEdgeInsetsMake(topInset,
                                                        0.0,
                                                        0.0,
                                                        0.0);
    self.thumbnailsGridView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset,
                                                                 0.0,
                                                                 0.0,
                                                                 0.0);
}

- (void)textFieldFinished:(id)sender {
    
    UITextField *searchFeild = (UITextField*)sender;
    [self apiRequestWithSearchingKeyWord:searchFeild.text];
    [sender resignFirstResponder];
}

// Send api request with lat long
- (void) apiRequestWithSearchingKeyWord: (NSString *)keyword {

    //string for the URL request
    NSString *myUrlString = [NSString stringWithFormat:@"http://api.bigstockphoto.com/2/%@/search/?q=%@/&response_detail=all", [flyerConfigurator bigstockAccountId], keyword];
    
    //create a NSURL object from the string data
    NSURL *myUrl = [NSURL URLWithString:myUrlString];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    //sets the receiver’s timeout interval, in seconds
    [urlRequest setTimeoutInterval:30.0f];
    //sets the receiver’s HTTP request method
    [urlRequest setHTTPMethod:@"GET"];
    
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
         if ([data length] >0 && error == nil)
         {
             //process the JSON response
             //use the main queue so that we can interact with the screen
             dispatch_async(dispatch_get_main_queue(), ^{

                 [self parseSearchResponse:data];
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

- (NSString *)sha1:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), result);
    if (result) {
        /* SHA-1 hash has been calculated and stored in 'result'. */
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02x", result[i]];
        }
        
        return output;
        
    }
    return nil;
}

// Send api request with lat long
- (void) apiRequestForPurchasingImage: (NSString *)imageID {
    
    NSString *encoded = [self sha1:[NSString stringWithFormat:@"%@%@%@", [flyerConfigurator bigstockSecretKey], [flyerConfigurator bigstockAccountId] , imageID]];
    
    NSString *myUrlString = [NSString stringWithFormat:@"http://api.bigstockphoto.com/2/%@/purchase?image_id=%@&size_code=s&auth_key=%@", [flyerConfigurator bigstockAccountId] , imageID,encoded];
    
    //create a NSURL object from the string data
    NSURL *myUrl = [NSURL URLWithString:myUrlString];
    
    //create a mutable HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    //sets the receiver’s timeout interval, in seconds
    [urlRequest setTimeoutInterval:30.0f];
    //sets the receiver’s HTTP request method
    [urlRequest setHTTPMethod:@"GET"];
    
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
                 
                 [self parsePurchaseResponse:data];
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

// Here we got response from api, parsing purchasing json response
- (void) parsePurchaseResponse:(NSData *) data {
    
    NSError *error = nil;
    
    //parsing the JSON response
    id jsonObject = [NSJSONSerialization
                  JSONObjectWithData:data
                  options:NSJSONReadingAllowFragments
                  error:&error];
    
    if (jsonObject != nil && error == nil){
        
        // Test/Access any key of json object( KEY , VALUE )
        int status = [[jsonObject objectForKey:@"response_code"] intValue];
        //NSMutableArray *imagesPreview = [[NSMutableArray alloc]init];
        imagesIDs = [[NSMutableArray alloc]init];
        
        if( status == 200 )
        {
            NSDictionary *tableData = [jsonObject objectForKey:@"data"];
            
            NSArray *purchasedImageDownloadID = [tableData objectForKey:@"download_id"];
            
            NSString *encoded = [self sha1:[NSString stringWithFormat:@"%@%@%@", [flyerConfigurator bigstockSecretKey], [flyerConfigurator bigstockAccountId], purchasedImageDownloadID]];
            
            NSString *purchaseImageUrlString = [NSString stringWithFormat:@"http://api.bigstockphoto.com/2/%@/download?auth_key=%@&download_id=%@", [flyerConfigurator bigstockAccountId], encoded,purchasedImageDownloadID];
            
            NSURL *purchaseImageUrl = [[NSURL alloc] initWithString:purchaseImageUrlString];
            NSURLRequest *purchaseImageUrlRequest = [[NSURLRequest alloc] initWithURL:purchaseImageUrl];

            NSURL *URL = purchaseImageUrl;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
            [manager GET:URL.absoluteString parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
                UIImage *thumbnail = (UIImage *) responseObject;
                NSData* data = UIImagePNGRepresentation(thumbnail);
                [self saveInGallery:data];
                NSLog(@"JSON: %@", responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        
    }
    else
    {
        NSLog(@"Error while trying to parse JSON. Error : %@", error);
    }
    
}

// Here we got response from api, parsing json response
- (void) parseSearchResponse:(NSData *) data {
    
    NSError *error = nil;
    
    //parsing the JSON response
    id jsonObject = [NSJSONSerialization
                  JSONObjectWithData:data
                  options:NSJSONReadingAllowFragments
                  error:&error];
    
    if (jsonObject != nil && error == nil){
        
        // Test/Access any key of json object( KEY , VALUE )
        int status = [[jsonObject objectForKey:@"response_code"] intValue];
        
        NSMutableArray *imagesPreview = [[NSMutableArray alloc]init];
        imagesIDs = [[NSMutableArray alloc]init];
        
        if( status == 200 ){
            NSDictionary *tableData = [jsonObject objectForKey:@"data"];
            
            NSArray *images = [tableData objectForKey:@"images"];
            
            for (int i=0;i < images.count; i++){
                
                NSDictionary *imageObject = [images objectAtIndex:i];
                NSDictionary *thumbDetails = [imageObject objectForKey:@"small_thumb"];
                NSString *imageId = [imageObject objectForKey:@"id"];
                [imagesPreview addObject :[thumbDetails objectForKey:@"url"]];
                [imagesIDs addObject:imageId];
            }
            
            ImageLoader *obj = [[ImageLoader alloc]init];
            self.imageLoader = obj;
            self.objectArray = imagesPreview;
            [self setShowThumbnailsView:YES];
            
            [self hideLoadingIndicator];
            
        }
        
    } else{
        NSLog(@"Json parsin may error aya hy, error=%@", error);
        //lbl_status.text = @"Json parsin may error aya hy";
    }
    
}

- (void)loadThumbnailImageWithIndex:(NSUInteger)index
{
    NBULogVerbose(@"%@ %@", THIS_METHOD, @(index));
    
    [self.imageLoader imageForObject:self.objectArray[index]
                                size:NBUImageSizeThumbnail
                         resultBlock:^(UIImage * image,
                                       NSError * error)
     {
         NSMutableArray *thumbnailViews = [[NSMutableArray alloc] init];
         thumbnailViews = [self valueForKey:@"_thumbnailViews"];
         ((NBUGalleryThumbnailView *)thumbnailViews[index]).imageView.backgroundColor = [UIColor whiteColor];
         ((NBUGalleryThumbnailView *)thumbnailViews[index]).imageView.contentMode = UIViewContentModeScaleAspectFit;
         ((NBUGalleryThumbnailView *)thumbnailViews[index]).imageView.image = image;
     }];
}


- (void) purchaseProduct
{
    //This line pop up login screen if user not exist
    [[RMStore defaultStore] addStoreObserver:self];
    
    NSString* productIdentifier= PRODUCT_ICON_SELETED;
    
    //Purchasing the product on the basis of product identifier
    [self purchaseProductID:productIdentifier];
}

/* HERE WE PURCHASE PRODUCT FROM APP STORE
 */
-(void)purchaseProductID:(NSString *)pid{
    
    [[RMStore defaultStore] addPayment:pid success:^(SKPaymentTransaction *transaction)
    {
        [self productSuccesfullyPurchased];
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error)
    {
        
        NSLog(@"Something went wrong");
        
        [self.thumbnailsGridView setUserInteractionEnabled:YES];
        [self hideLoadingIndicator];
        
    }];
}

#pragma mark  PURCHASE PRODUCT

-(void)requestProduct {
    
    if ([FlyerlySingleton connected])
    {
        //Check For Crash Maintain
        cancelRequest = NO;
        
        //These are over Products on App Store
        NSSet *productIdentifiers = [NSSet setWithArray:@[BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_ALL_DESIGN, BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION, BUNDLE_IDENTIFIER_UNLOCK_VIDEO,  BUNDLE_IDENTIFIER_AD_REMOVAL, PRODUCT_ICON_SELETED]];
        
        [[RMStore defaultStore] requestProducts:productIdentifiers success:^(NSArray *products, NSArray *invalidProductIdentifiers)
        {
            if (cancelRequest) return ;

            bool disablePurchase = ([[PFUser currentUser] sessionToken].length == 0);
            
            NSString *sheetTitle = @"Choose Product";
            
            if (disablePurchase)
            {
                sheetTitle = @"This feature requires Sign In";
            }
            
            NSMutableArray *productArray = [[NSMutableArray alloc] init];
            for(SKProduct *product in products)
            {
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      product.localizedTitle,@"packagename",
                                      product.priceAsString,@"packageprice" ,
                                      product.localizedDescription,@"packagedesciption",
                                      product.productIdentifier,@"productidentifier" , nil];
                [productArray addObject:dict];
            }
            
            // we will move it when UI Related issues fixed,here we explicitly requesting the BigStock API for the key word "dog"
            [self apiRequestWithSearchingKeyWord:@"flyer"];
            
            
        } failure:^(NSError *error) {
            NSLog(@"Something went wrong");
            
            [self.thumbnailsGridView setUserInteractionEnabled:YES];
            
            [self hideLoadingIndicator];
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're not connected to the internet. Please connect and retry." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


- ( void )productSuccesfullyPurchased
{
    [self.thumbnailsGridView setUserInteractionEnabled:YES];
    
    //Download request for purchsed image
    [self apiRequestForPurchasingImage:imageID_];
}


-(void)thumbnailWasTapped :(UIView *)sender {
    
    [self.thumbnailsGridView setUserInteractionEnabled:NO];
    
    [self showLoadingIndicator];
    
    //Checking if the user is valid or anonymus
    
    if (self.isFromInApp) //[[PFUser currentUser] sessionToken].length != 0
    {
        [self purchaseProduct];
        imageID_ = [imagesIDs objectAtIndex:sender.tag];
    }
    else
    {
//        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Please sign in first"
//                                                            message: @"To purchase any product, you need to sign in first."
//                                                           delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
//
//        [someError show];
       [self openPanel];
       imageID_ = [imagesIDs objectAtIndex:sender.tag];
       [self hideLoadingIndicator];
    }
    
}


-(void)openPanel
{
    if( IS_IPHONE_4 )
    {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    } else if( IS_IPHONE_5 || IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController" bundle:nil];
    }else {
        inappviewcontroller = [[InAppViewController alloc] initWithNibName:@"InAppViewController-iPhone4" bundle:nil];
    }
    
    inappviewcontroller.isFromStockPhoto = true;
    [self presentViewController:inappviewcontroller animated:YES completion:nil];
    
    [inappviewcontroller requestProduct];
    inappviewcontroller.buttondelegate = self;
}

- ( void )inAppPurchasePanelContent
{
    [inappviewcontroller inAppDataLoaded];
}

- (void)inAppPurchasePanelButtonTappedWasPressed:(NSString *)inAppPurchasePanelButtonCurrentTitle
{
    __weak InAppViewController *inappviewcontroller_ = inappviewcontroller;
    if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Sign In")])
    {
        
        // Put code here for button's intended action.
        signInController = [[SigninController alloc]initWithNibName:@"SigninController" bundle:nil];
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        signInController.launchController = appDelegate.lauchController;
        
        __weak AssetGroupViewControllerWithSearchFeild *assetGroupViewController = self;
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        
        userPurchases_.delegate = self;
        
        [inappviewcontroller_.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        signInController.signInCompletion = ^void(void) {
            
            UINavigationController* navigationController = assetGroupViewController.navigationController;
            [navigationController popViewControllerAnimated:NO];
            [userPurchases_ setUserPurcahsesFromParse];
        };
        
        [self.navigationController pushViewController:signInController animated:YES];
    }
    else if ([inAppPurchasePanelButtonCurrentTitle isEqualToString:(@"Restore Purchases")])
    {
        [inappviewcontroller_ restorePurchase];
    }
}

- (void)inAppPanelDismissed
{
    [self.thumbnailsGridView setUserInteractionEnabled:YES];
}

- ( void )productSuccesfullyPurchased: (NSString *)productId
{
    UserPurchases *userPurchases_ = [UserPurchases getInstance];
    
//    if ([userPurchases_ canCreateVideoFlyer])
//    {
//        [self apiRequestForPurchasingImage:imageID_];
////        UIImage *buttonImage = [UIImage imageNamed:@"MqodeVideo.png"];
////        [_mode setImage:buttonImage forState:UIControlStateNormal];
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }
//    else
//    {
        [self apiRequestForPurchasingImage:imageID_];
        [self dismissViewControllerAnimated:NO completion:nil];
   // }
    
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
    
    //Checking Group Path should be not null for Flyer Saving In Gallery
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyPurchasedAlbum"] == nil) {
        return;
    }
    
    //HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
    //if not allow so ignore Flyer saving in Gallery
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        return;
    }
    
    
    // HERE WE GET FLYERLY ALBUM URL
    NSURL *groupUrl  = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyPurchasedAlbum"]];
    
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupUrl resultBlock:^(ALAssetsGroup *group) {
        
        //CHECKING ALBUM EXIST IN DEVICE
        if ( group == nil ) {
            
            //ALBUM NOT FOUND
            [self createFlyerlyPurchasedAlbum];
            
        } else {
            
            [self createImageToFlyerlyPurchasedAlbum:groupUrl ImageData:imgData];
            
        }
    }
             failureBlock:^(NSError *error) {
             }];
}


/* APPLY OVER LOADING HERE
 * THIS METHOD CREATE ALBUM ON DEVICE AFTER IT SAVING IMAGE IN LIBRARY
 */
-(void)createFlyerlyPurchasedAlbum
{
    NSString *albumName;
    
    #if defined(FLYERLY)
        albumName = FLYER_PURCHASED_ALBUM_NAME;
    #else
        albumName = FLYERLY_BIZ_PURCHASED_ALBUM_NAME;
    #endif
    
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [_library addAssetsGroupAlbumWithName:albumName
                              resultBlock:^(ALAssetsGroup *group) {
                                  
                                  //CHECKING ALBUM FOUND IN LIBRARY
                                  if (group == nil) {
                                      
                                      //ALBUM NAME ALREADY EXIST IN LIBRARY
                                      [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          
                                          NSString *existAlbumName = [group valueForProperty: ALAssetsGroupPropertyName];
                                          
                                          if ([existAlbumName isEqualToString:albumName]) {
                                              *stop = YES;
                                              
                                              // GETTING CREATED URL OF ALBUM
                                              NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                              
                                              //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                              [[NSUserDefaults standardUserDefaults] setObject:groupURL.absoluteString forKey:@"FlyerlyPurchasedAlbum"];
                                          }
                                          
                                      } failureBlock:^(NSError *error) {
                                          NSLog( @"Error adding album: %@", error.localizedDescription );
                                      }];
                                      
                                  }else {
                                      
                                      //CREATE NEW ALBUM IN LIBRARY
                                      // GETTING CREATED URL OF ALBUM
                                      NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                      
                                      //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                      [[NSUserDefaults standardUserDefaults] setObject:groupURL.absoluteString forKey:@"FlyerlyPuchasedAlbum"];
                                  }
                              }
     
                             failureBlock:^(NSError *error) {
                                 NSLog( @"Error adding album: %@", error.localizedDescription );
                             }];
    
}


/*
 * HERE WE CREATE NEW IMAGE IN GALLERY
 */
-(void)createImageToFlyerlyPurchasedAlbum :(NSURL *)groupURL ImageData :(NSData *)imgData {
    
    // CREATE LIBRARY OBJECT FIRST
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupURL resultBlock:^(ALAssetsGroup *group) {
        
        //HERE WE CREATE IMAGE IN GALLERY
        [library  writeImageDataToSavedPhotosAlbum:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            // GETTING GENERATED IMAGE WITH URL
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                //HERE WE LINK IMAGE WITH FLYERLY ALBUM
                [group addAsset:asset];
                
                NBUAsset * asset_ = [NBUAsset assetForALAsset:asset];
                
                // Get out of full screen mode.
                [self viewWillDisappear:NO];
                
                [self hideLoadingIndicator];
                
                CropViewController *nbuCrop;
                
                if ( IS_IPHONE_5 || IS_IPHONE_4) {
                    nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
                }else if ( IS_IPHONE_6){
                    nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6" bundle:nil];
                }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
                    nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController-iPhone6-Plus" bundle:nil];
                }else { 
                    nbuCrop = [[CropViewController alloc] initWithNibName:@"CropViewController" bundle:nil];
                }
                
                nbuCrop.desiredImageSize = self.desiredImageSize;
                nbuCrop.image = [asset_.fullResolutionImage imageWithOrientationUp];
                nbuCrop.onImageTaken = self.onImageTaken;
                
                // Pop the current view, and push the crop view.
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
                [viewControllers removeLastObject];
                [viewControllers removeLastObject];
                [viewControllers addObject:nbuCrop];
                
                if(self.onImageTaken != NULL)
                {
                    [[self navigationController] setViewControllers:viewControllers animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can use purchased photo from Gallery -> Flyerly Purchases" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                   [self goBack];
                }

                //[self goBack];
                
            } failureBlock:^(NSError *error)
            {
                NSLog( @"Image not linked: %@", error.localizedDescription );
            }];
            
        }];
        
        
    } failureBlock:^(NSError *error) {
        NSLog( @"Image not created in gallery: %@", error.localizedDescription );
    }];
}

/**
 * Show a loding indicator in the right bar button.
 */
- (void)showLoadingIndicator {
    // Remember the right bar button item.
    rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    UIActivityIndicatorView *uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [uiBusy setColor:[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0]];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
    [self.navigationItem setRightBarButtonItem:btn animated:NO];
}

/**
 * Hide previously shown indicator.
 */
- (void)hideLoadingIndicator {
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:NO];
}

@end
