/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <UIKit/UIKit.h>

#import "ImageToolInfo.h"
#import "ImageEditorTheme.h"

@protocol ImageEditorDelegate;
@protocol ImageEditorTransitionDelegate;

@interface ImageEditor : UIViewController

@property (nonatomic, weak) id<ImageEditorDelegate> delegate;
@property (nonatomic, readonly) ImageEditorTheme *theme;
@property (nonatomic, readonly) ImageToolInfo *toolInfo;

- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image delegate:(id<ImageEditorDelegate>)delegate;
- (id)initWithDelegate:(id<ImageEditorDelegate>)delegate;

- (void)showInViewController:(UIViewController<ImageEditorTransitionDelegate>*)controller withImageView:(UIImageView*)imageView;

@end



@protocol ImageEditorDelegate <NSObject>
@optional
- (void)imageEditor:(ImageEditor*)editor didFinishEdittingWithImage:(UIImage*)image;
- (void)imageEditorDidCancel:(ImageEditor*)editor;

@end


@protocol ImageEditorTransitionDelegate <ImageEditorDelegate>
@optional
- (void)imageEditor:(ImageEditor*)editor willDismissWithImageView:(UIImageView*)imageView canceled:(BOOL)canceled;
- (void)imageEditor:(ImageEditor*)editor didDismissWithImageView:(UIImageView*)imageView canceled:(BOOL)canceled;

@end

