//
//  FlyerImageView.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "FlyerImageView.h"

@implementation FlyerImageView

@synthesize layers,lble,img;


-(id)init{
   
    self = [super init];
     return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //Set Master Layers
    layers = [[NSMutableDictionary alloc] init];
    
    //Set Template Here
    
}

/*
 * Here we create or update actual layer
 */
-(void)renderLayer :(NSString *)uid LayerDictionary:(NSMutableDictionary *)layDic{


    // Checking for Label or ImageView
    if ([layDic objectForKey:@"image"] == nil) {
        
        //Check Layer Exist in Master Layers
        if ([layers objectForKey:uid] == nil) {
            
            lble = [[UILabel alloc] init];
            lble.backgroundColor = [UIColor clearColor];
            lble.textAlignment = UITextAlignmentCenter;
            lble.adjustsFontSizeToFitWidth = YES;
            lble.lineBreakMode = UILineBreakModeClip;
            lble.numberOfLines = 80;
            [self configureLabel:lble LabelDictionary:layDic ];
            [self addSubview:lble];
            [layers setValue:lble forKey:uid];
            
            
        } else {
            
            lble = [layers objectForKey:uid];
            [self configureLabel:lble LabelDictionary:layDic ];
            [layers setValue:lble forKey:uid];

            
        }


    } else {
    
      img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    
    
}



/*
 *Here we set Properties of uiLabel
 */
-(void)configureLabel :(UILabel *)lbl LabelDictionary:(NSMutableDictionary *)detail{
    
    
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
            UIColor *clr = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
            
            lbl.layer.borderColor = clr.CGColor;
            
        }
    }else{
        
        NSArray *rgbBorder = [[detail valueForKey:@"textbordercolor"] componentsSeparatedByString:@","];
        
        UIColor *clr = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
        lbl.layer.borderColor = clr.CGColor;
    }
    lbl.layer.borderWidth = 2;
}

@end
