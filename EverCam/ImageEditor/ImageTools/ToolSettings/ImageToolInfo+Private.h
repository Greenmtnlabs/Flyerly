/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "ImageToolInfo.h"

@protocol ImageToolProtocol;

@interface ImageToolInfo (Private)

+ (ImageToolInfo*)toolInfoForToolClass:(Class<ImageToolProtocol>)toolClass;
+ (NSArray*)toolsWithToolClass:(Class<ImageToolProtocol>)toolClass;

@end
