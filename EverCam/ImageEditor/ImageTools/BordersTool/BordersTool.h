/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ImageToolBase.h"

NSArray *filesList;
NSString *filePath, *bordersPath;

UIView *_workingView;
UIImage *_originalImage;

UIView *imageContainerView;


CGFloat width, height;

UIPinchGestureRecognizer *pinchGest;
UIPanGestureRecognizer *panGest;
UIRotationGestureRecognizer *rotateGest;

UILabel *titleLabel;

@interface BordersTool : ImageToolBase

@end
