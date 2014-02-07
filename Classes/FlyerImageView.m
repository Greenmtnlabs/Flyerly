//
//  FlyerImageView.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "FlyerImageView.h"

@implementation FlyerImageView
@synthesize layers;

/**
 * Image initialization.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //Set Master Layers
    layers = [[NSMutableDictionary alloc] init];

    //Set Template Here
    
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
        [self setTemplate:[layDic valueForKey:@"image"]];
        return;
    }
    
    // Checking for Label or ImageView
    if ([layDic objectForKey:@"image"] == nil) {
        
        //Check Layer Exist in Master Layers
        if ([layers objectForKey:uid] == nil) {
            
            CustomLabel *lble = [[CustomLabel alloc] init];
            lble.tag = layers.count;
            lble.backgroundColor = [UIColor clearColor];
            lble.textAlignment = UITextAlignmentCenter;
            lble.adjustsFontSizeToFitWidth = YES;
            lble.lineBreakMode = UILineBreakModeClip;
            lble.numberOfLines = 80;
            [self configureLabel:lble labelDictionary:layDic ];
            [self addSubview:lble];
            [layers setValue:lble forKey:uid];
            
            view = lble;
        } else {
            
            CustomLabel *lble = [layers objectForKey:uid];
            [self configureLabel:lble labelDictionary:layDic ];
            [layers setValue:lble forKey:uid];
        }
    } else {

        // Check Layer Exist in Master Layers
        if ([layers objectForKey:uid] == nil) {
            
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
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(layerMoved:)];
        [view addGestureRecognizer:panGesture];
    }
}


/*
 *Here we set Properties of UIImageView
 */
-(void)configureImageView :(UIImageView *)imgView ImageViewDictionary:(NSMutableDictionary *)detail {
    
    //SetFrame
    [imgView setFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];
    
    //Set Image
    NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:[detail valueForKey:@"image"]];
    UIImage *currentImage = [UIImage imageWithData:imageData];
    [imgView setImage:currentImage];

}

/*
 *Here we set Properties of uiLabel
 */
-(void)configureLabel :(CustomLabel *)lbl labelDictionary:(NSMutableDictionary *)detail {
    
    
    //SetFrame
    [lbl setFrame:CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue])];


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
}



/*
 * Here We Set Flyer Backgound Image
 */
-(void)setTemplate :(NSString *)imgPath{
    
   
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    currentpath = [currentpath stringByAppendingString:[NSString stringWithFormat:@"/%@",imgPath]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:currentpath isDirectory:NULL] ) {
        

        UIImage *img = [[UIImage alloc] initWithContentsOfFile:currentpath];
        self.image = img;
        
    }
    
    

}


/*
 * Here we set Flyer Border Color
 */
-(void)setTemplateBorder :(NSString *)borColor{


}

#pragma mark - Drag & Drop Functionality

/**
 * This method does drag and drop functionality on the layer.
 */
- (void)layerMoved:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

/**
 * Get layer position
 */
- (CGRect)layerFrame:(NSString *)uid {
    CGRect fr = CGRectMake(0, 0, 0, 0);
    
    UIView *view = [layers objectForKey:uid];
    
    // Make sure the view is valid.
    if ( view != nil ) {
        fr = view.frame;
    }
    
    return fr;
}

@end
