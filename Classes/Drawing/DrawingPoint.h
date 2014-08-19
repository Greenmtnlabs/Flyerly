//
//  DrawingPoint.h
//  parholikho
//
//  Created by Jahanzeb on 6/19/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "LineSegment.h"

#define DRAWINGPOINT_SHOW_REGION NO

@interface DrawingPoint : UIImageView {
    
    // Region for this point.
    CGRect          region;
    
    // Main point.
    CGPoint         mainPoint;
    
    
    //main origin of point ,, this point is used when we have to redraw the alphabets which have more than one segment
    //as the origin changes we have to keep the value of main origin of all the points
    CGPoint origins;
    
    // Exit line
    LineSegment     *exitLine;
    
    // Label to be applied on this point
    int     label;
    
    //whether to display this point or not
    BOOL isHidden;
    
}

@property CGRect  region;
@property CGPoint mainPoint;
@property CGPoint origins;
@property int     label;
@property BOOL isHidden;

/**
 * Initialize the point.
 */
- (id)initWithPoint:(CGPoint)pt region:(CGRect)rgn exitLine:(LineSegment *)ln 
              label:(int)lbl labelSize:(CGSize)lblSize;

/**
 * Returns true if parameter Point lies inside the region of this Point
 */
- (BOOL)isPointInRegion:(CGPoint)pt;

/**
 * Did we exit this region?
 */
- (BOOL)didExitRegion:(LineSegment *)path;

-(void)changeFontSize;

@end
