/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "UIImage+Utility.h"


#import "PreviewVC.h"
#import "ImageEditor.h"
#import "SharingVC.h"

#import <Social/Social.h>


@interface PreviewVC ()
<
ImageEditorDelegate,
ImageEditorTransitionDelegate,
ImageEditorThemeDelegate
>
@end


@implementation PreviewVC

// Hide the Status Bar
- (BOOL)prefersStatusBarHidden {
    return true;
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a bitmap context.
    UIGraphicsBeginImageContextWithOptions(newSize, true, image.scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSUInteger imageSize = [UIImagePNGRepresentation(passedImage) length];
    NSLog(@"passedImage original size: %lu", (unsigned long)imageSize);
    CGFloat scaleFactor = 4;
    
    if (imageSize >= 4500000 ) {
        _imageView.image = [self imageWithImage:passedImage scaledToSize:CGSizeMake(passedImage.size.width/scaleFactor, passedImage.size.height/scaleFactor )];
        NSLog(@"_imageView new size: %lu", (unsigned long)imageSize);
    } else {  _imageView.image = passedImage;  }

    NSLog(@"IAP MADE: %d", iapMade);
    
    
    [self refreshImageView];
    
}




#pragma mark - BUTTONS ================================
- (IBAction)savePicButt:(id)sender {
    [self savePic];
}
- (IBAction)editPicButt:(id)sender {
    [self editPic];
}



#pragma mark - ACTIONS CALLED BY THE BUTTONS  ========================
// Sets a new Image/Picture up
- (void)newPic {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeVC *homeVC = (HomeVC *)[storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    homeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homeVC animated:true completion:nil];
}


// Open the Image Editor to edit your Picture
- (void)editPic {
    if(_imageView.image) {
        ImageEditor *editor = [[ImageEditor alloc] initWithImage:_imageView.image delegate:self];
        [self presentViewController:editor animated:true completion:nil];

    } else {
        [self newPic];
    }
}

// Save the edited image (with sharing options)
- (void)savePic {
    if(_imageView.image){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SharingVC *shVC = (SharingVC *)[storyboard instantiateViewControllerWithIdentifier:@"SharingVC"];
        [self presentViewController:shVC animated:true completion:nil];
        
        // Pass the Edited Image to the SharingScreen
        imageToBeShared = _imageView.image;
        
    // Open the HomeVC where you can choose where to pick your picture up
    } else {
        [self newPic];
    }

    
}




#pragma mark- IMAGE EDITOR DELEGATE ==========================

- (void)imageEditor:(ImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    _imageView.image = image;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(ImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled {
    [self refreshImageView];
}




#pragma mark- IMAGE SCROLLVIEW SETTINGS ======================

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.superview.frame.size.width;
    CGFloat H = _imageView.superview.frame.size.height;
    
    CGRect rct = _imageView.superview.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.superview.frame = rct;
}



// Refresh the ImageView ===========================
- (void)refreshImageView  {
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimate: false];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    _imageView.frame = CGRectMake(0, 0, W, H);
    _imageView.superview.bounds = _imageView.bounds;
    
}

- (void)resetZoomScaleWithAnimate:(BOOL)animated {
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
