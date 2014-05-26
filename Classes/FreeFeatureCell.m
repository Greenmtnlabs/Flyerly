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
@end
