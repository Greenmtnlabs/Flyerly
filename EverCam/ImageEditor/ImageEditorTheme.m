/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "ImageEditorTheme.h"
#import "Configs.h"


@implementation ImageEditorTheme

#pragma mark - singleton pattern

static ImageEditorTheme *_sharedInstance = nil;

+ (ImageEditorTheme*)theme
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ImageEditorTheme alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleName = @"ImageEditor";
        
        
        // Bottom Toolbar's background color for active selections ====================
      //  _toolbarSelectedButtonColor =
        _toolbarSelectedButtonColor = [UIColor clearColor];
        
    }
    
    return self;
}

@end
