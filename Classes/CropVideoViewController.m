//
//  CropVideoViewController.m
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import "CropVideoViewController.h"
#import "FlyerlySingleton.h"
#import "CommonFunctions.h"
#import "Common.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CropVideoViewController (){
    BOOL isGiphy; // sets to YES if Giphy is given
    BOOL isSizeGreater; // sets to YES if Giphy rect is greater than standard size
}

@end

@implementation CropVideoViewController
@synthesize giphyDic;

/**
 * Initialize the view.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )) {
        
        // Done Button
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 42)];
        [nextButton addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        
        [self.navigationItem setRightBarButtonItem:doneBarButton];
        
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
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0];
        label.text = @"CROP";
        
        self.navigationItem.titleView = label;
    }
    
    return self;
}

/**
 * View did load.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
//    player = [[MPMoviePlayerController alloc] initWithContentURL:_url];
//    [player.view setFrame:_playerView.bounds];
//    [_playerView addSubview:player.view];
//     [player prepareToPlay];

    // create a player view controller
   player = [AVPlayer playerWithURL:_url];
    avPlayerController = [[AVPlayerViewController alloc] init];
    
    [self addChildViewController:avPlayerController];
    avPlayerController.view.backgroundColor = [UIColor clearColor];
    avPlayerController.view.frame = _playerView.bounds;
    avPlayerController.player = player;
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    avPlayerController.showsPlaybackControls = YES;
    player.closedCaptionDisplayEnabled = NO;
    [player play];
   // avPlayerController.view.center = _playerView.center;
    [_playerView addSubview:avPlayerController.view];

//    player = [AVPlayer playerWithURL:_url];
//
//    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
//    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    layer.frame = _playerView.bounds;
//    layer.masksToBounds = YES;
//
//    // Put the AVPlayerLayer on top of the image view.
//    [self.view.layer addSublayer:layer];
//
//    [player play];
   
    [self calculateDimension];
    
    // Wait for the size to be calculated.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(calculateDimension:)
//                                                 name:MPMovieNaturalSizeAvailableNotification
//                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:)
        name:AVPlayerItemDidPlayToEndTimeNotification
      object:[player currentItem]];
    
    // Set a border for the cropview.
}

/**
 * When the view disappears, remove the observer so that the controller
 * can get deallocated.
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Calculate resolution

/**
 * Get the dimensions of the curren videw.
 */

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)calculateDimension//:(NSNotification *)n
{
    
    if(giphyDic != NULL)
    {
        isGiphy = YES;
    }
    
    // Get aspect ratio of video
    aspectRatio =  avPlayerController.view.frame.size.width /  avPlayerController.view.frame.size.height;
    
    // Remember the untranslated crop size.
    originalConceptualFrame = _cropView.frame;
    
    // Get the scale ratio.
    if (  avPlayerController.view.frame.size.width <  avPlayerController.view.frame.size.height )
    {
        // If the video is in portrait mode.
        scaleRatio = _desiredVideoSize.width /  avPlayerController.view.frame.size.width;
        
        if(isGiphy)
        {
            scaleRatio = [[giphyDic objectForKey:@"desiredWidth"] integerValue] /  avPlayerController.view.frame.size.width;
        }
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat width = _playerView.frame.size.height * aspectRatio;
        _cropView.frame = CGRectMake((_playerView.size.width - width) / 2.0, (_playerView.size.height - width) / 2.0, width, width );
        
        // Do not allowing moving on x axis
        _cropView.fixedX = YES;
        
    }
    else
    {
        // If the video is landscape or square.
        scaleRatio = _desiredVideoSize.height /  avPlayerController.view.frame.size.height;
        
        if(isGiphy){
            scaleRatio = [[giphyDic objectForKey:@"desiredHeight"] integerValue] /  avPlayerController.view.frame.size.height;
        }
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat height = _playerView.frame.size.width / aspectRatio;
        _cropView.frame = CGRectMake( ( _playerView.size.width - height) / 2.0, ( _playerView.size.height - height) / 2.0, height, height );
        
        // Do not allow moving on y axis
        _cropView.fixedY = YES;
    }
    
    if(isGiphy)
    {
        
        CGFloat newWH;
        
        if ( avPlayerController.view.frame.size.width <  avPlayerController.view.frame.size.height )
        { // for Portrait
            
            newWH = [self getNewWidth:[[giphyDic objectForKey:@"minWH"] integerValue]  :[[giphyDic objectForKey:@"maxWH"] integerValue] :_playerView.size.height];
            
            if( _cropView.frame.size.width >= _playerView.size.width)
            {
                
                if(aspectRatio > 0.9){
                    
                   aspectRatio = 0.75;
                   if(IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
                       aspectRatio = 0.85;
                   }
                }
                CGFloat height = _playerView.frame.size.height * aspectRatio;
                if(IS_IPHONE_XS || IS_IPHONE_XR)
                {
                    newWH = 320;
                    _cropView.frame = CGRectMake(30, (self.view.size.height - height) / 2.0, newWH, newWH);
                }
                else
                {
                    newWH = 320;
                    _cropView.frame = CGRectMake(0, (self.view.size.height - height) / 2.0, newWH, newWH);
                }
                
                isSizeGreater = YES;
            }
            
        }
        else
        { // for Landescape
            newWH = [self getNewWidth:[[giphyDic objectForKey:@"maxWH"] integerValue]  :[[giphyDic objectForKey:@"minWH"] integerValue] :_playerView.size.width];
        }
        _cropView.size = CGSizeMake(newWH,newWH);
    }
    // Remember the translated crop size.
    originalCropFrame = _cropView.frame;
    
    // Bring this view to front.
    [_playerView bringSubviewToFront:_cropView];
}

#pragma mark - Button Event Handlers

/**
 * Go back to the last screen.
 */
-(void) goBack
{
    [player pause];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
    
    if( _onVideoCancel != NULL ){
        _onVideoCancel();
    }
}

/*
 * Determines new width/height and x/y axes (w.r.t. ratio)
 * @params:
 *      originalVideoWH: CGFloat
 *      cropXY: CGFloat
 *      playerWH: CGFloat
 * @return:
 *      newChildWidth: int
 */
-(int)getNewWidth: (CGFloat)originalVideoWH :(CGFloat)cropXY :(CGFloat)playerWH{
    int newChildWidth = (cropXY/originalVideoWH)*playerWH;
    return newChildWidth;
}

/**
 * We are done, use the cropped and filtered image.
 */
-(void)onDone
{
    if ( isGiphy == false )
    {
        int videoDuration = [CommonFunctions videoDuration:_url];
        if (videoDuration < 3 )
        {
            [CommonFunctions showAlert:WARNING :PLEASE_CREATE_M_T_3_VIDEO :Ok];
            return;
        }
    }
    // Crop rect to use will differ based on whether this is from gallery
    // or camera. Camera has the video rotated.
    CGRect cropRect;

    // If this is portrait, then do not allow x translations
    if ( avPlayerController.view.frame.size.width < avPlayerController.view.frame.size.height ) {

        CGFloat y = _cropView.origin.y * avPlayerController.view.frame.size.width / _playerView.frame.size.height;

        cropRect = CGRectMake(0, y, _desiredVideoSize.width, _desiredVideoSize.height );

        if(isGiphy){
            y = [self getNewWidth:_playerView.frame.size.height :_cropView.origin.y :[[giphyDic objectForKey:@"minWH"] integerValue]];

            aspectRatio = avPlayerController.view.frame.size.width / avPlayerController.view.frame.size.height;

            if(aspectRatio > 0.9)
            {
                y = y/13;
            }

            cropRect = CGRectMake(0, y, [[giphyDic objectForKey:@"desiredWidth"] integerValue], [[giphyDic objectForKey:@"desiredHeight"] integerValue] );
        }
    } else {
        CGFloat maxHeight = 568.0;
        if ( IS_IPHONE_4 ) {
            maxHeight = 480;
        }

        CGFloat x = avPlayerController.view.frame.size.width / _playerView.frame.size.width + (_cropView.origin.x * maxHeight / _playerView.frame.size.width);
        cropRect = CGRectMake(x, 0, _desiredVideoSize.width, _desiredVideoSize.height);

        if(isGiphy)
        {
            x = [self getNewWidth:_playerView.frame.size.width :_cropView.origin.x :[[giphyDic objectForKey:@"maxWH"] integerValue]];
            cropRect = CGRectMake(x, 0, [[giphyDic objectForKey:@"desiredWidth"] integerValue], [[giphyDic objectForKey:@"desiredHeight"] integerValue] );
        }

    }

    [player pause];

    _onVideoFinished( _url, cropRect, scaleRatio );

    // Go back to the last screen.
    [self.navigationController popViewControllerAnimated:YES];
}

@end

