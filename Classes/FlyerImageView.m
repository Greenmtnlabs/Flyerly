 //
//  FlyerImageView.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "FlyerImageView.h"
#import "Flyer.h"

@implementation FlyerImageView
@synthesize layers,flyerTapGesture;

CGAffineTransform previuosTransform;

/**
 * Image initialization.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    //Set Master Layers
    layers = [[NSMutableDictionary alloc] init];
    
}

/**
 * Removes all sub views from layers dictionary as well as UIImageView
 */
-(void)removeAllLayers {
    
    //Here we Remove all Object from Controller Dictionary
    [self.layers removeAllObjects];
    
    // Remove all subviews from uiview as well
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

}

/*
 * Here we Delete One Layer from View
 */
-(void)deleteLayer :(NSString *)uid{
    
    UIView *view = [layers objectForKey:uid];
    
    // Make sure the view is valid.
    if ( view != nil ) {
        // Remove it from the superview.
        [view removeFromSuperview];
        
        // Also remove from dictionary.
        [layers removeObjectForKey:uid];
    }
}

/*
 * Here we create or update actual layer
 */
-(void)renderLayer :(NSString *)uid layerDictionary:(NSMutableDictionary *)layDic {
   
    // This is a reference to the view that we use to do some generic stuff.
    UIView *view = nil;

    //check for Flyer Background
    if ( [uid isEqualToString:@"Template"] ) {
        
        NSString *flyerTyp = [layDic objectForKey:@"FlyerType"];
        if (flyerTyp != nil && [flyerTyp isEqualToString:@"video"]) {

            flyerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editLayer:)];
            flyerTapGesture.delegate = self;
            [self addGestureRecognizer:flyerTapGesture];
            
            [self.delegate addVideo:[layDic objectForKey:@"VideoURL"]];
        
        }else {
            
            [self setTemplate:[layDic valueForKey:@"image"]];
        }

        //Set Flyer Border
        if ([layDic objectForKey:@"bordercolor"]) {
            [self setTemplateBorder:layDic];
        }else {
            [self removeFlyerBorder];
        }
        return;
    }
    
    // Checking for Label or ImageView
    if ([layDic objectForKey:@"image"] == nil) {
        
        id lastControl = [layers objectForKey:uid];
        
        // If we have switched from an image to a text view, then we need to
        // make a new label.
        if ( lastControl != nil && [layDic objectForKey:@"text"] != nil &&
            ![lastControl isKindOfClass:[CustomLabel class]] ) {
            [lastControl removeFromSuperview];
            lastControl = nil;
        }
        
        //Check Layer Exist in Master Layers
        if ( lastControl == nil) {
            
            CustomLabel *lble = [[CustomLabel alloc] init];
            lble.tag = layers.count;
            lble.backgroundColor = [UIColor clearColor];
            // Get the type of layer
            //NSString *type = [flyer getLayerType:currentLayer];
            //if( [type isEqualToString:FLYER_LAYER_CLIP_ART] ){

            lble.textAlignment = UITextAlignmentCenter;//    UITextAlignmentCenter;
            //}
            lble.adjustsFontSizeToFitWidth = YES;
            lble.lineBreakMode = UILineBreakModeClip;
            lble.numberOfLines = 80;
            [self configureLabel:lble labelDictionary:layDic ];
            [self addSubview:lble];
            [layers setValue:lble forKey:uid];
            
            view = lble;
        } else {

            if ([lastControl isKindOfClass:[CustomLabel class]]) {
                
                //here we Update Label
                CustomLabel *lble = [layers objectForKey:uid];
                [self configureLabel:lble labelDictionary:layDic ];
                [layers setValue:lble forKey:uid];
            
            } else {
            
                //here we Update ImageView
                UIImageView *img = [layers objectForKey:uid];
                [self configureImageView:img ImageViewDictionary:layDic];
                [layers setValue:img forKey:uid];
            }
        }
    } else {
        id lastControl = [layers objectForKey:uid];
        
        // If we have switched from an text to a image view, then we need to
        // make a new label.
        if ( lastControl != nil &&
            ![lastControl isKindOfClass:[UIImageView class]] ) {
            [lastControl removeFromSuperview];
            lastControl = nil;
        }

        // Check Layer Exist in Master Layers
        if ( lastControl == nil) {
            
            // Here We Write Code for Image
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 90, 70)];

            [self configureImageView:img ImageViewDictionary:layDic];
            [self addSubview:img];
            [layers setValue:img forKey:uid];
            
            view = img;
        } else {
        
            UIImageView *img = [layers objectForKey:uid];
            [self configureImageView:img ImageViewDictionary:layDic];
            [layers setValue:img forKey:uid];
        
        }
    }
    
    // Do the generic stuff that needs to happen for all views. For now,
    // we add support for drag.
    if ( view != nil ) {
        view.userInteractionEnabled = YES;
        
        // Gesture for moving layers
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(layerMoved:)];
        [view addGestureRecognizer:panGesture];
        
        // Gesture for resizing layers
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(layerResized:)];
        [view addGestureRecognizer:pinchGesture];
        
        // PinchGesture for editing layers
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editLayer:)];
        [view addGestureRecognizer:tapGesture];
        
        SEL handleRotateGestureSelector = @selector(handleRotateGesture:uid:);
        
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGestureSelector)];
        //[rotationRecognizer setDelegate:self];
        [view addGestureRecognizer:rotationRecognizer];
        
    }
}


/*
 *Here we set Properties of UIImageView
 */
-(void)configureImageView :(UIImageView *)imgView ImageViewDictionary:(NSMutableDictionary *)detail {
    
    //SetFrame
    [imgView setFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];
              
    imgView.transform = CGAffineTransformMakeRotation([[detail valueForKey:@"rotation"] floatValue]);
    
    //Set Image
    if ([detail objectForKey:@"image"] != nil) {
        
        if ( ![[detail valueForKey:@"image"] isEqualToString:@""]) {
            NSError *error = nil;
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:[detail valueForKey:@"image"]
                                                          options:NSDataReadingMappedIfSafe
                                                            error:&error];
            //NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:[detail valueForKey:@"image"]];
            UIImage *currentImage = [UIImage imageWithData:imageData];
            [imgView setImage:currentImage];
        }
    }

}

/*
 *Here we set Properties of uiLabel
 */
-(void)configureLabel :(CustomLabel *)lbl labelDictionary:(NSMutableDictionary *)detail {
    
    
    //SetFrame
    [lbl setFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];

    // Remember originalsize
    lbl.originalSize = lbl.frame.size;

    //set Label Text
    [lbl setText:[detail valueForKey:@"text"]];

    //set Label Font
    lbl.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
    
    if ([[detail valueForKey:@"textcolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        if ([detail valueForKey:@"textWhitecolor"]  != nil) {
            NSArray *rgb = [[detail valueForKey:@"textWhitecolor"]  componentsSeparatedByString:@","];
            lbl.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
        }
    }else{
        NSArray *rgb = [[detail valueForKey:@"textcolor"] componentsSeparatedByString:@","];
        
        lbl.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];
        
    }
    
    
    if ([[detail valueForKey:@"textbordercolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {

        if ([detail valueForKey:@"textborderWhite"] != nil) {
            NSArray *rgbBorder = [[detail valueForKey:@"textborderWhite"] componentsSeparatedByString:@","];

            lbl.borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
            
        }
    }else{
        
        NSArray *rgbBorder = [[detail valueForKey:@"textbordercolor"] componentsSeparatedByString:@","];
        
        lbl.borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
    }
    lbl.lineWidth = 2;
    
    // Make sure we are vertically aligned to the top and centerally aligned.
    if( [[detail valueForKey:@"type"] isEqualToString:FLYER_LAYER_CLIP_ART] ){
        lbl.textAlignment = UITextAlignmentCenter;
        [lbl setNumberOfLines:0];
        [lbl sizeToFit];
        
        CGRect fr = lbl.frame;
        fr.size.width = 150;
        lbl.frame = fr;
        
    } else{
       lbl.textAlignment = UITextAlignmentCenter;//UITextAlignmentLeft;//
       [lbl setNumberOfLines:0];
       [lbl sizeToFit];
       
       // Resize the frame's width to actual
       CGRect fr = lbl.frame;
       fr.size.width = [[detail valueForKey:@"width"] floatValue];
       //fr.origin.x = [[detail valueForKey:@"x"] floatValue];
       //fr.origin.y = [[detail valueForKey:@"y"] floatValue];
       lbl.frame = fr;
    }
}



/*
 * Here We Set Flyer Backgound Image
 */
-(void)setTemplate :(NSString *)imgPath{
    
    [self removeGestureRecognizer:flyerTapGesture];
    flyerTapGesture = nil;
   
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    currentpath = [currentpath stringByAppendingString:[NSString stringWithFormat:@"/%@",imgPath]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentpath isDirectory:NULL] ) {
        

        UIImage *img = [[UIImage alloc] initWithContentsOfFile:currentpath];
        self.image = img;
        [self setContentMode:UIViewContentModeScaleToFill];

        
    }
    
    

}


/*
 * Here we set Flyer Border Color
 */
-(void)setTemplateBorder :(NSMutableDictionary *)layDic {
    
    UIColor *borderColor;
    if ([[layDic valueForKey:@"bordercolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        
        if ([layDic valueForKey:@"bordercolorWhite"] != nil) {
            NSArray *rgbBorder = [[layDic valueForKey:@"bordercolorWhite"] componentsSeparatedByString:@","];
            
            borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
            
        }
        
    }else{
        
        NSArray *rgbBorder = [[layDic valueForKey:@"bordercolor"] componentsSeparatedByString:@","];
        
        borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
    }


    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 3.0;
}


/*
 *Here we Remove Flyer Border
 */
-(void)removeFlyerBorder{

    UIColor *borderColor = [UIColor clearColor];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 0;
}


#pragma mark - Show layer as editable.

/**
 * Visually show a layer as being edited
 */
- (void)layerIsBeingEdited:(NSString *)uid {
    UIView *view = [layers objectForKey:uid];
    
    // Show the layer as being edited.
    if ( view != nil ) {
        CALayer * l = view.layer;
        [l setMasksToBounds:YES];
        [l setBorderWidth:0.5];
        [l setBorderColor:[[UIColor grayColor] CGColor]];
    }
}

/**
 * Layer stopped editing.
 */
- (void)layerStoppedEditing:(NSString *)uid {
    UIView *view = [layers objectForKey:uid];
    
    // Show the layer as being edited.
    if ( view != nil ) {
        CALayer * l = view.layer;
        [l setBorderWidth:0.0];
        [l setBorderColor:[[UIColor clearColor] CGColor]];
    }
}

#pragma mark - Drag & Drop Functionality

/**
 * This method does drag and drop functionality on the layer.
 */
- (void)layerMoved:(UIPanGestureRecognizer *)recognizer {
    
    /*CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self];
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        _firstX = recognizer.view.center.x;
        _firstY = recognizer.view.center.y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [recognizer.view setCenter:translatedPoint];
    [self showOverlayWithFrame:recognizer.view.frame :recognizer.view];*/
    
    
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    // Get the key for this view.
    NSArray *keys = [layers allKeysForObject:recognizer.view];
    
    // Let the delegate know that we changed frame.
    for ( int i = 0; i < keys.count; i++ ) {
        NSString *key = [keys objectAtIndex:i];
        
        CGRect fr = recognizer.view.frame;
        
        // If this is a UILable, the size may have changed due to alignment issues.
        // so we send the default size.
        if ( [recognizer.view.class isSubclassOfClass:[CustomLabel class]] ) {
            fr.size = [(CustomLabel *)recognizer.view originalSize];
        }
        
        [self.delegate frameChangedForLayer:key frame:fr];
        
        // See if this view is at the front
        if ( [self.subviews lastObject] != recognizer.view ) {
            [self bringSubviewToFront:recognizer.view];
            
            // When we bring a view to front, we need to change its key
            NSString *newKey = [Flyer getUniqueId];
            
            // Update the layer dictionary with new key
            id l = [layers objectForKey:key];
            [layers removeObjectForKey:key];
            [layers setObject:l forKey:newKey];
            
            [self.delegate bringLayerToFront:key new:newKey];
        }
    }
}

#pragma mark - Private Methods

-(void)showOverlayWithFrame:(CGRect)frame :(UIView*)view{
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + view.frame.origin.x, frame.origin.y + view.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

#pragma mark - Resize functionality

/**
 * Resize view when pinched.
 */
- (void)layerResized:(UIGestureRecognizer *)sender {
    
    
    /*if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = sender.view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [sender.view setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self showOverlayWithFrame:sender.view.frame :sender.view];*/
    
    
    static CGRect initialBounds;
    
    UIView *_view = sender.view;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = _view.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    _view.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    //Here we update frame of layer in Dictionary
    // Get the key for this view.
    NSArray *keys = [layers allKeysForObject:_view];
    
    // Let the delegate know that we changed frame.
    for ( int i = 0; i < keys.count; i++ ) {
        NSString *key = [keys objectAtIndex:i];
        [self.delegate frameChangedForLayer:key frame:_view.frame];
    }

    return;
}

#pragma mark - Tap to edit functionality

/**
 * Edit view when tapped.
 */
- (void)editLayer:(UIGestureRecognizer *)sender {
    UIView *_view = sender.view;
    
    // Here we send the first matching layer in Dictionary
    // in to edit mode.
    NSArray *keys = [layers allKeysForObject:_view];
    
    // Let the delegate know that this layer needs to go in to edit mode.
    if ( keys.count > 0 ) {
        NSString *key = [keys objectAtIndex:0];
        [self.delegate sendLayerToEditMode:key];
    }else {
        [self.delegate toggleImageViewInteraction];
       
    }
}
                                                           
/**
 * Rotate view on rotate Gesture.
 */
-(void) handleRotateGesture:(UIGestureRecognizer *) sender  :(NSString *)uid{
    
    UIView *_view = sender.view;
    
    
    
    CGFloat currentAngle = [self.delegate previuosrotationAngle :uid :];//Get rotation from current layer
    
    CGFloat rotation = [(UIRotationGestureRecognizer *) sender rotation];
    //rotation += currentAngle
    
    NSArray *keys = [layers allKeysForObject:_view];
    // Let the delegate know that we changed frame.
    for ( int i = 0; i < keys.count; i++ ) {
        NSString *key = [keys objectAtIndex:i];
        [self.delegate rotationAngleChangedForLayer:key rotationAngle:rotation];
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    //+ netRotation);
    //CGAffineTransform CGAffineTransformConcat(CGAffineTransform previuosTransform,CGAffineTransform transform);
    //selectedView.transform = CGAffineTransformConcat(selectedView.transform, viewFlipTrans);
    CGAffineTransform newTransform = CGAffineTransformConcat( previuosTransform, transform);
    sender.view.transform = transform;//CGAffineTransformConcat( previuosTransform, transform);
    if (sender.state == UIGestureRecognizerStateEnded) {
          rotation += rotation;
    }
    previuosTransform = transform;
}
@end
