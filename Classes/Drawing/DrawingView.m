//
//  DrawingView.m
//  parholikho
//
//  Created by Jahanzeb on 6/18/12.
//  Copyright (c) 2012 RIKSOF (Private) Limited. All rights reserved.
//

#import "DrawingView.h"
#import "LineSegment.h"
#import "CreateFlyerController.h"

#define TOUCH_START 1
#define TOUCH_MOVE  2
#define TOUCH_END   3

@implementation DrawingView

@synthesize screen;

#pragma mark - Show Segment Points

/**
 * Show points
 */

int i = 0;
bool aboveTen;
SEL customSelector;



-(CGPoint)getPoint:(CGPoint)point {
    return CGPointMake(point.x + 200,point.y);
    
}


#pragma mark - Reset View

/**
 * Reset the drawing.
 */
-(void)resetDrawing:(id)anObject withSelector:(SEL)selector {
    
    //play sound for mistake
    if(hasMistakes) {
     
        mistakes++;
    } else {
    
        // We need to make sure that any drawing that was to happen in the background queue
        // happens and then we refresh the image.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async( dispatch_get_main_queue(), ^{
                screen.displayView.image = nil;
            });
        });
    }
    
    // Refresh the chalk.
    CGPathRelease(chalk);
    chalk = CGPathCreateMutable();
    lastDrawnLine = nil;
    
    // We need to make sure that any drawing that was to happen in the background queue
    // happens and then we refresh the image.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            self.image = nil;
        });
    });
    
   // [self showCurrentSegment:self withSelector:selector];
}

#pragma mark - Initialization

/**
 * Initialize with the way points of the alphabet and the initial marker size.
 */
-(void)setSegments:(NSArray *)sgmts Alphabet:(int)alphabet WithSound:(BOOL)sound {
    
    // First clear the view from previously showing segments.
    self.userInteractionEnabled = TRUE;

    hasMistakes = NO;
    
    // Reset the view.
    [self resetDrawing:self withSelector:nil];
    
    hasMistakes = YES;
    mistakes = 0;
    
    
}

#pragma mark - Draw chalk

/**
 * Draw the chalk.
 */
- (void)drawChalkOnBoard {
    
    // The drawing can be intensive. So we do it in a background thread and just
    // update the image on the main thread once done.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(self.frame.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapRound);
        //CGContextSetLineWidth(context, currentSegment.markerSize);
        
        CGContextAddPath(context, chalk);
        CGContextSetRGBFillColor(context, 255, 255, 255, 1);
        
        //white color stroke
        CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
        
        CGContextStrokePath(context);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async( dispatch_get_main_queue(), ^{
            self.image = img;
        });
    });
}

/**
 * Draws the chalk path.
 */
-(void)drawChalk:(LineSegment *)line controlPoint1:(CGPoint)pt1 controlPoint2:(CGPoint)pt2 {
    
    CGPathMoveToPoint(chalk, NULL, line.point1.x, line.point1.y);
    
    if(pt1.x != 0 && pt1.y != 0)
        CGPathAddCurveToPoint(chalk, NULL,pt1.x , pt1.y, pt2.x , pt2.y,line.point2.x, line.point2.y);
    else
        CGPathAddLineToPoint(chalk, NULL, line.point2.x, line.point2.y);

    [self drawChalkOnBoard];
    
}


#pragma mark - Process touches

/**
 * Process move event.
 */
-(void) processMove:(CGPoint)currentPoint {
    // If we are drawing
    if ( [cursor isDrawing] ) {
        
        NSLog(@"%f,%f",currentPoint.x,currentPoint.y);
        
        // Get the region we are in.
        DrawingPoint *currentRegion = cursor.lastPoint;
        
        // Make a straight line path from our movement.
        LineSegment *line;
        
        line = [[LineSegment alloc] initWithPoints:cursor.position
                                             point:cursor.position];
        
        // While we remain with in our limits
        while ( currentRegion != nil ) {
            // Are we in the current point's region?
            if ( [currentRegion isPointInRegion:currentPoint] ) {
                
                // Draw this path of the chalk if we have started drawing.
                [self drawChalk:line controlPoint1:CGPointMake(0,0) controlPoint2:CGPointMake(0,0)];
                
                break;
            } else if ( [currentRegion didExitRegion:line] ) {
                
                [UIView beginAnimations:@"NextRegion" context:nil];
                currentRegion.alpha = 0;
                [UIView commitAnimations];
                
                
            } else {
                // Wrong path, error out.
                currentRegion = nil;
                break;
            }
            
        }
        
        // If we are inside a region, then the move is valid.
        if ( currentRegion != nil ) {
            [cursor move:currentPoint];
            cursor.lastPoint = currentRegion;
           
            //merge this segment to display view
            [self mergeImage];
            
        } else {
            // Play the error sound here.
            
            // Wrong move son!
            [self resetDrawing:self withSelector:nil];
        }
    }
}


-(void)SuccessSoundDelay{
    
    //goto next letter after some delay
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(gotoNextLetter)
                                   userInfo:nil
                                    repeats:NO];


}

//call for playing success sound
-(void)SuccessSound{
   
    
}


/*
//restart drawing when duster is clicked
 */
 
-(void)restartDrawing{
    
    self.userInteractionEnabled = TRUE;
    
    hasMistakes = NO;
    // Reset the view.
    [self resetDrawing:self withSelector:nil];
    
    hasMistakes = YES;
    mistakes = 0;
    
}

/**
 * This function will process respective events while user is drawning,
 * and perform action based on event type
 */
-(void) processEvent:(NSSet *)touches eventType:(int)eventType {
    
    // Get the current touch.
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];

    // What event is this?
    switch ( eventType ) {
        
        case TOUCH_START:
            
            // Is the touch on the cursor?
            if ( [cursor didTouch:currentPoint] ) {
                
                // Indicate that we are drawing now.
                cursor.drawing = YES;
                
                //check whether the current letter (on which drawing has actually started)
                //is the consective one or not,, if not then set consectivealphabets array to nil
                
                
                // Hide the starting point.
                [UIView beginAnimations:@"StartingPoint" context:nil];
                [UIView commitAnimations];
                
                if(cursor.lastPoint.alpha != 0)

                cursor.lastPoint.alpha = 0;
                
                // Draw this slight move if we have something drawn already.
                if ( !CGPathIsEmpty(chalk) ) {
                    
                    LineSegment *line;
                    
                    line = [[LineSegment alloc] initWithPoints:cursor.position point:currentPoint];
                    
                    
                    [self drawChalk:line controlPoint1:CGPointMake(0,0) controlPoint2:CGPointMake(0,0)];
                }
                
                // Move cursor to center on the touch.
                [cursor move:currentPoint];
            }
            
            break;
        case TOUCH_MOVE:
            
            // Process the move.
            [self processMove:currentPoint];
            break;
            
        case TOUCH_END:
            
            // Drawing stopped.
            [self processMove:currentPoint];
            cursor.drawing = NO;
            
            break;
            
        default:
            break;
    }
}


#pragma mark - Handle Touches

/**
 * Thise event means user started drawing.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    // We are starting to draw
    [self processEvent:touches eventType:TOUCH_START];
}

/**
 * User is drawing.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // If we are in the middle of drawing.
    [self processEvent:touches eventType:TOUCH_MOVE];
}

/**
 * User finished drawing.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // In the end of drawing.
    [self processEvent:touches eventType:TOUCH_END];
}



/**
 * This function will merge the image from drawing view to display view
 */
-(void) mergeImage {
    //merge image on display view
    // capture image context ref
    UIGraphicsBeginImageContext(CGSizeMake(screen.displayView.frame.size.width, screen.displayView.frame.size.height));
    
    //Draw images onto the context
    [self.image drawInRect:CGRectMake(0, 0, screen.displayView.frame.size.width, screen.displayView.frame.size.height)];
    [screen.displayView.image drawInRect:CGRectMake(0, 0, screen.displayView.frame.size.width, screen.displayView.frame.size.height)]; 
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    // We need to make sure that any drawing that was to happen in the background queue
    // happens and then we refresh the image.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            screen.displayView.image = newImage;
        });
    });
}




@end
