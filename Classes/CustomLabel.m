//
//  CustomLabel.m
//  Flyr
//
//  Created by Riksof on 5/3/13.
//
//

#import "CustomLabel.h"

@implementation CustomLabel
@synthesize lineWidth, borderColor;
@synthesize originalSize;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    lineWidth = 0;
    borderColor = [UIColor blackColor];
    return self;
}

-(void)drawRect:(CGRect)rect{

    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = borderColor;
    //[super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject: borderColor];
    [aCoder encodeObject: @(lineWidth)];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    self.borderColor = [aDecoder decodeObject];
    self.lineWidth = [[aDecoder decodeObject] intValue];
    
    return self;
}

// helper to get pre transform frame
-(CGRect)originalFrame {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    
    return originalFrame;
}

// helper to get point offset from center
-(CGPoint)centerOffset:(CGPoint)thePoint {
    return CGPointMake(thePoint.x - self.center.x, thePoint.y - self.center.y);
}

// helper to get point back relative to center
-(CGPoint)pointRelativeToCenter:(CGPoint)thePoint {
    return CGPointMake(thePoint.x + self.center.x, thePoint.y + self.center.y);
}

// helper to get point relative to transformed coords
-(CGPoint)newPointInView:(CGPoint)thePoint {
    // get offset from center
    CGPoint offset = [self centerOffset:thePoint];
    // get transformed point
    CGPoint transformedPoint = CGPointApplyAffineTransform(offset, self.transform);
    // make relative to center
    return [self pointRelativeToCenter:transformedPoint];
}

// now get your corners
-(CGPoint)newTopLeft {
    CGRect frame = [self originalFrame];
    return [self newPointInView:frame.origin];
}

-(CGPoint)newTopRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return [self newPointInView:point];
}

-(CGPoint)newBottomLeft {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.y += frame.size.height;
    return [self newPointInView:point];
}

-(CGPoint)newBottomRight {
    CGRect frame = [self originalFrame];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return [self newPointInView:point];
}

-(CGSize)newSize{
    
    CGFloat wx = [self newTopRight].x - [self newTopLeft].x;
    CGFloat wy = [self newTopRight].y - [self newTopLeft].y;
    
    CGFloat width = sqrt((wx * wx) + (wy * wy));
    
    CGFloat hx = [self newTopLeft].x - [self newBottomLeft].x;
    CGFloat hy = [self newTopLeft].y - [self newBottomLeft].y;
    
    CGFloat height = sqrt((hx * hx) + (hy * hy));
    
    return CGSizeMake(width, height);
}

@end
