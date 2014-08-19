//
//  LineSegment.h
//  parholikho
//
//  Created by Khurram Ali on 6/27/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineSegment : NSObject {
    CGPoint     point1;
    CGPoint     point2;
}

@property CGPoint point1;
@property CGPoint point2;

- (id)initWithPoints:(CGPoint)pt1 point:(CGPoint)pt2;
- (CGPoint)intersectionWithLine:(LineSegment *)line;

/**
 * Construct a new line by rotating given line at a point.
 */
+(LineSegment *)perpendicularLineFor:(LineSegment *)ln atOrigin:(CGPoint)origin width:(float)width;

@end
