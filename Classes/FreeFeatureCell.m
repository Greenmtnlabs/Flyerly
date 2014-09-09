//
//  FreeFeaturesTableViewCell.m
//  Flyr
//
//  Created by RIKSOF Developer on 5/21/14.
//
//

#import "FreeFeatureCell.h"

@implementation FreeFeatureCell

@synthesize featureName,featureDesc;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellValueswithProductTitle :(NSString *)title ProductDescription: (NSString *)description{
    
    featureName.text = title;
    featureDesc.text = description;
}

-(void)setCellValuesColourWhite {
    
    [featureDesc setTextColor:[UIColor whiteColor]];
}

-(void)setCellValuesSize {
    
    CGRect featureNameFrame = CGRectMake(0, 0, 0, 0);
    featureName.frame = featureNameFrame;
    CGRect featureDescFrame = CGRectMake(0,0,136,66);
    featureDesc.frame = featureDescFrame;
    [featureDesc setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
}
@end
