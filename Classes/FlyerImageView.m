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
@synthesize layers,flyerTapGesture,zoomedIn;

//Flag for drawing layer
@synthesize addUiImgForDrawingLayer,heightIsSelected,widthIsSelected;

CGAffineTransform previuosTransform;
NSString *abc;

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

            lble.textAlignment = NSTextAlignmentCenter;//    UITextAlignmentCenter;
            //}
            lble.adjustsFontSizeToFitWidth = YES;
            lble.lineBreakMode = NSLineBreakByWordWrapping;
            lble.numberOfLines = 80;
            [self configureLabel:lble labelDictionary:layDic ];
            [self applyTransformOnLabel:lble CustomLableDictionary:layDic];
            [self addSubview:lble];
            [layers setValue:lble forKey:uid];
            
            view = lble;
        } else {

            if ([lastControl isKindOfClass:[CustomLabel class]]) {
                
                //here we Update Label
                CustomLabel *lble = [layers objectForKey:uid];
                //[self configureLabel:lble labelDictionary:layDic ];
                [self applyTransformOnLabel:lble CustomLableDictionary:layDic];
                [layers setValue:lble forKey:uid];
            
            } else {
            
                //here we Update ImageView
                UIImageView *img = [layers objectForKey:uid];
                [self configureImageView:img ImageViewDictionary:layDic];
                [layers setValue:img forKey:uid];
            }
        }
    }
    else if ([layDic objectForKey:@"type"] != nil && [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_DRAWING]) {
        
        if( self.addUiImgForDrawingLayer ){
            //keep in mind call this code for drawing layer only once(render flyer time, add drawing layer[not for edit/reRenderings layers])
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DRAWING_LAYER_W, DRAWING_LAYER_H)];
            
            [self configureImageView:img ImageViewDictionary:layDic];
            [self addSubview:img];
            [layers setValue:img forKey:uid];
            
            view = img;
        }
    }
    else{
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
            [self applyTransform:img ImageViewDictionary:layDic];
            [self addSubview:img];
            [layers setValue:img forKey:uid];
            
            view = img;
        } else {
        
            UIImageView *img = [layers objectForKey:uid];
            [self applyTransform:img ImageViewDictionary:layDic];
            [layers setValue:img forKey:uid];
        
        }
    }
    
    if ([layDic objectForKey:@"type"] != nil && [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_DRAWING]) {
        //we hooked the events(Gesture) of drawing in createFlyerController.h in function: drawingLayerMoved
        if( self.addUiImgForDrawingLayer ){
        }
    }
    // Do the generic stuff that needs to happen for all views. For now,
    // we add support for drag.
    else if ( view != nil ) {
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
        
        //SEL handleRotateGestureSelector = @selector(handleRotateGesture:uid:);
        
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
        abc = uid;
        //[abc isEqualToString:uid];
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
 *Here we set Transformation Properties of UIImageView
 */

- (void) applyTransform:(UIImageView *)imgView ImageViewDictionary:(NSMutableDictionary *)detail {
    
    if ( ([detail objectForKey:@"a"] != nil) && ([detail objectForKey:@"b"] != nil) && ([detail objectForKey:@"c"] != nil) && ([detail objectForKey:@"d"] != nil) && ([detail objectForKey:@"tx"] != nil ) && ([detail objectForKey:@"ty"] != nil) ) {
        
        CGAffineTransform ttransform = CGAffineTransformMake([[detail valueForKey:@"a"] floatValue], [[detail valueForKey:@"b"] floatValue], [[detail valueForKey:@"c"] floatValue], [[detail valueForKey:@"d"] floatValue], [[detail valueForKey:@"tx"] floatValue], [[detail valueForKey:@"ty"] floatValue]);
        
        imgView.transform = ttransform;
    }
    
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

- (void) applyTransformOnLabel:(CustomLabel *)lbl CustomLableDictionary:(NSMutableDictionary *)detail {

    if ( ([detail objectForKey:@"a"] != nil) && ([detail objectForKey:@"b"] != nil) && ([detail objectForKey:@"c"] != nil) && ([detail objectForKey:@"d"] != nil) && ([detail objectForKey:@"tx"] != nil ) && ([detail objectForKey:@"ty"] != nil) ) {
        
        CGAffineTransform ttransform = CGAffineTransformMake([[detail valueForKey:@"a"] floatValue], [[detail valueForKey:@"b"] floatValue], [[detail valueForKey:@"c"] floatValue], [[detail valueForKey:@"d"] floatValue], [[detail valueForKey:@"tx"] floatValue], [[detail valueForKey:@"ty"] floatValue]);
        
        lbl.transform = ttransform;
    }
}

/*
 *Here we set color Properties of uiLabel
 */
-(void)configureLabelColor :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lbl = [layers objectForKey:uid];
    
    if ([[detail valueForKey:@"textcolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        if ([detail valueForKey:@"textWhitecolor"]  != nil) {
            NSArray *rgb = [[detail valueForKey:@"textWhitecolor"]  componentsSeparatedByString:@","];
            lbl.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
        }
    }else{
        NSArray *rgb = [[detail valueForKey:@"textcolor"] componentsSeparatedByString:@","];
        
        lbl.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];
        
    }
}


/*
 *Here we set size Properties of uiLabel
 */
-(void)configureLabelSize :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lbl = [layers objectForKey:uid];
    
    //SetFrame
    [lbl setFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];
    
    // Remember originalsize
    lbl.originalSize = lbl.frame.size;
    
    //set Label Text
    [lbl setText:[detail valueForKey:@"text"]];
    
    //set Label Font
    lbl.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
}


/*
 *Here we set font of uiLabel
 */
-(void)configureLabelFont :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lble = [layers objectForKey:uid];
    
    //set Label Font
    lble.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
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
        lbl.textAlignment = NSTextAlignmentCenter;
        [lbl setNumberOfLines:0];
        [lbl sizeToFit];
        
        CGRect fr = lbl.frame;
        fr.size.width = 150;
        lbl.frame = fr;
        
    } else{
       lbl.textAlignment = NSTextAlignmentCenter;//UITextAlignmentLeft;//
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
    
    static CGAffineTransform currentTransform;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        currentTransform = recognizer.view.transform;
        recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self];
    
        // Scale
        CGAffineTransform tr =
        CGAffineTransformConcat(
                                currentTransform,
                                CGAffineTransformMakeTranslation ( translatedPoint.x,translatedPoint.y ));
        
        [recognizer.view setTransform:tr];

        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGAffineTransform newTransForm = recognizer.view.transform;
        // Get all layer keys for this flyer
        NSArray *keys = [layers allKeysForObject:recognizer.view];
        // Find key for rotated layer
        for ( int i = 0; i < keys.count; i++ ) {
            NSString *key = [keys objectAtIndex:i];
            
            // Save rotation angle for layer
            [self.delegate layerTransformedforKey:key :&newTransForm];
            
            //[self.delegate frameChangedForLayer:key frame:recognizer.view.frame];

        }
    }
    
}

#pragma mark - Private Methods

-(void)showOverlayWithFrame:(CGRect)frame :(UIView*)view{

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
- (void)layerResized:(UIGestureRecognizer *)recognizer {
    
    static CGAffineTransform currentTransform;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        currentTransform = recognizer.view.transform;
        recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat scale = [(UIPinchGestureRecognizer*)recognizer scale];
    
       
        // Scale
        CGAffineTransform tr;
        if ( heightIsSelected ) {
        
            tr =
            CGAffineTransformConcat(
                                    currentTransform,
                                    CGAffineTransformMakeScale ( 1, scale ));
        }else if ( widthIsSelected ){
            tr =
            CGAffineTransformConcat(
                                    currentTransform,
                                    CGAffineTransformMakeScale ( scale, 1 ));
        } else if ( widthIsSelected == NO && heightIsSelected == NO ) {
            
            tr =
            CGAffineTransformConcat(
                                    currentTransform,
                                    CGAffineTransformMakeScale ( scale, scale ));
        }
        
        
        [recognizer.view setTransform:tr];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
     
        CGAffineTransform newTransForm = recognizer.view.transform;
        // Get all layer keys for this flyer
        NSArray *keys = [layers allKeysForObject:recognizer.view];
        // Find key for rotated layer
        for ( int i = 0; i < keys.count; i++ ) {
            NSString *key = [keys objectAtIndex:i];
            
            // Save rotation angle for layer
            [self.delegate layerTransformedforKey:key :&newTransForm];
        
        }

    }
}

#pragma mark - Tap to edit functionality

/**
 * Edit view when tapped.
 */
- (void)editLayer:(UIGestureRecognizer *)sender {
    if( !(self.zoomedIn) ){
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
}

/**
 * Rotate view on rotate Gesture.
 */
-(void)handleRotateGesture:(UIRotationGestureRecognizer *)recognizer{
    
    static CGAffineTransform origTr;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        origTr = recognizer.view.transform;
        recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Angle of rotation
        CGFloat rotation = [(UIRotationGestureRecognizer *) recognizer rotation];
        
        // Scale
        CGAffineTransform tr =
        CGAffineTransformConcat(CGAffineTransformMakeRotation(rotation),
                                origTr);
        
        [recognizer.view setTransform:tr];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Rotation has ended we need to save the angle in layer information
        
        CGAffineTransform newTransForm = recognizer.view.transform;
        // Get all layer keys for this flyer
        NSArray *keys = [layers allKeysForObject:recognizer.view];
        // Find key for rotated layer
        for ( int i = 0; i < keys.count; i++ ) {
            NSString *key = [keys objectAtIndex:i];
            
            // Save rotation angle for layer
            [self.delegate layerTransformedforKey:key :&newTransForm];
            
        }
    }
    
}

@end
