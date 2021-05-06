//
//  GiphyViewController.m
//  Flyr
//
//  Created by Abdul Rauf on 20/10/2015.
//
//

#import "GiphyViewController.h"
#import "AFNetworking.h"
#import "Common.h"
#import "FlyrAppDelegate.h"
#import "FlyerlyConfigurator.h"
#import "CropVideoViewController.h"
#import "CommonFunctions.h"
#import "VideoFunctions.h"
#define LESS_THEN_3_SECONDS 3

@interface GiphyViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchField;
@end

@implementation GiphyViewController{
    UIView *giphyBgsView;
    UIView *loadingOverly;
    NSArray *giphyData;
    BOOL reqGiphyApiInProccess;
    BOOL giphyDownloading;
    NSString *giphyApiKey;

    NSString *destination, *destinationTemp, *destinationTemp2;
    NSURL *mediaURL, *mediaURLTemp, *mediaURLTemp2;
    int width, height; // to hold original width and height of a giphy
    int squareWH, squareWHMax; // to hold minimum and miximum between width and height of a giphy
    
    int videoDuration;
}


@synthesize layerScrollView, flyer, tasksAfterGiphySelect, searchField;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view bringSubviewToFront:_searchTextField];
    
    // Navigation buttons
    // BackButton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    // Set the title view.
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 102, 38)];
    [logo setImage:[UIImage imageNamed:@"giphyLogo"]];
    self.navigationItem.titleView = logo;
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    FlyerlyConfigurator *flyerConfigurator = appDelegate.flyerConfigurator;
    giphyApiKey = [[NSString alloc] initWithString:[flyerConfigurator giphyApiKey]];
    
    giphyBgsView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,layerScrollView.frame.size.width, layerScrollView.frame.size.height)];
    [layerScrollView addSubview:giphyBgsView];
    
    //load trending giphy default
    [self loadGiphyImages:[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/trending?api_key=%@",giphyApiKey]];
    
    double fontSize = 7.0;
    
    if(IS_IPHONE_6){
        fontSize = 9.0;
    } else if(IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS)
    {
        fontSize = 11.0;
    }
    
    // Set font size of placeholder of UISearchBar
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{                                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:fontSize], }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // To clear navigation bar color
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

/**
 * Load giphy images from internet
 */
-(void)loadGiphyImages:(NSString *)urlStr{
    
    //when request is in process
    if( reqGiphyApiInProccess ){
        return;
    } else{
        //showing the laoding indicator on the top right corner
        [self showLoadingIndicator];
        reqGiphyApiInProccess = YES;
    }
    
    [self deleteSubviewsFromView:giphyBgsView];

    // Send request to giphy API
    NSURL *URL = [NSURL URLWithString: urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: URL.absoluteString parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
        reqGiphyApiInProccess = NO;
        [self hideLoadingIndicator];
        giphyData = responseObject[@"data"];
        
        if( giphyData != nil && giphyData.count > 0 ){
            int heightHandlerForMainView = 0;
            int i=0, row = 0, column = 0;
            int showInRow = 2, defX = 16, defY = 16 , defW = 182, defH = 182;//414 full width
            
            if( IS_IPHONE_4 ){
                showInRow = 2, defX = 13, defY = 13 , defW = 141, defH = 141;//320 full width
            } else if(IS_IPHONE_5 ){
                showInRow = 2, defX = 13, defY = 13 , defW = 141, defH = 141;//320 full width
            } else if( IS_IPHONE_6 ){
                showInRow = 2, defX = 17, defY = 17 , defW = 162, defH = 162;//375 full width
            }
            else
            {
                showInRow = 2, defX = 17, defY = 17 , defW = 162, defH = 162;
            }
            
            int x = 0, y = 0;
            for(NSDictionary *gif in giphyData ){
                column = i % showInRow;
                row = floor( i / showInRow );
                x = defX*column+defX + defW*column;
                y = defY*row+defY + defH*row;
                
                UIView *viewForGiphy = [[UIView alloc]initWithFrame:CGRectMake(x-4, y-4, defW+4, defH+4)];
                UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, defW+4, defH+4)];
                webview.userInteractionEnabled = NO;
                webview.scrollView.scrollEnabled = NO;
                
                NSString *giphyUrlStr = [[gif[@"images"] objectForKey:@"original"] objectForKey:@"url"];
                NSString *spinnerImagePath = [[NSBundle mainBundle] pathForResource:@"spinner" ofType:@"gif"];
                NSString* htmlContent = [NSString stringWithFormat:@"<html><head><title></title></head><body style='margin:0px; padding:0px;'><img src='%@' style='border:1px solid black; width:%ipx; height:%ipx; background:url(%@) no-repeat center center; '></body></html>",giphyUrlStr,defW,defH,spinnerImagePath];
                [webview loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
                
                viewForGiphy.tag = i++;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGiphy:)];
                [viewForGiphy addGestureRecognizer:tapGesture];
                [viewForGiphy addSubview:webview];
                [giphyBgsView addSubview:viewForGiphy];
                
            }
            
            //GiphyBgsView will get height dynamically
            int gbvH = y+defH+defY+heightHandlerForMainView;
            int gbvW = layerScrollView.frame.size.width;
            giphyBgsView.frame = CGRectMake(giphyBgsView.frame.origin.x, giphyBgsView.frame.origin.y, gbvW, gbvH);
            
            [layerScrollView addSubview:giphyBgsView];
            [layerScrollView setContentSize:CGSizeMake(giphyBgsView.frame.size.width,giphyBgsView.frame.size.height)];
        }

        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
 * When user select any giphy, download mov file and play in the player
 */
-(void)selectGiphy:(id)sender{
    videoDuration = 0;
    //when a process in que dont start other
    if( giphyDownloading == YES ){
        return;
    } else {
        //showing the laoding indicator on the top right corner
        [self onSelectGiphyShowLoadingIndicator:YES];
    }
    
    int tag = (int)[(UIGestureRecognizer *)sender view].tag;
    NSDictionary *gif = giphyData[tag];
    NSURL *url = [NSURL URLWithString:[[gif[@"images"] objectForKey:@"original"] objectForKey:@"mp4"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // when data is nil then stop going forward
        if( data == nil ){
            [self onSelectGiphyShowLoadingIndicatorInThread:NO];
            return;
        }
        
        //After download complete work for cropping in mainQueue thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
            
            //File will be saved here
            destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
            mediaURL = [NSURL fileURLWithPath:destination];
            
            //Temporary video we will crop from it then delete it
            destinationTemp = [NSString stringWithFormat:@"%@/Template/templateTemp.mov",currentpath];
            [self deleteFile:destinationTemp];//delete of file if exist
            [[NSFileManager defaultManager] createFileAtPath:destinationTemp contents:data attributes:nil];
            mediaURLTemp = [NSURL fileURLWithPath:destinationTemp];
            
            
            //will help when video is less then 3 second
            destinationTemp2 = [NSString stringWithFormat:@"%@/Template/templateTemp2.mov",currentpath];
            [self deleteFile:destinationTemp2];//delete of file if exist
            mediaURLTemp2 = [NSURL fileURLWithPath:destinationTemp2];
            
            //If downloaded Giphy is less then 3 seconds then repeat it 3 times
            videoDuration = [CommonFunctions videoDuration:mediaURLTemp];
            
            [self onSelectGiphyShowLoadingIndicatorInThread:NO];
            
            CGSize mediaSize = [self getMediaSize:mediaURLTemp];
            
            width = mediaSize.width;
            height = mediaSize.height;
            
            //Video must be squire, othere wise merge video will not map layer on exact points
            squareWH = (width < height) ? width : height;
            squareWHMax = (width > height) ? width : height;

            //start cropping
            [self videoCrop:mediaURLTemp];

        }];
        
    }] resume];

    // This clears white overlay from superview
    [loadingOverly removeFromSuperview];
    // To enable Home button
    [leftBarButtonItem setEnabled:YES];
}

-(CGSize)getMediaSize:(NSURL *)mediaFileUrl{
    //Get video width/height
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaFileUrl options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *track = [tracks objectAtIndex:0];
    return track.naturalSize;
}

-(void)onSelectGiphyShowLoadingIndicatorInThread:(BOOL)showHide{
    //hide loading indicator in UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onSelectGiphyShowLoadingIndicator:showHide];
    });
}

/**
 * Delete file
 */
-(void)deleteFile:(NSString *)fileDest{
    // Make sure the video does not exist already. If it does, delete it.
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileDest isDirectory:NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileDest error:nil];
    }
}


# pragma mark - Video editing

/*
 * Crop video using crop video view controller.
 */
-(void) videoCrop:(NSURL *)movieUrl {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //Background Thread
    CropVideoViewController *cropVideo;
    if( IS_IPHONE_4 || IS_IPHONE_5) {
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
    }else if ( IS_IPHONE_6){
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6" bundle:nil];
    }else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController-iPhone6-Plus" bundle:nil];
    } else{
        cropVideo = [[CropVideoViewController alloc] initWithNibName:@"CropVideoViewController" bundle:nil];
    }
    
    __weak GiphyViewController *weakSelf = self;
    
    [cropVideo setOnVideoFinished:^(NSURL *recvUrl, CGRect cropRect, CGFloat scale ) {
        
        NSURL *destUrl = (videoDuration < LESS_THEN_3_SECONDS ) ? mediaURLTemp2 : mediaURL;
        
        [self deleteFile:destination];
        [self onSelectGiphyShowLoadingIndicatorInThread:YES];
        
        [weakSelf modifyVideo:recvUrl destination:destUrl crop:cropRect scale:scale overlay:nil completion:^(NSInteger status, NSError *error) {
            
            switch ( status ) {
                case AVAssetExportSessionStatusFailed:
                    NSLog (@"FAIL = %@", error );
                    break;
                case AVAssetExportSessionStatusCompleted:
                    //Update dictionary
                    [flyer setOriginalVideoUrl:@"Template/template.mov"];
                    [flyer setFlyerTypeVideoWithSize:cropRect.size.width height:cropRect.size.height videoSoure:@"giphy"];
                    [flyer setImageTag:@"Template" Tag:nil];
                    [flyer addGiphyWatermark];
                    
                    tasksAfterGiphySelect = @"play";
                    break;
            }
            
            if (videoDuration < LESS_THEN_3_SECONDS ){
                // Repeat/merge video till LESS_THEN_SECONDS
                NSMutableArray *urlArr = [[NSMutableArray alloc] initWithCapacity:0];
                [urlArr addObject:mediaURLTemp2];
                if (videoDuration < 3 ) {
                    [urlArr addObject:mediaURLTemp2];
                }
                if (videoDuration < 2 ) {
                    [urlArr addObject:mediaURLTemp2];
                }
                if (videoDuration < 1 ) {
                    [urlArr addObject:mediaURLTemp2];
                }
                
                CGSize mediaSize = [weakSelf getMediaSize:mediaURLTemp2];
                __weak GiphyViewController *weakSelf2 = weakSelf;
                VideoFunctions *vf = [[VideoFunctions alloc] init];
                [vf mergeVideos:urlArr outputURL:mediaURL width:mediaSize.width height:mediaSize.height completion:^(NSInteger status, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Delete temporary file
                        [weakSelf2 deleteFile:destinationTemp2];
                        [weakSelf2 goBackAfterCropping];
                    });
                }];
                
            } else {
                [weakSelf goBackAfterCropping];
            }
            
        }];
    }];
    
    cropVideo.giphyDic = [[NSMutableDictionary alloc] init];
    [cropVideo.giphyDic setObject: [NSNumber numberWithInteger:squareWH] forKey:@"minWH"];
    [cropVideo.giphyDic setObject: [NSNumber numberWithInteger:squareWHMax] forKey:@"maxWH"];
    [cropVideo.giphyDic setObject: [NSNumber numberWithInteger:squareWH] forKey:@"desiredWidth"];
    [cropVideo.giphyDic setObject: [NSNumber numberWithInteger:squareWH] forKey:@"desiredHeight"];
    

    cropVideo.url = movieUrl;
    cropVideo.onVideoCancel = _onVideoCancel;
    cropVideo.fromCamera = YES;
    
    // Pop the current view, and push the crop view.
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:cropVideo];
    [[self navigationController] pushViewController:cropVideo animated:YES];
}

-(void)goBackAfterCropping{
    //Delete temporary file
    [self deleteFile:destinationTemp];
    
    // Perform ui related things in main thread
    dispatch_async( dispatch_get_main_queue(), ^{
        [self goBack];
    });
}

/*
 * Video cropping function
 * Export video to given destination, from given source, cropped and scaled to specified
 * rect with the given overlay.
 */
- (void)modifyVideo:(NSURL *)src destination:(NSURL *)dest crop:(CGRect)crop
              scale:(CGFloat)scale overlay:(UIImage *)image
         completion:(void (^)(NSInteger, NSError *))callback {
    
    // Get a pointer to the asset
    AVURLAsset* firstAsset = [AVURLAsset URLAssetWithURL:src options:nil];
    
    // Make an instance of avmutablecomposition so that we can edit this asset:
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    // Add tracks to this composition
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    // Image video is always 30 seconds. So we use that unless the background video is smaller.
    CMTime inTime = CMTimeMake( MAX_VIDEO_LENGTH * VIDEOFRAME, VIDEOFRAME );
    if ( CMTimeCompare( firstAsset.duration, inTime ) < 0 ) {
        inTime = firstAsset.duration;
    }
    
    // Add to the video track.
    NSArray *videos = [firstAsset tracksWithMediaType:AVMediaTypeVideo];
    CGAffineTransform transform;
    if ( videos.count > 0 )
    {
        AVAssetTrack *track = [videos objectAtIndex:0];
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, inTime) ofTrack:track atTime:kCMTimeZero error:nil];
        transform = track.preferredTransform;
        videoTrack.preferredTransform = transform;
    }
    
    NSLog(@"Natural size: %.2f x %.2f", videoTrack.naturalSize.width, videoTrack.naturalSize.height);
    
    // if we have negative dimensions
    if(crop.size.width < 0){
        crop.size.width = -1 * crop.size.width;
    }
    if(crop.size.height < 0){
        crop.size.height = -1 * crop.size.height;
    }
    
    // Set the mix composition size.
    mixComposition.naturalSize = crop.size;
    
    // Set up the composition parameters.
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, VIDEOFRAME );
    videoComposition.renderSize = crop.size;
    videoComposition.renderScale = 1.0;
    
    // Pass through parameters for animation.
    AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, inTime);
    
    // Layer instructions
    AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    // Set the transform to maintain orientation
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale( scale, scale);
    CGAffineTransform translateTransform = CGAffineTransformTranslate( CGAffineTransformIdentity,
                                                                          -crop.origin.x,
                                                                          -crop.origin.y);
    transform = CGAffineTransformConcat( transform, scaleTransform );
    transform = CGAffineTransformConcat( transform, translateTransform);
    
    [passThroughLayer setTransform:transform atTime:kCMTimeZero];
    
    passThroughInstruction.layerInstructions = @[ passThroughLayer ];
    videoComposition.instructions = @[passThroughInstruction];
    
    // Now export the movie
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
   // exportSession.videoComposition = videoComposition;
    
    // Export the URL
    exportSession.outputURL = dest;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        callback( exportSession.status, exportSession.error );
    }];
}


#pragma mark - Button Handlers
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // hiding the keyboard
    [searchBar resignFirstResponder];
    
    // To replace " " with '%20'
    NSString * searchString = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //send search giphies request
    [self loadGiphyImages:[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?api_key=%@&q=%@",giphyApiKey,searchString]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

/**
 * Go Back
 */
-(void)goBack{
    
    [self deleteSubviewsFromView:giphyBgsView];
    [self deleteSubviewsFromView:layerScrollView];
    
    [giphyBgsView removeFromSuperview];
    [loadingOverly removeFromSuperview];
    [layerScrollView removeFromSuperview];
    
    giphyBgsView = nil;
    loadingOverly = nil;
    layerScrollView = nil;
    giphyData = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Show/hide a loding indicator on select giphy
 */
- (void)onSelectGiphyShowLoadingIndicator:(BOOL)show {
    giphyDownloading = show;
    if( show ){
        layerScrollView.alpha = 0.7;
        searchField.userInteractionEnabled = NO;
        [leftBarButtonItem setEnabled:NO];
        [self showLoadingIndicator];
        
        loadingOverly = [[UIView alloc] initWithFrame:layerScrollView.frame];
        loadingOverly.backgroundColor = [UIColor whiteColor];
        loadingOverly.alpha = 0.5;
        [self.view addSubview:loadingOverly];
        
    }
    else{
        [loadingOverly removeFromSuperview];
        
        layerScrollView.alpha = 1;
        searchField.userInteractionEnabled = YES;
        [leftBarButtonItem setEnabled:YES];
        [self hideLoadingIndicator];
    }
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

/*
 *Here we Remove all Subviews of ScrollViews
 */
-(void)deleteSubviewsFromView:(UIView *)view{
    NSArray *ChildViews = [view subviews];
    for (UIView *child in ChildViews) {
            [child removeFromSuperview];
    }    
}
@end
