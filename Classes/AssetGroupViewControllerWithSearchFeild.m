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
            tableData = [jsonObject objectForKey:@"data"];//[NSArray arrayWithObjects:nil];
            
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
            
            //NSMutableArray *imagesArray = [tableData objectForKey:@"images"];
            //NSLog(@"%@",imagesArray);
            
            /*tableData = [NSMutableArray arrayWithObjects:@"a",@"b",@"c", @"two", @"three", @"four"
                         @"1",@"2",@"3", @"4", @"5", @"6"
                         , nil];*/
            //[tableViewMasjids reloadData];
            
            //Scroll tableview ,
            NSIndexPath* ip = [NSIndexPath indexPathForRow:3 inSection:0];
            //[tableViewMasjids scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        
        
    } else{
        NSLog(@"Json parsin may error aya hy, error=%@", error);
        //lbl_status.text = @"Json parsin may error aya hy";
    }
    
}
//------------------------------ App functions ------------------------ End   -----

/*
- (void)objectUpdated:(NSDictionary *)userInfo
{
    // [super objectUpdated:userInfo];
    
    // Clean up before reuse
    NBUAssetsGroup * oldGroup = userInfo[NBUObjectUpdatedOldObjectKey];
    if (oldGroup)
    {
        [oldGroup stopLoadingAssets];
        [self.gridView resetGridView];
    }
    
    // Set the group name
    if (self.groupNameLabel)
        self.groupNameLabel.text = self.assetsGroup.name;
    else
        self.title = self.assetsGroup.name;
    self.selectedAssets = nil;
    
    // Check the number of images
    [self.assetsGroup stopLoadingAssets];
    NSUInteger totalCount;
    
    // Here we Check Selection For Photo or Background
    totalCount = imagesPreview.count;
    
    // And update the count label
    /*if (self.assetsCountLabel)
    {
        switch (totalCount)
        {
            case 0:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupViewController NoImagesLabel", @"No images"),
                                              totalCount];
                break;
            }
            case 1:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupView Only one image", @"1 image"),
                                              totalCount];
                break;
            }
            default:
            {
                self.assetsCountLabel.text = [NSString stringWithFormat:NBULocalizedString(@"NBUAssetsGroupView Number of images", @"%d images"),
                                              totalCount];
                break;
            }
        }
    }
    
    // No need to load assets
    if (totalCount == 0)
    {
        self.loading = NO;
        return;
    }
    
    // Load assets
    NBULogInfo(@"Loading %d images for group %@...", totalCount, self.assetsGroup.name);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.loading = YES;
                   });
    __unsafe_unretained NBUAssetsGroupViewController * weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NBUAssetType *contentType;
        
        contentType = NBUAssetTypeImage;
    
        
        [weakSelf.assetsGroup assetsWithTypes:contentType
                                    atIndexes:nil
                                 reverseOrder:YES
                          incrementalLoadSize:self.loadSize
                                  resultBlock:^(NSArray * assets,
                                                NSError * error)
         {
             if (!error)
             {
                 assets = assets;
                 
                 // Update from time to time only...
                 if (assets.count == 50 ||
                     assets.count == 100 ||
                     assets.count == totalCount)
                 {
                     NBULogVerbose(@"...%d images loaded", assets.count);
                     
                     
                     // Stop loading?
                     if (assets.count == totalCount)
                     {
                         dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            self.loading = NO;
                                        });
                     }
                     
                     // Check for selectedAssets
                     NSArray * selectedAssets = [self selectedAssetsFromAssets:assets
                                                            selectedAssetsURLs:self.selectedAssetsURLs];
                     
                     // Update grid view and selected assets on main thread
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        self.selectedAssets = selectedAssets;
                                        weakSelf.gridView.objectArray = assets;
                                        
                                    });
                 }
             }
         }];
    });
    
    
}*/

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

@end
