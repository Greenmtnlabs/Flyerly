/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/

#import "HighlightShadowEffect.h"

#import "UIView+Frame.h"
#import "Configs.h"


@implementation HighlightShadowEffect
{
    UIView *_containerView;
    UISlider *_shadowSlider;
}


+ (NSString*)defaultTitle
{
    return NSLocalizedString(@"HighlightSadowEffect", @"");
}

+ (BOOL)isAvailable {
    return true;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        [superview addSubview:_containerView];
        
        [self setupSlider];
    }
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}



#pragma mark - EFFECT METHOD ==============================

- (UIImage*)applyEffect:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_shadowSlider.value] forKey:@"inputShadowAmount"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}



#pragma mark- SETUP USER INTERFACE ============================

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = true;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [_containerView addSubview:container];
    
    return slider;
}

- (void)setupSlider
{
    _shadowSlider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1];
    _shadowSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    _shadowSlider.thumbTintColor = [UIColor blackColor];
    _shadowSlider.minimumTrackTintColor = LIGHT_COLOR;
    _shadowSlider.maximumTrackTintColor = LIGHT_COLOR;
    
    
}

- (void)sliderDidChange:(UISlider*)sender
{
    [self.delegate effectParameterDidChange:self];
}

@end
