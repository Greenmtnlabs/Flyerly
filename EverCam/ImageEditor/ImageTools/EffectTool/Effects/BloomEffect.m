/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "BloomEffect.h"

#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "Configs.h"


@implementation BloomEffect
{
    UIView *_containerView;
    UISlider *_radiusSlider;
    UISlider *_intensitySlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedString(@"BloomEffect", @"");
}

+ (BOOL)isAvailable {
    return true;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ImageToolInfo*)info {
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        [superview addSubview:_containerView];
        
        [self setupSliders];
    }
    return self;
}

- (void)cleanup {
    [_containerView removeFromSuperview];
}



#pragma mark - EFFECT METHOD ===================

- (UIImage*)applyEffect:(UIImage*)image {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CGFloat R = _radiusSlider.value * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:_intensitySlider.value] forKey:@"inputIntensity"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    CGFloat dW = (result.size.width - image.size.width)/2;
    CGFloat dH = (result.size.height - image.size.height)/2;
    
    CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    
    return [result crop:rct];
}




#pragma mark- SLIDER SETUP ==============================

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = false;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [_containerView addSubview:container];
    
    return slider;
}

- (void)setupSliders {
    // Radius Slider ================
    _radiusSlider = [self sliderWithValue:0.5 minimumValue:0 maximumValue:1.0];
    _radiusSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    _radiusSlider.thumbTintColor = [UIColor blackColor];
    _radiusSlider.minimumTrackTintColor = LIGHT_COLOR;
    _radiusSlider.maximumTrackTintColor = LIGHT_COLOR;
    
    
    // Intensity Slider =============
    _intensitySlider = [self sliderWithValue:1 minimumValue:0 maximumValue:1.0];
    _intensitySlider.superview.center = CGPointMake(25, _radiusSlider.superview.top - 150);
    _intensitySlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    _intensitySlider.thumbTintColor = [UIColor blackColor];
    _intensitySlider.minimumTrackTintColor = LIGHT_COLOR;
    _intensitySlider.maximumTrackTintColor = LIGHT_COLOR;
    
}

- (void)sliderDidChange:(UISlider*)sender
{
    [self.delegate effectParameterDidChange:self];
}

@end
