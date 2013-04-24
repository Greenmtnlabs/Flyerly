//
//  CustomPhotoController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/24/13.
//
//

#import "CustomPhotoController.h"

#define IMAGE_HEIGHT 204
#define IMAGE_WIDTH  204
@implementation CustomPhotoController

@synthesize scrollView, imageView, image, callbackObject, callbackOnComplete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the size of the scrollview.
        
    }
    return self;
}

- (void)dealloc {
    [scrollView release];
    [imageView release];
    [image release];
    [callbackObject release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Image Preparation

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark - Process Image Crop

- (IBAction)onSelectImage:(UIButton *)sender{
    
    // Get the content offset in scroll view.
    CGPoint scrollOffset = CGPointMake(
                                       scrollView.contentOffset.x + ((self.view.frame.size.width - IMAGE_WIDTH) / 2),
                                       scrollView.contentOffset.y + ((self.view.frame.size.height - IMAGE_HEIGHT) /2));
    
    // Get the offset of the image.
    CGPoint imageOffset = CGPointMake( imageView.frame.origin.x,
                                      imageView.frame.origin.y);
    
    // Create rectangle that represents a cropped image
    // from the middle of the current view.
    float deltaX = ( scrollOffset.x - imageOffset.x ) /
    scrollView.zoomScale;
    float deltaY = ( scrollOffset.y - imageOffset.y ) /
    scrollView.zoomScale;
    float imageWidth = ( IMAGE_WIDTH + (( deltaX < 0 ) ? deltaX : 0 ) ) / scrollView.zoomScale;
    float imageHeight = ( IMAGE_HEIGHT + (( deltaY < 0 ) ? deltaY : 0) ) / scrollView.zoomScale;
    
    // If the delta is negative, then make it zero, we have already adjusted
    // the width and height above.
    deltaX = (deltaX < 0) ? 0 : deltaX;
    deltaY = (deltaY < 0) ? 0 : deltaY;
    
    CGRect rect = CGRectMake(deltaX,
                             deltaY,
                             imageWidth, imageHeight);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef
                                       scale:scrollView.zoomScale
                                 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    // Pass the image to callback function.
    [callbackObject performSelector:callbackOnComplete withObject:img];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *tmpImage = [self scaleAndRotateImage:image];
    [image release];
    image = [tmpImage retain];
    
    // Get the size of the image.
    CGSize imageSize = [image size];
    
    // Content size for scrollview needs to be twice this size.
    CGSize contentSize = CGSizeMake(imageSize.width  + self.view.frame.size.width, imageSize.height + self.view.frame.size.height);
    [scrollView setContentSize:contentSize];
    
    // Center on the scroll view.
    [scrollView setContentOffset:CGPointMake((contentSize.width - self.view.frame.size.width) / 2,
                                             (contentSize.height - self.view.frame.size.height) / 2)];
    
    // Set the image and frame of image view so that the image is centered in
    // the scroll view.
    [imageView setImage:self.image];
    [imageView setFrame:CGRectMake((contentSize.width - imageSize.width)/2,
                                   (contentSize.height - imageSize.height)/2,
                                   imageSize.width, imageSize.height)];
}

- (void)viewWillAppear:(BOOL)animated {
    // Remember the state so that we may revert once we leave this screen.
    //previosNavigationBarState = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Crop" style:UIBarButtonItemStyleDone target:self action:@selector(onSelectImage:)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];

}

- (void)viewWillDisappear:(BOOL)animated {
    // Revert to how the navigation bar was before we showed up.
    //self.navigationController.navigationBarHidden = previosNavigationBarState;
    [super viewWillDisappear:animated];
}

#pragma mark UIScrollViewDelegate

/**
 * Support for zooming.
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    // Get the size of the image.
    CGSize imageSize = [image size];
    
    // Content size for scrollview needs to be twice this size.
    CGSize contentSize = CGSizeMake(self.view.frame.size.width + (imageSize.width * scale), self.view.frame.size.height + ( imageSize.height * scale));
    [self.scrollView setContentSize:contentSize];
}

@end