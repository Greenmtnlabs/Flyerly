/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/

#import "ImageEditor.h"

@interface ImageEditorViewController : ImageEditor
<
UIScrollViewDelegate,
UIBarPositioningDelegate
>
{
    IBOutlet __weak UINavigationBar *_navigationBar;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButtItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, weak) IBOutlet UIScrollView *menuView;

- (IBAction)pushedCloseBtn:(id)sender;
- (IBAction)pushedFinishBtn:(id)sender;


- (id)initWithImage:(UIImage*)image;

- (void)fixZoomScaleWithAnimated:(BOOL)animated;
- (void)resetZoomScaleWithAnimated:(BOOL)animated;



@end
