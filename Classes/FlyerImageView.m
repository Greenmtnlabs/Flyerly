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
    layers = [[NSMutableDictionary alloc] init];
    return self;
}

/*
 * Here we update actual position of layer
 */
-(void)renderLayer :(NSString *)uid LayerDictionary:(NSMutableDictionary *)layDic{

    //For Testing
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [lbl setText:@"Zohaib"];
    [super addSubview:lbl];
    
    //Check Layer Exist in Master Layers
    if ([layers objectForKey:uid] == nil) {
    
        [layers setValue:layDic forKey:uid];
        [self addLabel:layDic ];
    
    } else {
        
        [self updateLabel:layDic ];
    
    }

    
}



/*
 *Here we Add New Label and set Properties
 */
-(void)addLabel:(NSMutableDictionary *)detail{
    lbl = [[UILabel alloc] init];
    [lbl setText:[detail valueForKey:@"text"]];
    
    lbl.font = [UIFont fontWithName:[detail valueForKey:@"fontname"] size:[[detail valueForKey:@"fontsize"] floatValue]];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.lineBreakMode = UILineBreakModeClip;
    
    lbl.numberOfLines = 80;
    
    if ([[detail valueForKey:@"textcolor"] isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
        if ([detail valueForKey:@"textWhitecolor"]  != nil) {
            NSArray *rgb = [[detail valueForKey:@"textWhitecolor"]  componentsSeparatedByString:@","];
            lbl.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
        }
    }else{
        NSArray *rgb = [[detail valueForKey:@"textcolor"] componentsSeparatedByString:@","];
        
        lbl.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];
        
    }
    
    
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
