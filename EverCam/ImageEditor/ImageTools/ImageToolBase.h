/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <Foundation/Foundation.h>

#import "ImageEditorViewController.h"
#import "ImageToolSettings.h"


static const CGFloat kImageToolAnimationDuration = 0.3;
static const CGFloat kImageToolFadeoutDuration   = 0.2;



@interface ImageToolBase : NSObject <ImageToolProtocol>

@property (nonatomic, weak) ImageEditorViewController *editor;
@property (nonatomic, weak) ImageToolInfo *toolInfo;

- (id)initWithImageEditor:(ImageEditorViewController*)editor withToolInfo:(ImageToolInfo*)info;

- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName;

@end
