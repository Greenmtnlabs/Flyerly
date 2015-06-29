//
//  InAppPurchaseCell.m
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import "InAppPurchaseCell.h"

@implementation InAppPurchaseCell

@synthesize packageName,packagePrice,packageDescription,discount,start;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValueswithProductTitle :(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description{
    
    if ( ![title isEqualToString:@"Complete Bundle"] ){
        //discount.alpha = 0;
        [discount removeFromSuperview];
    }
    
    if ( ![title isEqualToString:@"Monthly Subscription"] ){
        //start.alpha = 0;
        [start removeFromSuperview];
    }

    
    packageName.text = title;
    packagePrice.text = price;
    packageDescription.text = description;
}

@end
