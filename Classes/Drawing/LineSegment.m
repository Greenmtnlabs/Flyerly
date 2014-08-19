//
//  LineSegment.m
//  parholikho
//
//  Created by Khurram Ali on 6/27/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "LineSegment.h"
#include <math.h>

@implementation LineSegment

@synthesize point1;
@synthesize point2;

#pragma mark - Initialization

/**
 * Initialize the line.
 */
- (id)initWithPoints:(CGPoint)pt1 point:(CGPoint)pt2 {
    if ( ( self = [super init] ) ) {
        point1 = pt1;
        point2 = pt2;
    }
    
    return self;
}

#pragma mark - Detect intersection

/**
 * Find the intersection point between the two lines. Using this:
 *
 * http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
 */
- (CGPoint)intersectionWithLine:(LineSegment *)line {
    CGPoint intersection;
    
    float ua =  (((line.point2.x - line.point1.x) * (self.point1.y - line.point1.y) ) - 
                 ((line.point2.y - line.point1.y) * (self.point1.x - line.point1.x) )) / 
                (((line.point2.y - line.point1.y) * (self.point2.x - self.point1.x) ) -
                 ((line.point2.x - line.point1.x) * (self.point2.y - self.point1.y) ));
    
    float ub =  (((self.point2.x - self.point1.x) * (self.point1.y - line.point1.y) ) - 
                 ((self.point2.y - self.point1.y) * (self.point1.x - line.point1.x) )) / 
                (((line.point2.y - line.point1.y) * (self.point2.x - self.point1.x) ) -
                 ((line.point2.x - line.point1.x) * (self.point2.y - self.point1.y) ));
    
    // Is there an intersection?
    if ( isnan(ua) || isnan(ub) ) {
        // No intersection
        intersection = CGPointMake(-1, -1);
    } else {
        intersection = CGPointMake(self.point1.x + ( ua * (self.point2.x - self.point1.x) ), 
                                   self.point1.y + ( ub * (self.point2.y - self.point1.y) ));
    
        //check whther intersection point is on our exit line
        float crossproduct = (intersection.y - self.point1.y) * (self.point2.x - self.point1.x) - (intersection.x - self.point1.x) * (self.point2.y - self.point1.y);
        
        if (abs(crossproduct) != 0)  return CGPointMake(-1, -1);
            
        float dotproduct = (intersection.x - self.point1.x) * (self.point2.x - self.point1.x) + (intersection.y - self.point1.y)*(self.point2.y - self.point1.y);
        if (dotproduct < 0) return CGPointMake(-1, -1);
            
        float squaredlengthba = (self.point2.x - self.point1.x)*(self.point2.x - self.point1.x) + (self.point2.y - self.point1.y)*(self.point2.y - self.point1.y);
        if (dotproduct > squaredlengthba) return CGPointMake(-1, -1);
        
    
    }
    
    return intersection;
}

#pragma mark - New Line by rotation

/**
 * Construct a new line by rotating given line at a point.
 *
 * http://www.physicsforums.com/showthread.php?t=419561
 */
+ (LineSegment *)perpendicularLineFor:(LineSegment *)ln atOrigin:(CGPoint)origin width:(float)width {
    
    LineSegment *line;
    CGPoint pt1;
    CGPoint pt2;
    
    if ( ln.point2.x - ln.point1.x == 0 ) {
        // Line is constant on the x axis, new line will be constant on the y axis.
        pt1 = CGPointMake(ln.point1.x - (width / 2), origin.y);
        pt2 = CGPointMake(ln.point1.x + (width / 2), origin.y);
        
    } else if ( ( ln.point2.y - ln.point1.y ) == 0 ) {
        // Line is constant on the y axis, new line will be constant on the x axis.
        pt1 = CGPointMake(origin.x, ln.point1.y - (width / 2));
        pt2 = CGPointMake(origin.x, ln.point2.y + (width / 2));
        
    } else {
        // Get gradient of the perpendicular line.
        float m = -1 / (( ln.point2.x - ln.point1.x ) / ( ln.point2.y - ln.point1.y ));

        // Get the c constant for line using provided origin point.
        float c = origin.y - (m * origin.x);
    
        // Now get the two points at given distance from origin.
        float x1 = origin.x - ( (width / 2) / (sqrt((1 + (m * m))))); 
        pt1 = CGPointMake(x1, (m * x1) + c);
    
        float x2 = origin.x + ( (width / 2) / (sqrt((1 + (m * m)))));
        pt2 = CGPointMake(x2, (m * x2) + c);
    }
    
    line = [[LineSegment alloc] initWithPoints:pt1 point:pt2];
    
    return line;
}

@end
