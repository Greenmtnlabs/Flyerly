/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ImageToolBase.h"

@implementation ImageToolBase

- (id)initWithImageEditor:(ImageEditorViewController*)editor withToolInfo:(ImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.editor   = editor;
        self.toolInfo = info;
    }
    return self;
}

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@", NSStringFromClass([self class])];
    //return [NSString stringWithFormat:@"%@.bundle/%@/icon.png", [ImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    
    // Image tools are sorted in the Toolbar ScrollView accordingly to the following Array:
    NSArray *tools = @[
                       
                       @"BrightnessTool",
                       @"SaturationTool",
                       @"ContrastTool",
                       @"ExposureTool",
                       @"FilterTool",
                       @"ColorizeTool",
                       @"EffectTool",
                       @"BlurTool",
                       @"ClippingTool",
                       @"ToneCurveTool",
                       @"StickerTool",
                       @"FramesTool",
                       @"BordersTool",
                       @"TexturesTool",
                       @"DrawingTool",
                       @"SplashTool",
                       @"TextTool",
                       

                       ];
    return [tools indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return @"DefaultTitle";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark - SETUP ====================

- (void)setup
{


}

- (void)cleanup
{
    
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName {
    NSString *iconName = self.toolInfo.optionalInfo[key];
    
    if(iconName.length>0){
        return [UIImage imageNamed:iconName];
    } else {
        return [ImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@", [self class]]];
    }
}


@end
