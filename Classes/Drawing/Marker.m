//
//  Marker.m
//  parholikho
//
//  Created by Jahanzeb on 6/22/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "Marker.h"

@implementation Marker

@synthesize lastPoint;
@synthesize position;
@synthesize markerSize;
@dynamic drawing;

#pragma mark - Initialization

/**
 * Initialize the marker with given point.
 */
- (id)initWithPoint:(DrawingPoint *)pt {
    
    CGPoint initialPoint;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        marker_height = 52;
        marker_width = 52;
        imageNamePrefix = @"";
        initialPoint = CGPointMake(290, 480);
    } else {
        
        marker_height = 100;
        marker_width = 100;
        imageNamePrefix = @"ipad_";
        initialPoint = CGPointMake(490, 980);       
    }
    
    // Initialize with marker image.
    if ( ( self = [super initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",imageNamePrefix, @"pointerwithoutshadow.png"]]] )) {
        
        // Start from the chalk.
        [self move:initialPoint];
        
        // Set the current marker position.
        [self moveToPoint:pt];
        
    }
    
    
    return self;
}

#pragma mark - Move

/**
 * Moves the marker to newPosition and alters marker size by deltaX, deltaY
 */
- (void) move:(CGPoint)newPosition {
    position = newPosition;
    self.frame = CGRectMake(position.x - ( marker_width / 2.0 ), 
                            position.y - ( marker_height / 2.0 ),
                            marker_width, marker_height);
}

/**
 * Move cursor to the new point.
 */
- (void)moveToPoint:(DrawingPoint *)pt {
    lastPoint = pt;
    
    [UIView beginAnimations:@"MovePoint" context:nil];
    self.alpha = 1;
    [self move:lastPoint.mainPoint];
    [UIView commitAnimations];
}

#pragma mark - Was the marker touched?

/**
 * Returns true if parameter Point lies inside the region of this marker
 */
- (BOOL)didTouch:(CGPoint)pt {
    return CGRectContainsPoint(self.frame, pt);
}

#pragma mark - Manage drawing switch

/**
 * Indicate if we are drawing.
 */
- (BOOL)isDrawing {
    return drawing;
}

/**
 * Set the drawing switch.
 */
- (void)setDrawing:(BOOL)drwng {
    drawing = drwng;
    
    // Also update the cursor.
    if ( drawing ) {
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",imageNamePrefix, @"pointerwithshadow.png"]];
    } else {
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",imageNamePrefix, @"pointerwithoutshadow.png"]];
    }
}

@end
