//
//  CropView.m
//  Flyr
//
//  Created by Khurram Ali on 22/05/2014.
//
//
#import <QuartzCore/CALayer.h>
#import "CropView.h"

@implementation CropView

#pragma mark - Initialization

/**
 * Set up the border and gestures.
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor whiteColor].CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:_border];
    
    // Gesture for moving layers
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(videolayerMoved:)];
    [self addGestureRecognizer:panGesture];
    
    // Gesture for resizing layers
    /*UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(layerResized:)];
    [self addGestureRecognizer:pinchGesture];*/
}

#pragma mark - Setup

/**
 * Give dimensions to the border layer.
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    
    _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _border.frame = self.bounds;
}

#pragma mark - Drag & Drop Functionality

/**
 * This method does drag and drop functionality on the layer.
 */
- (void)videolayerMoved:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self];
    
    if ( _fixedX ) {
        // Do not move x
        translation.x = 0;
    } else if ( _fixedY ) {
        // Do not move y
        translation.y = 0;
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    self.frame = recognizer.view.frame;
}

#pragma mark - Resize functionality

/**
 * Resize view when pinched.
 */
- (void)layerResized:(UIGestureRecognizer *)sender {
    static CGRect initialBounds;
    
    UIView *_view = sender.view;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialBounds = _view.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    _view.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    // Resize my frame
    self.frame = _view.frame;
}

@end
