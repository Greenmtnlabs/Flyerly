/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "SaturationTool.h"
#import "Configs.h"


@implementation SaturationTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UISlider *_saturationSlider;
    UIActivityIndicatorView *_indicatorView;
}

+ (NSString*)defaultTitle {
    return NSLocalizedString(@"SaturationTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}

- (void)setup {
    _originalImage = self.editor.imageView.image;
    _thumnailImage = _originalImage;
    
    [self setupSlider];
}

- (void)cleanup {
    [_indicatorView removeFromSuperview];
    [_saturationSlider.superview removeFromSuperview];
    
    [self.editor resetZoomScaleWithAnimated: true];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [ImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 240, 35)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, slider.height)];
    container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = true;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.view addSubview:container];
    
    return slider;
}

- (void)setupSlider
{
    _saturationSlider = [self sliderWithValue:1 minimumValue:0 maximumValue:2 action:@selector(sliderDidChange:)];
    _saturationSlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.menuView.top-30);
    _saturationSlider.thumbTintColor = [UIColor blackColor];
    _saturationSlider.minimumTrackTintColor = LIGHT_COLOR;
    _saturationSlider.maximumTrackTintColor = LIGHT_COLOR;
}

- (void)sliderDidChange:(UISlider*)sender {
    static BOOL inProgress = false;
    
    if(inProgress){ return; }
    inProgress = true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_thumnailImage];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = false;
    });
}

- (UIImage*)filteredImage:(UIImage*)image {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
   
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_saturationSlider.value] forKey:@"inputSaturation"];
    
    filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];

    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}



@end
