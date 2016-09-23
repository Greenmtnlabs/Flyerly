/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <Foundation/Foundation.h>

#import "ImageToolSettings.h"

@protocol ColorizeBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface ColorizeBase : NSObject
<
ImageToolProtocol,
ColorizeBaseProtocol
>

@end
