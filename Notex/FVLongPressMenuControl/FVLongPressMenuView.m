//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////

#import "FVLongPressMenuView.h"

#define ShowAnimationID @"FVContextMenuViewRriseAnimationID"
#define DismissAnimationID @"FVContextMenuViewDismissAnimationID"




// *************** CUSTOMIZATION **********************
// Size of the circle that appears when you touch the screen
NSInteger const MainItemSize = 44;
// Size of the Menu Buttons
NSInteger const MenuItemSize = 46;
// Border size of the Buttons
NSInteger const BorderWidth  = 1;
// Duration of the animation (when the Buttons first appears)
CGFloat const   AnimationDuration = 0.2;
CGFloat const   AnimationDelay = AnimationDuration/5;
//******************************************************



@interface MenuItemLocation : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat angle;

@end

@implementation MenuItemLocation

@end


@interface FVLongPressMenuView ()<UIGestureRecognizerDelegate>
{
    CADisplayLink *displayLink;
}
@property (nonatomic) NSInteger prevIndex;
@property (nonatomic) CGColorRef itemBGColor;

@end



@implementation FVLongPressMenuView

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor  = [UIColor clearColor];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self
        selector:@selector(highlightMenuItemForPoint)];
        
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        menuItems = [NSMutableArray array];
        itemLocations = [NSMutableArray array];
        arcAngle = M_PI_2;
        radius = 90;
        
    // Sets the menu buttons background color when they first appear and you don't touch them yet
    _itemBGColor = [UIColor whiteColor].CGColor;
        
    }
    return self;
}


- (void) longPressDetected:(UIGestureRecognizer*) gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _prevIndex = -1;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        longPressLocation = [gestureRecognizer locationInView:self];
        CGPoint pointInView = [gestureRecognizer locationInView:gestureRecognizer.view];
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(shouldShowMenuAtPoint:)] && ![self.dataSource shouldShowMenuAtPoint:pointInView]){
            return;
        }
        self.layer.backgroundColor = [UIColor colorWithWhite:0.1f alpha:.8f].CGColor;
        isShowing = YES;
        [self animateMenu:YES];
        [self setNeedsDisplay];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (isShowing) {
            isPaning = YES;
            curretnLocation =  [gestureRecognizer locationInView:self];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex: forMenuAtPoint:)] && self.prevIndex >= 0){
            [self.delegate didSelectItemAtIndex:self.prevIndex forMenuAtPoint:[self convertPoint:longPressLocation toView:gestureRecognizer.view]];
            self.prevIndex = -1;
        }
        [self hideMenu];
    }
}

- (void) showMenu
{
    
}

- (void) hideMenu
{
    if (isShowing) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        isShowing = NO;
        isPaning = NO;
        [self animateMenu:NO];
        [self setNeedsDisplay];
        [self removeFromSuperview];
    }
}

- (CALayer*) layerWithImage:(UIImage*) image
{
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, MenuItemSize, MenuItemSize);
    layer.cornerRadius = MenuItemSize/2;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = BorderWidth;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -1);
    layer.backgroundColor = _itemBGColor;
    
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contents = (id) image.CGImage;
    imageLayer.bounds = CGRectMake(0, 0, MenuItemSize*2/3, MenuItemSize*2/3);
    imageLayer.position = CGPointMake(MenuItemSize/2, MenuItemSize/2);
    [layer addSublayer:imageLayer];
    
    return layer;
}

- (void) setDataSource:(id<FVLongPressOverlayViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];

}

# pragma mark - menu item layout

- (void) reloadData
{
    [menuItems removeAllObjects];
    [itemLocations removeAllObjects];
    
    if (self.dataSource != nil) {
        NSInteger count = [self.dataSource numberOfMenuItems];
        for (int i = 0; i < count; i++) {
            UIImage* image = [self.dataSource imageForItemAtIndex:i];
            CALayer *layer = [self layerWithImage:image];
            [self.layer addSublayer:layer];
            [menuItems addObject:layer];
        }
    }
}

- (void) layoutMenuItems
{
    [itemLocations removeAllObjects];
    
    CGSize itemSize = CGSizeMake(MenuItemSize, MenuItemSize);
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2) + pow(itemSize.height, 2)) / 2;
    arcAngle = ((itemRadius * menuItems.count) / radius) * 1.5;
    
    NSUInteger count = menuItems.count;
	BOOL isFullCircle = (arcAngle == M_PI*2);
	NSUInteger divisor = (isFullCircle) ? count : count - 1;

    angleBetweenItems = arcAngle/divisor;
    
    for (int i = 0; i < menuItems.count; i++) {
        MenuItemLocation *location = [self locationForItemAtIndex:i];
        [itemLocations addObject:location];
    }
}

- (MenuItemLocation*) locationForItemAtIndex:(NSUInteger) index
{
	CGFloat itemAngle = [self itemAngleAtIndex:index];
	
	CGPoint itemCenter = CGPointMake(longPressLocation.x + cosf(itemAngle) * radius,
									 longPressLocation.y + sinf(itemAngle) * radius);
    MenuItemLocation *location = [MenuItemLocation new];
    location.position = itemCenter;
    location.angle = itemAngle;
    
    return location;
}

- (CGFloat) itemAngleAtIndex:(NSUInteger) index
{
    float bearingRadians = [self angleBeweenStartinPoint:longPressLocation endingPoint:self.center];
    
    CGFloat angle =  bearingRadians - arcAngle/2;
    
	CGFloat itemAngle = angle + (index * angleBetweenItems);
    
    if (itemAngle > 2 *M_PI) {
        itemAngle -= 2*M_PI;
    }else if (itemAngle < 0){
        itemAngle += 2*M_PI;
    }

    return itemAngle;
}

# pragma mark - helper methiods

- (CGFloat) calculateRadius
{
    CGSize mainSize = CGSizeMake(MainItemSize, MainItemSize);
    CGSize itemSize = CGSizeMake(MenuItemSize, MenuItemSize);
    CGFloat mainRadius = sqrt(pow(mainSize.width, 2) + pow(mainSize.height, 2)) / 2;
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2) + pow(itemSize.height, 2)) / 2;
    
    CGFloat minRadius = (CGFloat)(mainRadius + itemRadius);
    CGFloat maxRadius = ((itemRadius * menuItems.count) / arcAngle) * 1.5;
    
	CGFloat radius = MAX(minRadius, maxRadius);

    return radius;
}

- (CGFloat) angleBeweenStartinPoint:(CGPoint) startingPoint endingPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    
    bearingRadians = (bearingRadians > 0.0 ? bearingRadians : (M_PI*2 + bearingRadians));

    return bearingRadians;
}

- (CGFloat) validaAngle:(CGFloat) angle
{
    if (angle > 2*M_PI) {
        angle = [self validaAngle:angle - 2*M_PI];
    }
    
    return angle;
}

# pragma mark - animation and selection

-  (void) highlightMenuItemForPoint
{
    if (isShowing && isPaning) {
        
        CGFloat angle = [self angleBeweenStartinPoint:longPressLocation endingPoint:curretnLocation];
        NSInteger closeToIndex = -1;
        for (int i = 0; i < menuItems.count; i++) {
            MenuItemLocation *itemLocation = [itemLocations objectAtIndex:i];
            if (fabs(itemLocation.angle - angle) < angleBetweenItems/2) {
                closeToIndex = i;
                break;
            }
        }
        
        if (closeToIndex >= 0 && closeToIndex < menuItems.count) {
            
            MenuItemLocation* itemLocation = [itemLocations objectAtIndex:closeToIndex];

            CGFloat distanceFromCenter = sqrt(pow(curretnLocation.x - longPressLocation.x, 2)+ pow(curretnLocation.y-longPressLocation.y, 2));
            
            CGFloat toleranceDistance = (radius - MainItemSize/(2*sqrt(2)) - MenuItemSize/(2*sqrt(2)) )/2;
            
            CGFloat distanceFromItem = fabs(distanceFromCenter - radius) - MenuItemSize/(2*sqrt(2)) ;
            
            if (fabs(distanceFromItem) < toleranceDistance ) {
                CALayer *layer = [menuItems objectAtIndex:closeToIndex];
                
        // Sets the menu buttons background color when you touch them
        layer.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
                
                
                CGFloat distanceFromItemBorder = fabs(distanceFromItem);
                
                CGFloat scaleFactor = 1 + 0.5 *(1-distanceFromItemBorder/toleranceDistance) ;
                
                if (scaleFactor < 1.0) {
                    scaleFactor = 1.0;
                }
                
                // Scale
                CATransform3D scaleTransForm =  CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1.0);
                
                CGFloat xtrans = cosf(itemLocation.angle);
                CGFloat ytrans = sinf(itemLocation.angle);
                
                CATransform3D transLate = CATransform3DTranslate(scaleTransForm, 10*scaleFactor*xtrans, 10*scaleFactor*ytrans, 0);
                layer.transform = transLate;
                
                if ( ( self.prevIndex >= 0 && self.prevIndex != closeToIndex)) {
                    [self resetPreviousSelection];
                }
                
                _prevIndex = closeToIndex;
                
            } else if(_prevIndex >= 0) {
                [self resetPreviousSelection];
            }
        }else {
            [self resetPreviousSelection];
        }
    }
}

- (void) resetPreviousSelection
{
    if (self.prevIndex >= 0) {
        CALayer *layer = menuItems[self.prevIndex];
        MenuItemLocation* itemLocation = [itemLocations objectAtIndex:self.prevIndex];
        layer.position = itemLocation.position;
        layer.backgroundColor = _itemBGColor;
        layer.transform = CATransform3DIdentity;
        _prevIndex = -1;
    }
}

- (void) animateMenu:(BOOL) isShowing
{
    if (isShowing) {
        [self layoutMenuItems];
    }
    
    for (NSUInteger index = 0; index < menuItems.count; index++) {
        CALayer *layer = menuItems[index];
        layer.opacity = 0;
        CGPoint fromPosition = longPressLocation;
        
        MenuItemLocation* location = [itemLocations objectAtIndex:index];
        CGPoint toPosition = location.position;
        
        double delayInSeconds = index * AnimationDelay;
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:isShowing ? fromPosition : toPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:isShowing ? toPosition : fromPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = AnimationDuration;
        positionAnimation.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:isShowing ? ShowAnimationID : DismissAnimationID];
        positionAnimation.delegate = self;
        
        [layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if([anim valueForKey:ShowAnimationID]) {
        NSUInteger index = [[anim valueForKey:ShowAnimationID] unsignedIntegerValue];
        CALayer *layer = menuItems[index];
        
        MenuItemLocation* location = [itemLocations objectAtIndex:index];
        CGFloat toAlpha = 1.0;
        
        layer.position = location.position;
        layer.opacity = toAlpha;
        
    }
    else if([anim valueForKey:DismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:DismissAnimationID] unsignedIntegerValue];
        CALayer *layer = menuItems[index];
        CGPoint toPosition = longPressLocation;
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        layer.position = toPosition;
        layer.backgroundColor = _itemBGColor;
        layer.opacity = 0.0f;
        layer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}

- (void)drawCircle:(CGPoint)locationOfTouch
{
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx,BorderWidth/2);
    CGContextSetRGBStrokeColor(ctx,0.8,0.8,0.8,1.0);
    CGContextAddArc(ctx,locationOfTouch.x,locationOfTouch.y,MainItemSize/2,0.0,M_PI*2,YES);
    CGContextStrokePath(ctx);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (isShowing) {
        [self drawCircle:longPressLocation];
    }
}
@end
