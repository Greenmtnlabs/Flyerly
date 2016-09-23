/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "UIView+ImageToolInfo.h"

#import <objc/runtime.h>

@implementation UIView (ImageToolInfo)

- (ImageToolInfo*)toolInfo
{
    return objc_getAssociatedObject(self, @"UIView+ImageToolInfo_toolInfo");
}

- (void)setToolInfo:(ImageToolInfo *)toolInfo
{
    objc_setAssociatedObject(self, @"UIView+ImageToolInfo_toolInfo", toolInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)userInfo
{
    return objc_getAssociatedObject(self, @"UIView+ImageToolInfo_userInfo");
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, @"UIView+ImageToolInfo_userInfo", userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
