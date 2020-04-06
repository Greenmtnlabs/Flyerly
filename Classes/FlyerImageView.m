 //
//  FlyerImageView.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "FlyerImageView.h"
#import "Flyer.h"
#import "ImageLayer.h"

@implementation FlyerImageView
@synthesize layers,flyerTapGesture,zoomedIn;

//Flag for drawing layer
@synthesize addUiImgForDrawingLayer,heightIsSelected,widthIsSelected;

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
        
        if( uid != nil ){
            [layers removeObjectForKey:uid];
        }
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
    
    
    // Checking for Label(text) or ImageView
    if ([layDic objectForKey:@"image"] == nil) {
        
        id lastControl = [layers objectForKey:uid];
        
        // If we have switched from an image to a text view, then we need to make a new label.
        if ( lastControl != nil && [layDic objectForKey:@"text"] != nil &&
            ![lastControl isKindOfClass:[CustomLabel class]] ) {
            [lastControl removeFromSuperview];
            lastControl = nil;
        }
        
        //Check Layer Exist in Master Layers
        if ( lastControl == nil) { //this work when we created new one
            //----
            CustomLabel *lble = [[CustomLabel alloc] init];
            lble.tag = layers.count;
            lble.backgroundColor = [UIColor clearColor];
            lble.textAlignment = NSTextAlignmentCenter;
            lble.adjustsFontSizeToFitWidth = YES;
            lble.lineBreakMode = NSLineBreakByWordWrapping;
            lble.numberOfLines = 80;
            
            //Apply view related tasks
            [self configureLabel:lble labelDictionary:layDic ];
            [self applyTransformOnLabel:lble CustomLableDictionary:layDic];
            
            //Add into view
            [self addSubview:lble];
            
            [layers setValue:lble forKey:uid];
            
            view = lble;
            
            //----
        }
        else { //this else works when we try to edit old one

            if ([lastControl isKindOfClass:[CustomLabel class]]) {
                
                //here we Update Label
                CustomLabel *lble = [layers objectForKey:uid];
                
                //[self configureLabel:lble labelDictionary:layDic ];
                
                if( [[layDic valueForKey:@"type"] isEqualToString:FLYER_LAYER_CLIP_ART] ){
                    NSLog(@"its clipart");
                    [self configureLabelFont:uid labelDictionary:layDic];
                    [self applyTransformOnLabel:lble CustomLableDictionary:layDic];
                }
                else{
                    [self applyTransformOnLabel:lble CustomLableDictionary:layDic];
                }
                
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
            ImageLayer *img = [[ImageLayer alloc]initWithFrame:CGRectMake(10,10, 90, 70)];

            [self configureImageView:img ImageViewDictionary:layDic];
            [self applyTransform:img ImageViewDictionary:layDic];
            [self addSubview:img];
            [layers setValue:img forKey:uid];
            
            view = img;
        } else {
        
            ImageLayer *img = [layers objectForKey:uid];
            [self applyTransform:img ImageViewDictionary:layDic];
            [layers setValue:img forKey:uid];
        
        }
    }
    
    BOOL hookGuestures = YES;
    //Dont Apply Gestures[move/resize...etc]
    if ([layDic objectForKey:@"type"] != nil) {
        if( [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_DRAWING] ){
            hookGuestures = NO;
            //we hooked the events(Gesture) of drawing in createFlyerController.h in function: drawingLayerMoved
            if( self.addUiImgForDrawingLayer ){
            }
        } else if( [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_GIPHY_LOGO] ){
            hookGuestures = NO;
        }
    }
    
    
    //Apply Gestures[move/resize...etc]
    // Do the generic stuff that needs to happen for all views. For now,
    // we add support for drag.
    if ( hookGuestures && view != nil ) {
        view.userInteractionEnabled = YES;

        // Gesture for moving layers
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(layerMoved:)];
        [view addGestureRecognizer:panGesture];
        
        BOOL isClipArtLayer = ([layDic objectForKey:@"type"] != nil && [[layDic objectForKey:@"type"] isEqual:FLYER_LAYER_CLIP_ART]);
        
        // We are only going to allow pinch gesture on non text/clipart layers
        if ( [layDic valueForKey:@"image"] || isClipArtLayer ) {
            // Gesture for resizing layers
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(layerResized:)];
            [view addGestureRecognizer:pinchGesture];
        }
        
        // PinchGesture for editing layers
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editLayer:)];
        [view addGestureRecognizer:tapGesture];
        
        //SEL handleRotateGestureSelector = @selector(handleRotateGesture:uid:);
        
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
        
        //[abc isEqualToString:uid];
        //[rotationRecognizer setDelegate:self];
        [view addGestureRecognizer:rotationRecognizer];        
    }
    
}

-(void)configureImageViewSize :(NSString *)uid {


    UIImageView *imgView = [layers objectForKey:uid];
    
    static CGAffineTransform currentTransform;

    currentTransform = imgView.transform;
    //imgView.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        
    CGFloat scale  = 2.0;//= [(UIPinchGestureRecognizer*)imgView scale];
    
    
    // Scale
    CGAffineTransform tr;
    tr =
    CGAffineTransformConcat(
                            currentTransform,
                            CGAffineTransformMakeScale ( scale, scale ));
    
    [imgView setTransform:tr];
    
        
    CGAffineTransform newTransForm = imgView.transform;
    // Get all layer keys for this flyer
    NSArray *keys = [layers allKeysForObject:imgView];
    // Find key for rotated layer
    for ( int i = 0; i < keys.count; i++ ) {
        NSString *key = [keys objectAtIndex:i];
        
        // Save rotation angle for layer
        [self.delegate layerTransformedforKey:key :&newTransForm];
        
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

    if ( [self hasTransformation:&detail] ) {
        
        CGAffineTransform ttransform = CGAffineTransformMake([[detail valueForKey:@"a"] floatValue], [[detail valueForKey:@"b"] floatValue], [[detail valueForKey:@"c"] floatValue], [[detail valueForKey:@"d"] floatValue], [[detail valueForKey:@"tx"] floatValue], [[detail valueForKey:@"ty"] floatValue]);
        
        
        lbl.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        lbl.transform = ttransform;
    }
}
-(BOOL)hasTransformation:(NSMutableDictionary **)detail {
    return ( ([*detail objectForKey:@"a"] != nil) && ([*detail objectForKey:@"b"] != nil) && ([*detail objectForKey:@"c"] != nil) && ([*detail objectForKey:@"d"] != nil) && ([*detail objectForKey:@"tx"] != nil ) && ([*detail objectForKey:@"ty"] != nil) ) ? YES : NO;
}

/*
 *Here we set text of Clipart Icon
 */
-(void)configureClipartFont :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lble = [[CustomLabel alloc] init];
    [layers setValue:lble forKey:uid];
    
    //set Label Text
    [lble setText:[detail valueForKey:@"text"]];
    
    //set Label Font
    lble.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
}

/*
 *Here we set dimensions of Clipart Icon
 */
-(void)configureClipartDimensions :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lbl = [layers objectForKey:uid];
    
    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl setNumberOfLines:0];
    [lbl sizeToFit];

    CGRect fr = lbl.frame;
    fr.size.width = 150;
    lbl.frame = fr;
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
    
    //set Label Text
    [lbl setText:[detail valueForKey:@"text"]];
    
    //set Label Font
    lbl.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
    
    // Make sure we are vertically aligned to the top and centerally aligned.
    if( [[detail valueForKey:@"type"] isEqualToString:FLYER_LAYER_CLIP_ART] ){
     
        // Because emoticons are always sized squarely, we are just considering width here, assuming height is the same
        CGFloat currentSize = [lbl newSize].width; //lbl.frame.size.width;
        
        CGFloat newSize = [[detail valueForKey:@"fontsize"] floatValue];
        
        NSLog(@"newSize:%f, currentSize:%f",newSize/3,currentSize/3);
        
        CGFloat scale = newSize / currentSize;
        
        CGAffineTransform currentTransform = lbl.transform;
        
        lbl.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        
        CGAffineTransform tr =
        CGAffineTransformConcat(
                                CGAffineTransformMakeScale(scale, scale),
                                currentTransform);
        
        lbl.transform = tr;

         // Keep existing layer's transform
         CGAffineTransform tempTransform = lbl.transform;
         
         // Now apply the identity transform
         lbl.transform = CGAffineTransformIdentity;
         
         lbl.textAlignment = NSTextAlignmentCenter;
         [lbl setNumberOfLines:0];
         
         CGRect fr = lbl.frame;
         fr.size.width = 150;
         lbl.frame = fr;
         
         [lbl sizeToFit];
         
         // Now apply the previous transform again
         lbl.transform = tempTransform;

        //update dictionary
        [self.delegate layerTransformedforKey:uid :&tempTransform];
        
        /*
            currentSize = [lbl newSize].width; //lbl.frame.size.width;
            newSize = [[detail valueForKey:@"fontsize"] floatValue];
            NSLog(@"b-- newSize:%f, currentSize:%f", newSize/3, currentSize/3);
        */
    }
    else{ //Text
        
        // Keep existing layer's transform
        CGAffineTransform tempTransform = lbl.transform;
        
        // Now apply the identity transform
        lbl.transform = CGAffineTransformIdentity;
        
        lbl.textAlignment = NSTextAlignmentCenter;//UITextAlignmentLeft;//
        [lbl setNumberOfLines:0];
        
        // Resize the frame's width to actual
        CGRect fr = lbl.frame;
        fr.size.width = [[detail valueForKey:@"width"] floatValue];
        //fr.origin.x = [[detail valueForKey:@"x"] floatValue];
        //fr.origin.y = [[detail valueForKey:@"y"] floatValue];
        lbl.frame = fr;
        
        [lbl sizeToFit];
        
        lbl.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
        // Now apply the previous transform again
        lbl.transform = tempTransform;
    }
}

/*
 *Here we set font of UILabel
 */
-(void)configureLabelFont :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lble = [layers objectForKey:uid];
    
    //set Label Font
    lble.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
    
    [lble setText:[detail valueForKey:@"text"]];
}

/*
 *Here we set border of UILabel
 */
-(void)configureLabelBorder :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail {
    
    CustomLabel *lbl = [layers objectForKey:uid];
    
    //set Label Text
    [lbl setText:[detail valueForKey:@"text"]];
    
    
    if ([[detail valueForKey:@"textbordercolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        
        if ([detail valueForKey:@"textborderWhite"] != nil) {
            NSArray *rgbBorder = [[detail valueForKey:@"textborderWhite"] componentsSeparatedByString:@","];
            
            lbl.borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
            
        }
    }else{
        
        NSArray *rgbBorder = [[detail valueForKey:@"textbordercolor"] componentsSeparatedByString:@","];
        
        lbl.borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
    }
    
    // This was required as border was not showing up immediately on iOS 7.0. it was ok on 7.1
    [lbl setNeedsDisplay];
    
    lbl.lineWidth = 2;
    
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
        
        
        CGRect fr = lbl.frame;
        fr.size.width = 150;
        lbl.frame = fr;
        [lbl sizeToFit];
        
    } else{
       //lbl.textAlignment = NSTextAlignmentCenter;//UITextAlignmentLeft;//
       [lbl setNumberOfLines:80];
       
       
       // Resize the frame's width to actual
       CGRect fr = lbl.frame;
       fr.size.width = [[detail valueForKey:@"width"] floatValue];
        /*if ( IS_IPHONE_5 || IS_IPHONE_4){
            fr.origin.x = 80;
        }else if ( IS_IPHONE_6 ){
            fr.origin.x = 155;
        }*/
       
       //fr.origin.y = [[detail valueForKey:@"y"] floatValue];
       lbl.frame = fr;
    
        [lbl sizeToFit];
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
    
    UIColor *borderColor =     borderColor = [UIColor clearColor];
    [self deleteLayer:@"TemplateBorder"];
    NSString *flyerTyp = [layDic objectForKey:@"FlyerType"];
    //when type is not video
    if ( !(flyerTyp != nil && [flyerTyp isEqualToString:@"video"]) ) {

        if ([[layDic valueForKey:@"bordercolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
            if ([layDic valueForKey:@"bordercolorWhite"] != nil) {

                NSArray *rgbBorder = [[layDic valueForKey:@"bordercolorWhite"] componentsSeparatedByString:@","];
                borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
            }
        }else {
            [self deleteLayer:@"TemplateBorder"];
            borderColor = [UIColor clearColor];
            
            //When picture flyer border
            if ([[layDic valueForKey:@"bordercolor"] rangeOfString:@".png"].location != NSNotFound) {
                // Here We Write Code for Image
                ImageLayer *img = [[ImageLayer alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                img.image = [UIImage imageNamed:[layDic valueForKey:@"bordercolor"]];
                [self addSubview:img];
                [layers setValue:img forKey:@"TemplateBorder"];
            }
            //Colored flyer border
            else{
                NSArray *rgbBorder = [[layDic valueForKey:@"bordercolor"] componentsSeparatedByString:@","];
                
                borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
            }
        }
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
        [l setBorderWidth:1.0];
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
    if( [self.delegate wmCanPerformAction:[[layers allKeysForObject:recognizer.view] objectAtIndex:0]] ) {

        static CGAffineTransform currentTransform;
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            currentTransform = recognizer.view.transform;
            recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
            
            [self bringLayerToFrontFiv:recognizer.view bypassIsFront:YES updateSv:YES];
        }
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self];
        
            // Scale
            CGAffineTransform tr =
            CGAffineTransformConcat(
                                    currentTransform,
                                    CGAffineTransformMakeTranslation ( translatedPoint.x,translatedPoint.y ));
            
            [recognizer.view setTransform:tr];

            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            CGAffineTransform newTransForm = recognizer.view.transform;
            //CGRect newRect = recognizer.view.frame;
            // Get all layer keys for this flyer
            NSArray *keys = [layers allKeysForObject:recognizer.view];
            // Find key for rotated layer
            for ( int i = 0; i < keys.count; i++ ) {
                NSString *key = [keys objectAtIndex:i];
                
                // Save rotation angle for layer
                [self.delegate layerTransformedforKey:key :&newTransForm];
                //[self.delegate setLayerDicXY :key  :newRect];
                
                //[self.delegate frameChangedForLayer:key frame:recognizer.view.frame];
            }

            [self.delegate zoomUpdateScreenshot];
        }
        
        //[self editLayer:recognizer];
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
    
    if( [self.delegate wmCanPerformAction:[[layers allKeysForObject:recognizer.view] objectAtIndex:0]] ) {
        
        static CGAffineTransform currentTransform;
        static CGFloat fontScale = 0.0;
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            currentTransform = recognizer.view.transform;
            recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );

            [self bringLayerToFrontFiv:recognizer.view bypassIsFront:YES updateSv:YES];
        }
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            CGFloat scale = [(UIPinchGestureRecognizer*)recognizer scale];
            fontScale += scale;
           
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
                                        CGAffineTransformMakeScale ( scale, scale ),
                                        currentTransform);
            }
            
            
            [recognizer.view setTransform:tr];
            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
         
            CGAffineTransform newTransForm = recognizer.view.transform;
            // Get all layer keys for this flyer
            NSArray *keys = [layers allKeysForObject:recognizer.view];
            // Find key for rotated layer
            for ( int i = 0; i < keys.count; i++ ) {
                NSString *key = [keys objectAtIndex:i];
                
                // Save rotation angle for layer
                [self.delegate layerTransformedforKey:key :&newTransForm];

                // Inform the delegate/controller that a layer has been resized,
                // and it might want to do something with the contents.
                //[self.delegate layerResizedForKey:key :fontScale];
                    
                    fontScale = 0.0;
            }
            
            [self.delegate zoomUpdateScreenshot];
        }
    }
}


#pragma mark - Tap to edit functionality

/**
 * Edit view when just tapped on layer(in flyerimageView screen)
 */
- (void)editLayer:(UIGestureRecognizer *)sender {
    [self bringLayerToFrontFiv:sender.view bypassIsFront:YES updateSv:YES];
    if( !(self.zoomedIn) ) {
        UIView *_view = sender.view;
        
        // Here we send the first matching layer in Dictionary
        // in to edit mode.
        NSArray *keys = [layers allKeysForObject:_view];
        
        // Let the delegate know that this layer needs to go in to edit mode.
        if ( keys.count > 0 ) { //edit layer's except video layer
            if( [self.delegate wmCanPerformAction:[[layers allKeysForObject:sender.view] objectAtIndex:0]] ) {
                NSString *key = [keys objectAtIndex:0];
                [self.delegate sendLayerToEditMode:key];
            }
        } else { //edit video layer
              [self.delegate toggleImageViewInteraction];
        }
    }//zoomIn
}

/**
 * Rotate view on rotate Gesture.
 */
-(void)handleRotateGesture:(UIRotationGestureRecognizer *)recognizer{
   if( [self.delegate wmCanPerformAction:[[layers allKeysForObject:recognizer.view] objectAtIndex:0]] ) {
       
        static CGAffineTransform origTr;
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            origTr = recognizer.view.transform;
            recognizer.view.layer.anchorPoint = CGPointMake( 0.5, 0.5 );

            [self bringLayerToFrontFiv:recognizer.view bypassIsFront:YES updateSv:YES];
        }
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            // Angle of rotation
            CGFloat rotation = [(UIRotationGestureRecognizer *) recognizer rotation];
            
            // Scale
            CGAffineTransform tr =
            CGAffineTransformConcat(CGAffineTransformMakeRotation(rotation),
                                    origTr);
            
            [recognizer.view setTransform:tr];
            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
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

            [self.delegate zoomUpdateScreenshot];
        }

    }
}

-(void)bringLayerToFrontFiv:(UIView *)view bypassIsFront:(BOOL)bypassIsFront updateSv:(BOOL)updateSv{
    
    // Get the key for this view.
    NSArray *keys = [layers allKeysForObject:view];
    
    // Let the delegate know that we changed frame.
    for ( int i = 0; i < keys.count; i++ ) {
        NSString *key = [keys objectAtIndex:i];
        
        CGRect fr = view.frame;
        
        // If this is a UILable, the size may have changed due to alignment issues.
        // so we send the default size.
        if ( [view.class isSubclassOfClass:[CustomLabel class]] ) {
            fr.size = [(CustomLabel *)view originalSize];
        }
        
        //[self.delegate frameChangedForLayer:key frame:fr];
        
        // See if this view is at the front
        if ( bypassIsFront || [self.subviews lastObject] != view ) {
            [self bringSubviewToFront:view];
            
            // When we bring a view to front, we need to change its key
            NSString *newKey = [Flyer getUniqueId];
            
            // Update the layer dictionary with new key
            id l = [layers objectForKey:key];
            if( key != nil ){
                [layers removeObjectForKey:key];
            }
            [layers setObject:l forKey:newKey];
            
            [self.delegate bringLayerToFrontCf:key new:newKey updateSv:updateSv];
        }
    }
}
@end
