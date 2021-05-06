//
//  ImageLayer.m
//  Flyr
//
//  Created by RIKSOF Developer on 9/9/14.
//
//

#import "ImageLayer.h"

@implementation ImageLayer

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
