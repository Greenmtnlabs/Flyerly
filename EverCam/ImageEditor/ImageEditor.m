/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ImageEditor.h"

#import "ImageEditorViewController.h"

@interface ImageEditor ()

@end


@implementation ImageEditor

- (id)init
{
    return [[ImageEditorViewController alloc] init];
}

- (id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image delegate:nil];
    
}

- (id)initWithImage:(UIImage*)image delegate:(id<ImageEditorDelegate>)delegate
{
    return [[ImageEditorViewController alloc] initWithImage:image delegate:delegate];
}

- (id)initWithDelegate:(id<ImageEditorDelegate>)delegate
{
    return [[ImageEditorViewController alloc] initWithDelegate:delegate];
}

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    
}

- (ImageEditorTheme*)theme
{
    return [ImageEditorTheme theme];
}


@end

