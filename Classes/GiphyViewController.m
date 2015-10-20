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
    BOOL giphyLoading;
    UILabel *giphyStatus;
}


@synthesize layerScrollView, flyer, tasksAfterGiphySelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGiphyImages];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Load giphy images from internet
 */
-(void)loadGiphyImages{
    giphyBgsView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,layerScrollView.frame.size.width, layerScrollView.frame.size.height)];
    
    giphyBgsView.backgroundColor = [UIColor yellowColor];

    
    [layerScrollView addSubview:giphyBgsView];

    
    
    giphyStatus = [[UILabel alloc] init];
    giphyStatus.text = @"Loading..";
    [giphyStatus sizeToFit];
    [giphyBgsView addSubview:giphyStatus];
    
    //send request to giphy api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        giphyStatus.text = @"";
        NSLog(@"JSON: %@", responseObject);
        
        giphyData = responseObject[@"data"];
        
        if( giphyData != nil && giphyData.count > 0 ){
            int heightHandlerForMainView = 0;
            int i=0, row = 0, column = 0;
            int showInRow = 2, defX = 10, defY = 10 , defW = 182, defH = 182;
            if( IS_IPHONE_4 ){
                showInRow = 9999;//we will have only one row in iphone 4
                defX = 10, defY = 5 , defW = 50, defH = 50;
            } else if( IS_IPHONE_5 ){
                showInRow = 2, defX = 14, defY = 14 , defW = 140, defH = 140; heightHandlerForMainView = 20;
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
                
                if( i > 5 ) return; //show only 6 flyers
                
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
    if( giphyLoading == YES ){
        return;
    }
    giphyLoading = YES;
    
    int tag = (int)[(UIGestureRecognizer *)sender view].tag;
    NSDictionary *gif = giphyData[tag];
    NSURL *url = [NSURL URLWithString:[[gif[@"images"] objectForKey:@"original"] objectForKey:@"mp4"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
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
            
            giphyLoading = NO; //giphy has been loaded in video player
            giphyData = nil;
            giphyStatus = nil;
            giphyBgsView = nil;
            layerScrollView = nil;
            
            
            
            tasksAfterGiphySelect = @"play";
            [self.navigationController popViewControllerAnimated:YES];

        }];
        
    }] resume];
    
}


@end
