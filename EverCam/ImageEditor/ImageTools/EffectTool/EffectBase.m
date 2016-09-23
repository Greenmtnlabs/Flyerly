/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "EffectBase.h"
#import "Configs.h"

@implementation EffectBase

#pragma mark-

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@", NSStringFromClass(self.class)];
    //[NSString stringWithFormat:@"%@.bundle/EffectTool/%@.png", [ImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // List of Effects available, you can reorder them or add new ones here =======
    NSArray *effects = @[
                         @"EffectBase",
                         @"SpotEffect",
                         @"HueEffect",
                         @"HighlightShadowEffect",
                         @"BloomEffect",
                         @"GloomEffect",
                         @"PosterizeEffect",
                         @"PixellateEffect",
                         @"BumpEffect",
                         @"SplashEffect",
                         @"PinchEffect",
                         
                         
                         ];
    return [effects indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle {
    return NSLocalizedString(@"EffectBase", @"");
}

+ (BOOL)isAvailable {
    return true;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.toolInfo = info;
    }
    return self;
}

- (void)cleanup
{
    
}

- (BOOL)needsThumnailPreview
{
    return true;
}

- (UIImage*)applyEffect:(UIImage*)image
{
    return image;
}

@end
