//
//  Marker.h
//  parholikho
//
//  Created by Jahanzeb on 6/22/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingPoint.h"


@interface Marker : UIImageView {
    DrawingPoint* lastPoint;
    CGPoint       position;
    float         markerSize;
    BOOL          drawing;
    float   marker_height;
    float   marker_width;
    NSString    *imageNamePrefix;
}

@property (nonatomic, strong) DrawingPoint* lastPoint;
@property CGPoint position;
@property float markerSize;
@property (getter = isDrawing) BOOL drawing;

/**
 * Initialize the marker.
 */
- (id)initWithPoint:(DrawingPoint *)pt;

/**
 * Moves the marker to newPosition and alters marker size by deltaX, deltaY
 */
- (void)move:(CGPoint)newPosition;
- (void)moveToPoint:(DrawingPoint *)pt;

/**
 * Checks if the marker was hit.
 */
- (BOOL)didTouch:(CGPoint)pt;

@end
