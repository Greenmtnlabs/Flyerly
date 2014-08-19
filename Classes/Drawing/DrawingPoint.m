//
//  DrawingPoint.m
//  flyerly
//
//  Created by Abdul Rauf on 8/19/14.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "DrawingPoint.h"

@implementation DrawingPoint

@synthesize region;
@synthesize mainPoint;
@synthesize label;
@synthesize isHidden;
@synthesize origins;

#pragma mark - Initialization

/**
 * Initialize the drawing point.
 */
- (id)initWithPoint:(CGPoint)pt region:(CGRect)rgn exitLine:(LineSegment *)ln 
              label:(int)lbl labelSize:(CGSize)lblSize {
   
    NSString *imgPrefix;
    float fontSize;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imgPrefix = @"";
        fontSize = 11.0;
    } else {
        fontSize = 20.0;
        imgPrefix = @"ipad_";
    }
    
    
    // Initialize the button.
    if ( ( self = [super initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@numbersbg.png",imgPrefix]]] ) ) {
        
        // Remember the region.
        region = rgn;
        mainPoint = pt;
        exitLine = ln;
        isHidden = NO;
        if(lbl == 0) isHidden = YES;
        // Also remember the label.
        label = lbl;
        
        // Set the frame
        self.frame = CGRectMake(pt.x - (lblSize.width / 2.0), pt.y - (lblSize.height / 2.0), lblSize.width, lblSize.height);
        
        
        //set the origins
        origins.x = self.frame.origin.x;
        origins.y = self.frame.origin.y;
        
        
        // Set the title
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, lblSize.width, lblSize.height)];
        
        title.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        title.textAlignment = UITextAlignmentCenter;
        title.text = [NSString stringWithFormat:@"%d", self.label];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        
        // For debuggin purposes, show the region
        if ( DRAWINGPOINT_SHOW_REGION ) {
            [self setContentMode:UIViewContentModeCenter];
            self.frame = self.region;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.borderWidth = 2;
            
            // Update the frame for title.
            title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
        
        // Show hidden first.
        self.alpha = 0;
        
        // Add title to the image.
        [self addSubview:title];
    }
    
    return self;
}

#pragma mark - Determing if point or path is in region

/**
 * Point is in region?
 */
- (BOOL)isPointInRegion:(CGPoint)pt {
    
    return CGRectContainsPoint(region, pt);
}

/**
 * Does the given path exit this region?
 */
- (BOOL)didExitRegion:(LineSegment *)path {
    BOOL didExit = NO;
    
    // There are some regions we can never exit.
    if ( exitLine != nil ) {
        CGPoint intersection = [exitLine intersectionWithLine:path];
    
        if ( intersection.x != -1 && intersection.y != -1 ) {
            didExit = YES;
        }
        
    }
    
    return didExit;
}

//change font size when zoom in
-(void)changeFontSize {
    
    //first remove previous title
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
    
    // Set the title
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(-6, 0, 30, 20)];
    
    title.font = [UIFont fontWithName:@"Helvetica" size:24.0];
    title.textAlignment = UITextAlignmentCenter;
    title.text = [NSString stringWithFormat:@"%d", self.label];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    
    // For debuggin purposes, show the region
    if ( DRAWINGPOINT_SHOW_REGION ) {
        [self setContentMode:UIViewContentModeCenter];
        self.frame = self.region;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
        
        // Update the frame for title.
        title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    // Add title to the image.
    [self addSubview:title];
    
    
}


@end
