/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import <Foundation/Foundation.h>

@protocol ImageToolProtocol

@required
+ (NSString*)defaultIconImagePath;
+ (CGFloat)defaultDockedNumber;
+ (NSString*)defaultTitle;
+ (BOOL)isAvailable;
+ (NSArray*)subtools;
+ (NSDictionary*)optionalInfo;

@end
