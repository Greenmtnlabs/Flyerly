/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import "ImageEditorTheme+Private.h"

@implementation ImageEditorTheme (Private)

#pragma mark- instance methods

- (NSBundle*)bundle
{
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:self.bundleName ofType:@"bundle"]];
}

#pragma mark- class methods

+ (NSString*)bundleName
{
    return self.theme.bundleName;
}

+ (NSBundle*)bundle
{
    return self.theme.bundle;
}

+ (UIImage*)imageNamed:(NSString *)path
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", self.bundleName, path]];
}

#pragma mark color settings

+ (UIColor*)backgroundColor
{
    return self.theme.backgroundColor;
}

+ (UIColor*)toolbarColor
{
    return self.theme.toolbarColor;
}

+ (UIColor*)toolbarTextColor
{
    return self.theme.toolbarTextColor;
}

+ (UIColor*)toolbarSelectedButtonColor
{
    return self.theme.toolbarSelectedButtonColor;
}

#pragma mark font settings

+ (UIFont*)toolbarTextFont
{
    return self.theme.toolbarTextFont;
}

#pragma mark UI components

+ (UIActivityIndicatorView*)indicatorView
{
    if([self.theme.delegate respondsToSelector:@selector(imageEditorThemeActivityIndicatorView)]){
        return [self.theme.delegate imageEditorThemeActivityIndicatorView];
    }
    
    // default indicator view
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    indicatorView.layer.cornerRadius = 5;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    return indicatorView;
}

+ (ToolbarMenuItem*)menuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(ImageToolInfo*)toolInfo;
{
    return [[ToolbarMenuItem alloc] initWithFrame:frame target:target action:action toolInfo:toolInfo];
}

@end
