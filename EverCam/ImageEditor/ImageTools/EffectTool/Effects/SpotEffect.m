/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import "SpotEffect.h"
#import "UIView+Frame.h"
#import "Configs.h"


@interface SpotCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface SpotEffect()
<UIGestureRecognizerDelegate>
@end


@implementation SpotEffect
{
    UIView *_containerView;
    SpotCircle *_circleView;
    
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
}



+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"SpotEffect", nil, [ImageEditorTheme bundle], @"Spot", @"");
}

+ (BOOL)isAvailable {
    return true;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ImageToolInfo *)info {
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:frame];
        [superview addSubview:_containerView];
        
        _X = 0.5;
        _Y = 0.5;
        _R = 0.5;
        
        [self setUserInterface];
    }
    return self;
}

- (void)cleanup {
    [_containerView removeFromSuperview];
}


#pragma mark - EFFECT METHOD ===================

- (UIImage*)applyEffect:(UIImage*)image {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * 0.5 * (_R + 0.1);
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width * _X Y:image.size.height * (1 - _Y)];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}




#pragma mark- INTERFACE STUP  =============

- (void)setUserInterface {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContainerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainerView:)];
    
    pan.maximumNumberOfTouches = 1;
    
    tap.delegate = self;
    pinch.delegate = self;
    
    [_containerView addGestureRecognizer:tap];
    [_containerView addGestureRecognizer:pan];
    [_containerView addGestureRecognizer:pinch];
    
    _circleView = [[SpotCircle alloc] init];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    [_containerView addSubview:_circleView];
    
    [self drawCircleView];
}

- (void)drawCircleView
{
    CGFloat R = MIN(_containerView.width, _containerView.height) * (_R + 0.1) * 1.2;
    
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_containerView.width * _X, _containerView.height * _Y);
    
    [_circleView setNeedsDisplay];
}

- (void)tapContainerView:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:_containerView];
    _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
    _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
    
    [self drawCircleView];
    
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.delegate effectParameterDidChange:self];
    }
}

- (void)panContainerView:(UIPanGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:_containerView];
    _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
    _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
    
    [self drawCircleView];
    
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.delegate effectParameterDidChange:self];
    }
}

- (void)pinchContainerView:(UIPinchGestureRecognizer*)sender
{
    static CGFloat initialScale;
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialScale = (_R + 0.1);
    }
    
    _R = MIN(1.1, MAX(0.1, initialScale * sender.scale)) - 0.1;
    
    [self drawCircleView];
    
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.delegate effectParameterDidChange:self];
    }
}

@end




#pragma mark - UI COMPONENTS ================================

@implementation SpotCircle

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.x += 1;
    rct.origin.y += 1;
    rct.size.width -= 2;
    rct.size.height -= 2;
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeEllipseInRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kEffectToolAnimationDuration delay:1
    options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
    animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
}

@end

