//
//  FlyerImageView.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "FlyerImageView.h"

@implementation FlyerImageView

@synthesize layers,lbl,img;


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
    

    //Dummy Label
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.lineBreakMode = UILineBreakModeClip;
    lbl.numberOfLines = 80;

    img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    

}

/*
 * Here we create or update actual layer
 */
-(void)renderLayer :(NSString *)uid LayerDictionary:(NSMutableDictionary *)layDic{

    //For Testing

    
    //Check Layer Exist in Master Layers
    if ([layers objectForKey:uid] == nil) {
    
        [layers setValue:layDic forKey:uid];
        [self addLabel:layDic ];
    
    } else {
        
        [self addLabel:layDic ];// 4 Test
        
        //[self updateLabel:layDic ];
    
    }

    
}



/*
 *Here we Add New Label and set Properties
 */
-(void)addLabel:(NSMutableDictionary *)detail{
    
    
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
    [self addSubview:lbl];


}


/*
 *Here we Update Properties of Label
 */
-(void)updateLabel:(NSMutableDictionary *)detail{

    lbl = [[UILabel alloc] init];
    [lbl setText:[detail valueForKey:@"text"]];
    
}



@end
