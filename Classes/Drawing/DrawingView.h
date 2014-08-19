//
//  DrawingView.h
//  parholikho
//
//  Created by Jahanzeb on 6/18/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "DrawingPoint.h"
#import "Marker.h"
#define ALPHABETS_BEFORE_STICKER_SCREEN 3


@class CreateFlyerController;

@interface DrawingView : UIImageView <UIScrollViewDelegate> {
    
    // Cursor
    Marker         *cursor;
    
    // Path to be drawn by the chalk.
    CGMutablePathRef chalk;
    LineSegment      *lastDrawnLine;
    
    // Target point. This is the point we want to get at.
    int targetPoint;
    
    BOOL hasMistakes;
    int mistakes;
    
    CreateFlyerController *screen;

    CALayer *penLayer;
    
}

-(void)resetDrawing:(id)anObject withSelector:(SEL)selector;
-(void)restartDrawing;


@property (nonatomic, strong) CreateFlyerController *screen;

@end
