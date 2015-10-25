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
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"giphyLogo1.jpg"]];
    titleImg.frame = CGRectMake(titleImg.frame.origin.x, titleImg.frame.origin.y, 40, 40);
    self.navigationItem.titleView = titleImg;
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    FlyerlyConfigurator *flyerConfigurator = appDelegate.flyerConfigurator;
    giphyApiKey = [[NSString alloc] initWithString:[flyerConfigurator giphyApiKey]];
    
    
    giphyBgsView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,layerScrollView.frame.size.width, layerScrollView.frame.size.height)];
    [layerScrollView addSubview:giphyBgsView];
    
    //load trending giphy default
    [self loadGiphyImages:[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/trending?api_key=%@",giphyApiKey]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    

    //send request to giphy api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        reqGiphyApiInProccess = NO;
        [self hideLoadingIndicator];
        giphyData = responseObject[@"data"];
        
        if( giphyData != nil && giphyData.count > 0 ){
            int heightHandlerForMainView = 0;
            int i=0, row = 0, column = 0;
            int showInRow = 2, defX = 16, defY = 16 , defW = 182, defH = 182;//414 full width
            if( IS_IPHONE_4 ){
                showInRow = 2, defX = 13, defY = 13 , defW = 141, defH = 141;//320 full width
            } else if( IS_IPHONE_5 ){
                showInRow = 2, defX = 13, defY = 13 , defW = 141, defH = 141;//320 full width
            } else if( IS_IPHONE_6 ){
                showInRow = 2, defX = 17, defY = 17 , defW = 162, defH = 162;//375 full width
            } else if( IS_IPHONE_6_PLUS ){
                showInRow = 2, defX = 16, defY = 16 , defW = 182, defH = 182;//414 full width
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        
        if( data == nil ){
            [self onSelectGiphyShowLoadingIndicator:NO];
            return;
        }
            
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
            NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
            NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
            [[NSFileManager defaultManager] createFileAtPath:destination contents:data attributes:nil];
            
            NSURL *mediaURL = [NSURL fileURLWithPath:destination];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
            NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
            AVAssetTrack *track = [tracks objectAtIndex:0];
            CGSize mediaSize = track.naturalSize;
            
            int width = mediaSize.width;
            int height = mediaSize.height;
            
            //Update dictionary
            [flyer setOriginalVideoUrl:@"Template/template.mov"];
            [flyer setFlyerTypeVideoWithSize:width height:height videoSoure:@"giphy"];

            tasksAfterGiphySelect = @"play";
            [self onSelectGiphyShowLoadingIndicator:NO];
            [self goBack];

        }];
        
    }] resume];
}

#pragma mark - Button Handlers
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // hiding the keyboard
    [searchBar resignFirstResponder];
    //send search giphies request
    [self loadGiphyImages:[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?api_key=%@&q=%@",giphyApiKey,searchBar.text]];
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
- (void)onSelectGiphyShowLoadingIndicator:(BOOL)showHide {
    giphyDownloading = showHide;
    if( showHide ){
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
        [layerScrollView removeFromSuperview];
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
