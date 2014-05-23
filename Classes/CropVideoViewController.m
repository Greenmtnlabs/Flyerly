//
//  CropVideoViewController.m
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import "CropVideoViewController.h"
#import "FlyerlySingleton.h"

@interface CropVideoViewController ()

@end

@implementation CropVideoViewController

/**
 * Initialize the view.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] )) {
        
        // Done Button
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 42)];
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
        label.textAlignment = UITextAlignmentCenter;
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
        scaleRatio = _cropView.frame.size.width / player.naturalSize.width;
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat width = _playerView.frame.size.height * aspectRatio;
        _cropView.frame = CGRectMake( ( _playerView.size.width - width) / 2.0,
                                     ( _playerView.size.height - width) / 2.0,
                                     width,
                                     width );
        
        // Do not allowing moving on x axis
        _cropView.fixedX = YES;
        
    } else {
        // If the video is landscape or square.
        scaleRatio = _cropView.frame.size.height / player.naturalSize.height;
        
        // Adjust the cropview to match current width of portrait. Keep view centered.
        CGFloat height = _playerView.frame.size.width / aspectRatio;
        _cropView.frame = CGRectMake( ( _playerView.size.width - height) / 2.0,
                                     ( _playerView.size.height - height) / 2.0,
                                     height,
                                     height );
        
        // Do not allow moving on y axis
        _cropView.fixedY = YES;
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
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
    
    _onVideoCancel();
}

/**
 * We are done, use the cropped and filtered image.
 */
-(void)onDone {
    /*
    // The change in width needs to be first translated from our UI width to
    // our conceptual width.
    CGFloat sizeRatio = originalConceptualSize.width / originalCropSize.width;
    
    // Now get the conceptual size based on ui size.
    CGSize conceptualSize = CGSizeMake( sizeRatio * _cropView.frame.size.width,
                                       sizeRatio * _cropView.frame.size.height );
    */
    CGRect cropRect = CGRectMake( _cropView.origin.x,
                                 _cropView.origin.y,
                                 _desiredVideoSize.width,
                                 _desiredVideoSize.height );
    
    // Update scale ratio to reflect the change in crop size from original.
    if ( player.naturalSize.width < player.naturalSize.height ) {
        // If this is portrait, then do not allow x translations
        cropRect.origin.x = 0;
        
        
        // If the video is in portrait mode.
        //scaleRatio = conceptualSize.width / player.naturalSize.width;
        
    } else {
        // If its landscape do not allow y translations
        cropRect.origin.y = 0;
        
        // If the video is landscape or square.
        //scaleRatio = conceptualSize.height / player.naturalSize.height;
    }
    
    _onVideoFinished( _url, cropRect, scaleRatio );
    
    // Go back to the last screen.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
