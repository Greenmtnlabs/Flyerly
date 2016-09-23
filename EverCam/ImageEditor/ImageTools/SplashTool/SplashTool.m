//
//  CLSplashTool.m
//
//  Created by sho yakushiji on 2014/06/21.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "SplashTool.h"
#import "Configs.h"


static NSString* const kSplashToolEraserIconName = @"eraserIconAssetsName";

@implementation SplashTool
{
    UIImageView *_drawingView;
    UIImage *_maskImage;
    UIImage *_grayImage;
    CGSize _originalImageSize;
    
    CGPoint _prevDraggingPosition;
    UIView *_menuView;
    UISlider *_widthSlider;
    UIView *_strokePreview;
    UIView *_strokePreviewBackground;
    UIImageView *_eraserIcon;
    UILabel *eraserLabel;
    UILabel *infoLabel;
    
    ToolbarMenuItem *_colorBtn;
}

+ (NSArray*)subtools
{
    return nil;
}


+ (NSString*)defaultTitle {
    return NSLocalizedString(@"SplashTool", @"");
}

+ (BOOL)isAvailable {
    return true;
}

+ (NSDictionary*)optionalInfo {
    return @{  kSplashToolEraserIconName : @"",  };
}



#pragma mark- SETUP =====================

- (void)setup {
    _originalImageSize = self.editor.imageView.image.size;
    
    _drawingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    _drawingView.contentMode = UIViewContentModeScaleAspectFit;
    
    _grayImage = [[self.editor.imageView.image aspectFit:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] grayScaleImage];
    _drawingView.image = _grayImage;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    panGesture.maximumNumberOfTouches = 1;
    
    _drawingView.userInteractionEnabled = true;
    [_drawingView addGestureRecognizer:panGesture];
    
    [self.editor.imageView addSubview:_drawingView];
    self.editor.imageView.userInteractionEnabled = true;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = false;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = false;
    
    _menuView = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    _menuView.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view addSubview:_menuView];
    
    [self setMenu];
    
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
         _menuView.transform = CGAffineTransformIdentity;
    }];
}

- (void)cleanup {
    [_drawingView removeFromSuperview];
    [infoLabel removeFromSuperview];
    self.editor.imageView.userInteractionEnabled = false;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kImageToolAnimationDuration animations:^{
        _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
    } completion:^(BOOL finished) {
        [_menuView removeFromSuperview];
    }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}



#pragma mark - SLIDER SETUP

- (UISlider*)defaultSliderWithWidth:(CGFloat)width
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, width, 34)];
    slider.thumbTintColor = [UIColor whiteColor];
    slider.minimumTrackTintColor = LIGHT_COLOR;
    slider.maximumTrackTintColor = LIGHT_COLOR;
    
return slider;
}

- (UIImage*)widthSliderBackground
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [[[ImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
    
    CGFloat strRadius = 1;
    CGFloat endRadius = size.height/2 * 0.6;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2 - 2);
    CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, true);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, true);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}


// SETUP MENU
- (void)setMenu {
    CGFloat W = 70;
    
    _widthSlider = [self defaultSliderWithWidth:_menuView.width - W - 20];
    _widthSlider.left = 10;
    _widthSlider.top = _menuView.height/2 - _widthSlider.height/2;
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.1;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_menuView addSubview:_widthSlider];
    
    _strokePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 15, W - 15)];
    _strokePreview.layer.cornerRadius = _strokePreview.height/2;
    _strokePreview.layer.borderWidth = 1;
    _strokePreview.layer.borderColor = [UIColor whiteColor].CGColor;
    _strokePreview.center = CGPointMake(_menuView.width-W/2, _menuView.height/2);
    [_menuView addSubview:_strokePreview];
    
    _strokePreviewBackground = [[UIView alloc] initWithFrame:_strokePreview.frame];
    _strokePreviewBackground.layer.cornerRadius = _strokePreviewBackground.height/2;
    _strokePreviewBackground.alpha = 0.3;
    [_strokePreviewBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strokePreviewDidTap:)]];
    [_menuView insertSubview:_strokePreviewBackground aboveSubview:_strokePreview];
    
    _strokePreview.backgroundColor = [[ImageEditorTheme theme] toolbarTextColor];
    _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
    
    _eraserIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _eraserIcon.image  =  [self imageForKey:kSplashToolEraserIconName defaultImageName:@"btn_eraser"];
    _eraserIcon.hidden = true;
    [_menuView addSubview:_eraserIcon];
    
    [self widthSliderDidChange:_widthSlider];
    
    _menuView.clipsToBounds = false;
    
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.editor.view.frame.size.height-80, self.editor.view.frame.size.width, 20)];
    infoLabel.font = [UIFont fontWithName:@"BebasNeue" size:16];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.text = @"Tap the Stroke preview to enable/disable the Eraser";
    [self.editor.view addSubview: infoLabel];
}

- (void)widthSliderDidChange:(UISlider*)sender
{
    CGFloat scale = MAX(0.05, _widthSlider.value);
    _strokePreview.transform = CGAffineTransformMakeScale(scale, scale);
    _strokePreview.layer.borderWidth = 2/scale;
}




// STROKE PREVIEW CIRCLE TAPPED
- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender {
    _eraserIcon.hidden = !_eraserIcon.hidden;
    
    // Show an info Label
    eraserLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    eraserLabel.center = self.editor.view.center;
    eraserLabel.font = [UIFont fontWithName:@"BebasNeue" size:35];
    eraserLabel.textColor = LIGHT_COLOR;
    eraserLabel.textAlignment = NSTextAlignmentCenter;
    [self.editor.view addSubview:eraserLabel];
    
    if (_eraserIcon.hidden) {   eraserLabel.text = @"Eraser Off";
    } else {  eraserLabel.text = @"Eraser On";  }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeSplashLabel) userInfo:nil repeats:false];
}
-(void)removeSplashLabel {
    [eraserLabel removeFromSuperview];
}



- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:_prevDraggingPosition to:currentDraggingPosition];
        _drawingView.image = [_grayImage maskedImage:_maskImage];
    }
    _prevDraggingPosition = currentDraggingPosition;
}

-(void)drawLine:(CGPoint)from to:(CGPoint)to
{
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strokeWidth = MAX(1, _widthSlider.value * 65);
    
    if(_maskImage==nil){
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    } else {   [_maskImage drawAtPoint:CGPointZero];   }
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(!_eraserIcon.hidden){
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    } else{
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    
    _maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (UIImage*)buildImage
{
    _grayImage = [self.editor.imageView.image grayScaleImage];
    
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, false, self.editor.imageView.image.scale);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    [[_grayImage maskedImage:_maskImage] drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end
