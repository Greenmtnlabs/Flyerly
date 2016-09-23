/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "ImageToolInfo+Private.h"

#import "ImageToolProtocol.h"
#import "ClassList.h"


@interface ImageToolInfo()
@property (nonatomic, strong) NSString *toolName;
@property (nonatomic, strong) NSArray *subtools;
@end

@implementation ImageToolInfo (Private)

+ (ImageToolInfo*)toolInfoForToolClass:(Class<ImageToolProtocol>)toolClass;
{
    if([(Class)toolClass conformsToProtocol:@protocol(ImageToolProtocol)] && [toolClass isAvailable]){
        ImageToolInfo *info = [ImageToolInfo new];
        info.toolName  = NSStringFromClass(toolClass);
        info.title     = [toolClass defaultTitle];
        info.available = YES;
        info.dockedNumber = [toolClass defaultDockedNumber];
        info.iconImagePath = [toolClass defaultIconImagePath];
        info.subtools = [toolClass subtools];
        info.optionalInfo = [[toolClass optionalInfo] mutableCopy];
        
        return info;
    }
    return nil;
}

+ (NSArray*)toolsWithToolClass:(Class<ImageToolProtocol>)toolClass
{
    NSMutableArray *array = [NSMutableArray array];
    
    ImageToolInfo *info = [ImageToolInfo toolInfoForToolClass:toolClass];
    if(info){
        [array addObject:info];
    }
    
    NSArray *list = [ClassList subclassesOfClass:toolClass];
    for(Class subtool in list){
        info = [ImageToolInfo toolInfoForToolClass:subtool];
        if(info){
            [array addObject:info];
        }
    }
    return [array copy];
}

@end
