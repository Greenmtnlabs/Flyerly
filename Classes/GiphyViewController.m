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


@interface GiphyViewController ()
@end

@implementation GiphyViewController{
    UIView *giphyBgsView;
    NSArray *giphyData;
    BOOL reqGiphyApiInProccess;
    BOOL giphyDownloading;
    UILabel *giphyStatus;
    
    
}


@synthesize layerScrollView, flyer, tasksAfterGiphySelect;

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
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    // Set the title view.
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"giphyLogo1.jpg"]];
    titleImg.frame = CGRectMake(titleImg.frame.origin.x, titleImg.frame.origin.y, 65, 40);
    self.navigationItem.titleView = titleImg;

    //load trending giphy default
    [self loadGiphyImages:@"http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"];
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
    
    giphyBgsView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,layerScrollView.frame.size.width, layerScrollView.frame.size.height)];
    
    giphyBgsView.backgroundColor = [UIColor yellowColor];

    
    [layerScrollView addSubview:giphyBgsView];

    
    
    giphyStatus = [[UILabel alloc] init];
    giphyStatus.text = @"Loading..";
    [giphyStatus sizeToFit];
    [giphyBgsView addSubview:giphyStatus];
    
     __weak GiphyViewController *weakSelf = self;
    
    //send request to giphy api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        reqGiphyApiInProccess = NO;
        [weakSelf hideLoadingIndicator];
        
        giphyStatus.text = @"";
        NSLog(@"JSON: %@", responseObject);
        
        giphyData = responseObject[@"data"];
        
        if( giphyData != nil && giphyData.count > 0 ){
            int heightHandlerForMainView = 0;
            int i=0, row = 0, column = 0;
            int showInRow = 2, defX = 17, defY = 17 , defW = 162, defH = 162;
            if( IS_IPHONE_4 ){
                showInRow = 2, defX = 14, defY = 14 , defW = 140, defH = 140;
            } else if( IS_IPHONE_5 ){
                showInRow = 2, defX = 14, defY = 14 , defW = 140, defH = 140;
            } else if( IS_IPHONE_6 ){
                showInRow = 2, defX = 17, defY = 17 , defW = 162, defH = 162;
            } else if( IS_IPHONE_6_PLUS ){
                showInRow = 2, defX = 12, defY = 12 , defW = 182, defH = 182;
            }
            int x = 0, y = 0;
            for(NSDictionary *gif in giphyData ){
                column = i % showInRow;
                row = floor( i / showInRow );
                x = defX*column+defX + defW*column;
                y = defY*row+defY + defH*row;
                
                if( i > 3 ) return; //show only 4 flyers
                
                __block UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, defW, defH)];
                [imageView2.layer setBorderColor:(__bridge CGColorRef)([UIColor blackColor])];
                [imageView2.layer setBorderWidth:3.0];
                
                imageView2.backgroundColor = [UIColor redColor];
                imageView2.userInteractionEnabled = YES;
                imageView2.tag = i++;
                [giphyBgsView addSubview:imageView2];
                
                //load each giffy in separate block
                NSURL *url = [NSURL URLWithString:[[gif[@"images"] objectForKey:@"original"] objectForKey:@"url"]];

                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    if( giphyData == nil || giphyData.count < 1 ) return;
                    NSLog(@"image data loaded");
                    NSData * data = [[NSData alloc] initWithContentsOfURL: url];
                    if( giphyData == nil || giphyData.count < 1 || data == nil ) return;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if( giphyData == nil || giphyData.count < 1 ) return;
                        
                        NSLog(@"render image on view");
                        imageView2.image = [UIImage imageWithData:data];
                        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGiphy:)];
                        [imageView2 addGestureRecognizer:tapGesture];
                    });
                });
                
            }
            //GiphyBgsView will get height dynamically
            int gbvH = y+defH+defY+heightHandlerForMainView;
            int gbvW = layerScrollView.frame.size.width;
            if( IS_IPHONE_4 ){
                gbvW = x+defW+defX+10;
            }
            giphyBgsView.frame = CGRectMake(giphyBgsView.frame.origin.x, giphyBgsView.frame.origin.y, gbvW, gbvH);
            [layerScrollView addSubview:giphyBgsView];
            [layerScrollView setContentSize:CGSizeMake(giphyBgsView.frame.size.width,giphyBgsView.frame.size.height)];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        giphyStatus.text = @"Error occured while loadig Giphy, please try again later.";
    }];
}



/*
 * When user select any giphy, download mov file and play in the player
 */
-(void)selectGiphy:(id)sender{
    
    //when a process in que dont start other
    if( giphyDownloading == YES ){
        return;
    } else {
        giphyDownloading = YES;
        //showing the laoding indicator on the top right corner
        [self showLoadingIndicator];
    }
    
    __weak GiphyViewController *weakSelf = self;
    
    int tag = (int)[(UIGestureRecognizer *)sender view].tag;
    NSDictionary *gif = giphyData[tag];
    NSURL *url = [NSURL URLWithString:[[gif[@"images"] objectForKey:@"original"] objectForKey:@"mp4"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if( data == nil ){
            [weakSelf hideLoadingIndicator];
            return;
        }
            
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // HERE WE MOVE SOURCE FILE INTO FLYER FOLDER
            NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
            NSString *destination = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
            [[NSFileManager defaultManager] createFileAtPath:destination contents:data attributes:nil];
            
            int width = [[[gif[@"images"] objectForKey:@"original"] objectForKey:@"width"] integerValue];
            int height = [[[gif[@"images"] objectForKey:@"original"] objectForKey:@"height"] integerValue];
            
            //Update dictionary
            [flyer setOriginalVideoUrl:@"Template/template.mov"];
            [flyer setFlyerTypeVideoWithSize:width height:height videoSoure:@"giphy"];
            
            giphyDownloading = NO; //giphy has been loaded in video player
            giphyData = nil;
            giphyStatus = nil;
            giphyBgsView = nil;
            layerScrollView = nil;
            tasksAfterGiphySelect = @"play";
            [self.navigationController popViewControllerAnimated:YES];

        }];
        
    }] resume];
}

#pragma mark - Button Handlers
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // hiding the keyboard
    [searchBar resignFirstResponder];
    
    //[self loadGiphyImages:@"http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"];
    [self loadGiphyImages:[NSString stringWithFormat:@"%@%@",@"http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=",searchBar.text]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
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

/**
 * Cancel and go back.
 */
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
