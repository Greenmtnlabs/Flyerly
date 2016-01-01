//
//  CropVideoViewController.m
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import "CropVideoViewController.h"
#import "FlyerlySingleton.h"

@interface CropVideoViewController (){
    BOOL isGiphy, isSizeGreater;

}

@end

@implementation CropVideoViewController
@synthesize giphyRect;

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
    player = [[MPMoviePlayerController alloc] initWithContentURL:_url];
    [player.view setFrame:_playerView.bounds];
    [_playerView addSubview:player.view];
    
    [player prepareToPlay];
    
    // Wait for the size to be calculated.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calculateDimension:)
                                                 name:MPMovieNaturalSizeAvailableNotification
                                               object:player];
    
    // Set a border for the cropview.
    
}

/**
 * When the view disappears, remove the observer so that the controller
 * can get deallocated.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Calculate resolution

/**
 * Get the dimensions of the curren videw.
 */
-(void)calculateDimension:(NSNotification *)n {
    
    // Get aspect ratio of video
    aspectRatio = player.naturalSize.width / player.naturalSize.height;
    
    // Remember the untranslated crop size.
    originalConceptualFrame = _cropView.frame;
    
    // Get the scale ratio.
    if ( player.naturalSize.width < player.naturalSize.height ) {
        // If the video is in portrait mode.
        scaleRatio = _desiredVideoSize.width / player.naturalSize.width;
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat width = _playerView.frame.size.height * aspectRatio;
        _cropView.frame = CGRectMake((_playerView.size.width - width) / 2.0,
                                     (_playerView.size.height - width) / 2.0,
                                     width,
                                     width );
        
        // Do not allowing moving on x axis
        _cropView.fixedX = YES;
        
    } else {
        // If the video is landscape or square.
        scaleRatio = _desiredVideoSize.height / player.naturalSize.height;
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat height = _playerView.frame.size.width / aspectRatio;
        _cropView.frame = CGRectMake( ( _playerView.size.width - height) / 2.0,
                                     ( _playerView.size.height - height) / 2.0,
                                     height,
                                     height );
        
        // Do not allow moving on y axis
        _cropView.fixedY = YES;
    }
    
    if(!CGRectIsEmpty(giphyRect)){
        isGiphy = YES;
    }
    
    if(isGiphy){
        
        CGFloat newWH;
        
        if ( player.naturalSize.width < player.naturalSize.height ){
            
            newWH = [self getNewWidth:giphyRect.size.width :giphyRect.size.height :_playerView.size.height];
            
            if( _cropView.frame.size.width > _playerView.size.width){
                CGFloat height = _playerView.frame.size.height * aspectRatio;
                //newWH = [self getNewWidth:giphyRect.size.height :giphyRect.size.width :_playerView.size.width];
                newWH = 320;
                _cropView.frame = CGRectMake(0, (self.view.size.height - height) / 2.0, newWH, newWH);
                isSizeGreater = YES;
            }
            
            
        } else {
            newWH = [self getNewWidth:giphyRect.size.height :giphyRect.size.width :_playerView.size.width];
        }
        _cropView.size = CGSizeMake(newWH,newWH);
    }
    // Remember the translated crop size.
    originalCropFrame = _cropView.frame;
    
    // Bring this view to front.
    [_playerView bringSubviewToFront:_cropView];
    
    // Get the naturatl size and log it
    NSLog(@"Natural size: %.2f x %.2f", player.naturalSize.width, player.naturalSize.height );
    NSLog(@"Scale ratio: %.2f", scaleRatio );
    NSLog(@"Aspect ratio: %.2f", scaleRatio );
    NSLog(@"Crop size: %.2f x %.2f", _desiredVideoSize.width, _desiredVideoSize.height );
}

#pragma mark - Button Event Handlers

/**
 * Go back to the last screen.
 */
-(void) goBack {
    [player stop];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
    
    if( _onVideoCancel != NULL ){
        _onVideoCancel();
    }
}

-(int)getNewWidth: (CGFloat)originalVideoWH :(CGFloat)cropXY :(CGFloat)playerWH{
    int newChildWidth = (cropXY/originalVideoWH)*playerWH;
    return newChildWidth;
}

/**
 * We are done, use the cropped and filtered image.
 */
-(void)onDone {
    // Crop rect to use will differ based on whether this is from gallery
    // or camera. Camera has the video rotated.
    CGRect cropRect;
    
    // If this is portrait, then do not allow x translations
    if ( player.naturalSize.width < player.naturalSize.height ) {
        
        CGFloat y = _cropView.origin.y * player.naturalSize.width / _playerView.frame.size.height;
        
        if(isGiphy){
            y = [self getNewWidth:_playerView.frame.size.height :_cropView.origin.y :giphyRect.size.width];
            
            if(isSizeGreater){
//                int h = 40;
//                if(IS_IPHONE_4 || IS_IPHONE_5){
//                    h = 30;
//                } else if(IS_IPHONE_6){
//                    h = 80;
//                } else if (IS_IPHONE_6_PLUS){
//                    h = 120;
//                }
                
               
                //y = [self getNewWidth:_playerView.frame.size.height :_cropView.origin.y :1000];
                //y = [self getNewWidth:giphyRect.size.height :giphyRect.size.width :_playerView.frame.size.height];
                _desiredVideoSize.width = 320;
                _desiredVideoSize.height = 320;
            }
        }
        
        cropRect = CGRectMake(
                0,
                 y,
                _desiredVideoSize.width,
                _desiredVideoSize.height );
    } else {
        CGFloat maxHeight = 568.0;
        if ( IS_IPHONE_4 ) {
            maxHeight = 480;
        }
        
        CGFloat x = player.naturalSize.width / _playerView.frame.size.width + (_cropView.origin.x * maxHeight / _playerView.frame.size.width);
        
        if(isGiphy){
            x = [self getNewWidth:_playerView.frame.size.width :_cropView.origin.x :giphyRect.size.height];
        }
        
        cropRect = CGRectMake(
                          x,
                          0,
                          _desiredVideoSize.width,
                          _desiredVideoSize.height);
    }
    
    [player stop];

    _onVideoFinished( _url, cropRect, scaleRatio );
    
    // Go back to the last screen.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
